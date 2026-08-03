# database.py
from datetime import datetime
from typing import Optional
from sqlmodel import Field, SQLModel, create_engine, Session

# 1. ScanHistory Table Schema
class ScanHistory(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    scanned_url: str
    resolved_url: str
    risk_score: int
    verdict: str  # AMAN, WASPADA, or BAHAYA
    created_at: datetime = Field(default_factory=datetime.utcnow)

# 2. SQLite Connection Setup
sqlite_file_name = "qrisk.db"
sqlite_url = f"sqlite:///{sqlite_file_name}"

# check_same_thread=False is required for SQLite with FastAPI
engine = create_engine(sqlite_url, connect_args={"check_same_thread": False})

def create_db_and_tables():
    SQLModel.metadata.create_all(engine)

def get_session():
    with Session(engine) as session:
        yield session