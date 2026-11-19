// The simulated surroundings of the RVC: the 10x10 map, where the RVC is, what
// its sensors read, and what its outputs do to the map. This file contains no
// control decision; those come from the C controller.
//
// Works in the browser (window.RvcWorld) and in Node.js (require).
(function (root, factory) {
    if (typeof module === 'object' && module.exports) {
        module.exports = factory();
    } else {
        root.RvcWorld = factory();
    }
}(typeof self !== 'undefined' ? self : this, function () {
    'use strict';

    const SIZE = 10;
    const MAX_TICKS = 100;
    const TURN_TICKS = 5;                 // five Turn ticks make one 90-degree turn (C8)
    const HEADINGS = ['N', 'E', 'S', 'W'];
    const DX = { N: 0, E: 1, S: 0, W: -1 };
    const DY = { N: -1, E: 0, S: 1, W: 0 };

    const key = (x, y) => x + ',' + y;
    const inside = (x, y) => x >= 0 && x < SIZE && y >= 0 && y < SIZE;
    const rightOf = (heading) => HEADINGS[(HEADINGS.indexOf(heading) + 1) % 4];
    const leftOf = (heading) => HEADINGS[(HEADINGS.indexOf(heading) + 3) % 4];
    const backOf = (heading) => HEADINGS[(HEADINGS.indexOf(heading) + 2) % 4];

    // Returns a list of problems; empty when the configuration is valid.
    function validate(config) {
        const problems = [];
        const start = config.start || {};
        if (!Number.isInteger(start.x) || !Number.isInteger(start.y) || !inside(start.x, start.y)) {
            problems.push('The RVC start position must be inside the 10x10 grid.');
        }
        if (!HEADINGS.includes(config.heading)) {
            problems.push('The initial direction must be N, E, S, or W.');
        }
        const seen = new Set();
        (config.obstacles || []).forEach(([x, y]) => {
            if (!inside(x, y)) {
                problems.push(`Obstacle (${x},${y}) is outside the grid.`);
            }
            if (x === start.x && y === start.y) {
                problems.push(`Obstacle (${x},${y}) overlaps the RVC start position.`);
            }
            if (seen.has(key(x, y))) {
                problems.push(`Obstacle (${x},${y}) is listed twice.`);
            }
            seen.add(key(x, y));
        });
        (config.dust || []).forEach(([x, y]) => {
            if (!inside(x, y)) {
                problems.push(`Dust (${x},${y}) is outside the grid.`);
            }
            if (seen.has(key(x, y))) {
                problems.push(`Dust (${x},${y}) is on an obstacle.`);
            }
        });
        return problems;
    }

    function create(config) {
        return {
            x: config.start.x,
            y: config.start.y,
            heading: config.heading,
            turnProgress: 0,        // Turn ticks done in the turn in progress (0-4)
            turnDirection: null,    // 'Turn Right' or 'Turn Left' while turning
            obstacles: new Set((config.obstacles || []).map(([x, y]) => key(x, y))),
            dust: new Set((config.dust || []).map(([x, y]) => key(x, y))),
            cleaned: new Set(),     // cells the RVC was on with the cleaner running
        };
    }

    // A cell blocks the RVC when it holds an obstacle or lies outside the grid.
    function blocked(world, x, y) {
        return !inside(x, y) || world.obstacles.has(key(x, y));
    }

    // Sensors read the adjacent cell in front, to the left, and to the right,
    // and the dust on the cell the RVC is on.
    function sense(world) {
        const at = (heading) => blocked(world, world.x + DX[heading], world.y + DY[heading]);
        return {
            front: at(world.heading),
            left: at(leftOf(world.heading)),
            right: at(rightOf(world.heading)),
            dust: world.dust.has(key(world.x, world.y)),
        };
    }

    // Applies the outputs of one Tick to the map. Returns what happened.
    function apply(world, direction, clean) {
        const events = [];

        // Cleaning acts on the cell the RVC is on when the command is issued.
        if (clean === 'Start' || clean === 'Power Up') {
            world.cleaned.add(key(world.x, world.y));
        }
        if (clean === 'Power Up' && world.dust.has(key(world.x, world.y))) {
            world.dust.delete(key(world.x, world.y));
            events.push(`dust removed at (${world.x},${world.y})`);
        }

        if (direction === 'Turn Right' || direction === 'Turn Left') {
            if (world.turnDirection !== direction) {
                world.turnDirection = direction;
                world.turnProgress = 0;
            }
            world.turnProgress += 1;
            if (world.turnProgress === TURN_TICKS) {
                world.heading = direction === 'Turn Right' ? rightOf(world.heading) : leftOf(world.heading);
                world.turnProgress = 0;
                world.turnDirection = null;
                events.push('turn completed, now heading ' + world.heading);
            }
        } else {
            world.turnProgress = 0;
            world.turnDirection = null;
            if (direction === 'Forward' || direction === 'Backward') {
                const way = direction === 'Forward' ? world.heading : backOf(world.heading);
                const nx = world.x + DX[way];
                const ny = world.y + DY[way];
                if (blocked(world, nx, ny)) {
                    events.push(`${direction.toLowerCase()} move blocked at (${world.x},${world.y})`);
                } else {
                    world.x = nx;
                    world.y = ny;
                }
            }
        }
        return events;
    }

    // A copy of the world for the history, with plain arrays.
    function snapshot(world) {
        return {
            x: world.x,
            y: world.y,
            heading: world.heading,
            turnProgress: world.turnProgress,
            turnDirection: world.turnDirection,
            dust: Array.from(world.dust),
            cleaned: Array.from(world.cleaned),
        };
    }

    return { SIZE, MAX_TICKS, TURN_TICKS, HEADINGS, key, inside, validate, create, blocked, sense, apply, snapshot };
}));
