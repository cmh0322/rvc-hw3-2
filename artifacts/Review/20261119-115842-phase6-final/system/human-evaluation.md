# 사람의 시뮬레이터 평가 — 대기

2026-11-19 Phase6 자동 검증은 완료했다. 이 문서는 자동 결과와 별도로 사람이 시나리오 기대 동작을 관찰하고 판정할 목록이다. 자동 검증을 사람 PASS로 기록하지 않았다.

프로젝트 루트에서 다음을 실행한다. 현재 빌드는 이미 준비되어 있다.

```powershell
node simulator/server.js
```

브라우저에서 http://localhost:8765 를 연다. 각 시나리오를 선택하고 Start/Step 및 History/슬라이더로 기대 동작과 타이밍을 확인한다. PASS/FAIL/INCONCLUSIVE, Evaluator, 관련 Tick과 관찰 내용을 적은 뒤 Save evaluation and trace를 누른다. 결과는 simulator/results/에 저장된다. 불일치가 보이면 실패 trace와 Tick을 근거로 기록한다. 최종 산출물 승인은 사람이 별도로 내린다.

중점: tick0에서 이동/청소 명령 없음과 실제 센서값 표시, 첫 blocked-front Tick의 Stop,5틱 정지/회전/후진, 후진 후 front와 무관한 좌우 판단, C16 측면만 막힘, 회피 중 먼지와 복귀 파워업. UI의 map은 Tick 사이 임의 pulse를 만드는 기능이 없으므로 수신 TRUE/FALSE pulse는 이번 웹/API 자동 회귀가 별도로 검사했다.

모든 새 headless trace는 [scenarios/traces/](scenarios/traces/)에 있다. 자동 UI 초기 동작 결과는 [browser-scenarios.json](browser-scenarios.json), 먼지/초기화 회귀는 [web-results.json](web-results.json)이다. 아래 Pending은 사람 판정 상태이며 코드 결함 판정이 아니다.

| 시나리오 | 이름 | 사람 판정 |
|---|---|---|
| ST-01 | Empty room | Pending |
| ST-02 | Obstacle ahead, both sides open | Pending |
| ST-03 | Obstacle ahead, right blocked | Pending |
| ST-04 | Obstacle ahead, left blocked | Pending |
| ST-05 | Dead end in the open | Pending |
| ST-06 | Closed corridor | Pending |
| ST-07 | Corridor that opens to the left | Pending |
| ST-08 | Corridor that opens to the right | Pending |
| ST-09 | Backward twice, then turn | Pending |
| ST-10 | Dust on a straight path | Pending |
| ST-11 | Second dust during a power-up | Pending |
| ST-12 | Two separate power-ups | Pending |
| ST-13 | Power-up interrupted by an obstacle | Pending |
| ST-14 | Dust where the RVC stops | Pending |
| ST-15 | Obstacles beside the path only | Pending |
| ST-16 | Heading east | Pending |
| ST-17 | Heading south, right blocked | Pending |
| ST-18 | Heading west into a dead end | Pending |
| ST-19 | Start in a corner | Pending |
| ST-20 | Obstacle and dust course | Pending |
| ST-21 | Enclosed on all four sides | Pending |
