# Otto Cypher ↔ Graph Pattern Cross-Reference

This document cross-checks `create_otto_slice_crosschecked.cypher` against `otto_neo4j_graph_pattern.md`.

## 1. Node Labels

| Graph pattern requirement | Expected count | Included in Cypher | Notes |
|---|---:|---|---|
| `Patient` | 1 | ✅ | `otto` |
| `PatientProfile` | 1 | ✅ | `otto_profile` |
| `ClinicalCondition` | 1 | ✅ | `cll` |
| `HealthLiteracyDimension` | 4 | ✅ | `Access`, `Understand`, `Appraise`, `Apply` |
| `Factor` | 8 | ✅ | General reusable factors, not value-specific states |
| `AdaptationCategory` | 4 | ✅ | All four categories included |
| `AdaptationElement` | 14 | ✅ | All exact adaptation instances included |
| `TextFeature` | 14 | ✅ | All text features included |

Expected total nodes: **47**.

## 2. Relationship Types

| Graph pattern requirement | Expected count | Included in Cypher | Notes |
|---|---:|---|---|
| `HAS_PROFILE` | 1 | ✅ | Otto → Otto profile |
| `HAS_CONDITION` | 1 | ✅ | Otto profile → CLL |
| `HAS_FACTOR_SCORE` | 8 | ✅ | Otto-specific factor values only |
| `INFLUENCES` | 8 | ✅ | Stable factor → HL dimension weights |
| `ACTIVATES` | 15 | ✅ | Stable factor → adaptation activation weights |
| `BELONGS_TO` | 14 | ✅ | Every adaptation element linked to category |
| `MODIFIES` | 15 | ✅ | Includes one multi-feature adaptation: `bullet_points_lists` → `list_structure` and `paragraph_density` |

Expected total relationships: **62**.

## 3. Weight / Value Distinction

| Property | Layer | Included in Cypher | Notes |
|---|---|---|---|
| `factor_value` | Patient instance layer | ✅ | Stored only on `HAS_FACTOR_SCORE` |
| `factor_value_type` | Patient instance layer | ✅ | `numeric`, `categorical`, `inferred_categorical` |
| `influence_weight` | Stable ontology/model layer | ✅ | Stored only on `INFLUENCES` |
| `activation_weight` | Stable ontology/model layer | ✅ | Stored only on `ACTIVATES` |
| `modification_weight` | Stable ontology/model layer | ✅ | Stored on all `MODIFIES` relationships |


## 4. Validation Queries

After running the Cypher script, run:

```cypher
MATCH (n)
WHERE n.slice = "otto_vertical_slice"
WITH labels(n) AS labels, count(n) AS count
RETURN labels, count
UNION ALL
MATCH (n)
WHERE n.slice = "otto_vertical_slice"
RETURN ["TOTAL"] AS labels, count(n) AS count
ORDER BY labels;
```

Expected nodes:

```text
AdaptationCategory: 4
AdaptationElement: 14
ClinicalCondition: 1
Factor: 8
HealthLiteracyDimension: 4
Patient: 1
PatientProfile: 1
TextFeature: 14
Total nodes: 47
```

Then run:

```cypher
MATCH (a)-[r]->(b)
WHERE a.slice = "otto_vertical_slice"
  AND b.slice = "otto_vertical_slice"
RETURN type(r) AS relationship_type, count(r) AS count
UNION ALL
MATCH (a)-[r]->(b)
WHERE a.slice = "otto_vertical_slice"
  AND b.slice = "otto_vertical_slice"
RETURN "TOTAL" AS relationship_type, count(r) AS count
ORDER BY relationship_type;
```

Expected relationships:

```text
ACTIVATES: 15
BELONGS_TO: 14
HAS_CONDITION: 1
HAS_FACTOR_SCORE: 8
HAS_PROFILE: 1
INFLUENCES: 8
MODIFIES: 15
Total relationships: 62
```
