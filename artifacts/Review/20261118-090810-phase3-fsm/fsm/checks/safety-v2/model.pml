/* Movement-only abstraction of SA, not a translation of production C.
 * One atomic synchronous Tick; finite raw Boolean inputs, D4 and monitors.
 * ENV_STOP_FRONT=1 enforces only SA stationary front persistence (C4).
 * All other samples may change: over-approximation, no physical map.
 */
#define ENV_STOP_FRONT 1
#define PROBE_T 255
#define PROBE_STATE 0
#define IDLE 6
mtype = { Forward, Stopping, Backing, TurningRight, TurningLeft,
          GoForward, Stop, GoBackward, TurnRight, TurnLeft, NoCommand,
          RightOpen, LeftOpen, SidesBlocked };
mtype state, previous, command = NoCommand, direction = NoCommand, side;
bool front, left, right, dust;
bool done, start_timer, stable, avoiding, first_tick = true;
bool clean_emitted = false; /* initialization only; cleaning is out of scope */
byte sampled = 0;
byte elapsed = IDLE;
byte remaining = 0; /* independent countdown monitor: number of step ticks */
byte transition = 0;
byte emitted = 0;
byte guards = 0;

inline sample_inputs() {
    sampled = 0;
    if
    :: ENV_STOP_FRONT && state == Stopping -> front = true
    :: !(ENV_STOP_FRONT && state == Stopping) ->
        if :: front = false :: front = true fi
    fi;
    sampled = sampled | 1;
    if :: left = false :: left = true fi;
    sampled = sampled | 2;
    if :: right = false :: right = true fi;
    sampled = sampled | 4;
    if :: dust = false :: dust = true fi;
    sampled = sampled | 8
}

inline take(id, next_state, output, restart) {
    transition = id;
    state = next_state;
    command = output;
    start_timer = restart;
    emitted++
}

active proctype Controller() {
    atomic {
        /* T0, C13: state initialization is not an output event. */
        state = Forward;
        previous = Forward;
        assert(state == Forward && elapsed == IDLE);
        assert(command == NoCommand && direction == NoCommand);
        assert(!clean_emitted && !start_timer && emitted == 0);
        printf("INIT T0 state=%e command=%e elapsed=%d\n", state, command, elapsed);
        assert(transition != PROBE_T);
        assert(state != PROBE_STATE);
        sample_inputs();
        assert(sampled == 15); /* C12: all four reads before the first Tick */
    }
    do
    :: atomic {
        stable = false;
        if :: first_tick -> first_tick = false :: else -> sample_inputs() fi;
        assert(sampled == 15);
        previous = state;
        emitted = 0;
        start_timer = false;
        done = false;

        /* P3.1: raw-to-side mapping with right priority. */
        if
        :: !right -> side = RightOpen
        :: right && !left -> side = LeftOpen
        :: right && left -> side = SidesBlocked
        fi;
        assert((side == RightOpen) == !right);
        assert((side == LeftOpen) == (right && !left));
        assert((side == SidesBlocked) == (right && left));

        /* Monitor counts commanded step ticks downward; D4 counts upward. */
        if :: remaining > 0 -> remaining-- :: else -> skip fi;
        /* P3.2.4: advance before transition; pulse Done, then become Idle. */
        if
        :: elapsed != IDLE ->
            elapsed++;
            if :: elapsed == 5 -> done = true; elapsed = IDLE :: else -> skip fi
        :: else -> skip
        fi;
        assert(done == (previous != Forward && remaining == 0));

        /* Exactly one guard, including repeated Backing, is enabled. */
        guards = ((previous == Forward && !front)
          + (previous == Forward && front)
          + (previous == Stopping && !done)
          + (previous == Stopping && done && side == RightOpen)
          + (previous == Stopping && done && side == LeftOpen)
          + (previous == Stopping && done && side == SidesBlocked)
          + (previous == Backing && !done)
          + (previous == Backing && done && side == SidesBlocked)
          + (previous == Backing && done && side == RightOpen)
          + (previous == Backing && done && side == LeftOpen)
          + (previous == TurningRight && !done)
          + (previous == TurningRight && done)
          + (previous == TurningLeft && !done)
          + (previous == TurningLeft && done));
        assert(guards == 1);
        if
        :: previous == Forward && !front -> take(1, Forward, GoForward, false)
        :: previous == Forward && front -> take(2, Stopping, Stop, true)
        :: previous == Stopping && !done -> take(3, Stopping, Stop, false)
        :: previous == Stopping && done && side == RightOpen -> take(4, TurningRight, TurnRight, true)
        :: previous == Stopping && done && side == LeftOpen -> take(5, TurningLeft, TurnLeft, true)
        :: previous == Stopping && done && side == SidesBlocked -> take(6, Backing, GoBackward, true)
        :: previous == Backing && !done -> take(7, Backing, GoBackward, false)
        :: previous == Backing && done && side == SidesBlocked -> take(8, Backing, GoBackward, true)
        :: previous == Backing && done && side == RightOpen -> take(9, TurningRight, TurnRight, true)
        :: previous == Backing && done && side == LeftOpen -> take(10, TurningLeft, TurnLeft, true)
        :: previous == TurningRight && !done -> take(11, TurningRight, TurnRight, false)
        :: previous == TurningRight && done -> take(12, Forward, GoForward, false)
        :: previous == TurningLeft && !done -> take(13, TurningLeft, TurnLeft, false)
        :: previous == TurningLeft && done -> take(14, Forward, GoForward, false)
        fi;

        /* Independent postconditions expressed over raw inputs, not T IDs. */
        assert(emitted == 1);
        if
        :: previous == Forward ->
            assert((front && state == Stopping && start_timer) ||
                   (!front && state == Forward && !start_timer))
        :: previous != Forward && !done -> assert(state == previous && !start_timer)
        :: (previous == Stopping || previous == Backing) && done ->
            assert(start_timer);
            assert((!right && state == TurningRight) ||
                   (right && !left && state == TurningLeft) ||
                   (right && left && state == Backing))
        :: (previous == TurningRight || previous == TurningLeft) && done ->
            assert(state == Forward && !start_timer)
        fi;

        if
        :: start_timer ->
            assert(remaining == 0);
            elapsed = 0;
            remaining = 5
        :: else -> skip
        fi;
        direction = command;
        avoiding = (command != GoForward);
        assert((state == Forward && command == GoForward) ||
               (state == Stopping && command == Stop) ||
               (state == Backing && command == GoBackward) ||
               (state == TurningRight && command == TurnRight) ||
               (state == TurningLeft && command == TurnLeft));
        assert(direction == command && avoiding == (state != Forward));
        assert((state == Forward && elapsed == IDLE && remaining == 0) ||
               (state != Forward && elapsed < 5 && remaining == 5 - elapsed));
        printf("T%d prev=%e f=%d l=%d r=%d done=%d state=%e cmd=%e elapsed=%d remaining=%d\n",
               transition, previous, front, left, right, done, state, command, elapsed, remaining);
        stable = true;
        assert(transition != PROBE_T);
        assert(state != PROBE_STATE);
    }
    od
}
