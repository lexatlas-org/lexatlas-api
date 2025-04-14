## **Step 1: Install Requirements**

1. **Ensure Python is Installed**  
   Make sure you have Python 3.11 installed on your system. You can verify this by running:
   ```bash
   python --version
   ```
   If Python is not installed, download and install it from [python.org](https://www.python.org/).

2. **Create a Virtual Environment**  
   It is recommended to use a virtual environment to manage dependencies. Run the following commands:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows, use `venv\Scripts\activate`
   ```

3. **Install Dependencies**  
   Use `pip` to install the required dependencies listed in the requirements.txt file:
   ```bash
   pip install -r requirements.txt
   ```

---

## **Step 2: Configure the .env File**

The .env file contains environment variables required for the project to run. Follow these steps to configure it:

1. **Locate the .env File**  
   The .env file is located in the root directory of the project. If it does not exist, create a new file named .env.

2. **Copy the Example File**  
   Use the .env_example file as a template. You can copy its contents to the .env file:
   ```bash
   cp .env_example .env
   ```

3. **Edit the .env File**  
   Open the .env file in a text editor and fill in the required values. Below is an explanation of the key variables:

   - **API Key**  
     Set the API key for securing your application:
     ```env
     LEXATLAS_API_KEY=supersecuredevtoken
     ```

   - **Azure OpenAI Configuration**  
     Provide the Azure OpenAI service details:
     ```env
     AZURE_OPENAI_KEY=<your_openai_key>
     AZURE_OPENAI_ENDPOINT=<your_openai_endpoint>
     AZURE_OPENAI_DEPLOYMENT=<your_openai_deployment_name>
     ```

   - **Azure Cognitive Search Configuration**  
     Provide the Azure Cognitive Search details:
     ```env
     AZURE_SEARCH_ENDPOINT=<your_search_endpoint>
     AZURE_SEARCH_INDEX=<your_search_index>
     AZURE_SEARCH_KEY=<your_search_key>
     ```

   - **Azure Blob Storage Configuration**  
     Provide the Azure Blob Storage details:
     ```env
     AZURE_STORAGE_ACCOUNT_NAME=<your_storage_account_name>
     AZURE_STORAGE_ACCOUNT_KEY=<your_storage_account_key>
     AZURE_STORAGE_CONTAINER=<your_storage_container_name>
     ```

4. **Save the File**  
   After editing, save the .env file.

---

## **Step 3: Verify the Setup**

1. **Run the Application**  
   Start the FastAPI application to verify the setup:
   ```bash
   uvicorn main:app --reload
   ```

2. **Test the API**  
   Use the test_api.http file to test the API endpoints. For example:
   ```http
   GET http://127.0.0.1:8000
   X-API-Key: supersecuredevtoken
   ```

3. **Check for Errors**  
   If there are any errors, ensure the .env file is correctly configured and all dependencies are installed.

 