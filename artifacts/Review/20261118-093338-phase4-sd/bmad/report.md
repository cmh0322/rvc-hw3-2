# Phase 4 — SA↔SD 검토 결과

입력 기준: 2026-11-18T09:33:38.420761+09:00 (Asia/Seoul), Git HEAD `dea14b590b5246e1889119fc9040c5df496bd987`, 미커밋 작업 트리. 실제 입력 해시/상태는 `../input-manifest.json`에 보관.

최신 요구사항/SA를 기준으로 기존 Transform Analysis와 Structure Chart를 검토했다. **검토는 완료했지만 현재 SD를 최신 SA 준수 상태로 승인할 수 없다.** 수정 권고 5개와 선택적 근거 문구 정리 1개를 기록했다. 요구사항·SA·SD·C는 수정하지 않았다.

BMAD adversarial, edge-case-hunter, sasd를 서로 다른 하위 에이전트가 독립 수행했다. 원본 11개 지적은 [findings.json](findings.json)에 관점별로 그대로 보관하고, 주 검토자가 아래 수정 책임별로 연결·반증 검토했다. 프로젝트 규약의 심각도는 아래 triage에만 붙였으며 BMAD 원본 결과에는 추가하지 않았다. RVC-adapted Spec Kit의 결과는 [추적성 보고서](../traceability/report.md)에 있다.

## 통합 판정

| ID | 심각도/분류 | 문제 | 최소 수정 방향 |
|---|---|---|---|
| P4-01 | HIGH / 확정 설계 충돌 | 초기 Forward 출력이 C13/T0와 충돌 | 초기화의 출력 호출 및 Forward 반환 계약을 제거하고 상태·타이머·pending 초기화만 남긴다. 첫 Tick만 센서 판단 후 명령을 출력하도록 호출도·모듈 설명·인터페이스·T0 추적을 함께 갱신한다. |
| P4-02 | MEDIUM / 확정 SA→SD 순서 누락 | 첫 Tick 전 초기 센서 샘플 확보 단계 누락 | 초기 샘플 확보와 완료 조건, 첫 Tick이 사용하는 입력 스냅샷을 초기화/입력 모듈 호출 계약에 명시한다. 함수 이름이나 캐시 배치는 설계 선택으로 결정하되 최신 SA의 시간 순서를 보존한다. |
| P4-03 | HIGH / 확정 상태·인터페이스 누락 | D2의 pending 감지 수명·소유자·소비 경로 누락 | D2를 지속 숨김 상태로 설계하고 초기 FALSE, Detect Dust의 OR 갱신, Track Power-Up의 Forward 소비/해제 책임을 정한다. TA의 D2→P2 읽기 및 P4.1→D2 Pending Dust Detection, 경계 설명과 SC 인터페이스를 갱신한다. |
| P4-04 | HIGH / 확정 입력 수신 계약 누락 | Tick당 현재값 polling만으로 Tick 사이 감지 보존 불가 | 입력 수신 시 감지를 래치하고 Tick 소비와 논리적으로 직렬화하는 계약을 추가한다. 콜백·이벤트 어댑터·보존된 감지 전달 중 구현 방식은 SD 설계 선택이며 실제 하드웨어 구현은 B6 밖이다. |
| P4-05 | MEDIUM / 확정 결정 상태 불일치 | 확정 C16을 Q6 가정으로 표시 | Q6→C16 해결 이력과 현재 요구사항 범위를 갱신한다. 예전 승인 시점 기록은 이력으로 보존하고 최신 개정의 승인 상태를 구분한다. |
| P4-06 | LOW / 선택적 근거 문구 정리 | D3 초기값이 SA에 없다는 설명이 오래됨 | D3=0의 근거를 최신 PSPEC/Dictionary로 갱신한다. 초기값 동작을 바꿀 필요는 없다. |

## P4-01 — 초기 Forward 출력이 C13/T0와 충돌

근거: docs/requirements_clarifications.md:21; artifacts/SA/DFD/dfd_level_4_fsm.md:63; artifacts/SD/structure_chart.md:68–71; artifacts/SD/structure_chart.md:257–265; artifacts/SD/structure_chart.md:309–312; artifacts/SD/structure_chart.md:386; artifacts/SD/structure_chart.md:404.

조건/반례: 전방이 막힌 채 전원을 켜면 첫 Tick의 Stop 판단 전에 Initialize RVC가 Forward를 출력한다.

판정·범위: P3-D01/P1-05의 SD 전파 항목 재확인. 상태: 수정안 작성, 미적용. 연결된 원본 finding 배열 인덱스(0부터): [0, 3, 7].

## P4-02 — 첫 Tick 전 초기 센서 샘플 확보 단계 누락

근거: docs/requirements_clarifications.md:20; artifacts/SA/process_specification.md:38–54; artifacts/SA/event_list.md:26; artifacts/SD/structure_chart.md:64–79; artifacts/SD/structure_chart.md:286; artifacts/SD/structure_chart.md:399.

조건/반례: 현재 SD는 Initialize → Wait For Tick → Controller/Get Inputs 순서다. 최신 SA는 첫 Tick 이전에 네 샘플을 완성하도록 정했다.

판정·범위: C12의 SD 전파 누락. 이미 결정 전에 센서를 읽으므로 미초기화 값 사용이 확정되었다고 주장하지 않음. 상태: 수정안 작성, 미적용. 연결된 원본 finding 배열 인덱스(0부터): [1, 4, 8].

## P4-03 — D2의 pending 감지 수명·소유자·소비 경로 누락

근거: docs/requirements_clarifications.md:23; artifacts/SA/data_dictionary.md:159–178; artifacts/SA/process_specification.md:365–392; artifacts/SD/structure_chart.md:290–298; artifacts/SD/structure_chart.md:327; artifacts/SD/structure_chart.md:375; artifacts/SD/transform_analysis.md:33; artifacts/SD/transform_analysis.md:50; artifacts/SD/transform_analysis.md:139–159.

조건/반례: 회피 Tick에 TRUE를 읽어도 전진 복귀 전에 FALSE면 D2가 사라져 5틱 재시작을 할 근거가 없다. 잔여 2틱이 있었다면 C15는 5틱 재시작이어야 한다.

판정·범위: C15 전파; 데이터 사전 타입 참조만으로 명시적 비영속 설계를 해소할 수 없음. 상태: 수정안 작성, 미적용. 연결된 원본 finding 배열 인덱스(0부터): [2, 6, 9].

## P4-04 — Tick당 현재값 polling만으로 Tick 사이 감지 보존 불가

근거: docs/requirements_clarifications.md:30; artifacts/SA/process_specification.md:128–142; artifacts/SA/process_specification.md:372; artifacts/SD/structure_chart.md:262; artifacts/SD/structure_chart.md:399.

조건/반례: 회피 중 두 Tick 사이 TRUE 입력과 FALSE 입력을 순서대로 수신해도 다음 Tick의 현재값은 FALSE다. D2 저장소만 추가하고 polling을 유지해도 놓친 TRUE를 복원할 수 없다.

판정·범위: P4-03과 연결되지만 저장소 수명과 입력 포착은 별도 수정 책임. 상태: 수정안 작성, 미적용. 연결된 원본 finding 배열 인덱스(0부터): [2, 5, 9].

## P4-05 — 확정 C16을 Q6 가정으로 표시

근거: docs/requirements_clarifications.md:24; docs/requirements_clarifications.md:43–47; artifacts/SA/DFD/dfd_level_4_fsm.md:64–65; artifacts/SD/structure_chart.md:431–433; artifacts/SD/structure_chart.md:5; artifacts/SD/transform_analysis.md:5.

조건/반례: 후속 검증자가 전방만 회피 시작하는 동작을 확정 요구사항이 아닌 선택 가능한 가정으로 읽는다. 동작 자체는 현 FSM과 같다.

판정·범위: Q6 확정의 SD 참조 정리. 상태: 수정안 작성, 미적용. 연결된 원본 finding 배열 인덱스(0부터): [10].

## P4-06 — D3 초기값이 SA에 없다는 설명이 오래됨

근거: artifacts/SD/structure_chart.md:401; artifacts/SA/process_specification.md:38; artifacts/SA/data_dictionary.md:210–218.

조건/반례: SD는 D3=0을 구현하지만 이를 SA에 없는 설계 선택이라고 설명한다. 현재 SA에는 이미 초기값 0이 명시돼 있다.

판정·범위: 주 검토자의 Spec Kit 근거 대조에서 추가; 과거 승인 당시 설명의 현재화. 상태: 수정안 작성, 미적용. 연결된 원본 finding 배열 인덱스(0부터): [].

## 반증 검토와 유지할 설계

- 모듈 26개(내부 19·library 7), 호출/인터페이스 26개가 서로 대응한다. 프로세스 13개가 모두 매핑되고 primitive 9개의 transform 영역이 존재한다. 대응 개수만으로 동작 준수를 판단하지 않았다.
- 3.2.1을 별도 빈 함수 대신 파라미터 전달로 실현하고, 3.2.3을 Movement Status와 Direction 책임으로 나눈 것은 SA/TA 근거가 있다. 별도 결함으로 지적하지 않는다.
- D4 advance → 전이 선택 → timer restart 순서와 C9의 sides-only 판단은 SD에 반영돼 있다. Phase 3의 SPIN 결과는 기존 이동 SA 모델에 한정되며 이번 SD 통과 증거로 재사용하지 않았다.
- C14의 ID나 물걸레 문구가 SD에 직접 없더라도 SC:333의 Dictionary 타입·값 참조와 :415의 PSPEC 동작 참조, PSPEC:428의 명령 정의가 연결된다. 독립적인 C14 미구현/누락 결함으로 단정하지 않는다. 구현 시 C14 준수는 Phase 5에서 별도 확인한다.
- C15도 같은 참조만으로 충족된다고 볼 수 있는지 검토했지만, D2가 틱 사이에 유지되지 않는다는 SC:375와 Tick당 polling으로 충분하다는 :399의 명시적 설계가 최신 SA와 충돌하므로 P4-03/04는 유지했다.
- C12는 '결정 로직이 네 센서를 읽기 전에 실행된다'는 지적이 아니다. 현재 호출 순서는 결정 전에 읽는다. 최신 SA가 별도로 정의한 첫 Tick 이전 초기 샘플 완료 단계가 SD에서 빠진 순서·추적성 문제로 한정했다.
- 숨긴 상태 그룹, 매개변수 중심 결합, 역할별 모듈 분리는 대체로 유지 가능하다. D2의 지속 상태와 입력 수신/소비 책임을 추가할 때 정보 은닉·직렬화 계약을 다시 확인해야 한다.

## 원본 관점별 결과

### adversarial

- 원본 #0: 전원을 켜고 아직 첫 Tick을 처리하지 않은 경우. 특히 초기 전방 센서가 장애물을 보고하는 경우에도 SD의 Initialize RVC → Issue Movement Output 호출은 센서 판단 전에 실행된다. 근거: artifacts/SD/structure_chart.md:68-71,257,265,386,404 ↔ docs/requirements_clarifications.md:21(C13; B1/B2), artifacts/SA/DFD/dfd_level_4_fsm.md:63(T0), artifacts/SA/DFD/dfd_level_3.md:134(3.2.2/3.2.3)
- 원본 #1: 초기화 직후 첫 Tick을 기다리는 동안 아직 네 센서의 초기 샘플을 확보하지 않은 경우. 근거: artifacts/SD/structure_chart.md:64-83,286,399 ↔ docs/requirements_clarifications.md:20(C12; B2-B5), artifacts/SA/process_specification.md:38-40,51-54,92-100(0/1/2), artifacts/SA/DFD/dfd_level_3.md:127
- 원본 #2: 회피 중 한 Tick에서 먼지를 감지한 뒤 Forward 복귀 전에 센서가 FALSE가 되는 경우, 또는 Tick 사이에 TRUE 입력과 FALSE 입력이 순서대로 수신되는 경우. 기존 파워업 잔여 틱이 있어도 동일하다. 근거: artifacts/SD/structure_chart.md:262,290-298,327,375,399 및 artifacts/SD/transform_analysis.md:33,50,86-92,139-159 ↔ docs/requirements_clarifications.md:23,28-30(C15; B5/C3/C10/C11), artifacts/SA/process_specification.md:118-142,365-395(2/4.1), artifacts/SA/data_dictionary.md:159-176(D2)
### edge-case-hunter

- 원본 #3: C13: 전방 장애물이 있는 상태에서 전원을 켠다. 근거: artifacts/SD/structure_chart.md:71; artifacts/SD/structure_chart.md:257; artifacts/SD/structure_chart.md:386; artifacts/SA/DFD/dfd_level_4_fsm.md:63; docs/requirements_clarifications.md:21
- 원본 #4: C12: 초기화 후 첫 Tick이 도착하지만 초기 센서 샘플은 아직 수집되지 않았다. 근거: artifacts/SD/structure_chart.md:64-75; artifacts/SD/structure_chart.md:285; artifacts/SA/process_specification.md:38-40; artifacts/SA/DFD/dfd_level_3.md:127; docs/requirements_clarifications.md:20
- 원본 #5: B5/C10/C15: 두 Tick 사이에 먼지 입력이 TRUE였다가 FALSE가 된다. 근거: artifacts/SD/structure_chart.md:399; artifacts/SD/structure_chart.md:262; artifacts/SA/process_specification.md:128-142; artifacts/SA/process_specification.md:372; docs/requirements_clarifications.md:30
- 원본 #6: C15: 회피 중 먼지를 읽었지만 Forward 복귀 전 센서가 FALSE로 바뀐다. 근거: artifacts/SD/structure_chart.md:298; artifacts/SD/structure_chart.md:327; artifacts/SD/structure_chart.md:375; artifacts/SD/transform_analysis.md:33; artifacts/SD/transform_analysis.md:50; artifacts/SA/process_specification.md:367-392; docs/requirements_clarifications.md:23
### sasd

- 원본 #7: 전원을 켜고 첫 Tick이 아직 발생하지 않은 경우. C13은 Forward 상태만 초기화하도록 확정했으나 SD는 초기화 경로에서 Forward 명령을 반환하고 Motor로 전달한다. 근거: artifacts/SD/structure_chart.md:71,123,257,265,309,312,386,404
- 원본 #8: 시작 후 첫 Tick을 준비할 때. SD의 Main은 초기화 후 Wait For Tick을 호출하고, Tick 반환 후 Controller/Get Inputs에서 처음 센서를 읽는다. 초기 샘플 네 개를 Tick 전에 확보하는 호출 단계가 없다. 근거: artifacts/SD/structure_chart.md:64-79,98,256-262,399
- 원본 #9: 회피 중 Dust Sensor Input이 TRUE였다가 Forward 복귀 전에 FALSE가 되거나, 두 Tick 사이 TRUE 입력 뒤 FALSE가 수신되는 경우. C15는 해당 검출을 보존하고 첫 Forward Tick에서 5틱을 재시작하도록 요구한다. 근거: artifacts/SD/structure_chart.md:262,290-298,327,375,399; artifacts/SD/transform_analysis.md:33,50,140-143
- 원본 #10: 최신 요구사항 및 SA와 SD의 결정 상태를 대조하거나 후속 구현·검증 기준을 선정할 때. 확정된 C16을 SD가 여전히 Q6 가정으로 분류한다. 근거: artifacts/SD/structure_chart.md:431-433

## 다음 조치

새 업무 규칙을 정할 질문은 발견하지 못했다. 이미 확정한 C12/C13/C15/C16을 SD에 반영하는 수정이 우선이다. 초기화 → D2 소유권/수명 → 입력 수신/소비 인터페이스 → TA·호출도·추적/승인 이력 순으로 정리하면 된다. P4-03/04는 함께 수정해야 한다.

현재 요청은 Phase 4 검토이므로 구체적 수정안까지 기록했다. 수정·재검토와 개정 SD에 대한 사람 승인을 거쳐 Phase 5의 C 준수 검사를 진행해야 한다. 문서 검토·자동 구조 점검만 수행했으며 C 테스트·SPIN·웹 시뮬레이터를 이번 Phase에서 실행하지 않았다. [종료 검증](../verification/report.md)을 참고한다.
