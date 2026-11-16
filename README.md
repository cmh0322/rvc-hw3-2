# RVC 컨트롤러 실습

로봇청소기(RVC)의 자동 이동과 청소 동작을 요구사항에서 출발해 구조적 분석(SA), 구조적 설계(SD), C11 구현과 테스트로 연결하는 소프트웨어공학 프로젝트입니다. [요구사항](docs/preliminary_requirements.md) · [요구사항 보완 결정](docs/requirements_clarifications.md) · [Claude 작업 지침](.claude/skills/)

## 진행 상황

2026년 11월 16일 기준입니다.

| 단계 | 상태 | 산출물 |
|---|---|---|
| 구조적 분석 (SA) | 완료, 승인됨 | [artifacts/SA/](artifacts/SA/) |
| 구조적 설계 (SD) | 완료, 승인됨 | [artifacts/SD/](artifacts/SD/) |
| TDD 구현 (C11) | 완료 | [src/](src/) · [include/](include/) · [tests/](tests/) · [artifacts/Implementation/](artifacts/Implementation/) |
| 시스템 테스트 (웹 시뮬레이터) | 시뮬레이터와 시나리오 21개 완성, 사람의 평가 대기 | [simulator/](simulator/) · [artifacts/SystemTest/](artifacts/SystemTest/) |

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
| C9 | 후진한 뒤에는 좌우만 보고 결정한다. 전방 센서는 보지 않는다. |
| C10 | 파워업 도중 먼지를 다시 감지하면 5틱을 다시 센다. |
| C11 | 회피로 끊긴 파워업은 남은 틱을 유지했다가 전진을 재개하면 이어간다. |

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
| 단위 테스트 (GoogleTest) | 129개 통과, 실패 0 |
| 호출 계층 검사 | Structure Chart의 호출 26개와 컴파일된 코드의 호출 26개가 일치 |
| 라인 커버리지 | 115 / 115 (100%) |
| 분기 커버리지 | 36 / 36 (100%) |
| 컴파일 경고 | 0 (`-Wall -Wextra -Wpedantic -Werror`) |

- 11개 사이클로 나눠 테스트를 먼저 쓰고 실패를 확인한 뒤 구현했습니다. 사이클별 기록은 [test_report.md](artifacts/Implementation/test_report.md)에 있습니다.
- FSM 전이 T0–T14와 요구사항 B1–B5, C1–C3, C5–C11에 각각 대응하는 테스트가 있습니다.
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

## 시스템 테스트 (웹 시뮬레이터)

실제 C 컨트롤러(`main()` 포함)를 백엔드 프로세스로 띄우고, 브라우저의 10x10 지도와 Tick마다 한 줄씩 주고받습니다. 제어 판단은 모두 C 코드가 하고, 브라우저는 지도와 표시만 맡습니다.

```sh
cmake --build build --target rvc_sim_host
node simulator/server.js          # http://localhost:8765
```

- 지도 편집(장애물, 먼지, 시작 위치와 방향), Start / Pause / Step / Step back / Reset / Restart, 재생 속도, 최대 100틱
- 틱마다 위치, 방향, 센서 입력, FSM 상태와 전이, Motor·Cleaner 출력, 두 타이머 값을 표시하고 이력으로 저장
- 시나리오 21개([test_scenarios.md](artifacts/SystemTest/test_scenarios.md)), 요구사항 추적표([requirement_traceability.md](artifacts/SystemTest/requirement_traceability.md))
- PASS / FAIL / INCONCLUSIVE는 사람이 판정합니다. 시뮬레이터는 자동으로 판정하지 않습니다. 현재 21개 모두 평가 대기 상태입니다([test_results.md](artifacts/SystemTest/test_results.md)).
- 지도 규칙(한 틱에 한 칸, 센서는 인접 한 칸, 회전 5틱에 90도)과 한계는 [simulator/README.md](simulator/README.md)에 있습니다.

## 남은 가정

| 항목 | 내용 | 현재 동작 |
|---|---|---|
| Q6 | 전방은 비었고 좌우에만 장애물이 있는 경우 | 무시하고 전진 (가정) |

요구사항이 정하지 않은 상황도 시뮬레이터에서 드러납니다. 좌우가 계속 막힌 통로(ST-06)나 사방이 막힌 칸(ST-21)에서는 C5에 따라 후진 명령을 5틱씩 계속 반복합니다.

## Claude Code 단계별 토큰 사용량

2026년 11월 16일 기준, **Event List 작성부터 웹 시뮬레이터 시스템 테스트 준비까지 Claude가 사용한 토큰은 32,905,896개**입니다. 같은 프로젝트의 Claude 대화 2개에서 작업 요청과 완료 답변을 확인해 집계했습니다.

| 작업 단계 | 모델 응답 수 | 단계 사용량 (토큰) | 누적 사용량 (토큰) |
|---|---:|---:|---:|
| Event List·Context Diagram | 4 | 230,440 | 230,440 |
| DFD 0 | 7 | 569,178 | 799,618 |
| DFD 1 | 9 | 578,615 | 1,378,233 |
| DFD 2 | 6 | 563,172 | 1,941,405 |
| DFD 3 | 6 | 661,025 | 2,602,430 |
| DFD 4 (Controller FSM) | 8 | 1,098,697 | 3,701,127 |
| SA 최종 일관성 검토 | 3 | 463,686 | 4,164,813 |
| SD (변환 분석·구조도) | 20 | 4,575,090 | 8,739,903 |
| Test (TDD 구현·단위 테스트) | 34 | 12,256,249 | 20,996,152 |
| 웹 시뮬레이터 시스템 테스트 | 23 | 11,909,744 | 32,905,896 |

**집계 방법.** 단계 사용량은 해당 작업을 요청한 시점부터 완료 답변까지 기록된 일반 입력, 캐시 쓰기, 캐시 읽기, 출력 토큰의 합입니다. 같은 메시지 ID가 여러 줄에 나타나도 한 번만 셌습니다. 누적 열은 첫 행부터 해당 행까지의 합입니다. 스킬 입력 경로 상담, 사용량만 묻는 대화, README 정리와 GitHub 업로드는 제외했습니다.

- **DFD 0~4**에는 해당 레벨을 작성하면서 함께 고친 요구사항·데이터 사전·프로세스 명세가 포함됩니다. 예전 대화의 DFD 2 수치 1,202,980은 DFD 1부터의 세션 누적이었습니다. 표의 563,172는 DFD 2 작성과 후속 요구사항 C4 반영에 쓴 양입니다. DFD 4 요청 중 함께 고친 DFD 3 내용은 DFD 4에 한 번만 포함했습니다.
- **SA 검토와 SD**는 별도로 셌습니다. DFD·사전·명세 사이의 일관성 확인은 SA 검토에, 변환 분석·구조도 작성과 다이어그램 확인은 SD에 포함했습니다.
- **Test**는 SD 승인 뒤 시작한 TDD 작업과 다음 날 재개한 작업을 합친 값입니다. C11 구현, 단위 테스트, 호출 관계·커버리지 확인, [시험 보고서](artifacts/Implementation/test_report.md) 작성까지 포함합니다.
- **웹 시뮬레이터 시스템 테스트**는 시뮬레이터 요청부터 완료 답변까지입니다. 시뮬레이터와 시나리오 21개 작성, 헤드리스 실행과 브라우저 확인, [시스템 테스트 문서](artifacts/SystemTest/) 작성을 포함합니다. 시작할 때 확정한 요구사항 결정 C9~C11을 코드·테스트·SA·SD 문서에 반영한 작업과, 같은 요청 안에서 한 마지막 커밋·병합도 따로 떼어낼 수 없어 포함했습니다. 사람의 PASS/FAIL 평가는 아직 하지 않았으므로 그 과정의 사용량은 없습니다.
