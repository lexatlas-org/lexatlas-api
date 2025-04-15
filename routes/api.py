from fastapi import APIRouter, UploadFile, File, Form, HTTPException
from models.schemas import *
from services.search_service import perform_search
from services.llm_service import run_llm_query
from services.file_service import handle_upload
import datetime
from uuid import uuid4

router = APIRouter()

# In-memory context store (should be replaced with Redis or CosmosDB in production)
context_store = {}

@router.get("/search",
    response_model=SearchResponse,
    summary="Semantic or keyword search",
    description="""
                Performs a semantic or keyword-based search on legal documents.
                Returns top `k` passages and stores them under a context ID for future queries.
                """
                )
def search(q: str, top_k: int = 5):
    """
    ### Search endpoint:
    - **q**: Search query string (e.g., "nonprofit registration in California")
    - **top_k**: Number of results to return (default: 5)
    """
    results = perform_search(q, top_k)
    context_id = f"ctx-{uuid4()}"
    context_store[context_id] = [r.excerpt for r in results]

    return SearchResponse(
        context_id=context_id,
        results=results,
        source="Azure AI Search",
        timestamp=datetime.datetime.utcnow().isoformat()
    )

@router.post("/query",
    response_model=QueryResponse,
    summary="Ask a question based on search context",
    description="""
                Uses the provided `context_id` (generated from `/search`) to answer a legal question using GPT-based LLM.
                """
                )
def query(payload: QueryRequest):
    """
    ### Query endpoint:
    - Accepts a legal question and a context ID
    - Returns an AI-generated answer using the associated context chunks
    """
    chunks = context_store.get(payload.context_id)
    if not chunks:
        raise HTTPException(status_code=404, detail="Context ID not found.")

    answer = run_llm_query(chunks, payload.question)
    return QueryResponse(
        answer=answer,
        source="Azure OpenAI",
        used_chunks=chunks,
        timestamp=datetime.datetime.utcnow().isoformat()
    )

@router.post("/upload",
    response_model=UploadResponse,
    summary="Upload a legal document",
    description="""
                Uploads a legal document (PDF, DOCX, or TXT).
                Returns a document ID and status. The document will be queued for background processing.
                """
                )
async def upload(
    file: UploadFile = File(...),
    title: str = Form(None),
    user_id: str = Form(None)
):
    """
    ### Upload endpoint:
    - **file**: Required document file (PDF, DOCX, or TXT)
    - **title**: Optional user-friendly title for the document
    - **user_id**: Optional identifier for tracking uploads by user
    """
    return await handle_upload(file, title, user_id)
