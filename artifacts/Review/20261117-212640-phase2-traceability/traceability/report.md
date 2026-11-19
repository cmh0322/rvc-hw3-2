# Phase 2 — 요구사항 ↔ SA 추적성 검토

**검토 완료. B1–B7/C1–C15의 22개 항목 모두 관련 SA 근거에 연결되며, 이번 범위에서 새로운 필수 동작 누락이나 상충은 발견하지 못했다.** 기존 Q6 가정은 계속 남아 있고, 요약 참조 목록을 정리할 선택적 개선 1개를 기록했다. 이는 문서 검토 결과이며 구현·테스트·SPIN 성공 판정이 아니다.

## 방법과 범위

- 날짜/실행 ID: 2026-11-17 (Asia/Seoul), `20261117-212640-phase2-traceability`.
- 방법: **RVC-adapted Spec Kit analysis**. `rvc-speckit-review`를 통해 설치된 Spec Kit `speckit-analyze`의 6가지 분석 방법과 `speckit-checklist`의 요구사항 품질 관점을 적용했다. 로컬 `uv tool list`에서 specify-cli v1.4.1을 확인했다.
- 원본 Spec Kit의 feature/spec.md/plan.md/tasks.md workflow나 prerequisite 명령을 실행하지 않았다. 프로젝트 매핑 `.specify/rvc-review-map.toml`을 사용했으며, 미작성 constitution 템플릿 대신 AGENTS와 공통 검증 규약을 준거로 삼았다. 새 feature/tasks/branch를 만들지 않았다.
- Git HEAD: `dea14b590b5246e1889119fc9040c5df496bd987`; 기존 Phase 1 수정과 도구 설치가 미커밋 상태다. 입력 11개 파일의 SHA-256·1,591줄 및 시작 상태를 [manifest](input-manifest.json), 당시 원문을 [snapshot](source-snapshot.md)에 보존했다.
- 읽은 대상: 요구사항 2개, Event List, Context, DFD 0–4, Data Dictionary, PSPEC. QA의 Phase 2 범위에 따라 요구사항→SA만 의미 대조했다. 매핑에 있는 SD/구현·시스템 보고서는 경로 존재만 확인했으며 내용 준수 판정에 사용하지 않았다.
- 종료 점검: `rvc-superpowers-verify`와 활성 Superpowers `bd2122cb`의 receiving-code-review/verification-before-completion. 같은 주 검토자가 원문을 재대조했다. 독립 검토자 실행이나 독립 반증이 있었다고 보고하지 않는다.

## 산출물

- [정방향 매트릭스](matrix.md): 요구사항별 원문·이벤트·프로세스·사전·FSM 적용 여부와 조건. [JSON](matrix.json)에는 SD/C/단위·시스템 테스트 열도 행마다 `notChecked`로 명시했다.
- [역방향 매핑](reverse-map.md): 흐름 19개·프로세스 13개·저장소 4개·상태 5개·T0–T14에서 요구사항으로 되돌아가는 근거.
- [품질 체크리스트](checklist.md): 팀 검토자가 사용할 문서 품질 질문 15개. 새 체크박스는 모두 미표시이며 테스트 미실행/실패를 의미하지 않는다.
- [종료 점검 및 실제 검사](../verification/report.md).

## 6가지 분석 결과

| 분석 | 검토한 내용 | 결과 |
|---|---|---|
| 중복 | B3/B4와 C1–C9, B5와 C3/C10/C11/C15 관계 | B/C는 원본과 세부 결정의 관계. 서로 다른 요구사항의 우발적 중복으로 판정하지 않음. C11/C15는 보존과 복귀 재시작 우선순위로 함께 정의됨 |
| 모호함 | B3의 sensors, B5의 for a while, 출력 의미, Q1–Q6 | 기간은 C3, 물걸레 의미는 C14, 회피 감지는 C15로 명확해짐. Q1–Q5는 해결, Q6는 기존 가정으로 남음. 새 미해결 placeholder 없음 |
| 불충분한 명세 | 초기 샘플, 출력 시점, D3/D4 초기값, 감지 수신·소비 순서 | C12/C13과 PSPEC 0/1/2/4.1로 연결. TRUE→FALSE 및 잔여 틱과 pending 충돌도 명시. 이번 범위에서 새로운 필수 명세 누락 없음 |
| 프로젝트 규칙 정합 | SA 산출물, DFD 부모 경계, PSPEC 범위, 승인·Q6 처리 | Level 0–3의 13개 프로세스 명세 존재, Level 4는 FSM. 인간 승인이나 이후 단계 진입을 자동 처리하지 않음. 실행 테스트 성공 주장 없음 |
| 커버리지 | B1–B7/C1–C15→관련 SA 근거, SA→요구사항 역방향 | 22개 모두 근거 연결. B6/B7은 범위 제약으로 검토. 직접 FSM 전이가 없는 청소/초기 입력 항목은 사유를 적음 |
| 불일치 | C9 record·Q6 적용 범위, C10/C11/C15, D2 writer/reader, 초기 출력 | 동작 계약의 새 충돌 없음. PSPEC/DFD 요약 요구사항 목록의 부분적인 최신 참조 누락은 P2-I01로 분리 |

검색 보조로 요구사항 두 파일과 SA 전체의 `TODO`, `TBD`, `TKTK`, `placeholder`, `Open:`, `remain open`, 이전 C9 enum 표현을 확인했다. 발견되지 않았다는 검색 결과는 [검사 출력](../verification/review-checks.json)에 있으며, 의미 판단은 해당 절을 직접 읽어 수행했다.

## 관찰 사항

### P2-A01 — 기존 Q6 가정 유지

- 종류: 기존 요구사항 모호함. Spec Kit 분류 `Ambiguity`, 참고 심각도 `MEDIUM`; 신규 결함 수에는 포함하지 않음.
- 원문: `docs/preliminary_requirements.md:3`은 sensors의 장애물을 포괄적으로 기술한다. `docs/requirements_clarifications.md:42`는 front clear일 때 측면 장애물을 무시한다고 가정한다.
- SA 대응: `process_specification.md:175,291`, `DFD/dfd_level_4_fsm.md:64–65`는 Forward에서 front만 회피 진입에 사용한다.
- 조건: Forward, front=FALSE, left 또는 right=TRUE에서 계속 Forward. 이 동작은 Q6 가정 아래에서는 일관적이다.
- 처리: Q6를 확정으로 올리지 않았다. Phase 3의 모델 속성/보고서에도 Q6 조건을 명시해야 한다. 사용자가 이 가정을 바꾸면 B3 관련 추적 행과 FSM을 다시 검토한다. 이번 단계의 검토 완료와 별개로 가정 자체는 열린 상태다.

### P2-I01 — 요약 요구사항 참조 목록의 정리

- 종류: **선택적 개선**, Spec Kit 분류 `Inconsistency`, 심각도 `LOW`. 동작 결함 또는 요구사항 미구현 판정이 아니다.
- 근거 1: `process_specification.md:516`은 C12/C13을 본문에 명시하지만 같은 Process 3.2.2의 Relevant Requirements 목록 `:537–538`에는 둘이 없다. `DFD/dfd_level_3.md:56`은 C13을 이미 포함한다.
- 근거 2: `process_specification.md:482,485–486`은 3.2.1의 record 전달에 C9를 명시하지만 `DFD/dfd_level_3.md:55`의 Requirements 칸은 B3/B4/C1만 나열한다.
- 조건/영향: 요약 Requirements 칸만 추출하는 팀 도구는 C12/C13/C9 연결을 놓칠 수 있다. 전체 본문을 읽으면 의미와 출처를 찾을 수 있어 본 매트릭스의 누락으로 계산하지 않는다.
- 최소 개선안: 해당 목록에 본문의 최신 근거를 동기화하거나 목록이 대표 근거임을 표시한다. 현 요청은 Phase 2 리뷰이므로 원문은 변경하지 않았다.
- 반증 결과: 규칙이 모든 참조 칸의 완전 나열을 강제하지 않으므로 확정 기능 결함으로 확대하지 않았다.

## 근거를 확인하고 제외한 지적

| 후보 주장 | 반증 근거 | 처리 |
|---|---|---|
| C11과 C15가 서로 모순 | requirements_clarifications:27, PSPEC:365–395에서 회피 중 보존/복귀 때 pending 우선 재시작을 구분 | 결함에서 제외 |
| D2가 Boolean이라고 가정하면 새 pending이 누락 | DD:129–178의 두 Boolean record, PSPEC:130–142/378–392, Level 1:33–38과 Level 2:71–77 | 수정된 레코드/흐름의 추적 확인 |
| Power On 이벤트가 Context에 없으므로 balancing 위반 | C13, Event:38, Level 4:T0는 출력 없는 내부 초기화 | 외부 이벤트 추가 요구 제외 |
| B6/B7 또는 C14/C15에 직접 FSM 전이가 없으므로 누락 | B6/B7은 범위, C14는 출력 의미, C15는 D2/4.1 청소 처리 | 해당 없음의 사유로 표기 |
| DFD 3.2.2 외에 Level 4 PSPEC이 필요 | AGENTS가 Level 4에는 FSM을 사용하고 별도 PSPEC을 금지 | 새 PSPEC 생성 요구 제외 |
| 후진 반복은 반드시 교착/종료 실패 | C5/C9, T8은 양측 차단 시 반복 허용 | 무조건 eventual Forward를 요구하지 않음 |

## 지표와 해석

| 항목 | 결과 |
|---|---|
| 확정 요구사항/결정 | 22개: B1–B7 + C1–C15 |
| 검토한 요구사항→SA 근거 묶음 | 22/22 연결; B3의 회피 진입은 Q6에 조건부 |
| 기존 가정 | Q6 1개, 분모에서 제외 |
| 새 필수 동작 누락/상충 | 발견 0개 |
| 새 개선 항목 | LOW 선택적 개선 1개 |
| CRITICAL/HIGH 신규 항목 | 0개 |
| task coverage | N/A — native Spec Kit task workflow가 아님 |
| SD/C/단위·시스템 테스트 준수 | notChecked |
| 제품 테스트·SPIN | notRun |

22/22는 이 보고서에 정의한 요구사항별 SA 근거 연결률이다. 모든 교차 링크의 완전성, 실행 성공률, 기능 구현률로 해석하면 안 된다. `notChecked`는 `absent`나 `PASS`가 아니다.

## 다음 단계

계획상 다음은 Phase 3 FSM Verify이다. T0는 출력 없는 초기화, C9는 후진 종료에서 front 독립, C4는 정지 중 전방 지속이라는 환경 전제, Q6는 명시적 가정으로 모델에 전달한다. C15를 검증하려면 Movement FSM만으로는 부족하며, D2·D3·2/4.1/4.2를 포함하는 별도 청소 합성 범위를 선언해야 한다.

Phase 4 이후의 SD/C/테스트 전파 대기는 유지한다. Phase 2를 완료했다고 기존 SD나 C가 C12–C15를 충족한다고 판단하지 않았다. [QA.md](../../../../QA.md)에 현재 상태와 결과 링크를 갱신했다.
