# Q6 → C16 확정 및 문서 종료 점검

결정일: 2026-11-17 (Asia/Seoul). 범위: P2-A01의 사용자 결정 반영과 영향받는 SA·검증 지침의 제한적 재점검.

사용자 답변: “그대로 전진·청소한다. 전방 장애물만 회피 시작 조건으로 확정한다”.

Q6는 **C16으로 확정·해결**했다. Forward에서 전방이 비어 있으면 좌우 어느 쪽 또는 양쪽이 막혀도 전진·청소를 유지한다. 먼지에 따른 청소 강도는 기존 요구사항을 따른다. 후진 종료 시 좌우만 판단하는 C9는 유지한다.

## 근거와 추적

| 대상 | 근거 | 판정 |
|---|---|---|
| 요구사항 | `docs/requirements_clarifications.md:24`, Q6 해결 이력 `:43` | 사용자 승인 결정 C16, 미확정 가정에서 제외 |
| 입력/분류 | `artifacts/SA/DFD/dfd_level_2.md:42`, `artifacts/SA/data_dictionary.md:188` | Front Blocked와 Side Situation을 계속 별도로 제공; 좌우 센서를 제거하는 결정이 아님 |
| 이동 | `artifacts/SA/process_specification.md:520`, `artifacts/SA/DFD/dfd_level_4_fsm.md:64` | T1은 전방이 비면 Forward, T2는 전방이 막히면 Stopping. C16 참조 추가, 조건·동작 동일 |
| 청소 | `artifacts/SA/process_specification.md:567`, `:425` | Forward 명령 → Movement Status Forward → Start 또는 Power Up. 좌우만 막힌 경우 Stop으로 바뀌지 않음 |
| 후진 | `artifacts/SA/DFD/dfd_level_4_fsm.md:71`의 T8–T10 | C9의 좌우 기반 후진 반복/회전 판단 유지 |
| 후속 검증 | `.specify/rvc-review-map.toml`, 공통 규약·프로젝트 어댑터 | 확정 ID 23개, Q6는 C16의 해결 이력. 기존 보고서는 수정하지 않음 |

문서 반례 점검: Forward/front clear에서 좌우 네 조합 모두 T1 조건을 만족하고 T2 조건은 만족하지 않는다. Backing/front clear에서는 Step Done과 좌우에 따라 T8/T9/T10이 가능하므로 C16을 모든 상태의 회피 해제 조건으로 일반화하지 않는다. 이는 원문 조건 대조이며 SPIN 실행 결과가 아니다.

## 실행 근거

`rvc-superpowers-verify`와 설치된 Superpowers의 `receiving-code-review`, `verification-before-completion` 지침을 적용했다. 주 검토자가 수행한 제한적 문서 재점검이며, BMAD 독립 에이전트 리뷰나 Spec Kit 전체 분석의 재실행은 아니다. 이전 Phase 2 결과의 22개 + Q6 행은 당시 증거로 보존한다.

프로젝트 루트에서 실행:

```text
python artifacts/Review/20261117-214322-q6-confirmation/verification/verify_decision.py
```

해당 명령은 `check_documents.py`와 `git diff --check`도 실행한다. 결과는 [decision-checks.json](decision-checks.json), [document-checks.json](document-checks.json), [문서 검사 로그](document-checks.log), [diff 검사 로그](diff-check.log)에 기록한다. 종료 코드 0: DFD 경계 5개 일치, 프로세스 13개와 PSPEC 대응, 흐름 19개 정의, FSM 전이 15개의 조건·동작 및 모든 SA Mermaid 블록 불변, C9 원문 불변, 보호 파일 113개 불변을 확인했다.

[baseline.json](../baseline.json)에 실행 전 Git HEAD·변경 상태와 보호 파일 SHA-256, `before/`에 수정 전 문서, [입력 목록](../traceability/input-manifest.json)에 최신 입력 해시를 보관한다. 수정 파일과 최종 해시는 `decision-checks.json`에 기록한다.

SD·C 준수는 미검토, 제품 테스트·SPIN·Mermaid 렌더링은 미실행이다. 이번에는 다이어그램 구문과 동작을 바꾸지 않았다. P2-I01 선택적 참조 정리는 미적용이며, 다음 Phase나 개정 SA 전체를 승인한 것으로 간주하지 않는다.
