# Phase 2 역방향 추적

목적: SA 항목에서 원본 요구사항/결정으로 돌아가는 근거를 확인한다. 번호 개수 일치만으로 의미를 판정하지 않았으며 아래 역할을 원문과 대조했다. 과거 SD/C는 범위 밖이다. Q6는 확정 요구사항이 아닌 가정이다.

## 흐름 19개

원문: Data Dictionary:49–277, Context:24–30, Level 1:27–46, Level 2:28–33/71–79, Level 3:33–43. 파일 경로 약어는 [정방향 매트릭스](matrix.md)의 출처 목록을 따른다.

| 항목 | 근거 요구사항/가정 | 대조한 의미 |
|---|---|---|
| Front Sensor Input | B3,B4,C12,Q6 | 외부→1→D1; Q6는 가정 |
| Left Sensor Input | B3,B4,C1,C5,C9,C12 | 외부→1→D1 |
| Right Sensor Input | B3,B4,C1,C5,C9,C12 | 외부→1→D1 |
| Dust Sensor Input | B5,C10,C12,C15 | 외부→2→D2; TRUE를 pending으로 기억 |
| Tick | C3,C6,C7,C8,C12,C13 | 시간 기준; 초기화와 구별 |
| Direction | B2,B3,B4,C1,C2,C5,C6,C7,C8,C9,C13 | 3.2.3→Motor |
| Clean | B1,B2,B3,B5,C14 | 4.2→Cleaner; 흡입·물걸레 의미 |
| Obstacle Location | B3,B4,C12 | 1→D1→3.1의 실제 센서값 |
| Dust Existence | B5,C12,C15 | 2↔D2 및 D2→4.1; 현재값+pending |
| Movement Status | B2,B3,B4,C11,C15 | 3.2.3→4.1/4.2; Forward/Avoiding |
| Obstacle Situation | B3,B4,C1,C9 | front Boolean+side enum |
| Situation Signal | B3,B4,C1,C9 | 3.2.1→3.2.2; 동일 의미의 제어 표현 |
| Movement Command | B2,B3,B4,C13 | 3.2.2→3.2.3; 초기화 출력 없음 |
| Start Step Timer | C6,C7,C8 | 3.2.2→3.2.4 |
| Step Done | C6,C7,C8 | 3.2.4→3.2.2 |
| Step Ticks Elapsed | C6,C7,C8 | 3.2.4↔D4 |
| Power-Up Active | B5,C3,C10,C11,C15 | 4.1→4.2; 이번 틱 출력 결정 |
| Remaining Power-Up Ticks | B5,C3,C10,C11,C15 | 4.1↔D3; 현재 틱 차감 |
| Pending Dust Detection | B5,C10,C11,C15 | 4.1→D2 필드 갱신; 2는 record를 통해 set |

## 프로세스 13개

원문: Process Specification의 각 Process 절(0–3). 파일 경로 약어는 [정방향 매트릭스](matrix.md)의 출처 목록을 따른다.

| 항목 | 근거 요구사항/가정 | 대조한 의미 |
|---|---|---|
| 0 | B1,B2,B3,B4,B5,B6,B7,C12,C13,C14,C15 | 시스템 경계·초기화·Tick 조정 |
| 1 | B3,B4,C1,C12 | 장애물 센서별 갱신 |
| 2 | B5,C12,C15 | 현재 먼지와 미처리 감지 기록 |
| 3 | B2,B3,B4,C1,C2,C4,C5,C6,C7,C8,C9,C13 | 분류와 상태 기반 이동 |
| 4 | B1,B2,B3,B5,C3,C10,C11,C14,C15 | 파워업과 청소 명령 조정 |
| 3.1 | B3,B4,C1,C9 | 전방과 독립적인 우측 우선 side 분류 |
| 3.2 | B2,B3,B4,C1,C2,C4,C5,C6,C7,C8,C9,C13 | 이동 상태·타이머 순서 |
| 4.1 | B5,C3,C10,C11,C12,C15 | 파워업 count 및 pending 소비 |
| 4.2 | B1,B2,B3,B5,C14 | Clean 명령 선택 |
| 3.2.1 | B3,B4,C1,C9 | record를 제어 신호로 전달 |
| 3.2.2 | B2,B3,B4,C1,C2,C4,C5,C6,C7,C8,C9,C12,C13 | Movement Controller |
| 3.2.3 | B2,B3,B4 | 명령→Direction/Movement Status |
| 3.2.4 | C6,C7,C8 | 5틱 경과 산술 |

## 저장소 4개

원문: Data Dictionary:149–178,210–218,270–277; PSPEC:38,637. 파일 경로 약어는 [정방향 매트릭스](matrix.md)의 출처 목록을 따른다.

| 항목 | 근거 요구사항/가정 | 대조한 의미 |
|---|---|---|
| D1 | B3,B4,C12 | 3개 실제 장애물 읽기 |
| D2 | B5,C10,C12,C15 | current+pending; 2 set/4.1 consume |
| D3 | B5,C3,C10,C11,C15 | 초기0, 잔여 틱, 회피 중 유지 |
| D4 | C6,C7,C8 | 초기Idle, 이동 스텝 경과 |

## 상태 5개

원문: Level 4:49–55. 파일 경로 약어는 [정방향 매트릭스](matrix.md)의 출처 목록을 따른다.

| 항목 | 근거 요구사항/가정 | 대조한 의미 |
|---|---|---|
| Forward | B2,B3,C13 | 초기 출력 없음, 이후 전진 |
| Stopping | B3,C2,C7 | 5틱 정지 |
| Backing | B4,C5,C6,C9 | 5틱 후진/반복 |
| TurningRight | B3,B4,C1,C8 | 오른쪽 회전 지속 |
| TurningLeft | B3,B4,C5,C8 | 왼쪽 회전 지속 |

## 초기화 포함 전이 15개

원문: Level 4:63–77. 파일 경로 약어는 [정방향 매트릭스](matrix.md)의 출처 목록을 따른다.

| 항목 | 근거 요구사항/가정 | 대조한 의미 |
|---|---|---|
| T0 | C13 | 내부 초기화, 출력 없음 |
| T1 | B2,Q6 | front clear인 Forward 유지 |
| T2 | B3,C2,C7 | front blocked면 정지 시작 |
| T3 | C7 | 정지 유지 |
| T4 | B3,C1,C8 | 정지 완료 후 우회전 |
| T5 | B3,C8 | 정지 완료 후 좌회전 |
| T6 | B4,C6 | 정지 완료+양측 차단 후 후진 |
| T7 | C6 | 후진 유지 |
| T8 | C5,C6,C9 | 후진 완료+양측 차단 후 재후진 |
| T9 | C5,C8,C9 | 후진 완료 후 우회전 |
| T10 | C5,C8,C9 | 후진 완료 후 좌회전 |
| T11 | C8 | 우회전 유지 |
| T12 | B3,B4,C8 | 우회전 완료 후 Forward |
| T13 | C8 | 좌회전 유지 |
| T14 | B3,B4,C8 | 좌회전 완료 후 Forward |

## 분석상 구체화의 근거

| 구체화 | 출처 | 판정 |
|---|---|---|
| D2 pending을 Boolean으로 기억하고 여러 감지를 합침 | C15 및 requirements_clarifications:27–29 | 재시작 한 번을 실현하는 데이터 표현; 감지 횟수만큼 기간을 누적하지 않음 |
| 센서 갱신과 Tick의 논리적 직렬화 | PSPEC:38–40,130–142,395; C12/C15 | 첫 샘플과 감지 보존을 위한 분석 순서. 실제 하드웨어 동기화 방법을 확정한 것은 아님 |
| Forward만 front로 회피 진입 | Q6, PSPEC:175,291 | 조건부 가정. C9의 후진 종료 side 판단에 확장하지 않음 |
| 정지 중 전방 유지, 이동 후 front 변경 가능 | C4/C9, Level 3:96–97 | 모델 환경 전제. 모든 센서값을 영구 고정하지 않음 |
| 회전 방향을 별도 두 상태로 보존 | C8, Level 4:57 | 5틱 동안 같은 회전 방향을 유지하는 분석 표현 |
| D3와 D4 분리 | C3/C6-C8/C11, Level 3:64, PSPEC:365–398,613–637 | 청소 잔여 틱과 이동 경과 틱의 서로 다른 생명주기 |

위 범위의 항목에서 근거가 없는 새 외부 기능은 찾지 못했다. 하드웨어 고장·시간 제한·물리 충돌 자유·항상 전진으로 복귀한다는 성질은 원 요구사항에 없는 추가 의무로 만들지 않았다. 센서 receipt를 생략하는 Tick-only 모델은 C15의 틱 사이 TRUE→FALSE를 표현하지 못할 수 있으므로 Phase 3 합성 모델 범위에서 구별해야 한다.

