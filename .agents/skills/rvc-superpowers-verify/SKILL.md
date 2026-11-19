---
name: rvc-superpowers-verify
description: Validate RVC review findings, apply authorized fixes with TDD, and record fresh verification evidence using Superpowers. Use when responding to review feedback, fixing confirmed RVC defects, or checking a change before completion.
---

# RVC finding resolution and verification

Read `docs/verification/review-contract.md`. Discover the active Superpowers plugin and read `receiving-code-review` and `verification-before-completion`. If unavailable, report that dependency and apply this project's evidence policy without claiming Superpowers executed.

## Decide what is authorized

Classify each finding as confirmed, refuted, ambiguous, or optional against the cited requirements and actual paths. Preserve its original ID. Check C9–C11 and C16 (which resolves Q6) before changing behavior. Review feedback is not automatically correct. A request to verify alone does not authorize fixing source files; a request to fix covers the named changes, subject to the project's phase approval rules. Record a concrete proposal for new requirements/phase transitions requiring human decision.

## Select checks by changed behavior

| Change | Evidence required |
|---|---|
| Event/Context/DFD/Dictionary/PSPEC | Re-run relevant BMAD and traceability scope, adjacent-level balancing, affected definitions; render changed Mermaid if a renderer is available. Rendering alone is insufficient. |
| SD hierarchy/interface | SA↔SD mapping and the actual call contract; inspect `tests/expected_calls.txt` against the chart before trusting call_hierarchy. |
| C logic | Requirement-derived failing regression before fix, minimal C11 correction, pass/refactor cycle, affected tests then required project checks. |
| FSM/timer semantics | Boundary-tick regression plus `rvc-fsm-verify` if the formal model/claims are affected; keep D3 and D4 separate. |
| Simulator | Build `rvc_sim_host`, exercise affected web scenarios, record traces and human evaluation status. A unit test is not a web system test. |

## Actual build environment

Inspect `CMakeLists.txt`, existing `build/CMakeCache.txt`, and tool versions. Prefer the existing compiler/generator; do not silently switch an existing build directory to another compiler. On this project's Windows setup, the previously configured GCC/Ninja directory is `D:/MSYS2/mingw64/bin`; check its existence and derive current paths from CMakeCache instead of requiring every teammate to use that drive. Put the selected compiler tools first in the current process PATH.

Run as applicable from the project root, sequentially, checking each exit code:

```text
cmake -S . -B build -G Ninja
cmake --build build
ctest --test-dir build --output-on-failure
cmake --build build --target coverage
```

Use configure only when needed; a fresh verification build may use another directory. Coverage must use the project's `coverage` target because of the documented Windows Korean-path workaround. Read `build/coverage/summary.md` and raw output after execution. Check that `call_hierarchy` actually ran (it is conditional on compiler support), not only that CTest returned zero. Production must remain C11/GCC; C++17 GoogleTest and fake hardware are intentional. Never hard-code 129 tests or 100% coverage as the observed result.

## Evidence ledger

Write `artifacts/Review/<run-id>/verification/report.md` and logs, recording finding ID, accepted/refuted reasoning, changed files, red/green evidence for code fixes, actual commands and exit codes, test counts, measured coverage, skipped checks and residual risk. Do not claim a failing baseline was observed if only the fixed code ran. For document-only corrections, do not invent unit tests or rerun unrelated suites. Do not commit/push or declare phase approval unless requested.
