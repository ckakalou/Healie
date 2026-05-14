// HEALIE Otto Vertical Slice
// Day 4: Create Otto mini-graph in Neo4j Aura
// Cross-checked against docs/architecture/otto_neo4j_graph_pattern.md
//
// Modelling distinction:
// - factor_value = Otto-specific patient value, stored on HAS_FACTOR_SCORE
// - influence_weight = stable model-level factor-to-HL-dimension weight
// - activation_weight = stable model-level factor-to-adaptation-element weight
// - modification_weight = stable model-level adaptation-to-text-feature weight
//
// Health literacy dimensions must use:
// Access, Understand, Appraise, Apply

// -----------------------------------------------------------------------------
// 0. Clear previous Otto slice
// -----------------------------------------------------------------------------

MATCH (n)
WHERE n.slice = "otto_vertical_slice"
DETACH DELETE n;

// -----------------------------------------------------------------------------
// 1. Patient, profile, and clinical condition
// -----------------------------------------------------------------------------

MERGE (otto:Patient {id: "otto"})
SET otto.name = "Otto",
    otto.slice = "otto_vertical_slice";

MERGE (profile:PatientProfile {id: "otto_profile"})
SET profile.name = "Otto profile",
    profile.age_group = "elderly_65_plus",
    profile.education_level = "middle_school_graduate",
    profile.health_literacy_level = "low",
    profile.main_communication_need = "Understand diagnosis without unnecessary alarm",
    profile.slice = "otto_vertical_slice";

MERGE (cll:ClinicalCondition {id: "cll"})
SET cll.name = "Chronic Lymphocytic Leukemia",
    cll.abbreviation = "CLL",
    cll.slice = "otto_vertical_slice";

MATCH (otto:Patient {id: "otto"})
MATCH (profile:PatientProfile {id: "otto_profile"})
MERGE (otto)-[:HAS_PROFILE {status: "active"}]->(profile);

MATCH (profile:PatientProfile {id: "otto_profile"})
MATCH (cll:ClinicalCondition {id: "cll"})
MERGE (profile)-[:HAS_CONDITION {
    status: "active",
    evidence_status: "defined_in_use_case"
}]->(cll);

// -----------------------------------------------------------------------------
// 2. Health Literacy dimensions
// -----------------------------------------------------------------------------

MERGE (access:HealthLiteracyDimension {id: "access"})
SET access.name = "Access",
    access.slice = "otto_vertical_slice";

MERGE (understand:HealthLiteracyDimension {id: "understand"})
SET understand.name = "Understand",
    understand.slice = "otto_vertical_slice";

MERGE (appraise:HealthLiteracyDimension {id: "appraise"})
SET appraise.name = "Appraise",
    appraise.slice = "otto_vertical_slice";

MERGE (apply:HealthLiteracyDimension {id: "apply"})
SET apply.name = "Apply",
    apply.slice = "otto_vertical_slice";

// -----------------------------------------------------------------------------
// 3. Reusable HEALIE factors
// -----------------------------------------------------------------------------

MERGE (f:Factor {id: "worry_anxiety"})
SET f.name = "Worry / anxiety", f.factor_type = "emotional", f.slice = "otto_vertical_slice";

MERGE (f:Factor {id: "uncertainty"})
SET f.name = "Uncertainty", f.factor_type = "emotional", f.slice = "otto_vertical_slice";

MERGE (f:Factor {id: "health_literacy_level"})
SET f.name = "Health literacy level", f.factor_type = "health_literacy", f.slice = "otto_vertical_slice";

MERGE (f:Factor {id: "medical_knowledge"})
SET f.name = "Medical knowledge", f.factor_type = "knowledge", f.slice = "otto_vertical_slice";

MERGE (f:Factor {id: "age"})
SET f.name = "Age", f.factor_type = "sociodemographic", f.slice = "otto_vertical_slice";

MERGE (f:Factor {id: "memory"})
SET f.name = "Memory", f.factor_type = "cognitive", f.slice = "otto_vertical_slice";

MERGE (f:Factor {id: "processing_speed"})
SET f.name = "Processing speed", f.factor_type = "cognitive", f.slice = "otto_vertical_slice";

MERGE (f:Factor {id: "educational_level"})
SET f.name = "Educational level", f.factor_type = "sociodemographic", f.slice = "otto_vertical_slice";

// -----------------------------------------------------------------------------
// 4. Otto-specific factor values
// -----------------------------------------------------------------------------

MATCH (profile:PatientProfile {id: "otto_profile"})
MATCH (factor:Factor {id: "worry_anxiety"})
MERGE (profile)-[:HAS_FACTOR_SCORE {
    factor_value: 0.85,
    factor_value_type: "numeric",
    evidence_status: "defined_in_use_case",
    needs_validation: false,
    notes: "Otto's worry/anxiety score for the vertical slice"
}]->(factor);

MATCH (profile:PatientProfile {id: "otto_profile"})
MATCH (factor:Factor {id: "uncertainty"})
MERGE (profile)-[:HAS_FACTOR_SCORE {
    factor_value: 0.80,
    factor_value_type: "numeric",
    evidence_status: "defined_in_use_case",
    needs_validation: false,
    notes: "Otto's uncertainty score for the vertical slice"
}]->(factor);

MATCH (profile:PatientProfile {id: "otto_profile"})
MATCH (factor:Factor {id: "health_literacy_level"})
MERGE (profile)-[:HAS_FACTOR_SCORE {
    factor_value: "low",
    factor_value_type: "categorical",
    evidence_status: "defined_in_use_case",
    needs_validation: true,
    notes: "Otto's health literacy level"
}]->(factor);

MATCH (profile:PatientProfile {id: "otto_profile"})
MATCH (factor:Factor {id: "medical_knowledge"})
MERGE (profile)-[:HAS_FACTOR_SCORE {
    factor_value: "low",
    factor_value_type: "categorical",
    evidence_status: "defined_in_use_case",
    needs_validation: false,
    notes: "Otto's medical knowledge level"
}]->(factor);

MATCH (profile:PatientProfile {id: "otto_profile"})
MATCH (factor:Factor {id: "age"})
MERGE (profile)-[:HAS_FACTOR_SCORE {
    factor_value: "elderly_65_plus",
    factor_value_type: "categorical",
    evidence_status: "defined_in_use_case",
    needs_validation: false,
    notes: "Otto's age group used for reasoning"
}]->(factor);

MATCH (profile:PatientProfile {id: "otto_profile"})
MATCH (factor:Factor {id: "memory"})
MERGE (profile)-[:HAS_FACTOR_SCORE {
    factor_value: "possible_deficit",
    factor_value_type: "inferred_categorical",
    evidence_status: "inferred_for_vertical_slice",
    needs_validation: true,
    notes: "Memory difficulty inferred for the vertical slice"
}]->(factor);

MATCH (profile:PatientProfile {id: "otto_profile"})
MATCH (factor:Factor {id: "processing_speed"})
MERGE (profile)-[:HAS_FACTOR_SCORE {
    factor_value: "possible_deficit",
    factor_value_type: "inferred_categorical",
    evidence_status: "inferred_for_vertical_slice",
    needs_validation: true,
    notes: "Processing speed difficulty inferred for the vertical slice"
}]->(factor);

MATCH (profile:PatientProfile {id: "otto_profile"})
MATCH (factor:Factor {id: "educational_level"})
MERGE (profile)-[:HAS_FACTOR_SCORE {
    factor_value: "middle_school_graduate",
    factor_value_type: "categorical",
    evidence_status: "defined_in_use_case",
    needs_validation: false,
    notes: "Otto's educational level"
}]->(factor);

// -----------------------------------------------------------------------------
// 5. Stable factor-to-health-literacy relationships
// -----------------------------------------------------------------------------

MATCH (factor:Factor {id: "worry_anxiety"})
MATCH (dimension:HealthLiteracyDimension {id: "appraise"})
MERGE (factor)-[:INFLUENCES {
    influence_weight: 0.85,
    direction: "negative",
    effect: "Higher worry makes health information harder to appraise calmly",
    evidence_type: "expert_mapping",
    evidence_status: "expert_informed_provisional",
    source: "expert_selection_workbook",
    validated: false,
    needs_validation: true,
    confidence: 7
}]->(dimension);

MATCH (factor:Factor {id: "uncertainty"})
MATCH (dimension:HealthLiteracyDimension {id: "appraise"})
MERGE (factor)-[:INFLUENCES {
    influence_weight: 0.80,
    direction: "negative",
    effect: "Higher uncertainty makes prognosis and disease meaning harder to appraise",
    evidence_type: "expert_mapping",
    evidence_status: "expert_informed_provisional",
    source: "expert_selection_workbook",
    validated: false,
    needs_validation: true,
    confidence: 7
}]->(dimension);

MATCH (factor:Factor {id: "health_literacy_level"})
MATCH (dimension:HealthLiteracyDimension {id: "understand"})
MERGE (factor)-[:INFLUENCES {
    influence_weight: 0.90,
    direction: "negative",
    effect: "Lower health literacy reduces ability to understand standard medical explanations",
    evidence_type: "profile_definition",
    evidence_status: "profile_defined_provisional",
    source: "otto_use_case_spec",
    validated: false,
    needs_validation: true,
    confidence: 8
}]->(dimension);

MATCH (factor:Factor {id: "medical_knowledge"})
MATCH (dimension:HealthLiteracyDimension {id: "understand"})
MERGE (factor)-[:INFLUENCES {
    influence_weight: 0.85,
    direction: "negative",
    effect: "Lower medical knowledge makes technical terminology harder to understand",
    evidence_type: "expert_mapping",
    evidence_status: "expert_informed_provisional",
    source: "expert_selection_workbook",
    validated: false,
    needs_validation: true,
    confidence: 8
}]->(dimension);

MATCH (factor:Factor {id: "age"})
MATCH (dimension:HealthLiteracyDimension {id: "understand"})
MERGE (factor)-[:INFLUENCES {
    influence_weight: 0.65,
    direction: "negative",
    effect: "Older age may require accessibility-oriented presentation",
    evidence_type: "profile_definition",
    evidence_status: "profile_defined_provisional",
    source: "otto_use_case_spec",
    validated: false,
    needs_validation: true,
    confidence: 6
}]->(dimension);

MATCH (factor:Factor {id: "memory"})
MATCH (dimension:HealthLiteracyDimension {id: "understand"})
MERGE (factor)-[:INFLUENCES {
    influence_weight: 0.75,
    direction: "negative",
    effect: "Lower memory capacity reduces retention of key information",
    evidence_type: "inferred_factor",
    evidence_status: "inferred_for_vertical_slice",
    source: "otto_modelling_decision",
    validated: false,
    needs_validation: true,
    confidence: 6
}]->(dimension);

MATCH (factor:Factor {id: "processing_speed"})
MATCH (dimension:HealthLiteracyDimension {id: "understand"})
MERGE (factor)-[:INFLUENCES {
    influence_weight: 0.60,
    direction: "negative",
    effect: "Lower processing speed requires slower-paced stepwise explanations",
    evidence_type: "inferred_factor",
    evidence_status: "inferred_for_vertical_slice",
    source: "otto_modelling_decision",
    validated: false,
    needs_validation: true,
    confidence: 5
}]->(dimension);

MATCH (factor:Factor {id: "educational_level"})
MATCH (dimension:HealthLiteracyDimension {id: "understand"})
MERGE (factor)-[:INFLUENCES {
    influence_weight: 0.70,
    direction: "negative",
    effect: "Lower educational level requires simpler syntax and shorter text blocks",
    evidence_type: "profile_definition",
    evidence_status: "profile_defined_provisional",
    source: "otto_use_case_spec",
    validated: false,
    needs_validation: true,
    confidence: 7
}]->(dimension);

// -----------------------------------------------------------------------------
// 6. Adaptation categories
// -----------------------------------------------------------------------------

MERGE (category:AdaptationCategory {id: "content_good_practices"})
SET category.name = "Content - Good Practices", category.slice = "otto_vertical_slice";

MERGE (category:AdaptationCategory {id: "content_lexical"})
SET category.name = "Content - Lexical", category.slice = "otto_vertical_slice";

MERGE (category:AdaptationCategory {id: "morphology_formatting"})
SET category.name = "Morphology / Formatting", category.slice = "otto_vertical_slice";

MERGE (category:AdaptationCategory {id: "content_syntax_grammar"})
SET category.name = "Content - Syntax & Grammar", category.slice = "otto_vertical_slice";

// -----------------------------------------------------------------------------
// 7. Adaptation elements
// -----------------------------------------------------------------------------

MERGE (element:AdaptationElement {id: "reassurance_its_ok_phrases"})
SET element.name = "Reassurance (it's ok phrases)", element.slice = "otto_vertical_slice";

MERGE (element:AdaptationElement {id: "positive_information_first"})
SET element.name = "Positive information first", element.slice = "otto_vertical_slice";

MERGE (element:AdaptationElement {id: "order_of_information"})
SET element.name = "Order of information", element.slice = "otto_vertical_slice";

MERGE (element:AdaptationElement {id: "repeat_information"})
SET element.name = "Repeat Information", element.slice = "otto_vertical_slice";

MERGE (element:AdaptationElement {id: "simplified_medical_terms"})
SET element.name = "Simplified Medical Terms", element.slice = "otto_vertical_slice";

MERGE (element:AdaptationElement {id: "simplified_language"})
SET element.name = "Simplified Language", element.slice = "otto_vertical_slice";

MERGE (element:AdaptationElement {id: "complexity_of_medical_terms"})
SET element.name = "Complexity of medical terms", element.slice = "otto_vertical_slice";

MERGE (element:AdaptationElement {id: "font_size"})
SET element.name = "Font Size", element.slice = "otto_vertical_slice";

MERGE (element:AdaptationElement {id: "text_block_size"})
SET element.name = "Text block size", element.slice = "otto_vertical_slice";

MERGE (element:AdaptationElement {id: "enumeration_steps"})
SET element.name = "Enumeration (Steps)", element.slice = "otto_vertical_slice";

MERGE (element:AdaptationElement {id: "bullet_points_lists"})
SET element.name = "Bullet Points/Lists", element.slice = "otto_vertical_slice";

MERGE (element:AdaptationElement {id: "bold"})
SET element.name = "Bold", element.slice = "otto_vertical_slice";

MERGE (element:AdaptationElement {id: "secondary_sentences"})
SET element.name = "Secondary sentences", element.slice = "otto_vertical_slice";

MERGE (element:AdaptationElement {id: "no_conditionals"})
SET element.name = "No conditionals", element.slice = "otto_vertical_slice";

// -----------------------------------------------------------------------------
// 8. Adaptation element category membership
// -----------------------------------------------------------------------------

MATCH (element:AdaptationElement {id: "reassurance_its_ok_phrases"})
MATCH (category:AdaptationCategory {id: "content_good_practices"})
MERGE (element)-[:BELONGS_TO {status: "active"}]->(category);

MATCH (element:AdaptationElement {id: "positive_information_first"})
MATCH (category:AdaptationCategory {id: "content_good_practices"})
MERGE (element)-[:BELONGS_TO {status: "active"}]->(category);

MATCH (element:AdaptationElement {id: "order_of_information"})
MATCH (category:AdaptationCategory {id: "content_good_practices"})
MERGE (element)-[:BELONGS_TO {status: "active"}]->(category);

MATCH (element:AdaptationElement {id: "repeat_information"})
MATCH (category:AdaptationCategory {id: "content_good_practices"})
MERGE (element)-[:BELONGS_TO {status: "active"}]->(category);

MATCH (element:AdaptationElement {id: "simplified_medical_terms"})
MATCH (category:AdaptationCategory {id: "content_lexical"})
MERGE (element)-[:BELONGS_TO {status: "active"}]->(category);

MATCH (element:AdaptationElement {id: "simplified_language"})
MATCH (category:AdaptationCategory {id: "content_lexical"})
MERGE (element)-[:BELONGS_TO {status: "active"}]->(category);

MATCH (element:AdaptationElement {id: "complexity_of_medical_terms"})
MATCH (category:AdaptationCategory {id: "content_lexical"})
MERGE (element)-[:BELONGS_TO {status: "active"}]->(category);

MATCH (element:AdaptationElement {id: "font_size"})
MATCH (category:AdaptationCategory {id: "morphology_formatting"})
MERGE (element)-[:BELONGS_TO {status: "active"}]->(category);

MATCH (element:AdaptationElement {id: "text_block_size"})
MATCH (category:AdaptationCategory {id: "morphology_formatting"})
MERGE (element)-[:BELONGS_TO {status: "active"}]->(category);

MATCH (element:AdaptationElement {id: "enumeration_steps"})
MATCH (category:AdaptationCategory {id: "morphology_formatting"})
MERGE (element)-[:BELONGS_TO {status: "active"}]->(category);

MATCH (element:AdaptationElement {id: "bullet_points_lists"})
MATCH (category:AdaptationCategory {id: "morphology_formatting"})
MERGE (element)-[:BELONGS_TO {status: "active"}]->(category);

MATCH (element:AdaptationElement {id: "bold"})
MATCH (category:AdaptationCategory {id: "morphology_formatting"})
MERGE (element)-[:BELONGS_TO {status: "active"}]->(category);

MATCH (element:AdaptationElement {id: "secondary_sentences"})
MATCH (category:AdaptationCategory {id: "content_syntax_grammar"})
MERGE (element)-[:BELONGS_TO {status: "active"}]->(category);

MATCH (element:AdaptationElement {id: "no_conditionals"})
MATCH (category:AdaptationCategory {id: "content_syntax_grammar"})
MERGE (element)-[:BELONGS_TO {status: "active"}]->(category);

// -----------------------------------------------------------------------------
// 9. Stable factor-to-adaptation activation relationships
// -----------------------------------------------------------------------------

MATCH (factor:Factor {id: "worry_anxiety"})
MATCH (element:AdaptationElement {id: "reassurance_its_ok_phrases"})
MERGE (factor)-[:ACTIVATES {activation_weight: 0.85, text_effect: "Add one calming sentence after explaining the diagnosis", evidence_type: "expert_mapping", evidence_status: "expert_informed_provisional", source: "expert_selection_workbook", validated: false, needs_validation: true, confidence: 8}]->(element);

MATCH (factor:Factor {id: "worry_anxiety"})
MATCH (element:AdaptationElement {id: "positive_information_first"})
MERGE (factor)-[:ACTIVATES {activation_weight: 0.85, text_effect: "Mention slow progression and regular monitoring early", evidence_type: "expert_mapping", evidence_status: "expert_informed_provisional", source: "expert_selection_workbook", validated: false, needs_validation: true, confidence: 8}]->(element);

MATCH (factor:Factor {id: "uncertainty"})
MATCH (element:AdaptationElement {id: "order_of_information"})
MERGE (factor)-[:ACTIVATES {activation_weight: 0.80, text_effect: "Start with stabilizing information then explain disease details", evidence_type: "expert_mapping", evidence_status: "expert_informed_provisional", source: "expert_selection_workbook", validated: false, needs_validation: true, confidence: 8}]->(element);

MATCH (factor:Factor {id: "memory"})
MATCH (element:AdaptationElement {id: "repeat_information"})
MERGE (factor)-[:ACTIVATES {activation_weight: 0.75, text_effect: "Repeat the main message near the end", evidence_type: "expert_mapping", evidence_status: "expert_informed_provisional", source: "expert_selection_workbook", validated: false, needs_validation: true, confidence: 7}]->(element);

MATCH (factor:Factor {id: "medical_knowledge"})
MATCH (element:AdaptationElement {id: "simplified_medical_terms"})
MERGE (factor)-[:ACTIVATES {activation_weight: 0.85, text_effect: "Use blood cancer instead of hematological malignancy", evidence_type: "expert_mapping", evidence_status: "expert_informed_provisional", source: "expert_selection_workbook", validated: false, needs_validation: true, confidence: 8}]->(element);

MATCH (factor:Factor {id: "health_literacy_level"})
MATCH (element:AdaptationElement {id: "simplified_language"})
MERGE (factor)-[:ACTIVATES {activation_weight: 0.90, text_effect: "Use common words and direct explanations", evidence_type: "expert_mapping", evidence_status: "expert_informed_provisional", source: "expert_selection_workbook", validated: false, needs_validation: true, confidence: 8}]->(element);

MATCH (factor:Factor {id: "health_literacy_level"})
MATCH (element:AdaptationElement {id: "complexity_of_medical_terms"})
MERGE (factor)-[:ACTIVATES {activation_weight: 0.90, text_effect: "Explain CLL immediately after naming it", evidence_type: "expert_mapping", evidence_status: "expert_informed_provisional", source: "expert_selection_workbook", validated: false, needs_validation: true, confidence: 8}]->(element);

MATCH (factor:Factor {id: "age"})
MATCH (element:AdaptationElement {id: "font_size"})
MERGE (factor)-[:ACTIVATES {activation_weight: 0.65, text_effect: "Support larger readable text in the demo or output", evidence_type: "expert_mapping", evidence_status: "expert_informed_provisional", source: "expert_selection_workbook", validated: false, needs_validation: true, confidence: 6}]->(element);

MATCH (factor:Factor {id: "health_literacy_level"})
MATCH (element:AdaptationElement {id: "text_block_size"})
MERGE (factor)-[:ACTIVATES {activation_weight: 0.90, text_effect: "Use short paragraphs and avoid dense text blocks", evidence_type: "expert_mapping", evidence_status: "expert_informed_provisional", source: "expert_selection_workbook", validated: false, needs_validation: true, confidence: 8}]->(element);

MATCH (factor:Factor {id: "processing_speed"})
MATCH (element:AdaptationElement {id: "enumeration_steps"})
MERGE (factor)-[:ACTIVATES {activation_weight: 0.60, text_effect: "Present key information step by step", evidence_type: "expert_mapping", evidence_status: "expert_informed_provisional", source: "expert_selection_workbook", validated: false, needs_validation: true, confidence: 6}]->(element);

MATCH (factor:Factor {id: "memory"})
MATCH (element:AdaptationElement {id: "bullet_points_lists"})
MERGE (factor)-[:ACTIVATES {activation_weight: 0.75, text_effect: "Summarize key information as bullet points", evidence_type: "expert_mapping", evidence_status: "expert_informed_provisional", source: "expert_selection_workbook", validated: false, needs_validation: true, confidence: 7}]->(element);

MATCH (factor:Factor {id: "memory"})
MATCH (element:AdaptationElement {id: "bold"})
MERGE (factor)-[:ACTIVATES {activation_weight: 0.75, text_effect: "Bold only the most important terms or messages", evidence_type: "expert_mapping", evidence_status: "expert_informed_provisional", source: "expert_selection_workbook", validated: false, needs_validation: true, confidence: 6}]->(element);

MATCH (factor:Factor {id: "educational_level"})
MATCH (element:AdaptationElement {id: "secondary_sentences"})
MERGE (factor)-[:ACTIVATES {activation_weight: 0.70, text_effect: "Avoid long subordinate clauses", evidence_type: "expert_mapping", evidence_status: "expert_informed_provisional", source: "expert_selection_workbook", validated: false, needs_validation: true, confidence: 7}]->(element);

MATCH (factor:Factor {id: "health_literacy_level"})
MATCH (element:AdaptationElement {id: "no_conditionals"})
MERGE (factor)-[:ACTIVATES {activation_weight: 0.90, text_effect: "Avoid complex if-then constructions where possible", evidence_type: "expert_mapping", evidence_status: "expert_informed_provisional", source: "expert_selection_workbook", validated: false, needs_validation: true, confidence: 8}]->(element);

MATCH (factor:Factor {id: "worry_anxiety"})
MATCH (element:AdaptationElement {id: "no_conditionals"})
MERGE (factor)-[:ACTIVATES {activation_weight: 0.85, text_effect: "Avoid conditional phrasing that may increase anxiety", evidence_type: "expert_mapping", evidence_status: "expert_informed_provisional", source: "expert_selection_workbook", validated: false, needs_validation: true, confidence: 7}]->(element);

// -----------------------------------------------------------------------------
// 10. Text features
// -----------------------------------------------------------------------------

MERGE (feature:TextFeature {id: "emotional_framing"})
SET feature.name = "Emotional framing", feature.slice = "otto_vertical_slice";

MERGE (feature:TextFeature {id: "positive_framing"})
SET feature.name = "Positive framing", feature.slice = "otto_vertical_slice";

MERGE (feature:TextFeature {id: "information_order"})
SET feature.name = "Information order", feature.slice = "otto_vertical_slice";

MERGE (feature:TextFeature {id: "information_repetition"})
SET feature.name = "Information repetition", feature.slice = "otto_vertical_slice";

MERGE (feature:TextFeature {id: "terminology_complexity"})
SET feature.name = "Terminology complexity", feature.slice = "otto_vertical_slice";

MERGE (feature:TextFeature {id: "language_complexity"})
SET feature.name = "Language complexity", feature.slice = "otto_vertical_slice";

MERGE (feature:TextFeature {id: "term_explanation"})
SET feature.name = "Term explanation", feature.slice = "otto_vertical_slice";

MERGE (feature:TextFeature {id: "visual_accessibility"})
SET feature.name = "Visual accessibility", feature.slice = "otto_vertical_slice";

MERGE (feature:TextFeature {id: "paragraph_density"})
SET feature.name = "Paragraph density", feature.slice = "otto_vertical_slice";

MERGE (feature:TextFeature {id: "sequential_structure"})
SET feature.name = "Sequential structure", feature.slice = "otto_vertical_slice";

MERGE (feature:TextFeature {id: "list_structure"})
SET feature.name = "List structure", feature.slice = "otto_vertical_slice";

MERGE (feature:TextFeature {id: "emphasis"})
SET feature.name = "Emphasis", feature.slice = "otto_vertical_slice";

MERGE (feature:TextFeature {id: "sentence_complexity"})
SET feature.name = "Sentence complexity", feature.slice = "otto_vertical_slice";

MERGE (feature:TextFeature {id: "conditional_complexity"})
SET feature.name = "Conditional complexity", feature.slice = "otto_vertical_slice";

// -----------------------------------------------------------------------------
// 11. Stable adaptation-to-text-feature modification relationships
// -----------------------------------------------------------------------------

MATCH (element:AdaptationElement {id: "reassurance_its_ok_phrases"})
MATCH (feature:TextFeature {id: "emotional_framing"})
MERGE (element)-[:MODIFIES {modification_type: "emotional_framing", description: "Adds reassurance to reduce unnecessary alarm", modification_weight: 0.90}]->(feature);

MATCH (element:AdaptationElement {id: "positive_information_first"})
MATCH (feature:TextFeature {id: "positive_framing"})
MERGE (element)-[:MODIFIES {modification_type: "positive_framing", description: "Places reassuring or stabilizing information early", modification_weight: 0.85}]->(feature);

MATCH (element:AdaptationElement {id: "order_of_information"})
MATCH (feature:TextFeature {id: "information_order"})
MERGE (element)-[:MODIFIES {modification_type: "information_order", description: "Controls the sequence of information in the generated explanation", modification_weight: 0.85}]->(feature);

MATCH (element:AdaptationElement {id: "repeat_information"})
MATCH (feature:TextFeature {id: "information_repetition"})
MERGE (element)-[:MODIFIES {modification_type: "information_repetition", description: "Repeats the central message near the end of the explanation", modification_weight: 0.90}]->(feature);

MATCH (element:AdaptationElement {id: "simplified_medical_terms"})
MATCH (feature:TextFeature {id: "terminology_complexity"})
MERGE (element)-[:MODIFIES {modification_type: "lexical_simplification", description: "Replaces complex medical terms with patient-friendly alternatives", modification_weight: 0.90}]->(feature);

MATCH (element:AdaptationElement {id: "simplified_language"})
MATCH (feature:TextFeature {id: "language_complexity"})
MERGE (element)-[:MODIFIES {modification_type: "language_simplification", description: "Uses common words and direct explanations", modification_weight: 0.90}]->(feature);

MATCH (element:AdaptationElement {id: "complexity_of_medical_terms"})
MATCH (feature:TextFeature {id: "term_explanation"})
MERGE (element)-[:MODIFIES {modification_type: "term_explanation", description: "Explains technical medical terms immediately after naming them", modification_weight: 0.85}]->(feature);

MATCH (element:AdaptationElement {id: "font_size"})
MATCH (feature:TextFeature {id: "visual_accessibility"})
MERGE (element)-[:MODIFIES {modification_type: "visual_accessibility", description: "Supports larger readable text for older adults", modification_weight: 0.70}]->(feature);

MATCH (element:AdaptationElement {id: "text_block_size"})
MATCH (feature:TextFeature {id: "paragraph_density"})
MERGE (element)-[:MODIFIES {modification_type: "paragraph_density", description: "Uses shorter paragraphs and avoids dense text blocks", modification_weight: 0.90}]->(feature);

MATCH (element:AdaptationElement {id: "enumeration_steps"})
MATCH (feature:TextFeature {id: "sequential_structure"})
MERGE (element)-[:MODIFIES {modification_type: "sequential_structure", description: "Presents information step by step", modification_weight: 0.80}]->(feature);

MATCH (element:AdaptationElement {id: "bullet_points_lists"})
MATCH (feature:TextFeature {id: "list_structure"})
MERGE (element)-[:MODIFIES {modification_type: "list_structure", description: "Summarizes key information in a bullet list", modification_weight: 0.85}]->(feature);

MATCH (element:AdaptationElement {id: "bullet_points_lists"})
MATCH (feature:TextFeature {id: "paragraph_density"})
MERGE (element)-[:MODIFIES {modification_type: "paragraph_density", description: "Reduces dense paragraph structure by moving key points into a list", modification_weight: 0.80}]->(feature);

MATCH (element:AdaptationElement {id: "bold"})
MATCH (feature:TextFeature {id: "emphasis"})
MERGE (element)-[:MODIFIES {modification_type: "emphasis", description: "Highlights only the most important terms or messages", modification_weight: 0.70}]->(feature);

MATCH (element:AdaptationElement {id: "secondary_sentences"})
MATCH (feature:TextFeature {id: "sentence_complexity"})
MERGE (element)-[:MODIFIES {modification_type: "sentence_complexity", description: "Reduces long subordinate clauses", modification_weight: 0.80}]->(feature);

MATCH (element:AdaptationElement {id: "no_conditionals"})
MATCH (feature:TextFeature {id: "conditional_complexity"})
MERGE (element)-[:MODIFIES {modification_type: "conditional_complexity", description: "Avoids complex conditional constructions", modification_weight: 0.80}]->(feature);

// -----------------------------------------------------------------------------
// 12. Validation queries
// -----------------------------------------------------------------------------
// Run these manually after executing the script.

// Count Otto slice nodes by label
// MATCH (n)
// WHERE n.slice = "otto_vertical_slice"
// RETURN labels(n) AS labels, count(n) AS count
// ORDER BY labels;

// Count all relationships by type
// MATCH ()-[r]->()
// RETURN type(r) AS relationship_type, count(r) AS count
// ORDER BY relationship_type;

// Expected node counts:
// AdaptationCategory: 4
// AdaptationElement: 14
// ClinicalCondition: 1
// Factor: 8
// HealthLiteracyDimension: 4
// Patient: 1
// PatientProfile: 1
// TextFeature: 14
// Total nodes: 47

// Expected relationship counts:
// ACTIVATES: 15
// BELONGS_TO: 14
// HAS_CONDITION: 1
// HAS_FACTOR_SCORE: 8
// HAS_PROFILE: 1
// INFLUENCES: 8
// MODIFIES: 15
// Total relationships: 62

// Check Otto profile and condition
// MATCH (p:Patient {id: "otto"})-[:HAS_PROFILE]->(profile:PatientProfile)-[:HAS_CONDITION]->(condition:ClinicalCondition)
// RETURN p.name AS patient, profile.id AS profile_id, condition.name AS condition, condition.abbreviation AS abbreviation;

// Check Otto-specific factor values
// MATCH (:Patient {id: "otto"})-[:HAS_PROFILE]->(profile:PatientProfile)-[score:HAS_FACTOR_SCORE]->(factor:Factor)
// RETURN factor.id AS factor_id,
//        factor.name AS factor,
//        score.factor_value AS factor_value,
//        score.factor_value_type AS factor_value_type,
//        score.evidence_status AS evidence_status,
//        score.needs_validation AS needs_validation
// ORDER BY factor_id;

// Check stable weighted factor influences
// MATCH (factor:Factor)-[r:INFLUENCES]->(dimension:HealthLiteracyDimension)
// WHERE factor.slice = "otto_vertical_slice"
// RETURN factor.name AS factor,
//        dimension.name AS dimension,
//        r.influence_weight AS influence_weight,
//        r.direction AS direction,
//        r.effect AS effect
// ORDER BY r.influence_weight DESC;

// Check activated adaptation elements for Otto
// MATCH (:Patient {id: "otto"})-[:HAS_PROFILE]->(:PatientProfile)-[score:HAS_FACTOR_SCORE]->(factor:Factor)
// MATCH (factor)-[activation:ACTIVATES]->(element:AdaptationElement)-[:BELONGS_TO]->(category:AdaptationCategory)
// RETURN factor.name AS factor,
//        score.factor_value AS factor_value,
//        element.name AS adaptation_element,
//        category.name AS adaptation_category,
//        activation.activation_weight AS activation_weight,
//        activation.text_effect AS text_effect
// ORDER BY activation.activation_weight DESC;

// Check text features modified by activated adaptations
// MATCH (:Patient {id: "otto"})-[:HAS_PROFILE]->(:PatientProfile)-[:HAS_FACTOR_SCORE]->(factor:Factor)
// MATCH (factor)-[:ACTIVATES]->(element:AdaptationElement)-[m:MODIFIES]->(feature:TextFeature)
// RETURN DISTINCT element.name AS adaptation_element,
//        feature.name AS text_feature,
//        m.modification_type AS modification_type,
//        m.modification_weight AS modification_weight
// ORDER BY adaptation_element, text_feature;

// Check all four adaptation categories are represented
// MATCH (element:AdaptationElement)-[:BELONGS_TO]->(category:AdaptationCategory)
// WHERE element.slice = "otto_vertical_slice"
// RETURN category.name AS category, count(element) AS adaptation_elements
// ORDER BY category;
