# Relationship Registry

This folder contains structured relationship and adaptation mappings for the HEALIE vertical slices.

For the Otto vertical slice, weights are treated as **expert-informed provisional decision weights**, not as final psychometric or empirically validated coefficients.

## Metadata fields

- `weight` / `activation_weight`: provisional strength of influence or activation.
- `evidence_type`: origin of the relationship, e.g. expert mapping, profile definition, inferred factor.
- `evidence_status`: maturity of the evidence, e.g. expert-informed provisional, inferred for vertical slice.
- `validated`: whether the relationship has been formally validated.
- `needs_validation`: whether the relationship requires expert or empirical validation.
- `confidence`: modelling confidence for the current vertical slice.
- `source`: source artifact or modelling decision behind the relationship.

These fields are included to make uncertainty explicit and to support later expert validation, sensitivity analysis, and thesis documentation.