# Otto – Vertical Slice

## 1. Purpose of this vertical slice

This vertical slice tests whether HEALIE can use a weighted Health Literacy Knowledge Graph to explainably adapt medical content for one patient profile.

The goal is to demonstrate:

Patient profile → patient-specific factor values → stable weighted HEALIE model relationships → activated content adaptation elements → personalized medical explanation

This slice focuses only on Otto. It does not include additional patients, full ontology expansion, user interface development, or complete graph population.

The slice follows the modelling distinction defined in the final Day 3 graph pattern:

- `factor_value` = Otto-specific value stored on `HAS_FACTOR_SCORE`
- `influence_weight` = stable model-level factor → Health Literacy Dimension weight
- `activation_weight` = stable model-level factor → AdaptationElement weight
- `modification_weight` = stable model-level AdaptationElement → TextFeature weight

---

## 2. Patient Profile

| Attribute | Value |
|---|---|
| Patient name | Otto |
| Age | 75 |
| Age group for reasoning | elderly_65_plus |
| Education | Middle-school graduate |
| Condition | Chronic Lymphocytic Leukemia (CLL) |
| Health literacy level | Low |
| Worry / anxiety | 0.85 / high |
| Uncertainty | 0.80 / high |
| Medical knowledge | Low |
| Cognitive profile | Possible memory and processing speed difficulties |
| Main communication need | Understand diagnosis without unnecessary alarm |

---

## 3. Health Literacy Challenges

| Health Literacy Dimension | Challenge for Otto | Reason |
|---|---|---|
| Understand | Difficulty understanding medical terminology and dense explanations | Low health literacy, low medical knowledge, educational level |
| Understand | Difficulty retaining key information | Possible memory difficulty and older age |
| Understand | Difficulty processing long or complex explanations | Possible processing speed difficulty |
| Appraise | Difficulty evaluating the seriousness of CLL calmly | High worry / anxiety |
| Appraise | Difficulty interpreting prognosis | High uncertainty |
| Apply | Not the primary focus of this slice | The current slice focuses on Understand and Appraise diagnosis information |
| Access | Not the primary focus of this slice | Otto is already given a leaflet; access to information is not the main issue in this slice |

---

## 4. Selected Factors, Patient-Specific Values, and Stable Weighted Relationships

Factor nodes are reusable HEALIE factors. Patient-specific states such as `high`, `low`, or numeric scores are represented as `factor_value` on the `HAS_FACTOR_SCORE` relationship.

| Factor ID | Factor name | Otto factor_value | factor_value_type | Health Literacy Dimension | influence_weight | Direction | Effect on Health Literacy |
|---|---|---|---|---|---:|---|---|
| `worry_anxiety` | Worry / anxiety | 0.85 | numeric | Appraise | 0.85 | Negative | Higher worry makes health information harder to appraise calmly |
| `uncertainty` | Uncertainty | 0.80 | numeric | Appraise | 0.80 | Negative | Higher uncertainty makes prognosis and disease meaning harder to appraise |
| `health_literacy_level` | Health literacy level | low | categorical | Understand | 0.90 | Negative | Lower health literacy reduces ability to understand standard medical explanations |
| `medical_knowledge` | Medical knowledge | low | categorical | Understand | 0.85 | Negative | Lower medical knowledge makes technical terminology harder to understand |
| `age` | Age | elderly_65_plus | categorical | Understand | 0.65 | Negative | Older age group requires accessibility-oriented presentation |
| `memory` | Memory | possible_deficit | inferred_categorical | Understand | 0.75 | Negative | Lower memory capacity reduces retention of key information |
| `processing_speed` | Processing speed | possible_deficit | inferred_categorical | Understand | 0.60 | Negative | Lower processing speed requires slower-paced stepwise explanations |
| `educational_level` | Educational level | middle_school_graduate | categorical | Understand | 0.70 | Negative | Lower educational level requires simpler syntax and shorter text blocks |

---

## 5. Activated Content Adaptation Elements

The adaptation elements are stable HEALIE model instances. They are not Otto-specific. Otto activates them through his patient-specific factor values and the stable model-level `ACTIVATES` relationships.

### 5.1 Content – Good Practices

| Adaptation element ID | Exact adaptation instance | Triggering factor | activation_weight | TextFeature | How it should appear in the generated text |
|---|---|---|---:|---|---|
| `reassurance_its_ok_phrases` | Reassurance (it's ok phrases) | Worry / anxiety | 0.85 | Emotional framing | Add one calming sentence after explaining the diagnosis |
| `positive_information_first` | Positive information first | Worry / anxiety | 0.85 | Positive framing | Mention slow progression / monitoring early |
| `order_of_information` | Order of information | Uncertainty | 0.80 | Information order | Start with stabilizing information, then explain disease details |
| `repeat_information` | Repeat Information | Memory | 0.75 | Information repetition | Repeat the main message near the end |

### 5.2 Content – Lexical

| Adaptation element ID | Exact adaptation instance | Triggering factor | activation_weight | TextFeature | How it should appear in the generated text |
|---|---|---|---:|---|---|
| `simplified_medical_terms` | Simplified Medical Terms | Medical knowledge | 0.85 | Terminology complexity | Use “blood cancer” instead of “hematological malignancy” |
| `simplified_language` | Simplified Language | Health literacy level | 0.90 | Language complexity | Prefer common words and direct explanations |
| `complexity_of_medical_terms` | Complexity of medical terms | Health literacy level | 0.90 | Term explanation | Explain CLL immediately after naming it |

### 5.3 Morphology / Formatting

| Adaptation element ID | Exact adaptation instance | Triggering factor | activation_weight | TextFeature | How it should appear in the generated text |
|---|---|---|---:|---|---|
| `font_size` | Font Size | Age | 0.65 | Visual accessibility | Demo/output should support larger readable text |
| `text_block_size` | Text block size | Health literacy level | 0.90 | Paragraph density | Use short paragraphs |
| `enumeration_steps` | Enumeration (Steps) | Processing speed | 0.60 | Sequential structure | Present key information step by step |
| `bullet_points_lists` | Bullet Points/Lists | Memory | 0.75 | List structure | Summarize key information as bullets |
| `bold` | Bold | Memory | 0.75 | Emphasis | Bold only the most important terms or messages |

### 5.4 Content – Syntax & Grammar

| Adaptation element ID | Exact adaptation instance | Triggering factor | activation_weight | TextFeature | How it should appear in the generated text |
|---|---|---|---:|---|---|
| `secondary_sentences` | Secondary sentences | Educational level | 0.70 | Sentence complexity | Avoid long subordinate clauses |
| `no_conditionals` | No conditionals | Health literacy level / Worry / anxiety | 0.90 / 0.85 | Conditional complexity | Avoid complex “if… then…” constructions where possible |

---

## 6. Expected Output Behaviour

For Otto, HEALIE should:

- Start with a reassuring, stabilizing explanation.
- Explain CLL as a type of blood cancer.
- Avoid dense medical terminology.
- Use short sentences.
- Use short paragraphs.
- Use bullet points for key information.
- Repeat the central message once.
- Avoid unnecessarily alarming phrasing.
- Avoid complex conditional sentences.
- Support larger readable font in the demo.

---

## 7. Example Transformation

### Generic medical content

Chronic Lymphocytic Leukemia (CLL) is a hematological malignancy characterized by the accumulation of abnormal lymphocytes. Disease progression varies, and treatment initiation depends on symptoms, blood markers, and clinical staging.

### HEALIE-adapted content for Otto

You have Chronic Lymphocytic Leukemia, or CLL.

CLL is a type of blood cancer. It often grows slowly. Many people live with CLL for many years and have regular check-ups with their doctor.

It is normal to feel worried when you hear the word leukemia. Your doctor will monitor your condition and explain each step clearly.

The most important things to remember are:

- CLL affects a type of white blood cell.
- It often grows slowly.
- You may not need treatment right away.
- Your doctor will check your blood regularly.

The key message is this: CLL often grows slowly, and your doctor will follow it carefully.

---

## 8. Reasoning Pathway

This use case demonstrates how HEALIE connects patient-specific factor values to stable model-level relationships and concrete text adaptations.

| Patient-specific factor value | Stable health-literacy effect | Activated adaptation element | Expected text change |
|---|---|---|---|
| Otto has Worry / anxiety = 0.85 | Worry / anxiety influences Appraise | Reassurance (it's ok phrases) | Add a calming sentence |
| Otto has Worry / anxiety = 0.85 | Worry / anxiety influences Appraise | Positive information first | Mention slow progression early |
| Otto has Uncertainty = 0.80 | Uncertainty influences Appraise | Order of information | Present stabilizing information before detailed disease information |
| Otto has Medical knowledge = low | Medical knowledge influences Understand | Simplified Medical Terms | Use “blood cancer” instead of “hematological malignancy” |
| Otto has Health literacy level = low | Health literacy level influences Understand | Simplified Language | Use common words and direct explanations |
| Otto has Memory = possible_deficit | Memory influences Understand | Repeat Information | Repeat the central message near the end |
| Otto has Memory = possible_deficit | Memory influences Understand | Bullet Points/Lists | Summarize key information in bullets |
| Otto has Processing speed = possible_deficit | Processing speed influences Understand | Enumeration (Steps) | Present information step by step |
| Otto has Educational level = middle_school_graduate | Educational level influences Understand | Secondary sentences | Avoid long subordinate clauses |
| Otto has Health literacy level = low and Worry / anxiety = 0.85 | Health literacy level influences Understand; Worry / anxiety influences Appraise | No conditionals | Avoid complex conditional structures |

This makes the personalization explainable and traceable through the Knowledge Graph. Each adaptation is not selected generically, but activated by a specific patient factor value and connected to a stable HEALIE model relationship.

---

## 9. Day 1 Status

### Completed

- Otto profile defined.
- Health literacy challenges defined using `Access`, `Understand`, `Appraise`, and `Apply` naming.
- Eight reusable factors selected.
- Patient-specific factor values separated from stable influence weights.
- Content adaptation elements selected from all four categories.
- Before/after example drafted.
- Reasoning pathway drafted.

### Not included in Day 1

- Neo4j implementation.
- Cypher queries.
- LangChain pipeline.
- Streamlit demo.
- Additional patients.
- Full ontology redesign.

### Open questions

- Weights need expert validation.
- Memory and processing speed are inferred factors and should be validated.
- Morphology / Formatting elements need consistent naming in the final ontology.
