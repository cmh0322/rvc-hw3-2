// Output branch: Issue Movement Output (SA Process 3.2.3, Direction part),
// Put Outputs (efferent coordinator)
// Source: Process Specification 3.2.3; Structure Chart sections 3.6 and 5;
// Event List (Direction, Clean); requirements B1-B5, C1, C2.
#include <string>
#include <vector>

#include <gtest/gtest.h>

#include "fake_hw.h"
#include "issue_movement_output.h"
#include "put_outputs.h"

namespace {

class OutputsTest : public ::testing::Test {
protected:
    void SetUp() override { ResetFakeHw(); }

    // Issues one Movement Command and returns the single Direction sent to the Motor.
    static Direction DirectionFor(MovementCommand movement_command) {
        ResetFakeHw();
        issue_movement_output(movement_command);
        EXPECT_EQ(1u, fake_hw.motor.size()) << "the Motor must be driven exactly once";
        return fake_hw.motor.empty() ? static_cast<Direction>(-1) : fake_hw.motor.front();
    }
};

// ---- Issue Movement Output --------------------------------------------------

// B2
TEST_F(OutputsTest, IssueMovementOutput_ForwardCommandGivesForwardDirection) {
    EXPECT_EQ(DIRECTION_FORWARD, DirectionFor(MOVEMENT_COMMAND_FORWARD));
}

// B3, C2
TEST_F(OutputsTest, IssueMovementOutput_StopCommandGivesStopDirection) {
    EXPECT_EQ(DIRECTION_STOP, DirectionFor(MOVEMENT_COMMAND_STOP));
}

// B3, C1
TEST_F(OutputsTest, IssueMovementOutput_TurnRightCommandGivesTurnRightDirection) {
    EXPECT_EQ(DIRECTION_TURN_RIGHT, DirectionFor(MOVEMENT_COMMAND_TURN_RIGHT));
}

// B3
TEST_F(OutputsTest, IssueMovementOutput_TurnLeftCommandGivesTurnLeftDirection) {
    EXPECT_EQ(DIRECTION_TURN_LEFT, DirectionFor(MOVEMENT_COMMAND_TURN_LEFT));
}

// B4
TEST_F(OutputsTest, IssueMovementOutput_BackwardCommandGivesBackwardDirection) {
    EXPECT_EQ(DIRECTION_BACKWARD, DirectionFor(MOVEMENT_COMMAND_BACKWARD));
}

TEST_F(OutputsTest, IssueMovementOutput_DoesNotDriveTheCleaner) {
    issue_movement_output(MOVEMENT_COMMAND_FORWARD);
    EXPECT_TRUE(fake_hw.cleaner.empty());
}

// ---- Put Outputs ------------------------------------------------------------

TEST_F(OutputsTest, PutOutputs_SendsTheDirectionToTheMotorAndTheCleanToTheCleaner) {
    put_outputs(MOVEMENT_COMMAND_TURN_LEFT, CLEAN_STOP);
    EXPECT_EQ((std::vector<Direction>{DIRECTION_TURN_LEFT}), fake_hw.motor);
    EXPECT_EQ((std::vector<Clean>{CLEAN_STOP}), fake_hw.cleaner);
}

TEST_F(OutputsTest, PutOutputs_PassesEveryCleanValueUnchanged) {
    put_outputs(MOVEMENT_COMMAND_FORWARD, CLEAN_START);
    put_outputs(MOVEMENT_COMMAND_FORWARD, CLEAN_POWER_UP);
    put_outputs(MOVEMENT_COMMAND_STOP, CLEAN_STOP);
    EXPECT_EQ((std::vector<Clean>{CLEAN_START, CLEAN_POWER_UP, CLEAN_STOP}), fake_hw.cleaner);
    EXPECT_EQ((std::vector<Direction>{DIRECTION_FORWARD, DIRECTION_FORWARD, DIRECTION_STOP}), fake_hw.motor);
}

// Structure Chart 3.1: Issue Movement Output is called before Drive Cleaner.
TEST_F(OutputsTest, PutOutputs_DrivesTheMotorThenTheCleanerAndNothingElse) {
    put_outputs(MOVEMENT_COMMAND_FORWARD, CLEAN_START);
    EXPECT_EQ((std::vector<std::string>{"motor", "cleaner"}), fake_hw.calls);
}

}  // namespace
