# Phase 2 요구사항 → SA 추적 매트릭스

대상: B1–B7/C1–C15의 22개 확정 항목 + Q6 가정 1개. **문서 대응을 대조한 결과이며 실행·구현 준수율이 아니다.** B6/B7은 범위 제약이므로 FSM 전이나 함수를 강제하지 않는다. B3의 회피 진입은 Q6에 조건부다. 각 행의 복합 의미와 우선순위까지 읽고 대조했으며 ID가 등장한다는 사실만으로 판정하지 않았다.

## 출처 약어

- R: [docs/requirements_clarifications.md](../../../../docs/requirements_clarifications.md)
- B: [docs/preliminary_requirements.md](../../../../docs/preliminary_requirements.md)
- E: [artifacts/SA/event_list.md](../../../../artifacts/SA/event_list.md)
- CTX: [artifacts/SA/context_diagram.md](../../../../artifacts/SA/context_diagram.md)
- P: [artifacts/SA/process_specification.md](../../../../artifacts/SA/process_specification.md)
- D: [artifacts/SA/data_dictionary.md](../../../../artifacts/SA/data_dictionary.md)
- L1: [artifacts/SA/DFD/dfd_level_1.md](../../../../artifacts/SA/DFD/dfd_level_1.md)
- L2: [artifacts/SA/DFD/dfd_level_2.md](../../../../artifacts/SA/DFD/dfd_level_2.md)
- L3: [artifacts/SA/DFD/dfd_level_3.md](../../../../artifacts/SA/DFD/dfd_level_3.md)
- F: [artifacts/SA/DFD/dfd_level_4_fsm.md](../../../../artifacts/SA/DFD/dfd_level_4_fsm.md)

숫자는 해당 원문의 줄 번호다. 이번 실행 시점 원문은 [source-snapshot.md](source-snapshot.md), 해시는 [input-manifest.json](input-manifest.json)에 보존했다. 기계 판독용 전체 행은 [matrix.json](matrix.json)에 있다.

## 정방향 대응

| ID · 원문 | 의미 | 이벤트/흐름 | SA 프로세스 · 사전 | FSM 적용 여부 | 근거 | 판정·조건 |
|---|---|---|---|---|---|---|
| B1 (B:1) | 자동 흡입 청소·물걸레 | Clean | 0,4,4.2; Clean | 청소 출력은 FSM 밖; Forward 상태와 Movement Status로 연결 | E:16–28, P:424–444, D:109–117 | traced: C14가 물걸레/강화 의미를 보완 |
| B2 (B:2) | 전진하며 청소 | Direction,Clean | 3,3.2.2,3.2.3,4.2; Movement Status,Clean | T1,T12,T14 | E:27–28, P:520–533, P:565–579, P:424–440 | traced: 초기 출력 예외는 C13 |
| B3 (B:3) | 장애물 시 청소 중단·정지·회전·전진 재개 | Front/Left/Right Sensor Input,Direction,Clean | 1,3.1,3.2.2,3.2.3,4.2; Obstacle Situation,Movement Status | T2-T5,T11-T14 | E:22–28, P:174–189, P:520–535, P:424–440 | traced-under-Q6: Forward의 회피 진입은 Q6 가정 아래 전방만 사용; Q6 별도 행 |
| B4 (B:4) | 전방·좌우 차단 시 후진 후 회전 | Front/Left/Right Sensor Input,Direction | 1,3.1,3.2.2,3.2.4; Side Situation,D4 | T6-T10,T12,T14 | E:22–27, P:264–291, F:69–77 | traced: C5/C9가 후진 반복과 전방 독립을 보완 |
| B5 (B:5) | 먼지 감지 시 일시 파워업 | Dust Sensor Input,Clean,Tick | 2,4.1,4.2; D2,D3,Pending Dust Detection | 직접 전이 해당 없음: 청소 타이머는 FSM 밖 | E:25–28, P:130–146, P:365–398, P:424–444 | traced: C3/C10/C11/C15로 기간·재시작·보존 정의 |
| B6 (B:6) | 하드웨어 세부 설계·구현 제외 | Context 외부 경계 | 0,4.2의 범위 계약; 외부 센서/Motor/Cleaner | 해당 없음: 범위 제약 | CTX:8–9, P:428 | scope-traced: C14는 명령 의미만 정의; 하드웨어 모듈 추가를 요구하지 않음 |
| B7 (B:7) | 자동 청소 기능으로 범위 제한 | Context 내부 경계 | 0 및 자동 제어 분해; 시스템 전체 범위 | 해당 없음: 범위 제약 | CTX:8–9, P:20–21, P:42–62, L1:53–66 | scope-traced: 충전/지도/앱 기능을 새 요구사항으로 요구하지 않음 |
| C1 (R:9) | 양측 개방 시 우회전 우선 | Left/Right Sensor Input,Direction | 3.1,3.2.2; Right Open,Left Open | T4,T9 | E:23–27, P:264–286, F:67–73 | traced: Right Open은 오른쪽이 비면 TRUE, Left Open은 오른쪽 차단+왼쪽 개방 |
| C2 (R:10) | 우회 전 정지 | Front Sensor Input,Direction | 3.2.2,3.2.4; Start Step Timer,D4 | T2,T3 | E:27, P:520–525, F:65–69 | traced: Stop을 먼저 출력; C7이 지속 시간 보완 |
| C3 (R:11) | 파워업 5틱 | Dust Sensor Input,Tick,Clean | 4.1; Remaining Power-Up Ticks,D3 | 직접 전이 해당 없음: D3 | E:26–28, P:365–392, D:200–218 | traced: 시작 틱 포함, 새 감지/회피가 없으면 t..t+4 |
| C4 (R:12) | 장애물이 물리적으로 사라지지 않음 | Front/Left/Right Sensor Input의 환경 전제 | 3.2.2; Front Blocked,Side Situation | Stopping의 T4-T6 전제 | L2:125, L3:96–97, F:104–111 | traced: 정지 중 전방 유지; 이동·회전 후 센서 고정이라는 뜻이 아님 |
| C5 (R:13) | 후진 후 오른쪽/왼쪽/재후진 선택 | Left/Right Sensor Input,Direction | 3.1,3.2.2; Side Situation | T8,T9,T10 | P:174–177, F:71–73, L2:125–129 | traced: 양측 차단이면 무제한 반복 가능; unconditional eventual-forward 요구 없음 |
| C6 (R:14) | 후진 5틱 | Tick,Direction | 3.2.2,3.2.4; D4,Step Done | T6-T10 | E:26, P:613–637, F:69–73, F:91 | traced: 시작 틱 포함 5회 출력; 다음 틱에 선택 |
| C7 (R:15) | 회피 전 정지 5틱 | Tick,Direction | 3.2.2,3.2.4; D4,Step Done | T2-T6 | E:26, P:613–637, F:85–91 | traced: 정지 t..t+4, 다음 액션 t+5 |
| C8 (R:16) | 회전 5틱 | Tick,Direction | 3.2.2,3.2.4; D4,Step Done | T4,T5,T9-T14 | E:26, P:613–637, F:67–77, F:85–91 | traced: 회전 방향은 상태로 유지 |
| C9 (R:17) | 후진 종료 때 전방을 보지 않고 좌우로 결정 | Left/Right Sensor Input,Direction | 3.1,3.2.1,3.2.2; Front Blocked + Side Situation | T8,T9,T10 | P:264–291, P:319–329, P:474–486, F:71–73 | traced: front=FALSE, sides blocked도 T8; 상위 enum 잔존 없음 |
| C10 (R:18) | 재감지 시 5틱 재시작 | Dust Sensor Input,Tick,Clean | 2,4.1; D2,D3 | 직접 전이 해당 없음: 청소 | E:25–28, P:365–392 | traced: current/pending dust가 잔여 틱보다 우선; 지속 TRUE는 매 Forward Tick 재시작 |
| C11 (R:19) | 회피 중 잔여 파워업 보존·복귀 시 재개 | Movement Status,Clean,Tick | 3.2.3,4.1,4.2; D3 | FSM은 Avoiding/Forward 상태를 제공 | E:28, P:365–395, P:565–579 | traced: 회피 중 감소 없음; C15 감지가 있으면 복귀 때 재시작 우선 |
| C12 (R:20) | 첫 Tick 전 네 센서 실제 값 확보 | 네 Sensor Input,Tick | 0,1,2; D1,D2 초기 샘플 | T1/T2 실행 전 조건; 새 전이 없음 | E:38, P:38–40, P:92–104, P:130–146, L3:127–134 | traced: 미수신 FALSE 금지; 초기 dust TRUE는 pending에 기록 |
| C13 (R:21) | 초기 Forward 상태만 설정; 첫 Tick에 출력 | Tick,Direction,Clean | 0,3.2,3.2.2; D3=0,D4=Idle; no initial output | T0 상태 설정만, 첫 Tick T1 또는 T2 | E:38, P:38–59, P:516, F:25, F:63–65 | traced: Power On은 외부 여덟 번째 이벤트가 아님 |
| C14 (R:22) | Start/Stop 동시 제어, Power Up 흡입만 강화 | Clean | 4,4.2; Clean enum의 효과 | 직접 전이 해당 없음: 출력 의미 | E:16, D:109–117, P:424–444 | traced: 물걸레 강화가 아닌 정상 유지; B6 범위 보존 |
| C15 (R:23) | 회피 먼지 기억 후 복귀 시 5틱 시작·재시작 | Dust Sensor Input,Pending Dust Detection,Clean | 2,4,4.1; D2 두 Boolean,D3 | 직접 전이 해당 없음: 4.1이 새 Movement Status 사용 | R:27–29, L1:33–38, L2:71–107, D:159–178, P:130–142, P:365–395 | traced: TRUE→FALSE도 pending 유지; 반복 감지 합침; 복귀 시 잔여 틱보다 재시작 우선 |
| Q6 (R:42) | 전방이 비면 측면 장애물만으로 회피하지 않는 가정 | Front/Left/Right Sensor Input | 3.1,3.2.2; Front Blocked,Side Situation | T1,T2 | R:42, P:175, P:291, L3:147, F:64–65 | assumption-traced: 미확정. B3의 포괄적 sensors 표현에 대한 현재 해석; 새 결함이나 승인으로 승격하지 않음 |

## 후속 단계 열

현재 Phase 2는 요구사항↔SA 범위다. 아래 열은 모든 행에 적용되며, JSON에는 각 행별로 명시했다. 빈칸이나 통과로 채우지 않는다.

| 행 범위 | SD 모듈/인터페이스 | C symbol | 단위 테스트 | 시스템 테스트 | 실행 근거 |
|---|---|---|---|---|---|
| B1–B7, C1–C15, Q6 | notChecked — Phase 4 | notChecked — Phase 5 | notChecked | notChecked | notRun |

## 지표의 의미

- 요구사항별 SA 근거 연결: **22/22**. B1–B5와 C1–C15의 20개 동작/환경·입력 항목 + B6/B7의 2개 범위 항목을 모두 검토했다.
- Q6는 별도 1행이며 확정 요구사항 분모에 넣지 않는다. B3의 `traced-under-Q6`는 가정에 따른 문서 연결이지 무조건적인 요구 충족 판정이 아니다.
- 22/22는 모든 문서 조합의 교차 연결을 완전 탐색했다는 뜻도, 실제 기능이 100% 구현됐다는 뜻도 아니다. 이번 검토에 명시한 요구사항→관련 SA 근거 묶음의 연결률이다.
- task coverage는 해당 없음. 기존 SASD 문서를 검토하며 Spec Kit용 tasks.md를 새로 만들지 않았다.

