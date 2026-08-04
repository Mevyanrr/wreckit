# lib/backend/services/checker.py
import os
import asyncio
import httpx
from urllib.parse import quote

VIRUSTOTAL_API_KEY = os.getenv("VIRUSTOTAL_API_KEY", "")
GSB_API_KEY = os.getenv("GOOGLE_SAFE_BROWSING_API_KEY", "")
IPQS_API_KEY = os.getenv("IPQS_API_KEY", "")

# -------------------------------------------------------------------------
# 1. VirusTotal v3 API Check
# -------------------------------------------------------------------------
async def check_virustotal(client: httpx.AsyncClient, url: str) -> dict:
    if not VIRUSTOTAL_API_KEY:
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
    
    return {"malicious": 0, "suspicious": 0, "status": "error"}

# -------------------------------------------------------------------------
# 2. Google Safe Browsing v4 API Check
# -------------------------------------------------------------------------
async def check_google_safe_browsing(client: httpx.AsyncClient, url: str) -> dict:
    if not GSB_API_KEY:
        return {"is_flagged": False, "threats": [], "status": "skipped"}

    api_url = f"https://safebrowsing.googleapis.com/v4/threatMatches:find?key={GSB_API_KEY}"
    payload = {
        "client": {"clientId": "qrisk-app", "clientVersion": "1.0.0"},
        "threatInfo": {
            "threatTypes": ["MALWARE", "SOCIAL_ENGINEERING", "UNWANTED_SOFTWARE", "POTENTIALLY_HARMFUL_APPLICATION"],
            "platformTypes": ["ANY_PLATFORM"],
            "threatEntryTypes": ["URL"],
            "threatEntries": [{"url": url}]
        }
    }

    try:
        res = await client.post(api_url, json=payload)
        if res.status_code == 200:
            data = res.json()
            matches = data.get("matches", [])
            threats = [m.get("threatType") for m in matches]
            return {
                "is_flagged": len(matches) > 0,
                "threats": threats,
                "status": "ok"
            }
    except Exception as e:
        print(f"Google Safe Browsing Error: {e}")

    return {"is_flagged": False, "threats": [], "status": "error"}

# -------------------------------------------------------------------------
# 3. IPQualityScore (IPQS) Malicious URL Scanner
# -------------------------------------------------------------------------
async def check_ipqs(client: httpx.AsyncClient, url: str) -> dict:
    if not IPQS_API_KEY:
        return {"risk_score": 0, "unsafe": False, "phishing": False, "malware": False, "status": "skipped"}

    encoded_url = quote(url, safe="")
    api_url = f"https://www.ipqualityscore.com/api/json/url/{IPQS_API_KEY}/{encoded_url}"

    try:
        res = await client.get(api_url)
        if res.status_code == 200:
            data = res.json()
            if data.get("success", False):
                return {
                    "risk_score": data.get("risk_score", 0),
                    "unsafe": data.get("unsafe", False),
                    "phishing": data.get("phishing", False),
                    "malware": data.get("malware", False),
                    "status": "ok"
                }
    except Exception as e:
        print(f"IPQS Error: {e}")

    return {"risk_score": 0, "unsafe": False, "phishing": False, "malware": False, "status": "error"}

# -------------------------------------------------------------------------
# Orchestrator & Scoring Matrix
# -------------------------------------------------------------------------
async def evaluate_url_safety(resolved_url: str, heuristic_score: float = 0.0) -> dict:
    async with httpx.AsyncClient(timeout=8.0) as client:
        # Run all 3 threat intelligence lookups concurrently in parallel
        vt_res, gsb_res, ipqs_res = await asyncio.gather(
            check_virustotal(client, resolved_url),
            check_google_safe_browsing(client, resolved_url),
            check_ipqs(client, resolved_url),
        )

    # Composite Risk Calculation (0 - 100)
    risk_score = 0

    # 1. VirusTotal Weight
    vt_malicious = vt_res.get("malicious", 0)
    if vt_malicious >= 3:
        risk_score += 60
    elif vt_malicious > 0:
        risk_score += 35

    # 2. Google Safe Browsing Weight
    if gsb_res.get("is_flagged", False):
        risk_score += 50

    # 3. IPQS Weight
    ipqs_score = ipqs_res.get("risk_score", 0)
    if ipqs_res.get("phishing") or ipqs_res.get("malware"):
        risk_score += 40
    else:
        risk_score += int(ipqs_score * 0.3)

    # 4. Local Heuristic Score Weight (Nopas's ML engine contribution)
    risk_score += int(heuristic_score * 0.2)

    # Cap max score at 100
    risk_score = min(100, max(0, risk_score))

    # Verdict Matrix
    if risk_score >= 70 or vt_malicious >= 3 or gsb_res.get("is_flagged"):
        verdict = "BAHAYA"
    elif risk_score >= 35 or vt_malicious > 0:
        verdict = "WASPADA"
    else:
        verdict = "AMAN"

    return {
        "scanned_url": resolved_url,
        "resolved_url": resolved_url,
        "risk_score": risk_score,
        "verdict": verdict,
        "details": {
            "virustotal": vt_res,
            "google_safe_browsing": gsb_res,
            "ipqs": ipqs_res,
            "heuristic_score": heuristic_score,
        }
    }