---
name: rvc-c-compliance
description: Audit how RVC SASD requirements and approved module interfaces are implemented in C11 using Trail of Bits specification compliance methods. Use for SA/SD-to-code conformance, missing behavior, or requirement-level implementation evidence.
---

# RVC SASD to C compliance

Read `docs/verification/review-contract.md`, `.specify/rvc-review-map.toml`, and the active Trail of Bits `spec-to-code-compliance` skill, including `resources/DOMAIN_NOTES.md` (C/C++), `ANALYSIS_FORMAT.md` and `DIVERGENCE_RUBRIC.md`. Discover the active plugin path; do not hard-code a personal cache version.

## Evidence boundary

The specification is the original B1–B7 + C1–C16, relevant SA/PSPEC/FSM, and approved SD interfaces and decisions. Q6 is resolved by C16: side obstacles alone do not initiate avoidance while Forward with a clear front; C9 still governs post-backing decisions. `artifacts/Implementation/module_traceability.md` is a search index to verify, not the specification. Never infer intended behavior from the function you are auditing.

Inspect `src/`, `include/`, `tests/`, `CMakeLists.txt`. Read callers, callees, every relevant branch, reset paths and Tick order. Compare one requirement at a time; split compound C/PSPEC obligations into sourced subclaims while keeping the original ID. Include SD module/parameter/return/call obligations, not just B/C text.

| Obligation | Starting points, not pre-established proof |
|---|---|
| B2–B4, C1/C2/C5/C6/C7/C8/C9, T0–T14 | `src/assess_obstacle_situation.c`, `movement_controller.c`, `step_timer.c`, `initialize_rvc.c`, `tests/test_movement_controller.cpp`, `test_step_timer.cpp` |
| B5, C3/C10/C11, PSPEC 4.1/4.2 | `src/power_up_timer.c`, `decide_cleaning.c`, `decide_actions.c`, `tests/test_power_up_timer.cpp`, `test_requirements.cpp` |
| C12/C13 initial sampling and no power-on output; C14 suction/mopping; C15 remembered dust | Read the revised SA before judging historical SD/C. Inspect initialization, sensor receipt/storage, power-up consumption and hardware output contracts; do not assume a pending field already exists. Track downstream changes separately until the revised SD is approved. |
| Data/commands and interfaces | `include/rvc_types.h`, all module headers, `src/issue_movement_output.c`, `put_outputs.c`, Data Dictionary, Structure Chart section 5 |
| Hidden state and call hierarchy | SD sections 4–6, source static state, `tests/expected_calls.txt`, `tests/check_call_hierarchy.cmake` |
| B6/B7 scope | `include/hw_interface.h`, fake hardware, simulator host; absent real hardware drivers are intentional |

Read all actual mapped modules; this table is not an exclusion list. Verify the 3.2.1 value-passing realization and the two outputs of 3.2.3 without imposing a new one-process/one-function rule. Separate accepted read-only queries from production calls.

## Execution and independent refutation

Use the plugin's native compliance workflow when the host exposes its required Workflow runtime. Inspect the installed `workflows/spec-compliance.js` interface and supply only supported arguments. Preserve its per-requirement results and refutation outcomes.

If that runtime is unavailable, explicitly identify this as a **Codex adapter using Trail of Bits criteria**, not a native workflow run. When subagents are available, use one independent reviewer per requirement/subclaim, bounded by available slots, and a different reviewer to try to refute each divergence against the document and code. Give each reader source paths, claim and required evidence; never give the suspected answer to the first reviewer. If independent execution is unavailable, mark findings as not independently refuted. Do not fabricate plugin tool calls or hide this limitation.

## Output

Retain the six native verdicts: `implemented`, `partial`, `contradicted`, `stronger-than-spec`, `absent`, `undecidable`. Code enforcement and execution are separate: `implemented` requires reading enforcement, not necessarily a newly executed test; label test status separately. An `absent` claim needs searches, alternative terms and inspected paths. Unexamined requirements are `notChecked`, never `absent`.

Write a sourced index and per-requirement evidence under `artifacts/Review/<run-id>/c-compliance/`. If the native workflow writes its own `spec-compliance/` folder, retain it and link/copy the actual run's evidence into this run directory without overwriting earlier runs. Include reverse tracing for undocumented behavior, document/code conflicts, refuted candidates and unverified claims. Do not modify C or adjust the specification to fit it during the audit. Authorized corrections and fresh tests belong to `rvc-superpowers-verify`.
