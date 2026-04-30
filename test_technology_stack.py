"""
HEALIE Technology Stack Validation Script

Checks:
- Environment variables (.env loading via python-dotenv)
- OpenAI API connectivity (LLM access)
- Neo4j Aura connectivity (Knowledge Graph access)
- LangChain integration (LLM + Neo4j wrappers)

Used to verify system readiness before running HEALIE pipelines (LLM + Neo4j wrappers).
"""

import subprocess
import sys
from pathlib import Path

TESTS = [
    "tests/test_env.py",
    "tests/test_neo4j.py",
    "tests/test_langchain.py",
]

def run_test(test_path: str) -> bool:
    path = Path(test_path)

    if not path.exists():
        print(f"❌ Missing: {test_path}")
        return False

    print(f"\n▶ Running {test_path}")
    print("-" * 60)

    result = subprocess.run(
        [sys.executable, str(path)],
        text=True,
        capture_output=True
    )

    print(result.stdout)

    if result.stderr:
        print(result.stderr)

    if result.returncode == 0:
        print(f"✅ Passed: {test_path}")
        return True
    else:
        print(f"❌ Failed: {test_path}")
        return False


def main():
    print("HEALIE stack test runner")
    print("=" * 60)

    results = [run_test(test) for test in TESTS]

    print("\nSummary")
    print("=" * 60)

    passed = sum(results)
    total = len(results)

    print(f"Passed {passed}/{total} tests")

    if passed == total:
        print("✅ HEALIE technology stack is ready.")
    else:
        print("❌ Some tests failed. Check the output above.")
        sys.exit(1)


if __name__ == "__main__":
    main()