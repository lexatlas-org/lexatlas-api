from dotenv import load_dotenv
import os

load_dotenv()

class Settings:
    AZURE_OPENAI_KEY = os.getenv("AZURE_OPENAI_KEY") # AZURE_OPENAI_KEY
    AZURE_SEARCH_KEY = os.getenv("AZURE_SEARCH_KEY")
    AZURE_SEARCH_ENDPOINT = os.getenv("AZURE_SEARCH_ENDPOINT")
    LEXATLAS_API_KEY = os.getenv("LEXATLAS_API_KEY")

settings = Settings()

 