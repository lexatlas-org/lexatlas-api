import requests
from config import settings
from models.schemas import SearchResult

def perform_search(query: str, top_k: int = 5) -> list[SearchResult]:
    url = f"{settings.AZURE_SEARCH_ENDPOINT}/indexes/{settings.AZURE_SEARCH_INDEX}/docs/search?api-version=2023-07-01-Preview"

    headers = {
        "Content-Type": "application/json",
        "api-key": settings.AZURE_SEARCH_KEY
    }

    payload = {
        "search": query,
        "top": top_k,
        "queryType": "semantic",
        "semanticConfiguration": settings.AZURE_SEARCH_SEMANTIC_CONFIG_NAME,   
        "captions": "extractive",
        "answers": "extractive"
    }

    response = requests.post(url, headers=headers, json=payload)
    
    if response.status_code != 200:
        raise Exception(f"Azure Search failed: {response.status_code} - {response.text}")

    data = response.json()
    results = []

    for doc in data.get("value", []):
        results.append(SearchResult(
            title=doc.get("title", "Untitled"),
            excerpt=doc.get("@search.captions", [{}])[0].get("text", ""),
            score=doc.get("@search.score", 0),
            doc_id=str(doc.get("id", "unknown"))
        ))

    return results
