// Obstacle Situation values used by the tests.
#ifndef SITUATIONS_H
#define SITUATIONS_H

#include <ostream>

#include "rvc_types.h"

inline ObstacleSituation Situation(bool front_blocked, SideSituation side_situation) {
    ObstacleSituation situation;
    situation.front_blocked = front_blocked;
    situation.side_situation = side_situation;
    return situation;
}

inline bool operator==(const ObstacleSituation& a, const ObstacleSituation& b) {
    return a.front_blocked == b.front_blocked && a.side_situation == b.side_situation;
}

inline std::ostream& operator<<(std::ostream& os, const ObstacleSituation& s) {
    static const char* const sides[] = {"right open", "left open", "both blocked"};
    return os << (s.front_blocked ? "front blocked, " : "front clear, ") << sides[s.side_situation];
}

// Front clear, sides open.
const ObstacleSituation kClear = Situation(false, SIDE_SITUATION_RIGHT_OPEN);
// Front blocked.
const ObstacleSituation kRightOpen = Situation(true, SIDE_SITUATION_RIGHT_OPEN);
const ObstacleSituation kLeftOpen = Situation(true, SIDE_SITUATION_LEFT_OPEN);
const ObstacleSituation kAllBlocked = Situation(true, SIDE_SITUATION_BOTH_BLOCKED);
// Front clear, as seen after moving backward away from an obstacle.
const ObstacleSituation kFrontClearLeftOpen = Situation(false, SIDE_SITUATION_LEFT_OPEN);
const ObstacleSituation kFrontClearSidesBlocked = Situation(false, SIDE_SITUATION_BOTH_BLOCKED);

#endif  // SITUATIONS_H
