#include "test_input_helpers.h"
#include "fake_hw.h"
#include "initialize_rvc.h"
#include "movement_controller.h"
#include "step_timer.h"
#include <gtest/gtest.h>
TEST(InitializeRvc, ActualSamplesWithoutCommands) {
    ResetFakeHw(); fake_hw.front=true;
    initialize_rvc();
    EXPECT_TRUE(inputs_ready()); EXPECT_TRUE(get_obstacle_location().front_obstacle);
    EXPECT_EQ((std::vector<std::string>{"front","left","right","dust"}),fake_hw.calls);
    EXPECT_TRUE(fake_hw.motor.empty()); EXPECT_TRUE(fake_hw.cleaner.empty());
}
TEST(InitializeRvc, ResetsTimersAndPendingBeforeSampling) {
    ResetFakeHw(); initialize_rvc(); TestActions({true,SIDE_SITUATION_RIGHT_OPEN},true);
    ResetFakeHw(); initialize_rvc();
    EXPECT_EQ(CONTROLLER_STATE_FORWARD,get_controller_state());
    EXPECT_EQ(STEP_TIMER_IDLE,get_step_ticks_elapsed());
    EXPECT_EQ(0,get_remaining_power_up_ticks());
    EXPECT_FALSE(get_dust_existence().pending);
}
TEST(InitializeRvc, InitialDustPulseIsNotResetAfterSampling) {
    ResetFakeHw();
    fake_hw.initial_events={{INPUT_DUST,true},{INPUT_DUST,false},{INPUT_RIGHT,false},
        {INPUT_FRONT,true},{INPUT_LEFT,false}};
    initialize_rvc();
    EXPECT_TRUE(inputs_ready()); EXPECT_TRUE(get_dust_existence().pending);
    EXPECT_FALSE(get_dust_existence().current); EXPECT_TRUE(fake_hw.motor.empty());
}
