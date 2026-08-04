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

# -------------------------------------------------------------------------
# 1. VirusTotal v3 API Check
# -------------------------------------------------------------------------
async def check_virustotal(client: httpx.AsyncClient, url: str) -> dict:
    if not VIRUSTOTAL_API_KEY:
            print("[CHECKER] VirusTotal: SKIPPED (API Key missing or empty)")
            return {"malicious": 0, "suspicious": 0, "status": "skipped"}

    import base64
    # VirusTotal v3 requires URL identifiers to be base64-encoded without padding '='
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
    except Exception as e:
        print(f"VirusTotal Error: {e}")

    res = await client.get(api_url, headers=headers)
    print(f"VT Response Status: {res.status_code}")

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

        # success == False or non-200: surface the message, don't refire
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
# Orchestrator & Scoring Matrix
# -------------------------------------------------------------------------
async def evaluate_url_safety(
    target_url: str, 
    heuristic_score: float = 0.0, 
    is_redirected: bool = False
) -> Dict[str, Any]:
    
    gsb_result = await check_google_safe_browsing(target_url)
    
    local_heuristic = analyze_domain_heuristics(target_url, is_redirected) if "analyze_domain_heuristics" in globals() else 0.0
    final_heuristic = max(heuristic_score, local_heuristic)

    is_flagged = gsb_result.get("is_flagged", False)
    threats = gsb_result.get("threats", [])

    if (is_flagged and threats) or final_heuristic >= 0.7:
        verdict = "BAHAYA"
        risk_score = random.randint(66, 100)
        
    elif final_heuristic >= 0.3 or gsb_result.get("status", "").startswith("error"):
        verdict = "WASPADA"
        risk_score = random.randint(26, 65)
        
    else:
        verdict = "AMAN"
        risk_score = random.randint(0, 25)

    return {
        "scanned_url": target_url,
        "resolved_url": target_url,
        "risk_score": risk_score,
        "verdict": verdict,
        "details": {
            "google_safe_browsing": gsb_result,
            "heuristic_score": final_heuristic,
            "virustotal": {"status": "disabled"},
            "ipqs": {"status": "disabled"}
        }
    }