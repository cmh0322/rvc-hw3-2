# RVC 컨트롤러 실습

로봇청소기(RVC)의 자동 이동과 청소 동작을 요구사항에서 출발해 구조적 분석(SA), 구조적 설계(SD), C11 구현과 테스트로 연결하는 소프트웨어공학 프로젝트입니다. [요구사항](docs/preliminary_requirements.md) · [요구사항 보완 결정](docs/requirements_clarifications.md) · [Claude 작업 지침](.claude/skills/)

## 진행 상황

2026년 11월 16일 기준입니다.

아래 완료·승인 표시는 개정 전 작업 이력입니다. **2026-11-17 Phase 1 답변(C12–C15)을 요구사항과 SA에 반영했으며, SD·C·테스트·시뮬레이터의 후속 반영은 아직 진행하지 않았습니다.** 현재 검증 상태는 [QA.md](QA.md)를 참고하세요.

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
| Q6 | 전방은 비었고 좌우에만 장애물이 있는 경우 | 전진·청소 유지 (C16으로 확정, 전방 장애물만 회피 시작) |

요구사항이 정하지 않은 상황도 시뮬레이터에서 드러납니다. 좌우가 계속 막힌 통로(ST-06)나 사방이 막힌 칸(ST-21)에서는 C5에 따라 후진 명령을 5틱씩 계속 반복합니다.

## Codex를 이용한 독립 검증과 보강

2026년 11월 17일부터 Claude로 작성한 RVC 산출물을 Codex에서 다시 검토하는 절차를 준비합니다. 요구사항과 승인된 산출물을 기준으로 오류·누락·모순을 찾아 보강하며, 기존 SASD-Guided SDD 절차와 [AGENTS.md](AGENTS.md)의 단계별 사람 승인 규칙을 유지합니다.

**2026-11-17: Phase 1 리뷰의 7개 항목에 대해 사용자 답변과 SA 수정을 반영하고 문서 재점검을 마쳤습니다.** [QA 계획·진행 기록](QA.md), [최초 Phase 1 보고서](artifacts/Review/20261117-210003-phase1-sa/bmad/report.md), [수정·재검증 기록](artifacts/Review/20261117-211457-phase1-fixes/verification/report.md)을 참고하세요. 독립 재검토자 실행은 한도로 완료되지 않아 주 검토자가 순차 검토했습니다. 기존 테스트 수치와 승인 이력은 개정된 SA의 구현·실행 검증 결과가 아닙니다.

### 도구별 역할

**Q6 후속 확정:** 사용자 답변을 C16으로 기록했습니다. 전진 중에는 전방 장애물만 회피를 시작하며, 좌우만 막히면 전진·청소를 유지합니다. 기존 SA 동작은 같고 C9도 유지합니다. 최신 결정·검증 기록은 [QA.md](QA.md#q6-확정--2026-11-17)를 참고하세요.

**Phase 4 SA↔SD 검토 완료 (2026-11-18):** BMAD 3개 독립 관점과 RVC-adapted Spec Kit으로 검토했습니다. 초기 출력·초기 샘플·먼지 보존/수신·C16 상태의 필수 정리 5개와 선택적 문구 정리 1개를 기록했습니다. SD 원문 수정과 승인은 아직이며, 해결 후 Phase 5로 진행합니다. [Phase 4 보고서](artifacts/Review/20261118-093338-phase4-sd/bmad/report.md) · [추적표](artifacts/Review/20261118-093338-phase4-sd/traceability/matrix.md).

**Phase 3 이동 FSM 검증 완료 (2026-11-18):** SPIN으로 안전성·활성성 4개를 완전 탐색했고 T0–T14와 5개 상태의 도달 경로를 확인했습니다. 반복 후진은 C5/C9의 허용 동작입니다. 기존 SD 초기 출력 설명은 C13과 달라 Phase 4에서 정리해야 합니다. 청소 모델·실제 C·웹 시스템 검증은 별도입니다. [Phase 3 보고서](artifacts/Review/20261118-090810-phase3-fsm/fsm/report.md) · [진행 기록](QA.md).

**Phase 2 추적성 검토도 완료했습니다.** B1–B7/C1–C15의 22개 항목 모두 SA 근거에 연결되며, 당시 Q6는 가정으로 유지하고 요약 참조의 LOW 선택적 개선 1개를 기록했습니다. [Phase 2 보고서](artifacts/Review/20261117-212640-phase2-traceability/traceability/report.md) · [추적 매트릭스](artifacts/Review/20261117-212640-phase2-traceability/traceability/matrix.md). 문서 연결 확인이며 SD·C 준수, 테스트·SPIN 성공을 뜻하지 않습니다.

| 도구 | Codex에 맡길 검토 | RVC 적용 대상 | 적용 범위와 한계 |
|---|---|---|---|
| [BMAD Method](https://github.com/bmad-code-org/BMAD-METHOD) — `bmad-review` | 반론 중심 검토, 경계조건 탐색, 문서 구조 검토. 코드 검토에는 검증 누락 관점도 적용 | 요구사항, Event List, Context, DFD, Data Dictionary, Process Specifications, Transform Analysis, Structure Chart | SASD 체크리스트를 함께 전달한다. 일반 문서 구조 검토만으로 DFD balancing이나 모듈 설계의 타당성을 검증했다고 판단하지 않는다. |
| [GitHub Spec Kit](https://github.com/github/spec-kit) — `speckit-analyze`, `speckit-checklist` | 문서 간 모순·중복·모호함·누락 및 요구사항 추적성 분석 | 요구사항 ↔ SA ↔ SD | 원본은 `spec.md`, `plan.md`, `tasks.md`를 요구한다. RVC에서는 `rvc-speckit-review`가 프로젝트 매핑을 통해 원본 산출물에 분석 방법을 적용한다. 원본 명령 실행과 구분한다. |
| [Superpowers](https://github.com/obra/superpowers) — `receiving-code-review`, `verification-before-completion` | 리뷰 의견을 실제 근거와 대조한 뒤 수정하고, 실행 결과를 확인한 뒤 완료 판정 | 검토에서 발견한 문제의 보강 및 재검증 | 코드 중심 지침을 문서 검토에 맞게 적용한다. Codex가 제시한 비판도 재확인 대상이다. |
| [Trail of Bits](https://github.com/trailofbits/skills) — `spec-to-code-compliance` | 명세의 각 요구사항과 실제 구현을 대조하고 근거 위치 제시 | 승인된 SA·SD ↔ `src/`, `include/`, `tests/` | 구현됨·부분 구현·명세와 모순·미구현·판단 불가 등을 구분한다. 함수 이름이나 테스트 존재만으로 준수를 판정하지 않는다. |
| [SPIN](https://github.com/nimble-code/Spin) | Promela 모델의 상태 탐색으로 교착 및 명시한 조건 위반 확인 | Controller FSM | 별도 실행 도구이다. Mermaid FSM에서 검증 모델과 환경 가정을 명시적으로 작성해야 하며, 모델 검증이 실제 C 코드나 시뮬레이터 검증을 대체하지 않는다. |

### 검증 순서와 판정 기준

상세 범위·산출물·진행 상태는 [QA.md](QA.md)를 기준으로 한다. 최초 요구사항, 보완 결정, 승인된 산출물과 `AGENTS.md`를 함께 읽으며 미정 사항을 임의로 확정하지 않는다.

1. **BMAD:** 요구사항과 SA 전체를 반론·경계조건·SASD 일관성 관점에서 검토한다.
2. **Spec Kit:** 요구사항 ↔ SA의 추적성, 누락·중복·모호함을 검토한다.
3. **FSM Verify:** SA를 바탕으로 SPIN 모델·속성·환경 가정을 작성하고 실행 결과와 반례를 기록한다.
4. **BMAD + Spec Kit:** SA → Transform Analysis → Structure Chart의 설계 타당성과 추적성을 검토한다.
5. **C Compliance:** Trail of Bits 기준으로 승인된 SA·SD와 C11 구현을 대조한다.
6. **Superpowers:** 전체 지적 처리 상태를 종합하고 승인되어 반영된 수정 및 필요한 테스트를 실행·검증한다.

**각 Phase 마지막에도 Superpowers를 적용**해 지적의 근거를 다시 확인하고 실제 실행/미실행 검사를 기록한다. 문서 검토와 코드 테스트·모델 검증을 구별하며 기존 단계별 사람 승인 규칙을 유지한다.

검토 결과는 **확정 결함 / 요구사항 모호함 / 선택적 개선**으로 구분한다. 각 지적에는 다음 정보를 남긴다.

| 항목 | 기록 내용 |
|---|---|
| 식별 및 위치 | 이슈 ID, 심각도, 대상 파일·절·줄 |
| 근거 | 해당 요구사항 또는 프로젝트 규칙, 서로 충돌하는 산출물 위치 |
| 재현 | 구체적 반례·입력·상태 경로 또는 실행 명령과 결과 |
| 영향과 수정 | 영향받는 산출물, 최소 수정안, 사람의 결정이 필요한 사항 |
| 상태 | 미확인 / 확인됨 / 수정됨 / 재검증됨 / 보류와 사유 |

도구가 제안한 지적 수를 채우기 위해 결함을 만들어 내지 않는다. 검토하지 못한 범위는 명시하며, 테스트·모델 검사 미실행 상태에서 통과를 선언하지 않는다. 검토 보고서는 `artifacts/Review/<run-id>/` 아래에 실행별로 저장한다. 승인된 SA·SD의 공식 저장 위치는 각각 `artifacts/SA/`, `artifacts/SD/`를 유지한다.

### 설치 상태와 팀원 준비

2026년 11월 17일 작업 PC 기준 설치 상태입니다. 저장소의 프로젝트 파일과 개인 PC에 설치되는 도구를 구분합니다.

| 도구 | 설치 버전·위치 | 확인 범위 |
|---|---|---|
| BMAD | v6.12.4, `_bmad/`와 `.agents/skills/bmad-*` 29개 | Codex 연동 설치 완료, `bmad-review` 설정 해석 스크립트 실행 확인 |
| Spec Kit | v1.4.1, `.specify/`와 `.agents/skills/speckit-*` 9개. `specify` CLI는 사용자 PC에 설치 | Codex용 스킬과 PowerShell 지원 파일 설치. RVC 입력 매핑과 `rvc-speckit-review` 어댑터 준비 완료 |
| Superpowers | Codex의 `superpowers@openai-curated` 플러그인 | 설치·활성화 상태 확인 |
| Trail of Bits | `spec-to-code-compliance@trailofbits` v2.0.2 | 플러그인 설치·활성화 상태와 스킬 파일 확인 |
| SPIN | v6.5.1, 사용자 폴더의 `.local/bin/spin.exe` | 작은 예제의 모델 생성 → GCC 컴파일 → 상태 탐색 실행, `errors: 0`. 생성된 검증기 컴파일에서 포인터 크기 변환 경고 1건 발생 |
| uv | v0.13.8, 사용자 폴더의 `.local/bin/` | BMAD 스크립트 실행 및 Spec Kit CLI 설치 확인 |

BMAD·Spec Kit 프로젝트 파일과 아래 RVC 전용 설정은 팀이 공유하고, `uv`, `specify`, SPIN 실행 파일 및 Codex 플러그인은 각 팀원 PC에 설치한다. `.specify/memory/constitution.md`는 원본 Spec Kit 기능을 위한 미작성 템플릿이다. RVC 어댑터는 `AGENTS.md`와 공통 규약을 기준으로 사용하며 이 템플릿을 승인된 프로젝트 원칙으로 취급하지 않는다. 별도 feature/tasks를 준비하지 않은 상태에서 원본 `speckit-analyze`를 직접 실행하는 대신 `rvc-speckit-review`를 사용한다.

각 PC에서 필요한 설치 명령은 다음과 같다. Node.js, Python, GCC 등 실행 환경은 각 도구의 공식 문서를 따른다.

```powershell
# uv: https://docs.astral.sh/uv/getting-started/installation/
# 설치 후 새 터미널에서 실행한다.
uv tool install --from git+https://github.com/github/spec-kit.git@v1.4.1 specify-cli

# Codex 플러그인 (이미 설치되어 있으면 생략)
codex plugin add superpowers@openai-curated
codex plugin marketplace add trailofbits/skills
codex plugin add spec-to-code-compliance@trailofbits
```

BMAD와 Spec Kit 프로젝트 파일이 없는 새 작업 폴더에서는 다음 공식 설치 명령으로 Codex 연동을 만들 수 있다. 기존 설치 파일이 있는 저장소에서는 재초기화하지 않는다.

```powershell
npx bmad-method@6.12.4 install --modules bmm --tools codex --communication-language Korean --document-output-language Korean --no-shims --yes
specify init --here --integration codex --integration-options="--skills" --script ps
```

SPIN은 [공식 Windows 바이너리](https://github.com/nimble-code/Spin/tree/master/Bin)의 `spin651_windows64.exe.gz`를 풀어 `spin.exe`로 설치하고 `spin -V`로 확인한다. 작업 PC에서는 `.local/bin/`에 설치했다. 이 바이너리는 MinGW 런타임이 필요하므로 팀원 PC에서도 `spin -V`와 예제 모델 컴파일·실행까지 확인한다. RVC의 GCC 환경은 위의 빌드 절차를 따른다.

### RVC 프로젝트 전용 진입 스킬

외부 도구의 원본 스킬을 유지하고, 이 저장소의 `.agents/skills/rvc-*`에 역할별 어댑터 5개를 둔다. 모든 어댑터는 [공통 검증 규약](docs/verification/review-contract.md)의 근거·판정·승인 규칙을 따른다.

| 스킬 | 프로젝트에 맞춘 설정 | 요청 예시 |
|---|---|---|
| [rvc-bmad-review](.agents/skills/rvc-bmad-review/SKILL.md) | BMAD 팀 override와 SASD lens. 부모별 balancing, PSPEC 완전성, 변환 경계, 모듈 인터페이스 검사. 지적 최소 개수 강제 제거 | `$rvc-bmad-review SA와 SD를 전반적으로 review해 줘.` |
| [rvc-speckit-review](.agents/skills/rvc-speckit-review/SKILL.md) | B/C/Q → 이벤트 → 프로세스 → FSM → 모듈 → 코드·테스트 추적. 새 spec/plan/tasks를 만들지 않고 기존 파일을 직접 읽음 | `$rvc-speckit-review C9~C11이 SA·SD·테스트 추적표에 일관되게 반영됐는지 검토해 줘.` |
| [rvc-superpowers-verify](.agents/skills/rvc-superpowers-verify/SKILL.md) | 지적 반증, 승인된 수정의 Red-Green-Refactor, 실제 빌드·CTest·호출 계층·coverage 증거 기록 | `$rvc-superpowers-verify 이 보고서의 지적이 타당한지 먼저 확인해 줘. 아직 수정하지 마.` |
| [rvc-c-compliance](.agents/skills/rvc-c-compliance/SKILL.md) | SA·SD의 동작·모듈·인터페이스를 C11 코드에 대조. C++ 테스트·가짜 하드웨어 구분. 요구사항별 판정과 반증 | `$rvc-c-compliance 승인된 SASD가 C 코드에 구현됐는지 검토해 줘.` |
| [rvc-fsm-verify](.agents/skills/rvc-fsm-verify/SKILL.md) | T0~T14, D4의 5틱 경계, C4/C9/C16(Q6 해결), 후진 반복을 반영한 모델 작성·검사. 청소 D3는 별도 범위 | `$rvc-fsm-verify 이동 FSM과 5틱 타이머를 SPIN으로 검증해 줘.` |

설정의 실제 위치는 [BMAD 팀 override](_bmad/custom/bmad-review.toml), [SASD 검토 관점](docs/verification/bmad-lenses.md), [Spec Kit 입력 매핑](.specify/rvc-review-map.toml), [FSM 모델 규약](.agents/skills/rvc-fsm-verify/references/model-contract.md)이다. 결과는 실행별 `artifacts/Review/<run-id>/`에 저장한다. SPIN 어댑터에는 명령·로그·모델 해시·반례를 보존하고 불완전 탐색을 통과로 처리하지 않는 실행 도우미가 포함된다.

Trail of Bits의 네이티브 Workflow 실행 기능이 현재 호스트에서 제공되지 않으면, 어댑터가 그 제한을 밝히고 Codex의 요구사항별 검토·독립 반증 방식으로 적용한다. 대체 실행을 원본 Workflow 실행으로 보고하지 않는다. 모든 어댑터는 스킬 설정 완료와 실제 검증 성공을 구분한다.

### Codex에 전달할 첫 검토 요청

다음 턴부터 설치된 스킬을 사용할 수 있다. 팀원은 프로젝트 폴더에서 Codex를 열고 아래와 같이 요청한다.

```text
$rvc-bmad-review를 사용해 RVC의 SA 산출물을 review해 줘.
AGENTS.md, docs/preliminary_requirements.md,
docs/requirements_clarifications.md를 기준으로 삼고,
README의 'Codex를 이용한 독립 검증과 보강' 절차를 따라 줘.
우선 Event List와 Context Diagram부터 검토하고 원본 산출물은 수정하지 마.
지적마다 파일 위치, 요구사항 근거, 반례, 영향, 최소 수정안을 제시해 줘.
확정 결함·요구사항 모호함·선택적 개선을 구분하고,
보고서는 artifacts/Review/<이번 실행 ID>/bmad/에 저장해 줘.
```

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
