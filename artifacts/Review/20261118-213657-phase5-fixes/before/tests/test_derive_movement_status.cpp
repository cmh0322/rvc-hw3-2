// Module: Derive Movement Status (SA Process 3.2.3, Movement Status part)
// Source: Process Specification 3.2.3; requirements B2, B3, B4.
#include <gtest/gtest.h>

#include "derive_movement_status.h"

namespace {

// B2: the RVC is moving forward.
TEST(DeriveMovementStatus, ForwardCommandIsForward) {
    EXPECT_EQ(MOVEMENT_STATUS_FORWARD, derive_movement_status(MOVEMENT_COMMAND_FORWARD));
}

// B3, C2: stopping at an obstacle is part of avoiding.
TEST(DeriveMovementStatus, StopCommandIsAvoiding) {
    EXPECT_EQ(MOVEMENT_STATUS_AVOIDING, derive_movement_status(MOVEMENT_COMMAND_STOP));
}

// B3: turning aside is part of avoiding.
TEST(DeriveMovementStatus, TurnCommandsAreAvoiding) {
    EXPECT_EQ(MOVEMENT_STATUS_AVOIDING, derive_movement_status(MOVEMENT_COMMAND_TURN_RIGHT));
    EXPECT_EQ(MOVEMENT_STATUS_AVOIDING, derive_movement_status(MOVEMENT_COMMAND_TURN_LEFT));
}

// B4: moving backward is part of avoiding.
TEST(DeriveMovementStatus, BackwardCommandIsAvoiding) {
    EXPECT_EQ(MOVEMENT_STATUS_AVOIDING, derive_movement_status(MOVEMENT_COMMAND_BACKWARD));
}

}  // namespace
