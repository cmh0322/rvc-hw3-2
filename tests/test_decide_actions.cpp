#include "test_input_helpers.h"
// Module: Decide Actions (central coordinator)
// Source: Structure Chart sections 3.5 and 5; Process Specifications 3.2.2,
// 3.2.3, 4.1, 4.2; requirements B1-B5, C2, C3.
#include <gtest/gtest.h>

#include "decide_actions.h"
#include "fake_hw.h"
#include "situations.h"
#include "movement_controller.h"
#include "power_up_timer.h"
#include "step_timer.h"

namespace {

const bool kDust = true;
const bool kNoDust = false;

class DecideActionsTest : public ::testing::Test {
protected:
    void SetUp() override {
        ResetFakeHw();
        reset_sensor_data(); detect_dust(false);
        reset_movement_controller();
        reset_power_up_timer();
    }

    // Expects the next `count` cycles to decide `command` and `clean`.
    static void ExpectCycles(int count, ObstacleSituation situation, bool dust,
                             MovementCommand command, Clean clean) {
        for (int cycle = 1; cycle <= count; ++cycle) {
            const Actions actions = TestActions(situation, dust);
            EXPECT_EQ(command, actions.movement_command) << "cycle " << cycle << " of " << count;
            EXPECT_EQ(clean, actions.clean) << "cycle " << cycle << " of " << count;
        }
    }
};

// B1, B2: goes forward while cleaning.
TEST_F(DecideActionsTest, ClearPathWithoutDustGoesForwardAndCleans) {
    ExpectCycles(5, kClear, kNoDust, MOVEMENT_COMMAND_FORWARD, CLEAN_START);
}

// B5, C3: dust powers up the cleaning for 5 ticks, then normal cleaning returns.
TEST_F(DecideActionsTest, DustPowersUpTheCleaningForFiveCycles) {
    ExpectCycles(1, kClear, kDust, MOVEMENT_COMMAND_FORWARD, CLEAN_POWER_UP);
    ExpectCycles(4, kClear, kNoDust, MOVEMENT_COMMAND_FORWARD, CLEAN_POWER_UP);
    ExpectCycles(3, kClear, kNoDust, MOVEMENT_COMMAND_FORWARD, CLEAN_START);
}

// B3, C2: at an obstacle the RVC stops moving and stops cleaning on the same cycle.
TEST_F(DecideActionsTest, ObstacleStopsMovementAndCleaningOnTheSameCycle) {
    ExpectCycles(1, kRightOpen, kNoDust, MOVEMENT_COMMAND_STOP, CLEAN_STOP);
}

// B3: cleaning stays stopped for the whole avoidance and resumes with forward movement.
TEST_F(DecideActionsTest, CleaningIsStoppedDuringAvoidanceAndResumesAfterwards) {
    ExpectCycles(5, kRightOpen, kNoDust, MOVEMENT_COMMAND_STOP, CLEAN_STOP);
    ExpectCycles(5, kRightOpen, kNoDust, MOVEMENT_COMMAND_TURN_RIGHT, CLEAN_STOP);
    ExpectCycles(3, kClear, kNoDust, MOVEMENT_COMMAND_FORWARD, CLEAN_START);
}

// B4: with front, left, and right blocked the RVC moves backward, not cleaning.
TEST_F(DecideActionsTest, AllBlockedMovesBackwardWithoutCleaning) {
    ExpectCycles(5, kAllBlocked, kNoDust, MOVEMENT_COMMAND_STOP, CLEAN_STOP);
    ExpectCycles(5, kAllBlocked, kNoDust, MOVEMENT_COMMAND_BACKWARD, CLEAN_STOP);
}

// B3 over B5: dust does not power up the cleaning while avoiding.
TEST_F(DecideActionsTest, DustWhileAvoidingDoesNotPowerUp) {
    ExpectCycles(5, kLeftOpen, kDust, MOVEMENT_COMMAND_STOP, CLEAN_STOP);
    ExpectCycles(5, kLeftOpen, kDust, MOVEMENT_COMMAND_TURN_LEFT, CLEAN_STOP);
}

// Structure Chart 3.1: each callee is called once per cycle.
TEST_F(DecideActionsTest, AdvancesTheControllerAndThePowerUpByOneTickPerCall) {
    TestActions(kClear, kDust);
    EXPECT_EQ(4, get_remaining_power_up_ticks());

    TestActions(kAllBlocked, kNoDust);
    EXPECT_EQ(CONTROLLER_STATE_STOPPING, get_controller_state());
    EXPECT_EQ(0, get_step_ticks_elapsed());

    TestActions(kAllBlocked, kNoDust);
    EXPECT_EQ(1, get_step_ticks_elapsed());
}

// The central branch decides only; it reads no sensor and drives no output.
TEST_F(DecideActionsTest, DoesNotTouchTheHardware) {
    TestActions(kClear, kDust);
    TestActions(kAllBlocked, kNoDust);
    EXPECT_TRUE(fake_hw.calls.empty());
}

}  // namespace
