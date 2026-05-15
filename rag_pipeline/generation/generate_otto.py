"""
Generate Otto patient-facing content using the HEALIE vertical slice.

This script:
1. Loads controlled CLL clinical facts.
2. Retrieves Otto data from Neo4j.
3. Builds the deterministic graph-based reasoning report.
4. Loads the Otto generation prompt template.
5. Fills the prompt.
6. Calls the LLM.
7. Saves the generated output.

Run from the project root with:

    python -m rag_pipeline.generation.generate_otto
"""

from __future__ import annotations

import os
from pathlib import Path
from pprint import pformat
from typing import Any

from dotenv import load_dotenv
from langchain_openai import ChatOpenAI

from rag_pipeline.reasoning.otto_reasoning import generate_otto_reasoning_bundle


MODEL_NAME = "gpt-4o-mini"


def get_project_root() -> Path:
    """
    Return the project root.

    This file is located at:
    rag_pipeline/generation/generate_otto.py

    parents[2] resolves to the repository root.
    """
    return Path(__file__).resolve().parents[2]


def load_project_env(project_root: Path) -> None:
    """
    Load .env from the project root.
    """
    env_path = project_root / ".env"
    load_dotenv(dotenv_path=env_path)


def read_text_file(path: Path) -> str:
    """
    Read a UTF-8 text file and raise a clear error if missing.
    """
    if not path.exists():
        raise FileNotFoundError(f"Required file not found: {path}")

    return path.read_text(encoding="utf-8")


def format_patient_profile(profile: dict[str, Any]) -> str:
    """
    Convert Otto profile dictionary into prompt-readable text.
    """
    return "\n".join(
        [
            f"- Patient ID: {profile.get('patient_id')}",
            f"- Patient name: {profile.get('patient_name')}",
            f"- Profile ID: {profile.get('profile_id')}",
            f"- Age group: {profile.get('age_group')}",
            f"- Education level: {profile.get('education_level')}",
            f"- Health literacy level: {profile.get('health_literacy_level')}",
            f"- Main communication need: {profile.get('main_communication_need')}",
            f"- Condition: {profile.get('condition_name')} ({profile.get('condition_abbreviation')})",
        ]
    )


def format_adaptation_instructions(
    adaptation_instructions: list[dict[str, Any]],
) -> str:
    """
    Convert adaptation instructions into prompt-readable text.
    """
    lines = []

    for index, item in enumerate(adaptation_instructions, start=1):
        text_features = ", ".join(item.get("text_features", [])) or "None"

        computed_score = item.get("computed_activation_score")
        if computed_score is None:
            computed_score_text = "not computed"
        else:
            computed_score_text = f"{computed_score:.3f}"

        lines.append(
            f"{index}. {item['adaptation_element']} "
            f"({item['category']})"
        )
        lines.append(f"   - Triggering factor: {item['triggering_factor']}")
        lines.append(f"   - Factor value: {item['factor_value']}")
        lines.append(f"   - Activation weight: {item['activation_weight']}")
        lines.append(f"   - Computed activation score: {computed_score_text}")
        lines.append(f"   - Expected text effect: {item['text_effect']}")
        lines.append(f"   - Modified text feature(s): {text_features}")

    return "\n".join(lines)


def build_generation_prompt(
    prompt_template: str,
    clinical_facts: str,
    reasoning_bundle: dict[str, Any],
) -> str:
    """
    Fill the Otto generation prompt template.
    """
    patient_profile_text = format_patient_profile(reasoning_bundle["profile"])
    adaptation_instructions_text = format_adaptation_instructions(
        reasoning_bundle["adaptation_instructions"]
    )

    return prompt_template.format(
        clinical_facts=clinical_facts,
        patient_profile=patient_profile_text,
        reasoning_report=reasoning_bundle["human_readable_report"],
        adaptation_instructions=adaptation_instructions_text,
    )


def call_llm(prompt: str) -> str:
    """
    Call the LLM and return generated content.
    """
    if not os.getenv("OPENAI_API_KEY"):
        raise EnvironmentError("OPENAI_API_KEY is missing from .env")

    llm = ChatOpenAI(
        model=MODEL_NAME,
        temperature=0.2,
    )

    response = llm.invoke(prompt)
    return response.content


def save_generated_output(
    output_path: Path,
    generated_text: str,
    prompt: str,
    reasoning_report: str,
    reasoning_object: dict[str, Any],
) -> None:
    """
    Save generated output with provenance information.
    """
    output_path.parent.mkdir(parents=True, exist_ok=True)

    reasoning_object_text = pformat(reasoning_object, sort_dicts=False)

    content_parts = [
        "# Otto Generated Output",
        "",
        "## Generated content",
        "",
        generated_text,
        "",
        "---",
        "",
        "## Reasoning report used",
        "",
        reasoning_report,
        "",
        "---",
        "",
        "## Machine-readable reasoning object used",
        "",
        "```python",
        reasoning_object_text,
        "```",
        "",
        "---",
        "",
        "## Prompt used",
        "",
        "```text",
        prompt,
        "```",
        "",
    ]

    content = "\n".join(content_parts)

    output_path.write_text(content, encoding="utf-8")

def main() -> None:
    print("Starting Otto generation...")

    project_root = get_project_root()
    load_project_env(project_root)

    clinical_facts_path = project_root / "data" / "clinical_content" / "cll_basic_facts.md"
    prompt_template_path = (
        project_root / "rag_pipeline" / "prompts" / "otto_generation_prompt.txt"
    )
    output_path = project_root / "docs" / "use_cases" / "otto_generated_output.md"

    print(f"Loading clinical facts from: {clinical_facts_path}")
    clinical_facts = read_text_file(clinical_facts_path)

    print(f"Loading prompt template from: {prompt_template_path}")
    prompt_template = read_text_file(prompt_template_path)

    print("Generating Otto reasoning bundle...")
    reasoning_bundle = generate_otto_reasoning_bundle()

    print("Building generation prompt...")
    prompt = build_generation_prompt(
        prompt_template=prompt_template,
        clinical_facts=clinical_facts,
        reasoning_bundle=reasoning_bundle,
    )

    print("Calling LLM...")
    generated_text = call_llm(prompt)

    reasoning_object = {
        "profile": reasoning_bundle["profile"],
        "dominant_barriers": reasoning_bundle["dominant_barriers"],
        "adaptation_instructions": reasoning_bundle["adaptation_instructions"],
    }

    print("Saving generated output...")
    save_generated_output(
        output_path=output_path,
        generated_text=generated_text,
        prompt=prompt,
        reasoning_report=reasoning_bundle["human_readable_report"],
        reasoning_object=reasoning_object,
    )

    print("Otto generation complete.")
    print(f"Saved generated output to: {output_path}")


if __name__ == "__main__":
    main()