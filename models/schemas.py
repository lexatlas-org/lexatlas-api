from pydantic import BaseModel
from typing import List, Optional

# Search request and response
class SearchResult(BaseModel):
    title: str
    excerpt: str
    score: float
    doc_id: str

class SearchResponse(BaseModel):
    context_id: str
    results: List[SearchResult]
    source: str
    timestamp: str

# Query request and response
class QueryRequest(BaseModel):
    question: str
    context_id: str

class QueryResponse(BaseModel):
    answer: str
    source: str
    used_chunks: List[str]
    timestamp: str

# Upload request and response
class UploadResponse(BaseModel):
    status: str
    filename: str
    doc_id: str
    message: str
