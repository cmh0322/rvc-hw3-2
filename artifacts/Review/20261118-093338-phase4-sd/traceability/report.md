# RVC-adapted Spec Kit Phase 4 분석

입력 기준: 2026-11-18T09:33:38.420761+09:00 (Asia/Seoul), Git HEAD `dea14b590b5246e1889119fc9040c5df496bd987`, 미커밋 작업 트리. 실제 입력 해시/상태는 `../input-manifest.json`에 보관.

기존 SASD 문서를 `.specify/rvc-review-map.toml`로 연결하여 6개 탐지 관점을 적용했다. 네이티브 feature/tasks workflow, prerequisite 명령, 새 spec/plan/tasks 생성은 실행하지 않았다. 모듈/호출/타입의 실제 근거를 읽었으며 C 및 테스트 색인은 경로 존재만 확인했다.

## 검토 범위와 분모

B1–B7/C1–C16의 **23/23개 요구사항을 SD와 대조**했다. 상태 분포: {"mapped": 15, "partial": 2, "scope-justified": 3, "conflict": 2, "stale-status": 1}. mapped 15개는 해당 요구사항의 문서 동작이 연결된 것, scope-justified 3개는 B6/B7/C4 범위·환경 근거다. partial 2개(B5/C12), conflict 2개(C13/C15), stale-status 1개(C16)는 준수 완료로 세지 않는다. 요구사항과 모듈 이름이 연결된 비율을 제품 성공률로 표현하지 않는다. C 심볼/단위·시스템 테스트는 모든 행에서 notChecked다.

[매트릭스](matrix.md) · [기계 판독 매트릭스](matrix.json) · [역방향 추적](reverse-map.md) · [지적/수정안](findings.json)

## 6개 탐지 관점

| 관점 | 결과 |
|---|---|
| Duplication | 새 요구사항 중복은 발견하지 못함. TA/SC에 같은 동작을 반복 기술한 것은 문서 역할 차이이며 자체 결함은 아님. |
| Ambiguity | C12의 초기 샘플/첫 Tick 경계가 SD에 명시되지 않음(P4-02). 업무 결정을 다시 물을 문제가 아니라 기존 SA로 정렬할 문제. |
| Underspecification | D2 소유권·초기화·보존·소비·입력 수신 직렬화 계약 누락(P4-03/04). |
| Project-rule alignment | AGENTS의 SA–SD 일관성/추적성에 비추어 초기 출력, C15, 결정 상태 정리가 필요. 기존 승인 이력을 최신 준수 승인으로 볼 수 없음. |
| Coverage gaps | 모든 13개 프로세스와 26개 모듈은 연결되지만 행동/시간/저장소 계약은 위 partial/conflict 행에서 부족. |
| Inconsistency | C13 초기 출력(P4-01), D2 비영속·polling(P4-03/04), Q6 가정 상태(P4-05), D3 근거 문구(P4-06). |

## 구조 점검 근거

호출 그래프의 조건 다이아몬드를 모듈로 세지 않고 MC→Start Step Timer로 해석했다. 모듈 설명, 계층의 26개 호출, 인터페이스 26개가 동일하다. 13개 SA 프로세스/9개 leaf 영역도 대응한다. TA에 없는 SA 흐름 이름은 Pending Dust Detection 1개이며, D2→P2의 기존 record 읽기와 P4.1→D2의 pending 갱신 연결도 최신 SA 대비 빠져 있다. 이름 존재 검사는 이 의미 차이를 대신하지 않는다.

자료가 없다는 판정의 검색 범위는 SD 두 파일 전체이며 `pending|C1[2-6]` 검색 결과 0건을 `verification/structure-evidence.json`에 기록했다. 문자열 부재만으로 C14를 결함으로 판정하지 않았고 Dictionary/PSPEC 상속을 반증 근거로 검토했다. mapped 경로 21개는 존재한다. task coverage는 해당 없음이다.

[체크리스트](checklist.md)는 팀의 문서 품질 검토 질문이며 모두 미표시로 생성했다. 이번 분석 판정은 보고서에 별도 기록했다. 자동 문서 체크 성공은 SD 승인이나 실행 테스트 성공을 뜻하지 않는다.
