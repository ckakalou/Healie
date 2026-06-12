# Otto Reasoning Report

## Patient profile

- Patient: Otto
- Condition: Chronic Lymphocytic Leukemia (CLL)
- Age group: elderly_65_plus
- Education level: middle_school_graduate
- Health literacy level: low
- Main communication need: Understand diagnosis without unnecessary alarm

## Dominant health-literacy barriers

1. **Health literacy level** (value: `low`, dimension: `Understand`, influence_weight: `0.9`, computed_score: `not computed`)
   - Effect: Lower health literacy reduces ability to understand standard medical explanations
   - Evidence: profile_defined_provisional; needs validation: True
2. **Medical knowledge** (value: `low`, dimension: `Understand`, influence_weight: `0.85`, computed_score: `not computed`)
   - Effect: Lower medical knowledge makes technical terminology harder to understand
   - Evidence: expert_informed_provisional; needs validation: True
3. **Memory** (value: `possible_deficit`, dimension: `Understand`, influence_weight: `0.75`, computed_score: `not computed`)
   - Effect: Lower memory capacity reduces retention of key information
   - Evidence: inferred_for_vertical_slice; needs validation: True
4. **Worry / anxiety** (value: `0.85`, dimension: `Appraise`, influence_weight: `0.85`, computed_score: `0.722`)
   - Effect: Higher worry makes health information harder to appraise calmly
   - Evidence: expert_informed_provisional; needs validation: True
5. **Educational level** (value: `middle_school_graduate`, dimension: `Understand`, influence_weight: `0.7`, computed_score: `not computed`)
   - Effect: Lower educational level requires simpler syntax and shorter text blocks
   - Evidence: profile_defined_provisional; needs validation: True
6. **Age** (value: `elderly_65_plus`, dimension: `Understand`, influence_weight: `0.65`, computed_score: `not computed`)
   - Effect: Older age may require accessibility-oriented presentation
   - Evidence: profile_defined_provisional; needs validation: True
7. **Uncertainty** (value: `0.8`, dimension: `Appraise`, influence_weight: `0.8`, computed_score: `0.640`)
   - Effect: Higher uncertainty makes prognosis and disease meaning harder to appraise
   - Evidence: expert_informed_provisional; needs validation: True
8. **Processing speed** (value: `possible_deficit`, dimension: `Understand`, influence_weight: `0.6`, computed_score: `not computed`)
   - Effect: Lower processing speed requires slower-paced stepwise explanations
   - Evidence: inferred_for_vertical_slice; needs validation: True

## Activated adaptation elements by category

### Content - Lexical

- **Complexity of medical terms**
  - Triggering factor: Health literacy level
  - Factor value: `low`
  - Activation weight: `0.9`
  - Computed activation score: `not computed`
  - Text effect: Explain CLL immediately after naming it
  - Modified text feature(s): Term explanation
- **Simplified Language**
  - Triggering factor: Health literacy level
  - Factor value: `low`
  - Activation weight: `0.9`
  - Computed activation score: `not computed`
  - Text effect: Use common words and direct explanations
  - Modified text feature(s): Language complexity
- **Simplified Medical Terms**
  - Triggering factor: Medical knowledge
  - Factor value: `low`
  - Activation weight: `0.85`
  - Computed activation score: `not computed`
  - Text effect: Use blood cancer instead of hematological malignancy
  - Modified text feature(s): Terminology complexity

### Content - Syntax & Grammar

- **No conditionals**
  - Triggering factor: Health literacy level
  - Factor value: `low`
  - Activation weight: `0.9`
  - Computed activation score: `not computed`
  - Text effect: Avoid complex if-then constructions where possible
  - Modified text feature(s): Conditional complexity
- **No conditionals**
  - Triggering factor: Worry / anxiety
  - Factor value: `0.85`
  - Activation weight: `0.85`
  - Computed activation score: `0.722`
  - Text effect: Avoid conditional phrasing that may increase anxiety
  - Modified text feature(s): Conditional complexity
- **Secondary sentences**
  - Triggering factor: Educational level
  - Factor value: `middle_school_graduate`
  - Activation weight: `0.7`
  - Computed activation score: `not computed`
  - Text effect: Avoid long subordinate clauses
  - Modified text feature(s): Sentence complexity

### Morphology / Formatting

- **Text block size**
  - Triggering factor: Health literacy level
  - Factor value: `low`
  - Activation weight: `0.9`
  - Computed activation score: `not computed`
  - Text effect: Use short paragraphs and avoid dense text blocks
  - Modified text feature(s): Paragraph density
- **Bold**
  - Triggering factor: Memory
  - Factor value: `possible_deficit`
  - Activation weight: `0.75`
  - Computed activation score: `not computed`
  - Text effect: Bold only the most important terms or messages
  - Modified text feature(s): Emphasis
- **Bullet Points/Lists**
  - Triggering factor: Memory
  - Factor value: `possible_deficit`
  - Activation weight: `0.75`
  - Computed activation score: `not computed`
  - Text effect: Summarize key information as bullet points
  - Modified text feature(s): Paragraph density, List structure
- **Font Size**
  - Triggering factor: Age
  - Factor value: `elderly_65_plus`
  - Activation weight: `0.65`
  - Computed activation score: `not computed`
  - Text effect: Support larger readable text in the demo or output
  - Modified text feature(s): Visual accessibility
- **Enumeration (Steps)**
  - Triggering factor: Processing speed
  - Factor value: `possible_deficit`
  - Activation weight: `0.6`
  - Computed activation score: `not computed`
  - Text effect: Present key information step by step
  - Modified text feature(s): Sequential structure

### Content - Good Practices

- **Repeat Information**
  - Triggering factor: Memory
  - Factor value: `possible_deficit`
  - Activation weight: `0.75`
  - Computed activation score: `not computed`
  - Text effect: Repeat the main message near the end
  - Modified text feature(s): Information repetition
- **Positive information first**
  - Triggering factor: Worry / anxiety
  - Factor value: `0.85`
  - Activation weight: `0.85`
  - Computed activation score: `0.722`
  - Text effect: Mention slow progression and regular monitoring early
  - Modified text feature(s): Positive framing
- **Reassurance (it's ok phrases)**
  - Triggering factor: Worry / anxiety
  - Factor value: `0.85`
  - Activation weight: `0.85`
  - Computed activation score: `0.722`
  - Text effect: Add one calming sentence after explaining the diagnosis
  - Modified text feature(s): Emotional framing
- **Order of information**
  - Triggering factor: Uncertainty
  - Factor value: `0.8`
  - Activation weight: `0.8`
  - Computed activation score: `0.640`
  - Text effect: Start with stabilizing information then explain disease details
  - Modified text feature(s): Information order

## Prompt-ready adaptation instructions

1. Use **Complexity of medical terms** (Content - Lexical) because of **Health literacy level** (value: `low`).
   - Expected text effect: Explain CLL immediately after naming it
   - Text feature(s): Term explanation
2. Use **Simplified Language** (Content - Lexical) because of **Health literacy level** (value: `low`).
   - Expected text effect: Use common words and direct explanations
   - Text feature(s): Language complexity
3. Use **No conditionals** (Content - Syntax & Grammar) because of **Health literacy level** (value: `low`).
   - Expected text effect: Avoid complex if-then constructions where possible
   - Text feature(s): Conditional complexity
4. Use **Text block size** (Morphology / Formatting) because of **Health literacy level** (value: `low`).
   - Expected text effect: Use short paragraphs and avoid dense text blocks
   - Text feature(s): Paragraph density
5. Use **Simplified Medical Terms** (Content - Lexical) because of **Medical knowledge** (value: `low`).
   - Expected text effect: Use blood cancer instead of hematological malignancy
   - Text feature(s): Terminology complexity
6. Use **Bold** (Morphology / Formatting) because of **Memory** (value: `possible_deficit`).
   - Expected text effect: Bold only the most important terms or messages
   - Text feature(s): Emphasis
7. Use **Bullet Points/Lists** (Morphology / Formatting) because of **Memory** (value: `possible_deficit`).
   - Expected text effect: Summarize key information as bullet points
   - Text feature(s): Paragraph density, List structure
8. Use **Repeat Information** (Content - Good Practices) because of **Memory** (value: `possible_deficit`).
   - Expected text effect: Repeat the main message near the end
   - Text feature(s): Information repetition
9. Use **No conditionals** (Content - Syntax & Grammar) because of **Worry / anxiety** (value: `0.85`).
   - Expected text effect: Avoid conditional phrasing that may increase anxiety
   - Text feature(s): Conditional complexity
10. Use **Positive information first** (Content - Good Practices) because of **Worry / anxiety** (value: `0.85`).
   - Expected text effect: Mention slow progression and regular monitoring early
   - Text feature(s): Positive framing
11. Use **Reassurance (it's ok phrases)** (Content - Good Practices) because of **Worry / anxiety** (value: `0.85`).
   - Expected text effect: Add one calming sentence after explaining the diagnosis
   - Text feature(s): Emotional framing
12. Use **Secondary sentences** (Content - Syntax & Grammar) because of **Educational level** (value: `middle_school_graduate`).
   - Expected text effect: Avoid long subordinate clauses
   - Text feature(s): Sentence complexity
13. Use **Font Size** (Morphology / Formatting) because of **Age** (value: `elderly_65_plus`).
   - Expected text effect: Support larger readable text in the demo or output
   - Text feature(s): Visual accessibility
14. Use **Order of information** (Content - Good Practices) because of **Uncertainty** (value: `0.8`).
   - Expected text effect: Start with stabilizing information then explain disease details
   - Text feature(s): Information order
15. Use **Enumeration (Steps)** (Morphology / Formatting) because of **Processing speed** (value: `possible_deficit`).
   - Expected text effect: Present key information step by step
   - Text feature(s): Sequential structure

## Reasoning summary

Otto's profile activates adaptations mainly because of low health literacy, low medical knowledge, high worry/anxiety, high uncertainty, inferred memory difficulty, inferred processing speed difficulty, older age group, and educational level.
The strongest adaptation needs are simplified language, simplified medical terms, reassurance, positive framing, ordered information, short text blocks, bullet points, repetition, and reduced conditional or complex sentence structures.
The reasoning separates Otto-specific factor values from stable HEALIE model weights.