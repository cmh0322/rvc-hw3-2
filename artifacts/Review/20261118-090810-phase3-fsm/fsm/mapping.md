# SA → Promela 대응 및 모델 적합성 검토

범위: 이동 FSM + D4 + 입력 분류 + 이동 출력. 생산 C를 읽거나 복제하여 만든 모델이 아니다. 원본과 해시는 `../input-manifest.json`, 줄 번호가 붙은 입력은 `source-snapshot.md`에 보관한다.

## T0–T14

원본 위치는 `artifacts/SA/DFD/dfd_level_4_fsm.md`이며, 모델 위치는 `model.pml`이다. `verify_outputs.py`가 T1–T14의 상태·조건·행동·타이머 시작 여부를 원문 표에서 읽어 비교했다. T0의 출력 없음과 초기값은 별도 assertion 및 원문 대조로 확인했다.

| ID | 원문 줄 | 모델 줄 | 상태 | 조건 | 행동 | 다음 상태 | 요구사항 |
|---|---:|---:|---|---|---|---|---|
| T0 | 63 | 51 | [*] | Before first Tick | Set state only; no Movement Command or Start Step Timer | Forward | C13 |
| T1 | 64 | 110 | Forward | not Front Blocked | Forward | Forward | B2, C16 |
| T2 | 65 | 111 | Forward | Front Blocked | Stop, Start Step Timer | Stopping | B3, C2, C7, C16 |
| T3 | 66 | 112 | Stopping | not Step Done | Stop | Stopping | C7 |
| T4 | 67 | 113 | Stopping | Step Done and Right Open | Turn Right, Start Step Timer | TurningRight | B3, C1, C8 |
| T5 | 68 | 114 | Stopping | Step Done and Left Open | Turn Left, Start Step Timer | TurningLeft | B3, C8 |
| T6 | 69 | 115 | Stopping | Step Done and Sides Blocked | Backward, Start Step Timer | Backing | B4, C6 |
| T7 | 70 | 116 | Backing | not Step Done | Backward | Backing | C6 |
| T8 | 71 | 117 | Backing | Step Done and Sides Blocked | Backward, Start Step Timer | Backing | C5, C6, C9 |
| T9 | 72 | 118 | Backing | Step Done and Right Open | Turn Right, Start Step Timer | TurningRight | C5, C8, C9 |
| T10 | 73 | 119 | Backing | Step Done and Left Open | Turn Left, Start Step Timer | TurningLeft | C5, C8, C9 |
| T11 | 74 | 120 | TurningRight | not Step Done | Turn Right | TurningRight | C8 |
| T12 | 75 | 121 | TurningRight | Step Done | Forward | Forward | B3, B4, C8 |
| T13 | 76 | 122 | TurningLeft | not Step Done | Turn Left | TurningLeft | C8 |
| T14 | 77 | 123 | TurningLeft | Step Done | Forward | Forward | B3, B4, C8 |

## 타이머·입출력·환경

- `elapsed=IDLE(6)`은 실행 중인 타이머가 없다는 모델 표현이다. SA의 Idle과 정수 0을 구별한다. 증가 중 5에 도달하면 Done을 발생시키고 바로 Idle로 돌린다. 명령이 새 단계를 시작하면 같은 Tick 뒤쪽에서 0으로 설정한다. PSPEC 3.2.4(`process_specification.md:609` 이후)와 Level 3 실행 순서(`dfd_level_3.md:125` 이후)에 대응한다.
- `remaining`은 검증용 감소 계수다. 시작 명령이 발생한 Tick을 포함하여 5로 설정하며 이후 Tick마다 1씩 감소한다. `done == (previous != Forward && remaining == 0)` 및 Tick 종료 시 `remaining == 5-elapsed`로 5틱 경계를 검사한다. 생산 데이터나 추가 요구사항이 아니다.
- `sampled`는 네 센서 읽기 완료 비트다. 초기 샘플을 모두 받은 뒤 첫 Tick을 처리하며 그 샘플을 첫 판단에 사용한다. 이후 Tick은 마지막 센서값을 비결정적으로 선택한다. 초기 저장소의 0을 실제 미수신 센서값으로 사용하지 않는다. 이는 C12의 순서를 모델링한 것이며 실제 센서 드라이버의 검증은 아니다.
- P3.1은 우측이 비면 RightOpen, 우측만 막히고 좌측이 비면 LeftOpen, 양쪽이 막히면 SidesBlocked로 분류한다. PSPEC 3.1과 Dictionary Obstacle Situation에 대응하며, 전방값과 독립적으로 분류한다.
- `direction=command`, `avoiding=(command!=GoForward)`는 PSPEC 3.2.3(`process_specification.md:565` 이후)의 출력 의미다. `NoCommand`는 초기 무출력을 표현하기 위한 모델 전용 값이다.
- C13의 초기 Clean 무출력만 sentinel로 표시했다. 첫 Tick 이후 Clean, D2 pending dust, D3, suction/mop 동작은 생성하지 않았다. 따라서 C16의 **이동 분기**를 검사했으며 청소 지속 자체는 이번 모델의 검증 결과가 아니다.
- 전체 Tick을 하나의 `atomic` 구간으로 모델링한다. assertions는 순서에 맞는 지점에서 실행하며, LTL은 `stable`인 Tick 결과에만 조건을 건다. 다른 프로세스나 인터럽트의 중간 관찰·실시간 지연은 범위 밖이다.
- 기본 환경은 Stopping에서 front=true인 SA C4 해석만 제약한다(`dfd_level_3.md:94`, FSM Validation). 좌우·먼지는 자유롭게 변하며 이동/회전 중 전방도 자유롭게 변한다. 고정 장애물 지도를 구현한 모델이 아니라 가능한 입력을 넓힌 추상화다. 특히 정지 중 좌우가 달라지는 경로도 허용하므로 모든 경로를 물리적 경로라고 해석하면 안 된다.
- `robust-unconstrained-front`는 그 front 제약까지 제거한 추가 안전성 검사다. 안전성 결과는 이 더 넓은 입력에서도 유지되었지만, C4를 폐기하거나 새로운 환경 동작을 요구사항으로 추가한 것은 아니다.
- Tick 루프는 계속 실행한다. fairness 옵션 없음. 프로세스가 하나이며 외부 환경이 Tick 제공을 영구 중단하는 상황은 모델링하지 않는다. 후진 종료 결정 때 양옆이 계속 막힐 수 있고, 센서가 언젠가 비워진다는 공정성은 가정하지 않는다.

## SD와의 관계

SD `structure_chart.md:389`의 Advance Step Timer → 전이 선택 순서는 최신 SA와 일치하여 대조했다. 그러나 `:257`, `:386`, `:404`의 초기 Forward 출력은 C13과 다르다. 모델은 최신 요구사항/SA를 따른다. 이 알려진 개정 전 SD 설명은 Phase 4에서 수정·승인해야 하며 모델 통과로 SD 준수를 승인하지 않는다.

## 적합성 검토 판정

주 검토자가 원문·15개 전이 대응·타이머 경계·원시 입력 기반 postconditions를 대조했다. `verify_outputs.py`의 대응 검사와 4개 변형 모델의 검출을 추가 근거로 사용했다. 독립 검토 에이전트의 검토는 수행하지 않았다. 입력을 넓힌 유한 모델에 대한 결과이며 물리적 충돌 방지, 실제 C, 청소 합성 시스템까지 증명하지 않는다.
