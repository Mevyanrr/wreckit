# lib/backend/main.py
from contextlib import asynccontextmanager
from pathlib import Path
from typing import List, Optional
from pydantic import BaseModel
from fastapi import FastAPI, Depends, HTTPException, Query
from sqlmodel import Session, select
from dotenv import load_dotenv

# 1. Explicitly load .env file from the same directory as main.py
env_path = Path(__file__).resolve().parent / ".env"
load_dotenv(dotenv_path=env_path)

from database import ScanHistory, create_db_and_tables, get_session
from services.checker import evaluate_url_safety
from services.resolver import resolve_url_redirects


@asynccontextmanager
async def lifespan(app: FastAPI):
    create_db_and_tables()
    yield


app = FastAPI(title="QRisk Threat Intelligence API", lifespan=lifespan)


class ScanPayload(BaseModel):
    url: str  # Cleaned payload schema


@app.post("/api/v1/scan")
async def scan_qr_code(payload: ScanPayload, session: Session = Depends(get_session)):
    # 1. Resolve URL shortener redirect chain first
    resolution = await resolve_url_redirects(payload.url)
    target_url = resolution["resolved_url"]

    # 2. Run threat checks (Fix: pass ONLY target_url)
    result = await evaluate_url_safety(target_url)

    # Enrich response with redirect metadata
    result["original_url"] = payload.url
    result["is_redirected"] = resolution["is_redirected"]
    result["redirect_chain"] = resolution["redirect_chain"]

    # 3. Save result into history database
    history_entry = ScanHistory(
        scanned_url=payload.url,  # Original short link scanned
        resolved_url=target_url,  # Final expanded target URL
        risk_score=result["risk_score"],
        verdict=result["verdict"],
    )
    session.add(history_entry)
    session.commit()

    return result


@app.get("/api/v1/history", response_model=List[ScanHistory])
async def get_history(
    verdict: Optional[str] = Query(
        None, description="Filter by AMAN, WASPADA, or BAHAYA"
    ),
    limit: int = 50,
    session: Session = Depends(get_session),
):
    statement = (
        select(ScanHistory).order_by(ScanHistory.created_at.desc()).limit(limit)
    )
    if verdict:
        statement = statement.where(ScanHistory.verdict == verdict.upper())
    return session.exec(statement).all()