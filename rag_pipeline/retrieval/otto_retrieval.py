"""
Retrieve Otto vertical-slice data from Neo4j.

This script retrieves:
1. Otto profile and clinical condition
2. Otto-specific factor values + stable influence weights
3. Activated adaptation elements + categories + text features

Run from the project root with:

    python rag_pipeline/retrieval/otto_retrieval.py
"""

from pprint import pprint
from typing import Any

from rag_pipeline.retrieval.neo4j_connection import (
    get_neo4j_database,
    get_neo4j_driver,
)
QUERY_OTTO_PROFILE = """
MATCH (patient:Patient {id: "otto"})
-[:HAS_PROFILE]->
(profile:PatientProfile)
-[:HAS_CONDITION]->
(condition:ClinicalCondition)

WHERE patient.slice = "otto_vertical_slice"
  AND profile.slice = "otto_vertical_slice"
  AND condition.slice = "otto_vertical_slice"

RETURN
  patient.id AS patient_id,
  patient.name AS patient_name,
  profile.id AS profile_id,
  profile.age_group AS age_group,
  profile.education_level AS education_level,
  profile.health_literacy_level AS health_literacy_level,
  profile.main_communication_need AS main_communication_need,
  condition.id AS condition_id,
  condition.name AS condition_name,
  condition.abbreviation AS condition_abbreviation
"""


QUERY_OTTO_WEIGHTED_FACTORS = """
MATCH (patient:Patient {id: "otto"})
-[:HAS_PROFILE]->
(profile:PatientProfile)
-[score:HAS_FACTOR_SCORE]->
(factor:Factor)
-[influence:INFLUENCES]->
(dimension:HealthLiteracyDimension)

WHERE patient.slice = "otto_vertical_slice"
  AND profile.slice = "otto_vertical_slice"
  AND factor.slice = "otto_vertical_slice"
  AND dimension.slice = "otto_vertical_slice"

RETURN
  patient.id AS patient_id,
  factor.id AS factor_id,
  factor.name AS factor,
  factor.factor_type AS factor_type,
  score.factor_value AS factor_value,
  score.factor_value_type AS factor_value_type,
  score.evidence_status AS factor_value_evidence_status,
  score.needs_validation AS factor_value_needs_validation,
  dimension.id AS health_literacy_dimension_id,
  dimension.name AS health_literacy_dimension,
  influence.influence_weight AS influence_weight,
  influence.direction AS direction,
  influence.effect AS effect,
  influence.evidence_type AS relationship_evidence_type,
  influence.evidence_status AS relationship_evidence_status,
  influence.source AS source,
  influence.validated AS validated,
  influence.needs_validation AS relationship_needs_validation,
  influence.confidence AS confidence,
  CASE
    WHEN score.factor_value_type = "numeric"
    THEN score.factor_value * influence.influence_weight
    ELSE null
  END AS computed_influence_score

ORDER BY influence.influence_weight DESC, factor.id
"""


QUERY_OTTO_ADAPTATIONS = """
MATCH (patient:Patient {id: "otto"})
-[:HAS_PROFILE]->
(profile:PatientProfile)
-[score:HAS_FACTOR_SCORE]->
(factor:Factor)
-[activation:ACTIVATES]->
(element:AdaptationElement)
-[:BELONGS_TO]->
(category:AdaptationCategory)

OPTIONAL MATCH (element)-[modification:MODIFIES]->(feature:TextFeature)

WHERE patient.slice = "otto_vertical_slice"
  AND profile.slice = "otto_vertical_slice"
  AND factor.slice = "otto_vertical_slice"
  AND element.slice = "otto_vertical_slice"
  AND category.slice = "otto_vertical_slice"
  AND (feature IS NULL OR feature.slice = "otto_vertical_slice")

WITH
  patient,
  factor,
  score,
  activation,
  element,
  category,
  collect(DISTINCT {
    text_feature_id: feature.id,
    text_feature: feature.name,
    modification_type: modification.modification_type,
    modification_description: modification.description,
    modification_weight: modification.modification_weight
  }) AS modified_text_features

RETURN
  patient.id AS patient_id,
  factor.id AS factor_id,
  factor.name AS triggering_factor,
  score.factor_value AS factor_value,
  score.factor_value_type AS factor_value_type,
  element.id AS adaptation_element_id,
  element.name AS adaptation_element,
  category.id AS adaptation_category_id,
  category.name AS adaptation_category,
  activation.activation_weight AS activation_weight,
  activation.text_effect AS text_effect,
  activation.evidence_type AS evidence_type,
  activation.evidence_status AS evidence_status,
  activation.source AS source,
  activation.validated AS validated,
  activation.needs_validation AS needs_validation,
  activation.confidence AS confidence,
  CASE
    WHEN score.factor_value_type = "numeric"
    THEN score.factor_value * activation.activation_weight
    ELSE null
  END AS computed_activation_score,
  modified_text_features

ORDER BY activation.activation_weight DESC, category.name, element.name
"""


def run_query(query: str) -> list[dict[str, Any]]:
    """
    Run a Cypher query and return records as dictionaries.
    """
    driver = get_neo4j_driver()
    database = get_neo4j_database()

    try:
        with driver.session(database=database) if database else driver.session() as session:
            result = session.run(query)
            return [record.data() for record in result]
    finally:
        driver.close()


def get_otto_profile() -> dict[str, Any]:
    """
    Retrieve Otto's profile.

    Returns a single dictionary.
    """
    rows = run_query(QUERY_OTTO_PROFILE)

    if not rows:
        raise ValueError("No Otto profile found in Neo4j.")

    if len(rows) > 1:
        raise ValueError(f"Expected 1 Otto profile row, found {len(rows)}.")

    return rows[0]


def get_otto_weighted_factors() -> list[dict[str, Any]]:
    """
    Retrieve Otto-specific factor values and stable influence weights.
    """
    return run_query(QUERY_OTTO_WEIGHTED_FACTORS)


def get_otto_adaptations() -> list[dict[str, Any]]:
    """
    Retrieve adaptation elements activated for Otto.
    """
    return run_query(QUERY_OTTO_ADAPTATIONS)


def get_otto_retrieval_bundle() -> dict[str, Any]:
    """
    Retrieve all Otto data needed by later reasoning and generation steps.
    """
    profile = get_otto_profile()
    weighted_factors = get_otto_weighted_factors()
    adaptations = get_otto_adaptations()

    return {
        "profile": profile,
        "weighted_factors": weighted_factors,
        "adaptations": adaptations,
    }


def print_section(title: str) -> None:
    print("\n" + "=" * 80)
    print(title)
    print("=" * 80)


if __name__ == "__main__":
    bundle = get_otto_retrieval_bundle()

    print_section("OTTO PROFILE")
    pprint(bundle["profile"], sort_dicts=False)

    print_section("OTTO WEIGHTED FACTORS")
    print(f"Rows: {len(bundle['weighted_factors'])}")
    pprint(bundle["weighted_factors"], sort_dicts=False)

    print_section("OTTO ADAPTATIONS")
    print(f"Rows: {len(bundle['adaptations'])}")
    pprint(bundle["adaptations"], sort_dicts=False)