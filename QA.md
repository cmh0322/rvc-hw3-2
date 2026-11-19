# RVC 검증 계획

계획 합의일: 2026-11-17 (Asia/Seoul)

Claude로 작성한 RVC 산출물을 Codex가 독립적으로 검토한다. 순서는 **BMAD → Spec Kit → FSM Verify → BMAD + Spec Kit → C Compliance → Superpowers**이며, 각 Phase 끝에서도 Superpowers로 지적의 타당성과 검증 근거를 확인한다.

## 공통 운영 원칙

- [공통 검증 규약](docs/verification/review-contract.md)과 [프로젝트 지침](AGENTS.md)을 따른다. 이 QA Phase는 검토 작업의 순서이며 기존 SA → SD → TDD → 시스템 테스트의 승인 단계를 대체하지 않는다.
- 기준은 원본 요구사항 B1–B7, 확정 결정 C1–C16, 승인된 SA·SD이다. Q6는 사용자 답변으로 C16에 확정되었다. 검토한 파일의 SHA-256, Git HEAD와 작업 트리 상태를 기록한다.
- 각 Phase는 검토 → 지적 반증·분류 → 필요한 결정/수정안 정리 → Superpowers 종료 점검 → 결과 공유로 진행한다. 수정은 별도 요청 범위에서 수행하고, 영향받는 이전 검토를 다시 확인한다.
- 지적은 확정 결함 / 요구사항 모호함 / 선택적 개선으로 구분한다. 원본 산출물과 코드는 이번 검토 요청만으로 수정하지 않는다. 중대한 미해결 사항은 후속 Phase의 전제·제약으로 남긴다.
- 문서 리뷰, C 준수 검사, 실행 테스트, SPIN 모델 검사를 별도 상태로 기록한다. 과거 테스트 수나 커버리지를 이번 결과로 재사용하지 않는다.
- 실행별 결과는 `artifacts/Review/<run-id>/`에 보관한다. 기존 결과를 덮어쓰지 않는다. Phase 진입/종료 상태와 다음 조치를 이 문서에 갱신한다.

## Phase별 계획

| Phase | 주 담당 | 범위와 수행 내용 | 산출물 및 종료 기준 |
|---|---|---|---|
| 1 | `rvc-bmad-review` | 요구사항 + SA 전체. Event List → Context → DFD 0–3·Data Dictionary·Process Specifications → Level 4 FSM 인터페이스 순으로 검토. 반론, 경계조건, SASD 일관성의 세 관점 사용 | `bmad/report.md`, `bmad/findings.json`, 입력 목록·부모별 balancing 근거. 지적마다 출처·조건·영향·최소 수정안과 재검토 판정 기록 |
| 2 | `rvc-speckit-review` | 요구사항 ↔ SA 추적성, 누락·중복·모호함 확인. 기존 문서를 `.specify/rvc-review-map.toml`로 연결 | `traceability/` 보고서·매트릭스·체크리스트. B1–B7/C1–C16의 적용 여부와 Q6→C16 해결 이력 구분, 미연결 항목 설명 |
| 3 | `rvc-fsm-verify` | SA 기반 Movement Controller 모델 작성, T0–T14·D4·5틱 경계·후진 반복·환경 가정 검토. D3 청소 타이머는 별도 범위 명시 | `fsm/` 모델·속성·실행 로그·반례·결과. 모델과 원문의 대응 및 탐색 한계 명시; 무조건적인 전진 복귀를 요구하지 않음 |
| 4 | `rvc-bmad-review` + `rvc-speckit-review` | SA → Transform Analysis → Structure Chart. 모듈 책임·인터페이스, 결합도·응집도, 데이터 흐름과 호출 관계, 추적성 검토 | `bmad/`, `traceability/`의 SD 검토 결과. SA 근거와 설계 선택, 불일치 및 승인 기준 확인 |
| 5 | `rvc-c-compliance` | 승인된 요구사항·SA·SD ↔ C11 구현 대조. Trail of Bits 기준으로 요구사항별 구현 위치·누락·충돌 검토 | `c-compliance/` 보고서. implemented / partial / contradicted / stronger-than-spec / absent / undecidable과 실행 증거를 구별 |
| 6 | `rvc-superpowers-verify` | 전체 지적 처리 상태 종합, 승인되어 반영된 수정 재검증, 필요한 빌드·단위 테스트·호출 계층·커버리지·웹 시스템 시나리오 확인 | `verification/` 최종 근거와 잔여 위험. 실제 명령·종료 코드·테스트/커버리지 측정값·미실행·사람 판정 대기 구분 |

## 매 Phase 마지막의 Superpowers 점검

`rvc-superpowers-verify`를 통해 `receiving-code-review`와 `verification-before-completion` 지침을 적용한다. 짧은 종료 점검이더라도 근거를 생략하지 않는다.

1. 지적의 인용 위치와 요구사항을 다시 읽고 확정 / 반증 / 모호함 / 선택적 개선으로 판정한다.
2. 중복 지적은 연결하되 원래 관점별 결과를 보존한다. 지적 수를 채우기 위한 항목은 제외한다.
3. 해당 Phase에 필요한 검사만 수행한다. 문서 리뷰에는 원문 대조·부모별 balancing·정의 일관성을, 코드 수정에는 TDD 및 실행 테스트를 적용한다.
4. `verification/report.md`에 실행/미실행 항목, 해결되지 않은 문제, 다음 단계에 넘길 조건을 남긴다. 결함 미수정과 리뷰 작업 완료를 구별한다.

## 진행 기록

| Phase | 상태 | 결과 / 다음 조치 |
|---|---|---|
| 계획 | 작성 완료 | 사용자가 지정한 순서와 Phase별 Superpowers 종료 점검 반영 |
| 1 | 최초 리뷰 완료; 답변 반영 및 문서 재점검 완료 | [최초 BMAD 보고서](artifacts/Review/20261117-210003-phase1-sa/bmad/report.md)의 7개 항목을 C12–C15와 SA 수정으로 처리. [수정·재검증 기록](artifacts/Review/20261117-211457-phase1-fixes/verification/report.md). 독립 재검토자 실행 불가로 주 검토자가 순차 재검토했으며, 전체 SA 승인/제품 테스트 성공 판정은 아님 |
| 2 | 추적성 리뷰·종료 점검 완료 | [Spec Kit 적용 보고서](artifacts/Review/20261117-212640-phase2-traceability/traceability/report.md), [매트릭스](artifacts/Review/20261117-212640-phase2-traceability/traceability/matrix.md), [종료 점검](artifacts/Review/20261117-212640-phase2-traceability/verification/report.md). 당시 확정 22개 모두 SA 근거 연결; Q6는 이후 C16으로 확정(아래 기록), LOW 선택적 참조 개선 1개. 원문 수정·제품 실행 검증 없음 |
| 3 | 이동 FSM 모델 검증·종료 점검 완료 | [SPIN 보고서](artifacts/Review/20261118-090810-phase3-fsm/fsm/report.md). 안전성·활성성 4개 완전 탐색 통과, T0–T14/5개 상태 도달 확인. 반복 후진은 허용 동작; SD 초기화 설명 불일치는 Phase 4로 전달 |
| 4 | SD 수정·재검토 완료; 개정 SD 사용자 승인 완료 | [수정·재검증](artifacts/Review/20261118-095720-phase4-fixes/verification/report.md). 2026-11-18 사용자 “승인할게 phase5진행”으로 [개정 SD 승인](artifacts/Review/20261118-101242-phase5-c-compliance/approval.md) |
| 5 | 감사 및 P5-01–06 수정·관련 재검증 완료 | [최초 감사](artifacts/Review/20261118-101242-phase5-c-compliance/c-compliance/report.md), [수정/Red-Green/종료 점검](artifacts/Review/20261118-213657-phase5-fixes/verification/report.md). CTest121/121, 승인31호출 일치, C140/140줄·62/62분기, 웹/API 검사 통과. 실제 하드웨어·사람 시스템 판정은 제외 |
| 6 | 자동 종합 검증 완료; 사람 시스템 평가·최종 승인 대기 | [Phase 6 보고서](artifacts/Review/20261119-115842-phase6-final/verification/report.md), [통합 지적대장](artifacts/Review/20261119-115842-phase6-final/verification/finding-ledger.md), [사람 평가 안내](artifacts/Review/20261119-115842-phase6-final/system/human-evaluation.md). 새 필수 수정 없음. P2-I01은 후속 정리 완료(아래 기록) |

첫 실행은 계획 작성과 Phase 1 수행이었다. 후속 요청에 따라 Phase 1 답변 반영과 **Phase 2 수행 및 종료 점검**까지 진행했다. 이후 2026-11-18 사용자 요청으로 Phase 3도 수행했다. 이후 Phase 4 검토도 수행했다. Phase 5 이후는 아직 실행하지 않았다.

## Phase 1 답변 반영 — 2026-11-17

사용자의 네 답변을 [C12–C15](docs/requirements_clarifications.md)에 기록했다. C12는 첫 Tick 전 네 센서 읽기, C13은 상태만 초기화하고 첫 Tick에 출력, C14는 흡입만 강화하며 물걸레는 정상 유지, C15는 회피 중 먼지를 기억하여 복귀 시 5틱 시작·재시작이다. C9 자료형·Q4/Q5 결정 상태·D3=0도 함께 정리했다. 이 시점의 Q6는 가정이었고, 이후 아래 기록처럼 C16으로 확정했다.

C15의 분석 실현으로 D2를 `Dust Detected + Pending Dust Detection` 레코드로 확장했다. Process 2가 TRUE 입력을 기억하고, Process 4.1이 Forward Tick에 소비한다. FALSE 입력은 미처리 감지를 지우지 않는다. 보존된 잔여 틱과 감지가 함께 있으면 C15의 5틱 재시작이 우선한다. 기존 리뷰 보고서와 수정 전 스냅샷은 이력으로 보존한다.

### 후속 단계에 넘길 변경

| 후속 단계 | 반영/확인할 항목 | 현재 상태 |
|---|---|---|
| Phase 2 | B1–B7/C1–C15 ↔ SA 추적성, D2 새 필드 및 소비 흐름, Q6 가정 | 검토 완료 — 아래 Phase 2 기록 참조 |
| Phase 3 | T0 무출력 초기화와 첫 Tick, D4 경계, C16의 전방 전용 회피 시작 조건 및 C9와의 구분. 청소 합성 모델 범위에 들어갈 경우 C15 감지 보존·재시작도 포함 | 이동 FSM 범위 완료 — 아래 Phase 3 기록 참조; 청소 합성 모델 제외 |
| Phase 4 | D2 레코드·reader/writer 및 초기화/입출력 의미를 Transform Analysis·Structure Chart·모듈 인터페이스에 전파 | SD 수정·재검토 완료(아래 후속 기록). 기존 승인과 개정 SD 사람 승인을 구분하며 현재 후자는 대기 |
| Phase 5–6 | 개정 SD 승인 후 C12–C15의 C 준수 확인, 필요한 TDD 수정·회귀 및 시뮬레이터 검증 | C·테스트·시뮬레이터 미수정/미실행 |

사용자 답변은 요구사항 결정과 SA 수정의 근거다. 개정 SA 전체의 승인 또는 SD·구현 단계로의 자동 진입 승인을 대신하지 않는다.

## Phase 2 결과 — 2026-11-17

`rvc-speckit-review`로 기존 SASD 문서에 Spec Kit의 분석 방법을 적용했다. 원본 feature/tasks workflow 실행과 구분한다. 요구사항 22개(B1–B7/C1–C15)의 관련 SA 근거를 연결하고 Q6는 별도 가정 행으로 유지했다. 흐름 19개·프로세스 13개·저장소 4개·상태 5개·T0–T14의 역방향 근거도 기록했다.

새로운 필수 동작 누락/상충은 발견하지 못했다. P2-I01은 PSPEC 3.2.2의 C12/C13, Level 3의 3.2.1 C9 요약 참조를 본문과 맞추는 LOW 선택적 개선이며 아직 적용하지 않았다. Q6(P2-A01)는 당시 기존 가정이었으며 이후 사용자 결정 C16으로 해결했다. 22/22는 문서 근거 연결률이지 구현 성공률이 아니다.

[팀용 품질 체크리스트](artifacts/Review/20261117-212640-phase2-traceability/traceability/checklist.md)는 새 질문 15개를 미표시 상태로 생성했다. 분석 결과는 보고서에 별도로 기록했다. SD·C·테스트는 notChecked, SPIN/제품 테스트는 notRun이다. 이 기록 당시 다음 순서는 Phase 3 FSM Verify였으며, 실행 결과는 아래에 추가했다. 사람 승인 규칙은 유지한다.

## Q6 확정 — 2026-11-17

사용자 답변에 따라 **C16: Forward에서 전방 장애물만 회피를 시작한다. 전방이 비어 있으면 좌우 장애물과 관계없이 전진·청소한다**로 확정했다. 후진 종료 후 좌우만 판단하는 C9는 유지한다. P2-A01은 사용자 결정으로 해결되었다.

현재 확정 요구사항은 B1–B7/C1–C16의 23개다. 기존 Phase 2의 22개 + Q6 가정 매트릭스는 실행 당시의 증거로 보존하고, C16의 영향 범위만 [후속 기록](artifacts/Review/20261117-214322-q6-confirmation/verification/report.md)에서 보충한다. 전체 Phase 2 재실행이나 SD·C 준수 확인을 의미하지 않는다.

요구사항·SA 참조·검증 공통 규약·프로젝트 스킬 및 Spec Kit 매핑을 갱신했다. FSM 전이 조건/동작과 Mermaid 흐름은 그대로다. P2-I01의 선택적 참조 정리는 이번 결정 범위 밖으로 남겨 둔다. Q6 확정 시점에는 Phase 3 미실행이었고, 이후 결과는 아래 기록에 추가했다.

## Phase 3 결과 — 2026-11-18

사용자의 Phase 3 진행 요청에 따라 `rvc-fsm-verify`로 최신 SA의 이동 FSM과 D4를 모델링하고 SPIN 6.5.1/GCC 15.2.0을 실제 실행했다. [검증 보고서](artifacts/Review/20261118-090810-phase3-fsm/fsm/report.md), [모델 대응](artifacts/Review/20261118-090810-phase3-fsm/fsm/mapping.md), [속성·가정](artifacts/Review/20261118-090810-phase3-fsm/fsm/properties.md), [Superpowers 종료 점검](artifacts/Review/20261118-090810-phase3-fsm/verification/report.md)을 남겼다.

- 기본 및 환경 확장 안전성, 정지·회전 종료 LTL: 총 4개 완전 탐색 통과(errors=0).
- T0–T14 전이 15개와 상태 5개: 도달성 witness 확보·재생. 타이머/C9/C16/C13을 어긴 시험용 변형 4개도 검출했다.
- 무조건적인 전진 복귀에는 반복 후진 반례가 있다. C5/C9의 허용 동작이며 교착이나 새 결함이 아니다. 센서가 언젠가 반드시 비워진다는 전제는 넣지 않았다.
- 검사 범위에서 새 이동 FSM 필수 수정 사항은 발견하지 못했다. P3-D01은 기존 SD의 초기 Forward 출력 설명과 C13의 불일치로, Phase 4에 전달한다. 기존 P2-I01의 선택적 참조 정리는 미적용 상태다.

초기 무출력·샘플 선행, 5틱 경계, 우측 우선, C9 및 C16의 이동 분기를 검사했다. D2/D3·청소 출력은 모델 범위 밖이며, 실제 C 준수·제품 테스트·커버리지·웹 시뮬레이터는 미검증이다. 입력 18개와 보호 파일 74개의 해시가 실행 전과 같음을 확인했다. 원본 요구사항/SA/SD/C는 수정하지 않았다.

Phase 3 검토 작업은 완료했다. 당시 다음 순서는 Phase 4였고, 이후 검토 결과를 아래에 추가했다. 이번 결과는 개정 SA 전체 승인이나 SD/구현 승인으로 간주하지 않는다.

## Phase 4 결과 — 2026-11-18

사용자 요청으로 `rvc-bmad-review`와 `rvc-speckit-review`를 적용했다. BMAD의 반론·경계조건·SASD 관점을 세 독립 하위 에이전트가 검토하고, 주 검토자가 원본 11개 지적을 반증·연결했다. [통합 보고서](artifacts/Review/20261118-093338-phase4-sd/bmad/report.md), [추적성 분석](artifacts/Review/20261118-093338-phase4-sd/traceability/report.md), [Superpowers 종료 점검](artifacts/Review/20261118-093338-phase4-sd/verification/report.md)을 남겼다.

| ID | 정리할 내용 | 판정 |
|---|---|---|
| P4-01 | 초기 Forward 출력 제거; C13에 맞춘 상태만 초기화 | HIGH, 필수 |
| P4-02 | 첫 Tick 전 초기 센서 샘플 확보·완료 단계 | MEDIUM, 필수 |
| P4-03 | D2 pending 상태 수명·소유자·초기화·소비 및 TA/인터페이스 | HIGH, 필수 |
| P4-04 | Tick 사이 TRUE→FALSE 감지를 보존하는 수신·직렬화 계약 | HIGH, 필수 |
| P4-05 | Q6 가정 표시를 확정 C16과 해결 이력으로 갱신 | MEDIUM, 필수 |
| P4-06 | D3=0이 SA에 없다는 오래된 근거 문구 정리 | LOW, 선택적 |

23개 요구사항을 모두 대조했다. mapped 15개·범위/환경 근거 3개·부분 연결 2개(B5/C12)·충돌 2개(C13/C15)·결정 상태 불일치 1개(C16)다. 모듈 26개와 호출/인터페이스 26개, SA 프로세스 13개 및 leaf 9개 영역의 구조적 대응을 확인했다. 이 수치는 문서 연결/구조 결과이며 구현 성공률이 아니다. C14는 DD/PSPEC 참조로 의미를 상속하므로 단순 ID 부재를 결함으로 만들지 않았다.

Phase 4 검토는 완료했지만 수정은 아직 적용하지 않았다. 원본 요구사항·SA·SD·C·테스트는 그대로이며 문서 검증 산출물만 추가했다. 기존 P2-I01도 미적용이다. 현재 SD의 계약 충돌을 수정·재검토하고 개정 SD에 대한 사람 승인을 받은 뒤 Phase 5의 C 준수 검사를 진행한다. 새 업무 규칙을 결정할 질문은 발견하지 못했으며, 이미 확정한 C12/C13/C15/C16의 SD 반영이 우선이다.

## Phase 4 수정 반영 및 재검토 — 2026-11-18

사용자의 수정 요청에 따라 P4-01–P4-06을 Transform Analysis와 Structure Chart에 반영했다. [수정/검증 보고서](artifacts/Review/20261118-095720-phase4-fixes/verification/report.md), [BMAD 재검토](artifacts/Review/20261118-095720-phase4-fixes/bmad/report.md), [최신 추적표](artifacts/Review/20261118-095720-phase4-fixes/traceability/matrix.md)를 남겼다.

- 초기화는 상태·타이머·센서 저장소를 준비하고 네 실제 샘플을 받은 뒤 종료한다. 초기 출력은 없다.
- 센서 이벤트와 Tick을 수신 순서대로 처리한다. 입력 수신은 D1/D2만 갱신하고 Tick만 한 제어 주기를 실행한다.
- D2는 지속 Sensor Store로 숨긴다. TRUE는 pending을 OR로 설정하고 FALSE는 보존한다. Forward에서 current/pending을 평가한 뒤 pending만 소비하며, 감지가 있으면 잔여량 대신 5틱을 재시작한다.
- Q6→C16 확정 이력과 D3=0의 최신 SA 근거를 갱신했다. C14 명령 의미도 출력 계약에 명시했다.

BMAD의 세 독립 관점 모두 추가 지적 없이 종료했다. 요구사항 23개와 30개 모듈의 문서 대응을 재검토하고, 31개 호출/인터페이스·13개 SA 프로세스·19개 흐름 이름·초기화 출력 경로 부재를 검사했다. Mermaid 5개를 렌더링하고 확인했다. 요구사항/SA/C/테스트/시뮬레이터 등 보호 파일 72개는 불변이다.

입력 어댑터는 기존 5개 입력 흐름을 묶는 설계 선택이며 외부 기능을 추가하지 않는다. 초기 샘플과 수신 이벤트를 무손실·순서대로 제공한다는 계약은 구현 시 검증해야 한다. 기존 C 및 tests/expected_calls.txt는 이전 설계이므로 이번 문서 검증으로 준수를 주장하지 않는다. 제품 테스트·SPIN·웹 시스템 테스트는 이번 실행에서 미실행이다.

**현재 상태: SD 수정 및 재검토 완료, 개정 SD 사람 승인 대기.** Phase 5는 아직 시작하지 않았다. 새로운 업무 결정을 물어볼 사항은 없었다. 기존 P2-I01 선택적 SA 요약 참조 정리는 미적용 상태로 남긴다.

## 개정 SD 승인 및 Phase 5 결과 — 2026-11-18

사용자가 “승인할게 phase5진행”으로 개정 SD를 승인했다. [승인 기록과 기준 해시](artifacts/Review/20261118-101242-phase5-c-compliance/approval.md)를 남기고 C 준수 감사를 수행했다. 앞선 승인 대기·Phase 5 미시작 문장은 해당 시점 이력이다.

[통합 보고서](artifacts/Review/20261118-101242-phase5-c-compliance/c-compliance/report.md), [23개 요구사항 매트릭스](artifacts/Review/20261118-101242-phase5-c-compliance/c-compliance/matrix.md), [31개 SD 호출 계약](artifacts/Review/20261118-101242-phase5-c-compliance/c-compliance/sd-interfaces.md), [Superpowers 종료 점검](artifacts/Review/20261118-101242-phase5-c-compliance/verification/report.md)을 작성했다. 네이티브 Trail of Bits Workflow 실행기는 없어 Codex 어댑터로 기준을 적용했다. 초기 독립 검토는 B1–B7/C1 완료, C2는 중단된 파일을 주 검토자가 확인, 나머지는 주 검토자가 요구사항별로 대조했다. 이후 별도 독립 검토자 3명이 여섯 지적을 모두 반증했고 유지됐다. 초기 전 항목 독립성은 완전히 재현하지 못했다.

| ID | 발견 사항 | 후속 조치 |
|---|---|---|
| P5-01 | 초기화에서 센서 판단 전에 Forward 출력(C13 충돌) | 상태만 초기화, 첫 Tick에 출력 |
| P5-02 | 첫 Tick 전 실제 네 샘플·준비 완료 단계 부재 | 초기 입력 확보·valid/readiness 구현 |
| P5-03 | 회피 중 먼지를 잊고 복귀 시 5틱 재시작하지 않음 | D2 pending 저장·Forward 소비·재시작 우선순위 |
| P5-04 | 승인된 이벤트 수신·dispatch·Sensor Store 및 접근 인터페이스 부재 | 생산 C/fake/시뮬레이터 경계에 새 SD 적용; 02/03과 공통 원인 |
| P5-05 | 초기 출력·감지 망각을 기존 테스트가 정답으로 기대 | 요구사항 기반 회귀와 승인 호출 기준으로 TDD |
| P5-06 | C16을 Q6 미확정 가정으로 부르는 테스트/구현 근거 | 선택적 이름·인용 정리; 이동 로직은 올바름 |

요구사항 판정은 implemented 15, partial 6, contradicted 1, undecidable 1이다. C4의 undecidable은 실제 환경 장애물 지속성을 C가 보장할 수 없다는 범위 한계다. C14는 추상 Clean 명령 수준에서 연결되며 물리 actuator 세기는 미검증이다. [개별 기록](artifacts/Review/20261118-101242-phase5-c-compliance/c-compliance/requirements/)에 하위 의무·경로·검색을 구분했다.

기존 GCC 빌드와 CTest 130개(단위 129+호출 검사1)가 통과하고 C 커버리지 115/115줄·36/36분기 결과(100%)를 새로 측정했다. 반면 개정 계약을 적용한 별도 검사 10개 assertion 중 6개는 실패·4개는 통과했다. 승인된 SD 호출 목록으로 checker를 실행하면 실패하며, 실제26/승인31 호출 중 누락14·이전9개를 확인했다. 기존 성공은 오래된 테스트 기준의 결과이며 개정 구현의 준수 판정이 아니다. [실행 명령·로그](artifacts/Review/20261118-101242-phase5-c-compliance/verification/execution-record.md)에 결과를 남겼다.

감사 입력 77개 보호 파일은 불변이다. C·기존 테스트·시뮬레이터는 수정하지 않았고, SPIN과 웹 시스템 테스트는 이번 감사에서 미실행이다. **Phase 5 감사 완료, 필수 수정 미반영, Phase 6 대기**다. 새 업무 결정을 질문할 사항은 발견하지 못했다. 후속 구현은 승인된 SD와 TDD에 따라 수정하고 테스트·커버리지·호출 계층·웹 시나리오를 재검증해야 한다. P2-I01 선택적 SA 참조 정리도 남아 있다.

## Phase 5 수정·재검증 — 2026-11-18

사용자의 “수정하자”에 따라 P5-01–P5-06을 구현에 반영했다. [수정 및 종료 점검 보고서](artifacts/Review/20261118-213657-phase5-fixes/verification/report.md), [실행 결과](artifacts/Review/20261118-213657-phase5-fixes/verification/results.json)를 남겼다. 이전 “필수 수정 미반영” 기록은 수정 전 감사의 이력이다.

- 초기화는 명령을 출력하지 않고 네 실제 샘플을 확보한다. 수신 이벤트/센서 dispatch와 private Sensor Store를 구현했다.
- D2는 TRUE를 pending에 저장하고 FALSE로 지우지 않는다. Forward에서만 소비하며 새 감지는 중단 잔여량보다 우선해5틱을 재시작한다. C9/C11/C16 이동·타이머 규칙은 유지했다.
- fake, C simulator host, Node/browser 연결을 ordered event 경계로 바꾸고 개별 센서 입력 API를 제공한다. tick0 센서값 표시와 ST-14/C16 근거도 갱신했다.
- 수정 전 회귀4개가 모두 실제 assertion 실패한 뒤 같은 기대값으로 통과했다. 현재 CTest121/121(단위120+호출1), 승인31호출, C140/140줄·62/62분기(100%) 통과다. 이전 polling/초기출력 테스트를 새 계약 검사로 교체한 수치다.
- 웹/API 회귀4개 묶음 및 ST-14 실제 UI18틱을 실행했다. 전체21개 시나리오는 별도 경로에100틱씩 새 trace를 기록했다. 사람 PASS/FAIL은 입력하지 않았다.

SA/SD 원문11개는 수정 전과 같다. 이동 FSM 알고리즘을 바꾸지 않아 SPIN은 재실행하지 않았고 기존 경계 회귀는 실행했다. 현재 상태는 **Phase 5 지적 수정·관련 재검증 완료, Phase 6 종합 검토 대기**다. 실제 하드웨어·사람 시스템 평가는 별도이며 P2-I01 선택적 SA 참조 정리도 남아 있다. 커밋/푸시는 하지 않았다.

## Phase 6 종합 검증 — 2026-11-19

사용자의 Phase6 요청에 따라 `rvc-superpowers-verify`와 Superpowers receiving-code-review/verification-before-completion 지침으로 기존 지적과 현재 코드·실행 결과를 종합했다. [최종 보고서](artifacts/Review/20261119-115842-phase6-final/verification/report.md), [통합 지적대장](artifacts/Review/20261119-115842-phase6-final/verification/finding-ledger.md), [실행 결과](artifacts/Review/20261119-115842-phase6-final/verification/results.json)를 남겼다. 이전 대기 표시는 당시 이력이다.

새 GCC/Ninja 빌드와 CTest121/121(단위120+호출1), 승인된 SD31개 호출 대조가 통과했다. 별도 음성 검사로 호출 누락/추가를 실제 검출하는지도 확인했다. 지정 coverage 목표로 C140/140줄·62/62분기 결과(각100%)를 새로 측정했다. 기존 테스트 직접 실행의 한글 경로 gcov 경고와 coverage 목표의 정상 측정을 구분해 보고했다.

21개 시나리오×100틱 headless trace를 별도 경로에 저장했고, 실제 Edge UI에서21개 초기화/첫 Tick을 확인했다. 초기 실측/무출력, Tick 사이 먼지 TRUE→FALSE 보존/소비/5틱 종료, 회피 새 감지의 잔여량 우선 재시작, ST-14 UI18틱 회귀도 통과했다. 브라우저 오류는0개다. 사람 PASS/FAIL 폼은 입력하지 않았다.

통합 지적24개 중22개 해결, P2-I01은 선택적 문서 개선 대기, P3-N01 반복 후진은 결함 아님으로 남긴다. 중복 계층 지적을 독립적인 코드 결함 수로 세지 않았다. 새 필수 수정 사항은 발견하지 못했다. 입력84개는 불변이며 C·테스트·시뮬레이터·요구사항/SA/SD를 이번에 수정하지 않았다. SPIN은 재실행하지 않았고 Phase3의 요구사항/SA11개 해시 동일성과 당시 모델 결과의 적용 범위만 확인했다.

**현재 상태: Phase6 자동 종합 검증 완료, 사람의 시스템 평가·최종 승인 대기.** [평가 방법과21개 대기 목록](artifacts/Review/20261119-115842-phase6-final/system/human-evaluation.md)을 참고한다. 물리 하드웨어는 B6 범위 밖이며 커밋/푸시는 수행하지 않았다. 선택적 P2-I01 정리와 사람 판정을 자동 검증 통과에 포함하지 않는다.


## 잔여 항목 정리 및 Codex 평가 — 2026-11-19

사용자의 “해줘”에 따라 P2-I01 참조 정리(C9/C12/C13)를 두 줄에 반영했다. 본문 동작·Mermaid·생산 C·테스트는 동일하다. [정리/평가 보고서](artifacts/Review/20261119-130006-closeout/verification/report.md), [최종 점검](artifacts/Review/20261119-130006-closeout/verification/results.json)을 남겼다. 기존 “P2-I01 미적용” 표시는 당시 이력이다.

시나리오21개 모두 실제 브라우저에서 각각100틱 실행하고, prose에서 고정한 명령/틱 구간과100틱 기본 불변식을 대조하여 **Codex 자동 평가21 PASS/0 FAIL**을 기록했다. 평가자와 관찰란에 자동 평가·사람 최종 승인 대기를 명시했고 UI에서 평가/trace를 저장했다. [결과](artifacts/Review/20261119-130006-closeout/system/evaluations.json)에 저장 경로와 비교 범위가 있다.

통합24개 중23개 해결, P3-N01 한 개는 결함 아님이다. 수정 대기 항목은 없고 **독립 사람 평가·사용자의 최종 승인만 대기**다. Codex의 PASS를 사람 판정으로 바꾸지 않았다. 이전 Phase6 테스트/커버리지 수치는 그 실행의 근거로 유지하며 문서 참조 정리 뒤 C 테스트·SPIN은 불필요하게 반복하지 않았다.
