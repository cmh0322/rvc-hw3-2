---
name: rvc-bmad-review
description: Review RVC requirements and SASD artifacts with BMAD, using project-specific evidence and balancing rules. Use for RVC SA/SD review or a requested overall artifact review.
---

# RVC BMAD review

Read `docs/verification/review-contract.md` from the project root. This skill is a project adapter for the installed `.agents/skills/bmad-review/SKILL.md`; load and execute that skill with the team override `_bmad/custom/bmad-review.toml`.

## Scope and handoff

- Respect a named artifact or phase. If the user requests all outputs, inventory them using `.specify/rvc-review-map.toml` and review in dependency order: events/context → DFD levels with dictionary/PSPEC → FSM interface → transform analysis/structure chart → implementation/system claims. Prior approval remains a review baseline, not proof of correctness.
- Default lenses for SASD: `adversarial`, `edge-case-hunter`, `sasd`. Add `structure`/`prose` for requested presentation/editing work and `verification-gap` when code/test adequacy is in scope. The project adversarial override replaces minimum-count criticism with evidence-based findings.
- Pass `AGENTS.md`, both requirement files, the shared review contract, and relevant parent/child documents to each reviewer. Do not judge a DFD child without its parent or a module without its interface and mapping.
- Use a new `artifacts/Review/<run-id>/bmad/` directory for report(s), canonical findings JSON and read-file inventory. Keep original files unchanged in review mode.
- Enumerate external boundary sets per parent, process/flow identifiers, dictionary entries and module mappings as evidence; diagram rendering alone is not semantic verification.

Use `rvc-speckit-review` for a full traceability matrix, `rvc-c-compliance` for per-requirement C enforcement, and `rvc-fsm-verify` for executable FSM checks when those scopes are requested. A general document review can recommend these without claiming they ran. No implementation workflow is activated merely by reviewing a defect.
