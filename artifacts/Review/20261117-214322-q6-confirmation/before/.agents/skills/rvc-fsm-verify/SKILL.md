---
name: rvc-fsm-verify
description: Model and verify the RVC Movement Controller FSM with SPIN, including Tick ordering, five-tick steps, explicit environment assumptions and counterexamples. Use for FSM formal verification; code conformance remains a separate audit.
---

# RVC FSM verification

Read `docs/verification/review-contract.md` and [the model contract](references/model-contract.md). Primary inputs are `artifacts/SA/DFD/dfd_level_4_fsm.md`, Level 3, Process Specification 3.2.4, Data Dictionary, B/C/Q requirements and SD Tick ordering. C code is a later comparison target, not the source from which to copy a supposedly independent model.

## Work products

For each requested verification run create a new `artifacts/Review/<run-id>/fsm/` with:

- `model.pml`: independently translated FSM plus explicit timer/environment abstraction.
- `mapping.md`: every T0–T14 guard/action, state, timer update and source location; list intentionally abstracted behavior.
- `properties.md`: property ID, requirement/source, assumptions, safety/liveness/reachability type and exact executable check.
- `report.md`: model version/hash, tools, exhaustive/bounded scope, results, state/transition counts, warnings, counterexample traces, untested properties. Keep model correctness review separate from model-checker outcomes.

Build only requested scope; movement-only verification does not claim C10/C11 or cleaning correctness. Do not create a Level 4 Process Specification.

## Run and inspect

Find `spin` and the configured GCC. If Windows PATH has not refreshed, use the user's `.local/bin/spin.exe` and the compiler from `build/CMakeCache.txt`, or explicit tool paths. The portable helper below captures generation, compilation, search and replay logs and rejects incomplete searches:

```text
python3 .agents/skills/rvc-fsm-verify/scripts/run_spin.py --model <model.pml> --out <new-run-directory> --cc <gcc-path>
python3 .agents/skills/rvc-fsm-verify/scripts/run_spin.py --model <model.pml> --out <new-property-directory> --cc <gcc-path> --ltl <claim-name>
```

The helper requires a new/empty output directory. Use self-contained Promela models so the model hash captures the full input. Run each named LTL claim separately. `passed` means only the configured check over that model finished with zero reported errors. Inspect unreachable-code output and review the translation before interpreting it as requirement evidence. A failed check must be replayed and classified as a model mistake, unsupported property/environment assumption, or a candidate source-FSM defect. The helper attempts replay and keeps the raw log; validate it manually.

For state/transition reachability, deliberately assert the target is never reached in a separate probe model; a resulting counterexample is a witness, not a product failure. Keep probe results separate from safety/liveness checks. No eventual-forward claim without explicit environmental assumptions. System testing still uses the web simulator.
