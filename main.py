from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import JSONResponse

# from routes.api import router as api_router
from config import LEXATLAS_API_KEY

app = FastAPI(title="LexAtlas API - Phase 1")

@app.middleware("http")
async def verify_api_key(request: Request, call_next):
    if request.url.path.startswith("/docs") or request.url.path.startswith("/openapi.json"):
        return await call_next(request)

    api_key = request.headers.get("x-api-key")

    if api_key is None:
        return JSONResponse(
            status_code=401,
            content={"detail": "Missing 'x-api-key' header. Please include your API key."}
        )

    if api_key != LEXATLAS_API_KEY:
        return JSONResponse(
            status_code=401,
            content={"detail": "Invalid API key. Access denied."}
        )

    return await call_next(request)

@app.get("/")
def read_root():
    return {"message": "Hello World from FastAPI 🚀", "version": "1.0.0"}

# app.include_router(api_router, prefix="/api")

