# Otto – Vertical Slice
## 1. Purpose of this vertical slice

This vertical slice tests whether HEALIE can use a weighted Health Literacy Knowledge Graph to explainably adapt medical content for one patient profile.

The goal is to demonstrate:

Patient profile → weighted health-literacy factors → activated content adaptation elements → personalized medical explanation

This slice focuses only on Otto. It does not include additional patients, full ontology expansion, user interface development, or complete graph population.

## 2. Patient Profile

| Attribute              | Value                                             |
|------------------------|---------------------------------------------------|
| Patient name           | Otto                                              |
| Age_Group              | Elderly                                           |
| Education              | Middle-school graduate                            |
| Condition              | Chronic Lymphocytic Leukemia (CLL)                |
| Health literacy level  | Low                                               |
| Worry / Anxiety        | High                                              |
| Uncertainty            | High                                              |
| Medical knowledge      | Low                                               |
| Cognitive profile      | Possible memory and processing speed difficulties |
| Main communication need | Understand diagnosis without unnecessary alarm    |

## 3. Health Literacy Challenges

| Health Literacy Dimension | Challenge for Otto | Reason |
|---|---|---|
| Understand | Difficulty understanding medical terminology and dense explanations | Low health literacy, low medical knowledge, education level |
| Understand | Difficulty retaining key information | Possible memory difficulty and older age |
| Understanding | Difficulty processing long or complex explanations | Possible processing speed difficulty |
| Appraise | Difficulty evaluating the seriousness of CLL calmly | High worry / anxiety |
| Appraise | Difficulty interpreting prognosis | High uncertainty |
| Applying | Not the primary focus of this slice | The current slice focuses on understanding and appraising diagnosis information |

## 4. Selected Factors and Weighted Relationships

| Factor                   | Health Literacy Dimension | Weight | Direction | Effect on Health Literacy |
|--------------------------|---|---:|---|---|
| High worry / anxiety     | Appraise | 0.85 | Negative | Makes information feel threatening and harder to evaluate calmly |
| High uncertainty         | Appraise | 0.80 | Negative | Makes prognosis and disease meaning harder to interpret |
| Low health literacy      | Understand | 0.90 | Negative | Reduces ability to understand standard medical explanations |
| Low medical knowledge    | Understand | 0.85 | Negative | Makes technical terminology difficult to process |
| Elderly age 65+          | Understand | 0.65 | Negative | Requires accessibility-oriented presentation |
| Memory deficit           | Understand | 0.75 | Negative | Reduces retention of key information |
| Processing speed deficit | Understand | 0.60 | Negative | Requires slower-paced, stepwise explanations |
| Low educational level    | Understand | 0.70 | Negative | Requires simpler syntax and shorter text blocks |

## 5. Activated Content Adaptation Elements

### 5.1 Content – Good Practices

| Exact adaptation instance | Triggering factor                    | How it should appear in the generated text |
|---|--------------------------------------|---|
| Reassurance (it's ok phrases) | High worry / anxiety                 | Add one calming sentence after explaining the diagnosis |
| Positive information first | High worry / anxiety                 | Mention slow progression / monitoring early |
| Order of information | High anxiety / uncertainty           | Start with stabilizing information, then explain disease details |
| Repeat Information | Memory deficit / low health literacy | Repeat the main message near the end |

### 5.2 Content – Lexical

| Exact adaptation instance | Triggering factor | How it should appear in the generated text |
|---|---|---|
| Simplified Medical Terms | Low medical knowledge | Use “blood cancer” instead of “hematological malignancy” |
| Simplified Language | Low health literacy | Prefer common words and direct explanations |
| Complexity of medical terms | Low health literacy / low medical knowledge | Explain CLL immediately after naming it |

### 5.3 Morphology / Formatting

| Exact adaptation instance | Triggering factor | How it should appear in the generated text |
|---|---|---|
| Font Size | Elderly age 65+ | Demo/output should support larger readable text |
| Text block size | Low health literacy / anxiety / memory difficulty | Use short paragraphs |
| Enumeration (Steps) | Processing speed deficit / memory difficulty | Present key information step by step |
| Bullet Points/Lists | Low health literacy / memory difficulty | Summarize key information as bullets |
| Bold | Memory difficulty / low health literacy | Bold only the most important terms or messages |

### 5.4 Content – Syntax & Grammar

| Exact adaptation instance | Triggering factor | How it should appear in the generated text |
|---|---|---|
| Secondary sentences | Low educational level / low health literacy | Avoid long subordinate clauses |
| No conditionals | Low health literacy / anxiety | Avoid complex “if… then…” constructions where possible |

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

## 8. Reasoning Pathway

This use case demonstrates how HEALIE connects patient-specific factors to concrete text adaptations.

The reasoning pathway is:

| Patient factor                | Health literacy effect | Activated adaptation element | Expected text change |
|-------------------------------|---|---|---|
| High worry / anxiety          | Appraise difficulty | Reassurance (it's ok phrases) | Add a calming sentence |
| High worry / anxiety          | Appraise difficulty | Positive information first | Mention slow progression early |
| High uncertainty              | Appraise difficulty | Order of information | Present stabilizing information before detailed disease information |
| Low medical knowledge         | Understand difficulty | Simplified Medical Terms | Use “blood cancer” instead of “hematological malignancy” |
| Low health literacy           | Understand difficulty | Simplified Language | Use common words and direct explanations |
| Memory deficit                | Understand difficulty | Repeat Information | Repeat the central message near the end |
| Memory deficit                | Understand difficulty | Bullet Points/Lists | Summarize key information in bullets |
| Processing speed deficit      | Understand difficulty | Enumeration (Steps) | Present information step by step |
| Low educational level         | Understand difficulty | Secondary sentences | Avoid long subordinate clauses |
| Low health literacy / anxiety | Understand and Appraise difficulty | No conditionals | Avoid complex conditional structures |

This makes the personalization explainable and traceable through the Knowledge Graph. Each adaptation is not selected generically, but activated by a specific patient factor and connected to a specific health literacy challenge.

## 9. Day 1 Status

### Completed
- Otto profile defined
- Health literacy challenges defined
- Eight weighted factors selected
- Content adaptation elements selected from all four categories
- Before/after example drafted
- Reasoning pathway drafted

### Not included in Day 1
- Neo4j implementation
- Cypher queries
- LangChain pipeline
- Streamlit demo
- Additional patients
- Full ontology redesign

### Open questions
- Weights need expert validation.
- Some cognitive factors are inferred from Otto’s profile and should be validated.
- Morphology/Formatting elements need consistent naming in the final ontology.