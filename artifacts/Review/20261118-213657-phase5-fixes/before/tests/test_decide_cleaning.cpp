// Module: Decide Cleaning (SA Process 4.2)
// Source: Process Specification 4.2; requirements B1, B2, B3, B5.
#include <gtest/gtest.h>

#include "decide_cleaning.h"

namespace {

// B1, B2: the RVC cleans while it goes forward.
TEST(DecideCleaning, ForwardWithoutPowerUpStartsCleaning) {
    EXPECT_EQ(CLEAN_START, decide_cleaning(MOVEMENT_STATUS_FORWARD, false));
}

// B5: detected dust powers up the cleaning.
TEST(DecideCleaning, ForwardWithPowerUpPowersUp) {
    EXPECT_EQ(CLEAN_POWER_UP, decide_cleaning(MOVEMENT_STATUS_FORWARD, true));
}

// B3: the RVC stops cleaning while it avoids an obstacle.
TEST(DecideCleaning, AvoidingStopsCleaning) {
    EXPECT_EQ(CLEAN_STOP, decide_cleaning(MOVEMENT_STATUS_AVOIDING, false));
}

// B3 has priority over B5: no powered-up cleaning while avoiding.
TEST(DecideCleaning, AvoidingStopsCleaningEvenWithPowerUp) {
    EXPECT_EQ(CLEAN_STOP, decide_cleaning(MOVEMENT_STATUS_AVOIDING, true));
}

}  // namespace
