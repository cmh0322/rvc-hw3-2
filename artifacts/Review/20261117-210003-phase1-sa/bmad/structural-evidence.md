# Phase 1 구조 확인 근거

입력 버전은 [manifest](input-manifest.json)와 같다. `verification/check_documents.py`는 Mermaid의 실제 화살표를 읽어 각 부모 경계의 `(방향, 흐름명, data/control, 외부 상대)` 집합을 비교했다. 자식 도표의 `P4ext`/`P3ext`/`P31ext`는 해당 형제 프로세스의 별칭으로 정규화했다. 동일 Tick의 fan-out은 한 경계 이벤트로 취급한다. 내부 저장소는 해당 부모 내부 집합에 포함한다.

## 부모별 경계

| 비교 | 입력 집합 | 출력 집합 | 문서 대조 결과 |
|---|---|---|---|
| Context ↔ Level 0 | Front/Left/Right/Dust Sensor Input, Tick | Direction, Clean | 7개 일치 |
| Process 0 ↔ Level 1 | 위와 같음 | 위와 같음 | 7개 일치; D1/D2 및 Movement Status는 내부 |
| Process 3 ↔ 3.1·3.2 | D1의 Obstacle Location, Tick | Motor로 Direction, Process 4로 Movement Status | 4개 일치; Obstacle Situation은 내부 |
| Process 4 ↔ 4.1·4.2 | D2의 Dust Existence, Process 3의 Movement Status, Tick | Cleaner로 Clean | 4개 일치; D3/Remaining Power-Up Ticks/Power-Up Active는 내부 |
| Process 3.2 ↔ 3.2.1–3.2.4 | Process 3.1의 Obstacle Situation, Tick | Motor로 Direction, Process 4로 Movement Status | 4개 일치; D4 및 Controller 제어 흐름은 내부 |

근거 위치: Context:22–28; Level 0:22–28; Level 1:25–41; Level 2:27–33,75–83; Level 3:31–42. 정확한 추출 집합은 [JSON](../verification/document-checks.json)에 있다. **P1-01의 Obstacle Situation 의미 불일치는 이 집합 비교로 검출되지 않으며 별도 수동 검토에서 확인했다.**

## 프로세스·흐름·저장소

- 프로세스 13개: 0, 1, 2, 3, 4, 3.1, 3.2, 4.1, 4.2, 3.2.1, 3.2.2, 3.2.3, 3.2.4. 모두 `process_specification.md`에 절이 있다. 3.2.2는 Level 3 Controller 계약이며 Level 4 FSM 전용 PSPEC이 아니다.
- 흐름 18개: 외부 7개 및 Obstacle Location, Dust Existence, Movement Status, Obstacle Situation, Situation Signal, Movement Command, Start Step Timer, Step Done, Step Ticks Elapsed, Power-Up Active, Remaining Power-Up Ticks. 사전 항목 존재를 확인했다.

| 저장소 | 최종 분해 기준 writer / reader | 자료형 | 최초 상태의 SA 명세 |
|---|---|---|---|
| D1 | 1 / 3.1 | front·left·right Boolean 레코드 | 미정의 — P1-04 |
| D2 | 2 / 4.1 | dust Boolean | 미정의 — P1-04 |
| D3 | 4.1 / 4.1 | 잔여 틱 0–5 | 미정의 — P1-03 |
| D4 | 3.2.4 / 3.2.4 | Idle 또는 경과 틱 0–5 | Idle, PSPEC:697 |

## FSM 문서와 한 Tick 순서

Level 3:125–131과 PSPEC 3.2.4를 대조했다: 3.1 분류 → 3.2.1 신호 → D4 advance → FSM 전이 → 이동 출력/상태 → 4.1(D3) → 4.2(Clean). StartTimer는 전이 중 D4를 0으로 설정하므로 같은 Tick에 다시 advance하지 않는다.

문서의 분기 범위는 Forward에서 front Boolean, Stopping/Backing에서 Done Boolean과 배타적인 3개 Side Situation, 두 Turning 상태에서 Done Boolean이다. 해당 입력 계약 내에서는 표에 분기가 있다. C9로 Backing 종료는 front를 사용하지 않는다. C4는 물리 장애물이 사라지지 않는다는 조건이며 이동 후 센서값 고정을 의미하지 않는다. T8의 반복은 C5가 허용하므로 결함으로 삼지 않았다.

Level 4의 초기 진입 T0는 별도의 의미 확인 사항(P1-05)이다. SPIN/시간 진행/도달 가능성 검사를 실행하지 않았으므로 이 문서를 형식 검증 증거로 사용하지 않는다.
