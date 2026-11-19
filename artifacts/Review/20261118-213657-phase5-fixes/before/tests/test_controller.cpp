// Module: Controller (one control cycle per Tick)
// Source: Structure Chart sections 3.1, 3.3, and 5; DFD Level 3
// "Execution Order Within One Tick"; Event List.
#include <algorithm>
#include <string>
#include <vector>

#include "rvc_system_fixture.h"

#include "movement_controller.h"
#include "power_up_timer.h"
#include "step_timer.h"

namespace {

class ControllerTest : public RvcSystemTest {};

// Event List: every Tick produces one Direction and one Clean.
TEST_F(ControllerTest, OneCycleSendsOneDirectionAndOneClean) {
    controller();
    EXPECT_EQ(1u, fake_hw.motor.size());
    EXPECT_EQ(1u, fake_hw.cleaner.size());
}

// Structure Chart, design decision 1: every sensor is read once per cycle.
TEST_F(ControllerTest, OneCycleReadsEverySensorExactlyOnce) {
    controller();
    EXPECT_EQ(1, fake_hw.front_reads);
    EXPECT_EQ(1, fake_hw.left_reads);
    EXPECT_EQ(1, fake_hw.right_reads);
    EXPECT_EQ(1, fake_hw.dust_reads);
}

// Structure Chart 3.1: Get Inputs, then Decide Actions, then Put Outputs.
TEST_F(ControllerTest, ReadsAllInputsBeforeItDrivesAnyOutput) {
    controller();
    ASSERT_EQ(6u, fake_hw.calls.size());
    std::vector<std::string> inputs(fake_hw.calls.begin(), fake_hw.calls.begin() + 4);
    std::sort(inputs.begin(), inputs.end());
    EXPECT_EQ((std::vector<std::string>{"dust", "front", "left", "right"}), inputs);
    EXPECT_EQ("motor", fake_hw.calls[4]);
    EXPECT_EQ("cleaner", fake_hw.calls[5]);
}

TEST_F(ControllerTest, DoesNotWaitForTheTickItself) {
    controller();
    EXPECT_EQ(0, fake_hw.ticks) << "waiting for the Tick is Main's job";
}

TEST_F(ControllerTest, UsesTheSensorValuesOfTheCurrentCycle) {
    SetSensors(false, false, false, false);
    ExpectCycles(1, DIRECTION_FORWARD, CLEAN_START);
    SetSensors(false, false, false, true);
    ExpectCycles(1, DIRECTION_FORWARD, CLEAN_POWER_UP);
    SetSensors(true, false, false, false);
    ExpectCycles(1, DIRECTION_STOP, CLEAN_STOP);
}

// One cycle advances the controller, the step timer, and the power-up by one Tick.
TEST_F(ControllerTest, OneCycleIsOneTickForTheHiddenData) {
    SetSensors(false, false, false, true);
    controller();
    EXPECT_EQ(4, get_remaining_power_up_ticks());

    SetSensors(true, true, true, false);
    controller();
    EXPECT_EQ(CONTROLLER_STATE_STOPPING, get_controller_state());
    EXPECT_EQ(0, get_step_ticks_elapsed());
    controller();
    EXPECT_EQ(1, get_step_ticks_elapsed());
}

}  // namespace
