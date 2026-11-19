# 개정 SD 모듈 역방향 추적

30개 모듈과 그 출처. 내부 27개·boundary 3개는 기존 외부 흐름 7개를 구현하는 설계 분해다.

| 모듈 | SA/설계 근거 | SD 위치 |
|---|---|---|
| Main | P0; event loop | artifacts/SD/structure_chart.md:134 |
| Initialize RVC | P0/T0/C12/C13 and initial stores | artifacts/SD/structure_chart.md:135 |
| Acquire Initial Inputs | P0/P1/P2/C12 readiness | artifacts/SD/structure_chart.md:136 |
| Dispatch Input Event | P0 serial sensor/Tick triggers | artifacts/SD/structure_chart.md:137 |
| Dispatch Sensor Input | P1/P2 sensor event triggers | artifacts/SD/structure_chart.md:138 |
| Controller | P0 Tick | artifacts/SD/structure_chart.md:139 |
| Get Inputs | TA afferent coordinator | artifacts/SD/structure_chart.md:140 |
| Detect Obstacle | P1/D1 | artifacts/SD/structure_chart.md:141 |
| Assess Obstacle Situation | P3.1 | artifacts/SD/structure_chart.md:142 |
| Detect Dust | P2/D2/C15 | artifacts/SD/structure_chart.md:143 |
| Reset Sensor Data | D1/D2 initial validity/C12/C15 | artifacts/SD/structure_chart.md:144 |
| Inputs Ready | P0/C12 first-Tick barrier | artifacts/SD/structure_chart.md:145 |
| Get Obstacle Location | D1 copy accessor | artifacts/SD/structure_chart.md:146 |
| Get Dust Existence | D2 copy accessor/P4.1 input | artifacts/SD/structure_chart.md:147 |
| Clear Pending Dust | P4.1 pending-only D2 write | artifacts/SD/structure_chart.md:148 |
| Decide Actions | TA central coordinator/P3.2.1 parameter passing | artifacts/SD/structure_chart.md:149 |
| Movement Controller | P3.2.2/T1-T14 | artifacts/SD/structure_chart.md:150 |
| Reset Movement Controller | P3.2.2/T0 | artifacts/SD/structure_chart.md:151 |
| Advance Step Timer | P3.2.4 Tick | artifacts/SD/structure_chart.md:152 |
| Start Step Timer | P3.2.4 Start | artifacts/SD/structure_chart.md:153 |
| Reset Step Timer | D4 Idle | artifacts/SD/structure_chart.md:151 |
| Derive Movement Status | P3.2.3 central | artifacts/SD/structure_chart.md:155 |
| Track Power-Up | P4.1/C10/C11/C15 | artifacts/SD/structure_chart.md:156 |
| Reset Power-Up Timer | D3=0 | artifacts/SD/structure_chart.md:157 |
| Decide Cleaning | P4.2/C14 | artifacts/SD/structure_chart.md:158 |
| Put Outputs | TA efferent coordinator | artifacts/SD/structure_chart.md:159 |
| Issue Movement Output | P3.2.3 efferent | artifacts/SD/structure_chart.md:160 |
| Receive Input Event | 4 sensor + Tick Context flows; C12/C15 boundary contract | artifacts/SD/structure_chart.md:166 |
| Drive Motor | Direction Context output/B6 | artifacts/SD/structure_chart.md:160 |
| Drive Cleaner | Clean Context output/C14/B6 | artifacts/SD/structure_chart.md:168 |
