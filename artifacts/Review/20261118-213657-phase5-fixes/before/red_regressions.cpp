// C12/C13/C15 regressions, first executed against the pre-correction implementation.
#include <gtest/gtest.h>
#include "controller.h"
#include "fake_hw.h"
#include "initialize_rvc.h"
#include "power_up_timer.h"

namespace {
class RevisionRegression : public ::testing::Test {
protected:
    void SetUp() override { ResetFakeHw(); }
    static void Cycle(bool front, bool dust) {
        fake_hw.front = front; fake_hw.dust = dust; controller();
    }
};
TEST_F(RevisionRegression, C13_NoPowerOnCommands) {
    initialize_rvc();
    EXPECT_TRUE(fake_hw.motor.empty());
    EXPECT_TRUE(fake_hw.cleaner.empty());
}
TEST_F(RevisionRegression, C12_AllInitialSensorsAcquired) {
    initialize_rvc();
    EXPECT_EQ(1, fake_hw.front_reads); EXPECT_EQ(1, fake_hw.left_reads);
    EXPECT_EQ(1, fake_hw.right_reads); EXPECT_EQ(1, fake_hw.dust_reads);
}
TEST_F(RevisionRegression, C15_AvoidanceDetectionSurvivesClear) {
    initialize_rvc();
    Cycle(true,true);
    for(int i=0;i<9;i++) Cycle(true,false);
    Cycle(false,false);
    EXPECT_EQ(CLEAN_POWER_UP,fake_hw.cleaner.back());
    EXPECT_EQ(4,get_remaining_power_up_ticks());
}
TEST_F(RevisionRegression, C15_NewDetectionOverridesPausedCount) {
    initialize_rvc(); Cycle(false,true); Cycle(false,false);
    Cycle(true,true);
    for(int i=0;i<9;i++) Cycle(true,false);
    Cycle(false,false);
    EXPECT_EQ(4,get_remaining_power_up_ticks());
}
}
