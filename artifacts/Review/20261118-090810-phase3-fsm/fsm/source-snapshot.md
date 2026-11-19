## AGENTS.md

1: 
2: # RVC Project Instructions
3: 
4: ## Project Overview
5: - Develop a Robotic Vacuum Cleaner (RVC) system.
6: - Use SASD-Guided Spec-Driven Development (SDD).
7: - Use AI Coding Agents to support the development process.
8: 
9: ## Development Process
10: - Follow the SASD-Guided SDD workflow.
11: - Complete Structured Analysis (SA) before Structured Design (SD).
12: - Complete SD before implementation.
13: - Follow Test-Driven Development (TDD) during implementation.
14: - Perform system testing after implementation.
15: 
16: ## Implementation Constraints
17: - Implement production code in C.
18: - Use C11 as the language standard.
19: - Use GCC for compilation.
20: 
21: ## Agent Responsibilities
22: - Follow the defined development workflow.
23: - Use approved artifacts from previous phases.
24: - Maintain consistency between development artifacts.
25: - Do not proceed to the next phase without human approval.
26: - Report missing or ambiguous requirements.
27: - Do not claim verification success without executing tests.
28: 
29: 
30: ## Structured Analysis Guidelines
31: - Generate SA artifacts using the corresponding skills.
32: - Generate the Event List before the System Context Diagram.
33: - Use preliminary_requirements.md as the primary source.
34: - Ensure consistency between related SA artifacts.
35: - Do not invent requirements or unsupported behavior.
36: - Save all SA artifacts under artifacts/SA/.
37: 
38: 
39: ## Structured Analysis Workflow
40: 
41: 1. Generate the Event List from preliminary requirements.
42: 2. Generate the System Context Diagram from the Event List.
43: 3. Generate DFD Levels 0 through 3 using hierarchical functional decomposition, incrementally updating the Data Dictionary and Process Specifications at each level.
44: 4. Generate the Controller FSM as DFD Level 4.
45: 5. Verify consistency across all SA artifacts.
46: 6. Present the completed SA artifacts for human approval before proceeding to SD.
47: 
48: 
49: ## Structured Analysis Constraints
50: - Use `preliminary_requirements.md` as the primary source.
51: - Preserve consistency between the Event List and Context Diagram.
52: - Maintain DFD balancing between adjacent levels.
53: - Use consistent process numbering and flow names.
54: - Update the Data Dictionary and Process Specifications after each DFD level (0-3).
55: - Describe every process in DFD Levels 0-3.
56: - Do not generate Process Specifications for the Level 4 FSM.
57: - Use Mermaid for DFD and FSM diagrams.
58: - Do not invent unsupported requirements or behavior.
59: 
60: 
61: 
62: ## Structured Design Guidelines
63: - Generate SD artifacts using the corresponding skills.
64: - Perform Transform Analysis before generating the Structure Chart.
65: - Use approved SA artifacts as the primary source.
66: - Derive the module hierarchy from SA functional decomposition.
67: - Apply information hiding, modularity, low coupling, and high cohesion.
68: - Ensure consistency and traceability between SA and SD artifacts.
69: - Do not introduce unsupported functionality or behavior.
70: - Save all SD artifacts under artifacts/SD/.
71: 
72: 
73: ## Structured Design Workflow
74: 
75: 1. Perform Transform Analysis using approved SA artifacts.
76: 2. Identify Afferent Flow, Central Transformation, and Efferent Flow.
77: 3. Derive a hierarchical module structure from the functional decomposition.
78: 4. Generate the Structure Chart using Mermaid.
79: 5. Verify consistency with SA artifacts and obtain human approval before TDD.
80: 
81: ## Structured Design Constraints
82: - Use approved SA artifacts as the design basis.
83: - Distinguish module calls from DFD data flows.
84: - Apply information hiding, modularity, low coupling, and high cohesion.
85: - Define clear module responsibilities and interfaces.
86: - Maintain traceability between SA processes and SD modules.
87: - Do not introduce unsupported system behavior.
88: - Do not proceed to TDD without human approval.
89: 
90: 
91: 
92: ## Required Deliverables
93: 
94: ### Structured Analysis (SA)
95: - Context Diagram
96: - Event List
97: - Data Flow Diagrams (DFD Levels 0-4)
98: - Finite State Machine (FSM)
99: - Data Dictionary
100: - Process Specifications
101: 
102: ### Structured Design (SD)
103: - Transform Analysis
104: - Structure Chart
105: 
106: ### Test-Driven Development (TDD)
107: - Unit Test Cases
108: - Test Execution Results
109: - Test Coverage Report
110: - Implementation Source Code
111: 
112: ### System Testing
113: - Web-based RVC Simulator
114: - System Test Scenarios
115: 
116: ## Testing Policy
117: - Derive test cases from requirements and approved SA artifacts.
118: - Follow the Red-Green-Refactor cycle.
119: - Measure and report test coverage.
120: - Do not proceed when required tests fail.
121: - Execute system tests using a web-based RVC simulator.
122: 
123: ## Codex Verification Routing
124: 
125: For requested RVC review, compliance, or verification work, read
126: `docs/verification/review-contract.md` and choose the project adapter by role:
127: 
128: - `rvc-bmad-review`: overall requirements/SA/SD review using BMAD and the SASD lens.
129: - `rvc-speckit-review`: requirements quality and cross-artifact traceability using
130:   `.specify/rvc-review-map.toml`; this adapts Spec Kit to existing SASD documents.
131: - `rvc-superpowers-verify`: validate review findings, implement authorized fixes
132:   with TDD, and record fresh verification evidence.
133: - `rvc-c-compliance`: approved SASD requirements/interfaces versus C11 implementation,
134:   using Trail of Bits criteria and independent refutation when available.
135: - `rvc-fsm-verify`: SPIN modeling and property checks for the Movement Controller FSM.
136: 
137: Use these adapters for this project rather than replacing the SASD workflow with
138: a new BMAD/Spec Kit product workflow. Review-only requests do not authorize source
139: changes. Treat Q6 as resolved by owner-confirmed C16, preserve phase approval gates, and distinguish
140: document review, code compliance, executed tests, and model-checking results.
141: Project adapters and BMAD team overrides are maintained separately from installed
142: upstream skill files so tool updates do not erase project-specific review rules.

## docs/preliminary_requirements.md

1: • An RVC automatically cleans and mops household surface.
2: • It goes straight forward while cleaning.
3: • If its sensors found an obstacle, it stops cleaning, turns aside left or right, and goes forward with cleaning.
4: • If there are obstacles in both front, left and right, it move backward and turn aside left or right, and goes forward.
5: • If it detects dust, power up the cleaning for a while.
6: • We do not consider the detail design and implementation on HW controls.
7: • We only focus on the automatic cleaning function.

## docs/requirements_clarifications.md

1: # Requirements Clarifications
2: 
3: Decisions made by the project owner from 2026-11-06 through 2026-11-17. They supplement `preliminary_requirements.md`, which remains unchanged. Bullets of that file are cited as B1-B7, by order.
4: 
5: ## Confirmed Decisions
6: 
7: | ID | Refines | Decision |
8: |---|---|---|
9: | C1 | B3 | When a front obstacle is found and both left and right are clear, the RVC turns right. |
10: | C2 | B3 | When an obstacle is found, the RVC stops moving before it continues. |
11: | C3 | B5 | "For a while" means 5 ticks. |
12: | C4 | B3, B4 | Obstacles do not disappear. An obstacle detected stays in place while the RVC stops, moves backward, or turns. (Decided 2026-11-08.) |
13: | C5 | B4, Q1 | After moving backward, the RVC turns right if the right is clear. If the right is blocked and the left is clear, it turns left. If left and right are still both blocked, it moves backward once more. (Decided 2026-11-08; left-turn case added the same day.) |
14: | C6 | B4, Q2 | Moving backward lasts 5 ticks. (Decided 2026-11-08.) |
15: | C7 | C2, Q3 | The stop before avoidance lasts 5 ticks. (Decided 2026-11-08.) |
16: | C8 | B3, B4 | A turn (left or right) lasts 5 ticks. (Decided 2026-11-08.) |
17: | C9 | B4, C5 | After moving backward, only left and right decide (as C5 states); the front sensor is not consulted. Moving backward takes the RVC away from the obstacle, so the front may read clear. (Decided 2026-11-16.) |
18: | C10 | B5, C3, Q4 | Dust detected again during a running power-up restarts the 5 ticks. (Decided 2026-11-16.) |
19: | C11 | B3, C3, Q5 | A power-up interrupted by an avoidance keeps its remaining ticks and continues when the RVC moves forward again. (Decided 2026-11-16.) |
20: | C12 | B2-B5, P1-04 | Read all four sensors (front, left, right, dust) before processing the first Tick. Unreceived sensor values must not be treated as FALSE. (Decided 2026-11-17.) |
21: | C13 | B1, B2, P1-05 | Power On only initializes the Forward state. No Direction or Clean command is emitted at Power On; the first Tick evaluates the sensors and emits the first movement and cleaning commands. (Decided 2026-11-17.) |
22: | C14 | B1, B5, P1-06 | Clean Start and Stop switch suction cleaning and mopping on and off together. Power Up increases suction only; mopping continues at its normal level. Hardware details remain out of scope (B6). (Decided 2026-11-17.) |
23: | C15 | B5, C10, C11, P1-07 | Remember dust detected during avoidance even if the sensor becomes clear before Forward resumes. On the first Forward Tick, start or restart a full 5-tick power-up when such a detection is pending, including when a previous power-up was paused. Without a pending or current detection, resume the saved remaining ticks (C11). (Decided 2026-11-17.) |
24: | C16 | B2, B3, Q6 | While Forward, only a front obstacle initiates avoidance. When the front is clear, continue moving forward and cleaning even if the left, right, or both sides are blocked. Cleaning power still follows B5/C3/C10-C15. This does not change the side-only decision after Backing (C9). (Confirmed by the project owner, 2026-11-17.) |
25: 
26: ## Phase 1 decision record (2026-11-17)
27: 
28: C12-C15 record the project owner's four answers to the Phase 1 review. C15 resolves the formerly unnumbered avoidance-dust question. It refines C11: preserve the remaining count during avoidance, but a remembered detection takes precedence and restarts the count on resumption. Repeated detections before resumption coalesce into one restart; they do not accumulate multiple five-tick periods.
29: 
30: The SA realization initializes D3 to 0 (no power-up yet), D4 to Idle, and the pending-dust flag to FALSE before receiving initial samples. Actual sensor values are obtained under C12, not invented as defaults. A dust detection is recorded when a TRUE sensor input is received, so a later FALSE before the next Tick must not erase it. These are analysis refinements supporting B5/C3/C12-C15, not extra external functions.
31: 
32: The answers authorize the requirements/SA corrections. They do not assert that the existing SD, C implementation, tests or simulator already satisfy the revised requirements; downstream propagation is recorded in QA.md.
33: 
34: ## Question resolution history
35: 
36: | ID | Refines | Question |
37: |---|---|---|
38: | Q1 | B4 | After moving backward, which way does the RVC turn, and what happens if left and right are still both blocked? **Resolved by C5.** |
39: | Q2 | B4 | How far or how many ticks does the RVC move backward? **Resolved by C6.** |
40: | Q3 | C2 | How many ticks does the stop last? **Resolved by C7.** |
41: | Q4 | B5, C3 | If dust is detected again during the 5 ticks, does the count restart or continue? **Resolved by C10.** |
42: | Q5 | B3, C3 | If an obstacle interrupts powered-up cleaning, is the remaining count kept or cancelled? **Resolved by C11.** |
43: | Q6 | B3 | Does an obstacle on the left or right trigger avoidance when the front is clear? **Resolved by C16: no; continue forward and cleaning.** |
44: 
45: ## Q6 confirmation record (2026-11-17)
46: 
47: The project owner selected: “그대로 전진·청소한다. 전방 장애물만 회피 시작 조건으로 확정한다”. C16 replaces the former Q6 assumption with a confirmed requirement. Existing Forward transitions T1/T2 already express this decision; no new transition or side-sensor priority rule is introduced. C9 still governs the decision after Backing. This decision does not approve later development phases.

## docs/verification/review-contract.md

1: # RVC 검증 공통 규약
2: 
3: 이 문서는 Codex 검증 도구의 프로젝트 적용 규칙이다. 요구사항이나 승인된 SA·SD를 대체하지 않는다. 경로는 프로젝트 루트 기준이다.
4: 
5: ## 역할과 입력
6: 
7: | 진입 스킬 | 담당 | 입력 | 기본 결과 위치 |
8: |---|---|---|---|
9: | `rvc-bmad-review` | SA·SD의 내용·구조·설계 근거 검토 | 요구사항, SA, SD | `artifacts/Review/<run-id>/bmad/` |
10: | `rvc-speckit-review` | 문서 품질과 교차 추적성 | `.specify/rvc-review-map.toml`에 연결된 원본 | `artifacts/Review/<run-id>/traceability/` |
11: | `rvc-superpowers-verify` | 지적 타당성 확인, 승인된 수정, 재검증 | 리뷰 보고서, 변경 diff, 관련 테스트 | `artifacts/Review/<run-id>/verification/` |
12: | `rvc-c-compliance` | SA·SD → C 구현의 준수 여부 | 요구사항, SA·SD, `src/`, `include/`, `tests/` | `artifacts/Review/<run-id>/c-compliance/` |
13: | `rvc-fsm-verify` | FSM 모델과 속성 검증 | Level 3·4, 타이머 명세, 요구사항 | `artifacts/Review/<run-id>/fsm/` |
14: 
15: `run-id`는 실제 실행 시각과 구분 가능한 이름으로 정한다. 기존 보고서를 덮어쓰지 않는다. 설정 작성, 문서 검토, 코드 검사, 모델 검사, 시스템 테스트는 서로 다른 실행 상태로 기록한다.
16: 
17: ## 근거의 우선순위
18: 
19: 1. `AGENTS.md`: SASD 절차, 승인 경계, 생산 코드 C11/GCC, TDD·시스템 테스트 규칙.
20: 2. `docs/preliminary_requirements.md`: 원문 7개 bullet을 기존 관례대로 B1–B7로 인용.
21: 3. `docs/requirements_clarifications.md`: 확정 C1–C16을 사용하고 Q6는 C16으로 해결된 이력으로 구분. 충돌이 있으면 보고하고 임의로 해소하지 않는다.
22: 4. `artifacts/SA/`, `artifacts/SD/`: 승인 기록과 이후 개정 범위를 확인한 뒤 해당 버전을 비교 기준으로 사용. 문서 안의 “Yes”, “approved”는 검토 이력의 주장이지 이번 실행의 검증 결과가 아니다.
23: 5. `artifacts/Implementation/`, `artifacts/SystemTest/`: 기존 근거를 찾는 색인. 원본 코드·테스트·실행 로그를 다시 확인한다.
24: 
25: 범위가 지정되지 않은 전반 리뷰는 SA → SD → 구현 → 시스템의 의존 순서를 따른다. 리뷰만 요청받았다면 원본 산출물·생산 코드·테스트를 바꾸지 않고 보고서와 검증용 파일만 작성한다. 수정 요청이 함께 있으면 그 범위 안에서 수정하되 SA→SD→TDD의 단계 진입 승인을 대신하지 않는다. 새 요구사항·가정 확정은 사람에게 맡긴다.
26: 
27: ## RVC에서 혼동하면 안 되는 사항
28: 
29: - Q6는 2026-11-17 사용자 답변으로 C16에 확정되었다. Forward에서는 전방 장애물만 회피 시작 조건이며, 전방이 비어 있으면 좌우 장애물과 관계없이 전진·청소한다. 후진 종료 시 좌우로 판단하는 C9는 별개로 유지한다. 과거 보고서의 Q6 가정 표시는 당시의 이력이다.
30: - C4는 장애물이 물리적으로 사라지지 않는다는 조건이다. RVC가 이동·회전해도 센서값이 영원히 고정된다는 뜻이 아니다. 정지 중 전방 장애물이 유지된다는 현재 SA 해석은 출처를 별도로 기록한다.
31: - C9: 후진 종료 시 좌우로만 결정한다. C5의 후진 반복은 허용 동작이며 무조건 “언젠가 전진”한다는 요구사항은 없다.
32: - C3·C6·C7·C8의 5틱은 명령 발생 틱을 포함하는지 경계까지 확인한다. FSM의 예는 정지 t~t+4, 회전 t+5~t+9, 전진 t+10이다.
33: - C10은 진행 중 파워업을 먼지 재감지 시 재시작, C11은 회피 중 남은 파워업 틱을 보존한다. 청소 타이머 D3는 이동 FSM의 D4와 별개다. C15(2026-11-17)는 회피 중 감지를 기억하고 전진 복귀 시 5틱 재시작하도록 확정했다. 감지가 없으면 C11의 잔여 틱을 재개한다. C12는 첫 Tick 전 네 센서 읽기, C13은 초기화 시 출력 없음, C14는 흡입만 강화하고 물걸레는 정상 유지다. 현재 코드를 요구사항으로 역정의하지 않는다.
34: - B6에 따라 실제 하드웨어 구현은 범위 밖이다. `include/hw_interface.h` 선언, `tests/fake_hw.cpp`, `simulator/host/sim_host.c`를 구분한다.
35: - 생산 코드는 C11이고 GoogleTest 코드는 C++17이다. C++ 테스트가 있다는 이유로 C11 제약 위반이라고 지적하지 않는다.
36: - 파일 범위 `static` 상태는 정보 은닉 대상이다. 외부에서 접근 가능한 공유 상태와 구분한다. SD가 허용한 읽기 전용 상태 조회도 출처를 확인한다.
37: - DFD Level 0은 이 프로젝트에서 Process 0이다. 다른 교재의 번호 관례로 재번호화하지 않는다. Level 0–3의 모든 프로세스를 명세하되 Level 4 FSM에 별도 PSPEC을 만들지 않는다.
38: - 3.2.1의 매개변수 전달 구현, 3.2.3의 상태 도출/출력 분리는 SD의 설계 선택이다. 무조건 DFD 프로세스 1개=함수 1개를 강제하지 않는다.
39: - 배터리, 충전, SLAM, 앱 통신, 물리 충돌 방지 보장은 이 검토에서 새 기능으로 추가하지 않는다.
40: 
41: ## 결과와 증거
42: 
43: 보고서 머리말: 도구/스킬 및 버전, 범위, 읽은 파일과 절·줄, Git HEAD와 미커밋 변경 여부, 실행 시각, 실행/미실행 검사를 기록한다. 실제 입력 파일의 SHA-256을 남기면 미커밋 상태도 재현하기 쉽다.
44: 
45: 각 지적: ID, 심각도, `확정 결함 / 요구사항 모호함 / 선택적 개선`, 근거 요구사항 ID, 양쪽 파일 위치, 반례·조건, 영향, 최소 수정안, 검증 상태. 도구 고유 판정과 심각도는 별도 열로 보존한다. 문서가 없다는 판정에는 검색 범위·표현·결과를 첨부한다.
46: 
47: 지적 수의 최소 할당량은 없다. 근거 없는 항목은 제외한다. 반증된 지적도 사유를 남겨 반복 제안을 막는다. `해당 없음`은 근거를 요구하며 `미검토`와 구분한다.
48: 
49: 테스트 성공, 문서 일관성, 모델 속성 성공, 실제 시스템 성공을 합쳐 하나의 PASS로 표시하지 않는다. 기존 README의 129개·100% 등의 수치를 이번 결과로 복사하지 않는다. 외부 스킬/Workflow 도구를 쓸 수 없으면 그 사실과 대체 방식, 미검증 범위를 명시한다.
50: 
51: ## 원본 플러그인 찾기
52: 
53: BMAD와 Spec Kit은 `.agents/skills/`에 있다. Superpowers와 Trail of Bits는 현재 제공된 스킬 목록 또는 `codex plugin list`로 설치 상태를 찾고, 활성 플러그인의 실제 `SKILL.md`와 필요한 리소스를 읽는다. 개인 이름·버전별 캐시 경로를 팀 지침에 고정하지 않는다. 원본이 없어도 이름만으로 실행했다고 보고하지 않는다.

## .agents/skills/rvc-fsm-verify/SKILL.md

1: ---
2: name: rvc-fsm-verify
3: description: Model and verify the RVC Movement Controller FSM with SPIN, including Tick ordering, five-tick steps, explicit environment assumptions and counterexamples. Use for FSM formal verification; code conformance remains a separate audit.
4: ---
5: 
6: # RVC FSM verification
7: 
8: Read `docs/verification/review-contract.md` and [the model contract](references/model-contract.md). Primary inputs are `artifacts/SA/DFD/dfd_level_4_fsm.md`, Level 3, Process Specification 3.2.4, Data Dictionary, B/C/Q requirements and SD Tick ordering. C code is a later comparison target, not the source from which to copy a supposedly independent model.
9: 
10: ## Work products
11: 
12: For each requested verification run create a new `artifacts/Review/<run-id>/fsm/` with:
13: 
14: - `model.pml`: independently translated FSM plus explicit timer/environment abstraction.
15: - `mapping.md`: every T0–T14 guard/action, state, timer update and source location; list intentionally abstracted behavior.
16: - `properties.md`: property ID, requirement/source, assumptions, safety/liveness/reachability type and exact executable check.
17: - `report.md`: model version/hash, tools, exhaustive/bounded scope, results, state/transition counts, warnings, counterexample traces, untested properties. Keep model correctness review separate from model-checker outcomes.
18: 
19: Build only requested scope; movement-only verification does not claim C10/C11 or cleaning correctness. Do not create a Level 4 Process Specification.
20: 
21: ## Run and inspect
22: 
23: Find `spin` and the configured GCC. If Windows PATH has not refreshed, use the user's `.local/bin/spin.exe` and the compiler from `build/CMakeCache.txt`, or explicit tool paths. The portable helper below captures generation, compilation, search and replay logs and rejects incomplete searches:
24: 
25: ```text
26: python3 .agents/skills/rvc-fsm-verify/scripts/run_spin.py --model <model.pml> --out <new-run-directory> --cc <gcc-path>
27: python3 .agents/skills/rvc-fsm-verify/scripts/run_spin.py --model <model.pml> --out <new-property-directory> --cc <gcc-path> --ltl <claim-name>
28: ```
29: 
30: The helper requires a new/empty output directory. Use self-contained Promela models so the model hash captures the full input. Run each named LTL claim separately. `passed` means only the configured check over that model finished with zero reported errors. Inspect unreachable-code output and review the translation before interpreting it as requirement evidence. A failed check must be replayed and classified as a model mistake, unsupported property/environment assumption, or a candidate source-FSM defect. The helper attempts replay and keeps the raw log; validate it manually.
31: 
32: For state/transition reachability, deliberately assert the target is never reached in a separate probe model; a resulting counterexample is a witness, not a product failure. Keep probe results separate from safety/liveness checks. No eventual-forward claim without explicit environmental assumptions. System testing still uses the web simulator.

## .agents/skills/rvc-fsm-verify/references/model-contract.md

1: # RVC Movement Controller model contract
2: 
3: This is a modeling checklist, not a completed model or proof. Re-read the source artifacts on every run; the descriptions below reflect their current interpretation and must not override changed requirements.
4: 
5: ## State and Tick semantics
6: 
7: Use distinct states Forward, Stopping, Backing, TurningRight, TurningLeft. T0 sets Forward without emitting MovementCommand, Direction or Clean (C13); all four initial sensor samples precede the first Tick (C12). T1–T14 execute once per Tick. SituationSignal has a Boolean front component and three mutually exclusive side values: RightOpen (right clear, including both clear), LeftOpen (right blocked and left clear), SidesBlocked.
8: 
9: Each modeled Tick: sample the applicable inputs → advance D4 and obtain Done → select one FSM transition → restart D4 if the action requests it → issue MovementCommand. Explicitly define whether intermediate states are observable; assertions about whole Tick results must run after the atomic transition. Avoid accidental interleavings introduced by separate Promela processes when the approved design is a single synchronous cycle.
10: 
11: Current timing example: obstacle at t emits Stop and starts elapsed=0; t+1…t+4 remain stopped; t+5 chooses and starts the next five-tick step. Turning emits Forward at t+10 in the example. Distinguish Idle from elapsed 0, and record the reset order. Do not nondeterministically supply Done independently of D4 in a claim about five-tick duration.
12: 
13: ## Environment
14: 
15: - State the abstraction: raw three-sensor combinations or already-classified SituationSignal. If classified, separately check the raw-to-side priority relation (C1).
16: - For controller robustness checks, nondeterministic signals over all legal values may be an over-approximation. Label it as such; a trace may not correspond to a realizable map.
17: - C4 does not freeze all sensor values across movement. If using the SA's stationary-front persistence while Stopping, cite Level 3 and explain it. Avoid imposing additional sensor stability merely to make a property pass.
18: - C16 resolves Q6 as an owner-confirmed requirement: Forward with a clear front continues forward and cleaning regardless of side obstacles. Verify T1/T2 against C16; retain C9 side-only selection after Backing. Cleaning outputs require the corresponding cleaning model scope.
19: - C5/C9 allow repeated Backing while both sides are blocked; front may be clear. A cycle with enabled Tick transitions is not automatically a deadlock or defect.
20: - Liveness assumes continuing Ticks. Weak process fairness is not a guarantee that sensors eventually clear. Record any fairness flag and environment assumptions explicitly.
21: 
22: ## Checks to derive from current sources
23: 
24: | Check | Basis | Scope |
25: |---|---|---|
26: | Initial Forward without output | T0, C12/C13 | Initialize state only; first Tick samples/evaluates the initialized inputs and produces both Direction and Clean. Do not inherit a historical SD power-on output as the new requirement. |
27: | Complete and non-overlapping guards | T1–T14 and legal input domain | Every state/Done/side combination, with timer-consistent reachable states |
28: | Stop before avoiding and exact step durations | C2/C6/C7/C8, timing table | D4 ordering, boundary tick and restart behavior |
29: | Right priority and post-backing front independence | C1/C5/C9 | RightOpen/LeftOpen/SidesBlocked; both front values after Backing |
30: | State/action agreement and timer domain | FSM states table, Dictionary D4 | Check after the cycle, not a transient assignment |
31: | Reachability of states and T0–T14 | FSM transition table | Explicit witness/probe per target; “unreached in” text alone is not a coverage report |
32: | Absence of invalid end states in the continuing controller | Controller Tick loop model | Preserve terminal semantics of a finite test harness; do not disguise deadlocks with end labels |
33: 
34: `eventually Forward` is not an unconditional project requirement. A conditional experiment may assume sides become available at a decision tick and Ticks continue; report the assumption and show it is not vacuous. Failure of an unconditional experiment can be expected under C5.
35: 
36: ## Optional cleaning composition
37: 
38: Only when requested, add D3 and processes 4.1/4.2 after movement status is determined. Check no cleaning while Avoiding, C3 duration, C10 restart, C11 freeze/resume and C15 pending-dust capture/consumption in D2. A pending detection restarts five ticks on resumption; without one, saved ticks resume. Include TRUE then FALSE between ticks if modeling input events. D3 is outside the Level 4 movement FSM; label this a composed model. Cite PSPEC for simultaneous dust/obstacle behavior and use C12-C15 decisions rather than copying historical C behavior as the requirement. C14 defines suction-only boost and normal mopping.
39: 
40: ## Interpretation
41: 
42: A SPIN pass establishes the configured property of the finite abstraction. It does not prove the abstraction faithful, physical collision freedom, actual C conformance or web simulator correctness. Record the property formula, source-to-model mapping and search completeness. Never use bitstate/hash approximation or a depth-limited/incomplete search as an exhaustive proof. For a counterexample, save/replay the trail with variable values and map each relevant step back to T IDs and requirement IDs.

## .agents/skills/rvc-fsm-verify/scripts/run_spin.py

1: #!/usr/bin/env python3
2: """Run one self-contained SPIN check; preserve logs and fail closed on incomplete searches."""
3: import argparse
4: import hashlib
5: import json
6: import os
7: from pathlib import Path
8: import re
9: import shutil
10: import subprocess
11: import sys
12: from datetime import datetime, timezone
13: 
14: 
15: def executable(value, default, fallback=None):
16:     candidate = value or shutil.which(default)
17:     if not candidate and fallback and fallback.is_file():
18:         candidate = str(fallback)
19:     if not candidate:
20:         raise ValueError(f"Cannot find {default}; supply an explicit path")
21:     resolved = shutil.which(candidate) or candidate
22:     path = Path(resolved).resolve()
23:     if not path.is_file():
24:         raise ValueError(f"Executable not found: {path}")
25:     return str(path)
26: 
27: 
28: def main():
29:     parser = argparse.ArgumentParser(description=__doc__)
30:     parser.add_argument('--model', type=Path, required=True)
31:     parser.add_argument('--out', type=Path, required=True)
32:     parser.add_argument('--spin')
33:     parser.add_argument('--cc')
34:     parser.add_argument('--ltl', help='Named inline LTL claim; checked with acceptance-cycle search')
35:     parser.add_argument('--depth', type=int, default=100000)
36:     parser.add_argument('--timeout', type=int, default=120, help='Seconds per subprocess')
37:     args = parser.parse_args()
38:     result = {'status': 'inconclusive', 'started_utc': datetime.now(timezone.utc).isoformat(),
39:               'commands': [], 'scope': 'one property/check on the supplied model only',
40:               'ltl': args.ltl, 'depth': args.depth, 'fairness': 'none', 'search': 'full-state'}
41:     out = args.out.resolve()
42:     ready = False
43: 
44:     def run(stage, command):
45:         record = {'stage': stage, 'argv': command, 'cwd': str(out)}
46:         result['commands'].append(record)
47:         try:
48:             proc = subprocess.run(command, cwd=out, env=env, stdout=subprocess.PIPE,
49:                                   stderr=subprocess.STDOUT, timeout=args.timeout)
50:             text = proc.stdout.decode('utf-8', errors='replace')
51:             record['exit_code'] = proc.returncode
52:         except subprocess.TimeoutExpired as exc:
53:             text = (exc.stdout or b'').decode('utf-8', errors='replace')
54:             record['timeout'] = True
55:             (out / f'{stage}.log').write_text(text, encoding='utf-8')
56:             raise RuntimeError(f'{stage} timed out; search result is not a pass') from exc
57:         (out / f'{stage}.log').write_text(text, encoding='utf-8')
58:         return proc.returncode, text
59: 
60:     try:
61:         if args.depth <= 0 or args.timeout <= 0:
62:             raise ValueError('depth and timeout must be positive')
63:         model = args.model.resolve(strict=True)
64:         raw = model.read_bytes()
65:         source = raw.decode('utf-8-sig')
66:         if re.search(r'^\s*#\s*include\b', source, re.M):
67:             raise ValueError('Use a self-contained model; includes are not captured by this runner')
68:         if re.search(r'\bnever\s*\{', source):
69:             raise ValueError('Use named inline LTL rather than an anonymous never claim')
70:         claims = re.findall(r'\bltl\s+(\w+)\s*\{', source)
71:         if claims and not args.ltl:
72:             raise ValueError('Model has LTL claims; select one explicitly with --ltl')
73:         if args.ltl and args.ltl not in claims:
74:             raise ValueError(f'Named LTL claim not found: {args.ltl}')
75:         spin = executable(args.spin, 'spin', Path.home() / '.local/bin/spin.exe')
76:         cc = executable(args.cc, 'gcc')
77:         if out.exists() and (not out.is_dir() or any(out.iterdir())):
78:             raise ValueError('Output directory must be new or empty; previous runs are preserved')
79:         out.mkdir(parents=True, exist_ok=True)
80:         ready = True
81:         (out / 'model.pml').write_bytes(raw)
82:         result.update(model_source=str(model), model_sha256=hashlib.sha256(raw).hexdigest(),
83:                       spin=spin, compiler=cc)
84:         env = os.environ.copy()
85:         env['PATH'] = str(Path(cc).parent) + os.pathsep + env.get('PATH', '')
86:         for stage, command in [('spin-version', [spin, '-V']), ('compiler-version', [cc, '--version'])]:
87:             code, _ = run(stage, command)
88:             if code:
89:                 raise RuntimeError(f'{stage} failed; inspect log')
90:         code, _ = run('generate', [spin, '-a', 'model.pml'])
91:         if code or not (out / 'pan.c').is_file():
92:             raise RuntimeError('Model generation failed; inspect generate.log')
93:         binary = out / ('pan.exe' if os.name == 'nt' else 'pan')
94:         code, _ = run('compile', [cc, '-O2', '-o', str(binary), 'pan.c'])
95:         if code:
96:             raise RuntimeError('Verifier compilation failed; inspect compile.log')
97:         command = [str(binary), f'-m{args.depth}']
98:         if args.ltl:
99:             command += ['-a', '-N', args.ltl]
100:         code, text = run('search', command)
101:         errors = re.search(r'\berrors:\s*(\d+)', text)
102:         incomplete = re.search(r'max search depth too small|out of memory|search not completed|'
103:                                r'VECTORSZ.*too small|cannot allocate', text, re.I)
104:         if errors:
105:             result['errors'] = int(errors.group(1))
106:         for name, pattern in [('stored_states', r'([\d.e+]+)\s+states, stored'),
107:                               ('transitions', r'([\d.e+]+)\s+transitions')]:
108:             match = re.search(pattern, text, re.I)
109:             if match:
110:                 result[name] = match.group(1)
111:         if errors and int(errors.group(1)) > 0:
112:             result['status'] = 'failed'
113:             result['reason'] = 'SPIN found a counterexample; classify against model and source requirements'
114:             trails = sorted(out.glob('*.trail'))
115:             result['trails'] = [p.name for p in trails]
116:             if trails:
117:                 try:
118:                     replay_code, _ = run('replay', [spin, '-t', '-p', '-g', '-l', '-k', trails[0].name, 'model.pml'])
119:                     result['replay_ok'] = replay_code == 0
120:                 except RuntimeError as exc:
121:                     result['replay_ok'] = False
122:                     result['replay_note'] = str(exc)
123:         elif code or not errors or incomplete:
124:             result['reason'] = 'Nonzero exit, missing summary or incomplete search; inspect search.log'
125:         else:
126:             result['status'] = 'passed'
127:             result['reason'] = 'Configured check completed with zero reported errors; model fidelity is separate'
128:     except (ValueError, OSError, RuntimeError, UnicodeError) as exc:
129:         result['reason'] = str(exc)
130:     if ready:
131:         result['finished_utc'] = datetime.now(timezone.utc).isoformat()
132:         (out / 'result.json').write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
133:     print(json.dumps(result, ensure_ascii=False, indent=2))
134:     return {'passed': 0, 'failed': 1, 'inconclusive': 2}[result['status']]
135: 
136: 
137: if __name__ == '__main__':
138:     sys.exit(main())

## artifacts/SA/context_diagram.md

1: # System Context Diagram
2: 
3: System: RVC Controller
4: Sources: `docs/preliminary_requirements.md`, `docs/requirements_clarifications.md`, `artifacts/SA/event_list.md`
5: 
6: ## System Boundary
7: 
8: - Inside: the automatic cleaning control logic of the RVC Controller (B7).
9: - Outside: the sensors and digital clock that supply inputs, and the motor and cleaner that receive commands. Their hardware design and control are out of scope (B6).
10: 
11: ## Diagram
12: 
13: ```mermaid
14: flowchart LR
15:     FrontSensor["Front Sensor"]
16:     LeftSensor["Left Sensor"]
17:     RightSensor["Right Sensor"]
18:     DustSensor["Dust Sensor"]
19:     DigitalClock["Digital Clock"]
20:     System(("RVC Controller"))
21:     Motor["Motor"]
22:     Cleaner["Cleaner"]
23: 
24:     FrontSensor -->|Front Sensor Input| System
25:     LeftSensor -->|Left Sensor Input| System
26:     RightSensor -->|Right Sensor Input| System
27:     DustSensor -->|Dust Sensor Input| System
28:     DigitalClock -.->|Tick| System
29:     System -->|Direction| Motor
30:     System -->|Clean| Cleaner
31: ```
32: 
33: Solid arrows are data flows. The dashed arrow is a control flow.
34: 
35: ## Initialization and output semantics
36: 
37: Before the first Tick, all four sensor readings are available (C12). Power On initializes state only and emits neither Direction nor Clean (C13); it is not a new external flow. Clean Start/Stop jointly enables/disables suction and mopping, and Power Up strengthens suction while mopping stays normal (C14). Dust detections retained for later use (C15) are internal state, not a new external event.

## artifacts/SA/data_dictionary.md

1: # Data Dictionary
2: 
3: Current coverage: Event List, Context Diagram, DFD Levels 0-3.
4: 
5: ## 1. External Input/Output Events
6: 
7: | Input/Output Event | Description | Format / Type |
8: |---|---|---|
9: | Front Sensor Input | Reports whether an obstacle is detected in front of the RVC. | Boolean |
10: | Left Sensor Input | Reports whether an obstacle is detected on the left side of the RVC. | Boolean |
11: | Right Sensor Input | Reports whether an obstacle is detected on the right side of the RVC. | Boolean |
12: | Dust Sensor Input | Reports whether dust is detected on the surface being cleaned. | Boolean |
13: | Tick | Clock event that provides the time base for the system. | Event |
14: | Direction | Movement command sent to the motor. | Enum |
15: | Clean | Cleaning command sent to the cleaner. | Enum |
16: 
17: ## 2. Internal Data and Control Flows
18: 
19: No internal flows exist at DFD Level 0.
20: 
21: | Data Name | Description | Format / Type | Flow Category | Source | Destination | DFD Level |
22: |---|---|---|---|---|---|---|
23: | Obstacle Location | Latest obstacle detection result for front, left, and right. | Front Obstacle + Left Obstacle + Right Obstacle | Data | Process 1; D1 Obstacle Location | D1 Obstacle Location; Process 3 (L1), 3.1 (L2) | 1, 2 |
24: | Dust Existence | Current dust reading and unconsumed detection. | Dust Detected + Pending Dust Detection | Data | Process 2; D2 Dust Existence | D2 Dust Existence; Process 2; Process 4 (L1), 4.1 (L2/L3) | 1, 2, 3 |
25: | Pending Dust Detection | A detection retained until a Forward Tick consumes it. | Boolean | Data | Process 4 (L1), 4.1 (L2/L3) | D2 Dust Existence (pending field only) | 1, 2, 3 |
26: | Movement Status | Whether the RVC is moving forward or avoiding an obstacle. | Enum | Data | Process 3 (L1), 3.2 (L2), 3.2.3 (L3) | Process 4 (L1), 4.1 and 4.2 (L2, L3) | 1, 2, 3 |
27: | Obstacle Situation | Classification of the current obstacles: Front Blocked and Side Situation. | Record | Data | Process 3.1 | Process 3.2 (L2), 3.2.1 (L3) | 2, 3 |
28: | Situation Signal | Obstacle Situation delivered to the Controller as a control signal. | Record | Control | Process 3.2.1 | Process 3.2.2 | 3 |
29: | Movement Command | Action chosen by the Controller for the current tick. | Enum | Control | Process 3.2.2 | Process 3.2.3 | 3 |
30: | Start Step Timer | Tells the step timer to begin counting a 5-tick stop, backward, or turn step. | Event | Control | Process 3.2.2 | Process 3.2.4 | 3 |
31: | Step Done | Signals that the current stop, backward, or turn step has lasted 5 ticks. | Event | Control | Process 3.2.4 | Process 3.2.2 | 3 |
32: | Step Ticks Elapsed | Ticks counted in the current stop, backward, or turn step. | Idle or Integer 0-5 | Data | Process 3.2.4; D4 Step Timer | D4 Step Timer; Process 3.2.4 | 3 |
33: | Power-Up Active | Whether powered-up cleaning applies this tick. | Boolean | Data | Process 4.1 | Process 4.2 | 2 |
34: | Remaining Power-Up Ticks | Ticks of powered-up cleaning still to run. | Integer, 0-5 | Data | Process 4.1; D3 Power-Up Timer | D3 Power-Up Timer; Process 4.1 | 2 |
35: 
36: ## 3. Data Store Definitions
37: 
38: No Data Stores exist at DFD Level 0.
39: 
40: | Data Store | Description | Stored Data | Format / Type | DFD Level |
41: |---|---|---|---|---|
42: | D1 Obstacle Location | Holds the latest front, left, and right obstacle readings for use on the next Tick. | Front Obstacle, Left Obstacle, Right Obstacle | Record of 3 Booleans | 1, 2 |
43: | D2 Dust Existence | Holds current dust and a remembered detection across ticks/avoidance. | Dust Detected, Pending Dust Detection | Record of 2 Booleans | 1, 2, 3 |
44: | D3 Power-Up Timer | Holds the remaining powered-up cleaning ticks across ticks. | Remaining Power-Up Ticks | Integer, 0-5 | 2, 3 |
45: | D4 Step Timer | Holds the tick count of the current stop, backward, or turn step across ticks. | Step Ticks Elapsed | Idle or Integer 0-5 | 3 |
46: 
47: ## 4. Detailed Data Definitions
48: 
49: ### Front Sensor Input
50: - Description: Reports whether an obstacle is detected in front of the RVC.
51: - Format / Type: Boolean
52: - Possible Values: TRUE (obstacle detected), FALSE (no obstacle detected)
53: - Flow Category: Data
54: - Source: Front Sensor
55: - Destination: Process 0; Process 1 (Level 1)
56: - DFD Level: Context, 0, 1
57: - Requirement Reference: B3, B4
58: 
59: ### Left Sensor Input
60: - Description: Reports whether an obstacle is detected on the left side of the RVC.
61: - Format / Type: Boolean
62: - Possible Values: TRUE (obstacle detected), FALSE (no obstacle detected)
63: - Flow Category: Data
64: - Source: Left Sensor
65: - Destination: Process 0; Process 1 (Level 1)
66: - DFD Level: Context, 0, 1
67: - Requirement Reference: B3, B4, C1
68: 
69: ### Right Sensor Input
70: - Description: Reports whether an obstacle is detected on the right side of the RVC.
71: - Format / Type: Boolean
72: - Possible Values: TRUE (obstacle detected), FALSE (no obstacle detected)
73: - Flow Category: Data
74: - Source: Right Sensor
75: - Destination: Process 0; Process 1 (Level 1)
76: - DFD Level: Context, 0, 1
77: - Requirement Reference: B3, B4, C1
78: 
79: ### Dust Sensor Input
80: - Description: Reports whether dust is detected on the surface being cleaned.
81: - Format / Type: Boolean
82: - Possible Values: TRUE (dust detected), FALSE (no dust detected)
83: - Flow Category: Data
84: - Source: Dust Sensor
85: - Destination: Process 0; Process 2 (Level 1)
86: - DFD Level: Context, 0, 1
87: - Requirement Reference: B5, C12, C15
88: 
89: ### Tick
90: - Description: Clock event for five-tick cleaning/stop/back/turn durations. All four initial sensor samples precede the first Tick (C12); initialization emits no output (C13).
91: - Format / Type: Event
92: - Possible Values: None; the occurrence of the event is the information.
93: - Flow Category: Control
94: - Source: Digital Clock
95: - Destination: Process 0; Processes 3 and 4 (Level 1); Processes 3.1, 3.2, 4.1 (Level 2); Processes 3.1, 3.2.2, 3.2.4, 4.1 (Level 3)
96: - DFD Level: Context, 0, 1, 2, 3
97: - Requirement Reference: B5, C3, C6-C8, C12, C13
98: 
99: ### Direction
100: - Description: Movement command sent to the motor.
101: - Format / Type: Enum
102: - Possible Values: Forward, Backward, Turn Left, Turn Right, Stop
103: - Flow Category: Data
104: - Source: Process 0; Process 3 (Level 1); Process 3.2 (Level 2); Process 3.2.3 (Level 3)
105: - Destination: Motor
106: - DFD Level: Context, 0, 1, 2, 3
107: - Requirement Reference: B2, B3, B4, C1, C2
108: 
109: ### Clean
110: - Description: Cleaning command sent to the cleaner.
111: - Format / Type: Enum
112: - Possible Values: Start (normal suction and mopping on), Stop (both off), Power Up (stronger suction and normal mopping), per C14
113: - Flow Category: Data
114: - Source: Process 0; Process 4 (Level 1); Process 4.2 (Level 2)
115: - Destination: Cleaner
116: - DFD Level: Context, 0, 1, 2, 3
117: - Requirement Reference: B1, B2, B3, B5, C3, C14
118: 
119: ### Obstacle Location
120: - Description: Latest obstacle detection result for the three obstacle sensors. Written by Process 1, kept in D1, read by Process 3 on Tick.
121: - Format / Type: Record = Front Obstacle + Left Obstacle + Right Obstacle (each Boolean)
122: - Possible Values: Each field TRUE (obstacle) or FALSE (no obstacle)
123: - Flow Category: Data
124: - Source: Process 1 (write); D1 Obstacle Location (read)
125: - Destination: D1 Obstacle Location; Process 3 (Level 1); Process 3.1 (Level 2)
126: - DFD Level: 1, 2, 3
127: - Requirement Reference: B3, B4, C1, C16
128: 
129: ### Dust Existence
130: - Description: Current dust reading plus a latched unconsumed detection. Process 2 records every TRUE input even if a subsequent FALSE arrives before Forward resumes (C15). Process 4.1 consumes pending dust on Forward only.
131: - Format / Type: Record = Dust Detected (Boolean) + Pending Dust Detection (Boolean)
132: - Possible Values: Dust Detected is the current reading; Pending Dust Detection records any unconsumed TRUE input (each Boolean).
133: - Flow Category: Data
134: - Source: Process 2 (write); D2 Dust Existence (read)
135: - Destination: D2 Dust Existence; Process 2 (read-modify-write); Process 4 (Level 1); Process 4.1 (Levels 2, 3)
136: - DFD Level: 1, 2, 3
137: - Requirement Reference: B5, C10, C12, C15
138: 
139: ### Movement Status
140: - Description: Tells Process 4 whether the RVC is moving forward (cleaning allowed) or avoiding an obstacle (cleaning stopped).
141: - Format / Type: Enum
142: - Possible Values: Forward, Avoiding
143: - Flow Category: Data
144: - Source: Process 3 (Level 1); Process 3.2 (Level 2); Process 3.2.3 (Level 3)
145: - Destination: Process 4 (Level 1); Processes 4.1 and 4.2 (Level 2)
146: - DFD Level: 1, 2, 3
147: - Requirement Reference: B2, B3, B4
148: 
149: ### D1 Obstacle Location (Data Store)
150: - Description: Holds the latest Obstacle Location so that Process 3 can use all three readings on each Tick.
151: - Format / Type: Record of 3 Booleans
152: - Stored Data: Front Obstacle, Left Obstacle, Right Obstacle
153: - Source: Process 1
154: - Destination: Process 3 (Level 1); Process 3.1 (Levels 2, 3)
155: - Initial state: All three fields are actual sensor samples obtained before the first Tick (C12), not default FALSE values. Later input updates replace only the received field.
156: - DFD Level: 1, 2, 3
157: - Requirement Reference: B3, B4, C12
158: 
159: ### D2 Dust Existence (Data Store)
160: - Description: Holds the current dust reading and an unconsumed detection across ticks and avoidance.
161: - Format / Type: Record of 2 Booleans
162: - Stored Data: Dust Detected, Pending Dust Detection
163: - Source: Process 2 writes the current reading and ORs TRUE detections into the pending flag; Process 4 (L1), 4.1 (L2/L3) writes only the pending flag after Tick processing.
164: - Destination: Process 2; Process 4 (Level 1); Process 4.1 (Levels 2, 3)
165: - Initial state: Pending Dust Detection=FALSE before initial sampling; Dust Detected is obtained from the actual sensor before the first Tick (C12). A TRUE initial sample latches pending dust.
166: - DFD Level: 1, 2, 3
167: - Requirement Reference: B5, C10, C12, C15
168: 
169: ### Pending Dust Detection
170: - Description: TRUE if a dust detection has not yet been consumed by a Forward Tick. FALSE sensor inputs never erase a pending detection. Repeated TRUE inputs coalesce; this is not a count of detections.
171: - Format / Type: Boolean
172: - Possible Values: TRUE (pending), FALSE (none)
173: - Flow Category: Data
174: - Source: Process 4 (L1), 4.1 (L2/L3) returns the updated flag; Process 2 also sets the field through the Dust Existence record.
175: - Destination: D2 Dust Existence (update only this field)
176: - Update: Preserve during Avoiding; on Forward use pending/current dust to start or restart five ticks, then clear pending. Input updates and Tick processing are logically serialized (Process 0 contract).
177: - DFD Level: 1, 2, 3
178: - Requirement Reference: B5, C10, C11, C15
179: 
180: ### Obstacle Situation
181: - Description: Classification of the obstacles read from D1. It has two parts. Front Blocked says whether an obstacle is detected in front. Side Situation classifies left and right, whether or not the front is blocked (C9).
182: - Format / Type: Record = Front Blocked (Boolean) + Side Situation (Enum)
183: - Possible Values: Front Blocked: TRUE or FALSE. Side Situation: Right Open (right clear), Left Open (right blocked, left clear), Sides Blocked (left and right blocked)
184: - Flow Category: Data
185: - Source: Process 3.1
186: - Destination: Process 3.2 (Level 2); Process 3.2.1 (Level 3)
187: - DFD Level: 2, 3
188: - Requirement Reference: B3, B4, C1, C16, C9
189: 
190: ### Power-Up Active
191: - Description: Whether powered-up cleaning applies on the current tick.
192: - Format / Type: Boolean
193: - Possible Values: TRUE (power up), FALSE (normal cleaning or stopped)
194: - Flow Category: Data
195: - Source: Process 4.1
196: - Destination: Process 4.2
197: - DFD Level: 2
198: - Requirement Reference: B5, C3
199: 
200: ### Remaining Power-Up Ticks
201: - Description: Number of powered-up cleaning ticks still to run, including the current tick before it is counted down.
202: - Format / Type: Integer
203: - Possible Values: 0-5 (0 = no power-up in progress; set to 5 on current or pending dust while Forward, C10/C15; kept while Avoiding, C11; initialized to 0)
204: - Flow Category: Data
205: - Source: Process 4.1 (write); D3 Power-Up Timer (read)
206: - Destination: D3 Power-Up Timer; Process 4.1
207: - DFD Level: 2
208: - Requirement Reference: B5, C3, C10, C11, C15
209: 
210: ### D3 Power-Up Timer (Data Store)
211: - Description: Holds Remaining Power-Up Ticks so that the 5-tick power-up persists across ticks.
212: - Format / Type: Integer, 0-5
213: - Stored Data: Remaining Power-Up Ticks
214: - Initial value: 0 before initial sampling and the first Tick (no power-up yet). Pending dust is stored separately in D2.
215: - Source: Process 4.1
216: - Destination: Process 4.1
217: - DFD Level: 2
218: - Requirement Reference: B5, C3, C11, C15
219: 
220: ### Situation Signal
221: - Description: The Obstacle Situation delivered to the Movement Controller as a control signal. The Controller uses Front Blocked while going forward and the Side Situation when a stop or backward step ends.
222: - Format / Type: Record = Front Blocked (Boolean) + Side Situation (Enum)
223: - Possible Values: Same as Obstacle Situation: Front Blocked (TRUE or FALSE) and Side Situation (Right Open, Left Open, Sides Blocked)
224: - Flow Category: Control
225: - Source: Process 3.2.1
226: - Destination: Process 3.2.2
227: - DFD Level: 3
228: - Requirement Reference: B3, B4, C1, C4, C16, C9
229: 
230: ### Movement Command
231: - Description: The action chosen by the Movement Controller for the current tick. It triggers Process 3.2.3.
232: - Format / Type: Enum
233: - Possible Values: Forward, Stop, Turn Right, Turn Left, Backward
234: - Flow Category: Control
235: - Source: Process 3.2.2
236: - Destination: Process 3.2.3
237: - DFD Level: 3
238: - Requirement Reference: B2, B3, B4, C1, C2
239: 
240: ### Start Step Timer
241: - Description: Issued by the Movement Controller when a 5-tick stop (C7), backward (C6), or turn (C8) step begins. Resets the step count.
242: - Format / Type: Event
243: - Possible Values: None; the occurrence of the event is the information.
244: - Flow Category: Control
245: - Source: Process 3.2.2
246: - Destination: Process 3.2.4
247: - DFD Level: 3
248: - Requirement Reference: C6, C7, C8
249: 
250: ### Step Done
251: - Description: Present on the tick when the current stop, backward, or turn step has lasted 5 ticks.
252: - Format / Type: Event
253: - Possible Values: None; the occurrence of the event is the information.
254: - Flow Category: Control
255: - Source: Process 3.2.4
256: - Destination: Process 3.2.2
257: - DFD Level: 3
258: - Requirement Reference: C6, C7, C8
259: 
260: ### Step Ticks Elapsed
261: - Description: Number of ticks counted since Start Step Timer, not counting the tick on which the timer was started.
262: - Format / Type: Idle or Integer
263: - Possible Values: Idle (no step running), 0-5 (Step Done is emitted when it reaches 5, then it returns to Idle)
264: - Flow Category: Data
265: - Source: Process 3.2.4 (write); D4 Step Timer (read)
266: - Destination: D4 Step Timer; Process 3.2.4
267: - DFD Level: 3
268: - Requirement Reference: C6, C7, C8
269: 
270: ### D4 Step Timer (Data Store)
271: - Description: Holds Step Ticks Elapsed so that the 5-tick stop, backward, and turn steps persist across ticks.
272: - Format / Type: Idle or Integer 0-5
273: - Stored Data: Step Ticks Elapsed
274: - Source: Process 3.2.4
275: - Destination: Process 3.2.4
276: - DFD Level: 3
277: - Requirement Reference: C6, C7, C8

## artifacts/SA/event_list.md

1: # Event List
2: 
3: System: RVC Controller
4: Sources: `docs/preliminary_requirements.md` (cited as B1-B7, by bullet order), `docs/requirements_clarifications.md` (cited as C1-C16)
5: 
6: ## Events
7: 
8: | Input/Output Event | Description |
9: |---|---|
10: | Front Sensor Input | Input. Reports whether an obstacle is detected in front of the RVC. |
11: | Left Sensor Input | Input. Reports whether an obstacle is detected on the left side of the RVC. |
12: | Right Sensor Input | Input. Reports whether an obstacle is detected on the right side of the RVC. |
13: | Dust Sensor Input | Input. Reports whether dust is detected on the surface being cleaned; each TRUE input is remembered internally until a Forward Tick consumes it (C15). |
14: | Tick | Input. Clock event that provides the time base for the system; powered-up cleaning, stopping, backing and turning each use 5-tick durations. |
15: | Direction | Output. Sends a movement command to the motor: forward, backward, turn left, turn right, or stop. |
16: | Clean | Output. Sends a cleaning command to the cleaner: Start (suction and mopping), Stop (both off), or Power Up (stronger suction, normal mopping), per C14. |
17: 
18: ## Traceability
19: 
20: | Input/Output Event | Requirement | Supporting behavior |
21: |---|---|---|
22: | Front Sensor Input | B3, B4 | An obstacle ahead triggers stopping and turning; it is also part of the front/left/right blocked case. |
23: | Left Sensor Input | B3, B4, C1 | A left obstacle limits the turn direction; it is also part of the front/left/right blocked case. |
24: | Right Sensor Input | B3, B4, C1 | A right obstacle limits the turn direction; it is also part of the front/left/right blocked case. |
25: | Dust Sensor Input | B5, C10, C15 | Dust triggers/restarts power-up; detections during avoidance are remembered until Forward resumes. |
26: | Tick | B5, C3, C6-C8, C12, C13 | Measures timed actions. First Tick occurs after all initial sensor samples; Power On emits no commands. |
27: | Direction | B2, B3, B4, C1, C2 | Go forward, stop at an obstacle, turn left or right, and move backward. |
28: | Clean | B1, B2, B3, B5, C3, C10, C11, C14, C15 | Suction and mopping run while Forward and stop while Avoiding; power-up strengthens suction only, including a remembered detection on resumption. |
29: 
30: ## Event Classification
31: 
32: - Flow-oriented: all four sensor inputs and both outputs.
33: - Temporal: `Tick`, which is drawn as a control flow in the DFDs.
34: - Control: none other than `Tick`. `Direction` and `Clean` carry commands as data flows.
35: 
36: ## Initialization contract
37: 
38: C12 requires all four initial sensor readings before the first Tick. C13 makes Power On an internal initialization condition, not an eighth external event or an output command. Internal pending-dust storage and its consumption do not add external flows.

## artifacts/SA/process_specification.md

1: # Process Specification
2: 
3: Current coverage: DFD Levels 0-3.
4: 
5: Requirement references: B1-B7 are bullets of `docs/preliminary_requirements.md`, by order. C1-C16 and Q1-Q6 are entries of `docs/requirements_clarifications.md`. Q1-Q5 are resolved by C5-C7/C10-C11. Q6 is resolved by C16. C12-C15 record the Phase 1 decisions of 2026-11-17. Earlier refinement notes are history; current logic below is normative.
6: 
7: # DFD Level 0
8: 
9: ## Process 0: RVC Controller
10: 
11: ### Process Identification
12: 
13: | Field | Description |
14: |---|---|
15: | Process ID | 0 |
16: | Process Name | RVC Controller |
17: | DFD Level | Level 0 |
18: | Parent Process | None |
19: 
20: ### Purpose
21: Control the movement and cleaning of the RVC automatically, using obstacle and dust detection.
22: 
23: ### Inputs
24: - Front Sensor Input
25: - Left Sensor Input
26: - Right Sensor Input
27: - Dust Sensor Input
28: - Tick (control)
29: 
30: ### Outputs
31: - Direction
32: - Clean
33: 
34: ### Trigger / Execution Condition
35: - Executes on every Tick.
36: 
37: ### Initialization and input contract
38: Initialize the Controller to Forward, D3 to 0 and D4 to Idle, and the Pending Dust Detection flag in D2 to FALSE. Emit no Direction or Clean at Power On (C13). Read all four actual sensor values through Processes 1 and 2 before the first Tick (C12); no unreceived value is assumed FALSE. A TRUE initial dust sample sets the pending flag.
39: 
40: Sensor input receipt and Tick execution are logically serialized. Inputs received before a Tick update the stores before its snapshot; later inputs are processed after that Tick. Process 1 updates the received field, retaining other valid readings. Process 2 records current dust and retains any unconsumed TRUE detection even if a later FALSE arrives.
41: 
42: ### Processing Logic
43: 1. Each Tick uses current state and the valid sensor snapshot, not a stateless front-only decision.
44: 2. Process 3 sequences the movement under C1-C9. Forward uses the front for avoidance entry (C16); Backing completion uses sides regardless of the front (C9).
45: 3. Process 4 uses this Tick's Movement Status, D2 and D3. Avoiding stops suction and mopping, preserves remaining power-up ticks, and keeps pending dust. Forward starts/restarts five ticks for pending/current dust, or resumes saved ticks otherwise (C10, C11, C15).
46: 4. Clean Start enables suction and mopping; Stop disables both; Power Up strengthens suction while mopping stays normal (C14).
47: 
48: ### Pseudocode
49: 
50: ```text
51: BEFORE first Tick:
52:     initialize state and stores as above
53:     obtain all four initial sensor samples through Processes 1 and 2
54: ON Tick:
55:     Direction, Movement Status = Process 3 using D1 and persistent movement state
56:     Clean = Process 4 using this Movement Status, D2 and D3
57: ```
58: 
59: This is a composition of the lower-level contracts, not multiple movement commands on one Tick. Exact ordering is in DFD Level 3; the first Tick may issue Stop rather than Forward when the front is blocked.
60: 
61: ### Relevant Requirements
62: - B1-B7, C1-C16
63: 
64: # DFD Level 1
65: 
66: ## Process 1: Detect Obstacle
67: 
68: ### Process Identification
69: 
70: | Field | Description |
71: |---|---|
72: | Process ID | 1 |
73: | Process Name | Detect Obstacle |
74: | DFD Level | Level 1 |
75: | Parent Process | 0 |
76: 
77: ### Purpose
78: Interpret the three obstacle sensors and record where obstacles are.
79: 
80: ### Inputs
81: - Front Sensor Input
82: - Left Sensor Input
83: - Right Sensor Input
84: 
85: ### Outputs
86: - Obstacle Location (to D1 Obstacle Location)
87: 
88: ### Trigger / Execution Condition
89: - When any obstacle sensor input is received.
90: 
91: ### Processing Logic
92: 1. Before the first Tick, obtain all three actual obstacle readings (C12).
93: 2. When an individual sensor input arrives, update only that matching field in D1 and retain the other valid readings. Tick does not run before the initial set is complete.
94: 
95: ### Pseudocode
96: 
97: ```text
98: ON received obstacle sensor input:
99:     UPDATE the matching Front/Left/Right Obstacle field in D1
100:     PRESERVE the other fields (all three must be initialized before first Tick, C12)
101: ```
102: 
103: ### Relevant Requirements
104: - B3, B4, C1, C12
105: 
106: ## Process 2: Detect Dust
107: 
108: ### Process Identification
109: 
110: | Field | Description |
111: |---|---|
112: | Process ID | 2 |
113: | Process Name | Detect Dust |
114: | DFD Level | Level 1 |
115: | Parent Process | 0 |
116: 
117: ### Purpose
118: Record the current dust reading and latch each TRUE detection until Process 4 consumes it on a Forward Tick (C15).
119: 
120: ### Inputs
121: - Dust Sensor Input
122: - Dust Existence (previous record from D2, including Pending Dust Detection)
123: 
124: ### Outputs
125: - Dust Existence (to D2 Dust Existence)
126: 
127: ### Trigger / Execution Condition
128: - When the dust sensor input is received.
129: 
130: ### Processing Logic
131: 1. Before initial sampling, set Pending Dust Detection to FALSE; obtain the actual initial Dust Sensor Input before the first Tick (C12).
132: 2. Store the current reading as Dust Detected. A TRUE input sets Pending Dust Detection to TRUE; a FALSE input preserves it (C15). Process 4.1 alone consumes it on a Forward Tick.
133: 3. This input update and Tick consumption are logically serialized, so a new input after consumption is retained for the next Tick.
134: 
135: ### Pseudocode
136: 
137: ```text
138: ON Dust Sensor Input:
139:     READ only Pending Dust Detection FROM D2
140:     Dust Existence.Dust Detected = Dust Sensor Input
141:     Dust Existence.Pending Dust Detection = Pending Dust Detection OR Dust Sensor Input
142:     WRITE Dust Existence TO D2
143: ```
144: 
145: ### Relevant Requirements
146: - B5, C12, C15
147: 
148: ## Process 3: Control Movement
149: 
150: ### Process Identification
151: 
152: | Field | Description |
153: |---|---|
154: | Process ID | 3 |
155: | Process Name | Control Movement |
156: | DFD Level | Level 1 |
157: | Parent Process | 0 |
158: 
159: ### Purpose
160: Decide the movement of the RVC from the obstacle locations, and tell Process 4 whether the RVC is moving forward or avoiding an obstacle.
161: 
162: ### Inputs
163: - Obstacle Location (from D1 Obstacle Location)
164: - Tick (control)
165: 
166: ### Outputs
167: - Direction (to Motor)
168: - Movement Status (to Process 4)
169: 
170: ### Trigger / Execution Condition
171: - Executes on every Tick.
172: 
173: ### Processing Logic
174: 1. Classify both Front Blocked and Side Situation, with right priority, independently of the front (3.1, C1/C9).
175: 2. Keep the movement state across ticks. Forward with front blocked enters a five-tick Stop (C2/C7); Forward with front clear remains Forward (C16).
176: 3. On completing Stop or Backing, use the sides: right clear means Turn Right, else left clear means Turn Left, else Backward. Backing ignores the front and can repeat (C5/C9).
177: 4. Stop, Backing and each Turn last five ticks (C6-C8). Turn completion resumes Forward. Exact timer ordering is specified by 3.2/3.2.2/3.2.4 and Level 4.
178: 5. Return one Direction and corresponding Movement Status for this Tick. Initialization alone produces no output (C13).
179: 
180: ### Pseudocode
181: 
182: ```text
183: ON Tick:
184:     Obstacle Situation = Process 3.1(D1)
185:     Direction, Movement Status = Process 3.2(Obstacle Situation, persistent state)
186: ```
187: 
188: ### Relevant Requirements
189: - B2, B3, B4, C1, C2, C4-C9, C12, C13; C16
190: 
191: ## Process 4: Control Cleaning
192: 
193: ### Process Identification
194: 
195: | Field | Description |
196: |---|---|
197: | Process ID | 4 |
198: | Process Name | Control Cleaning |
199: | DFD Level | Level 1 |
200: | Parent Process | 0 |
201: 
202: ### Purpose
203: Decide the cleaning command from the movement status and dust existence, including the 5-tick power-up, remembered dust, and suction/mopping semantics (C14/C15).
204: 
205: ### Inputs
206: - Movement Status (from Process 3)
207: - Dust Existence (from D2 Dust Existence)
208: - Tick (control)
209: 
210: ### Outputs
211: - Clean (to Cleaner)
212: - Pending Dust Detection (updated flag to D2)
213: 
214: ### Trigger / Execution Condition
215: - Executes on every Tick, after the current Movement Status is available.
216: 
217: ### Processing Logic
218: 1. Obtain Power-Up Active from Process 4.1 using this Tick's Movement Status and current/pending dust; D3 initially equals 0.
219: 2. While Avoiding, stop both suction and mopping and preserve D3 and pending dust (C11/C15).
220: 3. On Forward with pending or current dust, restart five ticks and consume the pending flag (C10/C15). Otherwise resume any saved ticks (C11).
221: 4. Process 4.2 emits Start, Stop or Power Up with C14's suction/mopping meanings.
222: 
223: ### Pseudocode
224: 
225: ```text
226: ON Tick after Movement Status:
227:     Power-Up Active = Process 4.1(Dust Existence, Movement Status, D3)
228:     Clean = Process 4.2(Movement Status, Power-Up Active)
229: ```
230: 
231: ### Relevant Requirements
232: - B1, B2, B3, B5, C3, C10, C11, C13-C15
233: - Q4 -> C10 and Q5 -> C11 are resolved; avoidance dust is resolved by C15.
234: 
235: # DFD Level 2
236: 
237: Processes 1 (Detect Obstacle) and 2 (Detect Dust) are functional primitives and are not decomposed. Their Level 1 specifications remain in force. Processes 3 and 4 are decomposed below.
238: 
239: ## Process 3.1: Assess Obstacle Situation
240: 
241: ### Process Identification
242: 
243: | Field | Description |
244: |---|---|
245: | Process ID | 3.1 |
246: | Process Name | Assess Obstacle Situation |
247: | DFD Level | Level 2 |
248: | Parent Process | 3 |
249: 
250: ### Purpose
251: Classify the current obstacles into one Obstacle Situation.
252: 
253: ### Inputs
254: - Obstacle Location (from D1 Obstacle Location)
255: - Tick (control)
256: 
257: ### Outputs
258: - Obstacle Situation (to Process 3.2)
259: 
260: ### Trigger / Execution Condition
261: - Executes on every Tick.
262: 
263: ### Processing Logic
264: Revised 2026-11-16 for C9: the sides are classified whether or not the front is blocked.
265: 
266: 1. Read Obstacle Location from D1.
267: 2. Front Blocked is TRUE when the front sensor detects an obstacle.
268: 3. Side Situation is Right Open when the right is clear (C1: right has priority).
269: 4. Otherwise it is Left Open when the left is clear.
270: 5. Otherwise it is Sides Blocked.
271: 
272: With Front Blocked, Sides Blocked means front, left, and right are all blocked (B4).
273: 
274: ### Pseudocode
275: 
276: ```text
277: ON Tick:
278:     READ Obstacle Location FROM D1
279:     Obstacle Situation.Front Blocked = Front Obstacle
280:     IF Right Obstacle == FALSE THEN
281:         Obstacle Situation.Side Situation = Right Open        (C1)
282:     ELSE IF Left Obstacle == FALSE THEN
283:         Obstacle Situation.Side Situation = Left Open
284:     ELSE
285:         Obstacle Situation.Side Situation = Sides Blocked
286:     END IF
287: ```
288: 
289: ### Relevant Requirements
290: - B3, B4, C1, C9
291: - C16: while Forward, the Controller uses Front Blocked only for avoidance entry; a clear front means continued forward movement and cleaning.
292: 
293: ## Process 3.2: Decide Movement
294: 
295: ### Process Identification
296: 
297: | Field | Description |
298: |---|---|
299: | Process ID | 3.2 |
300: | Process Name | Decide Movement |
301: | DFD Level | Level 2 |
302: | Parent Process | 3 |
303: 
304: ### Purpose
305: Sequence the movement over ticks from the Obstacle Situation and send the Direction to the Motor. Report whether the RVC is moving forward or avoiding.
306: 
307: ### Inputs
308: - Obstacle Situation (from Process 3.1)
309: - Tick (control)
310: 
311: ### Outputs
312: - Direction (to Motor)
313: - Movement Status (to Process 4)
314: 
315: ### Trigger / Execution Condition
316: - Executes on every Tick, after 3.1.
317: 
318: ### Processing Logic
319: Obstacle Situation is a record: Front Blocked plus Side Situation. Initialize the movement state to Forward without output (C13). On each Tick, advance D4 before taking the Controller transition. In Forward, front blocked enters Stopping and starts D4; otherwise remain Forward. Stopping and Backing retain their action until Step Done. When Done, use only the sides (Right Open -> Turning Right; Left Open -> Turning Left; Sides Blocked -> Backing) and restart D4, including repeated Backing. Turning retains its direction until Done, then selects Forward. C16 applies only to Forward avoidance entry, not side classification or the Backing decision (C9).
320: 
321: ### Pseudocode
322: 
323: ```text
324: ON Tick after Process 3.1:
325:     Situation Signal = Process 3.2.1(Obstacle Situation)
326:     Step Done = Process 3.2.4 advance on Tick
327:     Movement Command, optional Start Step Timer = Process 3.2.2(Situation Signal, Step Done)
328:     IF Start Step Timer issued THEN Process 3.2.4 sets D4 = 0
329:     Direction, Movement Status = Process 3.2.3(Movement Command)
330: ```
331: 
332: ### Relevant Requirements
333: - B2-B4, C1, C2, C4-C9, C13; C16
334: - Exact states/transitions: Process 3.2.2 and Level 4 FSM. Five-tick boundaries: Process 3.2.4.
335: 
336: ## Process 4.1: Track Power-Up
337: 
338: ### Process Identification
339: 
340: | Field | Description |
341: |---|---|
342: | Process ID | 4.1 |
343: | Process Name | Track Power-Up |
344: | DFD Level | Level 2 |
345: | Parent Process | 4 |
346: 
347: ### Purpose
348: Run the five-tick suction power-up from current or remembered dust; freeze its remaining ticks while Avoiding (C10/C11/C15).
349: 
350: ### Inputs
351: - Dust Existence (from D2 Dust Existence)
352: - Movement Status (from Process 3.2)
353: - Remaining Power-Up Ticks (from D3 Power-Up Timer)
354: - Tick (control)
355: 
356: ### Outputs
357: - Power-Up Active (to Process 4.2)
358: - Remaining Power-Up Ticks (to D3 Power-Up Timer)
359: - Pending Dust Detection (updated flag only, to D2 Dust Existence)
360: 
361: ### Trigger / Execution Condition
362: - Executes on every Tick, after Movement Status for the tick is available.
363: 
364: ### Processing Logic
365: Revised 2026-11-17 for C15; C10/C11 remain in force with the explicit restart precedence below. D3 starts at 0 before the first Tick. D2's pending flag is initialized FALSE before initial sensor sampling and is set by Process 2 on every TRUE dust input.
366: 
367: 1. Read current Dust Detected and Pending Dust Detection from D2 and Remaining Power-Up Ticks from D3.
368: 2. While Avoiding, output Power-Up Active=FALSE, preserve remaining ticks and the pending flag. Process 2 continues recording detections; no consumption or countdown occurs.
369: 3. While Forward, if current dust or pending dust is TRUE, set the remaining count to 5. This overrides a saved partial count (C15). Clear the pending flag only after consuming it; do not change the current Dust Detected value.
370: 4. If Forward with count > 0, output Power-Up Active=TRUE and decrement by one; otherwise output FALSE. Write the updated count and pending flag to their respective stores.
371: 
372: A start/restart at t powers suction on t..t+4 in the absence of another detection or avoidance. On a restart Tick, D3 becomes 4 after the current active tick is counted. Multiple pending detections coalesce into one restart. Without current/pending dust, a saved count resumes under C11. A continuously TRUE current reading restarts on each Forward Tick under C10, as before. A TRUE input followed by FALSE between ticks is not lost because Process 2 latches it.
373: 
374: ### Pseudocode
375: 
376: ```text
377: ON Tick after Movement Status:
378:     READ Dust Detected, Pending Dust Detection FROM D2
379:     READ Remaining Power-Up Ticks FROM D3
380:     Power-Up Active = FALSE
381:     IF Movement Status == Forward THEN
382:         IF Dust Detected OR Pending Dust Detection THEN
383:             Remaining Power-Up Ticks = 5               (C3, C10, C15)
384:         END IF
385:         Pending Dust Detection = FALSE                 (consume on Forward only)
386:         IF Remaining Power-Up Ticks > 0 THEN
387:             Power-Up Active = TRUE
388:             Remaining Power-Up Ticks = Remaining Power-Up Ticks - 1
389:         END IF
390:     END IF                                             (Avoiding preserves both, C11/C15)
391:     WRITE Remaining Power-Up Ticks TO D3
392:     UPDATE only Pending Dust Detection IN D2            (preserve current Dust Detected)
393: ```
394: 
395: Input updates and this Tick are logically serialized per Process 0's contract. A later input cannot be cleared by the earlier Tick's consumption.
396: 
397: ### Relevant Requirements
398: - B5, C3, C10, C11, C12, C15
399: 
400: ## Process 4.2: Decide Cleaning
401: 
402: ### Process Identification
403: 
404: | Field | Description |
405: |---|---|
406: | Process ID | 4.2 |
407: | Process Name | Decide Cleaning |
408: | DFD Level | Level 2 |
409: | Parent Process | 4 |
410: 
411: ### Purpose
412: Choose the cleaning command for the current tick.
413: 
414: ### Inputs
415: - Movement Status (from Process 3.2)
416: - Power-Up Active (from Process 4.1)
417: 
418: ### Outputs
419: - Clean (to Cleaner)
420: 
421: ### Trigger / Execution Condition
422: - When Power-Up Active for the tick arrives from 4.1.
423: 
424: ### Processing Logic
425: 1. While avoiding, stop cleaning (B3).
426: 2. While moving forward with power-up active, power up the cleaning (B5).
427: 3. While moving forward otherwise, clean normally (B1, B2). This also resumes cleaning after avoidance (B3).
428: 4. C14: Start enables normal suction and mopping; Stop disables both; Power Up strengthens suction only while mopping continues normally. No hardware implementation detail is specified (B6).
429: 
430: ### Pseudocode
431: 
432: ```text
433: ON Power-Up Active:
434:     IF Movement Status == Avoiding THEN
435:         Clean = Stop
436:     ELSE IF Power-Up Active == TRUE THEN
437:         Clean = Power Up
438:     ELSE
439:         Clean = Start
440:     END IF
441: ```
442: 
443: ### Relevant Requirements
444: - B1, B2, B3, B5, C14
445: 
446: # DFD Level 3
447: 
448: Only Process 3.2 (Decide Movement) is decomposed. Processes 1, 2, 3.1, 4.1, and 4.2 are functional primitives; their earlier specifications remain in force.
449: 
450: ## Process 3.2.1: Signal Obstacle Situation
451: 
452: ### Process Identification
453: 
454: | Field | Description |
455: |---|---|
456: | Process ID | 3.2.1 |
457: | Process Name | Signal Obstacle Situation |
458: | DFD Level | Level 3 |
459: | Parent Process | 3.2 |
460: | Process Type | Data |
461: 
462: ### Purpose
463: Deliver the Obstacle Situation to the Movement Controller as a control signal.
464: 
465: ### Inputs
466: - Obstacle Situation (from Process 3.1)
467: 
468: ### Outputs
469: - Situation Signal (control, to Process 3.2.2)
470: 
471: ### Trigger / Execution Condition
472: - When Obstacle Situation arrives from 3.1 (once per Tick).
473: 
474: ### Processing Logic
475: 1. Receive the Obstacle Situation.
476: 2. Emit the Situation Signal with the same value.
477: 
478: ### Pseudocode
479: 
480: ```text
481: ON Obstacle Situation:
482:     Situation Signal = Obstacle Situation     (Front Blocked + Side Situation; C9)
483: ```
484: 
485: ### Relevant Requirements
486: - B3, B4, C1, C9
487: 
488: ## Process 3.2.2: Movement Controller
489: 
490: ### Process Identification
491: 
492: | Field | Description |
493: |---|---|
494: | Process ID | 3.2.2 |
495: | Process Name | Movement Controller |
496: | DFD Level | Level 3 |
497: | Parent Process | 3.2 |
498: | Process Type | Control |
499: 
500: ### Purpose
501: Sequence the RVC movement over ticks: go forward, stop at an obstacle for 5 ticks, move backward for 5 ticks when needed, turn for 5 ticks, and resume forward.
502: 
503: ### Inputs
504: - Tick (control)
505: - Situation Signal (control, from Process 3.2.1)
506: - Step Done (control, from Process 3.2.4)
507: 
508: ### Outputs
509: - Movement Command (control, to Process 3.2.3)
510: - Start Step Timer (control, to Process 3.2.4)
511: 
512: ### Trigger / Execution Condition
513: - Executes on every Tick, after Situation Signal and Step Done for the tick are available.
514: 
515: ### Processing Logic
516: The Controller has five states: Forward (initial), Stopping, Backing, Turning Right, Turning Left. Initialization sets Forward without output (C13). On each Tick it takes one transition and issues one Movement Command. Initial sensor sampling precedes the first Tick (C12).
517: 
518: | Current State | Tick condition | Actions | Next State | Source |
519: |---|---|---|---|---|
520: | Forward | not Front Blocked | Forward | Forward | B2, C16 |
521: | Forward | Front Blocked | Stop, Start Step Timer | Stopping | B3, C2, C7, C16 |
522: | Stopping | not Step Done | Stop | Stopping | C7 |
523: | Stopping | Step Done and Right Open | Turn Right, Start Step Timer | Turning Right | C1, C8 |
524: | Stopping | Step Done and Left Open | Turn Left, Start Step Timer | Turning Left | B3, C8 |
525: | Stopping | Step Done and Sides Blocked | Backward, Start Step Timer | Backing | B4, C6 |
526: | Backing | not Step Done | Backward | Backing | C6 |
527: | Backing | Step Done and Sides Blocked | Backward, Start Step Timer | Backing | C5, C6, C9 |
528: | Backing | Step Done and Right Open | Turn Right, Start Step Timer | Turning Right | C5, C8 |
529: | Backing | Step Done and Left Open | Turn Left, Start Step Timer | Turning Left | C5, C8 |
530: | Turning Right | not Step Done | Turn Right | Turning Right | C8 |
531: | Turning Right | Step Done | Forward | Forward | B3, B4, C8 |
532: | Turning Left | not Step Done | Turn Left | Turning Left | C8 |
533: | Turning Left | Step Done | Forward | Forward | B3, B4, C8 |
534: 
535: When a stop or backward step ends, only the Side Situation decides (C9). The full state model, with transition IDs and validation, is the Level 4 FSM (`artifacts/SA/DFD/dfd_level_4_fsm.md`).
536: 
537: ### Relevant Requirements
538: - B2, B3, B4, C1, C2, C4, C5, C6, C7, C8, C9, C16
539: 
540: ## Process 3.2.3: Issue Movement Output
541: 
542: ### Process Identification
543: 
544: | Field | Description |
545: |---|---|
546: | Process ID | 3.2.3 |
547: | Process Name | Issue Movement Output |
548: | DFD Level | Level 3 |
549: | Parent Process | 3.2 |
550: | Process Type | Data |
551: 
552: ### Purpose
553: Turn the Controller's Movement Command into the Direction for the Motor and the Movement Status for Process 4.
554: 
555: ### Inputs
556: - Movement Command (control, from Process 3.2.2)
557: 
558: ### Outputs
559: - Direction (to Motor)
560: - Movement Status (to Process 4)
561: 
562: ### Trigger / Execution Condition
563: - When a Movement Command arrives.
564: 
565: ### Processing Logic
566: 1. Send Direction with the same value as the Movement Command.
567: 2. Report Movement Status Forward when the command is Forward; otherwise Avoiding (B3: cleaning stops while avoiding).
568: 
569: ### Pseudocode
570: 
571: ```text
572: ON Movement Command:
573:     Direction = Movement Command
574:     IF Movement Command == Forward THEN
575:         Movement Status = Forward
576:     ELSE
577:         Movement Status = Avoiding
578:     END IF
579: ```
580: 
581: ### Relevant Requirements
582: - B2, B3, B4
583: 
584: ## Process 3.2.4: Time Movement Step
585: 
586: ### Process Identification
587: 
588: | Field | Description |
589: |---|---|
590: | Process ID | 3.2.4 |
591: | Process Name | Time Movement Step |
592: | DFD Level | Level 3 |
593: | Parent Process | 3.2 |
594: | Process Type | Data |
595: 
596: ### Purpose
597: Count the ticks of a stop, backward, or turn step and tell the Controller when 5 ticks have elapsed.
598: 
599: ### Inputs
600: - Start Step Timer (control, from Process 3.2.2)
601: - Tick (control)
602: - Step Ticks Elapsed (from D4 Step Timer)
603: 
604: ### Outputs
605: - Step Done (control, to Process 3.2.2)
606: - Step Ticks Elapsed (to D4 Step Timer)
607: 
608: ### Trigger / Execution Condition
609: - On every Tick, before 3.2.2 runs.
610: - On Start Step Timer, issued by 3.2.2 during a tick.
611: 
612: ### Processing Logic
613: 1. On Start Step Timer, set the count to 0. The tick on which the step starts is the first tick of the step.
614: 2. On each later Tick, if a step is running, add 1.
615: 3. When the count reaches 5, emit Step Done and set the timer to Idle.
616: 
617: A step started on tick t covers ticks t to t+4. Step Done arrives on tick t+5, when the Controller issues the next action.
618: 
619: ### Pseudocode
620: 
621: ```text
622: ON Start Step Timer:
623:     WRITE Step Ticks Elapsed = 0 TO D4
624: 
625: ON Tick:                                   (before 3.2.2)
626:     READ Step Ticks Elapsed FROM D4
627:     IF Step Ticks Elapsed != Idle THEN
628:         Step Ticks Elapsed = Step Ticks Elapsed + 1
629:         IF Step Ticks Elapsed == 5 THEN
630:             emit Step Done
631:             Step Ticks Elapsed = Idle
632:         END IF
633:         WRITE Step Ticks Elapsed TO D4
634:     END IF
635: ```
636: 
637: Initial value of D4: Idle.
638: 
639: ### Relevant Requirements
640: - C6, C7, C8

## artifacts/SA/DFD/dfd_level_0.md

1: # DFD Level 0
2: 
3: System: RVC Controller
4: Sources: `docs/preliminary_requirements.md`, `docs/requirements_clarifications.md`, `artifacts/SA/event_list.md`, `artifacts/SA/context_diagram.md`
5: 
6: ## Diagram
7: 
8: ```mermaid
9: flowchart LR
10:     FrontSensor["Front Sensor"]
11:     LeftSensor["Left Sensor"]
12:     RightSensor["Right Sensor"]
13:     DustSensor["Dust Sensor"]
14:     DigitalClock["Digital Clock"]
15:     P0(("0. RVC Controller"))
16:     Motor["Motor"]
17:     Cleaner["Cleaner"]
18: 
19:     FrontSensor -->|Front Sensor Input| P0
20:     LeftSensor -->|Left Sensor Input| P0
21:     RightSensor -->|Right Sensor Input| P0
22:     DustSensor -->|Dust Sensor Input| P0
23:     DigitalClock -.->|Tick| P0
24:     P0 -->|Direction| Motor
25:     P0 -->|Clean| Cleaner
26: ```
27: 
28: Solid arrows are data flows. The dashed arrow is a control flow.
29: 
30: ## Process
31: 
32: | Process ID | Process Name | Responsibility |
33: |---|---|---|
34: | 0 | RVC Controller | Turns sensor inputs and clock ticks into movement and cleaning commands. |
35: 
36: ## Balancing with the Context Diagram
37: 
38: | Flow | Direction | Category | External Entity | Context Diagram | Level 0 |
39: |---|---|---|---|---|---|
40: | Front Sensor Input | Input | Data | Front Sensor | Yes | Yes |
41: | Left Sensor Input | Input | Data | Left Sensor | Yes | Yes |
42: | Right Sensor Input | Input | Data | Right Sensor | Yes | Yes |
43: | Dust Sensor Input | Input | Data | Dust Sensor | Yes | Yes |
44: | Tick | Input | Control | Digital Clock | Yes | Yes |
45: | Direction | Output | Data | Motor | Yes | Yes |
46: | Clean | Output | Data | Cleaner | Yes | Yes |
47: 
48: Level 0 introduces no flows, Data Stores, or internal processes beyond the Context Diagram.
49: 
50: ## Initialization and output semantics
51: 
52: Before the first Tick, all four sensor readings are available (C12). Power On initializes state only and emits neither Direction nor Clean (C13); it is not a new external flow. Clean Start/Stop jointly enables/disables suction and mopping, and Power Up strengthens suction while mopping stays normal (C14). Dust detections retained for later use (C15) are internal state, not a new external event.

## artifacts/SA/DFD/dfd_level_1.md

1: # DFD Level 1
2: 
3: System: RVC Controller
4: Parent: Process 0 (RVC Controller), `artifacts/SA/DFD/dfd_level_0.md`
5: Sources: `docs/preliminary_requirements.md` (B1-B7), `docs/requirements_clarifications.md` (C1-C16), `artifacts/SA/event_list.md`, `artifacts/SA/context_diagram.md`
6: 
7: ## Diagram
8: 
9: ```mermaid
10: flowchart LR
11:     FrontSensor["Front Sensor"]
12:     LeftSensor["Left Sensor"]
13:     RightSensor["Right Sensor"]
14:     DustSensor["Dust Sensor"]
15:     DigitalClock["Digital Clock"]
16:     Motor["Motor"]
17:     Cleaner["Cleaner"]
18: 
19:     P1(("1. Detect Obstacle"))
20:     P2(("2. Detect Dust"))
21:     P3(("3. Control Movement"))
22:     P4(("4. Control Cleaning"))
23: 
24:     DS1[["D1 Obstacle Location"]]
25:     DS2[["D2 Dust Existence"]]
26: 
27:     FrontSensor -->|Front Sensor Input| P1
28:     LeftSensor -->|Left Sensor Input| P1
29:     RightSensor -->|Right Sensor Input| P1
30:     DustSensor -->|Dust Sensor Input| P2
31: 
32:     P1 -->|Obstacle Location| DS1
33:     P2 -->|Dust Existence| DS2
34:     DS2 -->|Dust Existence| P2
35: 
36:     DS1 -->|Obstacle Location| P3
37:     DS2 -->|Dust Existence| P4
38:     P4 -->|Pending Dust Detection| DS2
39: 
40:     DigitalClock -.->|Tick| P3
41:     DigitalClock -.->|Tick| P4
42: 
43:     P3 -->|Movement Status| P4
44: 
45:     P3 -->|Direction| Motor
46:     P4 -->|Clean| Cleaner
47: ```
48: 
49: Solid arrows are data flows. Dashed arrows are control flows. `[[ ]]` nodes are Data Stores.
50: 
51: All four processes are data processes. No control process is introduced at this level: control and data processing are separated at Level 3, where the Controller is identified for the Level 4 FSM (sa-dfd Step 5.4).
52: 
53: ## Processes
54: 
55: | Process ID | Process Name | Responsibility | Requirements |
56: |---|---|---|---|
57: | 1 | Detect Obstacle | Reads the front, left, and right sensor inputs and records where obstacles are. | B3, B4, C1 |
58: | 2 | Detect Dust | Records the current dust reading and latches every TRUE detection until consumed on a Forward Tick. | B5, C15 |
59: | 3 | Control Movement | On each Tick, decides the movement from the obstacle locations: go forward, stop, turn right or left, or move backward. Reports whether the RVC is moving forward or avoiding an obstacle. | B2, B3, B4, C1, C2 |
60: | 4 | Control Cleaning | On each Tick, decides the cleaning command from the movement status and dust existence: start, stop, or power up for 5 ticks. Consumes pending dust on Forward; retains it while Avoiding. | B1, B2, B3, B5, C3, C10, C11, C14, C15 |
61: 
62: ### Decomposition rationale
63: 
64: - 1 and 2 separate sensor interpretation from decision making. Each groups the inputs of one requirement: obstacle sensors (B3, B4) and the dust sensor (B5).
65: - 3 and 4 follow the two outputs of Process 0. Movement (`Direction`) depends on obstacles; cleaning (`Clean`) depends on dust and on whether the RVC is avoiding an obstacle (B3: "stops cleaning ... goes forward with cleaning").
66: - `Movement Status` is the only coupling between 3 and 4. It carries the B3 rule that cleaning stops while avoiding and resumes when moving forward again.
67: 
68: ## Data Stores
69: 
70: | ID | Data Store | Contents | Written by | Read by | Justification |
71: |---|---|---|---|---|---|
72: | D1 | Obstacle Location | Front Obstacle, Left Obstacle, Right Obstacle | 1 | 3 | Sensor inputs arrive independently of the clock. 3 acts on Tick, so it needs the latest reading of all three sensors at that moment. |
73: | D2 | Dust Existence | Dust Detected + Pending Dust Detection | 2 (current reading and latch); 4 (consume pending flag) | 2, 4 | Preserve the latest reading and a TRUE detection even if the sensor clears before Forward resumes (C15). |
74: 
75: The 5-tick power-up count is kept inside Process 4 at this level. Whether it needs its own Data Store is decided at Level 2.
76: 
77: ## Internal Flows
78: 
79: | Flow | Category | Source | Destination | Content |
80: |---|---|---|---|---|
81: | Obstacle Location | Data | 1 (write), D1 (read) | D1, 3 | Front Obstacle + Left Obstacle + Right Obstacle |
82: | Dust Existence | Data | 2 (write), D2 (read) | D2, 2, 4 | Dust Detected + Pending Dust Detection |
83: | Pending Dust Detection | Data | 4 | D2 | Updated pending flag; FALSE after a Forward Tick consumes the detection, unchanged during avoidance |
84: | Movement Status | Data | 3 | 4 | Forward or Avoiding |
85: 
86: ## Balancing with Level 0
87: 
88: | Level 0 Flow | Direction | Category | External Entity | Level 1 Process | Balanced |
89: |---|---|---|---|---|---|
90: | Front Sensor Input | Input | Data | Front Sensor | 1 | Yes |
91: | Left Sensor Input | Input | Data | Left Sensor | 1 | Yes |
92: | Right Sensor Input | Input | Data | Right Sensor | 1 | Yes |
93: | Dust Sensor Input | Input | Data | Dust Sensor | 2 | Yes |
94: | Tick | Input | Control | Digital Clock | 3, 4 | Yes (split, see below) |
95: | Direction | Output | Data | Motor | 3 | Yes |
96: | Clean | Output | Data | Cleaner | 4 | Yes |
97: 
98: Flow mapping: the single Level 0 `Tick` is delivered to both 3 and 4. It is the same event, not two different flows.
99: 
100: No external flow was added or removed. `Obstacle Location`, `Dust Existence`, `Pending Dust Detection`, and `Movement Status` are internal to Process 0.
101: 
102: ## Decisions and remaining assumption
103: 
104: Q1-Q5 are resolved: C5 defines post-backing selection/repetition; C6-C8 set five-tick steps; C10 restarts power-up on re-detection; C11 preserves its count during avoidance. C9 requires side classification independently of the front. C15 remembers avoidance dust and restarts on resumption; without such dust C11 resumes the saved count. Q6 is resolved by C16: while Forward, a clear front does not initiate avoidance solely because of side obstacles.
105: 
106: Before the first Tick, obtain all four sensor readings into D1/D2 (C12). Initialize D3=0, D4=Idle and the pending flag=FALSE before initial sampling. Power On emits no commands (C13). Process 1 updates the received sensor field while preserving other valid readings. Process 2 updates the current dust reading and ORs TRUE detections into the pending flag. Input receipt and Tick processing are logically serialized: inputs received before a Tick are included in its snapshot; later inputs are processed after that Tick. This defines the analysis ordering, not hardware synchronization details (B6).

## artifacts/SA/DFD/dfd_level_2.md

1: # DFD Level 2
2: 
3: System: RVC Controller
4: Parent: DFD Level 1, `artifacts/SA/DFD/dfd_level_1.md`
5: Sources: `docs/preliminary_requirements.md` (B1-B7), `docs/requirements_clarifications.md` (C1-C16), `artifacts/SA/event_list.md`, `artifacts/SA/context_diagram.md`, `artifacts/SA/DFD/dfd_level_0.md`, `artifacts/SA/DFD/dfd_level_1.md`
6: 
7: ## Decomposition Scope
8: 
9: | Level 1 Process | Decomposed | Reason |
10: |---|---|---|
11: | 1 Detect Obstacle | No | Functional primitive. It copies three Boolean sensor values into D1; splitting it into per-sensor processes would add no function the requirements describe. Its Level 1 Process Specification is complete. |
12: | 2 Detect Dust | No | Functional primitive. It updates the current dust Boolean and latches a pending detection in D2 (C15). |
13: | 3 Control Movement | Yes → 3.1, 3.2 | It mixes two functions: classifying the obstacle situation (B3, B4, C1, C16) and sequencing the movement over several ticks (stop, turn, backward, forward; B3, B4, C2). |
14: | 4 Control Cleaning | Yes → 4.1, 4.2 | It mixes two functions: counting the 5-tick power-up (B5, C3) and choosing the cleaning command (B1-B3, B5). |
15: 
16: ## Diagram 3: Control Movement
17: 
18: ```mermaid
19: flowchart LR
20:     DigitalClock["Digital Clock"]
21:     Motor["Motor"]
22:     DS1[["D1 Obstacle Location"]]
23:     P4ext(("4. Control Cleaning"))
24: 
25:     P31(("3.1 Assess Obstacle Situation"))
26:     P32(("3.2 Decide Movement"))
27: 
28:     DS1 -->|Obstacle Location| P31
29:     DigitalClock -.->|Tick| P31
30:     DigitalClock -.->|Tick| P32
31:     P31 -->|Obstacle Situation| P32
32:     P32 -->|Direction| Motor
33:     P32 -->|Movement Status| P4ext
34: ```
35: 
36: Solid arrows are data flows. Dashed arrows are control flows. `[[ ]]` nodes are Data Stores. `4. Control Cleaning` is a sibling Level 1 process, shown only as the destination of `Movement Status`.
37: 
38: ### Processes
39: 
40: | Process ID | Process Name | Responsibility | Requirements |
41: |---|---|---|---|
42: | 3.1 | Assess Obstacle Situation | On each Tick, reads D1 and classifies the obstacles into one Obstacle Situation. Always classifies the sides with right priority (C1, C9), independently of the front. C16 restricts only Forward avoidance entry. | B3, B4, C1, C9, C16 |
43: | 3.2 | Decide Movement | On each Tick, chooses the Direction from the Obstacle Situation and the current avoidance step: stop first (C2), then turn, or move backward then turn; go forward when clear. Reports Movement Status to Process 4. | B2, B3, B4, C1, C2 |
44: 
45: The avoidance step (stopping, turning, moving backward) is control state that persists across ticks. It stays inside 3.2 at this level. Level 3 separates it from 3.2 as the Controller, which Level 4 describes as an FSM.
46: 
47: ### Balancing with Process 3
48: 
49: | Process 3 Flow | Direction | Category | Level 2 Process | Balanced |
50: |---|---|---|---|---|
51: | Obstacle Location (from D1) | Input | Data | 3.1 | Yes |
52: | Tick | Input | Control | 3.1, 3.2 | Yes (same event to both) |
53: | Direction | Output | Data | 3.2 | Yes |
54: | Movement Status | Output | Data | 3.2 | Yes |
55: 
56: Internal flow added: `Obstacle Situation` (3.1 → 3.2).
57: 
58: ## Diagram 4: Control Cleaning
59: 
60: ```mermaid
61: flowchart LR
62:     DigitalClock["Digital Clock"]
63:     Cleaner["Cleaner"]
64:     DS2[["D2 Dust Existence"]]
65:     DS3[["D3 Power-Up Timer"]]
66:     P3ext(("3. Control Movement"))
67: 
68:     P41(("4.1 Track Power-Up"))
69:     P42(("4.2 Decide Cleaning"))
70: 
71:     DS2 -->|Dust Existence| P41
72:     DigitalClock -.->|Tick| P41
73:     P3ext -->|Movement Status| P41
74:     P3ext -->|Movement Status| P42
75:     DS3 -->|Remaining Power-Up Ticks| P41
76:     P41 -->|Remaining Power-Up Ticks| DS3
77:     P41 -->|Pending Dust Detection| DS2
78:     P41 -->|Power-Up Active| P42
79:     P42 -->|Clean| Cleaner
80: ```
81: 
82: Solid arrows are data flows. Dashed arrows are control flows. `[[ ]]` nodes are Data Stores. `3. Control Movement` is a sibling Level 1 process, shown only as the source of `Movement Status`.
83: 
84: ### Processes
85: 
86: | Process ID | Process Name | Responsibility | Requirements |
87: |---|---|---|---|
88: | 4.1 | Track Power-Up | On each Tick, starts/restarts a 5-tick power-up on current or pending dust while Forward, consumes the pending flag, and counts down. While Avoiding, preserves D3 and the pending flag. | B5, C3, C10, C11, C15 |
89: | 4.2 | Decide Cleaning | Chooses the Clean command: Stop while avoiding, Power Up while power-up is active, otherwise Start. Runs when 4.1 reports Power-Up Active for the tick. Start/Stop affect suction and mopping together; Power Up strengthens suction only. | B1, B2, B3, B5, C14 |
90: 
91: ### Data Store
92: 
93: | ID | Data Store | Contents | Written by | Read by | Justification |
94: |---|---|---|---|---|---|
95: | D3 | Power-Up Timer | Remaining Power-Up Ticks (0-5) | 4.1 | 4.1 | The 5-tick count (C3) persists across ticks and freezes during avoidance (C11). Initial value: 0 before initial sensor sampling. |
96: 
97: ### Balancing with Process 4
98: 
99: | Process 4 Flow | Direction | Category | Level 2 Process | Balanced |
100: |---|---|---|---|---|
101: | Dust Existence (from D2) | Input | Data | 4.1 | Yes |
102: | Movement Status | Input | Data | 4.1, 4.2 | Yes (same flow to both) |
103: | Tick | Input | Control | 4.1 | Yes |
104: | Clean | Output | Data | 4.2 | Yes |
105: | Pending Dust Detection (to D2) | Output | Data | 4.1 | Yes |
106: 
107: Internal items added: `Power-Up Active` (4.1 → 4.2), `Remaining Power-Up Ticks` (4.1 ↔ D3), Data Store D3. `Pending Dust Detection` (4.1 → D2) crosses the Process 4 boundary and matches the Level 1 output; it updates only the pending field, not the current Dust Detected value. D2 is external to Process 4, not a newly introduced internal store.
108: 
109: ## Overall Balancing with Level 0
110: 
111: | Level 0 Flow | Level 1 Process | Level 2 Process |
112: |---|---|---|
113: | Front Sensor Input | 1 | 1 (not decomposed) |
114: | Left Sensor Input | 1 | 1 (not decomposed) |
115: | Right Sensor Input | 1 | 1 (not decomposed) |
116: | Dust Sensor Input | 2 | 2 (not decomposed) |
117: | Tick | 3, 4 | 3.1, 3.2, 4.1 |
118: | Direction | 3 | 3.2 |
119: | Clean | 4 | 4.2 |
120: 
121: No system-external flow was added or removed. Obstacle Situation, Power-Up Active, Remaining Power-Up Ticks and D3 are internal to their respective parent processes. Pending Dust Detection crosses Process 4's boundary to D2, matching the revised Level 1 boundary; it remains internal to Process 0.
122: 
123: ## Decisions and remaining assumption
124: 
125: Q1-Q5 are resolved by C5-C7/C10-C11; C8 sets the turn duration. Stopping, Backing and Turning each last five ticks. After Backing only Side Situation decides (C9): right when clear, else left when clear, else back again. C4 preserves physical obstacles, not sensor readings across motion; front remains blocked while stationary in Stopping.
126: 
127: C16 resolves Q6 for Forward avoidance entry: a clear front means continued forward movement and cleaning, regardless of side obstacles. Process 3.1 always supplies both Front Blocked and Side Situation, including when the front is clear.
128: 
129: C15 resolves the formerly unnumbered avoidance-dust question. Process 2 latches every TRUE input in D2; Process 4.1 preserves it while Avoiding and clears it only after a Forward Tick starts/restarts five ticks. Repeated detections coalesce. With no pending/current dust, C11 resumes the saved count. D3 starts at 0. C12-C13 govern initial sampling and output timing; C14 defines the suction/mopping meaning of Clean.

## artifacts/SA/DFD/dfd_level_3.md

1: # DFD Level 3
2: 
3: System: RVC Controller
4: Parent: DFD Level 2, `artifacts/SA/DFD/dfd_level_2.md`
5: Sources: `docs/preliminary_requirements.md` (B1-B7), `docs/requirements_clarifications.md` (C1-C16), `artifacts/SA/DFD/dfd_level_0.md`, `artifacts/SA/DFD/dfd_level_1.md`, `artifacts/SA/DFD/dfd_level_2.md`
6: 
7: ## Decomposition Scope
8: 
9: | Level 2 Process | Decomposed | Reason |
10: |---|---|---|
11: | 1 Detect Obstacle | No | Primitive since Level 2. |
12: | 2 Detect Dust | No | Primitive since Level 2. |
13: | 3.1 Assess Obstacle Situation | No | Primitive. A single stateless classification of D1 (see its Process Specification). |
14: | 3.2 Decide Movement | Yes → 3.2.1, 3.2.2, 3.2.3, 3.2.4 | It mixes control and data processing: it keeps the avoidance step across ticks (control state), counts the 5-tick stop, backward, and turn periods (C6, C7, C8), and produces the Direction and Movement Status data. Level 3 separates the control part as the Controller (sa-dfd Step 5.4). |
15: | 4.1 Track Power-Up | No | Primitive. It handles the numeric count in D3 and consumes the pending-dust Boolean in D2; these are data updates, not movement mode sequencing (C15). |
16: | 4.2 Decide Cleaning | No | Primitive. A stateless choice among three Clean values. |
17: 
18: ## Diagram 3.2: Decide Movement
19: 
20: ```mermaid
21: flowchart LR
22:     DigitalClock["Digital Clock"]
23:     Motor["Motor"]
24:     P31ext(("3.1 Assess Obstacle Situation"))
25:     P4ext(("4. Control Cleaning"))
26:     DS4[["D4 Step Timer"]]
27: 
28:     P321(("3.2.1 Signal Obstacle Situation"))
29:     P322(("3.2.2 Movement Controller"))
30:     P323(("3.2.3 Issue Movement Output"))
31:     P324(("3.2.4 Time Movement Step"))
32: 
33:     P31ext -->|Obstacle Situation| P321
34:     P321 -.->|Situation Signal| P322
35:     DigitalClock -.->|Tick| P322
36:     DigitalClock -.->|Tick| P324
37:     P322 -.->|Start Step Timer| P324
38:     P324 -.->|Step Done| P322
39:     DS4 -->|Step Ticks Elapsed| P324
40:     P324 -->|Step Ticks Elapsed| DS4
41:     P322 -.->|Movement Command| P323
42:     P323 -->|Direction| Motor
43:     P323 -->|Movement Status| P4ext
44: 
45:     classDef control stroke-dasharray: 5 5
46:     class P322 control
47: ```
48: 
49: Solid arrows are data flows. Dashed arrows are control flows. `3.2.2 Movement Controller` is drawn with a dashed border: it is a control process. `3.1` and `4. Control Cleaning` are shown only as the source and destination of the parent's flows.
50: 
51: ## Processes
52: 
53: | Process ID | Process Name | Type | Responsibility | Requirements |
54: |---|---|---|---|---|
55: | 3.2.1 | Signal Obstacle Situation | Data | Converts the Obstacle Situation data from 3.1 into a Situation Signal control flow for the Controller. | B3, B4, C1 |
56: | 3.2.2 | Movement Controller | Control | Keeps the current state (Forward, Stopping, Backing, Turning Right, Turning Left). On each Tick, uses Situation Signal and Step Done to choose the next state, issues one Movement Command, and starts the step timer when a 5-tick step begins. Specified by the Level 4 FSM. | B2, B3, B4, C1, C2, C4-C9, C13 |
57: | 3.2.3 | Issue Movement Output | Data | When a Movement Command arrives, sends the matching Direction to the Motor and the matching Movement Status to Process 4. | B2, B3, B4 |
58: | 3.2.4 | Time Movement Step | Data | Counts the ticks of the current stop, backward, or turn step in D4 and signals Step Done when 5 ticks have elapsed. | C6, C7, C8 |
59: 
60: ## Data Store
61: 
62: | ID | Data Store | Contents | Written by | Read by | Justification |
63: |---|---|---|---|---|---|
64: | D4 | Step Timer | Step Ticks Elapsed (Idle or 0-5) | 3.2.4 | 3.2.4 | The 5-tick stop (C7), backward movement (C6), and turn (C8) must be counted across ticks. The count is numeric data, so it is kept outside the control process, like D3 for the power-up. |
65: 
66: ## Controller Interface (input to Level 4)
67: 
68: | Item | Kind | Values |
69: |---|---|---|
70: | Tick | Input event (control) | — |
71: | Situation Signal | Input condition (control) | Front Blocked (yes or no) and Side Situation (Right Open, Left Open, Sides Blocked) |
72: | Step Done | Input condition (control) | Present on the tick when the running stop, backward, or turn step has lasted 5 ticks |
73: | Movement Command | Output action (control) | Forward, Stop, Turn Right, Turn Left, Backward |
74: | Start Step Timer | Output action (control) | — |
75: | Controller states | Internal | Forward (initial), Stopping, Backing, Turning Right, Turning Left |
76: 
77: ## Controller Behavior
78: 
79: | Current State | Tick condition | Actions | Next State | Source |
80: |---|---|---|---|---|
81: | Forward | not Front Blocked | Forward | Forward | B2 |
82: | Forward | Front Blocked | Stop, Start Step Timer | Stopping | B3, C2, C7 |
83: | Stopping | not Step Done | Stop | Stopping | C7 |
84: | Stopping | Step Done and Right Open | Turn Right, Start Step Timer | Turning Right | B3, C1, C8 |
85: | Stopping | Step Done and Left Open | Turn Left, Start Step Timer | Turning Left | B3, C8 |
86: | Stopping | Step Done and Sides Blocked | Backward, Start Step Timer | Backing | B4, C6 |
87: | Backing | not Step Done | Backward | Backing | C6 |
88: | Backing | Step Done and Sides Blocked | Backward, Start Step Timer | Backing | C5, C6, C9 |
89: | Backing | Step Done and Right Open | Turn Right, Start Step Timer | Turning Right | C5, C8 |
90: | Backing | Step Done and Left Open | Turn Left, Start Step Timer | Turning Left | C5, C8 |
91: | Turning Right | not Step Done | Turn Right | Turning Right | C8 |
92: | Turning Right | Step Done | Forward | Forward | B3, B4, C8 |
93: | Turning Left | not Step Done | Turn Left | Turning Left | C8 |
94: | Turning Left | Step Done | Forward | Forward | B3, B4, C8 |
95: 
96: - **C4 applied:** obstacles do not disappear, so while the RVC is stopped the front stays blocked. Sides Blocked at the end of a stop therefore means front, left, and right are blocked (B4).
97: - **C9 applied (2026-11-16):** at the end of a backward step only the Side Situation decides. The front is not consulted, because moving backward takes the RVC away from the obstacle and the front sensor may read clear.
98: - **Durations:** stop, backward, and turn each last 5 ticks (C7, C6, C8). Turning is split into two states so that the same turn direction is issued for all 5 ticks.
99: 
100: ## Balancing with Process 3.2
101: 
102: | Process 3.2 Flow | Direction | Category | Level 3 Process | Balanced |
103: |---|---|---|---|---|
104: | Obstacle Situation | Input | Data | 3.2.1 | Yes |
105: | Tick | Input | Control | 3.2.2, 3.2.4 | Yes (same event to both) |
106: | Direction | Output | Data | 3.2.3 | Yes |
107: | Movement Status | Output | Data | 3.2.3 | Yes |
108: 
109: Internal items added: `Situation Signal`, `Movement Command`, `Start Step Timer`, `Step Done` (control), `Step Ticks Elapsed` (data), Data Store D4.
110: 
111: ## Overall Balancing with Level 0
112: 
113: | Level 0 Flow | Level 1 | Level 2 | Level 3 |
114: |---|---|---|---|
115: | Front Sensor Input | 1 | 1 | 1 |
116: | Left Sensor Input | 1 | 1 | 1 |
117: | Right Sensor Input | 1 | 1 | 1 |
118: | Dust Sensor Input | 2 | 2 | 2 |
119: | Tick | 3, 4 | 3.1, 3.2, 4.1 | 3.1, 3.2.2, 3.2.4, 4.1 |
120: | Direction | 3 | 3.2 | 3.2.3 |
121: | Clean | 4 | 4.2 | 4.2 |
122: 
123: No external flow was added or removed.
124: 
125: ## Execution Order Within One Tick
126: 
127: 0. Complete initial sampling before the first Tick (C12). Process sensor inputs received before this Tick through 1 and 2; retain pending dust even if a later FALSE input arrived. Input receipt and this Tick are logically serialized.
128: 1. 3.1 reads D1 and produces Obstacle Situation; 3.2.1 converts it to Situation Signal.
129: 2. 3.2.4 advances D4 and, if 5 ticks have elapsed, emits Step Done.
130: 3. 3.2.2 takes its transition and issues Movement Command (and Start Step Timer when a step begins).
131: 4. 3.2.3 produces Direction and Movement Status.
132: 5. 4.1 uses Movement Status, the current/pending dust in D2 and D3. While Avoiding it preserves both pending dust and remaining ticks. On Forward it starts/restarts five ticks for current or pending dust, clears the consumed pending flag, then reports active and decrements D3. 4.2 produces Clean with C14 semantics.
133: 
134: Initialization before sampling: Forward state, D3=0, D4=Idle, pending dust=FALSE. No Movement Command, Direction or Clean is emitted on initialization (C13). The first Tick may issue Stop if its front sample is blocked.
135: 
136: ## Open Issues Affecting Level 3 and Level 4
137: 
138: | ID | Affects | Status |
139: |---|---|---|
140: | Q1 → C5 | 3.2.2 | Resolved: turn right after backing; back again if left and right are still blocked. |
141: | Q2 → C6 | 3.2.2, 3.2.4 | Resolved: backward lasts 5 ticks. |
142: | Q3 → C7 | 3.2.2, 3.2.4 | Resolved: stop lasts 5 ticks. |
143: | C5 edge | 3.2.2 | Resolved: after backing, Left Open turns left (C5 updated). |
144: | C8 | 3.2.2, 3.2.4 | Resolved: a turn lasts 5 ticks. |
145: | Q4 → C10, Q5 → C11 | 4.1 | Resolved: dust during a power-up restarts the 5 ticks; the remaining count is kept while avoiding. |
146: | C9 | 3.1, 3.2.2 | Resolved: Obstacle Situation carries Front Blocked and Side Situation; after backing the sides decide. |
147: | C16 (resolves Q6) | 3.1, 3.2.2 | Confirmed by the project owner: only while Forward, side obstacles alone do not initiate avoidance when the front is clear. Side classification is always provided (C9). |
148: 
149: C12-C15 are the 2026-11-17 Phase 1 decisions: initial sampling, initialization without output, suction-only power-up, and remembered avoidance dust. They do not add states to the Movement Controller; D2/4.1 handle the remembered detection.

## artifacts/SA/DFD/dfd_level_4_fsm.md

1: # DFD Level 4: Movement Controller FSM
2: 
3: System: RVC Controller
4: Controller: Process 3.2.2 Movement Controller, `artifacts/SA/DFD/dfd_level_3.md`
5: Sources: `docs/preliminary_requirements.md` (B1-B7), `docs/requirements_clarifications.md` (C1-C16)
6: 
7: ## Controller Inputs and Outputs
8: 
9: | Item | Kind | Source / Destination | Values |
10: |---|---|---|---|
11: | Tick | Event | Digital Clock | — |
12: | Situation Signal | Condition | 3.2.1 | Front Blocked (yes or no) and Side Situation (Right Open, Left Open, Sides Blocked) |
13: | Step Done | Condition | 3.2.4 | Present when the current stop, backward, or turn step has lasted 5 ticks |
14: | Movement Command | Action | 3.2.3 | Forward, Stop, Turn Right, Turn Left, Backward |
15: | Start Step Timer | Action | 3.2.4 | — |
16: 
17: Abbreviations in labels: `FrontBlocked` is the front part of the Situation Signal; `RightOpen`, `LeftOpen`, `SidesBlocked` are its Side Situation; `Done` is Step Done; `StartTimer` is Start Step Timer.
18: 
19: Revised 2026-11-16 for C9: the conditions of T1 and T2 use the front only, and the conditions of T4-T6 and T8-T10 use the sides only.
20: 
21: ## FSM
22: 
23: ```mermaid
24: stateDiagram-v2
25:     [*] --> Forward : Initialize state only (C13)
26: 
27:     Forward --> Forward : Tick [not FrontBlocked] / Forward
28:     Forward --> Stopping : Tick [FrontBlocked] / Stop, StartTimer
29: 
30:     Stopping --> Stopping : Tick [not Done] / Stop
31:     Stopping --> TurningRight : Tick [Done and RightOpen] / Turn Right, StartTimer
32:     Stopping --> TurningLeft : Tick [Done and LeftOpen] / Turn Left, StartTimer
33:     Stopping --> Backing : Tick [Done and SidesBlocked] / Backward, StartTimer
34: 
35:     Backing --> Backing : Tick [not Done] / Backward
36:     Backing --> Backing : Tick [Done and SidesBlocked] / Backward, StartTimer
37:     Backing --> TurningRight : Tick [Done and RightOpen] / Turn Right, StartTimer
38:     Backing --> TurningLeft : Tick [Done and LeftOpen] / Turn Left, StartTimer
39: 
40:     TurningRight --> TurningRight : Tick [not Done] / Turn Right
41:     TurningRight --> Forward : Tick [Done] / Forward
42: 
43:     TurningLeft --> TurningLeft : Tick [not Done] / Turn Left
44:     TurningLeft --> Forward : Tick [Done] / Forward
45: ```
46: 
47: ## States
48: 
49: | State | Meaning | Movement Command while in state | Movement Status (via 3.2.3) |
50: |---|---|---|---|
51: | Forward | Initial control state; after a Tick selects Forward, suction cleaning and mopping run. No output at initialization (C13). | Forward on a Tick | Forward |
52: | Stopping | Stopped in front of an obstacle for 5 ticks. | Stop | Avoiding |
53: | Backing | Moving backward for 5 ticks after a blocked stop or repeated because both sides remain blocked (C5, C9); the front may be clear after backing. | Backward | Avoiding |
54: | TurningRight | Turning right for 5 ticks. | Turn Right | Avoiding |
55: | TurningLeft | Turning left for 5 ticks. | Turn Left | Avoiding |
56: 
57: Turning is split into two states because the Controller must keep issuing the same turn direction for 5 ticks.
58: 
59: ## Transition Table
60: 
61: | # | Current State | Event | Condition | Action | Next State | Source |
62: |---|---|---|---|---|---|---|
63: | T0 | [*] | Internal initialization | Before first Tick | Set state only; no Movement Command or Start Step Timer | Forward | C13 |
64: | T1 | Forward | Tick | not Front Blocked | Forward | Forward | B2, C16 |
65: | T2 | Forward | Tick | Front Blocked | Stop, Start Step Timer | Stopping | B3, C2, C7, C16 |
66: | T3 | Stopping | Tick | not Step Done | Stop | Stopping | C7 |
67: | T4 | Stopping | Tick | Step Done and Right Open | Turn Right, Start Step Timer | TurningRight | B3, C1, C8 |
68: | T5 | Stopping | Tick | Step Done and Left Open | Turn Left, Start Step Timer | TurningLeft | B3, C8 |
69: | T6 | Stopping | Tick | Step Done and Sides Blocked | Backward, Start Step Timer | Backing | B4, C6 |
70: | T7 | Backing | Tick | not Step Done | Backward | Backing | C6 |
71: | T8 | Backing | Tick | Step Done and Sides Blocked | Backward, Start Step Timer | Backing | C5, C6, C9 |
72: | T9 | Backing | Tick | Step Done and Right Open | Turn Right, Start Step Timer | TurningRight | C5, C8, C9 |
73: | T10 | Backing | Tick | Step Done and Left Open | Turn Left, Start Step Timer | TurningLeft | C5, C8, C9 |
74: | T11 | TurningRight | Tick | not Step Done | Turn Right | TurningRight | C8 |
75: | T12 | TurningRight | Tick | Step Done | Forward | Forward | B3, B4, C8 |
76: | T13 | TurningLeft | Tick | not Step Done | Turn Left | TurningLeft | C8 |
77: | T14 | TurningLeft | Tick | Step Done | Forward | Forward | B3, B4, C8 |
78: 
79: ## Timing Example
80: 
81: Obstacle ahead with the right clear, first detected at tick t:
82: 
83: | Tick | State before | Condition | Command | State after |
84: |---|---|---|---|---|
85: | t | Forward | FrontBlocked | Stop (timer starts) | Stopping |
86: | t+1 to t+4 | Stopping | not Done | Stop | Stopping |
87: | t+5 | Stopping | Done, RightOpen | Turn Right (timer starts) | TurningRight |
88: | t+6 to t+9 | TurningRight | not Done | Turn Right | TurningRight |
89: | t+10 | TurningRight | Done | Forward | Forward |
90: 
91: Stop covers ticks t to t+4 and the turn covers t+5 to t+9, 5 ticks each (C7, C8). Backing works the same way: 5 Backward ticks, then the decision on the next tick (C6).
92: 
93: ## Validation
94: 
95: | Check | Result |
96: |---|---|
97: | All states defined | Yes: Forward, Stopping, Backing, TurningRight, TurningLeft. |
98: | Initial state | Forward, without output. T0 is initialization, not an external input event (C13). |
99: | Valid source and target for every transition | Yes: T0-T14. |
100: | Input events from DFD | Tick (Digital Clock), Situation Signal (3.2.1), Step Done (3.2.4), all in Level 3. |
101: | Output actions match Controller outputs | T1-T14 issue Movement Command and optionally Start Step Timer, both Level 3 outputs. T0 emits neither. |
102: | Conflicting conditions | None. Forward splits on Front Blocked. Stopping and Backing split first on Step Done, then on the Side Situation (Right Open, Left Open, Sides Blocked are mutually exclusive). Turning states split on Step Done only. |
103: | Priority | Step Done is checked first. The Side Situation matters only on the tick Step Done is present. Right Open takes priority over Left Open by its definition in 3.1 (C1). |
104: | Missing conditions | None. In every state the conditions cover all inputs. In Stopping the front is still blocked (C4), so Sides Blocked there means front, left, and right are blocked (B4). In Backing the front is not consulted (C9). |
105: | Unreachable states | None. Stopping via T2; Backing via T6; TurningRight via T4, T9; TurningLeft via T5, T10. |
106: | States without an outgoing transition | None. |
107: | Cycle check | Backing can repeat (T8) while both sides stay blocked, regardless of the front (C5, C9). The requirements set no limit on repeats. |
108: 
109: ## Notes
110: 
111: - C16 resolves Q6: while Forward with a clear front, side obstacles alone do not initiate avoidance; forward movement and cleaning continue. T1/T2 are unchanged. C9 still applies after Backing.
112: 
113: - The Situation Signal is ignored during a turn. By C4 the obstacles do not move, and the requirements do not describe interrupting a turn.
114: - Q4 and Q5 are resolved by C10/C11. C15 uses Process 2, D2 and 4.1 to retain dust; it does not add movement states.
115: - C12 requires all four initial sensor samples before the first Tick. C13 initializes Forward without emitting Direction or Clean. On the first Tick T1 or T2 uses the front reading; an obstacle can cause Stop immediately. C14 defines Clean output in Process 4.2.
116: - The FSM has no Process Specification, per AGENTS.md. Process 3.2.2's specification refers to it.

## artifacts/SD/structure_chart.md

1: # Structure Chart
2: 
3: System: RVC Controller
4: Sources: `artifacts/SD/transform_analysis.md`, `artifacts/SA/DFD/dfd_level_0.md` to `dfd_level_3.md`, `artifacts/SA/DFD/dfd_level_4_fsm.md`, `artifacts/SA/process_specification.md`, `artifacts/SA/data_dictionary.md`, `artifacts/SA/context_diagram.md`, `artifacts/SA/event_list.md`
5: Requirement references: B1-B7 (`docs/preliminary_requirements.md`), C1-C8 and Q4-Q6 (`docs/requirements_clarifications.md`)
6: 
7: ## 1. Objective
8: 
9: Represent the hierarchical software module structure of the RVC Controller, derived from the Transform Analysis and the approved SA artifacts. Each module is one intended C function. Each arrow is one intended function call.
10: 
11: ## 2. Notation
12: 
13: | Element | Representation in this document |
14: |---|---|
15: | Module | Rectangle `[ ]` |
16: | Library module | Subroutine `[[ ]]`. Here: the hardware interface, whose internals are outside the design (B6). |
17: | Module call | Solid arrow from caller to callee. A number on the arrow is the call order within the caller. |
18: | Data information | Dotted arrow labeled `data:`, drawn in the direction the data moves. |
19: | Control information | Dashed arrow labeled `ctrl:`, drawn in the direction the information moves. |
20: | Conditional call | Diamond `{ }` between caller and callee. |
21: | Repeated call | `every cycle` on the arrow. |
22: 
23: Mermaid draws dotted and dashed lines almost alike. The `data:` and `ctrl:` prefixes are the reliable distinction. An item is `ctrl:` when the Data Dictionary classifies it as a control flow.
24: 
25: ## 3. Module Hierarchy
26: 
27: ### 3.1 Call hierarchy
28: 
29: ```mermaid
30: flowchart TB
31:     Main["Main"]
32:     Init["Initialize RVC"]
33:     WaitTick[["Wait For Tick"]]
34:     Ctrl["Controller"]
35: 
36:     ResetMC["Reset Movement Controller"]
37:     ResetST["Reset Step Timer"]
38:     ResetPU["Reset Power-Up Timer"]
39: 
40:     GetIn["Get Inputs"]
41:     Decide["Decide Actions"]
42:     PutOut["Put Outputs"]
43: 
44:     DetObs["Detect Obstacle"]
45:     Assess["Assess Obstacle Situation"]
46:     DetDust["Detect Dust"]
47:     RdF[["Read Front Sensor"]]
48:     RdL[["Read Left Sensor"]]
49:     RdR[["Read Right Sensor"]]
50:     RdD[["Read Dust Sensor"]]
51: 
52:     MC["Movement Controller"]
53:     AdvST["Advance Step Timer"]
54:     StepQ{"step begins?"}
55:     StartST["Start Step Timer"]
56:     Status["Derive Movement Status"]
57:     TrackPU["Track Power-Up"]
58:     DecClean["Decide Cleaning"]
59: 
60:     IssueMove["Issue Movement Output"]
61:     DrvMotor[["Drive Motor"]]
62:     DrvCleaner[["Drive Cleaner"]]
63: 
64:     Main -->|"1 (once)"| Init
65:     Main -->|"2 (every cycle)"| WaitTick
66:     Main -->|"3 (every cycle)"| Ctrl
67: 
68:     Init -->|"1"| ResetMC
69:     ResetMC --> ResetST
70:     Init -->|"2"| ResetPU
71:     Init -->|"3"| IssueMove
72: 
73:     Ctrl -->|"1"| GetIn
74:     Ctrl -->|"2"| Decide
75:     Ctrl -->|"3"| PutOut
76: 
77:     GetIn -->|"1"| DetObs
78:     GetIn -->|"2"| Assess
79:     GetIn -->|"3"| DetDust
80:     DetObs --> RdF
81:     DetObs --> RdL
82:     DetObs --> RdR
83:     DetDust --> RdD
84: 
85:     Decide -->|"1"| MC
86:     Decide -->|"2"| Status
87:     Decide -->|"3"| TrackPU
88:     Decide -->|"4"| DecClean
89:     MC -->|"1"| AdvST
90:     MC -->|"2"| StepQ
91:     StepQ -->|"yes"| StartST
92: 
93:     PutOut -->|"1"| IssueMove
94:     PutOut -->|"2"| DrvCleaner
95:     IssueMove --> DrvMotor
96: ```
97: 
98: - **Repetition:** `Main` calls `Initialize RVC` once. It then repeats `Wait For Tick` followed by `Controller` for as long as the system runs. The requirements define no shutdown event.
99: - **Condition:** `Movement Controller` calls `Start Step Timer` only on a transition that begins a 5-tick step (stop, backward, or turn).
100: - **Shared module:** `Issue Movement Output` is called by `Initialize RVC` and by `Put Outputs`.
101: - All other calls are made on every cycle, in the numbered order.
102: 
103: ### 3.2 Top level and initialization, with exchanged information
104: 
105: ```mermaid
106: %%{init: {"flowchart": {"nodeSpacing": 150, "rankSpacing": 110}}}%%
107: flowchart TB
108:     Main["Main"]
109:     Init["Initialize RVC"]
110:     WaitTick[["Wait For Tick"]]
111:     Ctrl["Controller"]
112:     ResetMC["Reset Movement Controller"]
113:     ResetST["Reset Step Timer"]
114:     ResetPU["Reset Power-Up Timer"]
115:     IssueMove["Issue Movement Output"]
116: 
117:     Main --> Init
118:     Main --> WaitTick
119:     Main --> Ctrl
120:     Init --> ResetMC
121:     ResetMC --> ResetST
122:     Init --> ResetPU
123:     Init --> IssueMove
124: 
125:     WaitTick -.->|"ctrl: Tick"| Main
126:     ResetMC -.->|"ctrl: Movement Command"| Init
127:     Init -.->|"ctrl: Movement Command"| IssueMove
128: 
129:     linkStyle 7,8,9 stroke-dasharray: 9 5
130: ```
131: 
132: `Main` passes nothing to `Initialize RVC` or `Controller` and receives nothing from them.
133: 
134: ### 3.3 Control cycle, with exchanged information
135: 
136: ```mermaid
137: %%{init: {"flowchart": {"nodeSpacing": 90, "rankSpacing": 260}}}%%
138: flowchart LR
139:     Ctrl["Controller"]
140:     GetIn["Get Inputs"]
141:     Decide["Decide Actions"]
142:     PutOut["Put Outputs"]
143: 
144:     Ctrl --> GetIn
145:     Ctrl --> Decide
146:     Ctrl --> PutOut
147: 
148:     GetIn -.->|"data: Obstacle Situation, Dust Existence"| Ctrl
149:     Ctrl -.->|"data: Obstacle Situation, Dust Existence"| Decide
150:     Decide -.->|"data: Clean"| Ctrl
151:     Ctrl -.->|"data: Clean"| PutOut
152: 
153:     Decide -.->|"ctrl: Movement Command"| Ctrl
154:     Ctrl -.->|"ctrl: Movement Command"| PutOut
155: 
156:     linkStyle 7,8 stroke-dasharray: 9 5
157: ```
158: 
159: This one diagram is drawn left to right, with the caller on the left, so that its labels do not overlap.
160: 
161: ### 3.4 Input branch (afferent)
162: 
163: ```mermaid
164: %%{init: {"flowchart": {"nodeSpacing": 150, "rankSpacing": 110}}}%%
165: flowchart TB
166:     GetIn["Get Inputs"]
167:     DetObs["Detect Obstacle"]
168:     Assess["Assess Obstacle Situation"]
169:     DetDust["Detect Dust"]
170:     RdF[["Read Front Sensor"]]
171:     RdL[["Read Left Sensor"]]
172:     RdR[["Read Right Sensor"]]
173:     RdD[["Read Dust Sensor"]]
174: 
175:     GetIn --> DetObs
176:     GetIn --> Assess
177:     GetIn --> DetDust
178:     DetObs --> RdF
179:     DetObs --> RdL
180:     DetObs --> RdR
181:     DetDust --> RdD
182: 
183:     RdF -.->|"data: Front Sensor Input"| DetObs
184:     RdL -.->|"data: Left Sensor Input"| DetObs
185:     RdR -.->|"data: Right Sensor Input"| DetObs
186:     DetObs -.->|"data: Obstacle Location"| GetIn
187:     GetIn -.->|"data: Obstacle Location"| Assess
188:     Assess -.->|"data: Obstacle Situation"| GetIn
189:     RdD -.->|"data: Dust Sensor Input"| DetDust
190:     DetDust -.->|"data: Dust Existence"| GetIn
191: ```
192: 
193: ### 3.5 Processing branch (central)
194: 
195: ```mermaid
196: %%{init: {"flowchart": {"nodeSpacing": 150, "rankSpacing": 110}}}%%
197: flowchart TB
198:     Decide["Decide Actions"]
199:     MC["Movement Controller"]
200:     AdvST["Advance Step Timer"]
201:     StepQ{"step begins?"}
202:     StartST["Start Step Timer"]
203:     Status["Derive Movement Status"]
204:     TrackPU["Track Power-Up"]
205:     DecClean["Decide Cleaning"]
206: 
207:     Decide --> MC
208:     Decide --> Status
209:     Decide --> TrackPU
210:     Decide --> DecClean
211:     MC --> AdvST
212:     MC --> StepQ
213:     StepQ -->|"yes"| StartST
214: 
215:     Status -.->|"data: Movement Status"| Decide
216:     Decide -.->|"data: Movement Status, Dust Existence"| TrackPU
217:     TrackPU -.->|"data: Power-Up Active"| Decide
218:     Decide -.->|"data: Movement Status, Power-Up Active"| DecClean
219:     DecClean -.->|"data: Clean"| Decide
220: 
221:     Decide -.->|"ctrl: Situation Signal"| MC
222:     MC -.->|"ctrl: Movement Command"| Decide
223:     AdvST -.->|"ctrl: Step Done"| MC
224:     Decide -.->|"ctrl: Movement Command"| Status
225: 
226:     linkStyle 12,13,14,15 stroke-dasharray: 9 5
227: ```
228: 
229: ### 3.6 Output branch (efferent)
230: 
231: ```mermaid
232: flowchart TB
233:     PutOut["Put Outputs"]
234:     IssueMove["Issue Movement Output"]
235:     DrvMotor[["Drive Motor"]]
236:     DrvCleaner[["Drive Cleaner"]]
237: 
238:     PutOut --> IssueMove
239:     PutOut --> DrvCleaner
240:     IssueMove --> DrvMotor
241: 
242:     IssueMove -.->|"data: Direction"| DrvMotor
243:     PutOut -.->|"data: Clean"| DrvCleaner
244: 
245:     PutOut -.->|"ctrl: Movement Command"| IssueMove
246: 
247:     linkStyle 5 stroke-dasharray: 9 5
248: ```
249: 
250: ## 4. Module Descriptions
251: 
252: ### 4.1 Modules
253: 
254: | Module | Region | Responsibility | Called Modules |
255: |---|---|---|---|
256: | Main | Root | Initializes the system once, then runs one control cycle for every Tick. Corresponds to the C `main()` function. | Initialize RVC, Wait For Tick, Controller |
257: | Initialize RVC | Root | Puts the system into its power-on condition (FSM transition T0): resets the hidden data and issues the initial Forward command. | Reset Movement Controller, Reset Power-Up Timer, Issue Movement Output |
258: | Controller | Root | Runs one control cycle: obtains the inputs, decides the actions, delivers the outputs. Coordinates Process 0 for one Tick. | Get Inputs, Decide Actions, Put Outputs |
259: | Get Inputs | Afferent | Obtains the two inputs the decisions need: Obstacle Situation and Dust Existence. | Detect Obstacle, Assess Obstacle Situation, Detect Dust |
260: | Detect Obstacle | Afferent | Reads the three obstacle sensors and returns them as one Obstacle Location. | Read Front Sensor, Read Left Sensor, Read Right Sensor |
261: | Assess Obstacle Situation | Afferent | Classifies an Obstacle Location: whether the front is blocked, and whether the right is open, only the left is open, or both sides are blocked (C1, C9). | — |
262: | Detect Dust | Afferent | Reads the dust sensor and returns Dust Existence. | Read Dust Sensor |
263: | Decide Actions | Central | Decides the Movement Command and the Clean command for this cycle. | Movement Controller, Derive Movement Status, Track Power-Up, Decide Cleaning |
264: | Movement Controller | Central | Takes one FSM transition (T1-T14) for this Tick and returns the Movement Command. Keeps the controller state. | Advance Step Timer, Start Step Timer |
265: | Reset Movement Controller | Central | Sets the controller state to Forward and returns the initial Movement Command, Forward (T0). | Reset Step Timer |
266: | Advance Step Timer | Central | Counts one tick of the running step and reports Step Done when 5 ticks have elapsed. Does nothing when no step is running. | — |
267: | Start Step Timer | Central | Begins counting a new 5-tick step. | — |
268: | Reset Step Timer | Central | Sets the step timer to Idle. | — |
269: | Derive Movement Status | Central | Returns Forward when the Movement Command is Forward, otherwise Avoiding. | — |
270: | Track Power-Up | Central | Starts and counts down the 5-tick power-up and reports whether it applies on this tick. Keeps the remaining count. | — |
271: | Reset Power-Up Timer | Central | Sets the remaining power-up count to 0. | — |
272: | Decide Cleaning | Central | Chooses Clean: Stop while avoiding, Power Up while power-up is active, otherwise Start. | — |
273: | Put Outputs | Efferent | Delivers the two decided commands to the Motor and the Cleaner. | Issue Movement Output, Drive Cleaner |
274: | Issue Movement Output | Efferent | Converts a Movement Command into the Direction value and sends it to the Motor. | Drive Motor |
275: 
276: ### 4.2 Library modules (hardware interface)
277: 
278: Each stands for one terminator of the Context Diagram. Their internals are outside this design (B6). Unit tests and the simulator supply their own versions.
279: 
280: | Library Module | Terminator | Event (Event List) | Returns / Accepts |
281: |---|---|---|---|
282: | Read Front Sensor | Front Sensor | Front Sensor Input | Returns Boolean |
283: | Read Left Sensor | Left Sensor | Left Sensor Input | Returns Boolean |
284: | Read Right Sensor | Right Sensor | Right Sensor Input | Returns Boolean |
285: | Read Dust Sensor | Dust Sensor | Dust Sensor Input | Returns Boolean |
286: | Wait For Tick | Digital Clock | Tick | Returns when the next Tick occurs |
287: | Drive Motor | Motor | Direction | Accepts Forward, Backward, Turn Left, Turn Right, or Stop |
288: | Drive Cleaner | Cleaner | Clean | Accepts Start, Stop, or Power Up |
289: 
290: ### 4.3 Hidden data
291: 
292: Data that must persist between cycles is hidden inside the group of modules that uses it. No other module can read or write it.
293: 
294: | Group | Modules | Hidden data | SA origin |
295: |---|---|---|---|
296: | Movement Controller | Movement Controller, Reset Movement Controller | Controller state: Forward, Stopping, Backing, Turning Right, Turning Left | States of the Level 4 FSM |
297: | Step Timer | Advance Step Timer, Start Step Timer, Reset Step Timer | Step Ticks Elapsed: Idle or 0-5 | Data Store D4 |
298: | Power-Up Timer | Track Power-Up, Reset Power-Up Timer | Remaining Power-Up Ticks: 0-5 | Data Store D3 |
299: 
300: ## 5. Module Interfaces
301: 
302: "Input Data" is passed from caller to callee. "Output Data" is returned to the caller. In the last column, ↓ means passed to the callee and ↑ means returned to the caller.
303: 
304: | Caller | Callee | Input Data | Output Data | Control Information |
305: |---|---|---|---|---|
306: | Main | Initialize RVC | — | — | — |
307: | Main | Wait For Tick | — | — | ↑ Tick |
308: | Main | Controller | — | — | — |
309: | Initialize RVC | Reset Movement Controller | — | — | ↑ Movement Command (Forward) |
310: | Reset Movement Controller | Reset Step Timer | — | — | — |
311: | Initialize RVC | Reset Power-Up Timer | — | — | — |
312: | Initialize RVC | Issue Movement Output | — | — | ↓ Movement Command |
313: | Controller | Get Inputs | — | Obstacle Situation, Dust Existence | — |
314: | Controller | Decide Actions | Obstacle Situation, Dust Existence | Clean | ↑ Movement Command |
315: | Controller | Put Outputs | Clean | — | ↓ Movement Command |
316: | Get Inputs | Detect Obstacle | — | Obstacle Location | — |
317: | Get Inputs | Assess Obstacle Situation | Obstacle Location | Obstacle Situation | — |
318: | Get Inputs | Detect Dust | — | Dust Existence | — |
319: | Detect Obstacle | Read Front Sensor | — | Front Sensor Input | — |
320: | Detect Obstacle | Read Left Sensor | — | Left Sensor Input | — |
321: | Detect Obstacle | Read Right Sensor | — | Right Sensor Input | — |
322: | Detect Dust | Read Dust Sensor | — | Dust Sensor Input | — |
323: | Decide Actions | Movement Controller | — | — | ↓ Situation Signal, ↑ Movement Command |
324: | Movement Controller | Advance Step Timer | — | — | ↑ Step Done |
325: | Movement Controller | Start Step Timer | — | — | — (conditional call) |
326: | Decide Actions | Derive Movement Status | — | Movement Status | ↓ Movement Command |
327: | Decide Actions | Track Power-Up | Movement Status, Dust Existence | Power-Up Active | — |
328: | Decide Actions | Decide Cleaning | Movement Status, Power-Up Active | Clean | — |
329: | Put Outputs | Issue Movement Output | — | — | ↓ Movement Command |
330: | Put Outputs | Drive Cleaner | Clean | — | — |
331: | Issue Movement Output | Drive Motor | Direction | — | — |
332: 
333: Types and values of every item are those of the Data Dictionary. `Decide Actions` passes the Obstacle Situation it received to `Movement Controller` as the Situation Signal; the value is the same.
334: 
335: ## 6. SA-to-SD Traceability
336: 
337: ### 6.1 Processes
338: 
339: | SA Process ID | SA Process Name | SD Module | Design Rationale |
340: |---|---|---|---|
341: | 0 | RVC Controller | Main, Initialize RVC, Controller | Main supplies the Tick loop. Controller performs Process 0 once per Tick. |
342: | 1 | Detect Obstacle | Detect Obstacle | One to one. |
343: | 2 | Detect Dust | Detect Dust | One to one. |
344: | 3 | Control Movement | Modules of 3.1 and 3.2 | Parent process; realized by its children. |
345: | 3.1 | Assess Obstacle Situation | Assess Obstacle Situation | One to one. |
346: | 3.2 | Decide Movement | Modules of 3.2.1 to 3.2.4 | Parent process; realized by its children. |
347: | 3.2.1 | Signal Obstacle Situation | Decide Actions (parameter passing) | 3.2.1 only hands a value on as a signal. A module for it would have no body, so the hand-over is the call `Decide Actions → Movement Controller`. |
348: | 3.2.2 | Movement Controller | Movement Controller, Reset Movement Controller | Movement Controller takes T1-T14. Reset Movement Controller takes T0. |
349: | 3.2.3 | Issue Movement Output | Derive Movement Status, Issue Movement Output | Split along the transform boundary: Movement Status feeds the decisions (central), Direction goes to the Motor (efferent). Each module now has one function. |
350: | 3.2.4 | Time Movement Step | Advance Step Timer, Start Step Timer, Reset Step Timer | One module per trigger of 3.2.4 (Tick, Start Step Timer) plus its initial value. They share D4 as hidden data. |
351: | 4 | Control Cleaning | Modules of 4.1 and 4.2 | Parent process; realized by its children. |
352: | 4.1 | Track Power-Up | Track Power-Up, Reset Power-Up Timer | Track Power-Up is the process. Reset Power-Up Timer gives D3 its initial value. |
353: | 4.2 | Decide Cleaning | Decide Cleaning | One to one. |
354: 
355: Modules with no SA process of their own:
356: 
357: | SD Module | Origin |
358: |---|---|
359: | Get Inputs, Decide Actions, Put Outputs | The three regions of the Transform Analysis. They only coordinate their branch. |
360: | Initialize RVC | FSM transition T0 (Power On) and the initial values of D3 and D4. |
361: | Library modules | Terminators of the Context Diagram. |
362: 
363: ### 6.2 Control flows and Data Stores
364: 
365: DFD flows are not copied as calls. This table shows what each control flow and Data Store became.
366: 
367: | SA item | SA kind | Realized in the design as |
368: |---|---|---|
369: | Tick | Control flow | The return of `Wait For Tick`, after which `Main` calls `Controller` once. It is not passed as a parameter. |
370: | Situation Signal | Control flow | Parameter of `Movement Controller`. |
371: | Step Done | Control flow | Return value of `Advance Step Timer`. |
372: | Start Step Timer | Control flow | The call `Movement Controller → Start Step Timer` itself. |
373: | Movement Command | Control flow | Return value of `Movement Controller`; parameter of `Derive Movement Status` and `Issue Movement Output`. |
374: | D1 Obstacle Location | Data Store | Return value of `Detect Obstacle`, passed to `Assess Obstacle Situation` in the same cycle. Not kept between cycles. |
375: | D2 Dust Existence | Data Store | Return value of `Detect Dust`, passed on to `Track Power-Up` in the same cycle. Not kept between cycles. |
376: | D3 Power-Up Timer | Data Store | Hidden data of the Power-Up Timer group. |
377: | D4 Step Timer | Data Store | Hidden data of the Step Timer group. |
378: | Controller state | FSM states | Hidden data of the Movement Controller group. |
379: 
380: All other data flows are the parameters and return values listed in section 5.
381: 
382: ### 6.3 Controller FSM
383: 
384: | FSM element | Design element |
385: |---|---|
386: | T0 (Power On / Forward) | `Reset Movement Controller` sets the state and returns Forward. `Initialize RVC` passes it to `Issue Movement Output`. |
387: | T1-T14 (Tick) | One call of `Movement Controller` takes exactly one of these transitions. |
388: | Condition: Situation Signal | Parameter of `Movement Controller`. |
389: | Condition: Step Done | Obtained from `Advance Step Timer` at the start of every call, before the transition is chosen. |
390: | Action: Movement Command | Return value of `Movement Controller`. |
391: | Action: Start Step Timer | Call of `Start Step Timer` on T2, T4, T5, T6, T8, T9, T10 only. |
392: 
393: ## 7. Design Decisions Needing Approval
394: 
395: These go beyond what the SA artifacts state. Each is a design choice, not a requirement.
396: 
397: | # | Decision | Reason |
398: |---|---|---|
399: | 1 | The sensors are read once per cycle, at its start. D1 and D2 therefore need no storage between cycles. | In the SA, Processes 1 and 2 run "when the sensor input is received", and the stores hold the latest reading for the next Tick. Reading at each Tick gives the same latest reading. How sensor hardware delivers its input is out of scope (B6). |
400: | 2 | Seven library modules represent the hardware. | A C program needs a function to call for each external event. The Context Diagram defines exactly these seven events. |
401: | 3 | The initial power-up count is 0. | The Data Dictionary defines 0 as "no power-up in progress", but no SA artifact states an initial value for D3. D4's initial value (Idle) is stated in Process Specification 3.2.4. |
402: | 4 | Read-only queries of the hidden data (controller state, Step Ticks Elapsed, Remaining Power-Up Ticks) may be added for unit tests and the simulator. | The simulator must display these values at every tick. No production module calls such queries, so they are not in the chart. |
403: 
404: One consequence of the approved SA is kept as it is: at power on, only Direction = Forward is issued (T0). Clean is first issued on the first Tick, because Processes 4.1 and 4.2 run on Tick.
405: 
406: ## 8. Design Validation
407: 
408: | Check | Result |
409: |---|---|
410: | Every SA function is implemented by at least one module | Yes. All 9 leaf processes are mapped in 6.1; 3.2.1 is realized by parameter passing. |
411: | Every module has a clear responsibility | Yes. See 4.1. |
412: | Module calls represent actual invocation | Yes. Every arrow is a function call. DFD control flows that are not calls are listed in 6.2. |
413: | Data and control information are distinguishable | Yes. Labeled `data:` and `ctrl:` in 3.2-3.6 and separated in section 5. |
414: | Module interfaces are consistent | Yes. Each item returned by one module is passed unchanged to the module that uses it; names match the Data Dictionary. |
415: | Consistent with Process Specifications | Yes. Each module's logic is its process's specification. The order within a cycle follows "Execution Order Within One Tick" of DFD Level 3, with one difference: Direction is delivered at the end of the cycle, together with Clean, not before Process 4.1 runs. Both are still delivered within the same Tick. |
416: | Controller calls are consistent with the FSM | Yes. See 6.3. |
417: | Coupling | Modules exchange only parameters and return values. There is no global data. Persistent data is confined to the three groups in 4.3. Obstacle Location is passed as one record, and its receiver uses all three fields. |
418: | Cohesion | Leaf modules each perform one function. Controller, Get Inputs, Decide Actions, and Put Outputs only sequence their callees. Initialize RVC groups actions by time (power on), which is usual for initialization. |
419: | Fan-out and fan-in | Largest fan-out is 4 (Decide Actions). Issue Movement Output has fan-in 2. |
420: | No unsupported modules or behavior | The additions are the coordinating modules, the reset modules, and the library modules. Their origins are in 6.1; the choices behind them are in section 7. |
421: 
422: ### Decisions made after approval (2026-11-16)
423: 
424: C9, C10, and C11 changed the inside of three modules. No module, call, or interface name changed.
425: 
426: | ID | Affects | Effect on the design |
427: |---|---|---|
428: | C9 | Assess Obstacle Situation, Movement Controller | Obstacle Situation (and so the Situation Signal) is now a record: Front Blocked plus Side Situation. After a backward step the Controller decides by the sides only. |
429: | C10 | Track Power-Up | Dust during a running power-up restarts the 5 ticks. |
430: | C11 | Track Power-Up | The remaining count is kept while avoiding. Confirms what the module already did. |
431: | Q6 | Movement Controller | Assumption kept: while going forward only Front Blocked is used. |
432: 
433: The open issues listed at approval time (Q4, Q5) are resolved by C10 and C11. Q6 remains an assumption.

## artifacts/SD/transform_analysis.md

1: # Transform Analysis
2: 
3: System: RVC Controller
4: Sources: `artifacts/SA/DFD/dfd_level_0.md` to `dfd_level_3.md`, `artifacts/SA/DFD/dfd_level_4_fsm.md`, `artifacts/SA/process_specification.md`, `artifacts/SA/data_dictionary.md`, `artifacts/SA/context_diagram.md`, `artifacts/SA/event_list.md`
5: Requirement references: B1-B7 (`docs/preliminary_requirements.md`), C1-C8 and Q4-Q6 (`docs/requirements_clarifications.md`)
6: 
7: ## 1. Objective
8: 
9: Identify the Afferent Flow, Central Transformation, and Efferent Flow of the RVC Controller from the approved DFD hierarchy, as the basis for the Structure Chart (`artifacts/SD/structure_chart.md`).
10: 
11: The analysis uses the leaf processes of the hierarchy. Processes 0, 3, 3.2, and 4 are parents and are represented by their children:
12: 
13: | Parent | Leaf processes |
14: |---|---|
15: | 0 RVC Controller | all of the below |
16: | 3 Control Movement | 3.1, 3.2.1, 3.2.2, 3.2.3, 3.2.4 |
17: | 3.2 Decide Movement | 3.2.1, 3.2.2, 3.2.3, 3.2.4 |
18: | 4 Control Cleaning | 4.1, 4.2 |
19: 
20: Processes 1 and 2 are leaves at Level 1.
21: 
22: ## 2. Transform Regions
23: 
24: ### Afferent Flow (Input)
25: 
26: Processes that receive the sensor inputs and raise them to the form the decision logic uses.
27: 
28: | Process ID | Process Name | Input | Output |
29: |---|---|---|---|
30: | 1 | Detect Obstacle | Front Sensor Input, Left Sensor Input, Right Sensor Input | Obstacle Location (to D1) |
31: | 3.1 | Assess Obstacle Situation | Obstacle Location (from D1), Tick | Obstacle Situation |
32: | 3.2.1 | Signal Obstacle Situation | Obstacle Situation | Situation Signal |
33: | 2 | Detect Dust | Dust Sensor Input | Dust Existence (to D2) |
34: 
35: Rationale:
36: - 1 and 2 only record what the sensors report.
37: - 3.1 turns the three raw readings into one Obstacle Situation. It describes the surroundings; it does not choose an action, so it is still input processing.
38: - 3.2.1 hands that description to the Controller as a signal without changing its value.
39: - Situation Signal and Dust Existence are the most abstract forms of the inputs. The next process to use each of them makes a decision.
40: 
41: ### Central Transformation (Process)
42: 
43: Processes that decide what the RVC does.
44: 
45: | Process ID | Process Name | Input | Output |
46: |---|---|---|---|
47: | 3.2.2 | Movement Controller | Tick, Situation Signal, Step Done | Movement Command, Start Step Timer |
48: | 3.2.4 | Time Movement Step | Tick, Start Step Timer, Step Ticks Elapsed (from D4) | Step Done, Step Ticks Elapsed (to D4) |
49: | 3.2.3 (part) | Issue Movement Output: Movement Status | Movement Command | Movement Status |
50: | 4.1 | Track Power-Up | Tick, Dust Existence (from D2), Movement Status, Remaining Power-Up Ticks (from D3) | Power-Up Active, Remaining Power-Up Ticks (to D3) |
51: | 4.2 | Decide Cleaning | Movement Status, Power-Up Active | Clean |
52: 
53: Rationale:
54: - 3.2.2 is the control process of the system (the Level 4 FSM). It chooses the movement.
55: - 3.2.4 works only for 3.2.2: it is started by the Controller and reports back to it. It is part of the control loop, not an input or an output path.
56: - 4.1 decides whether powered-up cleaning applies on this tick.
57: - 4.2 is where the Clean value is first formed. Before 4.2 there is no cleaning command, only Movement Status and Power-Up Active, so 4.2 belongs to the decision logic.
58: 
59: ### Efferent Flow (Output)
60: 
61: Processes that deliver a decision that has already been made.
62: 
63: | Process ID | Process Name | Input | Output |
64: |---|---|---|---|
65: | 3.2.3 (part) | Issue Movement Output: Direction | Movement Command | Direction |
66: 
67: Rationale:
68: - The movement decision already exists as Movement Command when it reaches 3.2.3. Turning it into Direction for the Motor changes its form, not its content.
69: - Clean has no efferent process. It flows from 4.2 directly to the Cleaner.
70: 
71: ### Process 3.2.3 lies on the boundary
72: 
73: 3.2.3 has two outputs with different roles, so it is listed in two regions:
74: 
75: | Output of 3.2.3 | Used by | Region |
76: |---|---|---|
77: | Direction | Motor (terminator) | Efferent |
78: | Movement Status | 4.1 and 4.2 (decision logic) | Central |
79: 
80: If 3.2.3 were placed whole in the efferent region, Movement Status would flow from the output side back into the decision logic. The Structure Chart therefore separates the two responsibilities into two modules.
81: 
82: ## 3. Transform Boundaries
83: 
84: - **Afferent-to-Central Boundary:** after 3.2.1 on the obstacle path, and after 2 (at D2) on the dust path.
85: - **Central-to-Efferent Boundary:** after 3.2.2 on the movement path, and after 4.2 on the cleaning path.
86: - **Boundary Data Flows:** Dust Existence (afferent → central), Clean (central → Cleaner).
87: - **Boundary Control Flows:** Situation Signal (afferent → central), Movement Command (central → efferent).
88: 
89: | Boundary flow | Category | From | To | Why the boundary is here |
90: |---|---|---|---|---|
91: | Situation Signal | Control | 3.2.1 | 3.2.2 | Last point where the obstacle input is only a description. 3.2.2 turns it into an action. |
92: | Dust Existence | Data | 2 (via D2) | 4.1 | The dust reading is used unchanged. 4.1 turns it into a power-up decision. |
93: | Movement Command | Control | 3.2.2 | 3.2.3 | First point where the movement output exists. After it, only the form changes. |
94: | Clean | Data | 4.2 | Cleaner | First point where the cleaning output exists. It needs no further processing. |
95: 
96: **Tick** is not transformed by any afferent process. It triggers 3.1, 3.2.2, 3.2.4, and 4.1 directly. In the design it becomes the trigger of one control cycle, not a value that is passed around.
97: 
98: ## 4. Transform Analysis Diagram
99: 
100: ```mermaid
101: flowchart LR
102:     FS["Front Sensor"]
103:     LS["Left Sensor"]
104:     RS["Right Sensor"]
105:     DSN["Dust Sensor"]
106:     CLK["Digital Clock"]
107:     MOT["Motor"]
108:     CLN["Cleaner"]
109: 
110:     subgraph A["Afferent Flow (Input)"]
111:         P1(("1 Detect Obstacle"))
112:         D1[["D1 Obstacle Location"]]
113:         P31(("3.1 Assess Obstacle Situation"))
114:         P321(("3.2.1 Signal Obstacle Situation"))
115:         P2(("2 Detect Dust"))
116:         D2[["D2 Dust Existence"]]
117:     end
118: 
119:     subgraph C["Central Transformation"]
120:         P322(("3.2.2 Movement Controller"))
121:         P324(("3.2.4 Time Movement Step"))
122:         D4[["D4 Step Timer"]]
123:         P323S(("3.2.3 Movement Status part"))
124:         P41(("4.1 Track Power-Up"))
125:         D3[["D3 Power-Up Timer"]]
126:         P42(("4.2 Decide Cleaning"))
127:     end
128: 
129:     subgraph E["Efferent Flow (Output)"]
130:         P323D(("3.2.3 Direction part"))
131:     end
132: 
133:     FS -->|"Front Sensor Input"| P1
134:     LS -->|"Left Sensor Input"| P1
135:     RS -->|"Right Sensor Input"| P1
136:     P1 -->|"Obstacle Location"| D1
137:     D1 -->|"Obstacle Location"| P31
138:     P31 -->|"Obstacle Situation"| P321
139:     DSN -->|"Dust Sensor Input"| P2
140:     P2 -->|"Dust Existence"| D2
141: 
142:     P321 -.->|"Situation Signal"| P322
143:     D2 -->|"Dust Existence"| P41
144: 
145:     CLK -.->|"Tick"| P31
146:     CLK -.->|"Tick"| P322
147:     CLK -.->|"Tick"| P324
148:     CLK -.->|"Tick"| P41
149: 
150:     P322 -.->|"Start Step Timer"| P324
151:     P324 -.->|"Step Done"| P322
152:     P324 -->|"Step Ticks Elapsed"| D4
153:     D4 -->|"Step Ticks Elapsed"| P324
154:     P322 -.->|"Movement Command"| P323S
155:     P323S -->|"Movement Status"| P41
156:     P323S -->|"Movement Status"| P42
157:     P41 -->|"Remaining Power-Up Ticks"| D3
158:     D3 -->|"Remaining Power-Up Ticks"| P41
159:     P41 -->|"Power-Up Active"| P42
160: 
161:     P322 -.->|"Movement Command"| P323D
162:     P323D -->|"Direction"| MOT
163:     P42 -->|"Clean"| CLN
164: 
165:     classDef control stroke-dasharray: 5 5
166:     class P322 control
167: ```
168: 
169: Solid arrows are data flows. Dashed arrows are control flows. `3.2.2` has a dashed border because it is the control process. All names are those of the DFDs; `3.2.3` appears twice, once for each of its outputs.
170: 
171: ## 5. Result
172: 
173: | Region | DFD processes | Role in the Structure Chart |
174: |---|---|---|
175: | Afferent | 1, 2, 3.1, 3.2.1 | Input branch: obtains Obstacle Situation and Dust Existence. |
176: | Central | 3.2.2, 3.2.4, 3.2.3 (Movement Status), 4.1, 4.2 | Processing branch: decides Movement Command and Clean. |
177: | Efferent | 3.2.3 (Direction) | Output branch: delivers Direction to the Motor and Clean to the Cleaner. |
178: 
179: Every leaf process is assigned to a region. No process was added, and no flow was renamed.