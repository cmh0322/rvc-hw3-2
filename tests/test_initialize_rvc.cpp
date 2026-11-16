// Module: Initialize RVC
// Source: FSM transition T0; Structure Chart sections 3.2, 5, and 7;
// Process Specification 3.2.4 (initial value of D4).
#include <string>
#include <vector>

#include <gtest/gtest.h>

#include "decide_actions.h"
#include "fake_hw.h"
#include "initialize_rvc.h"
#include "movement_controller.h"
#include "power_up_timer.h"
#include "step_timer.h"

namespace {

class InitializeRvcTest : public ::testing::Test {
protected:
    void SetUp() override { ResetFakeHw(); }
};

// T0: Power On / Forward.
TEST_F(InitializeRvcTest, T0_SendsForwardToTheMotorOnce) {
    initialize_rvc();
    EXPECT_EQ((std::vector<Direction>{DIRECTION_FORWARD}), fake_hw.motor);
}

// At power on only the Direction is issued. Clean is first issued on a Tick.
TEST_F(InitializeRvcTest, TouchesNoOtherHardware) {
    initialize_rvc();
    EXPECT_EQ((std::vector<std::string>{"motor"}), fake_hw.calls);
}

TEST_F(InitializeRvcTest, PutsTheHiddenDataIntoItsInitialCondition) {
    initialize_rvc();
    EXPECT_EQ(CONTROLLER_STATE_FORWARD, get_controller_state());
    EXPECT_EQ(STEP_TIMER_IDLE, get_step_ticks_elapsed());
    EXPECT_EQ(0, get_remaining_power_up_ticks());
}

TEST_F(InitializeRvcTest, ResetsASystemThatHasAlreadyRun) {
    initialize_rvc();
    decide_actions(OBSTACLE_SITUATION_CLEAR, true);         // a power-up is running
    decide_actions(OBSTACLE_SITUATION_ALL_BLOCKED, false);  // stopping, step timer running
    decide_actions(OBSTACLE_SITUATION_ALL_BLOCKED, false);
    ASSERT_EQ(CONTROLLER_STATE_STOPPING, get_controller_state());
    ASSERT_NE(STEP_TIMER_IDLE, get_step_ticks_elapsed());
    ASSERT_NE(0, get_remaining_power_up_ticks());

    initialize_rvc();
    EXPECT_EQ(CONTROLLER_STATE_FORWARD, get_controller_state());
    EXPECT_EQ(STEP_TIMER_IDLE, get_step_ticks_elapsed());
    EXPECT_EQ(0, get_remaining_power_up_ticks());
    EXPECT_EQ(DIRECTION_FORWARD, fake_hw.motor.back());
}

}  // namespace
