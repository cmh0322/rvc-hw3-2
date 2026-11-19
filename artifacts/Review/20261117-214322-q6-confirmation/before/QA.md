# RVC 검증 계획

계획 합의일: 2026-11-17 (Asia/Seoul)

Claude로 작성한 RVC 산출물을 Codex가 독립적으로 검토한다. 순서는 **BMAD → Spec Kit → FSM Verify → BMAD + Spec Kit → C Compliance → Superpowers**이며, 각 Phase 끝에서도 Superpowers로 지적의 타당성과 검증 근거를 확인한다.

## 공통 운영 원칙

- [공통 검증 규약](docs/verification/review-contract.md)과 [프로젝트 지침](AGENTS.md)을 따른다. 이 QA Phase는 검토 작업의 순서이며 기존 SA → SD → TDD → 시스템 테스트의 승인 단계를 대체하지 않는다.
- 기준은 원본 요구사항 B1–B7, 확정 결정 C1–C15, 승인된 SA·SD이다. Q6는 가정으로 유지한다. 검토한 파일의 SHA-256, Git HEAD와 작업 트리 상태를 기록한다.
- 각 Phase는 검토 → 지적 반증·분류 → 필요한 결정/수정안 정리 → Superpowers 종료 점검 → 결과 공유로 진행한다. 수정은 별도 요청 범위에서 수행하고, 영향받는 이전 검토를 다시 확인한다.
- 지적은 확정 결함 / 요구사항 모호함 / 선택적 개선으로 구분한다. 원본 산출물과 코드는 이번 검토 요청만으로 수정하지 않는다. 중대한 미해결 사항은 후속 Phase의 전제·제약으로 남긴다.
- 문서 리뷰, C 준수 검사, 실행 테스트, SPIN 모델 검사를 별도 상태로 기록한다. 과거 테스트 수나 커버리지를 이번 결과로 재사용하지 않는다.
- 실행별 결과는 `artifacts/Review/<run-id>/`에 보관한다. 기존 결과를 덮어쓰지 않는다. Phase 진입/종료 상태와 다음 조치를 이 문서에 갱신한다.

## Phase별 계획

| Phase | 주 담당 | 범위와 수행 내용 | 산출물 및 종료 기준 |
|---|---|---|---|
| 1 | `rvc-bmad-review` | 요구사항 + SA 전체. Event List → Context → DFD 0–3·Data Dictionary·Process Specifications → Level 4 FSM 인터페이스 순으로 검토. 반론, 경계조건, SASD 일관성의 세 관점 사용 | `bmad/report.md`, `bmad/findings.json`, 입력 목록·부모별 balancing 근거. 지적마다 출처·조건·영향·최소 수정안과 재검토 판정 기록 |
| 2 | `rvc-speckit-review` | 요구사항 ↔ SA 추적성, 누락·중복·모호함 확인. 기존 문서를 `.specify/rvc-review-map.toml`로 연결 | `traceability/` 보고서·매트릭스·체크리스트. B1–B7/C1–C15의 적용 여부와 Q6 구분, 미연결 항목 설명 |
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
| 2 | 추적성 리뷰·종료 점검 완료 | [Spec Kit 적용 보고서](artifacts/Review/20261117-212640-phase2-traceability/traceability/report.md), [매트릭스](artifacts/Review/20261117-212640-phase2-traceability/traceability/matrix.md), [종료 점검](artifacts/Review/20261117-212640-phase2-traceability/verification/report.md). 확정 22개 모두 SA 근거 연결; Q6 가정 유지, LOW 선택적 참조 개선 1개. 원문 수정·제품 실행 검증 없음 |
| 3 | 대기 | 요구사항 모호함을 명시한 모델/속성으로 검증 |
| 4 | 대기 | 검토된 SA와 승인 범위를 기준으로 SD 검토 |
| 5 | 대기 | 승인된 SA·SD 버전 확인 후 구현 대조 |
| 6 | 대기 | 각 Phase 근거와 수정 결과를 종합 |

첫 실행은 계획 작성과 Phase 1 수행이었다. 후속 요청에 따라 Phase 1 답변 반영과 **Phase 2 수행 및 종료 점검**까지 진행했다. Phase 3 이후는 아직 실행하지 않았다.

## Phase 1 답변 반영 — 2026-11-17

사용자의 네 답변을 [C12–C15](docs/requirements_clarifications.md)에 기록했다. C12는 첫 Tick 전 네 센서 읽기, C13은 상태만 초기화하고 첫 Tick에 출력, C14는 흡입만 강화하며 물걸레는 정상 유지, C15는 회피 중 먼지를 기억하여 복귀 시 5틱 시작·재시작이다. C9 자료형·Q4/Q5 결정 상태·D3=0도 함께 정리했다. Q6는 계속 가정이다.

C15의 분석 실현으로 D2를 `Dust Detected + Pending Dust Detection` 레코드로 확장했다. Process 2가 TRUE 입력을 기억하고, Process 4.1이 Forward Tick에 소비한다. FALSE 입력은 미처리 감지를 지우지 않는다. 보존된 잔여 틱과 감지가 함께 있으면 C15의 5틱 재시작이 우선한다. 기존 리뷰 보고서와 수정 전 스냅샷은 이력으로 보존한다.

### 후속 단계에 넘길 변경

| 후속 단계 | 반영/확인할 항목 | 현재 상태 |
|---|---|---|
| Phase 2 | B1–B7/C1–C15 ↔ SA 추적성, D2 새 필드 및 소비 흐름, Q6 가정 | 검토 완료 — 아래 Phase 2 기록 참조 |
| Phase 3 | T0 무출력 초기화와 첫 Tick, D4 경계. 청소 합성 모델 범위에 들어갈 경우 C15 감지 보존·재시작도 포함 | 대기; SPIN 미실행 |
| Phase 4 | D2 레코드·reader/writer 및 초기화/입출력 의미를 Transform Analysis·Structure Chart·모듈 인터페이스에 전파 | SD 미수정. 기존 승인은 개정 전 버전의 이력이며 C12–C15 준수 승인으로 간주하지 않음 |
| Phase 5–6 | 개정 SD 승인 후 C12–C15의 C 준수 확인, 필요한 TDD 수정·회귀 및 시뮬레이터 검증 | C·테스트·시뮬레이터 미수정/미실행 |

사용자 답변은 요구사항 결정과 SA 수정의 근거다. 개정 SA 전체의 승인 또는 SD·구현 단계로의 자동 진입 승인을 대신하지 않는다.

## Phase 2 결과 — 2026-11-17

`rvc-speckit-review`로 기존 SASD 문서에 Spec Kit의 분석 방법을 적용했다. 원본 feature/tasks workflow 실행과 구분한다. 요구사항 22개(B1–B7/C1–C15)의 관련 SA 근거를 연결하고 Q6는 별도 가정 행으로 유지했다. 흐름 19개·프로세스 13개·저장소 4개·상태 5개·T0–T14의 역방향 근거도 기록했다.

새로운 필수 동작 누락/상충은 발견하지 못했다. P2-I01은 PSPEC 3.2.2의 C12/C13, Level 3의 3.2.1 C9 요약 참조를 본문과 맞추는 LOW 선택적 개선이며 아직 적용하지 않았다. Q6(P2-A01)는 기존 가정이다. 22/22는 문서 근거 연결률이지 구현 성공률이 아니다.

[팀용 품질 체크리스트](artifacts/Review/20261117-212640-phase2-traceability/traceability/checklist.md)는 새 질문 15개를 미표시 상태로 생성했다. 분석 결과는 보고서에 별도로 기록했다. SD·C·테스트는 notChecked, SPIN/제품 테스트는 notRun이다. 다음 검토 순서는 Phase 3 FSM Verify이며 사람 승인 규칙은 유지한다.
