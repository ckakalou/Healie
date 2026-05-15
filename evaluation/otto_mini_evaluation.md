# Otto Mini-Evaluation

# Otto Mini-Evaluation

## 1. Purpose

This mini-evaluation assesses whether the Otto vertical slice demonstrates visible, explainable adaptation of patient-facing medical content.

The evaluation compares three outputs:

1. Generic baseline explanation
2. LLM-only personalised baseline using Otto's factors
3. HEALIE KG-guided explanation using Otto's graph-derived reasoning and adaptation instructions

The main evaluation question is whether the Knowledge Graph adds value beyond simply providing Otto's factors to the LLM.

The goal is not to validate final clinical or psychological effectiveness. The goal is to check whether Otto's weighted Knowledge Graph profile activates concrete content adaptation elements and whether those elements are visible, traceable, and auditable in the generated output.

## 2. Evaluation Conditions

| Condition | Input to model | Purpose |
|---|---|---|
| A. Generic baseline | Controlled CLL facts only | Tests non-personalised patient-facing generation |
| B. LLM-only personalised baseline | Controlled CLL facts + Otto factors | Tests whether patient factors alone lead to good adaptation |
| C. HEALIE KG-guided output | Controlled CLL facts + Otto profile + KG reasoning + adaptation instructions | Tests added value of KG-mediated reasoning |
## 3. Evaluation Scale

| Score | Meaning |
|---:|---|
| 0 | Not present |
| 1 | Weakly present |
| 2 | Clearly present |
| 3 | Strongly present |

## 4. Evaluation Criteria

| Criterion | Generic baseline | LLM-only personalised | HEALIE KG-guided | Notes |
|---|---:|---:|---:|---|
| Uses simplified medical terms |  |  |  |  |
| Explains CLL immediately after naming it |  |  |  |  |
| Includes reassurance |  |  |  |  |
| Positive information appears early |  |  |  |  |
| Uses short sentences |  |  |  |  |
| Avoids dense text blocks |  |  |  |  |
| Uses bullet points |  |  |  |  |
| Repeats key message |  |  |  |  |
| Avoids complex conditionals |  |  |  |  |
| Reduces long subordinate clauses |  |  |  |  |
| Uses stepwise / ordered explanation |  |  |  |  |
| Faithful to controlled clinical facts |  |  |  |  |
| Traceable to explicit adaptation elements |  |  |  |  |
| Covers all four adaptation categories |  |  |  |  |
| Makes adaptation rationale auditable |  |  |  |  |

## 5. KG Value Ablation Interpretation

This evaluation separates two possible sources of personalisation:

1. Personalisation from simply giving the LLM Otto's factors.
2. Personalisation from the KG-mediated reasoning pathway.

The LLM-only personalised baseline tests whether the model can infer appropriate adaptations from patient factors alone.

The HEALIE KG-guided output tests whether explicit graph-derived adaptation instructions improve:

- traceability
- consistency
- coverage of adaptation categories
- auditability
- alignment with expert-informed mappings
- separation between patient-specific values and stable model-level weights

The expected added value of the KG is not only better wording. The expected added value is explainable and repeatable personalisation.

## 6. What the KG Changed Compared with LLM-only Personalisation

| KG factor/value | KG-derived adaptation element | Expected visible change | Present in LLM-only? | Present in KG-guided? |
|---|---|---|---|---|
| Worry / anxiety = 0.85 | Reassurance (it's ok phrases) | Adds a calming sentence |  |  |
| Worry / anxiety = 0.85 | Positive information first | Puts stabilizing information early |  |  |
| Uncertainty = 0.80 | Order of information | Sequences explanation from stabilizing to detailed |  |  |
| Medical knowledge = low | Simplified Medical Terms | Uses “blood cancer” instead of technical terminology |  |  |
| Health literacy level = low | Simplified Language | Uses common words and direct explanations |  |  |
| Health literacy level = low | No conditionals | Avoids complex if-then phrasing |  |  |
| Memory = possible_deficit | Repeat Information | Repeats central message near the end |  |  |
| Memory = possible_deficit | Bullet Points/Lists | Summarizes key information in bullets |  |  |
| Processing speed = possible_deficit | Enumeration (Steps) | Presents information step by step |  |  |
| Educational level = middle_school_graduate | Secondary sentences | Reduces long subordinate clauses |  |  |
| Age = elderly_65_plus | Font Size / readability support | Not directly visible in Markdown; retained as UI/demo requirement |  |  |



