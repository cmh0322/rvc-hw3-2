# Independent refutation: tests and evidence

Method: Codex adapter using Trail of Bits criteria. Inspected actual tests, call checker/CMake selection, approved SD/C16, relevant C paths, simulator boundary and retained execution evidence. No builds or tests were rerun by this reviewer. Machine-readable references and corrections are in `tests.json`.

| Candidate | Refuted? | Result |
|---|---|---|
| P5-05 | No | Retain MEDIUM verification gap. `tests/test_initialize_rvc.cpp:24–34` and `tests/test_main.cpp:34–60` require initial motor Forward, contrary to C13/SC:23. `tests/test_power_up_timer.cpp:74–78` requires forgotten avoidance dust, contrary to C15. CMakeLists.txt:67–71 selects the old expected file; the checker reads that file at tests/check_call_hierarchy.cmake:33–57 rather than interpreting the revised SD. |
| P5-06 | No | Retain LOW optional traceability cleanup. C16 and the owner confirmation resolve Q6 (docs/requirements_clarifications.md:24,43–47), but tests/test_requirements.cpp:165–175 and Implementation module_traceability.md:111/test_report.md:142 retain the open-assumption label. Actual Forward behavior matches C16 (src/movement_controller.c:27–31). |

P5-05 concerns obsolete oracles, not another runtime defect. The retained `verification/ctest.log:297–302` reports 130 passing CTest entries: 129 GoogleTest cases and the call-hierarchy test. `coverage-summary.md:23` reports 115/115 lines and 36/36 branch outcomes. Those results coexist with six failing contract assertions (`probe-results.json:80–144`) and 14 missing/9 obsolete approved call edges (`approved-call-hierarchy.log:1–31`). The checker itself can already accept an approved baseline through EXPECTED; it is the maintained baseline and semantic expectations that require reconciliation during authorized TDD.

The rejected hardware candidate remains rejected: B6 excludes real hardware-control detail, C14 preserves that boundary, and src/put_outputs.c:7–10 forwards the abstract Clean command. This does not prove physical suction/mop behavior; the simulator reports commands without separate intensities.

The rejected information-hiding candidate remains rejected: SC:181 permits diagnostic value copies. The state/D3/D4 getter implementations return scalars without exposing writable storage (movement_controller.c:71–74, power_up_timer.c:39–42, step_timer.c:38–41). This does not excuse the separately missing D1/D2 contract.

The rejected eventual-Forward candidate remains rejected: C5/C9 permit repeated Backing while both sides remain blocked; SC:21 explicitly rejects unconditional eventual Forward. The implementation selects another Backing step (movement_controller.c:32–57).

The inference that existing PASS proves revised SD conformance is refuted by the actual obsolete expectations and approved-baseline failure. Existing test execution, document/code compliance and web-based system tests must remain distinct.

No material inaccurate source claim was found in `sd-analysis.md`. Minor precision corrections: its SC:222 reference should be SC:221; qualify “only dust state is D3” as the production controller under src/ because fake/simulator adapters retain current sensor values; the simulator host actually parses four integer fields, while its documented and JavaScript-produced protocol uses 0/1. These corrections do not alter any verdict. Approval is supported by this run's approval.md despite historical pending text in the unchanged SD.

Only the refutation JSON and this Markdown were written. No source, maintained test baseline, SD artifact or build output was changed.
