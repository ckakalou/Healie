"""
Neo4j connection helper for the HEALIE retrieval pipeline.

This module centralizes the connection to Neo4j Aura so that all retrieval
scripts use the same environment variables and connection logic.
"""

import os
from pathlib import Path

from dotenv import load_dotenv
from neo4j import GraphDatabase


def load_project_env() -> None:
    """
    Load the .env file from the project root.

    This makes the script work whether it is run from the repository root
    or directly from the retrieval folder.
    """
    current_file = Path(__file__).resolve()
    project_root = current_file.parents[2]
    env_path = project_root / ".env"

    load_dotenv(dotenv_path=env_path)


def get_neo4j_driver():
    """
    Create and return a Neo4j driver.

    Required .env variables:
    - NEO4J_URI
    - NEO4J_USER
    - NEO4J_PASSWORD

    Optional .env variable:
    - NEO4J_DATABASE
    """
    load_project_env()

    uri = os.getenv("NEO4J_URI")
    user = os.getenv("NEO4J_USER")
    password = os.getenv("NEO4J_PASSWORD")

    missing = [
        name
        for name, value in {
            "NEO4J_URI": uri,
            "NEO4J_USER": user,
            "NEO4J_PASSWORD": password,
        }.items()
        if not value
    ]

    if missing:
        raise EnvironmentError(
            f"Missing required Neo4j environment variables: {', '.join(missing)}"
        )

    return GraphDatabase.driver(uri, auth=(user, password))


def get_neo4j_database() -> str | None:
    """
    Return the Neo4j database name from .env, if provided.
    """
    load_project_env()
    return os.getenv("NEO4J_DATABASE")