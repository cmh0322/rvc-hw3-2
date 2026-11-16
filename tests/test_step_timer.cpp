// Step Timer group: Advance Step Timer, Start Step Timer, Reset Step Timer
// (SA Process 3.2.4, Data Store D4)
// Source: Process Specification 3.2.4; requirements C6, C7, C8.
#include <gtest/gtest.h>

#include "step_timer.h"

namespace {

class StepTimerTest : public ::testing::Test {
protected:
    void SetUp() override { reset_step_timer(); }

    // Advances the timer `ticks` times and returns how often Step Done was reported.
    static int AdvanceAndCountStepDone(int ticks) {
        int step_done_count = 0;
        for (int i = 0; i < ticks; ++i) {
            if (advance_step_timer()) {
                ++step_done_count;
            }
        }
        return step_done_count;
    }
};

// Process Specification 3.2.4: the initial value of D4 is Idle.
TEST_F(StepTimerTest, IsIdleAfterReset) {
    EXPECT_EQ(STEP_TIMER_IDLE, get_step_ticks_elapsed());
}

TEST_F(StepTimerTest, AdvanceWhileIdleNeverReportsStepDone) {
    EXPECT_EQ(0, AdvanceAndCountStepDone(12));
    EXPECT_EQ(STEP_TIMER_IDLE, get_step_ticks_elapsed());
}

TEST_F(StepTimerTest, StartSetsTheCountToZero) {
    start_step_timer();
    EXPECT_EQ(0, get_step_ticks_elapsed());
}

TEST_F(StepTimerTest, CountsOneTickPerAdvance) {
    start_step_timer();
    for (int tick = 1; tick <= 4; ++tick) {
        advance_step_timer();
        EXPECT_EQ(tick, get_step_ticks_elapsed()) << "after advance " << tick;
    }
}

// C6, C7, C8: a step lasts 5 ticks. The tick on which it starts is its first
// tick, so Step Done arrives on the fifth advance after the start.
TEST_F(StepTimerTest, ReportsStepDoneOnTheFifthAdvanceAfterStart) {
    start_step_timer();
    EXPECT_FALSE(advance_step_timer());
    EXPECT_FALSE(advance_step_timer());
    EXPECT_FALSE(advance_step_timer());
    EXPECT_FALSE(advance_step_timer());
    EXPECT_TRUE(advance_step_timer());
}

TEST_F(StepTimerTest, IsIdleAgainAfterStepDone) {
    start_step_timer();
    EXPECT_EQ(1, AdvanceAndCountStepDone(5));
    EXPECT_EQ(STEP_TIMER_IDLE, get_step_ticks_elapsed());
    EXPECT_EQ(0, AdvanceAndCountStepDone(12)) << "Step Done must be reported only once";
}

TEST_F(StepTimerTest, StartDuringARunningStepRestartsTheCount) {
    start_step_timer();
    EXPECT_EQ(0, AdvanceAndCountStepDone(3));
    start_step_timer();
    EXPECT_EQ(0, get_step_ticks_elapsed());
    EXPECT_EQ(0, AdvanceAndCountStepDone(4));
    EXPECT_TRUE(advance_step_timer());
}

TEST_F(StepTimerTest, ResetStopsARunningStep) {
    start_step_timer();
    EXPECT_EQ(0, AdvanceAndCountStepDone(2));
    reset_step_timer();
    EXPECT_EQ(STEP_TIMER_IDLE, get_step_ticks_elapsed());
    EXPECT_EQ(0, AdvanceAndCountStepDone(12));
}

TEST_F(StepTimerTest, CanRunAnotherStepAfterStepDone) {
    start_step_timer();
    EXPECT_EQ(1, AdvanceAndCountStepDone(5));
    start_step_timer();
    EXPECT_EQ(0, AdvanceAndCountStepDone(4));
    EXPECT_TRUE(advance_step_timer());
}

}  // namespace
