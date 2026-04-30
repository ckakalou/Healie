from dotenv import load_dotenv
import os
from neo4j import GraphDatabase

load_dotenv()

uri = os.getenv("NEO4J_URI")
user = os.getenv("NEO4J_USER")
password = os.getenv("NEO4J_PASSWORD")
database = os.getenv("NEO4J_DATABASE", "neo4j")

print("URI loaded:", "YES" if uri else "NO")
print("User loaded:", "YES" if user else "NO")
print("Password loaded:", "YES" if password else "NO")

with GraphDatabase.driver(uri, auth=(user, password)) as driver:
    driver.verify_connectivity()
    records, summary, keys = driver.execute_query(
        "RETURN 'HEALIE Neo4j Aura connection works' AS message",
        database_=database,
    )

print(records[0]["message"])