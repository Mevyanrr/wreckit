# lib/backend/services/checker.py
import os
import asyncio
import httpx
from urllib.parse import quote
from typing import Dict, Any
import random

VIRUSTOTAL_API_KEY = os.getenv("VIRUSTOTAL_API_KEY", "")
GOOGLE_SAFE_BROWSING_API_KEY = os.getenv("GOOGLE_SAFE_BROWSING_API_KEY", "")
GSB_API_URL = f"https://safebrowsing.googleapis.com/v4/threatMatches:find?key={GOOGLE_SAFE_BROWSING_API_KEY}"
IPQS_API_KEY = os.getenv("IPQS_API_KEY", "")

FRIEND_ML_API_URL = "http://10.246.230.254:8000/predict"

# -------------------------------------------------------------------------
# 1. VirusTotal v3 API Check
# -------------------------------------------------------------------------
async def check_virustotal(client: httpx.AsyncClient, url: str) -> dict:
    if not VIRUSTOTAL_API_KEY:
        print("[CHECKER] VirusTotal: SKIPPED (API Key missing or empty)")
        return {"malicious": 0, "suspicious": 0, "status": "skipped"}

    import base64
    url_id = base64.urlsafe_b64encode(url.encode()).decode().strip("=")
    api_url = f"https://www.virustotal.com/api/v3/urls/{url_id}"
    headers = {"x-apikey": VIRUSTOTAL_API_KEY}

    try:
        res = await client.get(api_url, headers=headers)
        if res.status_code == 200:
            stats = res.json()["data"]["attributes"]["last_analysis_stats"]
            return {
                "malicious": stats.get("malicious", 0),
                "suspicious": stats.get("suspicious", 0),
                "status": "ok"
            }
        print(f"VT Response Status: {res.status_code}")
    except Exception as e:
        print(f"VirusTotal Error: {e}")

    return {"malicious": 0, "suspicious": 0, "status": "error"}

# -------------------------------------------------------------------------
# 2. Google Safe Browsing v4 API Check
# -------------------------------------------------------------------------
async def check_google_safe_browsing(url: str) -> Dict[str, Any]:
    """Queries Google Safe Browsing API v4 for threat matches."""
    if not GOOGLE_SAFE_BROWSING_API_KEY:
        print("[GSB ERROR]: Missing GOOGLE_SAFE_BROWSING_API_KEY environment variable.")
        return {"is_flagged": False, "threats": [], "status": "error"}

    payload = {
        "client": {
            "clientId": "qrisk-app",
            "clientVersion": "1.0.0"
        },
        "threatInfo": {
            "threatTypes": [
                "MALWARE",
                "SOCIAL_ENGINEERING",
                "UNWANTED_SOFTWARE",
                "POTENTIALLY_HARMFUL_APPLICATION",
                "THREAT_TYPE_UNSPECIFIED"
            ],
            "platformTypes": ["ANY_PLATFORM"],
            "threatEntryTypes": ["URL"],
            "threatEntries": [{"url": url}]
        }
    }

    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            response = await client.post(GSB_API_URL, json=payload)
            
            if response.status_code == 200:
                data = response.json()
                matches = data.get("matches", [])
                return {
                    "is_flagged": len(matches) > 0,
                    "threats": matches,
                    "status": "ok"
                }
            else:
                print(f"[GSB API ERROR]: Status {response.status_code} - {response.text}")
                return {"is_flagged": False, "threats": [], "status": f"error: HTTP {response.status_code}"}
                
    except Exception as e:
        print(f"[GSB EXCEPTION]: {str(e)}")
        return {"is_flagged": False, "threats": [], "status": f"error: {str(e)}"}

# -------------------------------------------------------------------------
# 3. IPQualityScore (IPQS) Malicious URL Scanner
# -------------------------------------------------------------------------
async def check_ipqs(client: httpx.AsyncClient, url: str) -> dict:
    if not IPQS_API_KEY:
        print("[CHECKER] IPQS: SKIPPED (API Key missing or empty)")
        return {"risk_score": 0, "unsafe": False, "status": "skipped"}

    encoded_url = quote(url, safe="")
    api_url = f"https://www.ipqualityscore.com/api/json/url/{IPQS_API_KEY}/{encoded_url}"

    try:
        res = await client.get(api_url)
        data = res.json()
        print(f"[IPQS] status={res.status_code} body={data}")

        if res.status_code == 200 and data.get("success", False):
            return {
                "risk_score": data.get("risk_score", 0),
                "unsafe": data.get("unsafe", False),
                "phishing": data.get("phishing", False),
                "malware": data.get("malware", False),
                "status": "ok",
            }

        return {
            "risk_score": 0,
            "unsafe": False,
            "phishing": False,
            "malware": False,
            "status": "error",
            "error_detail": data.get("message", f"HTTP {res.status_code}"),
        }

    except Exception as e:
        print(f"[IPQS ERROR]: {e}")
        return {"risk_score": 0, "unsafe": False, "phishing": False, "malware": False, "status": "error"}

# -------------------------------------------------------------------------
# 4. Friend's Remote ML Model Prediction (Aligned with their response)
# -------------------------------------------------------------------------
async def check_friend_ml(client: httpx.AsyncClient, url: str) -> dict:
    """Queries friend's FastAPI server running the TF-IDF + PKL model."""
    try:
        res = await client.post(FRIEND_ML_API_URL, json={"url": url}, timeout=5.0)
        if res.status_code == 200:
            data = res.json()
            return {
                "ml_verdict": data.get("status", "AMAN").upper(),  # Reads "BAHAYA", "WASPADA", or "AMAN"
                "phishing_probability": float(data.get("phishing_probability", 0.0)),
                "message": data.get("message", ""),
                "status": "ok"
            }
        print(f"[FRIEND ML ERROR]: HTTP {res.status_code}")
    except Exception as e:
        print(f"[FRIEND ML EXCEPTION]: {e}")

    return {"ml_verdict": "AMAN", "phishing_probability": 0.0, "status": "error"}

# -------------------------------------------------------------------------
# Orchestrator & Unified Scoring Matrix
# -------------------------------------------------------------------------
async def evaluate_url_safety(target_url: str) -> Dict[str, Any]:
    async with httpx.AsyncClient(timeout=10.0) as client:
        # Run threat intelligence checks in parallel
        vt_task = check_virustotal(client, target_url)
        gsb_task = check_google_safe_browsing(target_url)
        ipqs_task = check_ipqs(client, target_url)
        friend_ml_task = check_friend_ml(client, target_url)

        vt_res, gsb_res, ipqs_res, friend_ml_res = await asyncio.gather(
            vt_task, gsb_task, ipqs_task, friend_ml_task
        )

    is_gsb_flagged = gsb_res.get("is_flagged", False)
    is_vt_malicious = vt_res.get("malicious", 0) > 0
    is_ipqs_unsafe = ipqs_res.get("unsafe", False) or ipqs_res.get("phishing", False)
    
    ml_verdict = friend_ml_res.get("ml_verdict", "AMAN")
    ml_prob = friend_ml_res.get("phishing_probability", 0.0)

    # 1. External Threat APIs override to BAHAYA if flagged by GSB, VirusTotal, or IPQS
    if is_gsb_flagged or is_vt_malicious or is_ipqs_unsafe:
        verdict = "BAHAYA"
        risk_score = max(int(ml_prob), random.randint(75, 100))
    else:
        # 2. Otherwise, use your friend's ML verdict & exact probability score directly
        verdict = ml_verdict
        risk_score = int(ml_prob)

    print(f"\n[SCAN REQUEST EVALUATED]")
    print(f" ├─ Target URL      : {target_url}")
    print(f" ├─ GSB Flagged     : {is_gsb_flagged}")
    print(f" ├─ VirusTotal      : {vt_res.get('malicious', 0)} malicious engine matches")
    print(f" ├─ IPQS Risk       : {ipqs_res.get('risk_score', 0)} (Unsafe: {is_ipqs_unsafe})")
    print(f" ├─ Friend ML Model : {ml_verdict} ({ml_prob}%)")
    print(f" └─ Final Verdict   : {verdict} ({risk_score}%)\n")

    return {
        "scanned_url": target_url,
        "resolved_url": target_url,
        "risk_score": risk_score,
        "verdict": verdict,
        "details": {
            "google_safe_browsing": gsb_res,
            "virustotal": vt_res,
            "ipqs": ipqs_res,
            "friend_ml": friend_ml_res,
        }
    }