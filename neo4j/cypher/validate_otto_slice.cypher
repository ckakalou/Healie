// HEALIE Otto Vertical Slice
// Validation checks for the Otto Neo4j graph

// 1. Count nodes by label + total
MATCH (n)
WHERE n.slice = "otto_vertical_slice"
WITH labels(n) AS labels, count(n) AS count
RETURN labels, count
UNION ALL
MATCH (n)
WHERE n.slice = "otto_vertical_slice"
RETURN ["TOTAL"] AS labels, count(n) AS count
ORDER BY labels;


// 2. Count relationships by type + total
MATCH (a)-[r]->(b)
WHERE a.slice = "otto_vertical_slice"
  AND b.slice = "otto_vertical_slice"
WITH type(r) AS relationship_type, count(r) AS count
RETURN relationship_type, count
UNION ALL
MATCH (a)-[r]->(b)
WHERE a.slice = "otto_vertical_slice"
  AND b.slice = "otto_vertical_slice"
RETURN "TOTAL" AS relationship_type, count(r) AS count
ORDER BY relationship_type;


// 3. Check all four adaptation categories are represented
MATCH (:Patient {id: "otto"})
-[:HAS_PROFILE]->
(:PatientProfile)
-[:HAS_FACTOR_SCORE]->
(factor:Factor)
-[:ACTIVATES]->
(element:AdaptationElement)
-[:BELONGS_TO]->
(category:AdaptationCategory)
RETURN
  category.name AS adaptation_category,
  count(DISTINCT element) AS activated_elements
ORDER BY category.name;


// 4. Check Otto-specific factor values
MATCH (:Patient {id: "otto"})
-[:HAS_PROFILE]->
(profile:PatientProfile)
-[score:HAS_FACTOR_SCORE]->
(factor:Factor)
RETURN
  factor.id AS factor_id,
  factor.name AS factor,
  score.factor_value AS factor_value,
  score.factor_value_type AS factor_value_type,
  score.evidence_status AS evidence_status,
  score.needs_validation AS needs_validation
ORDER BY factor_id;