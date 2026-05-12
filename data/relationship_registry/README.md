# Relationship Registry

This folder contains structured relationship and adaptation mappings for the HEALIE vertical slices.

For the Otto vertical slice, the registry separates **patient-specific values** from **stable model-level weights**.

## Core distinction

| Field | Meaning | Layer |
|---|---|---|
| `factor_value` | Patient-specific value for a factor, e.g. Otto's `Worry / anxiety = 0.85` or `Health literacy level = low` | Neo4j instance layer |
| `influence_weight` | Stable model-level strength of a `Factor -> HealthLiteracyDimension` relationship | OWL ontology + Neo4j model layer |
| `activation_weight` | Stable model-level strength of a `Factor -> AdaptationElement` relationship | OWL ontology + Neo4j model layer |
| `modification_weight` | Stable model-level strength of an `AdaptationElement -> TextFeature` relationship | OWL ontology + Neo4j model layer |
| `computed_score` | Runtime reasoning score, e.g. `factor_value × activation_weight` | Query/Python reasoning layer |

## File roles

- `otto_profile.yaml`: Otto's patient profile and patient-specific factor values for `HAS_FACTOR_SCORE` relationships.
- `otto_weighted_relationships.csv`: stable model-level `INFLUENCES` relationships from general factors to HEALIE health-literacy dimensions.
- `otto_adaptation_mapping.csv`: stable model-level `ACTIVATES` relationships and their corresponding `MODIFIES` text-feature mappings.

## Naming conventions

Health literacy dimensions must be named:

- `Access`
- `Understand`
- `Appraise`
- `Apply`

Do not use `Accessing`, `Understanding`, `Appraising`, or `Applying` in implementation files.

Factor nodes should be general reusable factors, not value-specific patient states. Use `Worry / anxiety`, not `High worry / anxiety`. The high/low/numeric patient-specific value belongs in `factor_value` on the `HAS_FACTOR_SCORE` relationship.

## Metadata fields

- `evidence_type`: origin of the relationship, e.g. expert mapping, profile definition, inferred factor.
- `evidence_status`: maturity of the evidence, e.g. expert-informed provisional, inferred for vertical slice.
- `validated`: whether the relationship has been formally validated.
- `needs_validation`: whether the relationship requires expert or empirical validation.
- `confidence`: modelling confidence for the current vertical slice.
- `source`: source artifact or modelling decision behind the relationship.

These fields make uncertainty explicit and support later expert validation, sensitivity analysis, and thesis documentation.
