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
import json
import os
from datetime import datetime
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

def create_run_directory(project_root: Path) -> Path:
    """
    Create a timestamped archive directory for this generation run.
    """
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    run_dir = (
        project_root
        / "docs"
        / "use_cases"
        / "otto_outputs"
        / f"run_{timestamp}"
    )

    run_dir.mkdir(parents=True, exist_ok=False)
    return run_dir

def save_generated_output(
    latest_output_path: Path,
    run_dir: Path,
    llm_only_output: str,
    kg_guided_output: str,
    llm_only_prompt: str,
    kg_guided_prompt: str,
    reasoning_report: str,
    reasoning_object: dict[str, Any],
) -> None:
    """
    Save generated outputs in two ways:

    1. A timestamped archive folder for reproducibility.
    2. A latest combined output file for quick inspection.
    """
    reasoning_object_text = pformat(reasoning_object, sort_dicts=False)

    metadata = {
        "run_directory": str(run_dir),
        "model": MODEL_NAME,
        "temperature": 0,
        "conditions": [
            "LLM-only personalised baseline",
            "HEALIE KG-guided output",
        ],
        "notes": (
            "LLM-only receives Otto factors directly. "
            "KG-guided receives graph-derived reasoning and adaptation instructions."
        ),
    }

    # Individual archived files
    (run_dir / "llm_only_output.md").write_text(
        llm_only_output,
        encoding="utf-8",
    )

    (run_dir / "kg_guided_output.md").write_text(
        kg_guided_output,
        encoding="utf-8",
    )

    (run_dir / "reasoning_report.md").write_text(
        reasoning_report,
        encoding="utf-8",
    )

    (run_dir / "reasoning_object.py").write_text(
        reasoning_object_text,
        encoding="utf-8",
    )

    (run_dir / "llm_only_prompt.txt").write_text(
        llm_only_prompt,
        encoding="utf-8",
    )

    (run_dir / "kg_guided_prompt.txt").write_text(
        kg_guided_prompt,
        encoding="utf-8",
    )

    (run_dir / "metadata.json").write_text(
        json.dumps(metadata, indent=2, ensure_ascii=False),
        encoding="utf-8",
    )

    # Combined file
    content_parts = [
        "# Otto Generated Output",
        "",
        f"Archived run directory: `{run_dir}`",
        "",
        "## 1. LLM-only personalised baseline",
        "",
        llm_only_output,
        "",
        "---",
        "",
        "## 2. HEALIE KG-guided output",
        "",
        kg_guided_output,
        "",
        "---",
        "",
        "## 3. Reasoning report used for KG-guided output",
        "",
        reasoning_report,
        "",
        "---",
        "",
        "## 4. Machine-readable reasoning object used",
        "",
        "```python",
        reasoning_object_text,
        "```",
        "",
        "---",
        "",
        "## 5. LLM-only baseline prompt used",
        "",
        "```text",
        llm_only_prompt,
        "```",
        "",
        "---",
        "",
        "## 6. KG-guided HEALIE prompt used",
        "",
        "```text",
        kg_guided_prompt,
        "```",
        "",
    ]

    combined_content = "\n".join(content_parts)

    # Save full combined output inside the archive
    (run_dir / "combined_output.md").write_text(
        combined_content,
        encoding="utf-8",
    )

    # Save latest combined output for easy viewing
    latest_output_path.parent.mkdir(parents=True, exist_ok=True)
    latest_output_path.write_text(
        combined_content,
        encoding="utf-8",
    )


def build_llm_only_baseline_prompt(
    prompt_template: str,
    clinical_facts: str,
) -> str:
    """
    Fill the LLM-only personalised baseline prompt.

    This prompt gives the model Otto's factors, but does not provide
    KG-derived adaptation elements, weights, text-feature mappings,
    or reasoning pathways.
    """
    return prompt_template.format(
        clinical_facts=clinical_facts,
    )

def main() -> None:
    print("Starting Otto generation...")

    project_root = get_project_root()
    load_project_env(project_root)

    clinical_facts_path = project_root / "data" / "clinical_content" / "cll_basic_facts.md"

    kg_guided_prompt_template_path = (
        project_root / "rag_pipeline" / "prompts" / "otto_generation_prompt.txt"
    )

    llm_only_prompt_template_path = (
        project_root / "rag_pipeline" / "prompts" / "otto_llm_only_baseline_prompt.txt"
    )

    latest_output_path = (
            project_root
            / "docs"
            / "use_cases"
            / "otto_generated_output_latest.md"
    )

    run_dir = create_run_directory(project_root)

    print(f"Loading clinical facts from: {clinical_facts_path}")
    clinical_facts = read_text_file(clinical_facts_path)

    print(f"Loading KG-guided prompt template from: {kg_guided_prompt_template_path}")
    kg_guided_prompt_template = read_text_file(kg_guided_prompt_template_path)

    print(f"Loading LLM-only baseline prompt template from: {llm_only_prompt_template_path}")
    llm_only_prompt_template = read_text_file(llm_only_prompt_template_path)

    print("Generating Otto reasoning bundle...")
    reasoning_bundle = generate_otto_reasoning_bundle()

    print("Building LLM-only baseline prompt...")
    llm_only_prompt = build_llm_only_baseline_prompt(
        prompt_template=llm_only_prompt_template,
        clinical_facts=clinical_facts,
    )

    print("Calling LLM for LLM-only personalised baseline...")
    llm_only_output = call_llm(llm_only_prompt)

    print("Building KG-guided HEALIE prompt...")
    kg_guided_prompt = build_generation_prompt(
        prompt_template=kg_guided_prompt_template,
        clinical_facts=clinical_facts,
        reasoning_bundle=reasoning_bundle,
    )

    print("Calling LLM for KG-guided HEALIE output...")
    kg_guided_output = call_llm(kg_guided_prompt)

    reasoning_object = {
        "profile": reasoning_bundle["profile"],
        "dominant_barriers": reasoning_bundle["dominant_barriers"],
        "adaptation_instructions": reasoning_bundle["adaptation_instructions"],
    }

    print("Saving generated outputs...")
    save_generated_output(
        latest_output_path=latest_output_path,
        run_dir=run_dir,
        llm_only_output=llm_only_output,
        kg_guided_output=kg_guided_output,
        llm_only_prompt=llm_only_prompt,
        kg_guided_prompt=kg_guided_prompt,
        reasoning_report=reasoning_bundle["human_readable_report"],
        reasoning_object=reasoning_object,
    )

    print("Otto generation complete.")
    print(f"Archived run saved to: {run_dir}")
    print(f"Latest output saved to: {latest_output_path}")

if __name__ == "__main__":
    main()
