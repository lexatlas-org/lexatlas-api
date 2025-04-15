import os
from typing import List
from azure.ai.inference import ChatCompletionsClient
from azure.ai.inference.models import SystemMessage, UserMessage
from azure.core.credentials import AzureKeyCredential
from config import settings

# Initialize OpenAI Chat client using Azure Inference
chat_client = ChatCompletionsClient(
    endpoint=settings.AZURE_OPENAI_ENDPOINT,
    credential=AzureKeyCredential(settings.AZURE_OPENAI_KEY)  # Fixed key name
)

def run_llm_query(chunks: List[str], question: str) -> str:
    context = clean_text_for_rag(chunks)

    prompt = f"""You are a legal assistant providing concise answers grounded strictly in the provided legal context.

                Context:
                {context}

                Question:
                {question}

                Answer:"""

    response = chat_client.complete(
        messages=[
            SystemMessage(content=(
                "You are a legal assistant that only answers based on the provided context. "
                "If the context is insufficient, reply that more information is needed."
            )),
            UserMessage(content=prompt)
        ],
        max_tokens=800,
        temperature=0.3,
        model=settings.AZURE_OPENAI_DEPLOYMENT
    )

    return response.choices[0].message.content.strip()

def clean_text_for_rag(chunks: List[str], max_tokens: int = 16000) -> str:
    """
    Cleans and concatenates context chunks, limits to a safe token limit.
    """
    # Clean each chunk by removing extra spaces, newlines, and empty rows
    chunks = [chunk.strip() for chunk in chunks if chunk.strip()]
    chunks = [chunk.replace("\n", " ").replace("\r", " ").replace("\t", " ") for chunk in chunks]

    # Concatenate chunks into a single text
    text = " ".join(chunks)

    # Remove extra spaces and ensure compact formatting
    compact_text = " ".join(text.split())

    # Calculate the maximum character limit based on token limit (approx. 4 chars per token)
    max_chars = max_tokens * 4

    # Truncate the text to fit within the maximum character limit
    if len(compact_text) > max_chars:
        compact_text = compact_text[:max_chars]

    return compact_text
