from fastapi import UploadFile
from models.schemas import UploadResponse
from uuid import uuid4

async def handle_upload(file: UploadFile, title: str, user_id: str):
    contents = await file.read()
    filename = file.filename
    doc_id = f"doc-{uuid4()}"
    print(f"File received: {filename} ({len(contents)} bytes)")

    return UploadResponse(
        status="uploaded",
        filename=filename,
        doc_id=doc_id,
        message="Document uploaded successfully and is queued for processing."
    )
