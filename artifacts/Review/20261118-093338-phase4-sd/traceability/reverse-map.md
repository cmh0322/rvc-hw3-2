# SD 모듈 역방향 추적

26개 모듈의 출처를 검토했다. 구조적 출처가 있다는 사실과 최신 동작 계약이 맞는지는 별개다. 3.2.1의 값 전달, 3.2.3의 central/efferent 분리는 근거 있는 설계 선택이다. 상세 호출·인터페이스는 structure-evidence.json에 있다.

| 모듈 | SD 줄 | SA/설계 근거 |
|---|---:|---|
| Main | 256 | Process 0 + Tick loop |
| Initialize RVC | 257 | T0 + D3/D4 초기값; P4-01/02/03 개정 필요 |
| Controller | 258 | Process 0 / transform coordination |
| Get Inputs | 259 | TA afferent coordination |
| Detect Obstacle | 260 | P1 |
| Assess Obstacle Situation | 261 | P3.1 |
| Detect Dust | 262 | P2; P4-03/04 개정 필요 |
| Decide Actions | 263 | TA central coordination + P3.2.1 parameter passing |
| Movement Controller | 264 | P3.2.2 / T1–T14 |
| Reset Movement Controller | 265 | P3.2.2 / T0; P4-01 |
| Advance Step Timer | 266 | P3.2.4 Tick |
| Start Step Timer | 267 | P3.2.4 Start Step Timer |
| Reset Step Timer | 268 | P3.2.4 / D4 Idle |
| Derive Movement Status | 269 | P3.2.3 central part |
| Track Power-Up | 270 | P4.1; P4-03/04 |
| Reset Power-Up Timer | 271 | D3=0 / P4.1 |
| Decide Cleaning | 272 | P4.2 / C14 |
| Put Outputs | 273 | TA efferent coordination |
| Issue Movement Output | 274 | P3.2.3 efferent part |
| Read Front Sensor | 282 | Context terminator Front Sensor / Front Sensor Input / B6 |
| Read Left Sensor | 283 | Context terminator Left Sensor / Left Sensor Input / B6 |
| Read Right Sensor | 284 | Context terminator Right Sensor / Right Sensor Input / B6 |
| Read Dust Sensor | 285 | Context terminator Dust Sensor / Dust Sensor Input / B6 |
| Wait For Tick | 286 | Context terminator Digital Clock / Tick / B6 |
| Drive Motor | 287 | Context terminator Motor / Direction / B6 |
| Drive Cleaner | 288 | Context terminator Cleaner / Clean / B6 |

D1–D4와 모든 19개 SA 흐름을 색인했다. TA의 18개 흐름 이름 중 이름 변경은 없으나 Pending Dust Detection과 관련 D2 갱신 연결이 빠져 있다. 이 결과를 부모별 DFD balancing 전체 재실행으로 표현하지 않는다.
