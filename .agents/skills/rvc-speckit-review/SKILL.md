---
name: rvc-speckit-review
description: Apply Spec Kit consistency and requirements-quality checks to existing RVC SA/SD files through the RVC mapping, without creating a new feature. Use for traceability, omissions, contradictions, or requirements checklist requests.
---

# RVC Spec Kit adapter

Read `docs/verification/review-contract.md` and `.specify/rvc-review-map.toml` from the project root.

This is an explicit project adaptation of Spec Kit's six analysis passes and requirements-quality checklist method. Native `speckit-analyze` still requires its feature folder and generated tasks; **do not invoke its prerequisite command on these mapped documents, fabricate tasks.md, or claim its native workflow ran**. Read the installed `speckit-analyze` detection/severity/report guidance and `speckit-checklist` requirements-quality guidance as method references. This adapter defines its own input discovery and reports the method as “RVC-adapted Spec Kit analysis”. No new branch or product specification is needed.

## Analysis

1. Resolve every mapped path and re-enumerate B/C/Q, process, flow, state, module and test identifiers from the current source. A stale manifest is a configuration gap, not a product defect. Missing required artifacts are unreviewable; continue independent parts and list gaps.
2. Read the original requirement wording and all relevant mapped artifacts. Treat `evidence_indexes` as leads, never as proof. No copied spec/plan is authoritative.
3. Apply duplication, ambiguity, underspecification, project-rule alignment, coverage gaps and inconsistency checks to the mapped documents. Check data/control naming and parent/child interfaces, not merely matching words.
4. Build a matrix: requirement ID → event/flow → SA process/PSPEC → FSM transition if applicable → SD module/interface → C symbol → unit/system test → evidence/status. Distinguish an explicit mapping, verified meaning, executed test, and human approval. B6/B7 are scope constraints; `not applicable` requires a reason. C16 has a confirmed requirement row; retain Q6 as its resolved question provenance, not an additional requirement or open assumption.
5. Run reverse tracing: identify flows, states, modules and behaviors with no supporting requirement/design decision. A design refinement can be legitimate; lack of a one-to-one requirement ID alone is not a defect.
6. Report original-source locations on both sides of each discrepancy. Coverage numerator/denominator must state which applicable requirement-to-artifact links were actually reviewed. Unchecked or absent evidence does not count as covered; task coverage is not meaningful for this adapter.

## Checklist mode

Produce requirements-quality questions, not execution tests: are 5-tick boundaries defined; are reset/freeze semantics stated; are side priority and post-backing front independence explicit; is Q6 recorded as resolved by C16, with Forward avoidance entry distinguished from C9; do terms and interfaces agree? Tie every question to B/C/Q or an AGENTS rule. Generate unchecked items. Only evaluate them when the user requests evaluation; checked means document quality satisfied, not C implementation passed.

## Output

Create `artifacts/Review/<run-id>/traceability/report.md`, `matrix.md`, and, when requested, `checklist.md`. Report missing inputs and unreviewed rows. Read-only applies to source artifacts; writing these review outputs is part of this adapter. Do not invoke `speckit-specify`, `plan`, `tasks`, `implement`, or `converge` as an automatic next action. Route content/design findings to BMAD and code enforcement questions to `rvc-c-compliance` within the user's requested scope.
