# Phase 5 수정 및 재검증 — 2026-11-18

**코드와 테스트 수정 완료.** P5-01–P5-06을 승인된 2026-11-18 SD에 맞춰 반영했다. 사용자의 “수정하자”를 구현 수정/TDD 및 관련 검증의 승인으로 기록한다. 새로운 업무 규칙을 결정할 질문은 생기지 않았다. 요구사항·SA·SD 원문 11개는 수정 전 해시와 같다. Phase 6 종합 승인이나 사람의 시스템 평가 완료를 대신하지 않는다.

## 수정과 근거

| ID | 수정 | 검증 |
|---|---|---|
| P5-01 | 초기화는 Forward/D4/D3/센서 상태만 준비, reset 반환 void, 초기 Direction/Clean 없음 | RevisionRegression.C13_NoPowerOnCommands; Main/InitializeRvc; 웹 초기 null 출력 |
| P5-02 | Acquire Initial Inputs가 네 실제 관측의 valid/readiness를 확인한 뒤 종료 | RevisionRegression.C12_AllInitialSensorsAcquired; ActualFalseRequiredForEverySensor; 초기 blocked-front 웹 검사 |
| P5-03 | D2 current+pending을 Sensor Store에서 보유; TRUE OR 저장, FALSE 보존; Forward에서만 pending 소비; 새 감지는 잔여량보다 우선해5 재시작 | C15 회피 감지/중단 잔여량 회귀 두 개, PowerUpTimer·웹/API 재검증 |
| P5-04 | receive_input_event + 센서/일반 dispatch, D1/D2 접근 함수, 바뀐 반환형/인수 구현; fake와 C host/Node/browser 연결을 같은 이벤트 계약으로 전환 | 승인 SD 31개 호출 검사; receipt order/초기 pulse/출력 중 queue/100 pulse 검사; 실제 host의 웹/API 검사 |
| P5-05 | 이전 초기 Forward·먼지 망각·polling 테스트를 요구사항 기반 검사로 교체하고 call baseline을 승인 SD 31개로 변경 | CTest 121개(단위120+호출1) 통과; 전후 Red/Green 로그 |
| P5-06 | Q6 가정 표시를 확정 C16으로 변경하고 구현·시나리오 추적 문서 갱신 | C16 이름/근거 및 기존 이동 동작 테스트 유지 |

핵심 구현은 `src/input_events.c`, `src/sensor_store.c`, `initialize_rvc.c`, `main.c`, `power_up_timer.c`다. Sensor Store 함수는 하나의 번역 단위에서 D1/D2를 독점하며 get 함수는 값 복사만 반환한다. 옛 detect_dust.c/detect_obstacle.c 구현은 Sensor Store 그룹으로 이동했다. 입력은 한 이벤트 루프에서 처리되며 센서 이벤트 자체는 타이머·FSM·출력을 실행하지 않는다. Tick만 Controller를 실행한다. Get Inputs는 D1 분류만 반환하고, Track Power-Up이 D2를 조회/소비한다.

실제 하드웨어 입력 수집은 B6 제외 범위다. fake의 ordered queue와 simulator의 stdin pipe가 수신 순서를 보존한다. Controller 실행 중 도착한 이벤트는 이후에 처리되며 current/pending 조회와 소비 사이에는 재진입이 없다. 시뮬레이터 Reset은 브라우저가 계산한 네 실제 초기 센서값을 먼저 보낸다. 개별 `/api/event`는 Tick 사이의 TRUE/FALSE 변화도 전달한다. `/api/step`은 네 관측 뒤 Tick을 보내는 편의 API다. 기존 raw host의 네 숫자 한 줄 프로토콜은 이벤트 프로토콜로 교체했다(simulator/README.md 참조).

## TDD 및 실행 결과

수정 전 코드에 네 회귀를 추가해 빌드한 뒤 **4개 모두 실제 assertion 실패**를 관찰했다. 로그는 red.log, 테스트 원본은 ../before/red_regressions.cpp다. 출력 무시나 컴파일 오류를 Red로 취급하지 않았다. 이후 승인된 API에 맞춰 테스트의 입력 전달만 바꾸고 같은 기대 결과를 유지해 통과시켰다. 기존 이동/5틱 경계·후진 반복·C9/C11/C16 검사는 유지했다. 폐기된 polling 계약의 검사를 store/event 검사로 교체하여 총 단위 사례 수는 이전129에서 현재120으로 바뀌었다. 단순 테스트 수 증가/감소를 품질로 판정하지 않았다.

| 실행 | 결과 | 근거 |
|---|---|---|
| 기존 GCC 15.2.0/Ninja `cmake --build build` | 성공, 생산 C11 및 `rvc_sim_host` 빌드 | build-first.log |
| `ctest --test-dir build --output-on-failure` | 121/121 통과, call_hierarchy 실제 실행 | ctest.log |
| `cmake --build build --target coverage` | 140/140줄, 62/62분기 결과 각각100.0% | coverage.log, coverage-summary.md |
| `node simulator/run_scenarios.js` (별도 RVC_SCENARIO_OUT) | 21개×100틱 실행, 전체 trace 저장 | scenarios.log, scenarios/traces/ |
| `node .../verification/web_regressions.cjs` | 실제 Edge 브라우저에서 4개 묶음 검사 통과, 페이지 오류0 | web-results.json, web-ST14-tick18.png |
| `python .../verification/verify_corrections.py` | SA/SD11개 불변, 승인31호출/기대목록 일치, trace·로그·Git 공백 검사 통과 | results.json, diff-check.log |

첫 전체 검사에서는 삭제된 소스의 오래된 .ci 파일이 빌드 디렉터리에 남아 호출 검사가 실패했다(ctest-first.log). 검사기가 현재 `src/*.c` 대상에 대응하는 .ci만 읽도록 고쳤으며, 승인 간선 누락을 허용하거나 비교를 건너뛰지 않았다. 이후 정확히31개 호출로 통과했다. Red 실행에는 기존 Windows 한글 경로의 gcov 출력 경고도 있었지만 GoogleTest 네 assertion 실패는 별도로 확인했다. 최종 커버리지는 프로젝트 지정 coverage 목표의 경로 우회로 정상 측정했다.

웹 검사는 초기 실측/무출력, Tick 사이 TRUE→FALSE 보존과 Forward 소비·5틱 종료, 중단 잔여량보다 우선하는 새 감지 재시작, ST-14 UI 버튼/기록18틱을 확인했다. 21개 전체는 headless 기록이며 모두 브라우저 UI에서100틱씩 실행했다고 주장하지 않는다. trace에 초기 null 출력·틱 번호·회피 중 Clean Stop의 기본 일관성을 검사했다. 사람의 PASS/FAIL 입력은 하지 않았다.

## 검토·한계와 현재 상태

`rvc-superpowers-verify` 및 설치 Superpowers receiving-code-review/verification-before-completion 기준을 적용해 실제 실패, 최소 수정, 새 실행 증거를 확인했다. 이번 수정은 주 검토자의 소스 대조·자동 실행으로 재검증했다. 독립 다중 에이전트나 네이티브 Trail of Bits 워크플로를 다시 실행했다고 주장하지 않는다. Phase 5 최초 독립 반증 근거는 원래 실행 디렉터리에 보존했다.

이동 FSM 전이/타이머 알고리즘은 변경하지 않았고 reset의 출력 경로/반환형만 C13에 맞췄다. 기존 경계 테스트는 실행했으며 SPIN은 재실행하지 않았다. 단위 커버리지는 C 코드만 대상으로 하며 실제 물걸레/흡입 actuator, 센서 capture 및 JavaScript 전체 커버리지를 증명하지 않는다. C14 의미는 추상 Clean 계약이며 물리 구현은 B6 범위 밖이다.

현재: **Phase 5 지적 수정·관련 재검증 완료**. 남은 것은 Phase 6 종합 검토와 사람의 웹 시나리오 평가다. 기존 P2-I01 선택적 SA 요약 참조 정리도 별도 잔여 항목이다. 커밋/푸시는 수행하지 않았다. 수정 전 파일은 before/와 baseline.json, 최종 소스 해시는 final-inputs.json에 보관했다. 과거 보고서·시스템 trace는 덮어쓰지 않았다.
