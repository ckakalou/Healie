# Otto KG-Value Ablation Evaluation

## 1. Purpose

This evaluation assesses whether the HEALIE Knowledge Graph adds value beyond simply providing Otto's patient factors to an LLM.

The comparison is between:

1. **LLM-only personalised baseline**: the model receives Otto's patient factors directly in the prompt, but no graph-derived reasoning, adaptation elements, weights, or text-feature mappings.
2. **HEALIE KG-guided output**: the model receives Otto's patient profile plus graph-derived reasoning, activated adaptation elements, weights, and text-feature mappings.

The main evaluation question is:

> Does the KG-guided condition produce more consistent, traceable, and adaptation-complete patient-facing content than the LLM-only personalised condition?

This evaluation does not claim clinical effectiveness. It evaluates visible adaptation, consistency, traceability, and faithfulness in a prototype vertical slice.

---

## 2. Evaluation Conditions

| Condition | Input to model | Purpose |
|---|---|---|
| LLM-only personalised baseline | Controlled CLL facts + Otto factors | Tests whether the LLM can infer useful adaptations from patient factors alone |
| HEALIE KG-guided output | Controlled CLL facts + Otto profile + graph reasoning + adaptation instructions | Tests the added value of KG-mediated reasoning |

---

## 3. Runs Included

| Run | Folder | LLM-only evaluated | KG-guided evaluated | Notes |
|---:|---|---|---|---|
| 1 | docs/use_cases/otto_outputs/run_... | Yes | Yes |  |
| 2 | docs/use_cases/otto_outputs/run_... | Yes | Yes |  |
| 3 | docs/use_cases/otto_outputs/run_... | Yes | Yes |  |
| 4 | docs/use_cases/otto_outputs/run_... | Yes | Yes |  |
| 5 | docs/use_cases/otto_outputs/run_... | Yes | Yes |  |
| 6 | docs/use_cases/otto_outputs/run_... | Yes | Yes |  |
| 7 | docs/use_cases/otto_outputs/run_... | Yes | Yes |  |
| 8 | docs/use_cases/otto_outputs/run_... | Yes | Yes |  |
| 9 | docs/use_cases/otto_outputs/run_... | Yes | Yes |  |
| 10 | docs/use_cases/otto_outputs/run_... | Yes | Yes |  |

---

## 4. Evaluation Scale

| Score | Meaning |
|---:|---|
| 0 | Not present |
| 1 | Weakly present |
| 2 | Clearly present |
| 3 | Strongly present |

## 5. Run 001 Scoring

Run folder:

```text
docs/use_cases/otto_outputs/run_...

| Criterion                                 | LLM-only personalised | HEALIE KG-guided | Notes |
| ----------------------------------------- | --------------------: | ---------------: | ----- |
| Uses simplified medical terms             |                       |                  |       |
| Explains CLL immediately after naming it  |                       |                  |       |
| Includes reassurance                      |                       |                  |       |
| Positive information appears early        |                       |                  |       |
| Uses short sentences                      |                       |                  |       |
| Avoids dense text blocks                  |                       |                  |       |
| Uses bullet points                        |                       |                  |       |
| Repeats key message                       |                       |                  |       |
| Avoids complex conditionals               |                       |                  |       |
| Reduces long subordinate clauses          |                       |                  |       |
| Uses stepwise / ordered explanation       |                       |                  |       |
| Faithful to controlled clinical facts     |                       |                  |       |
| Traceable to explicit adaptation elements |                       |                  |       |
| Covers all four adaptation categories     |                       |                  |       |
| Makes adaptation rationale auditable      |                       |                  |       |


## 6. Summary Across Runs

| Criterion | LLM-only average | KG-guided average | Difference | Interpretation |
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


## 7. KG-Value Interpretation

The LLM-only personalised condition tests whether Otto's factors alone are sufficient for adaptation. This condition may produce fluent and patient-friendly content because the LLM can infer general simplification and reassurance strategies from the prompt.

However, the HEALIE KG-guided condition is expected to add value by making adaptation:

- explicit
- traceable
- reproducible
- factor-specific
- linked to health-literacy dimensions
- linked to adaptation elements
- linked to text features
- available for expert inspection

Therefore, the KG's value is not evaluated only by whether the final text sounds better. It is evaluated by whether the personalisation process is more explainable, auditable, and consistently aligned with expert-informed mappings.


## 8. Conclusion

Across the archived Otto runs, the LLM-only personalised baseline was able to produce patient-friendly text when given Otto's factors directly. This shows that patient factors alone can guide some degree of useful adaptation.

However, the HEALIE KG-guided condition provides additional value by linking the generated adaptations to an explicit graph-based reasoning pathway. The KG-guided condition makes it possible to inspect which patient factors activated which adaptation elements and which text features were expected to change.

The key contribution of the KG is therefore not only improved wording, but controlled, traceable, auditable, and reusable personalisation.

Further expert evaluation is required to validate the selected factors, weights, adaptation mappings, and clinical appropriateness of the generated outputs.

