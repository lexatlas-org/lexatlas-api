# store/context.py
import sqlite3
import os
import json

# DB path
DB_PATH = os.path.join(os.path.dirname(__file__), "context_store.db")

# Initialize DB if it doesn't exist
def _init_db():
    with sqlite3.connect(DB_PATH) as conn:
        conn.execute("""
            CREATE TABLE IF NOT EXISTS context (
                context_id TEXT PRIMARY KEY,
                chunks TEXT
            )
        """)
        conn.commit()

_init_db()

def set_context(context_id: str, chunks: list[str]):
    with sqlite3.connect(DB_PATH) as conn:
        conn.execute(
            "INSERT OR REPLACE INTO context (context_id, chunks) VALUES (?, ?)",
            (context_id, json.dumps(chunks))
        )
        conn.commit()

def get_context(context_id: str) -> list[str] | None:
    with sqlite3.connect(DB_PATH) as conn:
        cursor = conn.execute(
            "SELECT chunks FROM context WHERE context_id = ?",
            (context_id,)
        )
        row = cursor.fetchone()
        if row:
            return json.loads(row[0])
        return None

def delete_context(context_id: str):
    with sqlite3.connect(DB_PATH) as conn:
        conn.execute(
            "DELETE FROM context WHERE context_id = ?",
            (context_id,)
        )
        conn.commit()
