# Consolidated finding ledger

Historical findings remain unchanged in their original run directories. These are current source/evidence dispositions, not additional independent reviewer verdicts. Canonical IDs avoid counting repeated observations as independent defects.

| ID | Current status | Evidence/reason |
|---|---|---|
| P1-01 | resolved | C9 record and sides-only postback `artifacts/SA/process_specification.md:535` |
| P1-02 | resolved | C10/C11/C15 resolved question propagation `artifacts/SA/DFD/dfd_level_2.md:125` |
| P1-03 | resolved | D3 initial0 `src/power_up_timer.c:8` |
| P1-04 | resolved | C12 readiness `src/input_events.c:8` |
| P1-05 | resolved | C13 no initial output `src/initialize_rvc.c:14` |
| P1-06 | resolved | C14 abstract cleaner meaning `include/hw_interface.h:14` |
| P1-07 | resolved | C15 pending OR `src/sensor_store.c:28` |
| R1-SASD-01 | resolved | Pending Dust flow crosses P4 but is internal to P0; corrected balancing text retained. `artifacts/SA/DFD/dfd_level_2.md:121` |
| P2-A01 | resolved-by-owner | Q6 resolved by C16; Forward entry uses only front. `docs/requirements_clarifications.md:24`; `src/movement_controller.c:28` |
| P2-I01 | open-optional | PSPEC 3.2.2 relevant requirements summary omits C12/C13 and Level3 3.2.1 summary C9; behavior exists in body. No source correction authorized by Phase6 verify-only. `artifacts/SA/process_specification.md:516`; `artifacts/SA/DFD/dfd_level_3.md:14` |
| P3-D01 | resolved | Initial-output mismatch resolved through P4-01/P5-01. `src/initialize_rvc.c:11` |
| P3-N01 | not-a-defect | Unconditional eventual Forward is unsupported; repeated Backing allowed under C5/C9. `docs/requirements_clarifications.md:13` |
| P4-01 | resolved | 초기 Forward 출력이 C13/T0와 충돌; SD corrected and later owner approved; C propagation checked below. `artifacts/SD/structure_chart.md:23`; `artifacts/SD/structure_chart.md:151` |
| P4-02 | resolved | 첫 Tick 전 초기 센서 샘플 확보 단계 누락; SD corrected and later owner approved; C propagation checked below. `artifacts/SD/structure_chart.md:17`; `artifacts/SD/structure_chart.md:136` |
| P4-03 | resolved | D2의 pending 감지 수명·소유자·소비 경로 누락; SD corrected and later owner approved; C propagation checked below. `artifacts/SD/structure_chart.md:172`; `artifacts/SD/structure_chart.md:233`; `artifacts/SD/transform_analysis.md:146` |
| P4-04 | resolved | Tick당 현재값 polling만으로 Tick 사이 감지 보존 불가; SD corrected and later owner approved; C propagation checked below. `artifacts/SD/structure_chart.md:19`; `artifacts/SD/structure_chart.md:21`; `artifacts/SD/structure_chart.md:228` |
| P4-05 | resolved | 확정 C16을 Q6 가정으로 표시; SD corrected and later owner approved; C propagation checked below. `artifacts/SD/structure_chart.md:5`; `artifacts/SD/structure_chart.md:301` |
| P4-06 | resolved | D3 초기값이 SA에 없다는 설명이 오래됨; SD corrected and later owner approved; C propagation checked below. `artifacts/SD/structure_chart.md:298`; `artifacts/SD/structure_chart.md:179` |
| P5-01 | resolved | 전원 초기화가 첫 Tick 전에 Forward 명령 출력; current source and fresh tests/web/call graph inspected. `src/initialize_rvc.c:14` |
| P5-02 | resolved | 첫 Tick 전 실제 센서 확보·준비 완료 단계 누락; current source and fresh tests/web/call graph inspected. `src/input_events.c:8` |
| P5-03 | resolved | 회피 중 먼지 감지 유실 및 복귀 파워업 재시작 누락; current source and fresh tests/web/call graph inspected. `src/power_up_timer.c:18` |
| P5-04 | resolved | 승인된 입력 이벤트·Sensor Store 인터페이스 미구현; current source and fresh tests/web/call graph inspected. `src/main.c:16` |
| P5-05 | resolved | 기존 테스트와 호출 기준이 이전 동작을 정답으로 기대; current source and fresh tests/web/call graph inspected. `tests/test_main.cpp:25` |
| P5-06 | resolved | 확정 C16을 구현 근거에서 여전히 Q6 가정으로 표시; current source and fresh tests/web/call graph inspected. `tests/test_requirements.cpp:169` |

Phase1 raw aliases: ADV-01/SASD-01→P1-01; ADV-02/SASD-02→P1-02; ADV-03/EDGE-02/SASD-03→P1-03; ADV-03/EDGE-01/SASD-04→P1-04; ADV-04→P1-05; ADV-05→P1-06; ADV-06→P1-07. Phase4 raw lens observations were triaged into P4-01–06; original JSON is preserved.
