# Phase 4 수정본 BMAD 재검토

입력 기준: 2026-11-18T09:57:20.829242+09:00 (Asia/Seoul), Git HEAD `dea14b590b5246e1889119fc9040c5df496bd987`, 기존 미커밋 작업 포함. 수정 전 원문은 `../before/`, 수정 후 검토 입력은 review-input.md 및 ../input-manifest.json에 기록했다.

**adversarial, edge-case-hunter, sasd의 세 독립 검토자가 모두 추가 지적 없이 종료했다.** 각 검토자는 같은 최신 요구사항·SA·개정 SD 묶음과 해당 관점 지침을 읽고 다른 관점의 지적을 보지 않았다. 원본 반환은 모두 `[]`이며 [lens-results.json](lens-results.json)에 상태를 보관했다. 프로젝트 override를 resolve_customization.py로 적용했으며 resolved-workflow.json에 저장했다.

이번 재검토는 SD 문서 범위다. 새 C 코드, 시험 실행, 하드웨어 무손실 입력 구현의 타당성 증명까지 확장하지 않는다. 문서상 충돌을 해소했으며 사람의 SD 승인과 구현 준수는 별개다.

## 대조한 핵심 경로

- 초기화에서 네 실제 샘플 확보 전 Tick 전달을 허용하지 않으며 Reset 계열은 명령을 반환하지 않는다. 초기화가 호출할 수 있는 경로에는 출력 모듈이 없다.
- 수신한 센서 이벤트는 도착 순서대로 store를 갱신한다. Tick은 한 주기만 실행하고, 그 동안 새 입력은 boundary에 보존되어 이후 직렬 dispatch한다. 현재값 polling만으로 감지를 보존한다고 주장하지 않는다.
- D2는 Sensor Store에 지속 보관한다. Detect Dust의 TRUE OR 갱신, FALSE 보존, Track Power-Up의 Forward-only pending 소비, current 보존, C15의 잔여 틱보다 우선하는 5틱 재시작을 대조했다.
- D4/FSM의 기존 전이와 C9는 유지한다. C16을 확정 상태로 표시하며 C14의 suction/mop 의미를 SD 출력 계약에도 명시했다.
- 5개 들어오는 Context 흐름을 한 어댑터로 묶는 설계는 외부 기능을 추가하지 않는다. SA의 D1/D2 저장소를 private group과 복사 반환 accessor로 실현했다. 유효성 flags·event tag는 설계 지원 데이터다.

초기 획득과 Running 모드의 무손실·순서 보존은 구현해야 할 boundary 계약이다. 실제 센서/시뮬레이터 어댑터가 이를 만족하는지는 Phase 5 이후 근거가 필요하다. 임의의 동시 센서 우선순위, 충돌 안전 보장, 무조건 전진 복귀를 새 요구사항으로 추가하지 않았다.

[요구사항 추적](../traceability/matrix.md)과 [실행한 문서 검사](../verification/report.md)를 함께 확인한다. 기존 Phase 4 보고서는 당시 이력으로 그대로 보존한다.
