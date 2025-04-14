def run_llm_query(chunks, question):
    prompt = build_prompt(chunks, question)
    return "Yes, based on the context, you are required to register with the Attorney General."

def build_prompt(chunks, question):
    context = "\n\n".join(chunks)
    return f"""You are a legal assistant.

Context:
{context}

Question:
{question}

Answer:"""
