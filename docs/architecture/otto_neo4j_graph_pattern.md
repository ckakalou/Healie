# Otto Neo4j Graph Pattern

## 1. Purpose

This document defines the Neo4j graph pattern for the Otto vertical slice.

The purpose of this graph pattern is to translate the Otto specifications into an executable graph structure that can support:

- patient profile representation
- patient-specific factor values
- stable weighted health-literacy relationships
- activation of exact content adaptation elements
- Cypher retrieval
- graph-based reasoning
- prompt construction for personalised content generation

This pattern is intentionally limited to the Otto vertical slice. It is not the final full HEALIE ontology.

However, the graph pattern is designed to remain aligned with the future HEALIE OWL ontology. The OWL ontology will contain the reusable HEALIE model: general classes, stable health-literacy dimensions, stable content adaptation categories and instances, stable factor-to-dimension relationships, stable factor-to-adaptation relationships, stable adaptation-to-text-feature relationships, and their model-level weights and evidence metadata.

Neo4j will contain the executable instantiation of this model for concrete use cases such as Otto.

---

## 2. Design Principle

The graph is designed to preserve **explainability**.

The main modelling principle is to separate:

1. **Stable HEALIE model knowledge**, which belongs to the ontology/model layer.
2. **Patient-specific instance values**, which belong to the Neo4j instance layer.

### 2.1 Layer distinction

#### Instance layer

The instance layer represents Otto and his patient-specific values:

```text
Patient → PatientProfile → Factor with patient-specific factor_value
```

Example:

```text
(:Patient {id: "otto"})
-[:HAS_PROFILE]->
(:PatientProfile {id: "otto_profile"})
-[:HAS_FACTOR_SCORE {factor_value: 0.85}]->
(:Factor {id: "worry_anxiety", name: "Worry / anxiety"})
```

#### Stable model layer

The stable model layer represents reusable HEALIE knowledge:

```text
Factor → HealthLiteracyDimension
Factor → AdaptationElement
AdaptationElement → AdaptationCategory
AdaptationElement → TextFeature
```

Example:

```text
(:Factor {id: "worry_anxiety", name: "Worry / anxiety"})
-[:INFLUENCES {influence_weight: 0.85}]->
(:HealthLiteracyDimension {id: "appraise", name: "Appraise"})
```

and:

```text
(:Factor {id: "worry_anxiety", name: "Worry / anxiety"})
-[:ACTIVATES {activation_weight: 0.85}]->
(:AdaptationElement {id: "reassurance_its_ok_phrases", name: "Reassurance (it's ok phrases)"})
-[:BELONGS_TO]->
(:AdaptationCategory {id: "content_good_practices", name: "Content - Good Practices"})
```

### 2.2 Core traceability path

Each content adaptation should be traceable through the following pathway:

```text
Patient
→ PatientProfile
→ HAS_FACTOR_SCORE with patient-specific factor_value
→ Factor
→ stable INFLUENCES relationship to HealthLiteracyDimension
→ stable ACTIVATES relationship to AdaptationElement
→ AdaptationCategory
→ TextFeature
```

The graph should not connect a patient or factor only to a broad category such as `Content - Good Practices` or `Content - Lexical`.

The graph must connect each factor to an exact adaptation instance.

Correct pattern:

```text
(:Factor {id: "worry_anxiety", name: "Worry / anxiety"})
-[:ACTIVATES]->
(:AdaptationElement {id: "reassurance_its_ok_phrases", name: "Reassurance (it's ok phrases)"})
-[:BELONGS_TO]->
(:AdaptationCategory {id: "content_good_practices", name: "Content - Good Practices"})
```

Incorrect pattern:

```text
(:Factor {id: "worry_anxiety", name: "Worry / anxiety"})
-[:ACTIVATES]->
(:AdaptationCategory {name: "Content - Good Practices"})
```

The first pattern is preferred because it allows HEALIE to explain which exact adaptation was selected and why.

---

## 3. Node Labels

The Otto vertical slice uses eight main Neo4j node labels.

| Node Label | Purpose | Example |
|---|---|---|
| `Patient` | Represents the individual patient/use-case entity | Otto |
| `PatientProfile` | Represents Otto's structured profile for this slice | otto_profile |
| `ClinicalCondition` | Represents the clinical condition associated with the profile | Chronic Lymphocytic Leukemia |
| `Factor` | Represents a reusable health-literacy-relevant factor | Worry / anxiety |
| `HealthLiteracyDimension` | Represents a stable health-literacy dimension | Understand, Appraise |
| `AdaptationElement` | Represents the exact content adaptation instance to activate | Reassurance (it's ok phrases) |
| `AdaptationCategory` | Groups adaptation elements into broader categories | Content - Good Practices |
| `TextFeature` | Represents the generated text feature modified by an adaptation | Emotional framing, Terminology complexity |

### Node modelling note

`AdaptationCategory` nodes should not be used directly for reasoning. They are used for grouping and evaluation.

The reasoning should happen at the level of `AdaptationElement`, because this is where the exact content adaptation is represented.

`Factor` nodes should be general reusable factors, not value-specific patient states. For example, use `Worry / anxiety`, not `High worry / anxiety`. Otto's high worry score is represented as a property on the `HAS_FACTOR_SCORE` relationship.

---

## 3.1 Otto Node Instances

### Patient and Profile

| Label | ID | Name |
|---|---|---|
| `Patient` | `otto` | Otto |
| `PatientProfile` | `otto_profile` | Otto profile |

### Clinical Condition

| Label | ID | Name | Abbreviation |
|---|---|---|---|
| `ClinicalCondition` | `cll` | Chronic Lymphocytic Leukemia | CLL |

### Health Literacy Dimensions

The HEALIE ontology and Neo4j graph must use the following dimension names consistently:

| Correct HEALIE dimension |
|---|
| `Access` |
| `Understand` | 
| `Appraise` |
| `Apply` | 

For the Otto vertical slice, the active dimensions are:

| Label | ID | Name |
|---|---|---|
| `HealthLiteracyDimension` | `understand` | Understand |
| `HealthLiteracyDimension` | `appraise` | Appraise |

The health literacy dimensions `Access` and `Apply` are not active in this vertical slice because Otto's current use case focuses on understanding and appraising diagnosis information.

### Factors

Factor nodes represent reusable HEALIE factors. Patient-specific values such as high, low, or numeric scores are stored on the `HAS_FACTOR_SCORE` relationship.

| Label | ID | Name |
|---|---|---|
| `Factor` | `worry_anxiety` | Worry / anxiety |
| `Factor` | `uncertainty` | Uncertainty |
| `Factor` | `health_literacy_level` | Health literacy level |
| `Factor` | `medical_knowledge` | Medical knowledge |
| `Factor` | `age` | Age |
| `Factor` | `memory` | Memory |
| `Factor` | `processing_speed` | Processing speed |
| `Factor` | `educational_level` | Educational level |

### Adaptation Categories

| Label | ID | Name |
|---|---|---|
| `AdaptationCategory` | `content_good_practices` | Content - Good Practices |
| `AdaptationCategory` | `content_lexical` | Content - Lexical |
| `AdaptationCategory` | `morphology_formatting` | Morphology / Formatting |
| `AdaptationCategory` | `content_syntax_grammar` | Content - Syntax & Grammar |

### Adaptation Elements

Adaptation elements are stable reusable HEALIE adaptation instances. They should exist in the OWL ontology and be imported or mirrored in Neo4j.

| Adaptation Category | Adaptation Element ID | Adaptation Element Name |
|---|---|---|
| Content - Good Practices | `reassurance_its_ok_phrases` | Reassurance (it's ok phrases) |
| Content - Good Practices | `positive_information_first` | Positive information first |
| Content - Good Practices | `order_of_information` | Order of information |
| Content - Good Practices | `repeat_information` | Repeat Information |
| Content - Lexical | `simplified_medical_terms` | Simplified Medical Terms |
| Content - Lexical | `simplified_language` | Simplified Language |
| Content - Lexical | `complexity_of_medical_terms` | Complexity of medical terms |
| Morphology / Formatting | `font_size` | Font Size |
| Morphology / Formatting | `text_block_size` | Text block size |
| Morphology / Formatting | `enumeration_steps` | Enumeration (Steps) |
| Morphology / Formatting | `bullet_points_lists` | Bullet Points/Lists |
| Morphology / Formatting | `bold` | Bold |
| Content - Syntax & Grammar | `secondary_sentences` | Secondary sentences |
| Content - Syntax & Grammar | `no_conditionals` | No conditionals |

### Text Features

| Label | ID | Name |
|---|---|---|
| `TextFeature` | `emotional_framing` | Emotional framing |
| `TextFeature` | `positive_framing` | Positive framing |
| `TextFeature` | `information_order` | Information order |
| `TextFeature` | `information_repetition` | Information repetition |
| `TextFeature` | `terminology_complexity` | Terminology complexity |
| `TextFeature` | `language_complexity` | Language complexity |
| `TextFeature` | `term_explanation` | Term explanation |
| `TextFeature` | `visual_accessibility` | Visual accessibility |
| `TextFeature` | `paragraph_density` | Paragraph density |
| `TextFeature` | `sequential_structure` | Sequential structure |
| `TextFeature` | `list_structure` | List structure |
| `TextFeature` | `emphasis` | Emphasis |
| `TextFeature` | `sentence_complexity` | Sentence complexity |
| `TextFeature` | `conditional_complexity` | Conditional complexity |

---

## 4. Relationship Types

The Otto graph uses seven relationship types.

| Relationship Type | Source → Target | Layer | Purpose |
|---|---|---|---|
| `HAS_PROFILE` | `Patient` → `PatientProfile` | Instance layer | Connects Otto to his structured profile |
| `HAS_CONDITION` | `PatientProfile` → `ClinicalCondition` | Instance layer | Connects Otto's profile to his clinical condition |
| `HAS_FACTOR_SCORE` | `PatientProfile` → `Factor` | Instance layer | Stores Otto-specific value for a factor |
| `INFLUENCES` | `Factor` → `HealthLiteracyDimension` | Stable ontology/model layer | Represents stable weighted influence on a health-literacy dimension |
| `ACTIVATES` | `Factor` → `AdaptationElement` | Stable ontology/model layer | Represents stable activation of an exact content adaptation |
| `BELONGS_TO` | `AdaptationElement` → `AdaptationCategory` | Stable ontology/model layer | Groups adaptation elements under their category |
| `MODIFIES` | `AdaptationElement` → `TextFeature` | Stable ontology/model layer | Shows which feature of the generated text is modified |

Relationship direction is chosen to support retrieval and explanation.

The main reasoning flow is:

```text
Patient → PatientProfile → ClinicalCondition
PatientProfile → Factor with factor_value
Factor → HealthLiteracyDimension through stable INFLUENCES relationship
Factor → AdaptationElement through stable ACTIVATES relationship
AdaptationElement → AdaptationCategory
AdaptationElement → TextFeature
```

---

## 5. Relationship Properties

This section defines which properties should be stored on each relationship type in the Otto Neo4j graph.

Relationship properties are used to preserve:

- patient-specific factor values
- stable influence weights
- stable adaptation activation weights
- stable text-feature modification information
- evidence metadata
- validation status
- human-readable explanations

These properties allow the graph to support both machine retrieval and human explanation.

---

### 5.1 `HAS_PROFILE`

Connects Otto to his structured profile.

Pattern:

```text
(:Patient)-[:HAS_PROFILE]->(:PatientProfile)
```

Properties:

| Property | Data type | Meaning | Example |
|---|---|---|---|
| `status` | string | Optional modelling status | `active` |

Example:

```cypher
(:Patient {id: "otto", name: "Otto"})
-[:HAS_PROFILE {status: "active"}]->
(:PatientProfile {id: "otto_profile", name: "Otto profile"})
```

---

### 5.2 `HAS_CONDITION`

Connects Otto's profile to the clinical condition used in the vertical slice.

Pattern:

```text
(:PatientProfile)-[:HAS_CONDITION]->(:ClinicalCondition)
```

Properties:

| Property | Data type | Meaning | Example |
|---|---|---|---|
| `status` | string | Optional modelling status | `active` |
| `evidence_status` | string | Whether this condition is defined, inferred, or validated | `defined_in_use_case` |

Example:

```cypher
(:PatientProfile {id: "otto_profile"})
-[:HAS_CONDITION {
  status: "active",
  evidence_status: "defined_in_use_case"
}]->
(:ClinicalCondition {id: "cll", name: "Chronic Lymphocytic Leukemia", abbreviation: "CLL"})
```

---

### 5.3 `HAS_FACTOR_SCORE`

Connects Otto's profile to the factors that are relevant for the vertical slice and stores Otto-specific values.

Pattern:

```text
(:PatientProfile)-[:HAS_FACTOR_SCORE]->(:Factor)
```

Properties:

| Property | Data type | Meaning | Example |
|---|---|---|---|
| `factor_value` | float/string | Patient-specific value for the factor | `0.85`, `low`, `middle_school_graduate` |
| `factor_value_type` | string | Type of value | `numeric`, `categorical`, `inferred_categorical` |
| `evidence_status` | string | Whether this value is defined, inferred, or validated | `defined_in_use_case` |
| `needs_validation` | boolean | Whether the factor value requires expert validation | `true` |
| `notes` | string | Human-readable modelling note | `Otto's worry score for the vertical slice` |

Example:

```cypher
(:PatientProfile {id: "otto_profile"})
-[:HAS_FACTOR_SCORE {
  factor_value: 0.85,
  factor_value_type: "numeric",
  evidence_status: "defined_in_use_case",
  needs_validation: false,
  notes: "Otto's worry score for the vertical slice"
}]->
(:Factor {id: "worry_anxiety", name: "Worry / anxiety"})
```

---

### 5.4 `INFLUENCES`

Represents how a reusable HEALIE factor influences a health-literacy dimension.

This is a stable ontology/model-layer relationship. It is not Otto-specific.

Pattern:

```text
(:Factor)-[:INFLUENCES]->(:HealthLiteracyDimension)
```

Properties:

| Property | Data type | Meaning | Example |
|---|---|---|---|
| `influence_weight` | float | Stable model-level influence strength | `0.85` |
| `direction` | string | Direction of effect | `negative` |
| `effect` | string | Human-readable explanation of influence | `Higher worry makes health information harder to appraise calmly` |
| `evidence_type` | string | Origin of relationship | `expert_mapping` |
| `evidence_status` | string | Maturity of evidence | `expert_informed_provisional` |
| `source` | string | Source artifact or modelling source | `expert_selection_workbook` |
| `validated` | boolean | Whether formally validated | `false` |
| `needs_validation` | boolean | Whether validation is needed | `true` |
| `confidence` | integer | Modelling confidence for this slice | `7` |

Example:

```cypher
(:Factor {id: "worry_anxiety", name: "Worry / anxiety"})
-[:INFLUENCES {
  influence_weight: 0.85,
  direction: "negative",
  effect: "Higher worry makes health information harder to appraise calmly",
  evidence_type: "expert_mapping",
  evidence_status: "expert_informed_provisional",
  source: "expert_selection_workbook",
  validated: false,
  needs_validation: true,
  confidence: 7
}]->
(:HealthLiteracyDimension {id: "appraise", name: "Appraise"})
```

---

### 5.5 `ACTIVATES`

Represents which exact content adaptation element is activated by a reusable HEALIE factor.

This is a stable ontology/model-layer relationship. It is not Otto-specific.

Pattern:

```text
(:Factor)-[:ACTIVATES]->(:AdaptationElement)
```

Properties:

| Property | Data type | Meaning | Example |
|---|---|---|---|
| `activation_weight` | float | Stable model-level strength of adaptation activation | `0.85` |
| `text_effect` | string | Expected effect on generated text | `Add one calming sentence after explaining the diagnosis` |
| `evidence_type` | string | Origin of adaptation mapping | `expert_mapping` |
| `evidence_status` | string | Maturity of evidence | `expert_informed_provisional` |
| `source` | string | Source artifact or modelling source | `expert_selection_workbook` |
| `validated` | boolean | Whether formally validated | `false` |
| `needs_validation` | boolean | Whether validation is needed | `true` |
| `confidence` | integer | Modelling confidence for this slice | `8` |

Example:

```cypher
(:Factor {id: "worry_anxiety", name: "Worry / anxiety"})
-[:ACTIVATES {
  activation_weight: 0.85,
  text_effect: "Add one calming sentence after explaining the diagnosis",
  evidence_type: "expert_mapping",
  evidence_status: "expert_informed_provisional",
  source: "expert_selection_workbook",
  validated: false,
  needs_validation: true,
  confidence: 8
}]->
(:AdaptationElement {id: "reassurance_its_ok_phrases", name: "Reassurance (it's ok phrases)"})
```

---

### 5.6 `BELONGS_TO`

Connects an exact adaptation element to its broader category.

This is a stable ontology/model-layer relationship and does not require weights.

Pattern:

```text
(:AdaptationElement)-[:BELONGS_TO]->(:AdaptationCategory)
```

Properties:

| Property | Data type | Meaning | Example |
|---|---|---|---|
| `status` | string | Optional modelling status | `active` |

Example:

```cypher
(:AdaptationElement {id: "reassurance_its_ok_phrases", name: "Reassurance (it's ok phrases)"})
-[:BELONGS_TO {status: "active"}]->
(:AdaptationCategory {id: "content_good_practices", name: "Content - Good Practices"})
```

---

### 5.7 `MODIFIES`

Shows which aspect of the generated text is modified by an adaptation element.

This is a stable ontology/model-layer relationship.

Pattern:

```text
(:AdaptationElement)-[:MODIFIES]->(:TextFeature)
```

Properties:

| Property | Data type | Meaning | Example |
|---|---|---|---|
| `modification_type` | string | Type of text modification | `emotional_framing` |
| `description` | string | Human-readable explanation | `Adds reassurance to reduce unnecessary alarm` |
| `modification_weight` | float | Optional stable model-level strength of adaptation effect on the text feature | `0.90` |

Example:

```cypher
(:AdaptationElement {id: "reassurance_its_ok_phrases", name: "Reassurance (it's ok phrases)"})
-[:MODIFIES {
  modification_type: "emotional_framing",
  description: "Adds reassurance to reduce unnecessary alarm",
  modification_weight: 0.90
}]->
(:TextFeature {id: "emotional_framing", name: "Emotional framing"})
```

---

## 6. Example Otto Paths

This section documents example reasoning paths for the Otto vertical slice.

Each path shows how a patient-specific factor value connects to:

1. a stable health-literacy influence relationship,
2. an exact activated adaptation element,
3. a text-level modification.

The examples are graph-pattern examples, not final Cypher queries.

---

### 6.1 Path 1 — Otto's worry/anxiety value activates reassurance

#### Path 1-a: Patient-specific factor value and stable health-literacy influence path

```text
(:Patient {id: "otto"})
-[:HAS_PROFILE]->
(:PatientProfile {id: "otto_profile"})
-[:HAS_FACTOR_SCORE {
  factor_value: 0.85,
  factor_value_type: "numeric",
  evidence_status: "defined_in_use_case",
  needs_validation: false
}]->
(:Factor {id: "worry_anxiety", name: "Worry / anxiety"})
-[:INFLUENCES {
  influence_weight: 0.85,
  direction: "negative",
  effect: "Higher worry makes health information harder to appraise calmly"
}]->
(:HealthLiteracyDimension {id: "appraise", name: "Appraise"})
```

#### Path 1-b: Stable adaptation activation path

```text
(:Factor {id: "worry_anxiety", name: "Worry / anxiety"})
-[:ACTIVATES {
  activation_weight: 0.85,
  text_effect: "Add one calming sentence after explaining the diagnosis"
}]->
(:AdaptationElement {id: "reassurance_its_ok_phrases", name: "Reassurance (it's ok phrases)"})
-[:BELONGS_TO]->
(:AdaptationCategory {id: "content_good_practices", name: "Content - Good Practices"})
```

#### Path 1-c: Stable text-feature modification path

```text
(:AdaptationElement {id: "reassurance_its_ok_phrases", name: "Reassurance (it's ok phrases)"})
-[:MODIFIES {
  modification_type: "emotional_framing",
  description: "Adds reassurance to reduce unnecessary alarm",
  modification_weight: 0.90
}]->
(:TextFeature {id: "emotional_framing", name: "Emotional framing"})
```

#### Path 1: Expected generated text-effect

_It is normal to feel worried when you hear the word leukemia._

---

### 6.2 Path 2 — Otto's uncertainty value activates ordered explanation

#### Path 2-a: Patient-specific factor value and stable health-literacy influence path

```text
(:PatientProfile {id: "otto_profile"})
-[:HAS_FACTOR_SCORE {
  factor_value: 0.80,
  factor_value_type: "numeric",
  evidence_status: "defined_in_use_case",
  needs_validation: false
}]->
(:Factor {id: "uncertainty", name: "Uncertainty"})
-[:INFLUENCES {
  influence_weight: 0.80,
  direction: "negative",
  effect: "Higher uncertainty makes prognosis and disease meaning harder to appraise"
}]->
(:HealthLiteracyDimension {id: "appraise", name: "Appraise"})
```

#### Path 2-b: Stable adaptation activation path

```text
(:Factor {id: "uncertainty", name: "Uncertainty"})
-[:ACTIVATES {
  activation_weight: 0.80,
  text_effect: "Start with stabilizing information then explain disease details"
}]->
(:AdaptationElement {id: "order_of_information", name: "Order of information"})
-[:BELONGS_TO]->
(:AdaptationCategory {id: "content_good_practices", name: "Content - Good Practices"})
```

#### Path 2-c: Stable text-feature modification path

```text
(:AdaptationElement {id: "order_of_information", name: "Order of information"})
-[:MODIFIES {
  modification_type: "information_order",
  description: "Places stabilizing information before detailed disease information",
  modification_weight: 0.85
}]->
(:TextFeature {id: "information_order", name: "Information order"})
```

#### Path 2: Expected generated text-effect

_CLL often grows slowly. Many people live with CLL for many years and have regular check-ups with their doctor._

---

### 6.3 Path 3 — Otto's medical knowledge value activates simplified medical terms

#### Path 3-a: Patient-specific factor value and stable health-literacy influence path

```text
(:PatientProfile {id: "otto_profile"})
-[:HAS_FACTOR_SCORE {
  factor_value: "low",
  factor_value_type: "categorical",
  evidence_status: "defined_in_use_case",
  needs_validation: false
}]->
(:Factor {id: "medical_knowledge", name: "Medical knowledge"})
-[:INFLUENCES {
  influence_weight: 0.85,
  direction: "negative",
  effect: "Lower medical knowledge makes technical terminology harder to understand"
}]->
(:HealthLiteracyDimension {id: "understand", name: "Understand"})
```

#### Path 3-b: Stable adaptation activation path

```text
(:Factor {id: "medical_knowledge", name: "Medical knowledge"})
-[:ACTIVATES {
  activation_weight: 0.85,
  text_effect: "Use blood cancer instead of hematological malignancy"
}]->
(:AdaptationElement {id: "simplified_medical_terms", name: "Simplified Medical Terms"})
-[:BELONGS_TO]->
(:AdaptationCategory {id: "content_lexical", name: "Content - Lexical"})
```

#### Path 3-c: Stable text-feature modification path

```text
(:AdaptationElement {id: "simplified_medical_terms", name: "Simplified Medical Terms"})
-[:MODIFIES {
  modification_type: "lexical_simplification",
  description: "Replaces complex medical terms with patient-friendly alternatives",
  modification_weight: 0.90
}]->
(:TextFeature {id: "terminology_complexity", name: "Terminology complexity"})
```

#### Path 3: Expected generated text-effect

_CLL is a type of blood cancer._ instead of _CLL is a hematological malignancy._

---

### 6.4 Path 4 — Otto's memory value activates repetition and bullet points

#### Path 4-a: Patient-specific factor value and stable health-literacy influence path

```text
(:PatientProfile {id: "otto_profile"})
-[:HAS_FACTOR_SCORE {
  factor_value: "possible_deficit",
  factor_value_type: "inferred_categorical",
  evidence_status: "inferred_for_vertical_slice",
  needs_validation: true
}]->
(:Factor {id: "memory", name: "Memory"})
-[:INFLUENCES {
  influence_weight: 0.75,
  direction: "negative",
  effect: "Lower memory capacity reduces retention of key information"
}]->
(:HealthLiteracyDimension {id: "understand", name: "Understand"})
```

#### Path 4-b-1: Stable adaptation activation path A — Repeat Information

```text
(:Factor {id: "memory", name: "Memory"})
-[:ACTIVATES {
  activation_weight: 0.75,
  text_effect: "Repeat the main message near the end"
}]->
(:AdaptationElement {id: "repeat_information", name: "Repeat Information"})
-[:BELONGS_TO]->
(:AdaptationCategory {id: "content_good_practices", name: "Content - Good Practices"})
```

#### Path 4-b-2: Stable adaptation activation path B — Bullet points

```text
(:Factor {id: "memory", name: "Memory"})
-[:ACTIVATES {
  activation_weight: 0.75,
  text_effect: "Summarize key information as bullet points"
}]->
(:AdaptationElement {id: "bullet_points_lists", name: "Bullet Points/Lists"})
-[:BELONGS_TO]->
(:AdaptationCategory {id: "morphology_formatting", name: "Morphology / Formatting"})
```

#### Path 4-c: Stable text-feature modification paths

```text
(:AdaptationElement {id: "repeat_information", name: "Repeat Information"})
-[:MODIFIES {
  modification_type: "information_repetition",
  description: "Repeats the central message near the end of the explanation",
  modification_weight: 0.90
}]->
(:TextFeature {id: "information_repetition", name: "Information repetition"})
```

and:

```text
(:AdaptationElement {id: "bullet_points_lists", name: "Bullet Points/Lists"})
-[:MODIFIES {
  modification_type: "list_structure",
  description: "Summarizes key information in a bullet list",
  modification_weight: 0.85
}]->
(:TextFeature {id: "list_structure", name: "List structure"})
```

#### Path 4: Expected generated text-effect

_The most important things to remember are:_

- _CLL often grows slowly._
- _You may not need treatment right away._
- _Your doctor will check your blood regularly._

_The key message is this: CLL often grows slowly, and your doctor will follow it carefully._

---

### 6.5 Path 5 — Otto's health literacy level activates simplified language and reduced conditionals

#### Path 5-a: Patient-specific factor value and stable health-literacy influence path

```text
(:PatientProfile {id: "otto_profile"})
-[:HAS_FACTOR_SCORE {
  factor_value: "low",
  factor_value_type: "categorical",
  evidence_status: "defined_in_use_case",
  needs_validation: true
}]->
(:Factor {id: "health_literacy_level", name: "Health literacy level"})
-[:INFLUENCES {
  influence_weight: 0.90,
  direction: "negative",
  effect: "Lower health literacy reduces ability to understand standard medical explanations"
}]->
(:HealthLiteracyDimension {id: "understand", name: "Understand"})
```

#### Path 5-b-1: Stable adaptation activation path A — Simplified language

```text
(:Factor {id: "health_literacy_level", name: "Health literacy level"})
-[:ACTIVATES {
  activation_weight: 0.90,
  text_effect: "Use common words and direct explanations"
}]->
(:AdaptationElement {id: "simplified_language", name: "Simplified Language"})
-[:BELONGS_TO]->
(:AdaptationCategory {id: "content_lexical", name: "Content - Lexical"})
```

#### Path 5-b-2: Stable adaptation activation path B — No conditionals

```text
(:Factor {id: "health_literacy_level", name: "Health literacy level"})
-[:ACTIVATES {
  activation_weight: 0.90,
  text_effect: "Avoid complex if-then constructions where possible"
}]->
(:AdaptationElement {id: "no_conditionals", name: "No conditionals"})
-[:BELONGS_TO]->
(:AdaptationCategory {id: "content_syntax_grammar", name: "Content - Syntax & Grammar"})
```

#### Path 5-c: Stable text-feature modification paths

```text
(:AdaptationElement {id: "simplified_language", name: "Simplified Language"})
-[:MODIFIES {
  modification_type: "language_simplification",
  description: "Uses common words and direct explanations",
  modification_weight: 0.90
}]->
(:TextFeature {id: "language_complexity", name: "Language complexity"})
```

and:

```text
(:AdaptationElement {id: "no_conditionals", name: "No conditionals"})
-[:MODIFIES {
  modification_type: "conditional_complexity",
  description: "Avoids complex conditional constructions",
  modification_weight: 0.80
}]->
(:TextFeature {id: "conditional_complexity", name: "Conditional complexity"})
```

#### Path 5: Expected generated text-effect

_Your doctor will check your blood regularly. Treatment is not always needed right away. Later, your doctor may suggest treatment and explain the options step by step._

---

### 6.6 Path 6 — Otto's educational level activates simpler sentence structure

#### Path 6-a: Patient-specific factor value and stable health-literacy influence path

```text
(:PatientProfile {id: "otto_profile"})
-[:HAS_FACTOR_SCORE {
  factor_value: "middle_school_graduate",
  factor_value_type: "categorical",
  evidence_status: "defined_in_use_case",
  needs_validation: false
}]->
(:Factor {id: "educational_level", name: "Educational level"})
-[:INFLUENCES {
  influence_weight: 0.70,
  direction: "negative",
  effect: "Lower educational level requires simpler syntax and shorter text blocks"
}]->
(:HealthLiteracyDimension {id: "understand", name: "Understand"})
```

#### Path 6-b: Stable adaptation activation path

```text
(:Factor {id: "educational_level", name: "Educational level"})
-[:ACTIVATES {
  activation_weight: 0.70,
  text_effect: "Avoid long subordinate clauses"
}]->
(:AdaptationElement {id: "secondary_sentences", name: "Secondary sentences"})
-[:BELONGS_TO]->
(:AdaptationCategory {id: "content_syntax_grammar", name: "Content - Syntax & Grammar"})
```

#### Path 6-c: Stable text-feature modification path

```text
(:AdaptationElement {id: "secondary_sentences", name: "Secondary sentences"})
-[:MODIFIES {
  modification_type: "sentence_complexity",
  description: "Reduces long subordinate clauses",
  modification_weight: 0.80
}]->
(:TextFeature {id: "sentence_complexity", name: "Sentence complexity"})
```

#### Path 6: Expected generated text-effect

_CLL is a chronic type of leukemia. It affects a type of white blood cell. Your doctor will monitor it regularly._

---

## 6.7 Text Features Modified by Adaptation Elements

The following `TextFeature` nodes describe what aspect of the generated text is modified by each activated adaptation element.

This is important because adaptation elements should not only be selected; they should also point to the concrete textual property they modify.

| Adaptation Element | TextFeature | Modification Type |
|---|---|---|
| Reassurance (it's ok phrases) | Emotional framing | emotional_framing |
| Positive information first | Positive framing | positive_framing |
| Order of information | Information order | information_order |
| Repeat Information | Information repetition | information_repetition |
| Simplified Medical Terms | Terminology complexity | lexical_simplification |
| Simplified Language | Language complexity | language_simplification |
| Complexity of medical terms | Term explanation | term_explanation |
| Font Size | Visual accessibility | visual_accessibility |
| Text block size | Paragraph density | paragraph_density |
| Enumeration (Steps) | Sequential structure | sequential_structure |
| Bullet Points/Lists | List structure | list_structure |
| Bold | Emphasis | emphasis |
| Secondary sentences | Sentence complexity | sentence_complexity |
| No conditionals | Conditional complexity | conditional_complexity |

### TextFeature modelling note

`TextFeature` nodes allow HEALIE to explain not only which adaptation element was activated, but also what part of the generated content is expected to change.

For example:

```text
Medical knowledge
→ activates Simplified Medical Terms
→ modifies Terminology complexity
```

This supports later evaluation because the generated text can be checked against the expected text features.

---

## 7. Ontology Alignment Notes

The HEALIE OWL ontology and the Neo4j graph serve different but connected roles.

The OWL ontology represents the reusable HEALIE knowledge model. It contains the general classes, properties, stable health-literacy dimensions, stable content adaptation categories, stable content adaptation elements, and stable weighted relationships between factors, health-literacy dimensions, adaptation elements, and text features.

The Neo4j graph imports or mirrors this ontology structure and adds patient-specific instances and values for executable reasoning. In the Otto vertical slice, Neo4j stores Otto, Otto's profile, Otto's factor values, and the traversable graph paths used for Cypher retrieval and LangChain-based content generation.

The ontology is therefore not limited to abstract classes only. It also includes reusable HEALIE model knowledge, such as:

- stable Health Literacy Dimensions: `Access`, `Understand`, `Appraise`, `Apply`
- stable Content Adaptation Categories
- stable Content Adaptation Elements
- stable factor → Health Literacy Dimension influence relationships
- stable factor → Content Adaptation Element activation relationships
- stable Content Adaptation Element → TextFeature modification relationships
- stable weights and evidence metadata for these model-level relationships

Neo4j contains the executable instantiation of this model for concrete use cases.

---

### 7.1 OWL ontology vs Neo4j graph

| Layer | Role | Example |
|---|---|---|
| OWL ontology | Defines reusable class | `healie:Patient` |
| OWL ontology | Defines stable health-literacy dimension individuals/classes | `healie:Understand`, `healie:Appraise` |
| OWL ontology | Defines stable adaptation categories | `healie:ContentGoodPractices`, `healie:ContentLexical` |
| OWL ontology | Defines stable adaptation elements | `healie:PositiveInformationFirst`, `healie:SimplifiedMedicalTerms` |
| OWL ontology | Defines stable weighted influence relationship | `healie:WorryAnxiety healie:influences healie:Appraise` with `healie:hasInfluenceWeight 0.85` |
| OWL ontology | Defines stable adaptation activation relationship | `healie:WorryAnxiety healie:activatesAdaptationElement healie:ReassuranceItsOkPhrases` with `healie:hasActivationWeight 0.85` |
| OWL ontology | Defines stable text-feature modification relationship | `healie:SimplifiedMedicalTerms healie:modifiesTextFeature healie:TerminologyComplexity` |
| Neo4j graph | Stores patient instance | `(:Patient {id: "otto"})` |
| Neo4j graph | Stores patient-specific factor value | `(:PatientProfile)-[:HAS_FACTOR_SCORE {factor_value: 0.85}]->(:Factor {id: "worry_anxiety"})` |
| Neo4j graph | Supports executable traversal | Otto profile → factor value → stable influence → activated adaptation element |

---

### 7.2 Class alignment

| Neo4j node label | OWL ontology element | Notes |
|---|---|---|
| `Patient` | `healie:Patient` | Patient/use-case actor |
| `PatientProfile` | `healie:PatientProfile` | Structured profile used for personalization |
| `ClinicalCondition` | `healie:ClinicalCondition` | Clinical entity, e.g. CLL |
| `Factor` | `healie:HealthLiteracyFactor` | General factor type imported from ontology |
| `HealthLiteracyDimension` | `healie:HealthLiteracyDimension` | One of `Access`, `Understand`, `Appraise`, `Apply` |
| `AdaptationCategory` | `healie:ContentAdaptationCategory` | Stable category defined in ontology |
| `AdaptationElement` | `healie:ContentAdaptationElement` | Stable adaptation instance defined in ontology |
| `TextFeature` | `healie:TextFeature` | Stable text feature modified by adaptation elements |

---

### 7.3 Object property alignment

| Neo4j relationship | OWL object property | Domain | Range | Layer |
|---|---|---|---|---|
| `HAS_PROFILE` | `healie:hasProfile` | `healie:Patient` | `healie:PatientProfile` | Instance layer |
| `HAS_CONDITION` | `healie:hasClinicalCondition` | `healie:PatientProfile` | `healie:ClinicalCondition` | Instance layer |
| `HAS_FACTOR_SCORE` | `healie:hasFactorScore` | `healie:PatientProfile` | `healie:HealthLiteracyFactor` | Instance layer |
| `INFLUENCES` | `healie:influences` | `healie:HealthLiteracyFactor` | `healie:HealthLiteracyDimension` | Stable ontology/model layer |
| `ACTIVATES` | `healie:activatesAdaptationElement` | `healie:HealthLiteracyFactor` | `healie:ContentAdaptationElement` | Stable ontology/model layer |
| `BELONGS_TO` | `healie:belongsToAdaptationCategory` | `healie:ContentAdaptationElement` | `healie:ContentAdaptationCategory` | Stable ontology/model layer |
| `MODIFIES` | `healie:modifiesTextFeature` | `healie:ContentAdaptationElement` | `healie:TextFeature` | Stable ontology/model layer |

---

### 7.4 Data property alignment

| Neo4j property | OWL data property | Applies to | Meaning |
|---|---|---|---|
| `id` | `healie:hasIdentifier` | Nodes | Stable identifier |
| `name` | `rdfs:label` | Nodes | Human-readable label |
| `abbreviation` | `healie:hasAbbreviation` | `ClinicalCondition` | Clinical abbreviation, e.g. CLL |
| `factor_value` | `healie:hasFactorValue` | `HAS_FACTOR_SCORE` | Patient-specific factor value, e.g. Otto's worry score |
| `factor_value_type` | `healie:hasFactorValueType` | `HAS_FACTOR_SCORE` | Whether value is numeric, categorical, inferred, etc. |
| `influence_weight` | `healie:hasInfluenceWeight` | `INFLUENCES` | Stable model-level weight from factor to HL dimension |
| `activation_weight` | `healie:hasActivationWeight` | `ACTIVATES` | Stable model-level weight from factor to adaptation element |
| `modification_weight` | `healie:hasModificationWeight` | `MODIFIES` | Stable model-level strength of adaptation effect on text feature, if used |
| `direction` | `healie:hasDirection` | `INFLUENCES` | Positive or negative influence |
| `effect` | `healie:hasEffectDescription` | `INFLUENCES` | Explanation of the influence |
| `text_effect` | `healie:hasTextEffect` | `ACTIVATES`, `MODIFIES` | Expected effect on generated text |
| `modification_type` | `healie:hasModificationType` | `MODIFIES` | Type of text modification |
| `description` | `healie:hasDescription` | `MODIFIES`, nodes | Human-readable description |
| `evidence_type` | `healie:hasEvidenceType` | Stable relationships | Type of evidence |
| `evidence_status` | `healie:hasEvidenceStatus` | Stable relationships and instance assertions | Evidence maturity |
| `source` | `healie:hasSource` | Stable relationships | Source artifact or expert mapping |
| `validated` | `healie:isValidated` | Stable relationships | Whether formally validated |
| `needs_validation` | `healie:needsValidation` | Stable relationships and inferred instance values | Whether validation is required |
| `confidence` | `healie:hasModellingConfidence` | Stable relationships | Modelling confidence |

---

### 7.5 Weight distinction

The HEALIE model distinguishes between stable model-level weights and patient-specific values.

| Type | Example | Meaning | Stored in |
|---|---|---|---|
| `influence_weight` | `Worry / anxiety → Appraise = 0.85` | Stable model-level influence of a factor on a health-literacy dimension | OWL ontology and Neo4j model layer |
| `activation_weight` | `Worry / anxiety → Reassurance = 0.85` | Stable model-level activation strength of an adaptation element | OWL ontology and Neo4j model layer |
| `modification_weight` | `Reassurance → Emotional framing = 0.90` | Stable model-level effect of an adaptation on a text feature | OWL ontology and Neo4j model layer, if used |
| `factor_value` | `Otto has Worry / anxiety = 0.85` | Patient-specific factor value | Neo4j instance layer |
| `computed_score` | `0.85 × 0.85 = 0.7225` | Runtime reasoning score | Neo4j query or Python reasoning layer |

````
Otto has Worry = 0.85
Worry influences Appraise = 0.85
Worry activates Reassurance = 0.85
````

This distinction prevents patient-specific data from being confused with stable HEALIE model knowledge.

| Property            | Meaning                                           | Layer                  |
| ------------------- | ------------------------------------------------- | ---------------------- |
| `factor_value`      | Otto’s specific score/value                       | Patient instance layer |
| `influence_weight`  | Stable model-level factor → HL dimension strength | Ontology/model layer   |
| `activation_weight` | Stable model-level factor → adaptation strength   | Ontology/model layer   |

influence_weight = strength of factor’s effect on HL dimension
activation_weight = strength of factor’s activation of a content adaptation
For the vertical slice, activation_weight may reuse the same provisional value as the related influence_weight.
But the properties remain separate because they mean different things.
| Property         | Meaning                                                 |
| ---------------- | ------------------------------------------------------- |
| `computed_score` | Runtime result, e.g. `factor_value × activation_weight` |


---

### 7.6 Important modelling decision: weighted relationships in OWL

Neo4j can store weights directly on relationships, for example:

```text
(:Factor {id: "worry_anxiety", name: "Worry / anxiety"})
-[:INFLUENCES {
  influence_weight: 0.85,
  evidence_status: "expert_informed_provisional"
}]->
(:HealthLiteracyDimension {id: "appraise", name: "Appraise"})
```

In OWL, object properties do not naturally carry properties in the same way. Therefore, stable weighted relationships may later need to be represented through a reified pattern.

For example:

```text
InfluenceStatement
- hasSourceFactor: Worry / anxiety
- hasTargetDimension: Appraise
- hasInfluenceWeight: 0.85
- hasDirection: negative
- hasEvidenceStatus: expert_informed_provisional
```

Similarly, adaptation activation may become:

```text
AdaptationActivationStatement
- hasSourceFactor: Worry / anxiety
- hasTargetAdaptationElement: Reassurance (it's ok phrases)
- hasActivationWeight: 0.85
- hasEvidenceStatus: expert_informed_provisional
```

The simplified Neo4j representation will use direct relationship properties for executable traversal. The OWL ontology may use reified statement classes for semantic correctness.

---

### 7.7 Ontology timing note

The HEALIE ontology should be developed as the reusable contribution of the PhD.

However, the Otto vertical slice is still useful before finalizing the ontology because it tests whether the proposed ontology-level constructs can support executable retrieval, reasoning, and generation.

The intended workflow is:

```text
Define reusable ontology pattern
→ instantiate Otto in Neo4j
→ test retrieval and generation
→ revise ontology pattern if needed
→ formalize in Protégé
```

The ontology should contain stable HEALIE model knowledge. Neo4j should contain both the imported stable model and the patient-specific instance data required for the demo.

---

## 8. Open Modelling Questions

## 8. Open Modelling Questions

The following modelling questions remain open and should be revisited after the Otto slice is implemented.

For the Otto vertical slice, the goal is not to solve every final ontology issue. The goal is to make explicit working decisions that allow the Neo4j graph to be implemented without losing traceability to the future HEALIE OWL ontology.

| # | Modelling issue | Working decision for Otto vertical slice | Future decision / note |
|---|---|---|---|
| 1 | Should inferred cognitive factors such as `Memory` and `Processing speed` be represented as independent `Factor` nodes, or as subtypes of a broader cognitive processing construct? | Keep `Memory` and `Processing speed` as independent `Factor` nodes for now. Mark them as inferred using `evidence_status: inferred_for_vertical_slice` and `needs_validation: true`. | When deciding on the final model, consider adding a broader `Cognitive processing support` factor or class, with `Memory` and `Processing speed` as subtypes or related dimensions. |
| 2 | Should `Health literacy level` be represented as a patient profile property, a `Factor` node, or both? | Represent it both ways. Keep `health_literacy_level` as a `PatientProfile` property for human readability, and also represent it as a `Factor` node for traversal and adaptation activation. | In the final ontology, document the distinction between descriptive profile attributes and reasoning-enabled factor representations. |
| 3 | Should `factor_value` always use numeric scores, or can categorical values such as `low`, `high`, and `middle_school_graduate` remain acceptable for prototype-stage reasoning? | Use categorical values for the Otto slice. For example, use `factor_value: elderly_65_plus` rather than `factor_value: 75` for the `Age` reasoning factor. | Later, HEALIE may support both numeric and categorical factor values. Numeric values can be used when validated instruments or scoring rules are available. |
| 4 | Should `activation_weight` always mirror `influence_weight`, or should factor-to-adaptation activation weights be independently assigned? | For the vertical slice, `activation_weight` may reuse the same provisional value as the related `influence_weight`. However, the properties remain separate because they mean different things. | In future expert validation, `influence_weight` and `activation_weight` may diverge. `influence_weight` represents factor → HL dimension strength; `activation_weight` represents factor → adaptation element strength. |
| 5 | Should `modification_weight` be used for all `MODIFIES` relationships, or only when expert mappings provide a stable strength of effect? | Use `modification_weight` for all `MODIFIES` relationships for now. | Revisit later. Some text-feature modifications may require expert-derived weights, while others may only need descriptive mappings. |
| 6 | Should formatting-oriented elements such as `Font Size`, `Bold`, and `Text block size` remain under `Morphology / Formatting`, or should formatting become a separate category in the final ontology? | Keep them under `Morphology / Formatting` for the Otto slice. | Revisit during final ontology refinement only if the category becomes too broad or linguistically inconsistent. |
| 7 | Should `TextFeature` nodes be part of the formal OWL ontology, or only part of the Neo4j implementation layer? | Keep `TextFeature` as both a Neo4j node label and a future OWL ontology class. | `TextFeature` is part of the explanatory bridge between adaptation elements and observable generated-text changes, so it belongs in the formal model. |
| 8 | Should expert evidence be represented only as relationship properties, or should HEALIE later include explicit `Evidence` nodes? | Represent expert evidence only as relationship properties for the Otto slice. | Keep explicit `Evidence` nodes out of scope for now. They can be considered later only if evidence provenance becomes too complex for relationship properties. |
| 9 | Should every `AdaptationElement` map to exactly one `TextFeature`, or can one adaptation element modify multiple text features? | Allow one `AdaptationElement` to modify multiple `TextFeature` nodes. | This is important for realistic modelling. For example, `Bullet Points/Lists` may affect both `List structure` and `Paragraph density`. |
| 10 | How should conflicts between adaptations be handled later? Example: `Positive information first` vs. urgent safety warning first. | Conflict handling is not implemented in the Otto vertical slice because the selected adaptations are complementary. | Future HEALIE versions should include explicit priority rules. Suggested priority order: 1. Clinical accuracy and faithfulness; 2. Patient safety; 3. Health-literacy adaptation; 4. Emotional reassurance; 5. Formatting and presentation preferences. Positive framing must not hide urgent safety information, and simplification must not reduce clinical faithfulness. |
| 11 | In the final OWL ontology, should stable weighted relationships be represented as direct object properties with annotations, or as reified statement classes such as `InfluenceStatement` and `AdaptationActivationStatement`? | In Neo4j, represent weighted relationships directly as relationship properties because this supports efficient traversal and Cypher retrieval. | In the final OWL ontology, stable weighted relationships should likely be represented as reified statement classes rather than only as direct object properties. HEALIE relationships carry weights, evidence metadata, validation status, and explanatory text. These properties describe the relationship itself, not only the source or target node. Candidate classes: `InfluenceStatement`, `AdaptationActivationStatement`, and possibly `TextModificationStatement`. |
---

## 9. Day 3 Status

### Completed

- Defined the Neo4j node labels for the Otto slice.
- Revised factors so that factor nodes are general reusable factors rather than value-specific patient states.
- Defined health-literacy dimensions using the correct HEALIE naming convention: `Access`, `Understand`, `Appraise`, `Apply`.
- Defined the relationship types and their instance-layer vs stable model-layer roles.
- Added `HAS_CONDITION` to represent Otto's clinical condition.
- Defined relationship properties using the weight distinction:
  - `factor_value` for patient-specific values,
  - `influence_weight` for stable factor-to-dimension weights,
  - `activation_weight` for stable factor-to-adaptation weights,
  - `modification_weight` for stable adaptation-to-text-feature weights, where used.
- Specified exact adaptation elements rather than broad adaptation categories.
- Added example Otto reasoning paths using the corrected weight distinction.
- Added `TextFeature` mappings.
- Added ontology alignment notes for later Protégé modelling.
- Documented open modelling questions.

