// HEALIE Otto Vertical Slice
// Query 2: Retrieve Otto-specific factor values and stable factor-to-HL influence weights

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

ORDER BY influence.influence_weight DESC, factor.id;