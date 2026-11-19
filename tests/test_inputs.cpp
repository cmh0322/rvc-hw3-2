#include "test_input_helpers.h"
#include "fake_hw.h"
#include "get_inputs.h"
#include "movement_controller.h"
#include "step_timer.h"
#include <gtest/gtest.h>
class InputsTest : public ::testing::Test {
protected: void SetUp() override {ResetFakeHw(); reset_sensor_data();}
};
TEST_F(InputsTest, ActualFalseRequiredForEverySensor) {
    EXPECT_FALSE(inputs_ready());
    dispatch_sensor_input({INPUT_FRONT,false}); EXPECT_FALSE(inputs_ready());
    dispatch_sensor_input({INPUT_LEFT,false}); EXPECT_FALSE(inputs_ready());
    dispatch_sensor_input({INPUT_RIGHT,false}); EXPECT_FALSE(inputs_ready());
    dispatch_sensor_input({INPUT_DUST,false}); EXPECT_TRUE(inputs_ready());
    reset_sensor_data(); EXPECT_FALSE(inputs_ready());
}
TEST_F(InputsTest, SingleObstacleUpdatePreservesOtherFields) {
    Observe(true,true,true,false);
    dispatch_sensor_input({INPUT_LEFT,false});
    auto location=get_obstacle_location();
    EXPECT_TRUE(location.front_obstacle); EXPECT_FALSE(location.left_obstacle);
    EXPECT_TRUE(location.right_obstacle);
    location.front_obstacle=false;
    EXPECT_TRUE(get_obstacle_location().front_obstacle);
    dispatch_sensor_input({INPUT_FRONT,false});
    dispatch_sensor_input({INPUT_RIGHT,false});
    EXPECT_FALSE(get_obstacle_location().front_obstacle);
    EXPECT_FALSE(get_obstacle_location().right_obstacle);
}
TEST_F(InputsTest, TrueFalseDustIsRetainedAndGetterDoesNotConsume) {
    detect_dust(true); detect_dust(false);
    EXPECT_FALSE(get_dust_existence().current); EXPECT_TRUE(get_dust_existence().pending);
    auto copy=get_dust_existence(); copy.pending=false;
    EXPECT_FALSE(copy.pending); EXPECT_TRUE(get_dust_existence().pending);
    clear_pending_dust(); EXPECT_FALSE(get_dust_existence().pending);
    detect_dust(true); clear_pending_dust(); EXPECT_TRUE(get_dust_existence().current);
}
TEST_F(InputsTest, StoredInputsAreClassifiedWithoutHardwarePolling) {
    Observe(true,false,true,true);
    EXPECT_EQ(SIDE_SITUATION_LEFT_OPEN,get_inputs().side_situation);
    EXPECT_TRUE(get_inputs().front_blocked); EXPECT_TRUE(fake_hw.calls.empty());
}
TEST_F(InputsTest, SensorEventsDoNotAdvanceTimersOrOutput) {
    reset_movement_controller(); reset_power_up_timer(); start_step_timer();
    Observe(true,true,true,true);
    EXPECT_EQ(0,get_step_ticks_elapsed()); EXPECT_EQ(0,get_remaining_power_up_ticks());
    EXPECT_EQ(CONTROLLER_STATE_FORWARD,get_controller_state());
    EXPECT_TRUE(fake_hw.motor.empty()); EXPECT_TRUE(fake_hw.cleaner.empty());
}
