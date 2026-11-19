# Phase 5 execution record

2026-11-18 Asia/Seoul. Existing Ninja build and GCC 15.2.0 from the configured `build/CMakeCache.txt` were used. Production remains C11; GoogleTest is C++17. No production or existing test source was changed.

| Command | Exit | Observed result |
|---|---:|---|
| `cmake --build build` | 0 | Current C, tests and simulator host built; build.log |
| `ctest --test-dir build --output-on-failure` | 0 | 130/130 including call_hierarchy; ctest.log |
| `cmake --build build --target coverage` | 0 | Fresh counters; 115/115 lines and 36/36 branch outcomes; coverage.log and coverage-summary.md |
| `python artifacts/Review/20261118-101242-phase5-c-compliance/verification/run_probes.py` | 0 | Harness and approved-call-graph mismatch executed and captured as expected; probe-results.json |
| Underlying compliance_probe executable | 1 | 6 failed contract assertions, 4 passing controls; compliance-probe.log |
| Existing CMake call checker against review-local approved_expected_calls.txt | 1 | 14 missing and 9 obsolete calls vs approved SD; approved-call-hierarchy.log |

The probe runner's exit 0 means it successfully captured the expected failures. It does **not** mean C compliance passed. The unmodified implementation failed the requirement-derived assertions. Coverage reflects the existing suite's execution of existing code, not requirement completeness. The obsolete `DustSeenOnlyWhileAvoidingIsNotRemembered` and initial Forward expectations themselves pass.

The first probe compile attempt used an absolute Korean output path and failed in the MinGW assembler before running any probe. The harness runner now passes workspace-relative compiler paths. The subsequent compilation and linking succeeded under `-std=c11 -Wall -Wextra -Wpedantic -Werror`. This was a tool invocation correction, not a source fix.

The initial execution occurred at approximately 10:14–10:16. After a session interruption, work resumed at 15:33; all 77 baseline-protected files were hash-compared and unchanged before continuing the audit. These logs remain valid evidence for the same inputs. This record is not a newly repeated test run at resume time.

No SPIN rerun, browser simulator execution, human system-test evaluation or production correction was performed. Simulator source inspection and the C audit harness are not web-based system testing. Existing failing contract checks must be resolved before an implementation can be accepted; this audit can conclude with confirmed gaps.
