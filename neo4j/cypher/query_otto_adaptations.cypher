// HEALIE Otto Vertical Slice
// Query 3: Retrieve Otto-activated adaptation elements, categories, and modified text features

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

ORDER BY activation.activation_weight DESC, category.name, element.name;