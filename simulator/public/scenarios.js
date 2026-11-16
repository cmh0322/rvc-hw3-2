// System test scenarios. Coordinates are (x, y) with (0,0) at the top left,
// x to the right and y downward. Heading N points to smaller y.
//
// Works in the browser (window.RvcScenarios) and in Node.js (require).
(function (root, factory) {
    if (typeof module === 'object' && module.exports) {
        module.exports = factory();
    } else {
        root.RvcScenarios = factory();
    }
}(typeof self !== 'undefined' ? self : this, function () {
    'use strict';

    // Essential system functions, each with the requirements it comes from.
    const FUNCTIONS = {
        F1: { name: 'Go forward while cleaning', requirements: ['B1', 'B2'] },
        F2: { name: 'Stop moving and cleaning for 5 ticks at an obstacle', requirements: ['B3', 'C2', 'C7'] },
        F3: { name: 'Turn right for 5 ticks when the right is open', requirements: ['B3', 'C1', 'C8'] },
        F4: { name: 'Turn left for 5 ticks when only the left is open', requirements: ['B3', 'C8'] },
        F5: { name: 'Go forward with cleaning after turning aside', requirements: ['B3'] },
        F6: { name: 'Move backward for 5 ticks when front, left, and right are blocked', requirements: ['B4', 'C6'] },
        F7: { name: 'After moving backward, turn by left and right only', requirements: ['B4', 'C5', 'C9'] },
        F8: { name: 'Move backward again when left and right are still blocked', requirements: ['C5', 'C6', 'C9'] },
        F9: { name: 'Power up the cleaning for 5 ticks when dust is detected', requirements: ['B5', 'C3'] },
        F10: { name: 'Restart the 5 ticks when dust is detected during a power-up', requirements: ['C10'] },
        F11: { name: 'Continue an interrupted power-up after the avoidance', requirements: ['C11'] },
        F12: { name: 'Keep the cleaning stopped during the whole avoidance', requirements: ['B3'] },
        F13: { name: 'Ignore side obstacles while the front is clear', requirements: ['Q6 (assumption)'] },
    };

    const SA_ARTIFACTS = {
        F1: ['FSM T1', 'Process Specification 4.2'],
        F2: ['FSM T2, T3', 'Process Specification 4.2'],
        F3: ['FSM T4, T11', 'Process Specification 3.1'],
        F4: ['FSM T5, T13', 'Process Specification 3.1'],
        F5: ['FSM T12, T14', 'Process Specification 4.2'],
        F6: ['FSM T6, T7'],
        F7: ['FSM T9, T10', 'Process Specification 3.1'],
        F8: ['FSM T8'],
        F9: ['Process Specification 4.1, 4.2'],
        F10: ['Process Specification 4.1'],
        F11: ['Process Specification 4.1'],
        F12: ['Process Specification 3.2.3, 4.2'],
        F13: ['FSM T1', 'Process Specification 3.1'],
    };

    // Cells (x, y0) to (x, y1) of one column.
    function column(x, y0, y1) {
        const cells = [];
        for (let y = y0; y <= y1; y++) {
            cells.push([x, y]);
        }
        return cells;
    }

    const CENTER = { x: 4, y: 4 };

    const SCENARIOS = [
        {
            id: 'ST-01', name: 'Empty room',
            start: CENTER, heading: 'N', obstacles: [], dust: [],
            functions: ['F1', 'F2', 'F3', 'F5', 'F12'],
            expected: 'Goes forward with Clean Start for ticks 1-4 and reaches the top wall. Stops with Clean Stop for ticks 5-9. Both sides are open, so it turns right for ticks 10-14 and then goes forward with cleaning along the wall. It repeats stop, right turn, forward at every wall, travelling clockwise around the room.',
        },
        {
            id: 'ST-02', name: 'Obstacle ahead, both sides open',
            start: CENTER, heading: 'N', obstacles: [[4, 1]], dust: [],
            functions: ['F1', 'F2', 'F3', 'F5', 'F12'],
            expected: 'Goes forward for ticks 1-2 to (4,2). The obstacle at (4,1) is in front: stops with Clean Stop for ticks 3-7. Both sides are open, so it turns right for ticks 8-12 (C1) and goes forward east with cleaning from tick 13.',
        },
        {
            id: 'ST-03', name: 'Obstacle ahead, right blocked',
            start: CENTER, heading: 'N', obstacles: [[4, 1], [5, 2]], dust: [],
            functions: ['F1', 'F2', 'F4', 'F5', 'F12'],
            expected: 'Goes forward to (4,2) and stops for ticks 3-7. The right cell (5,2) is blocked and the left is open, so it turns left for ticks 8-12 and goes forward west with cleaning from tick 13.',
        },
        {
            id: 'ST-04', name: 'Obstacle ahead, left blocked',
            start: CENTER, heading: 'N', obstacles: [[4, 1], [3, 2]], dust: [],
            functions: ['F1', 'F2', 'F3', 'F5', 'F12'],
            expected: 'Goes forward to (4,2) and stops for ticks 3-7. The left cell (3,2) is blocked and the right is open, so it turns right for ticks 8-12 and goes forward east with cleaning from tick 13.',
        },
        {
            id: 'ST-05', name: 'Dead end in the open',
            start: CENTER, heading: 'N', obstacles: [[4, 1], [3, 2], [5, 2]], dust: [],
            functions: ['F2', 'F6', 'F7', 'F5', 'F12'],
            expected: 'Goes forward to (4,2), where front, left, and right are blocked. Stops for ticks 3-7, then moves backward for ticks 8-12 to (4,7). There both sides are open, so it turns right for ticks 13-17 and goes forward east with cleaning from tick 18. Clean is Stop from tick 3 to tick 17.',
        },
        {
            id: 'ST-06', name: 'Closed corridor',
            start: { x: 4, y: 6 }, heading: 'N', obstacles: column(3, 0, 9).concat(column(5, 0, 9)), dust: [],
            functions: ['F1', 'F2', 'F6', 'F8', 'F12'],
            expected: 'Goes forward to the top of the corridor (4,0) in ticks 1-6 and stops for ticks 7-11. All three sides are blocked: moves backward for ticks 12-16. The corridor walls still block left and right, so it moves backward again, 5 ticks at a time, for the rest of the run. Once it reaches the bottom wall it cannot move further. Clean stays Stop from tick 7. The requirements give no way out of a corridor closed on both sides.',
        },
        {
            id: 'ST-07', name: 'Corridor that opens to the left',
            start: CENTER, heading: 'N', obstacles: column(5, 0, 9).concat(column(3, 0, 3)), dust: [],
            functions: ['F2', 'F6', 'F7', 'F4', 'F5'],
            expected: 'Reaches (4,0) at tick 4 and stops for ticks 5-9 with front, left, and right blocked. Moves backward for ticks 10-14 to (4,5). There the right is still blocked and the left is open, so it turns left for ticks 15-19 (C5, C9) and goes forward west with cleaning from tick 20. The front sensor reads clear at tick 15 and is not used.',
        },
        {
            id: 'ST-08', name: 'Corridor that opens to the right',
            start: CENTER, heading: 'N', obstacles: column(3, 0, 9).concat(column(5, 0, 3)), dust: [],
            functions: ['F2', 'F6', 'F7', 'F3', 'F5'],
            expected: 'Reaches (4,0) at tick 4 and stops for ticks 5-9 with front, left, and right blocked. Moves backward for ticks 10-14 to (4,5). There the right is open, so it turns right for ticks 15-19 (C5, C9) and goes forward east with cleaning from tick 20.',
        },
        {
            id: 'ST-09', name: 'Backward twice, then turn',
            start: { x: 4, y: 3 }, heading: 'N', obstacles: column(3, 0, 8).concat(column(5, 0, 8)), dust: [],
            functions: ['F2', 'F6', 'F8', 'F7', 'F5'],
            expected: 'Reaches (4,0) at tick 3 and stops for ticks 4-8. Moves backward for ticks 9-13 to (4,5), where both sides are still blocked. Moves backward again for ticks 14-18 and ends at (4,9), below the corridor walls. Both sides are open there, so it turns right for ticks 19-23 and goes forward east with cleaning from tick 24.',
        },
        {
            id: 'ST-10', name: 'Dust on a straight path',
            start: { x: 4, y: 8 }, heading: 'N', obstacles: [], dust: [[4, 6]],
            functions: ['F1', 'F9', 'F2', 'F3'],
            expected: 'Goes forward with Clean Start for ticks 1-2 and is on the dust cell (4,6) at tick 3. Clean is Power Up for ticks 3-7 while it keeps going forward; the dust is removed. Clean is Start again at tick 8. It reaches the top wall, stops for ticks 9-13, and turns right.',
        },
        {
            id: 'ST-11', name: 'Second dust during a power-up',
            start: { x: 4, y: 8 }, heading: 'N', obstacles: [], dust: [[4, 6], [4, 4]],
            functions: ['F9', 'F10', 'F11', 'F2', 'F12'],
            expected: 'Clean is Power Up from tick 3 (dust at (4,6)). At tick 5 it is on the second dust cell (4,4) and the 5 ticks start again (C10), so Clean stays Power Up through tick 8. At tick 9 the top wall is in front: it stops and Clean is Stop, with 1 power-up tick left. After the stop (ticks 9-13) and the right turn (ticks 14-18) it goes forward with Clean Power Up at tick 19 (C11) and Clean Start from tick 20.',
        },
        {
            id: 'ST-12', name: 'Two separate power-ups',
            start: { x: 4, y: 9 }, heading: 'N', obstacles: [], dust: [[4, 9], [4, 2]],
            functions: ['F1', 'F9', 'F11', 'F2'],
            expected: 'The start cell has dust: Clean is Power Up for ticks 1-5, then Start for ticks 6-7. At tick 8 it is on the second dust cell (4,2): Clean is Power Up for ticks 8-9. At tick 10 the top wall is in front and it stops with Clean Stop, 3 power-up ticks left. After the stop and the right turn it goes forward with Clean Power Up for ticks 20-22 and Clean Start from tick 23.',
        },
        {
            id: 'ST-13', name: 'Power-up interrupted by an obstacle',
            start: { x: 4, y: 6 }, heading: 'N', obstacles: [[4, 2]], dust: [[4, 4]],
            functions: ['F9', 'F11', 'F2', 'F3', 'F12'],
            expected: 'At tick 3 it is on the dust cell (4,4): Clean is Power Up and it moves to (4,3). At tick 4 the obstacle is in front: it stops for ticks 4-8 with Clean Stop. It turns right for ticks 9-13 with Clean Stop. From tick 14 it goes forward east, with Clean Power Up for the 4 remaining ticks 14-17 (C11) and Clean Start from tick 18.',
        },
        {
            id: 'ST-14', name: 'Dust where the RVC stops',
            start: { x: 4, y: 6 }, heading: 'N', obstacles: [[4, 2]], dust: [[4, 3]],
            functions: ['F2', 'F12', 'F9', 'F3', 'F5'],
            expected: 'Reaches (4,3) at tick 3. At tick 4 the obstacle is in front and the cell has dust: it stops, and Clean is Stop, not Power Up (B3). Clean stays Stop during the stop (ticks 4-8) and the right turn (ticks 9-13); the dust stays. At tick 14 it goes forward and the dust is still under it: Clean is Power Up for ticks 14-18 and the dust is removed.',
        },
        {
            id: 'ST-15', name: 'Obstacles beside the path only',
            start: CENTER, heading: 'N', obstacles: [[3, 3], [5, 3], [3, 2], [5, 1]], dust: [],
            functions: ['F13', 'F1', 'F2', 'F3'],
            expected: 'Obstacles lie to the left and right of the path but never in front. It goes forward with Clean Start for ticks 1-4 without stopping (Q6 assumption) and reaches the top wall. It stops for ticks 5-9 and turns right for ticks 10-14.',
        },
        {
            id: 'ST-16', name: 'Heading east',
            start: CENTER, heading: 'E', obstacles: [[7, 4]], dust: [],
            functions: ['F1', 'F2', 'F3', 'F5'],
            expected: 'Goes forward east for ticks 1-2 to (6,4). Stops for ticks 3-7 in front of the obstacle at (7,4). Turns right for ticks 8-12, which is toward the south, and goes forward south with cleaning from tick 13.',
        },
        {
            id: 'ST-17', name: 'Heading south, right blocked',
            start: CENTER, heading: 'S', obstacles: [[4, 7], [3, 6]], dust: [],
            functions: ['F1', 'F2', 'F4', 'F5'],
            expected: 'Goes forward south for ticks 1-2 to (4,6). Stops for ticks 3-7 in front of (4,7). Its right side is the west cell (3,6), which is blocked; its left side (east) is open. Turns left for ticks 8-12 and goes forward east with cleaning from tick 13.',
        },
        {
            id: 'ST-18', name: 'Heading west into a dead end',
            start: { x: 3, y: 4 }, heading: 'W', obstacles: [[1, 4], [2, 3], [2, 5]], dust: [],
            functions: ['F2', 'F6', 'F7', 'F5', 'F12'],
            expected: 'Goes forward west to (2,4) at tick 1, where front, left, and right are blocked. Stops for ticks 2-6 and moves backward (east) for ticks 7-11 to (7,4). Both sides are open there: turns right for ticks 12-16, which is toward the north, and goes forward north with cleaning from tick 17.',
        },
        {
            id: 'ST-19', name: 'Start in a corner',
            start: { x: 0, y: 0 }, heading: 'N', obstacles: [], dust: [],
            functions: ['F2', 'F3', 'F5', 'F1', 'F12'],
            expected: 'The wall is in front at the first tick: it stops for ticks 1-5 without having moved. The left is the wall and the right is open: it turns right for ticks 6-10 and goes forward east with cleaning from tick 11. It then follows the walls clockwise.',
        },
        {
            id: 'ST-20', name: 'Obstacle and dust course',
            start: CENTER, heading: 'N', obstacles: [[4, 1]], dust: [[6, 2], [8, 2]],
            functions: ['F2', 'F3', 'F9', 'F10', 'F11', 'F12'],
            expected: 'Stops in front of (4,1) for ticks 3-7 and turns right for ticks 8-12. Going east, it is on the dust cell (6,2) at tick 15: Clean is Power Up. At tick 17 it is on the dust cell (8,2) and the 5 ticks start again. At tick 18 the right wall is in front: it stops with Clean Stop and 4 power-up ticks left. After the stop (ticks 18-22) and the right turn (ticks 23-27) it goes forward south with Clean Power Up for ticks 28-31 and Clean Start from tick 32.',
        },
        {
            id: 'ST-21', name: 'Enclosed on all four sides',
            start: CENTER, heading: 'N', obstacles: [[4, 3], [3, 4], [5, 4], [4, 5]], dust: [],
            functions: ['F2', 'F6', 'F8', 'F12'],
            expected: 'Front, left, and right are blocked at the first tick: it stops for ticks 1-5. It then issues Backward for ticks 6-10, but the cell behind is also blocked and it does not move. Left and right stay blocked, so it issues Backward again, 5 ticks at a time, for the rest of the run. Clean is Stop throughout. The RVC has no rear sensor, and the requirements give no behavior for an enclosed RVC.',
        },
    ];

    // Requirement IDs and SA artifacts of a scenario, from its functions.
    function requirementsOf(scenario) {
        const all = [];
        scenario.functions.forEach((f) => FUNCTIONS[f].requirements.forEach((r) => { if (!all.includes(r)) all.push(r); }));
        return all;
    }
    function artifactsOf(scenario) {
        const all = [];
        scenario.functions.forEach((f) => SA_ARTIFACTS[f].forEach((a) => { if (!all.includes(a)) all.push(a); }));
        return all;
    }

    return { FUNCTIONS, SA_ARTIFACTS, SCENARIOS, requirementsOf, artifactsOf };
}));
