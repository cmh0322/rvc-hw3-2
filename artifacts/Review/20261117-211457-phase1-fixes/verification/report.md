# Phase 1 답변 반영 및 문서 재검증

날짜: 2026-11-17 (Asia/Seoul). 실행 ID: `20261117-211457-phase1-fixes`.

**사용자가 확정한 네 답변을 C12–C15로 기록하고, 최초 Phase 1 지적 7개를 요구사항·SA 문서 수준에서 수정했다.** C/SD 준수, 실행 테스트, SPIN 성공 또는 개정 SA 전체 승인을 의미하지 않는다. Phase 2는 아직 실행하지 않았다.

## 권한·범위·입력

- 사용자 요청: “나한테 물어봐 그 답변으로 수정하자” 및 이어진 네 답변. 첫 Tick 전 네 센서 읽기 / 초기 Forward 상태만 설정하고 첫 Tick에 출력 / 흡입만 강화하고 물걸레는 정상 유지 / 회피 중 먼지를 기억하여 복귀 시 5틱 시작·재시작.
- 적용: `rvc-superpowers-verify`, Superpowers `bd2122cb`의 `receiving-code-review` 및 `verification-before-completion`. 재검토 방법: BMAD 6.12.4 `bmad-review`의 프로젝트 adversarial·edge-case-hunter·sasd 관점.
- Git HEAD: `dea14b590b5246e1889119fc9040c5df496bd987`. 기존 미커밋 변경이 있는 작업 트리에서 작업했다. [시작 상태 및 보호 파일 해시](baseline.json), [수정 후 입력 목록](../bmad/input-manifest.json), [수정 후 원문 스냅샷](../bmad/review-input.md)을 기록했다.
- 수정 전 요구사항 보완 문서와 SA 9개는 이 실행의 `before/`에 보존했다. 최초 보고서 `20261117-210003-phase1-sa`는 당시 상태의 이력으로 유지했다.
- 수정 범위: 요구사항 보완 문서, SA 9개, QA/README 진행 기록, 프로젝트 검증 규약·매핑 및 C/FSM 어댑터의 새 결정 안내. upstream 스킬과 원본 preliminary requirements는 변경하지 않았다.

## 지적별 해결 및 추적

| 원래 지적 | 반영 내용 | 현재 근거 | 문서 판정 |
|---|---|---|---|
| P1-01 | C9의 Front Blocked + Side Situation 레코드로 상위 설명 및 3.2/3.2.1 의사코드 통일. Q6는 Forward 진입에만 적용 | PSPEC 3, 3.1, 3.2, 3.2.1; Level 2 책임·결정 절; Data Dictionary | 수정·재대조 완료 |
| P1-02 | Q1–Q5 해결 상태를 상위 문서에 전파. Q4→C10, Q5→C11, 회피 먼지→C15. Q6는 가정 유지 | PSPEC 0/4, Level 1/2/3, requirements_clarifications | 수정·재대조 완료 |
| P1-03 | D3 초기값 0, 초기화 시점은 초기 샘플 전. D4 Idle과 pending FALSE도 연결 | PSPEC 0/4.1/3.2.4, Data Dictionary D3, Level 1/2/3 | 수정·재대조 완료 |
| P1-04 | C12: 네 센서의 실제 값을 모두 얻은 뒤 첫 Tick. 미수신 값을 FALSE로 가정하지 않음. 개별 입력은 해당 필드만 갱신 | C12, PSPEC 0/1/2, Data Dictionary D1/D2 | 사용자 결정 반영·재대조 완료 |
| P1-05 | C13: T0는 내부 상태 초기화이며 출력 없음. 첫 Tick T1/T2의 판단에 따라 Direction/Clean 출력 | C13, Event/Context/Level 0 설명, Level 4 T0, PSPEC 0/3.2.2 | 사용자 결정 반영·재대조 완료 |
| P1-06 | C14: Start/Stop은 흡입·물걸레 동시 제어, Power Up은 흡입만 강화 | C14, Event List Clean, Data Dictionary Clean, PSPEC 4/4.2 | 사용자 결정 반영·재대조 완료 |
| P1-07 | C15: 감지 보존 후 첫 Forward Tick에 5틱 재시작. 저장된 잔여 틱보다 pending/current dust가 우선 | C15, D2 record/flow, Level 1/2/3, PSPEC 2/4/4.1 | 사용자 결정 반영·재대조 완료 |

## C15의 분석 실현

D2를 `Dust Detected + Pending Dust Detection` 두 Boolean의 레코드로 확장했다. Process 2가 수신한 TRUE를 OR로 기억하므로 TRUE 다음 FALSE가 Tick 사이에 도착해도 감지가 사라지지 않는다. Process 4.1은 현재 Movement Status를 받은 후, Forward에서만 이를 소비한다. 회피 중에는 D3의 잔여 틱과 pending을 모두 유지한다.

Forward에서 current 또는 pending이 TRUE이면 D3=5로 설정한 뒤 현재 틱을 사용하여 4로 감소한다. 둘 다 FALSE이면 기존 잔여 틱을 재개한다. 여러 감지는 한 번의 재시작으로 합치며 기간을 누적하지 않는다. current dust가 계속 TRUE이면 기존 C10처럼 매 Forward Tick에 재시작한다. 입력 수신과 Tick은 논리적으로 직렬화하여 소비 뒤의 새 입력이 이전 Tick에 지워지지 않도록 명시했다. 이는 하드웨어 동기화 구현을 지정한 것이 아니다.

DFD의 변경은 D2→Process 2 읽기와 Process 4→D2 `Pending Dust Detection` 갱신 흐름이다. Level 2에서 4.1→D2로 대응시켰다. 이 흐름은 Process 4 경계를 넘지만 Process 0 내부이므로 외부 입출력은 여전히 7개다. Data Dictionary와 PSPEC에 reader/writer·초기값·필드 단위 갱신 의미를 함께 적었다.

## 재검토 방식과 한계

BMAD 지침에 따라 세 독립 검토자의 재실행을 시도했지만 모두 실행 한도로 실패하여 결과를 받지 못했다. 독립 재검토 완료로 계산하지 않았다. 주 검토자가 아래 순서로 직접 재대조했다.

1. **adversarial:** C12–C15를 실제 답변과 대조. B6의 범위 밖 하드웨어 설계를 추가하지 않았는지, C15가 C11을 취소하지 않고 재시작 우선순위로 보완하는지 확인. 새 Q6 확정이나 코드로부터의 요구사항 역추론 없음.
2. **edge-case-hunter:** 초기화/첫 Tick, 단발·반복·지속 먼지, 회피 중 TRUE→FALSE, 잔여 틱 유무, 소비 직후 새 입력을 문서로 순회. 아래 수동 경로표에 근거를 기록. diff 삭제 검토에서 오래된 상위 의사코드의 동작은 최신 하위 계약으로 연결됐음을 확인. 별도 claims 입력 없음.
3. **sasd:** 실제 부모 경계, D2의 두 writer, PSPEC 입출력 및 DD 정의를 확인. Level 2의 기존 “모든 새 흐름이 부모 내부” 문구가 새 pending 흐름에 맞지 않아 수정했다([재검토 지적](../bmad/findings.json)). 최종 문서에서는 이 흐름을 Process 4 외부/Process 0 내부로 구별한다.

현재 범위에서 추가로 남겨야 할 문서 결함을 확인하지 못했다. 독립 재검토 실패 및 Phase 2 추적성/Phase 3 형식 검증 미실행의 한계는 그대로 남는다.

## 수동 경로 대조 — 실행 테스트 아님

| 경로 | 수정 명세에서 도출되는 결과 | 근거 |
|---|---|---|
| 전원 켜짐, 아직 첫 Tick 전 | Forward 상태, D3=0, D4=Idle. Direction/Clean 없음; 센서 준비 전 Tick 처리 없음 | C12/C13, PSPEC 0 |
| 첫 Tick: front clear, dust FALSE | Forward/Start; 흡입·물걸레 정상, D3=0 | T1, PSPEC 4.1/4.2 |
| 첫 Tick: front blocked, dust TRUE | Stop/Stop, D4 시작; D3=0 유지, pending TRUE 보존 | T2, C14/C15 |
| 회피 중 TRUE→FALSE, 이후 첫 Forward | 현재 dust FALSE여도 pending TRUE로 5틱 시작; 그 Tick 종료 시 D3=4, pending FALSE | PSPEC 2/4.1 |
| 잔여 2틱으로 회피, 새 감지 없음, 복귀 | 잔여 2틱 재개; 첫 복귀 Tick 종료 시 D3=1 | C11 |
| 잔여 2틱으로 회피, 새 감지 있음, 복귀 | 잔여 2보다 C15 재시작 우선; 첫 복귀 Tick 종료 시 D3=4 | C15 |
| 회피 중 여러 번 감지 | pending TRUE 하나로 보존; 복귀 후 5틱 한 번 재시작 | C15 분석 실현 |
| 재시작 이후 새 감지·회피 없음 | t..t+4에서 Power Up, t+5에서 Start | C3, PSPEC 4.1 |
| 소비 뒤 새로운 TRUE 입력 | 입력 직렬화 순서상 다음 Tick용 pending TRUE로 남음 | PSPEC 0/2/4.1 |
| 후진 종료 front clear, 양측 blocked | C9의 sides 기준으로 다시 Backward; 기존 FSM T8 유지 | C5/C9, T8 |

## 실행한 검사

| 명령/검사 | 결과 | 범위 |
|---|---|---|
| BMAD `resolve_customization.py --skill .agents/skills/bmad-review --project-root . --key workflow` | 종료 0, [병합 설정](../bmad/resolved-workflow.json) | 프로젝트 관점/override 로딩 |
| `python3 artifacts/Review/20261117-211457-phase1-fixes/verification/check_documents.py` | 종료 0, [전체 출력](document-checks.json) | 부모 경계 5쌍 일치, PSPEC 13개 존재, 흐름 19개 정의 존재, 최종 입력 해시 확인 |
| 수정 전후 보호 파일 SHA-256·요구사항 매핑·보고서 링크 검사 | [최종 검사 결과](final-checks.json) | 원본 요구사항/SD/src/include/tests 및 기존 리뷰 보존; C1–C15 매핑 |
| `git diff --check` | 종료 0 | tracked 변경의 공백 오류 |

Mermaid CLI(`mmdc`, `mmdc.cmd`)가 현재 명령 경로에 없어 시각 렌더링은 실행하지 않았다. 도표 화살표/경계와 T0 텍스트는 원문으로 검토했다. 빌드·CTest·커버리지·웹 시스템 테스트·SPIN은 실행하지 않았다. 문서 수정에 코드용 Red-Green-Refactor 성공을 붙이지 않는다.

## 후속 작업

Phase 2에서 B1–B7/C1–C15 ↔ SA 전체 추적성을 확인한다. Phase 3에서 T0 무출력 초기화를 모델에 반영하고, 청소 합성 모델을 다룬다면 C15 감지 보존과 D3 재시작을 별도로 검증한다.

SD·C·테스트·시뮬레이터는 이번에 변경하지 않았다. 특히 D2 레코드/소비 흐름, C12 초기 샘플, C13 초기 출력, C14 Cleaner 의미, C15 감지 보존은 후속 설계 및 구현 검토 대상이다. **기존 구현이 새 요구사항을 충족한다는 판정은 아직 없다.** [QA 후속 항목](../../../../QA.md)에 연결했으며 개정 단계의 사람 승인 규칙을 유지한다.
