// HEALIE Otto Vertical Slice
// Query 1: Retrieve Otto profile and clinical condition

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
  condition.abbreviation AS condition_abbreviation;