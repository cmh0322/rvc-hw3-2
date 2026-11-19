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

## docs/verification/bmad-lenses.md

1: # RVC BMAD 검토 관점
2: 
3: `bmad-review`가 선택한 관점만 읽고 적용한다. 공통 규약은 `docs/verification/review-contract.md`이다. 결과는 BMAD의 `location`, `trigger_condition`, `guard_snippet`, `potential_consequence` 필드를 유지하고 각 필드 안에 요구사항 근거와 구체적 위치를 포함한다. 최종 보고서에서 공통 규약의 분류·심각도·미검토 범위를 보충한다.
4: 
5: ## adversarial
6: 
7: 각 주장에 대해 “어떤 요구사항·상위 산출물이 이것을 정당화하는가?”, “이 주장이 틀리는 입력이나 경계 틱이 있는가?”를 묻는다. 원본 명세와 지적을 반증할 근거도 읽고 살아남은 지적만 보고한다. 최소 지적 개수를 요구하지 않는다. 결함이 확인되지 않으면 빈 결과와 검토 범위를 반환한다. 요구사항 밖 개선은 선택적 개선으로 구분한다.
8: 
9: ## sasd
10: 
11: ### 요구사항·이벤트·컨텍스트
12: - B1–B7 및 C1–C16의 동작·범위 제한을 구분하고 Q6가 C16으로 확정되었음을 반영했는가?
13: - Front/Left/Right/Dust Sensor Input, Tick, Direction, Clean의 7개 외부 흐름이 이벤트 목록과 컨텍스트에서 방향·의미·외부 개체까지 대응하는가? 새 요구사항이 생겼다면 7이라는 숫자보다 원본을 우선한다.
14: - Tick 제어 흐름과 Direction/Clean 데이터 흐름의 분류가 일관적인가?
15: 
16: ### DFD·사전·프로세스 명세
17: - Context↔Level 0↔1↔2↔3의 **각 부모 프로세스 경계**에서 입출력 집합·방향·의미가 보존되는가? 단순 전체 이름 비교로 부모별 balancing을 대신하지 않는다.
18: - 복합 데이터 분해·재결합은 사전 정의로 설명되는가? 내부 저장소/흐름과 외부 경계 흐름을 구분했는가?
19: - 프로세스 번호, 데이터/제어 구분, D1–D4의 내용과 reader/writer, 초기값과 갱신 순서가 대응하는가?
20: - 모든 Level 0–3 프로세스의 입력·출력·처리가 명세에 있는가? 입력만으로 출력을 결정할 수 있는가? Level 4에는 FSM을 사용했는가?
21: - Level 3에서 D4 advance → FSM 전이 → 출력/이동 상태 → D3 → 청소 결정 순서와 SD의 한 Tick 실행 순서가 의미적으로 일치하는가?
22: 
23: ### FSM 및 구조적 설계
24: - Level 3 제어 인터페이스와 Level 4의 상태·전이·guard·action이 일치하는가? 모델 탐색 결과는 SPIN 단계에 맡기고, 문서 검토만으로 형식 검증 완료를 선언하지 않는다.
25: - Transform Analysis의 afferent/central/efferent 경계와 Structure Chart의 책임·호출 관계에 근거가 있는가?
26: - 매개변수·반환값과 데이터 사전이 일치하는가? DFD 화살표를 그대로 함수 호출로 옮기지 않았는가?
27: - 3.2.1의 값 전달, 3.2.3의 분리, 초기화/조정 모듈, 하드웨어 라이브러리, 숨긴 상태가 SA와 SD에 추적되는가?
28: - C9–C15 변경(첫 샘플·초기 출력·물걸레·미처리 먼지 포함)이 관련 문서에 전파됐는가? 승인 시점과 후속 결정 시점을 구분하는가?
29: 
30: ### 구현·시스템 보고서가 범위에 포함될 때
31: - 설계와 코드 대조의 자세한 검사는 `rvc-c-compliance`, 수정 후 실행 검사는 `rvc-superpowers-verify`로 연결한다.
32: - 웹 시뮬레이터의 지도·센서 모델 가정과 사람의 PASS/FAIL 판정을 구분한다. 시나리오 수나 과거 로그만으로 이번 시스템 테스트 성공을 선언하지 않는다.

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
3: System: RVC Controller. Revision: 2026-11-18 Phase 4 corrections.
4: Sources: `transform_analysis.md`, current `artifacts/SA/` DFD 0–4, Data Dictionary and Process Specifications, `docs/preliminary_requirements.md`, `docs/requirements_clarifications.md`.
5: Requirement references: B1–B7, C1–C16. Q1–Q6 are resolved; Q6 is confirmed C16.
6: 
7: ## 1. Objective and revision status
8: 
9: Derive C11 module responsibilities, call hierarchy and interfaces from the current SASD artifacts. Each module below is one intended C function; no production C is changed by this document. This revision implements the owner's authorized Phase 4 fixes. Earlier SD approval applies to its earlier revision; human approval of this revised SD is pending.
10: 
11: ## 2. Input boundary and execution contract
12: 
13: The Context Diagram still has exactly the same seven external flows: Front/Left/Right/Dust Sensor Input, Tick, Direction and Clean. Software packaging of the five incoming flows is changed to one **Receive Input Event** adapter. The former four Read Sensor functions and Wait For Tick are superseded design interfaces, not additional required public APIs.
14: 
15: `Input Event` is a design tagged value: kind ∈ {Front, Left, Right, Dust, Tick}; each sensor kind carries its actual Boolean value; Tick has no Boolean payload. `Sensor Input Event` excludes Tick. `Input Mode` is design control/configuration (InitialSensors or Running), not a new external event. Valid input kinds and values are a boundary precondition; no unsupported error/recovery behavior is invented.
16: 
17: **InitialSensors contract:** the adapter actively obtains/delivers actual initial readings from all four sensors. It returns only sensor events in receipt order. It preserves any received TRUE then FALSE dust updates during acquisition; events are not collapsed into only their latest value. Acquire Initial Inputs dispatches each observation, checking readiness until all four fields have actual values. The adapter guarantees eventual delivery of those initial samples under the existing available-sensors assumption. Tick delivery is not enabled during this initial acquisition; there is no pre-initialization Tick to discard or replay. This is the C12/SA first-Tick boundary, not a new periodic-clock requirement.
18: 
19: **Running contract:** the adapter returns sensor observations and Tick in a single receipt order. Every received sensor event before a Tick must be dispatched before that Tick; later events are processed afterwards. Simultaneous arrivals are serialized by that same boundary order; no new sensor-over-Tick priority is assumed. Input reception must retain observations while a Tick is executing, without dropping or coalescing TRUE/FALSE dust events. A simulator/test adapter can supply this ordered stream; hardware capture/transport details are outside B6. Sampling only the current sensor value once per Tick cannot satisfy this contract. The implementation must later demonstrate the boundary contract; it is not considered verified here.
20: 
21: All software dispatch occurs in one sequential event loop. No input callback mutates D1/D2 during Controller. There are no separate concurrent writers or writable store pointers. A sensor event updates only its store; it never advances D3/D4, takes a movement transition or emits an output. Each Tick executes exactly one complete Controller cycle. Ticks continue under the existing clock assumption; C5 allows repeated Backing without guaranteeing eventual Forward.
22: 
23: Initialization order: Reset Movement Controller (Forward, D4=Idle) → Reset Power-Up Timer (D3=0) → Reset Sensor Data (invalid sensor fields, pending=false) → Acquire Initial Inputs. The first TRUE dust sample sets pending; no reset is performed after sampling. Initialize RVC and every function reachable through its initialization calls return no Movement Command and emit no Direction/Clean (C13). Once initialization returns, Main first calls Receive Input Event in Running mode; the first Tick may immediately select Stop if front is blocked.
24: 
25: ## 3. Call hierarchy
26: 
27: Rectangles are internal modules; double rectangles are boundary/library modules. Solid arrows are calls, labelled with order or condition. These are not DFD flow arrows. For data/return/control values, the authoritative call table is section 5. The diagrams together cover every call in that table; shared modules appear in more than one view.
28: 
29: ### 3.1 Event loop and initialization
30: 
31: ```mermaid
32: flowchart TB
33:     M0["Main"]
34:     M1["Initialize RVC"]
35:     M2["Acquire Initial Inputs"]
36:     M3["Dispatch Input Event"]
37:     M4["Dispatch Sensor Input"]
38:     M5["Controller"]
39:     M7["Detect Obstacle"]
40:     M9["Detect Dust"]
41:     M10["Reset Sensor Data"]
42:     M11["Inputs Ready"]
43:     M17["Reset Movement Controller"]
44:     M20["Reset Step Timer"]
45:     M23["Reset Power-Up Timer"]
46:     M27[["Receive Input Event"]]
47:     M0 -->|"once before event loop"| M1
48:     M0 -->|"each event-loop iteration, after initialization"| M27
49:     M0 -->|"after Receive Input Event returns"| M3
50:     M1 -->|"once, in listed order"| M17
51:     M1 -->|"once, in listed order"| M23
52:     M1 -->|"once, in listed order"| M10
53:     M1 -->|"once, in listed order"| M2
54:     M2 -->|"before each acquisition iteration"| M11
55:     M2 -->|"while not Ready"| M27
56:     M2 -->|"after each initial sensor event"| M4
57:     M3 -->|"event kind is a sensor"| M4
58:     M3 -->|"event kind is Tick"| M5
59:     M4 -->|"front, left or right event"| M7
60:     M4 -->|"dust event"| M9
61:     M17 -->|"always"| M20
62: ```
63: 
64: ### 3.2 One Tick: input, decision and output
65: 
66: ```mermaid
67: flowchart TB
68:     M5["Controller"]
69:     M6["Get Inputs"]
70:     M8["Assess Obstacle Situation"]
71:     M12["Get Obstacle Location"]
72:     M15["Decide Actions"]
73:     M16["Movement Controller"]
74:     M18["Advance Step Timer"]
75:     M19["Start Step Timer"]
76:     M21["Derive Movement Status"]
77:     M22["Track Power-Up"]
78:     M24["Decide Cleaning"]
79:     M25["Put Outputs"]
80:     M26["Issue Movement Output"]
81:     M28[["Drive Motor"]]
82:     M29[["Drive Cleaner"]]
83:     M5 -->|"1 per Tick"| M6
84:     M5 -->|"2 per Tick"| M15
85:     M5 -->|"3 per Tick"| M25
86:     M6 -->|"1"| M12
87:     M6 -->|"2"| M8
88:     M15 -->|"1"| M16
89:     M15 -->|"2"| M21
90:     M15 -->|"3"| M22
91:     M15 -->|"4"| M24
92:     M16 -->|"before transition"| M18
93:     M16 -->|"T2/T4/T5/T6/T8/T9/T10 only, after selection"| M19
94:     M25 -->|"1"| M26
95:     M25 -->|"2"| M29
96:     M26 -->|"always"| M28
97: ```
98: 
99: ### 3.3 D2 access in power-up processing
100: 
101: ```mermaid
102: flowchart TB
103:     M13["Get Dust Existence"]
104:     M14["Clear Pending Dust"]
105:     M22["Track Power-Up"]
106:     M22 -->|"1 before power-up decision"| M13
107:     M22 -->|"Forward only, after evaluating current/pending; before returning"| M14
108: ```
109: 
110: The D2 feedback is a store update, not a call from the sensor module back into the controller. Detect Dust and the D2 accessors operate on private Sensor Store data. Track Power-Up invokes the accessor; its caller does not receive a writable D2 record.
111: 
112: ```mermaid
113: flowchart LR
114:     Detect["Detect Dust"]
115:     D2[["D2 current + pending"]]
116:     Get["Get Dust Existence"]
117:     Track["Track Power-Up"]
118:     Clear["Clear Pending Dust"]
119:     Detect -.->|"data: current=value, pending OR value"| D2
120:     D2 -.->|"data: value copy"| Get
121:     Get -.->|"data: Dust Existence"| Track
122:     Track -->|"call: Forward only"| Clear
123:     Clear -.->|"data: pending=false only"| D2
124: ```
125: 
126: This last view illustrates encapsulated data access and the Forward-only call; dashed labelled arrows are data movement, not extra function calls.
127: 
128: ## 4. Module descriptions and hidden data
129: 
130: ### 4.1 Internal modules
131: 
132: | Module | Region | Responsibility | Called modules |
133: |---|---|---|---|
134: | Main | Root | Initialize once, then receive and dispatch one ordered input event at a time. | Initialize RVC, Receive Input Event, Dispatch Input Event |
135: | Initialize RVC | Root | Reset movement, D3 and Sensor Store; acquire initial samples. Return only when all four samples are valid; emit no command (C12/C13). | Reset Movement Controller, Reset Power-Up Timer, Reset Sensor Data, Acquire Initial Inputs |
136: | Acquire Initial Inputs | Root | Until Inputs Ready, obtain InitialSensors events and dispatch only sensor inputs. Preserve all intermediate TRUE dust observations. | Inputs Ready, Receive Input Event, Dispatch Sensor Input |
137: | Dispatch Input Event | Root | For a sensor event call Dispatch Sensor Input; for Tick call Controller once. The branches are mutually exclusive. | Dispatch Sensor Input, Controller |
138: | Dispatch Sensor Input | Afferent | Route front/left/right values to Detect Obstacle and dust values to Detect Dust. Never call Controller or any output module. | Detect Obstacle, Detect Dust |
139: | Controller | Root | For one Tick: Get Inputs, Decide Actions, Put Outputs. No sensor dispatch interleaves with this cycle. | Get Inputs, Decide Actions, Put Outputs |
140: | Get Inputs | Afferent | Read a valid D1 snapshot and classify it. Dust is read directly by Track Power-Up through the Sensor Store accessor. | Get Obstacle Location, Assess Obstacle Situation |
141: | Detect Obstacle | Afferent | Update only the named D1 sensor field and its valid flag; preserve the other fields (P1). | — |
142: | Assess Obstacle Situation | Afferent | Produce Front Blocked and Side Situation independently; right priority (C1/C9). | — |
143: | Detect Dust | Afferent | Set current=value; pending=old_pending OR value; mark dust valid. FALSE preserves pending (P2/C15). | — |
144: | Reset Sensor Data | Afferent | Set valid flags false and pending=false. Current sensor slots are invalid until populated by actual input; zero is not an assumed reading. | — |
145: | Inputs Ready | Afferent | Return true exactly when front, left, right and dust have all received a valid actual sample. | — |
146: | Get Obstacle Location | Afferent | Return a value copy of the three valid D1 readings. No writable state reference escapes. | — |
147: | Get Dust Existence | Afferent | Return a value copy of D2 current and pending. Does not consume or clear the detection. | — |
148: | Clear Pending Dust | Afferent storage access | Set only pending=false. Leave current and validity unchanged. Called only by Track Power-Up on Forward. | — |
149: | Decide Actions | Central | Select movement, derive Movement Status, track power-up, then decide cleaning. | Movement Controller, Derive Movement Status, Track Power-Up, Decide Cleaning |
150: | Movement Controller | Central | Advance D4, take exactly one T1-T14 transition, and restart D4 only when that transition starts a timed step. | Advance Step Timer, Start Step Timer |
151: | Reset Movement Controller | Central | Set Forward state and reset D4 to Idle; return no Movement Command (T0/C13). | Reset Step Timer |
152: | Advance Step Timer | Central | If running, increment elapsed; at 5 emit Step Done and set Idle. Run before the FSM transition. | — |
153: | Start Step Timer | Central | Set elapsed=0 after the transition requests a new step; its command Tick is the first of five. | — |
154: | Reset Step Timer | Central | Set D4 to Idle. | — |
155: | Derive Movement Status | Central | Return Forward for a Forward command, otherwise Avoiding (P3.2.3 central part). | — |
156: | Track Power-Up | Central | Read D2; preserve D3 and pending while Avoiding. On Forward apply current/pending restart precedence, consume pending, report active and decrement D3. | Get Dust Existence, Clear Pending Dust |
157: | Reset Power-Up Timer | Central | Set D3=0 as specified by current SA; no cleaning output. | — |
158: | Decide Cleaning | Central | Choose Stop while Avoiding; otherwise Power Up if active, else Start. Use C14 meanings. | — |
159: | Put Outputs | Efferent | Deliver Movement Command through Issue Movement Output, then Clean through Drive Cleaner, within this Tick. | Issue Movement Output, Drive Cleaner |
160: | Issue Movement Output | Efferent | Map Movement Command to Direction and call Drive Motor (P3.2.3 efferent part). | Drive Motor |
161: 
162: ### 4.2 Library/boundary modules
163: 
164: | Module | Context terminators | Contract |
165: |---|---|---|
166: | Receive Input Event | Four sensor terminators and Digital Clock | Input Mode → one Input Event; ordered, lossless received-event contract in section 2 |
167: | Drive Motor | Motor | Direction → hardware boundary; no return data |
168: | Drive Cleaner | Cleaner | Clean → hardware boundary; Start/Stop affect suction+mop, Power Up suction only |
169: 
170: Grouping five input terminators in one adapter is a design choice. Their identities and semantics remain distinct in the tagged record. Motor and Cleaner remain separate output boundaries. No hardware implementation is specified.
171: 
172: ### 4.3 Hidden data and ownership
173: 
174: | Group | Member modules | Private data | SA origin and access rule |
175: |---|---|---|---|
176: | Sensor Store | Reset Sensor Data, Inputs Ready, Detect Obstacle, Detect Dust, Get Obstacle Location, Get Dust Existence, Clear Pending Dust | D1's three values; D2 current and pending; four validity flags | P1/P2 and D1/D2. Only these members access storage directly. Getters return copies. Only Detect Dust sets pending by OR; only Clear Pending Dust consumes it during operation. Reset is initialization-only. |
177: | Movement Controller | Movement Controller, Reset Movement Controller | State: Forward, Stopping, Backing, TurningRight, TurningLeft | P3.2.2 / Level 4 FSM |
178: | Step Timer | Advance Step Timer, Start Step Timer, Reset Step Timer | D4: Idle or elapsed 0–5 | P3.2.4; reaches 5 transiently, emits Done, then Idle |
179: | Power-Up Timer | Track Power-Up, Reset Power-Up Timer | D3: remaining 0–5 | P4.1; initially 0 in current PSPEC/Dictionary |
180: 
181: Readiness flags distinguish unreceived values from actual FALSE samples. Accessing sensor value copies requires the corresponding fields to be valid; Controller requires all four. The input adapter may buffer events as a boundary mechanism, but it is not a second owner of the authoritative D2 pending flag. Queries for tests/simulator may return copies without granting mutation; they are not production control calls in this chart.
182: 
183: ## 5. Module interfaces
184: 
185: Input Data is passed to the callee, Output Data is returned. Control Information records occurrence/enum control values. Conditions are part of the invocation contract. No raw pointer to hidden data is returned. Sensor ID, validity, Input Mode and Input Event are supporting design types; domain fields retain Data Dictionary values.
186: 
187: | Caller | Callee | Input Data | Output Data | Control Information | Order / condition |
188: |---|---|---|---|---|---|
189: | Main | Initialize RVC | — | — | — | once before event loop |
190: | Main | Receive Input Event | Input Mode=Running | Input Event | — | each event-loop iteration, after initialization |
191: | Main | Dispatch Input Event | Input Event | — | — | after Receive Input Event returns |
192: | Initialize RVC | Reset Movement Controller | — | — | — | once, in listed order |
193: | Initialize RVC | Reset Power-Up Timer | — | — | — | once, in listed order |
194: | Initialize RVC | Reset Sensor Data | — | — | — | once, in listed order |
195: | Initialize RVC | Acquire Initial Inputs | — | — | — | once, in listed order |
196: | Acquire Initial Inputs | Inputs Ready | — | Ready | — | before each acquisition iteration |
197: | Acquire Initial Inputs | Receive Input Event | Input Mode=InitialSensors | Sensor Input Event | — | while not Ready |
198: | Acquire Initial Inputs | Dispatch Sensor Input | Sensor Input Event | — | — | after each initial sensor event |
199: | Dispatch Input Event | Dispatch Sensor Input | Sensor Input Event | — | — | event kind is a sensor |
200: | Dispatch Input Event | Controller | — | — | Tick occurrence | event kind is Tick |
201: | Dispatch Sensor Input | Detect Obstacle | Sensor ID, Boolean value | — | — | front, left or right event |
202: | Dispatch Sensor Input | Detect Dust | Dust Sensor Input | — | — | dust event |
203: | Controller | Get Inputs | — | Obstacle Situation | — | 1 per Tick |
204: | Controller | Decide Actions | Obstacle Situation | Clean | ↑ Movement Command | 2 per Tick |
205: | Controller | Put Outputs | Clean | — | ↓ Movement Command | 3 per Tick |
206: | Get Inputs | Get Obstacle Location | — | Obstacle Location | — | 1 |
207: | Get Inputs | Assess Obstacle Situation | Obstacle Location | Obstacle Situation | — | 2 |
208: | Decide Actions | Movement Controller | — | — | ↓ Situation Signal, ↑ Movement Command | 1 |
209: | Decide Actions | Derive Movement Status | — | Movement Status | ↓ Movement Command | 2 |
210: | Decide Actions | Track Power-Up | Movement Status | Power-Up Active | — | 3 |
211: | Decide Actions | Decide Cleaning | Movement Status, Power-Up Active | Clean | — | 4 |
212: | Movement Controller | Advance Step Timer | — | — | ↑ Step Done | before transition |
213: | Movement Controller | Start Step Timer | — | — | — | T2/T4/T5/T6/T8/T9/T10 only, after selection |
214: | Reset Movement Controller | Reset Step Timer | — | — | — | always |
215: | Track Power-Up | Get Dust Existence | — | Dust Existence | — | 1 before power-up decision |
216: | Track Power-Up | Clear Pending Dust | — | — | — | Forward only, after evaluating current/pending; before returning |
217: | Put Outputs | Issue Movement Output | — | — | ↓ Movement Command | 1 |
218: | Put Outputs | Drive Cleaner | Clean | — | — | 2 |
219: | Issue Movement Output | Drive Motor | Direction | — | — | always |
220: 
221: `Decide Actions` forwards Obstacle Situation as Situation Signal, unchanged, realizing P3.2.1 without a separate empty function. The two fields are Front Blocked and Side Situation. RightOpen has priority even when both sides are clear. C16 restricts only avoidance entry while Forward; after Backing C9 uses the sides regardless of front.
222: 
223: ### 5.1 Sensor updates and power-up contract
224: 
225: The following is design pseudocode implementing existing PSPEC 2/4.1, not production C or new business behavior:
226: 
227: ```text
228: Detect Dust(value):
229:     D2.current = value
230:     D2.pending = D2.pending OR value
231:     dust_valid = TRUE
232: 
233: Track Power-Up(status):
234:     dust = Get Dust Existence()         // value copy; no clearing
235:     IF status == Avoiding:
236:         RETURN FALSE                  // D3 and D2.pending unchanged
237:     IF dust.current OR dust.pending:
238:         D3 = 5                        // C15 overrides saved partial count
239:     Clear Pending Dust()              // Forward only; current unchanged
240:     active = (D3 > 0)
241:     IF active: D3 = D3 - 1
242:     RETURN active
243: ```
244: 
245: A start/restart at t powers suction on t..t+4 absent another detection or avoidance; the stored count after t is 4. Continuous TRUE current dust restarts on every Forward Tick per C10. Multiple pending detections coalesce into one restart. Without current/pending dust, a saved count resumes under C11. TRUE then FALSE before the next Tick leaves pending TRUE. No input dispatch can interleave between Get Dust Existence and Clear Pending Dust; an input received during Controller remains ordered for later dispatch.
246: 
247: Clean is Stop (suction and mopping both off) while Avoiding; otherwise Power Up strengthens suction only with normal mopping, or Start runs normal suction and mopping (C14). Direction and Clean are delivered within the same Tick after decisions, as the existing SD output-phase design specifies.
248: 
249: ## 6. SA-to-SD traceability
250: 
251: ### 6.1 Processes
252: 
253: | SA process | SD realization | Design rationale |
254: |---|---|---|
255: | 0 | Main, Initialize RVC, Acquire Initial Inputs, Dispatch Input Event, Controller | Initial readiness and serial event/Tick coordination; C12/C13. |
256: | 1 | Dispatch Sensor Input, Detect Obstacle, Get Obstacle Location | Identify sensor, preserve D1 fields, expose valid value copy. |
257: | 2 | Dispatch Sensor Input, Detect Dust, Get Dust Existence | Retain current/pending D2 for each received dust input; C15. |
258: | 3 | Children of 3.1/3.2 | Movement parent. |
259: | 3.1 | Assess Obstacle Situation | Raw record to independent front and sides with right priority. |
260: | 3.2 | Children of 3.2.1–3.2.4 | Movement sequencing parent. |
261: | 3.2.1 | Decide Actions parameter passing | Obstacle Situation becomes Situation Signal without transformation. |
262: | 3.2.2 | Movement Controller, Reset Movement Controller | T1–T14 on Tick; T0 initializes only. |
263: | 3.2.3 | Derive Movement Status, Issue Movement Output | Split central status and efferent Direction. |
264: | 3.2.4 | Advance Step Timer, Start Step Timer, Reset Step Timer | Two triggers and initial D4=Idle. |
265: | 4 | Children of 4.1/4.2 | Cleaning parent. |
266: | 4.1 | Track Power-Up, Reset Power-Up Timer, Get Dust Existence, Clear Pending Dust | D3 count and D2 observation/Forward-only consumption; C10/C11/C15. |
267: | 4.2 | Decide Cleaning | Clean decision with C14 semantics. |
268: 
269: Get Inputs, Decide Actions and Put Outputs coordinate the transform regions. Reset Sensor Data and Inputs Ready realize SA initial D1/D2 validity and pending initialization. Sensor Store accessors realize store access without exposing storage. Dispatch functions realize SA input-event triggers, not new external functionality. Receive Input Event realizes the five existing incoming Context flows. Drive Motor/Cleaner realize the two existing outgoing flows.
270: 
271: ### 6.2 Stores and control flows
272: 
273: | SA item | Design realization |
274: |---|---|
275: | D1 Obstacle Location | Persistent latest received values inside Sensor Store, with validity. Read by Get Inputs via Get Obstacle Location. |
276: | D2 Dust Existence | Persistent current + pending inside Sensor Store. Detect Dust records every observation; Track Power-Up reads through a getter and consumes via Clear Pending Dust. |
277: | Pending Dust Detection | Forward-only pending-field update through Clear Pending Dust, corresponding to P4.1→D2; does not replace current. |
278: | D3 Power-Up Timer | Private remaining count in Power-Up Timer group; initial 0 is already specified in SA. |
279: | D4 Step Timer | Private elapsed/Idle state in Step Timer group. |
280: | Tick | Input Event kind Tick; Dispatch Input Event invokes Controller once. |
281: | Situation Signal | Control parameter from Decide Actions to Movement Controller. |
282: | Movement Command | Movement Controller return, passed to Derive Movement Status and Put Outputs/Issue Movement Output. No such return from reset. |
283: | Step Done | Advance Step Timer return before movement selection. |
284: | Start Step Timer | Conditional call after movement selection. |
285: 
286: ### 6.3 FSM and timing
287: 
288: T0 sets only Forward state; no Movement Command, Direction, Clean or timer start is emitted. Every subsequent Tick selects T1–T14 exactly once. Only T2/T4/T5/T6/T8/T9/T10 call Start Step Timer. Advance runs first; a step started at t has elapsed 0 after t, 1..4 at t+1..t+4 and Done at t+5. At Done a turn returns Forward, or Stopping/Backing chooses the sides and starts the next step. C5 permits repeated Backing; C9 ignores front at that decision. While Forward a clear front retains Forward regardless of sides (confirmed C16).
289: 
290: ## 7. Design decisions and approval record
291: 
292: | Decision | Basis and consequence |
293: |---|---|
294: | One ordered event adapter instead of polling-only sensor reads | SA event-triggered P1/P2, C12/C15. Changes software input APIs; actual capture implementation remains B6 scope exclusion. Test/simulator adapters must supply initial samples and ordered later events. |
295: | Serial event loop, no input reentrancy during Tick | SA Process 0 logical serialization. Allows value-copy D2 read then pending clear without losing a concurrently dispatched detection. |
296: | Persistent encapsulated Sensor Store with accessors | D1 latest-value semantics and D2 pending lifetime. Avoids external mutable globals; flags are initialization support. |
297: | Initialization acquires actual samples and does not output | C12/C13. No new requirement; supersedes old initial Forward and same-cycle-only storage design. |
298: | D3=0 | Current PSPEC 0/4.1 and Data Dictionary; no longer an unsupported design assumption. |
299: | Data/decisions/output remain separated within a Tick | Original transform mapping; Movement Status computed before D3/Clean; outputs delivered together at end of same Tick. |
300: 
301: Historical approval and 2026-11-16 C9–C11 updates apply to their historical revisions. The 2026-11-18 changes implement the already confirmed C12–C16 decisions and Phase 4 findings P4-01–P4-06. Q4/Q5 are resolved by C10/C11, Q6 by C16. This document does not assert that old C, tests or simulator already satisfy the revised interfaces. Revised SD human approval remains pending; QA.md holds the current review and approval status.
302: 
303: ## 8. Review criteria and downstream work
304: 
305: Review module responsibilities, every call/interface/condition and every SA mapping together; compare the event-boundary and initial-readiness contracts with C12/C15. Confirm pending-only consumption, current-value preservation, and countdown/restart precedence. C11 and C9 remain unchanged except for C15's explicit restart precedence already in SA.
306: 
307: The existing `tests/expected_calls.txt` describes the earlier call graph (including initialization output and wait_for_tick). It is not updated or treated as proof of this design. After human approval, C-compliance review and authorized TDD must reconcile production interfaces, expected calls, unit scenarios and simulator input delivery. Current document consistency checks, rendered diagrams and independent review results are recorded separately under artifacts/Review; this section does not pre-claim test success.

## artifacts/SD/transform_analysis.md

1: # Transform Analysis
2: 
3: System: RVC Controller
4: Sources: `artifacts/SA/DFD/dfd_level_0.md` to `dfd_level_3.md`, `artifacts/SA/DFD/dfd_level_4_fsm.md`, `artifacts/SA/process_specification.md`, `artifacts/SA/data_dictionary.md`, `artifacts/SA/context_diagram.md`, `artifacts/SA/event_list.md`
5: Requirement references: B1-B7 (`docs/preliminary_requirements.md`), C1-C16; Q1-Q6 resolved (`docs/requirements_clarifications.md`)
6: 
7: ## 1. Objective
8: 
9: Identify the Afferent Flow, Central Transformation, and Efferent Flow of the RVC Controller from the current SA DFD hierarchy (C12-C16 revision; human approval of this revised SD remains pending), as the basis for the Structure Chart (`artifacts/SD/structure_chart.md`).
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
33: | 2 | Detect Dust | Dust Sensor Input, previous Dust Existence (pending field from D2) | Dust Existence (current reading and latched pending flag, to D2) |
34: 
35: Rationale:
36: - 1 records the latest obstacle inputs. 2 records the current dust input and ORs each TRUE detection into the pending flag in D2 (C15). This is input-history retention, not a cleaning decision.
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
50: | 4.1 | Track Power-Up | Tick, Dust Existence (from D2), Movement Status, Remaining Power-Up Ticks (from D3) | Power-Up Active, Remaining Power-Up Ticks (to D3), Pending Dust Detection (pending-only update to D2) |
51: | 4.2 | Decide Cleaning | Movement Status, Power-Up Active | Clean |
52: 
53: Rationale:
54: - 3.2.2 is the control process of the system (the Level 4 FSM). It chooses the movement.
55: - 3.2.4 works only for 3.2.2: it is started by the Controller and reports back to it. It is part of the control loop, not an input or an output path.
56: - 4.1 decides whether powered-up cleaning applies on this tick. It preserves D2 pending and D3 during Avoiding; on Forward it starts/restarts five ticks for current/pending dust, consumes pending, otherwise resumes the saved count (C10/C11/C15).
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
86: - **Boundary Data Flows:** Dust Existence (afferent → central), Pending Dust Detection (central → D2 in the afferent region), Clean (central → Cleaner).
87: - **Boundary Control Flows:** Situation Signal (afferent → central), Movement Command (central → efferent).
88: 
89: | Boundary flow | Category | From | To | Why the boundary is here |
90: |---|---|---|---|---|
91: | Situation Signal | Control | 3.2.1 | 3.2.2 | Last point where the obstacle input is only a description. 3.2.2 turns it into an action. |
92: | Dust Existence | Data | 2 (via D2) | 4.1 | Current and remembered dust form the input to the power-up decision. |
93: | Pending Dust Detection | Data | 4.1 | D2 | A Forward Tick consumes pending; only this field is cleared, preserving current dust. This feedback crosses the transform boundary. |
94: | Movement Command | Control | 3.2.2 | 3.2.3 | First point where the movement output exists. After it, only the form changes. |
95: | Clean | Data | 4.2 | Cleaner | First point where the cleaning output exists. It needs no further processing. |
96: 
97: **Tick** is not transformed by any afferent process. It triggers 3.1, 3.2.2, 3.2.4, and 4.1 directly. In the design it becomes the trigger of one control cycle, not a value that is passed around.
98: 
99: ## 4. Transform Analysis Diagram
100: 
101: ```mermaid
102: flowchart LR
103:     FS["Front Sensor"]
104:     LS["Left Sensor"]
105:     RS["Right Sensor"]
106:     DSN["Dust Sensor"]
107:     CLK["Digital Clock"]
108:     MOT["Motor"]
109:     CLN["Cleaner"]
110: 
111:     subgraph A["Afferent Flow (Input)"]
112:         P1(("1 Detect Obstacle"))
113:         D1[["D1 Obstacle Location"]]
114:         P31(("3.1 Assess Obstacle Situation"))
115:         P321(("3.2.1 Signal Obstacle Situation"))
116:         P2(("2 Detect Dust"))
117:         D2[["D2 Dust Existence"]]
118:     end
119: 
120:     subgraph C["Central Transformation"]
121:         P322(("3.2.2 Movement Controller"))
122:         P324(("3.2.4 Time Movement Step"))
123:         D4[["D4 Step Timer"]]
124:         P323S(("3.2.3 Movement Status part"))
125:         P41(("4.1 Track Power-Up"))
126:         D3[["D3 Power-Up Timer"]]
127:         P42(("4.2 Decide Cleaning"))
128:     end
129: 
130:     subgraph E["Efferent Flow (Output)"]
131:         P323D(("3.2.3 Direction part"))
132:     end
133: 
134:     FS -->|"Front Sensor Input"| P1
135:     LS -->|"Left Sensor Input"| P1
136:     RS -->|"Right Sensor Input"| P1
137:     P1 -->|"Obstacle Location"| D1
138:     D1 -->|"Obstacle Location"| P31
139:     P31 -->|"Obstacle Situation"| P321
140:     DSN -->|"Dust Sensor Input"| P2
141:     D2 -->|"Dust Existence"| P2
142:     P2 -->|"Dust Existence"| D2
143: 
144:     P321 -.->|"Situation Signal"| P322
145:     D2 -->|"Dust Existence"| P41
146:     P41 -->|"Pending Dust Detection"| D2
147: 
148:     CLK -.->|"Tick"| P31
149:     CLK -.->|"Tick"| P322
150:     CLK -.->|"Tick"| P324
151:     CLK -.->|"Tick"| P41
152: 
153:     P322 -.->|"Start Step Timer"| P324
154:     P324 -.->|"Step Done"| P322
155:     P324 -->|"Step Ticks Elapsed"| D4
156:     D4 -->|"Step Ticks Elapsed"| P324
157:     P322 -.->|"Movement Command"| P323S
158:     P323S -->|"Movement Status"| P41
159:     P323S -->|"Movement Status"| P42
160:     P41 -->|"Remaining Power-Up Ticks"| D3
161:     D3 -->|"Remaining Power-Up Ticks"| P41
162:     P41 -->|"Power-Up Active"| P42
163: 
164:     P322 -.->|"Movement Command"| P323D
165:     P323D -->|"Direction"| MOT
166:     P42 -->|"Clean"| CLN
167: 
168:     classDef control stroke-dasharray: 5 5
169:     class P322 control
170: ```
171: 
172: Solid arrows are data flows. Dashed arrows are control flows. `3.2.2` has a dashed border because it is the control process. All names are those of the DFDs; `3.2.3` appears twice, once for each of its outputs.
173: 
174: ## 5. Result
175: 
176: | Region | DFD processes | Role in the Structure Chart |
177: |---|---|---|
178: | Afferent | 1, 2, 3.1, 3.2.1 | Input branch: obtains Obstacle Situation and Dust Existence. |
179: | Central | 3.2.2, 3.2.4, 3.2.3 (Movement Status), 4.1, 4.2 | Processing branch: decides Movement Command and Clean. |
180: | Efferent | 3.2.3 (Direction) | Output branch: delivers Direction to the Motor and Clean to the Cleaner. |
181: 
182: Every leaf process is assigned to a region. No process was added, and no flow was renamed.
183: 
184: ## 6. Input lifetime, initialization and scheduling (2026-11-18 revision)
185: 
186: D1 holds the latest three received obstacle values. D2 persists current Dust Detected and Pending Dust Detection across inputs and ticks. Process 2 reads only the previous pending field before writing the new record. Process 4.1 updates only pending after a Forward Tick. Input recording and Tick execution are logically serialized (SA Process 0); a later FALSE never erases a remembered TRUE.
187: 
188: The SD realizes the same five incoming event types (four sensors and Tick) using one ordered input-event adapter. This changes software packaging, not the Context boundary. Sensor events update D1/D2 without taking an FSM transition. Tick alone triggers the control cycle. Hardware capture/transport is outside B6; its boundary contract must preserve received events, including a TRUE followed by FALSE between ticks.
189: 
190: Initialization sets Forward state, D3=0, D4=Idle, pending=FALSE and all sensor-valid flags false. Acquire all four actual initial readings before enabling the first Tick delivery (C12). No Direction or Clean is emitted during initialization (C13). Readiness flags and tagged input events are design support data, not new external functions or SA data flows.
191: 
192: The three transform regions remain useful even with the feedback into D2. Store ownership is encapsulated in the Structure Chart's Sensor Store group; neither a DFD arrow nor this feedback implies a module call by itself. C14 defines Start/Stop for suction and mopping together and Power Up for suction only. C16 is confirmed; Forward avoidance entry uses only the front, whereas C9 still controls post-backing side selection.
193: 
194: Earlier approvals refer to the earlier artifact revision. This update implements the owner's authorized Phase 4 corrections; it does not declare revised SD approval or C conformance.