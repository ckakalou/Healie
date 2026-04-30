# HEALIE – Health Information Enhancement

HEALIE (HEALth Information Enhancement) is a research system for personalised medical content generation, designed to support patient empowerment through improved health literacy.

The system combines a **weighted Knowledge Graph (KG)** with **Large Language Models (LLMs)** to generate patient-specific medical information tailored to individual cognitive, clinical, and socio-economic profiles.

---

## 🎯 Objective

The goal of HEALIE is to operationalise health literacy as a **computable model**, enabling automated adaptation of medical content based on:

- Cognitive factors (e.g. memory, knowledge, worry, uncertainty)
- Social Determinants of Health (SDoH)
- Demographic characteristics
- Clinical information

---

## 🧠 Core Contribution

HEALIE introduces a **Knowledge Graph-based representation of health literacy**, where:

- Cognitive and socio-economic factors are explicitly modelled
- Relationships between factors and health literacy dimensions are represented
- The **importance of each factor is encoded through weighted relationships**
- Graph traversal is used to identify patient-specific needs
- These needs directly influence the generated medical content

This approach enables explainable, structured, and reproducible personalisation.

This aligns with the HEALIE model, where cognitive and socio-economic factors are mapped to health literacy dimensions and incorporated into the Knowledge Graph with weighted relationships :contentReference[oaicite:0]{index=0}.

---

## 🏗️ System Architecture

HEALIE follows a Retrieval-Augmented Generation (RAG) pipeline:

1. **Patient Profile Input**
2. **Knowledge Graph Retrieval (Neo4j + Cypher)**
3. **Graph-based reasoning (weighted paths, factor influence)**
4. **Context and adaptation strategy extraction**
5. **Prompt construction**
6. **Content generation using LLMs**
7. **Evaluation (readability, faithfulness, relevance)**

The system integrates graph-based retrieval, embeddings, ranking, and prompt engineering to produce personalised health content :contentReference[oaicite:1]{index=1}.

---

## 🧩 Knowledge Graph Design

The HEALIE Knowledge Graph integrates multiple domains:

- Clinical Data
- Patient Profiles
- Cognitive Factors
- Social Determinants of Health (SDoH)
- Text Generation Elements

These are organised into interconnected node clusters, enabling end-to-end reasoning from patient characteristics to content adaptation.

The KG includes:
- Nodes (entities)
- Relationships (semantic and influence-based)
- Properties (including weights and scores)

This structure enables modelling how different factors influence health literacy and content generation :contentReference[oaicite:2]{index=2}.

---

## 👤 Example Use Case

HEALIE generates personalised content for patient profiles such as:

- **Otto**: elderly patient with low health literacy, high worry and uncertainty  
  → simplified language, reassurance, repetition, structured summaries

- **Maya**: child patient  
  → simplified explanations, analogies, child-friendly language

The system dynamically adapts terminology (e.g. “hematological cancer” → “blood cancer”) and structure (e.g. bullet summaries, repetition) based on cognitive needs :contentReference[oaicite:3]{index=3}.

---

## 🛠️ Technologies

- **Neo4j** – Knowledge Graph storage and traversal
- **Cypher** – Graph querying
- **Protégé** – Ontology design
- **LangChain** – RAG orchestration
- **OpenAI LLMs** – Content generation
- **Streamlit / HuggingFace** – Demo interface (in progress)

---

## 📊 Evaluation

HEALIE evaluates generated content using:

- Readability metrics
- Context relevance and recall
- Answer relevance
- Faithfulness to retrieved knowledge
- Health literacy alignment

---

## 🚧 Status

This repository contains the **final PhD implementation (HEALIE vFinal)**, including:

- Weighted Knowledge Graph schema
- Neo4j implementation
- RAG pipeline
- Demo use cases
- Evaluation framework

---

## 📚 Research Context

This work builds on previous HEALIE research, including:

- Knowledge Graph-based personalised content generation
- Integration of cognitive and socio-economic factors
- Transition from template-based NLG to LLM-based RAG pipelines

As described in prior work, HEALIE combines Knowledge Graphs and language models to generate personalised medical content tailored to patient needs :contentReference[oaicite:4]{index=4}.

---

## 👩‍💻 Author

Christina Asimina Kakalou  
PhD Candidate – Artificial Intelligence & Health Informatics
