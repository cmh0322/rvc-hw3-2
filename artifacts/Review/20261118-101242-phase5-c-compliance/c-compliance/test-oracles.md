# Existing test expectations versus approved revision

Existing execution: 130/130 CTest entries passed, including 129 GoogleTest cases and one call_hierarchy check. Coverage was freshly measured as 115/115 C lines and 36/36 branch outcomes. The following expectations demonstrate why neither result proves conformance to the approved revision.

| Existing expectation / index | Conflict or limitation | Required correction during authorized TDD |
|---|---|---|
| tests/test_initialize_rvc.cpp:27–35 expects initial Forward and only motor hardware call | C13 forbids output; C12 requires initial sensor acquisition | Tests for no output, all four actual initial samples and blocked-front first Tick |
| tests/test_main.cpp:37–41,45–64 expects motor before Tick and sensor reads only after Tick | Superseded SD loop and startup contract | Ordered sensor/Tick event tests, readiness boundary, input receipt while controller is busy |
| tests/test_power_up_timer.cpp:74–77 `DustSeenOnlyWhileAvoidingIsNotRemembered` | Opposite of C15 | Detection retained through FALSE, first-Forward full five ticks, pending precedence over saved count |
| tests/rvc_system_fixture.h:15–19 resets fake output history after initialization | Requirement-level Tick tests cannot expose startup output | Separate lifecycle tests that preserve startup evidence |
| tests/expected_calls.txt:3–28 encodes old 26 calls | CTest call_hierarchy compares this file, not current SD text | Update expected graph with C implementation after approved TDD; current approved-graph audit fails |
| tests/test_requirements.cpp ending Q6 assumption section | Behavior now required by C16; test does exercise correct behavior | Rename/re-source to C16; low-priority traceability cleanup, not a new logic defect |
| artifacts/Implementation/module_traceability.md and test_report.md say Q6 remains open | Historical indexes are stale | Refresh implementation evidence after corrections; do not reinterpret C16 as undecided |

These are reviewed expectations, not newly executed failure regressions in the production suite. The separate audit harness in ../verification runs against unchanged production C and records six failed assertions for C12/C13/C15. Preserve that baseline as evidence; convert the scenarios into maintained regression tests when implementation correction is authorized. Do not merely relax the tests to make them green.
