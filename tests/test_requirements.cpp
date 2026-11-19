// Requirement-level tests. Each test drives the whole system through
// Controller, one call per Tick, and checks what reaches the Motor and Cleaner.
// Source: docs/preliminary_requirements.md (B1-B7),
// docs/requirements_clarifications.md (C1-C16).
#include "rvc_system_fixture.h"

namespace {

class RequirementsTest : public RvcSystemTest {
protected:
    // Finds an obstacle and stays stopped for the 5-tick stop (C2, C7).
    static void StopForFiveTicks() { ExpectCycles(5, DIRECTION_STOP, CLEAN_STOP); }
};

// B1: the RVC automatically cleans.  B2: it goes straight forward while cleaning.
TEST_F(RequirementsTest, B1_B2_GoesStraightForwardWhileCleaning) {
    SetSensors(false, false, false, false);
    ExpectCycles(20, DIRECTION_FORWARD, CLEAN_START);
}

// B3: "If its sensors found an obstacle, it stops cleaning ..."
// C2: it stops moving first.  C7: the stop lasts 5 ticks.
TEST_F(RequirementsTest, B3_C2_C7_StopsMovingAndCleaningForFiveTicksAtAnObstacle) {
    SetObstacles(false, false, false);
    ExpectCycles(2, DIRECTION_FORWARD, CLEAN_START);
    SetObstacles(true, false, false);
    ExpectCycles(5, DIRECTION_STOP, CLEAN_STOP);
}

// B3: "... turns aside left or right ..."
// C1: with both sides clear it turns right.  C8: a turn lasts 5 ticks.
TEST_F(RequirementsTest, B3_C1_C8_TurnsRightForFiveTicksWhenBothSidesAreClear) {
    SetObstacles(true, false, false);
    StopForFiveTicks();
    ExpectCycles(5, DIRECTION_TURN_RIGHT, CLEAN_STOP);
}

// B3: the left is blocked, so it turns right.
TEST_F(RequirementsTest, B3_TurnsRightWhenTheLeftIsBlocked) {
    SetObstacles(true, true, false);
    StopForFiveTicks();
    ExpectCycles(5, DIRECTION_TURN_RIGHT, CLEAN_STOP);
}

// B3: the right is blocked, so it turns left.  C8: 5 ticks.
TEST_F(RequirementsTest, B3_C8_TurnsLeftForFiveTicksWhenTheRightIsBlocked) {
    SetObstacles(true, false, true);
    StopForFiveTicks();
    ExpectCycles(5, DIRECTION_TURN_LEFT, CLEAN_STOP);
}

// B3: "... and goes forward with cleaning."
TEST_F(RequirementsTest, B3_GoesForwardWithCleaningAfterTurningAside) {
    SetObstacles(true, false, false);
    StopForFiveTicks();
    ExpectCycles(5, DIRECTION_TURN_RIGHT, CLEAN_STOP);
    SetObstacles(false, false, false);
    ExpectCycles(5, DIRECTION_FORWARD, CLEAN_START);
}

// B4: "If there are obstacles in both front, left and right, it move backward ..."
// C6: moving backward lasts 5 ticks.
TEST_F(RequirementsTest, B4_C6_MovesBackwardForFiveTicksWhenFrontLeftAndRightAreBlocked) {
    SetObstacles(true, true, true);
    StopForFiveTicks();
    ExpectCycles(5, DIRECTION_BACKWARD, CLEAN_STOP);
}

// B4: "... and turn aside left or right, and goes forward."
// C5: after moving backward it turns right if the right is clear.
TEST_F(RequirementsTest, B4_C5_AfterBackingTurnsRightWhenTheRightIsClearThenGoesForward) {
    SetObstacles(true, true, true);
    StopForFiveTicks();
    ExpectCycles(5, DIRECTION_BACKWARD, CLEAN_STOP);
    SetObstacles(true, true, false);
    ExpectCycles(5, DIRECTION_TURN_RIGHT, CLEAN_STOP);
    SetObstacles(false, false, false);
    ExpectCycles(3, DIRECTION_FORWARD, CLEAN_START);
}

// C5: if the right is blocked and the left is clear, it turns left.
TEST_F(RequirementsTest, C5_AfterBackingTurnsLeftWhenOnlyTheLeftIsClear) {
    SetObstacles(true, true, true);
    StopForFiveTicks();
    ExpectCycles(5, DIRECTION_BACKWARD, CLEAN_STOP);
    SetObstacles(true, false, true);
    ExpectCycles(5, DIRECTION_TURN_LEFT, CLEAN_STOP);
    SetObstacles(false, false, false);
    ExpectCycles(3, DIRECTION_FORWARD, CLEAN_START);
}

// C5: if left and right are still both blocked, it moves backward once more.
TEST_F(RequirementsTest, C5_C6_AfterBackingMovesBackwardAgainWhenStillBlocked) {
    SetObstacles(true, true, true);
    StopForFiveTicks();
    ExpectCycles(5, DIRECTION_BACKWARD, CLEAN_STOP);
    ExpectCycles(5, DIRECTION_BACKWARD, CLEAN_STOP);
    SetObstacles(true, true, false);
    ExpectCycles(5, DIRECTION_TURN_RIGHT, CLEAN_STOP);
}

// B5: "If it detects dust, power up the cleaning for a while."
// C3: "for a while" is 5 ticks.
TEST_F(RequirementsTest, B5_C3_PowersUpTheCleaningForFiveTicksWhenDustIsDetected) {
    SetSensors(false, false, false, false);
    ExpectCycles(2, DIRECTION_FORWARD, CLEAN_START);
    SetSensors(false, false, false, true);
    ExpectCycles(1, DIRECTION_FORWARD, CLEAN_POWER_UP);
    SetSensors(false, false, false, false);
    ExpectCycles(4, DIRECTION_FORWARD, CLEAN_POWER_UP);
    ExpectCycles(5, DIRECTION_FORWARD, CLEAN_START);
}

// B5: dust does not change the movement.
TEST_F(RequirementsTest, B5_DustDoesNotChangeTheMovement) {
    SetSensors(false, false, false, true);
    ExpectCycles(1, DIRECTION_FORWARD, CLEAN_POWER_UP);
}

// B3 and B5 together: an obstacle stops the cleaning even where there is dust.
TEST_F(RequirementsTest, B3_B5_ObstacleStopsTheCleaningEvenWithDust) {
    SetSensors(true, false, false, true);
    ExpectCycles(5, DIRECTION_STOP, CLEAN_STOP);
    ExpectCycles(5, DIRECTION_TURN_RIGHT, CLEAN_STOP);
}

// C9: after moving backward the front may read clear; left and right decide.
TEST_F(RequirementsTest, C9_AfterBackingDecidesByLeftAndRightOnlyWhenTheFrontIsClear) {
    SetObstacles(true, true, true);
    StopForFiveTicks();
    ExpectCycles(5, DIRECTION_BACKWARD, CLEAN_STOP);
    SetObstacles(false, true, true);                      // still between two walls
    ExpectCycles(5, DIRECTION_BACKWARD, CLEAN_STOP);
    SetObstacles(false, false, true);                     // the left has opened
    ExpectCycles(5, DIRECTION_TURN_LEFT, CLEAN_STOP);
    SetObstacles(false, false, false);
    ExpectCycles(2, DIRECTION_FORWARD, CLEAN_START);
}

// C10: dust detected again during a power-up restarts the 5 ticks.
TEST_F(RequirementsTest, C10_DustDuringAPowerUpRestartsTheFiveTicks) {
    SetSensors(false, false, false, true);
    ExpectCycles(1, DIRECTION_FORWARD, CLEAN_POWER_UP);
    SetSensors(false, false, false, false);
    ExpectCycles(2, DIRECTION_FORWARD, CLEAN_POWER_UP);
    SetSensors(false, false, false, true);
    ExpectCycles(1, DIRECTION_FORWARD, CLEAN_POWER_UP);
    SetSensors(false, false, false, false);
    ExpectCycles(4, DIRECTION_FORWARD, CLEAN_POWER_UP);
    ExpectCycles(2, DIRECTION_FORWARD, CLEAN_START);
}

// C11: a power-up interrupted by an avoidance continues afterwards.
TEST_F(RequirementsTest, C11_PowerUpContinuesAfterAnAvoidance) {
    SetSensors(false, false, false, true);
    ExpectCycles(1, DIRECTION_FORWARD, CLEAN_POWER_UP);   // 4 ticks remain
    SetSensors(true, false, false, false);
    ExpectCycles(5, DIRECTION_STOP, CLEAN_STOP);
    ExpectCycles(5, DIRECTION_TURN_RIGHT, CLEAN_STOP);
    SetSensors(false, false, false, false);
    ExpectCycles(4, DIRECTION_FORWARD, CLEAN_POWER_UP);
    ExpectCycles(2, DIRECTION_FORWARD, CLEAN_START);
}

// ---- C16 confirmed requirement ---------------------------------------------

// C16: obstacles on the left or right do not
// trigger avoidance while the front is clear.
TEST_F(RequirementsTest, C16_SideObstaclesAloneDoNotTriggerAvoidance) {
    SetObstacles(false, true, true);
    ExpectCycles(5, DIRECTION_FORWARD, CLEAN_START);
    SetObstacles(false, true, false);
    ExpectCycles(5, DIRECTION_FORWARD, CLEAN_START);
    SetObstacles(false, false, true);
    ExpectCycles(5, DIRECTION_FORWARD, CLEAN_START);
}

}  // namespace
