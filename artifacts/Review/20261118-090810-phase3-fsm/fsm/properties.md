# 실행 속성과 판정 기준

기본 모델 `model.pml`의 모든 assertions는 안전성 검사에서 함께 실행한다. 기본 환경은 `mapping.md`에 명시했다. 보호 요구사항은 B2–B4, C1/C2/C5–C9/C12/C13/C16의 이동 관련 부분이며 C4는 환경 해석이다.

| ID | 종류 | 근거 | 실행할 검사 |
|---|---|---|---|
| S01 | 초기화 안전성 | C13, T0 | Forward/Idle, NoCommand, 초기 command·direction·clean·start_timer 미발생 assertions |
| S02 | 입력 순서 안전성 | C12, Level 3 Tick 순서 | 첫 Tick과 모든 Tick의 `sampled == 15` |
| S03 | 분류 안전성 | C1, C9, PSPEC 3.1 | RightOpen/LeftOpen/SidesBlocked와 raw right/left의 동치 assertions |
| S04 | 타이밍 안전성 | C6/C7/C8, PSPEC 3.2.4 | 증가 D4와 독립 감소 monitor 동치, 종료·재시작·Idle 범위 assertions |
| S05 | 분기 완전성·배타성 | T1–T14 | `guards == 1`, `emitted == 1` 및 연속 루프 invalid-end-state 검사 |
| S06 | 상태 변경 안전성 | C2/C5/C9/C16 | 원시 front/left/right에 근거한 다음 상태·restart postconditions |
| S07 | 출력 일관성 | PSPEC 3.2.3 | 상태별 command, direction, avoiding 대응 assertions |
| S08 | 더 넓은 환경 안전성 | 환경 의존성 확인 | `ENV_STOP_FRONT=0`으로 S01–S07을 재실행 |
| L01 | 활성성 | C7, 계속되는 Tick | stop_progress: 정지를 시작하면 언젠가 정지를 벗어난다 |
| L02 | 활성성 | C8, 계속되는 Tick | turn_progress: 좌/우 회전을 시작하면 언젠가 Forward가 된다 |
| R00–R14 | 도달성 | T0–T14 | 각 `PROBE_T=N`의 `assert(transition != N)` 위반을 실제 재생하여 목표 도달 확인 |
| RS1–RS5 | 도달성 | 5개 상태 | 각 `PROBE_STATE=state`의 `assert(state != target)` 위반을 실제 재생하여 도달 확인 |
| N01 | 비요구사항 반증 실험 | C5/C9 | unconditional_forward: `[] <> (stable && state == Forward)`의 수용 순환 반례 예상 |
| M01–M04 | monitor 민감도 실험 | C6–C8/C9/C16/C13 | 조기 종료, 전방 의존 후진 판단, 좌우만으로 회피 시작, 초기 출력의 시험용 변형에서 assertion 위반 예상 |

R/RS의 assertion 위반은 목표 도달 증거, M의 위반은 시험용 결함 검출 증거다. N은 요구되지 않은 보장을 반증한다. 이들을 제품 결함이나 안전성 PASS 개수로 합산하지 않는다.

## LTL 정확한 식

```promela
ltl stop_progress { [] ((stable && state == Stopping) -> <> (stable && state != Stopping)) }
ltl turn_progress { [] ((stable && (state == TurningRight || state == TurningLeft)) -> <> (stable && state == Forward)) }
ltl unconditional_forward { [] <> (stable && state == Forward) }
```

각 식은 별도의 self-contained 모델과 `--ltl` 옵션으로 실행했다. 공정성 플래그를 쓰지 않았다. Backing의 무조건적인 종료는 요구하지 않는다. 원문에 없는 '언젠가 반드시 옆이 열린다'는 환경 전제도 추가하지 않았다.

## 정확한 assertion 목록

실행 위치는 모델 줄 번호다. `PROBE_T=255`, `PROBE_STATE=0`인 기본 모델에서 도달성 probe는 비활성이다.

`model.pml:53`

```promela
assert(state == Forward && elapsed == IDLE);
```

`model.pml:54`

```promela
assert(command == NoCommand && direction == NoCommand);
```

`model.pml:55`

```promela
assert(!clean_emitted && !start_timer && emitted == 0);
```

`model.pml:57`

```promela
assert(transition != PROBE_T);
```

`model.pml:58`

```promela
assert(state != PROBE_STATE);
```

`model.pml:60`

```promela
assert(sampled == 15);
```

`model.pml:66`

```promela
assert(sampled == 15);
```

`model.pml:78`

```promela
assert((side == RightOpen) == !right);
```

`model.pml:79`

```promela
assert((side == LeftOpen) == (right && !left));
```

`model.pml:80`

```promela
assert((side == SidesBlocked) == (right && left));
```

`model.pml:91`

```promela
assert(done == (previous != Forward && remaining == 0));
```

`model.pml:108`

```promela
assert(guards == 1);
```

`model.pml:127`

```promela
assert(emitted == 1);
```

`model.pml:130`

```promela
assert((front && state == Stopping && start_timer) ||
                   (!front && state == Forward && !start_timer))
        :: previous != Forward && !done -> assert(state == previous && !start_timer)
        :: (previous == Stopping || previous == Backing) && done ->
            assert(start_timer);
```

`model.pml:135`

```promela
assert((!right && state == TurningRight) ||
                   (right && !left && state == TurningLeft) ||
                   (right && left && state == Backing))
        :: (previous == TurningRight || previous == TurningLeft) && done ->
            assert(state == Forward && !start_timer)
        fi;

        if
        :: start_timer ->
            assert(remaining == 0);
```

`model.pml:151`

```promela
assert((state == Forward && command == GoForward) ||
               (state == Stopping && command == Stop) ||
               (state == Backing && command == GoBackward) ||
               (state == TurningRight && command == TurnRight) ||
               (state == TurningLeft && command == TurnLeft));
```

`model.pml:156`

```promela
assert(direction == command && avoiding == (state != Forward));
```

`model.pml:157`

```promela
assert((state == Forward && elapsed == IDLE && remaining == 0) ||
               (state != Forward && elapsed < 5 && remaining == 5 - elapsed));
```

`model.pml:162`

```promela
assert(transition != PROBE_T);
```

`model.pml:163`

```promela
assert(state != PROBE_STATE);
```

## 실행 및 탐색 한계

`run_suite.py`에 모델 파생 규칙·명령이 있고, 각 `checks/<name>/result.json`에 실제 argv/cwd/종료 코드/해시, generate/compile/search/replay 로그가 있다. SPIN `-a`, GCC `-O2`, pan `-m100000`과 LTL의 `-a -N <name>`을 사용했다. bitstate/hash-compaction 검사를 사용하지 않았다. 통과한 4개 탐색은 깊이 제한에 도달하지 않고 종료한 full-state search(POR 사용)이며, 반례 탐색은 첫 증거에서 중단된다.

SPIN LTL 검사에서 'only one claim defined, -N ignored'는 모델마다 claim이 하나라 선택 이름이 불필요하다는 경고다. 생성 로그/모델의 단일 claim 이름을 대조했다. Counterexample 탐색의 'Search not completed'는 첫 반례에서 종료했다는 의미이며 완전 탐색 PASS로 취급하지 않았다.

범위 밖: D2/D3, C3/C10/C11/C14/C15 청소 의미, C16 청소 출력 부분, 센서 드라이버, 멀티스레드/인터럽트, 물리적 충돌, 실제 시간, C 구현·단위 테스트·커버리지·웹 시뮬레이터. 초기 샘플 순서와 무출력은 이 추상 모델에서만 확인했다.
