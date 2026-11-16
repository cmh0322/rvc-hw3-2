// Power-Up Timer group: Track Power-Up, Reset Power-Up Timer
// (SA Process 4.1, Data Store D3)
// Source: Process Specification 4.1; requirements B5, C3; open questions Q4, Q5.
#include <gtest/gtest.h>

#include "power_up_timer.h"

namespace {

const bool kDust = true;
const bool kNoDust = false;

class PowerUpTimerTest : public ::testing::Test {
protected:
    void SetUp() override { reset_power_up_timer(); }

    // Expects the next `count` Ticks to report `expected` as Power-Up Active.
    static void ExpectTicks(int count, MovementStatus movement_status, bool dust_existence, bool expected) {
        for (int tick = 1; tick <= count; ++tick) {
            EXPECT_EQ(expected, track_power_up(movement_status, dust_existence))
                << "tick " << tick << " of " << count;
        }
    }
};

// Design decision 3 of the Structure Chart: the initial count is 0.
TEST_F(PowerUpTimerTest, CountIsZeroAfterReset) {
    EXPECT_EQ(0, get_remaining_power_up_ticks());
}

// B1, B2: without dust the cleaning is not powered up.
TEST_F(PowerUpTimerTest, NoDustMeansNoPowerUp) {
    ExpectTicks(10, MOVEMENT_STATUS_FORWARD, kNoDust, false);
    EXPECT_EQ(0, get_remaining_power_up_ticks());
}

// B5: detected dust powers up the cleaning on the same tick.
TEST_F(PowerUpTimerTest, DustWhileMovingForwardStartsPowerUp) {
    EXPECT_TRUE(track_power_up(MOVEMENT_STATUS_FORWARD, kDust));
    EXPECT_EQ(4, get_remaining_power_up_ticks()) << "5 ticks, the first one already used";
}

// C3: "for a while" is 5 ticks. A power-up starting on tick t runs on t..t+4.
TEST_F(PowerUpTimerTest, PowerUpLastsFiveTicks) {
    EXPECT_TRUE(track_power_up(MOVEMENT_STATUS_FORWARD, kDust));
    ExpectTicks(4, MOVEMENT_STATUS_FORWARD, kNoDust, true);
    EXPECT_FALSE(track_power_up(MOVEMENT_STATUS_FORWARD, kNoDust));
    EXPECT_EQ(0, get_remaining_power_up_ticks());
}

TEST_F(PowerUpTimerTest, StaysOffAfterThePowerUpEnded) {
    EXPECT_TRUE(track_power_up(MOVEMENT_STATUS_FORWARD, kDust));
    ExpectTicks(4, MOVEMENT_STATUS_FORWARD, kNoDust, true);
    ExpectTicks(10, MOVEMENT_STATUS_FORWARD, kNoDust, false);
}

// B5: dust found after a power-up has ended starts a new one.
TEST_F(PowerUpTimerTest, NewDustAfterThePowerUpEndedStartsAnotherFiveTicks) {
    EXPECT_TRUE(track_power_up(MOVEMENT_STATUS_FORWARD, kDust));
    ExpectTicks(4, MOVEMENT_STATUS_FORWARD, kNoDust, true);
    EXPECT_FALSE(track_power_up(MOVEMENT_STATUS_FORWARD, kNoDust));

    EXPECT_TRUE(track_power_up(MOVEMENT_STATUS_FORWARD, kDust));
    ExpectTicks(4, MOVEMENT_STATUS_FORWARD, kNoDust, true);
    EXPECT_FALSE(track_power_up(MOVEMENT_STATUS_FORWARD, kNoDust));
}

// Process Specification 4.1: a power-up starts only while moving forward.
TEST_F(PowerUpTimerTest, DustWhileAvoidingDoesNotStartPowerUp) {
    ExpectTicks(3, MOVEMENT_STATUS_AVOIDING, kDust, false);
    EXPECT_EQ(0, get_remaining_power_up_ticks());
}

// Process Specification 4.1: dust is not remembered from an avoiding tick.
TEST_F(PowerUpTimerTest, DustSeenOnlyWhileAvoidingIsNotRemembered) {
    EXPECT_FALSE(track_power_up(MOVEMENT_STATUS_AVOIDING, kDust));
    EXPECT_FALSE(track_power_up(MOVEMENT_STATUS_FORWARD, kNoDust));
}

// B3: no powered-up cleaning is reported while avoiding, even with a count left.
TEST_F(PowerUpTimerTest, PowerUpIsNotActiveWhileAvoiding) {
    EXPECT_TRUE(track_power_up(MOVEMENT_STATUS_FORWARD, kDust));
    EXPECT_FALSE(track_power_up(MOVEMENT_STATUS_AVOIDING, kNoDust));
}

TEST_F(PowerUpTimerTest, ResetEndsARunningPowerUp) {
    EXPECT_TRUE(track_power_up(MOVEMENT_STATUS_FORWARD, kDust));
    reset_power_up_timer();
    EXPECT_EQ(0, get_remaining_power_up_ticks());
    EXPECT_FALSE(track_power_up(MOVEMENT_STATUS_FORWARD, kNoDust));
}

// ---- Provisional: open questions --------------------------------------------
// Q4 and Q5 are undecided. These tests record the behavior of the pseudocode
// in Process Specification 4.1 as written. They are not requirements.

// Q4: dust detected again during a running power-up does not restart the count.
TEST_F(PowerUpTimerTest, Provisional_Q4_DustDuringARunningPowerUpDoesNotRestartIt) {
    EXPECT_TRUE(track_power_up(MOVEMENT_STATUS_FORWARD, kDust));    // tick 1
    EXPECT_TRUE(track_power_up(MOVEMENT_STATUS_FORWARD, kNoDust));  // tick 2
    EXPECT_TRUE(track_power_up(MOVEMENT_STATUS_FORWARD, kDust));    // tick 3: dust again
    EXPECT_EQ(2, get_remaining_power_up_ticks()) << "count continues, not reset to 5";
    EXPECT_TRUE(track_power_up(MOVEMENT_STATUS_FORWARD, kNoDust));  // tick 4
    EXPECT_TRUE(track_power_up(MOVEMENT_STATUS_FORWARD, kNoDust));  // tick 5
    EXPECT_FALSE(track_power_up(MOVEMENT_STATUS_FORWARD, kNoDust)); // tick 6
}

// Q5: the remaining count is kept while avoiding and continues afterwards.
TEST_F(PowerUpTimerTest, Provisional_Q5_RemainingCountIsKeptWhileAvoiding) {
    EXPECT_TRUE(track_power_up(MOVEMENT_STATUS_FORWARD, kDust));
    EXPECT_TRUE(track_power_up(MOVEMENT_STATUS_FORWARD, kNoDust));
    ASSERT_EQ(3, get_remaining_power_up_ticks());

    ExpectTicks(7, MOVEMENT_STATUS_AVOIDING, kNoDust, false);
    EXPECT_EQ(3, get_remaining_power_up_ticks());

    ExpectTicks(3, MOVEMENT_STATUS_FORWARD, kNoDust, true);
    EXPECT_FALSE(track_power_up(MOVEMENT_STATUS_FORWARD, kNoDust));
}

}  // namespace
