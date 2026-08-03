# main.py
from fastapi import FastAPI, Depends, HTTPException, Query
from sqlmodel import Session, select
from typing import List, Optional
from contextlib import asynccontextmanager
from pydantic import BaseModel
from dotenv import load_dotenv

from database import ScanHistory, create_db_and_tables, get_session
from services.checker import evaluate_url_safety

load_dotenv()

@asynccontextmanager
async def lifespan(app: FastAPI):
    create_db_and_tables()
    yield

app = FastAPI(title="QRisk Threat Intelligence API", lifespan=lifespan)

class ScanPayload(BaseModel):
    url: str
    heuristic_score: float = 0.0

# ----------------------------------------------------
# REAL-TIME SCAN ENDPOINT
# ----------------------------------------------------
@app.post("/api/v1/scan")
async def scan_qr_code(payload: ScanPayload, session: Session = Depends(get_session)):
    # 1. Run parallel threat checks
    result = await evaluate_url_safety(payload.url, payload.heuristic_score)
    
    # 2. Save result into history database
    history_entry = ScanHistory(
        scanned_url=result["scanned_url"],
        resolved_url=result["resolved_url"],
        risk_score=result["risk_score"],
        verdict=result["verdict"]
    )
    session.add(history_entry)
    session.commit()
    
    return result

# ----------------------------------------------------
# GET HISTORY ENDPOINT
# ----------------------------------------------------
@app.get("/api/v1/history", response_model=List[ScanHistory])
async def get_history(
    verdict: Optional[str] = Query(None, description="Filter by AMAN, WASPADA, or BAHAYA"),
    limit: int = 50,
    session: Session = Depends(get_session)
):
    statement = select(ScanHistory).order_by(ScanHistory.created_at.desc()).limit(limit)
    if verdict:
        statement = statement.where(ScanHistory.verdict == verdict.upper())
    return session.exec(statement).all()