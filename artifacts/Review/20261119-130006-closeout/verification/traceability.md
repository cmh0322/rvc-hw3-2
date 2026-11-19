# P2-I01 참조 정리 검증

범위는 요약 요구사항 참조 두 줄이다. 새 요구사항·SA 동작·C를 변경하지 않는다. 원문 본문과 확정 요구사항을 대조하고 요약의 누락을 연결했다. 전체 BMAD/Spec Kit/모델 검사를 재실행한 것으로 표현하지 않는다.

| 요구사항 | 이미 존재한 본문 근거 | 보완한 요약 | downstream 근거 |
|---|---|---|---|
| C9 | PSPEC3.2.1은 Front Blocked + Side Situation을 그대로 전달한다. PSPEC3.2.2/FSM은 후진 후 front를 쓰지 않는다. | DFD3 Process3.2.1 Requirements에 C9 추가 | SD Decide Actions의 SituationSignal 전달, C assess_obstacle_situation/movement_controller |
| C12 | PSPEC3.2.2 Processing Logic: Initial sensor sampling precedes the first Tick (C12). | 같은 Process의 Relevant Requirements 목록에 C12 추가 | SD Acquire Initial Inputs; C acquire_initial_inputs/inputs_ready |
| C13 | PSPEC3.2.2 Processing Logic: Initialization sets Forward without output (C13). | 같은 Process의 Relevant Requirements 목록에 C13 추가 | SD T0/state-only reset; C initialize_rvc/reset_movement_controller |

중복: 새 요구사항 행을 만들지 않았다. 모호함: C9는 후진 판단이고 C16의 Forward 진입과 구분한다. 불충분 명세: 본문 동작은 이미 존재한다. 규칙 정합성: SA→SD→C 순서·승인 경계를 바꾸지 않는다. 누락: 해당 요약 참조의 C9/C12/C13을 추가했다. 불일치: 요약과 본문을 맞췄다. 이 좁은 범위의 여섯 관점 대조이며 전 요구사항의 새 정량 커버리지 판정은 아니다.

기계 점검은 수정 전 스냅샷과 정확히 두 문자열만 다름, Mermaid 블록 동일, 다른84개 Phase6 입력 중 나머지82개 불변을 확인한다. 라벨만 바뀌므로 다이어그램 재렌더링·생산 단위 테스트·SPIN을 새로 실행하지 않는다. 기존 실행 결과는 20261119-115842-phase6-final의 당시 증거다.
