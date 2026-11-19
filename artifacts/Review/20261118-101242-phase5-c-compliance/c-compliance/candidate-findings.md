# Candidates for independent refutation

These are proposed findings, not final independently confirmed results. Check their specification interpretation and actual code paths; amend/refute as warranted. Do not infer physical hardware requirements beyond B6. No implementation changes have been authorized by the Phase 5 audit request.

## P5-01 — Power-on issues Forward before first sensor decision

Proposed HIGH, confirmed-code-divergence candidate, native verdict contradicted for C13. Spec: docs/requirements_clarifications.md:21, SA FSM T0 and SC:23. Code: initialize_rvc.c:10–13 → issue_movement_output.c:17 → drive_motor; main.c:12 calls initialization before wait_for_tick. Audit probe sees one motor command before first wait (expected 0); no initial Clean output (passes). Impact: front may be blocked yet startup sends Forward before any sensor evaluation. Do not claim observed physical collision. Minimum fix: state-only void reset; remove initialization output; first Tick handles output.

## P5-02 — No initial four-sensor acquisition/readiness barrier

Proposed MEDIUM, C12/SD partial-or-absent acquisition obligation. Spec SC:17,23 and PSPEC0:38–40, C12. Code initialize_rvc.c has no reads; main waits for Tick before get_inputs polls all four. Probe sees zero actual initial reads at entry to first clock wait, expected four. Be precise: current Tick decisions do read all four before output; do not allege that Controller decides with uninitialized C locals. Gap is the approved pre-first-Tick input boundary and distinct actual-read readiness. Minimum fix: initial actual sensor acquisition and four valid flags before enabling Tick delivery.

## P5-03 — Dust observed during avoidance is forgotten

Proposed HIGH, C15 partial (some no-pending/current cases work). Spec C15, PSPEC2:131–133 and 4.1:367–395. detect_dust.c returns current bool; power_up_timer.c:14–28 ignores dust on Avoiding without storing it. Trace: stop with dust TRUE, then dust FALSE through turn, resume Forward: Clean Start / remaining 0 instead of Power Up / remaining 4. When paused count was 3 and a new dust detection occurs in avoidance, resumption gives remaining 2 instead of 4. Both probes executed against unchanged C. Minimum fix: D2 current/pending store, OR TRUE on input, consume pending only Forward, restart5 overrides paused count. Do not break correct no-new-dust C11 resume.

## P5-04 — Approved ordered input/event and storage interfaces are not implemented

Proposed HIGH for received-event loss; absent SD-EVENT/SD-STORE obligations, related to P5-02/P5-03, not an extra business requirement. SC:13–23,136–148,185–220 specifies event delivery, serialization and private D1/D2 accessors. Existing main→wait→controller→get_inputs polling cannot receive a sensor-only update or retain intermediate TRUE/FALSE before Tick. No receive/dispatch/readiness/get-D2/clear-pending interface exists; source searches and whole input path reviewed. Simulator host accepts only four sensor bits per Tick. Compiled approved call graph misses14 and retains9old calls; shared signatures also differ. Probe explicitly calling existing detect_dust(TRUE), detect_dust(FALSE), controller loses detection, but is not claimed to be a production asynchronous path (none exists). Minimum fix: implement approved event adapter and Sensor Store across production headers, main and fake/simulator adapters. D2 alone will not capture updates never delivered by per-Tick polling.

## P5-05 — Existing tests and call baseline enforce superseded behavior

Proposed MEDIUM verification-gap finding (not an independent runtime bug). test_initialize_rvc.cpp:25–34 and test_main.cpp:34–59 demand initial Forward; test_power_up_timer.cpp:74–78 demands forgotten avoidance dust. expected_calls.txt still holds26old calls; check_call_hierarchy.cmake compares to that file, not SD. All130CTest pass and coverage100%, while new contract probes fail6assertions and approved graph fails. Minimum fix: derive maintained regressions and call baseline from approved SD during authorized TDD; retain baseline failure evidence. This finding is about obsolete oracle, not lack of coverage percentage.

## P5-06 — C16 still labelled open Q6 in implementation evidence

Proposed LOW optional traceability cleanup. Actual Forward front-only behavior is correct. tests/test_requirements.cpp last Q6 section, artifacts/Implementation/module_traceability.md:111 and test_report.md:142 still call Q6 open assumption. Requirement C16 is owner-confirmed. Minimum fix labels and evidence citations during implementation-report refresh; no new business question or movement branch change.

## Candidates to reject unless new evidence supports them

- Missing real suction/mop motor drivers violates C14: B6 explicitly excludes physical hardware. C sends abstract Clean commands; C14 actuator interpretation is a boundary limitation, not proof of wrong mopping.
- State/D3/D4 read-only getters violate information hiding: current SD explicitly permits copy-return diagnostic queries.
- Backing forever violates eventual Forward: C5/C9 permit repeated backing, no unconditional liveness requirement.
- Calling existing tests PASS proves revised SD conformance: contradicted by their actual oracle and executed probes.
