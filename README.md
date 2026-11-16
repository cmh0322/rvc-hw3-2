# RVC 컨트롤러 실습

로봇청소기(RVC)의 자동 이동과 청소 동작을 요구사항에서 출발해 구조적 분석(SA), 구조적 설계(SD), C11 구현과 테스트로 연결하는 소프트웨어공학 프로젝트입니다. [요구사항](docs/preliminary_requirements.md) · [요구사항 보완 결정](docs/requirements_clarifications.md) · [Claude 작업 지침](.claude/skills/)

## 진행 상황

2026년 11월 16일 기준입니다.

| 단계 | 상태 | 산출물 |
|---|---|---|
| 구조적 분석 (SA) | 완료, 승인됨 | [artifacts/SA/](artifacts/SA/) |
| 구조적 설계 (SD) | 완료, 승인됨 | [artifacts/SD/](artifacts/SD/) |
| TDD 구현 (C11) | 완료, 승인 대기 | [src/](src/) · [include/](include/) · [tests/](tests/) · [artifacts/Implementation/](artifacts/Implementation/) |
| 시스템 테스트 (웹 시뮬레이터) | 시작 전 | — |

## 구조적 분석 (SA)

| 산출물 | 내용 |
|---|---|
| [Event List](artifacts/SA/event_list.md), [Context Diagram](artifacts/SA/context_diagram.md) | 입력 5개(전방·좌측·우측·먼지 센서, Tick)와 출력 2개(Direction, Clean) |
| [DFD Level 0](artifacts/SA/DFD/dfd_level_0.md) | 프로세스 0: RVC Controller |
| [DFD Level 1](artifacts/SA/DFD/dfd_level_1.md) | 1 Detect Obstacle, 2 Detect Dust, 3 Control Movement, 4 Control Cleaning. 데이터 저장소 D1, D2 |
| [DFD Level 2](artifacts/SA/DFD/dfd_level_2.md) | 3을 3.1·3.2로, 4를 4.1·4.2로 분해. 데이터 저장소 D3(파워업 타이머) |
| [DFD Level 3](artifacts/SA/DFD/dfd_level_3.md) | 3.2를 3.2.1–3.2.4로 분해. 제어 프로세스 3.2.2 Movement Controller와 D4(단계 타이머) |
| [DFD Level 4 (FSM)](artifacts/SA/DFD/dfd_level_4_fsm.md) | Movement Controller의 상태 5개(Forward, Stopping, Backing, TurningRight, TurningLeft)와 전이 T0–T14 |
| [Data Dictionary](artifacts/SA/data_dictionary.md), [Process Specification](artifacts/SA/process_specification.md) | DFD 레벨마다 함께 갱신 |

분석 중에 확정한 요구사항 보완 결정입니다. 전체 내용은 [requirements_clarifications.md](docs/requirements_clarifications.md)에 있습니다.

| ID | 결정 |
|---|---|
| C1 | 전방에 장애물이 있고 좌우가 모두 비어 있으면 우회전한다. |
| C2 | 장애물을 만나면 먼저 정지한다. |
| C3 | 먼지를 감지하면 5틱 동안 청소를 강화한다. |
| C4 | 장애물은 사라지지 않는다. |
| C5 | 후진한 뒤 오른쪽이 비면 우회전, 왼쪽만 비면 좌회전, 둘 다 막혀 있으면 다시 후진한다. |
| C6, C7, C8 | 후진, 정지, 회전은 각각 5틱 동안 한다. |

## 구조적 설계 (SD)

- [Transform Analysis](artifacts/SD/transform_analysis.md): DFD의 leaf 프로세스를 입력(Afferent), 처리(Central), 출력(Efferent) 영역으로 나눴습니다.
- [Structure Chart](artifacts/SD/structure_chart.md): 모듈 19개와 하드웨어 인터페이스 라이브러리 모듈 7개의 호출 계층, 모듈 인터페이스, SA 추적표입니다.

```
Main
├─ Initialize RVC
├─ [[Wait For Tick]]
└─ Controller                 (Tick마다 1회)
    ├─ Get Inputs             Detect Obstacle, Assess Obstacle Situation, Detect Dust
    ├─ Decide Actions         Movement Controller(FSM), Derive Movement Status,
    │                         Track Power-Up, Decide Cleaning
    └─ Put Outputs            Issue Movement Output, [[Drive Cleaner]]
```

틱 사이에 유지되는 데이터(FSM 상태, D3, D4)는 각각 그것을 쓰는 모듈 그룹 안에 숨겼고, 전역 데이터는 없습니다.

## 구현과 테스트 (TDD)

Structure Chart의 모듈 하나를 C 함수 하나로 구현했습니다. 하드웨어 인터페이스 7개는 [hw_interface.h](include/hw_interface.h)에 선언만 있고 구현은 없습니다(요구사항상 하드웨어 세부는 범위 밖). 그래서 실행 파일은 만들지 않고, 테스트에서는 가짜 하드웨어([fake_hw.cpp](tests/fake_hw.cpp))를 씁니다.

| 항목 | 결과 |
|---|---|
| 단위 테스트 (GoogleTest) | 121개 통과, 실패 0 |
| 호출 계층 검사 | Structure Chart의 호출 26개와 컴파일된 코드의 호출 26개가 일치 |
| 라인 커버리지 | 116 / 116 (100%) |
| 분기 커버리지 | 40 / 40 (100%) |
| 컴파일 경고 | 0 (`-Wall -Wextra -Wpedantic -Werror`) |

- 10개 사이클로 나눠 테스트를 먼저 쓰고 실패를 확인한 뒤 구현했습니다. 사이클별 기록은 [test_report.md](artifacts/Implementation/test_report.md)에 있습니다.
- FSM 전이 T0–T14와 요구사항 B1–B5, C1–C3, C5–C8에 각각 대응하는 테스트가 있습니다.
- 관련 문서: [coverage_report.md](artifacts/Implementation/coverage_report.md), [module_traceability.md](artifacts/Implementation/module_traceability.md)

### 빌드와 테스트

GCC 10 이상, CMake 3.20 이상, Ninja, GoogleTest가 필요합니다. Windows에서는 MSYS2 mingw64 환경을 썼고, 그 `bin` 폴더가 PATH 맨 앞에 있어야 합니다.

```sh
cmake -S . -B build -G Ninja
cmake --build build
ctest --test-dir build --output-on-failure
cmake --build build --target coverage     # build/coverage/summary.md 생성
```

프로젝트 경로에 한글이 있으면 `ctest`만으로는 커버리지 데이터가 생기지 않습니다. 커버리지는 `coverage` 타깃으로 측정하세요.

## 결정이 필요한 것

시스템 테스트 전에 정해야 합니다. 지금 코드의 동작은 임시이고, "요구사항 아님"으로 표시한 테스트로만 기록되어 있습니다.

| 항목 | 내용 | 현재 동작 |
|---|---|---|
| G1 | 후진이 끝났을 때 전방 센서가 비어 있음으로 읽히는 경우. FSM에 전이가 없다. | 우회전 |
| Q4 | 파워업 도중 먼지를 다시 감지한 경우 | 카운트를 다시 세지 않음 |
| Q5 | 장애물 회피로 파워업이 끊긴 경우 | 남은 카운트를 유지 |
| Q6 | 전방은 비었고 좌우에만 장애물이 있는 경우 | 무시하고 전진 |

G1의 배경과 선택지는 [test_report.md](artifacts/Implementation/test_report.md) 6절에 있습니다.

## AI 토큰 사용량

**2026년 11월 15일 23:29:09 (한국시간) 현재, 이 컴퓨터에서 확인한 프로젝트 누적 사용량은 26,890,296토큰입니다.** 캐시에서 다시 읽은 입력도 포함한 처리량이며, 요금이나 구독 한도 소모량을 의미하지 않습니다.

| 도구 | 집계 범위 | 토큰 |
|---|---|---:|
| Claude Code | 프로젝트 세션 2개 | 22,515,998 |
| Codex | 현재 대화 | 3,073,069 |
| Codex | 같은 프로젝트의 다른 대화 2개 | 1,301,229 |
| **전체** | **Claude Code와 Codex 합계** | **26,890,296** |

### Claude Code

| 세션 시작일 (한국시간) | 일반 입력 | 캐시 쓰기 | 캐시 읽기 | 출력 | 합계 |
|---|---:|---:|---:|---:|---:|
| 11월 6일 | 1,339 | 392,813 | 6,173,275 | 85,960 | 6,653,387 |
| 11월 8일 | 1,353 | 462,430 | 15,146,167 | 252,661 | 15,862,611 |
| **Claude Code 전체** | 2,692 | 855,243 | 21,319,442 | 338,621 | 22,515,998 |

각 세션에서 마지막으로 저장된 사용량 요약(`cost-state.modelUsage`)을 한 번만 사용했습니다. 11월 8일 시작 세션은 마지막 요약 이후에도 진행되어, 그 뒤의 모델 응답 46건을 요청 ID와 메시지 ID 조합으로 중복 제거해 더했습니다. 요약에 포함된 하위 에이전트 사용량과 출력에 포함된 추론 토큰은 다시 더하지 않았습니다.

### Codex

현재 대화의 마지막 누계(`total_token_usage`)는 입력 3,051,912토큰과 출력 21,157토큰입니다. 입력 중 2,774,528토큰은 캐시 읽기이므로 입력에 이미 포함됩니다. 나머지 두 대화는 프로젝트별 로컬 색인에 남은 총량 91,359토큰과 1,209,870토큰을 사용했습니다. 두 대화는 상세 로그를 확인할 수 없어 입력·출력 비율을 추정하지 않았습니다.

이 수치는 집계 시점의 스냅샷입니다. 다른 컴퓨터나 팀원 계정의 사용량, 로컬 기록이 남지 않은 호출, 집계 이후의 대화는 범위 밖입니다.
