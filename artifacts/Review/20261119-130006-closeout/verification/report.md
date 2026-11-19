# 잔여 항목 정리 및 Codex 시나리오 평가 — 2026-11-19

사용자의 “해줘”에 따라 P2-I01 문서 참조 정리와 시나리오 기대 동작 대조를 수행했다. **참조 정리 완료, 21개 시나리오 모두 Codex 자동 평가 PASS다.** 사람의 독립 관찰·최종 승인을 대신 기록하지 않았다. 평가자 이름과 observations에 자동 평가 및 human approval pending을 명시했다.

## 문서 수정과 검증

PSPEC3.2.2 Relevant Requirements에 이미 본문에 있는 C12/C13을 추가하고, DFD3 Process3.2.1 Requirements에 C9를 추가했다. 수정 전 스냅샷은 before/에 보관했다. [좁은 추적성 검토](traceability.md)로 세 요구사항의 본문·SD·구현 연결을 확인했다. 동작, 다이어그램, 인터페이스, 생산 C와 테스트는 바뀌지 않았다.

`check_closeout.py`가 정확히 두 참조 줄만 바뀌었음과 Mermaid 동일, Phase6의84개 기존 입력 중 나머지82개 불변, Git 공백 검사를 확인했다. 도표가 같으므로 재렌더링하지 않았다. 코드 변경이 없어 C 테스트·커버리지·SPIN을 재실행하지 않았다. 121개 테스트와 C100% 커버리지는 직전 Phase6의 당시 결과이며 이번 실행의 새 측정이라고 주장하지 않는다. 전체 BMAD/Spec Kit 워크플로도 재실행하지 않았다.

## 시나리오 평가 방법

실제 Edge 브라우저에서 시나리오마다 Reset 후100틱을 실행했다. 처음3개는 Step 반복, 나머지는20ticks/s Start 자동 실행을 사용했다. 진행 중 일부 미완료 실행은 속도 조정을 위해 중단했으며, 이미100틱 평가/저장된 결과만 이어받았다. 각 최종 평가에는 초기화부터100틱까지의전체 trace가 있고 총21개다. 중단된 partial run을 평가로 세지 않았다.

시나리오 prose의 정해진 명령/틱 구간을 먼저 `expected-prefixes.json`으로 작성하고, UI에서 내려받은 각 trace를 그와 대조했다. 매 시나리오의100틱 번호·초기 null 출력·회피/청소 상태 일관성·잔여 파워업 범위도 확인했다. ST-21은 전 구간의 위치 불변도 검사했다.100틱 전체의 모든 가능한 성질을 증명한 것이 아니며, 명시한 기대 구간 이후는 기본 불변식 범위다. 해당 prefix 범위는 아래 표에 적었다.

각 결과는 브라우저의 평가 폼에서 PASS·평가자 Codex·관련Tick0–100·자동평가 관찰 내용을 입력하여 저장했다. `simulator/results/`의 파일과 이 실행의 UI export trace가 근거다. 독립 사람 평가를 했다는 표시, 사용자 이름의 평가, 최종 승인 입력은 하지 않았다. 이는 네이티브 Trail of Bits/BMAD 실행도 아니다.

| 시나리오 | Agent 판정 | 개별 기대 구간(Tick1부터) | 저장 파일 |
|---|---|---:|---|
| ST-01 | PASS | 15틱 | `simulator/results/ST-01_2026-11-19T04-02-09-040Z.json` |
| ST-02 | PASS | 13틱 | `simulator/results/ST-02_2026-11-19T04-02-28-960Z.json` |
| ST-03 | PASS | 13틱 | `simulator/results/ST-03_2026-11-19T04-03-13-648Z.json` |
| ST-04 | PASS | 13틱 | `simulator/results/ST-04_2026-11-19T04-04-07-520Z.json` |
| ST-05 | PASS | 18틱 | `simulator/results/ST-05_2026-11-19T04-04-19-904Z.json` |
| ST-06 | PASS | 100틱 | `simulator/results/ST-06_2026-11-19T04-04-32-176Z.json` |
| ST-07 | PASS | 20틱 | `simulator/results/ST-07_2026-11-19T04-04-44-088Z.json` |
| ST-08 | PASS | 20틱 | `simulator/results/ST-08_2026-11-19T04-04-56-898Z.json` |
| ST-09 | PASS | 24틱 | `simulator/results/ST-09_2026-11-19T04-05-11-298Z.json` |
| ST-10 | PASS | 18틱 | `simulator/results/ST-10_2026-11-19T04-05-23-049Z.json` |
| ST-11 | PASS | 20틱 | `simulator/results/ST-11_2026-11-19T04-05-35-353Z.json` |
| ST-12 | PASS | 23틱 | `simulator/results/ST-12_2026-11-19T04-05-47-222Z.json` |
| ST-13 | PASS | 18틱 | `simulator/results/ST-13_2026-11-19T04-05-59-680Z.json` |
| ST-14 | PASS | 18틱 | `simulator/results/ST-14_2026-11-19T04-06-11-589Z.json` |
| ST-15 | PASS | 14틱 | `simulator/results/ST-15_2026-11-19T04-06-23-803Z.json` |
| ST-16 | PASS | 13틱 | `simulator/results/ST-16_2026-11-19T04-06-35-312Z.json` |
| ST-17 | PASS | 13틱 | `simulator/results/ST-17_2026-11-19T04-06-47-352Z.json` |
| ST-18 | PASS | 17틱 | `simulator/results/ST-18_2026-11-19T04-06-59-303Z.json` |
| ST-19 | PASS | 11틱 | `simulator/results/ST-19_2026-11-19T04-07-11-093Z.json` |
| ST-20 | PASS | 32틱 | `simulator/results/ST-20_2026-11-19T04-07-23-632Z.json` |
| ST-21 | PASS | 100틱 | `simulator/results/ST-21_2026-11-19T04-07-35-029Z.json` |

실제 실행 로그: [evaluation.log](../system/evaluation.log). [판정 JSON](../system/evaluations.json), [브라우저 요약](../system/browser-summary.json), [예상 구간](../system/expected-prefixes.json), [최종 점검](results.json). ST-14/ST-21 스크린샷도 system/에 보관했다. Playwright/Edge는 기존 런타임을 사용했고 새 의존성을 설치하지 않았다.

## 현재 상태

통합24개 이력의 현재 상태는23개 해결과 결함 아닌 P3-N01 한 개다. 과거 보고서는 당시 기록으로 유지하고 [최신 지적대장](finding-ledger.json)에서 P2-I01만 해결로 갱신했다. 필수 또는 선택적 수정 대기 항목은 더 이상 없다. 사람의 독립 평가·사용자의 최종 승인은 여전히 pending이며 Codex의21개 PASS와 구분한다. 물리 하드웨어 검증은 B6 범위 밖이다. 커밋·푸시는 하지 않았다.
