// Movement Controller group: Movement Controller, Reset Movement Controller
// (SA Process 3.2.2)
// Source: Level 4 FSM, transitions T0-T14 (artifacts/SA/DFD/dfd_level_4_fsm.md);
// requirements B2, B3, B4, C1, C2, C4-C9.
#include <gtest/gtest.h>

#include "movement_controller.h"
#include "situations.h"
#include "step_timer.h"

namespace {

class MovementControllerTest : public ::testing::Test {
protected:
    void SetUp() override { reset_movement_controller(); }

    // One Tick of the Movement Controller.
    static MovementCommand Tick(SituationSignal situation_signal) {
        return movement_controller(situation_signal);
    }

    // Expects the next `count` Ticks to issue `expected`.
    static void ExpectTicks(int count, SituationSignal situation_signal, MovementCommand expected) {
        for (int tick = 1; tick <= count; ++tick) {
            EXPECT_EQ(expected, Tick(situation_signal)) << "tick " << tick << " of " << count;
        }
    }

    // From Forward: finds an obstacle and stays stopped for the whole 5-tick stop.
    static void StopForFiveTicks(SituationSignal situation_signal) {
        ExpectTicks(5, situation_signal, MOVEMENT_COMMAND_STOP);
    }

    // From Forward: stops for 5 ticks, then moves backward for 5 ticks.
    static void StopThenBackForFiveTicks() {
        StopForFiveTicks(kAllBlocked);
        ExpectTicks(5, kAllBlocked, MOVEMENT_COMMAND_BACKWARD);
    }
};

// ---- T0: Power On / Forward -------------------------------------------------

TEST_F(MovementControllerTest, T0_ResetReturnsForwardAndEntersForward) {
    EXPECT_EQ(MOVEMENT_COMMAND_FORWARD, reset_movement_controller());
    EXPECT_EQ(CONTROLLER_STATE_FORWARD, get_controller_state());
    EXPECT_EQ(STEP_TIMER_IDLE, get_step_ticks_elapsed());
}

TEST_F(MovementControllerTest, T0_ResetLeavesAnyStateAndStopsTheStepTimer) {
    Tick(kAllBlocked);
    Tick(kAllBlocked);
    ASSERT_EQ(CONTROLLER_STATE_STOPPING, get_controller_state());
    ASSERT_NE(STEP_TIMER_IDLE, get_step_ticks_elapsed());

    EXPECT_EQ(MOVEMENT_COMMAND_FORWARD, reset_movement_controller());
    EXPECT_EQ(CONTROLLER_STATE_FORWARD, get_controller_state());
    EXPECT_EQ(STEP_TIMER_IDLE, get_step_ticks_elapsed());
}

// ---- T1: Forward, Tick [Clear] / Forward (B2) -------------------------------

TEST_F(MovementControllerTest, T1_ForwardKeepsGoingForwardWhileClear) {
    ExpectTicks(20, kClear, MOVEMENT_COMMAND_FORWARD);
    EXPECT_EQ(CONTROLLER_STATE_FORWARD, get_controller_state());
    EXPECT_EQ(STEP_TIMER_IDLE, get_step_ticks_elapsed()) << "no step is timed while going forward";
}

// ---- T2: Forward, Tick [not Clear] / Stop, Start Step Timer (B3, C2, C7) -----

TEST_F(MovementControllerTest, T2_ForwardStopsWhenTheRightIsOpen) {
    EXPECT_EQ(MOVEMENT_COMMAND_STOP, Tick(kRightOpen));
    EXPECT_EQ(CONTROLLER_STATE_STOPPING, get_controller_state());
    EXPECT_EQ(0, get_step_ticks_elapsed()) << "the step timer must be started";
}

TEST_F(MovementControllerTest, T2_ForwardStopsWhenOnlyTheLeftIsOpen) {
    EXPECT_EQ(MOVEMENT_COMMAND_STOP, Tick(kLeftOpen));
    EXPECT_EQ(CONTROLLER_STATE_STOPPING, get_controller_state());
    EXPECT_EQ(0, get_step_ticks_elapsed());
}

TEST_F(MovementControllerTest, T2_ForwardStopsWhenAllBlocked) {
    EXPECT_EQ(MOVEMENT_COMMAND_STOP, Tick(kAllBlocked));
    EXPECT_EQ(CONTROLLER_STATE_STOPPING, get_controller_state());
    EXPECT_EQ(0, get_step_ticks_elapsed());
}

// ---- T3: Stopping, Tick [not Step Done] / Stop (C7) -------------------------

TEST_F(MovementControllerTest, T3_StopLastsFiveTicks) {
    StopForFiveTicks(kRightOpen);
    EXPECT_EQ(CONTROLLER_STATE_STOPPING, get_controller_state());
}

TEST_F(MovementControllerTest, T3_SituationIsIgnoredUntilTheStopEnds) {
    EXPECT_EQ(MOVEMENT_COMMAND_STOP, Tick(kAllBlocked));
    EXPECT_EQ(MOVEMENT_COMMAND_STOP, Tick(kRightOpen));
    EXPECT_EQ(MOVEMENT_COMMAND_STOP, Tick(kLeftOpen));
    EXPECT_EQ(MOVEMENT_COMMAND_STOP, Tick(kRightOpen));
    EXPECT_EQ(MOVEMENT_COMMAND_STOP, Tick(kAllBlocked));
    EXPECT_EQ(CONTROLLER_STATE_STOPPING, get_controller_state());
}

// ---- T4: Stopping, Tick [Step Done and Right Open] / Turn Right (B3, C1, C8) -

TEST_F(MovementControllerTest, T4_AfterTheStopTurnsRightWhenTheRightIsOpen) {
    StopForFiveTicks(kRightOpen);
    EXPECT_EQ(MOVEMENT_COMMAND_TURN_RIGHT, Tick(kRightOpen));
    EXPECT_EQ(CONTROLLER_STATE_TURNING_RIGHT, get_controller_state());
    EXPECT_EQ(0, get_step_ticks_elapsed()) << "the step timer must be started for the turn";
}

// ---- T5: Stopping, Tick [Step Done and Left Open] / Turn Left (B3, C8) -------

TEST_F(MovementControllerTest, T5_AfterTheStopTurnsLeftWhenOnlyTheLeftIsOpen) {
    StopForFiveTicks(kLeftOpen);
    EXPECT_EQ(MOVEMENT_COMMAND_TURN_LEFT, Tick(kLeftOpen));
    EXPECT_EQ(CONTROLLER_STATE_TURNING_LEFT, get_controller_state());
    EXPECT_EQ(0, get_step_ticks_elapsed());
}

// ---- T6: Stopping, Tick [Step Done and All Blocked] / Backward (B4, C6) ------

TEST_F(MovementControllerTest, T6_AfterTheStopMovesBackwardWhenAllBlocked) {
    StopForFiveTicks(kAllBlocked);
    EXPECT_EQ(MOVEMENT_COMMAND_BACKWARD, Tick(kAllBlocked));
    EXPECT_EQ(CONTROLLER_STATE_BACKING, get_controller_state());
    EXPECT_EQ(0, get_step_ticks_elapsed());
}

TEST_F(MovementControllerTest, T4_T5_T6_UseTheSituationOnTheTickTheStopEnds) {
    StopForFiveTicks(kAllBlocked);
    EXPECT_EQ(MOVEMENT_COMMAND_TURN_LEFT, Tick(kLeftOpen));
}

// ---- T7: Backing, Tick [not Step Done] / Backward (C6) ----------------------

TEST_F(MovementControllerTest, T7_BackwardLastsFiveTicks) {
    StopThenBackForFiveTicks();
    EXPECT_EQ(CONTROLLER_STATE_BACKING, get_controller_state());
}

// ---- T8: Backing, Tick [Step Done and All Blocked] / Backward (C5, C6) -------

TEST_F(MovementControllerTest, T8_AfterBackingMovesBackwardAgainWhenStillAllBlocked) {
    StopThenBackForFiveTicks();
    EXPECT_EQ(MOVEMENT_COMMAND_BACKWARD, Tick(kAllBlocked));
    EXPECT_EQ(CONTROLLER_STATE_BACKING, get_controller_state());
    EXPECT_EQ(0, get_step_ticks_elapsed()) << "the step timer must be restarted";
}

TEST_F(MovementControllerTest, T8_TheSecondBackwardStepAlsoLastsFiveTicks) {
    StopThenBackForFiveTicks();
    ExpectTicks(5, kAllBlocked, MOVEMENT_COMMAND_BACKWARD);
    EXPECT_EQ(MOVEMENT_COMMAND_TURN_RIGHT, Tick(kRightOpen));
}

// ---- T9: Backing, Tick [Step Done and Right Open] / Turn Right (C5, C8) ------

TEST_F(MovementControllerTest, T9_AfterBackingTurnsRightWhenTheRightIsOpen) {
    StopThenBackForFiveTicks();
    EXPECT_EQ(MOVEMENT_COMMAND_TURN_RIGHT, Tick(kRightOpen));
    EXPECT_EQ(CONTROLLER_STATE_TURNING_RIGHT, get_controller_state());
    EXPECT_EQ(0, get_step_ticks_elapsed());
}

// ---- T10: Backing, Tick [Step Done and Left Open] / Turn Left (C5, C8) -------

TEST_F(MovementControllerTest, T10_AfterBackingTurnsLeftWhenOnlyTheLeftIsOpen) {
    StopThenBackForFiveTicks();
    EXPECT_EQ(MOVEMENT_COMMAND_TURN_LEFT, Tick(kLeftOpen));
    EXPECT_EQ(CONTROLLER_STATE_TURNING_LEFT, get_controller_state());
    EXPECT_EQ(0, get_step_ticks_elapsed());
}

// ---- T11, T12: Turning Right (C8, B3, B4) -----------------------------------

TEST_F(MovementControllerTest, T11_RightTurnLastsFiveTicks) {
    StopForFiveTicks(kRightOpen);
    ExpectTicks(5, kRightOpen, MOVEMENT_COMMAND_TURN_RIGHT);
    EXPECT_EQ(CONTROLLER_STATE_TURNING_RIGHT, get_controller_state());
}

TEST_F(MovementControllerTest, T12_AfterTheRightTurnGoesForward) {
    StopForFiveTicks(kRightOpen);
    ExpectTicks(5, kRightOpen, MOVEMENT_COMMAND_TURN_RIGHT);
    EXPECT_EQ(MOVEMENT_COMMAND_FORWARD, Tick(kClear));
    EXPECT_EQ(CONTROLLER_STATE_FORWARD, get_controller_state());
    EXPECT_EQ(STEP_TIMER_IDLE, get_step_ticks_elapsed());
}

// ---- T13, T14: Turning Left (C8, B3, B4) ------------------------------------

TEST_F(MovementControllerTest, T13_LeftTurnLastsFiveTicks) {
    StopForFiveTicks(kLeftOpen);
    ExpectTicks(5, kLeftOpen, MOVEMENT_COMMAND_TURN_LEFT);
    EXPECT_EQ(CONTROLLER_STATE_TURNING_LEFT, get_controller_state());
}

TEST_F(MovementControllerTest, T14_AfterTheLeftTurnGoesForward) {
    StopForFiveTicks(kLeftOpen);
    ExpectTicks(5, kLeftOpen, MOVEMENT_COMMAND_TURN_LEFT);
    EXPECT_EQ(MOVEMENT_COMMAND_FORWARD, Tick(kClear));
    EXPECT_EQ(CONTROLLER_STATE_FORWARD, get_controller_state());
    EXPECT_EQ(STEP_TIMER_IDLE, get_step_ticks_elapsed());
}

// FSM note: the Situation Signal is ignored during a turn, and T12/T14 have no
// condition on it.
TEST_F(MovementControllerTest, T11_T12_SituationIsIgnoredDuringAndAtTheEndOfATurn) {
    StopForFiveTicks(kRightOpen);
    EXPECT_EQ(MOVEMENT_COMMAND_TURN_RIGHT, Tick(kRightOpen));
    EXPECT_EQ(MOVEMENT_COMMAND_TURN_RIGHT, Tick(kAllBlocked));
    EXPECT_EQ(MOVEMENT_COMMAND_TURN_RIGHT, Tick(kLeftOpen));
    EXPECT_EQ(MOVEMENT_COMMAND_TURN_RIGHT, Tick(kClear));
    EXPECT_EQ(MOVEMENT_COMMAND_TURN_RIGHT, Tick(kAllBlocked));
    EXPECT_EQ(MOVEMENT_COMMAND_FORWARD, Tick(kAllBlocked));
    EXPECT_EQ(CONTROLLER_STATE_FORWARD, get_controller_state());
}

// ---- Sequences --------------------------------------------------------------

// Timing example of the FSM document: stop on ticks t..t+4, turn on t+5..t+9,
// forward on t+10.
TEST_F(MovementControllerTest, TimingExample_ObstacleAheadWithTheRightOpen) {
    ExpectTicks(3, kClear, MOVEMENT_COMMAND_FORWARD);
    ExpectTicks(5, kRightOpen, MOVEMENT_COMMAND_STOP);
    ExpectTicks(5, kRightOpen, MOVEMENT_COMMAND_TURN_RIGHT);
    ExpectTicks(3, kClear, MOVEMENT_COMMAND_FORWARD);
}

// B4, C5: all blocked, still all blocked after backing once, then the left opens.
TEST_F(MovementControllerTest, DeadEnd_BacksTwiceThenTurnsLeft) {
    ExpectTicks(5, kAllBlocked, MOVEMENT_COMMAND_STOP);
    ExpectTicks(5, kAllBlocked, MOVEMENT_COMMAND_BACKWARD);
    ExpectTicks(5, kAllBlocked, MOVEMENT_COMMAND_BACKWARD);
    ExpectTicks(5, kLeftOpen, MOVEMENT_COMMAND_TURN_LEFT);
    EXPECT_EQ(MOVEMENT_COMMAND_FORWARD, Tick(kClear));
}

// B3: after an avoidance the controller handles the next obstacle the same way.
TEST_F(MovementControllerTest, HandlesASecondObstacleAfterTheFirstAvoidance) {
    ExpectTicks(5, kRightOpen, MOVEMENT_COMMAND_STOP);
    ExpectTicks(5, kRightOpen, MOVEMENT_COMMAND_TURN_RIGHT);
    EXPECT_EQ(MOVEMENT_COMMAND_FORWARD, Tick(kClear));
    ExpectTicks(5, kLeftOpen, MOVEMENT_COMMAND_STOP);
    ExpectTicks(5, kLeftOpen, MOVEMENT_COMMAND_TURN_LEFT);
    EXPECT_EQ(MOVEMENT_COMMAND_FORWARD, Tick(kClear));
}

// A turn that ends in front of an obstacle: T12 goes Forward first, then T2 stops.
TEST_F(MovementControllerTest, ObstacleRightAfterATurnIsHandledOnTheNextTick) {
    ExpectTicks(5, kRightOpen, MOVEMENT_COMMAND_STOP);
    ExpectTicks(5, kRightOpen, MOVEMENT_COMMAND_TURN_RIGHT);
    EXPECT_EQ(MOVEMENT_COMMAND_FORWARD, Tick(kAllBlocked));
    EXPECT_EQ(MOVEMENT_COMMAND_STOP, Tick(kAllBlocked));
    EXPECT_EQ(CONTROLLER_STATE_STOPPING, get_controller_state());
}

// ---- C9: after moving backward, only left and right decide ------------------
// Moving backward takes the RVC away from the obstacle, so the front sensor may
// read clear when the backward step ends.

TEST_F(MovementControllerTest, T9_C9_AfterBackingTurnsRightWhenTheRightIsOpenAndTheFrontIsClear) {
    StopThenBackForFiveTicks();
    EXPECT_EQ(MOVEMENT_COMMAND_TURN_RIGHT, Tick(kClear));
    EXPECT_EQ(CONTROLLER_STATE_TURNING_RIGHT, get_controller_state());
}

TEST_F(MovementControllerTest, T10_C9_AfterBackingTurnsLeftWhenOnlyTheLeftIsOpenAndTheFrontIsClear) {
    StopThenBackForFiveTicks();
    EXPECT_EQ(MOVEMENT_COMMAND_TURN_LEFT, Tick(kFrontClearLeftOpen));
    EXPECT_EQ(CONTROLLER_STATE_TURNING_LEFT, get_controller_state());
}

TEST_F(MovementControllerTest, T8_C9_AfterBackingMovesBackwardAgainWhenBothSidesAreBlockedAndTheFrontIsClear) {
    StopThenBackForFiveTicks();
    EXPECT_EQ(MOVEMENT_COMMAND_BACKWARD, Tick(kFrontClearSidesBlocked));
    EXPECT_EQ(CONTROLLER_STATE_BACKING, get_controller_state());
    EXPECT_EQ(0, get_step_ticks_elapsed());
}

// Q6 assumption: while going forward, obstacles on the sides alone do not stop the RVC.
TEST_F(MovementControllerTest, T1_SidesAreIgnoredWhileGoingForward) {
    ExpectTicks(3, kFrontClearLeftOpen, MOVEMENT_COMMAND_FORWARD);
    ExpectTicks(3, kFrontClearSidesBlocked, MOVEMENT_COMMAND_FORWARD);
    EXPECT_EQ(CONTROLLER_STATE_FORWARD, get_controller_state());
}

}  // namespace
