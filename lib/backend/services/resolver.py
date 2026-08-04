import httpx

async def resolve_url_redirects(url: str, max_redirects: int = 5) -> dict:
    """
    Follows HTTP redirect chains to expand short URLs (bit.ly, tinyurl.com, s.id, etc.).
    Returns the resolved destination URL and redirect metadata.
    """
    current_url = url.strip()
    
    # Ensure scheme exists
    if not current_url.startswith(("http://", "https://")):
        current_url = "https://" + current_url

    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) QRisk-Scanner/1.0"
    }

    try:
        # httpx handles redirect tracking asynchronously
        async with httpx.AsyncClient(follow_redirects=True, max_redirects=max_redirects, timeout=6.0) as client:
            response = await client.head(current_url, headers=headers)
            
            # Fallback to GET if server rejects HEAD requests
            if response.status_code in (405, 403):
                response = await client.get(current_url, headers=headers)

            redirect_chain = [str(r.url) for r in response.history] + [str(response.url)]
            final_url = str(response.url)

            return {
                "resolved_url": final_url,
                "is_redirected": len(response.history) > 0,
                "redirect_chain": redirect_chain
            }
            
    except Exception as e:
        # If redirect fails or times out, safely fall back to initial input URL
        return {
            "resolved_url": current_url,
            "is_redirected": False,
            "redirect_chain": [current_url],
            "error": str(e)
        }