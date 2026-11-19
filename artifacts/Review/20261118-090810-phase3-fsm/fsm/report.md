# Phase 3 — 이동 FSM SPIN 검증 결과

실행일: 2026-11-18 (Asia/Seoul). 입력 Git HEAD: `dea14b590b5246e1889119fc9040c5df496bd987`; 미커밋 변경이 있는 작업 트리의 실제 파일 해시를 `../input-manifest.json`에 기록했다.

**검사한 이동 FSM에서 새 필수 수정 결함은 발견하지 못했다.** 기본·환경 확장 안전성 2개와 정지·회전 종료 LTL 2개가 완전 탐색으로 통과했다. T0–T14 및 5개 상태의 도달 증거를 확보했다. 이는 최신 SA의 유한 추상 모델에 대한 결과다.

모델 SHA-256: `9d7a6c637f3afbd8d44dddb34f26bc7a0eb3e653d090f848143c0eb24b383fe4`. SPIN 6.5.1, GCC 15.2.0(MSYS2 cc.exe). `rvc-fsm-verify` 지침과 프로젝트 runner를 사용했다. 모델 적합성 검토는 [mapping.md](mapping.md), 정확한 속성과 가정은 [properties.md](properties.md), 모든 결과는 [suite-results.json](suite-results.json)에 있다.

## 안전성·활성성 실행 결과

| 실행 | 결과 | 저장 상태 수 | 탐색 전이 수 | 오류 |
|---|---|---:|---:|---:|
| [safety-final](checks/safety-final/search.log) | completed / passed | 157 | 2233 | 0 |
| [robust-unconstrained-front](checks/robust-unconstrained-front/search.log) | completed / passed | 177 | 2713 | 0 |
| [stop_progress](checks/stop_progress/search.log) | completed / passed | 177 | 2665 | 0 |
| [turn_progress](checks/turn_progress/search.log) | completed / passed | 237 | 5513 | 0 |

저장 상태 수는 SPIN 내부 모델 상태이며 FSM의 5개 상태 수와 다르다. 전이 수는 내부 탐색 전이 수이며 T0–T14 개수와 다르다. 네 검사는 full-state search + POR이고 최대 실제 깊이는 1062, 설정 한도는 100000이었다. 시간 제한·메모리 부족·깊이 초과로 잘린 통과 결과는 없다. 안전성 실행에서 invalid end states 검사도 켜져 있었다.

확인한 동작은 초기 무출력·네 센서 샘플 선행, 우측 우선, 전방만 회피 시작(C16의 이동 부분), 후진 후 전방과 독립적인 좌우 판단(C9), 5틱 경계와 타이머 재시작, 상태/명령 일치다. 이웃 상태까지의 한 단계뿐 아니라 유한 모델의 도달 가능한 전체 경로를 탐색했다.

## 도달성·반례·민감도

- 전이 probe 15개와 상태 probe 5개에서 각각 '목표는 도달하지 않는다' assertion을 깨는 trail을 얻고 SPIN으로 재생했다. `checks/reach-*/tick-trace.txt`는 원본 replay에서 추출한 Tick 요약이다. 기대한 probe assertion이 실패한 것인지까지 재확인했다.
- [unconditional_forward 반례](checks/unconditional_forward/tick-trace.txt): T2 → T3×4 → T6 → T7 반복 후, 결정 Tick마다 양옆이 막히면 T8로 5틱 후진을 재시작한다. 재생된 순환에서도 Tick이 실행되므로 교착이 아니다. 전방은 비어 있어도 C9에 따라 후진할 수 있다. **C5/C9가 허용한 동작이며 SA 결함으로 분류하지 않는다.** 주변이 항상 막혔다는 뜻은 아니며 결정 Tick의 좌우 입력이 핵심이다. 실제 지도에서 경로가 실현되는지는 이 모델로 판정하지 않는다.
- 시험용 모델 4개(타이머가 4에서 종료, 후진 종료 때 front clear로 전진, 좌우만 막혀도 회피, 초기 Forward 출력) 모두 assertion 위반으로 검출·재생했다. 생산 코드나 SA를 변경한 것이 아니다. `checks/mutant-*/search.log`와 replay가 증거다.
- 합계 29개 결과는 **4개 완전 탐색 통과 + 20개 도달 witness + 4개 변형 결함 검출 + 1개 비요구사항 반증**이다. 29개 제품 테스트 통과라고 해석하지 않는다.

## 경고·실행 과정의 문제

초기 모델 초안의 guard 합산식 구문 오류는 괄호로 수정했고 `checks/safety/`에 실패한 입력과 생성 로그를 보존했다. 한글 프로젝트 경로의 링커 출력 경로 문제는 `checks/safety-v2/compile.log`에 남겼다. 이후 영문 임시 경로에서 같은 모델 해시로 생성·컴파일·탐색하고 모델/로그/trail을 프로젝트로 복사했다. 명령과 실제 작업 경로는 각 result.json에 있다. 원본 runner나 생산 빌드 설정은 수정하지 않았다.

`unreached`는 기본 모델의 무한 Tick 루프 뒤 `-end-` 한 곳이며 전이 본문 미도달은 없었다. LTL claim의 종료 지점 미도달도 무한 실행 검사에 따른 것이다. 단일 claim의 `-N ignored` 경고는 claim 이름·생성 로그를 대조했다. probe·변형 검사에서 첫 반례를 찾은 뒤의 'Search not completed'는 예상된 중단으로, 완전 탐색 성공과 구분했다.

## Phase 4에 넘길 사항

P3-D01: `artifacts/SD/structure_chart.md:257`, `:386`, `:404`는 초기 Forward 출력을 여전히 설명하지만 최신 C13 및 FSM T0는 초기 출력을 금지한다. Phase 1 이후 이미 남겨 둔 SD 전파 항목을 구체적 위치로 재확인한 것이다. 이번에 SD를 수정하거나 승인하지 않았다. Phase 4에서 초기화 호출·책임·인터페이스와 C12–C16 전파를 함께 확인해야 한다.

기존 P2-I01(선택적 참조 목록 정리)은 그대로 남아 있다. 새 이동 FSM 요구사항 결정을 요청할 사항은 발견하지 못했다.

## 한계와 종료

모델은 한 프로세스의 동기 Tick과 비결정적 센서값을 사용한 유한 추상화다. 환경 제약, C4 해석, 지속 Tick 전제는 mapping.md에 있다. 독립 에이전트 리뷰는 수행하지 않았고 주 검토자가 원문과 모델을 대조했다. 실제 C 준수, 청소 D2/D3, 시스템 테스트와 물리적 안전성은 이 결과에서 결론 내리지 않는다. 제품 테스트·커버리지·웹 시뮬레이터는 실행하지 않았다.

[Superpowers 종료 점검](../verification/report.md)에 원문/보호 파일 해시, 15개 전이 대응, 29개 결과·반례 재확인과 실행한 검사 명령을 남겼다. Phase 3 검토 작업 완료이며 개정 SA 전체 승인이나 Phase 4 실행을 대신하지 않는다.
