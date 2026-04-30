from dotenv import load_dotenv
import os

from langchain_openai import ChatOpenAI
from langchain_neo4j import Neo4jGraph

load_dotenv()

# ---- Test 1: LangChain + OpenAI ----
llm = ChatOpenAI(
    model="gpt-4o-mini",
    temperature=0
)

response = llm.invoke("Say: HEALIE LangChain OpenAI connection works.")

print("LangChain OpenAI test:")
print(response.content)

# ---- Test 2: LangChain + Neo4j Aura ----
graph = Neo4jGraph(
    url=os.getenv("NEO4J_URI"),
    username=os.getenv("NEO4J_USER"),
    password=os.getenv("NEO4J_PASSWORD"),
    database=os.getenv("NEO4J_DATABASE"),
)

result = graph.query("""
RETURN 'HEALIE LangChain Neo4j connection works' AS message
""")

print("\nLangChain Neo4j test:")
print(result[0]["message"])