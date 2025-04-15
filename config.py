from dotenv import load_dotenv
import os

load_dotenv()

class Settings:
    LEXATLAS_API_KEY = os.getenv("LEXATLAS_API_KEY")
    
    AZURE_SEARCH_KEY = os.getenv("AZURE_SEARCH_KEY")
    AZURE_SEARCH_ENDPOINT = os.getenv("AZURE_SEARCH_ENDPOINT")
    AZURE_SEARCH_INDEX = os.getenv("AZURE_SEARCH_INDEX")
    AZURE_SEARCH_SEMANTIC_CONFIG_NAME = os.getenv("AZURE_SEARCH_SEMANTIC_CONFIG_NAME")

    AZURE_OPENAI_KEY = os.getenv("AZURE_OPENAI_KEY")
    AZURE_OPENAI_ENDPOINT = os.getenv("AZURE_OPENAI_ENDPOINT")
    AZURE_OPENAI_DEPLOYMENT = os.getenv("AZURE_OPENAI_DEPLOYMENT")

settings = Settings()
