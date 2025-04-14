from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from config import settings
from routes.api import router as api_router

app = FastAPI(title="LexAtlas RAG API", 
              version="1.0.1", 
              description="LexAtlas RAG API for document retrieval and question answering.")

@app.middleware("http")
async def verify_api_key(request: Request, call_next):
    if request.url.path.startswith("/docs") or request.url.path.startswith("/openapi.json"):
        return await call_next(request)

    api_key = request.headers.get("x-api-key")
    if not api_key:
        return JSONResponse(status_code=401, content={"detail": "Missing 'x-api-key' header."})
    if api_key != settings.LEXATLAS_API_KEY:
        return JSONResponse(status_code=401, content={"detail": "Invalid API key."})
    return await call_next(request)


@app.get("/")
def read_root():
    return {
        "message": "Welcome to the LexAtlas RAG API",
        "description": "This API provides document retrieval and question answering capabilities.", 
        "version": "1.0.1"
        }

app.include_router(api_router)
