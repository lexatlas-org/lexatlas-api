from models.schemas import SearchResult

def perform_search(query: str, top_k: int = 5):
    return [
        SearchResult(
            title="Nonprofit Formation in California",
            excerpt="File Articles of Incorporation with the Secretary of State...",
            score=0.93,
            doc_id="doc-001"
        ),
        SearchResult(
            title="Charitable Trust Requirements",
            excerpt="Register with the Attorney General within 30 days...",
            score=0.89,
            doc_id="doc-002"
        )
    ][:top_k]
