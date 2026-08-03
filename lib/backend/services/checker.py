# services/checker.py
import asyncio
import httpx
import os
import base64
import urllib.parse
from typing import Dict, Any

# 1. Resolve URL Shorteners (bit.ly, s.id, t.co) via HEAD request
async def resolve_final_url(client: httpx.AsyncClient, url: str) -> str:
    try:
        response = await client.head(url, follow_redirects=True, timeout=2.0)
        return str(response.url)
    except Exception:
        return url  # Fallback to initial URL if shortener check fails

# 2. VirusTotal v3 Check (Weight: 40%)
async def check_virustotal(client: httpx.AsyncClient, target_url: str) -> float:
    api_key = os.getenv("VIRUSTOTAL_API_KEY")
    if not api_key:
        return 0.0
    try:
        url_id = base64.urlsafe_b64encode(target_url.encode()).decode().strip("=")
        endpoint = f"https://www.virustotal.com/api/v3/urls/{url_id}"
        headers = {"x-apikey": api_key}
        
        resp = await client.get(endpoint, headers=headers, timeout=2.5)
        if resp.status_code == 200:
            stats = resp.json()["data"]["attributes"]["last_analysis_stats"]
            malicious = stats.get("malicious", 0)
            total = sum(stats.values()) or 1
            return (malicious / total) * 100
    except Exception:
        pass
    return 0.0

# 3. Google Safe Browsing v4 Check (Weight: 35%)
async def check_google_safe_browsing(client: httpx.AsyncClient, target_url: str) -> float:
    api_key = os.getenv("GOOGLE_SAFE_BROWSING_API_KEY")
    if not api_key:
        return 0.0
    try:
        endpoint = f"https://safebrowsing.googleapis.com/v4/threatMatches:find?key={api_key}"
        payload = {
            "client": {"clientId": "qrisk", "clientVersion": "1.0.0"},
            "threatInfo": {
                "threatTypes": ["MALWARE", "SOCIAL_ENGINEERING", "UNWANTED_SOFTWARE"],
                "platformTypes": ["ANY_PLATFORM"],
                "threatEntryTypes": ["URL"],
                "threatEntries": [{"url": target_url}]
            }
        }
        resp = await client.post(endpoint, json=payload, timeout=2.5)
        if resp.status_code == 200 and "matches" in resp.json():
            return 100.0  # Flagged as malicious by Google
    except Exception:
        pass
    return 0.0

# 4. IPQualityScore Check (Weight: 15%)
async def check_ipqualityscore(client: httpx.AsyncClient, target_url: str) -> float:
    api_key = os.getenv("IPQUALITYSCORE_API_KEY")
    if not api_key:
        return 0.0
    try:
        encoded_url = urllib.parse.quote_plus(target_url)
        endpoint = f"https://www.ipqualityscore.com/api/json/url/{api_key}/{encoded_url}"
        resp = await client.get(endpoint, timeout=2.5)
        if resp.status_code == 200:
            return float(resp.json().get("risk_score", 0.0))
    except Exception:
        pass
    return 0.0

# 5. Parallel Aggregator & Composite Score Engine
async def evaluate_url_safety(target_url: str, heuristic_score: float = 0.0) -> Dict[str, Any]:
    async with httpx.AsyncClient() as client:
        # Step A: Unshorten URL first
        final_url = await resolve_final_url(client, target_url)
        
        # Step B: Run VirusTotal, GSB, and IPQS concurrently
        vt_task = check_virustotal(client, final_url)
        gsb_task = check_google_safe_browsing(client, final_url)
        ipqs_task = check_ipqualityscore(client, final_url)
        
        results = await asyncio.gather(vt_task, gsb_task, ipqs_task, return_exceptions=True)
        
        # Safely extract scores even if an API call timed out/failed
        vt_score = results[0] if isinstance(results[0], float) else 0.0
        gsb_score = results[1] if isinstance(results[1], float) else 0.0
        ipqs_score = results[2] if isinstance(results[2], float) else 0.0

        # Step C: Weighted Scoring Formula (PRD Spec)
        composite_score = round(
            (vt_score * 0.40) + 
            (gsb_score * 0.35) + 
            (ipqs_score * 0.15) + 
            (heuristic_score * 0.10)
        )
        
        # Step D: Verdict Threshold Mapping
        if composite_score <= 25:
            verdict = "AMAN"
        elif composite_score <= 65:
            verdict = "WASPADA"
        else:
            verdict = "BAHAYA"

        return {
            "scanned_url": target_url,
            "resolved_url": final_url,
            "risk_score": composite_score,
            "verdict": verdict,
            "details": {
                "virustotal_score": vt_score,
                "google_safe_browsing_score": gsb_score,
                "ipqualityscore_score": ipqs_score,
                "heuristic_score": heuristic_score
            }
        }