// Module: Main (root of the Structure Chart)
// Source: Structure Chart sections 3.1, 3.2, and 5; Event List (Tick).
//
// main() never returns. For these tests main.c is compiled with main renamed
// to rvc_main, and the fake wait_for_tick ends the loop by jumping back here
// after the requested number of Ticks ("power off").
#include <csetjmp>
#include <string>
#include <vector>

#include <gtest/gtest.h>

#include "fake_hw.h"

extern "C" int rvc_main(void);

namespace {

class MainTest : public ::testing::Test {
protected:
    void SetUp() override { ResetFakeHw(); }

    // Runs main() until `ticks` Ticks have been delivered.
    static void RunMainForTicks(int ticks) {
        fake_hw.ticks_to_deliver = ticks;
        if (setjmp(fake_hw.power_off) == 0) {
            rvc_main();
            ADD_FAILURE() << "main() returned; it must keep running until power off";
        }
    }
};

// Structure Chart 3.1: Main calls Initialize RVC once, before the first Tick.
TEST_F(MainTest, InitializesTheSystemBeforeWaitingForTheFirstTick) {
    RunMainForTicks(0);
    EXPECT_EQ((std::vector<std::string>{"motor"}), fake_hw.calls);
    EXPECT_EQ((std::vector<Direction>{DIRECTION_FORWARD}), fake_hw.motor);
}

// Event List: Tick is the time base. One control cycle runs for every Tick.
TEST_F(MainTest, RunsOneControlCycleForEveryTick) {
    RunMainForTicks(7);
    EXPECT_EQ(7, fake_hw.ticks);
    EXPECT_EQ(7u, fake_hw.cleaner.size());
    EXPECT_EQ(8u, fake_hw.motor.size()) << "one at power on, then one per Tick";
    EXPECT_EQ(7, fake_hw.front_reads);
}

// Structure Chart 3.1: in every cycle, Wait For Tick comes before Controller.
TEST_F(MainTest, WaitsForTheTickBeforeEachControlCycle) {
    RunMainForTicks(2);
    // power on: motor | tick, 4 sensor reads, motor, cleaner | tick, ...
    ASSERT_EQ(15u, fake_hw.calls.size());
    EXPECT_EQ("motor", fake_hw.calls[0]);
    EXPECT_EQ("tick", fake_hw.calls[1]);
    EXPECT_EQ("motor", fake_hw.calls[6]);
    EXPECT_EQ("cleaner", fake_hw.calls[7]);
    EXPECT_EQ("tick", fake_hw.calls[8]);
    EXPECT_EQ("motor", fake_hw.calls[13]);
    EXPECT_EQ("cleaner", fake_hw.calls[14]);
}

// Initialize RVC runs once only: the avoidance carries on from Tick to Tick.
TEST_F(MainTest, DoesNotInitializeAgainBetweenTicks) {
    fake_hw.front = true;
    RunMainForTicks(6);
    const std::vector<Direction> expected{
        DIRECTION_FORWARD,                                    // power on (T0)
        DIRECTION_STOP, DIRECTION_STOP, DIRECTION_STOP,       // Ticks 1-5: stop (C7)
        DIRECTION_STOP, DIRECTION_STOP,
        DIRECTION_TURN_RIGHT};                                // Tick 6: turn right (C1)
    EXPECT_EQ(expected, fake_hw.motor);
}

// Each cycle uses the sensor values present at its Tick.
TEST_F(MainTest, EachCycleUsesTheSensorValuesAtItsTick) {
    fake_hw.before_tick = [](int tick) { fake_hw.dust = (tick == 2); };
    RunMainForTicks(3);
    const std::vector<Clean> expected{CLEAN_START, CLEAN_POWER_UP, CLEAN_POWER_UP};
    EXPECT_EQ(expected, fake_hw.cleaner);
}

}  // namespace
