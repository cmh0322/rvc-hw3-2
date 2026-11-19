# Current implementation test report — 2026-11-18

121/121 CTest entries passed: 120 GoogleTest cases and one call_hierarchy check against the approved 31-call structure. Superseded polling and startup-output tests were replaced by readiness/store/event tests; this count is not compared as a coverage percentage with the previous 129 cases. Movement/step boundary and requirement behavior tests remain active.

Red: four requirement regressions were compiled/run against old production C; all four failed for C12/C13/C15. Green: those same four assertions pass after porting input delivery to the approved event interface. New tests also cover TRUE/FALSE before Tick, initial dust pulses, events queued during output, 100 queued pulses coalesced to one five-tick boost, false sample validity, store copies, no sensor-only outputs/timer advance, paused residual precedence and C16. No compiler-error baseline is used as TDD Red evidence.

Commands, logs, limitations and fresh coverage are in [correction report](../Review/20261118-213657-phase5-fixes/verification/report.md). Browser/API regressions ran against the production C simulator host. All 21 existing scenarios also produced 100-tick headless traces; no human PASS/FAIL was submitted. Physical C14 actuator behavior remains B6 scope exclusion. Q6 is owner-confirmed C16.
