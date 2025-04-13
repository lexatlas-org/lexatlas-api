from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello World from FastAPI 🚀", "version": "1.0.0"}