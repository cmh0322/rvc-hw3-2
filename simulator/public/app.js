// Web page of the RVC simulator: map editing, simulation controls, state
// inspection, history, and human evaluation. It makes no control decision.
(function () {
    'use strict';

    const World = window.RvcWorld;
    const Scenarios = window.RvcScenarios;
    const $ = (id) => document.getElementById(id);
    const CUSTOM_KEY = 'rvc.customScenarios';
    const EVAL_KEY = 'rvc.evaluations';
    const ANGLE = { N: 0, E: 90, S: 180, W: 270 };

    const load = (name, fallback) => {
        try {
            return JSON.parse(localStorage.getItem(name)) || fallback;
        } catch (err) {
            return fallback;
        }
    };
    const store = (name, value) => localStorage.setItem(name, JSON.stringify(value));

    let customScenarios = load(CUSTOM_KEY, []);
    let evaluations = load(EVAL_KEY, {});
    let scenario = null;      // the selected scenario (predefined or custom)
    let config = null;        // the map being run or edited
    let world = null;         // the live map
    let history = [];         // one snapshot per tick, starting with tick 0
    let viewIndex = 0;        // the tick shown
    let timer = null;
    let busy = false;

    const allScenarios = () => Scenarios.SCENARIOS.concat(customScenarios);
    const copyConfig = (source) => ({
        start: { x: source.start.x, y: source.start.y },
        heading: source.heading,
        obstacles: source.obstacles.map((c) => [c[0], c[1]]),
        dust: source.dust.map((c) => [c[0], c[1]]),
    });
    const showMessage = (text) => { $('message').textContent = text || ''; };

    async function api(name, body) {
        const response = await fetch('/api/' + name, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body || {}),
        });
        const data = await response.json();
        if (!response.ok) {
            throw new Error(data.error || 'Request failed');
        }
        return data;
    }

    // ---- simulation -------------------------------------------------------

    // Reset: fresh C controller, initial map, tick 0.
    async function reset() {
        pause();
        const problems = World.validate(config);
        if (problems.length > 0) {
            showMessage('Invalid map: ' + problems.join(' '));
            return false;
        }
        showMessage('');
        world = World.create(config);
        const powerOn = await api('reset', World.sense(world));
        history = [Object.assign({}, powerOn, { events: [], world: World.snapshot(world) })];
        viewIndex = 0;
        render();
        return true;
    }

    // One Tick: sensors from the map, one controller update, effects on the map.
    async function executeTick() {
        if (history.length - 1 >= World.MAX_TICKS) {
            pause();
            showMessage('Tick limit reached: a scenario runs for at most 100 ticks.');
            return false;
        }
        const sensors = World.sense(world);
        const result = await api('step', sensors);
        const events = World.apply(world, result.direction, result.clean);
        history.push(Object.assign({}, result, { events, world: World.snapshot(world) }));
        viewIndex = history.length - 1;
        render();
        return true;
    }

    async function guarded(action) {
        if (busy) {
            return;
        }
        busy = true;
        try {
            await action();
        } catch (err) {
            pause();
            showMessage(err.message);
        } finally {
            busy = false;
        }
    }

    function stepForward() {
        return guarded(async () => {
            if (history.length === 0 && !(await reset())) {
                return;
            }
            if (viewIndex < history.length - 1) {
                viewIndex += 1;        // inspect a saved tick
                render();
            } else {
                await executeTick();
            }
        });
    }

    function stepBack() {
        pause();
        if (viewIndex > 0) {
            viewIndex -= 1;            // saved snapshot only; the controller is not reversed
            render();
        }
    }

    function start() {
        if (timer) {
            return;
        }
        viewIndex = Math.max(0, history.length - 1);
        const interval = () => 1000 / Number($('speed').value);
        const run = () => guarded(async () => {
            const more = await executeTick();
            timer = more && timer ? setTimeout(run, interval()) : null;
        });
        timer = setTimeout(run, 0);
    }

    function pause() {
        if (timer) {
            clearTimeout(timer);
            timer = null;
        }
    }

    // ---- rendering --------------------------------------------------------

    function renderGrid() {
        const grid = $('grid');
        const snap = history[viewIndex];
        const view = snap ? snap.world : { x: config.start.x, y: config.start.y, heading: config.heading, turnProgress: 0, dust: config.dust.map((c) => World.key(c[0], c[1])), cleaned: [] };
        const obstacles = new Set(config.obstacles.map((c) => World.key(c[0], c[1])));
        const dust = new Set(view.dust);
        const cleaned = new Set(view.cleaned);
        grid.innerHTML = '';
        grid.classList.toggle('editing', $('edit-mode').checked);
        grid.appendChild(axis(''));
        for (let x = 0; x < World.SIZE; x++) {
            grid.appendChild(axis(x));
        }
        for (let y = 0; y < World.SIZE; y++) {
            grid.appendChild(axis(y));
            for (let x = 0; x < World.SIZE; x++) {
                const cell = document.createElement('div');
                const k = World.key(x, y);
                cell.className = 'cell';
                cell.dataset.x = x;
                cell.dataset.y = y;
                cell.title = `(${x},${y})`;
                if (obstacles.has(k)) cell.classList.add('obstacle');
                if (dust.has(k)) cell.classList.add('dust');
                if (cleaned.has(k)) cell.classList.add('cleaned');
                if (x === config.start.x && y === config.start.y) cell.classList.add('start');
                if (x === view.x && y === view.y) {
                    cell.classList.add('rvc');
                    const marker = document.createElement('div');
                    const partial = view.turnProgress * (90 / World.TURN_TICKS) * (view.turnDirection === 'Turn Left' ? -1 : 1);
                    marker.className = 'marker';
                    marker.style.transform = `rotate(${ANGLE[view.heading] + partial}deg)`;
                    cell.appendChild(marker);
                }
                grid.appendChild(cell);
            }
        }
    }

    function axis(text) {
        const el = document.createElement('div');
        el.className = 'axis';
        el.textContent = text;
        return el;
    }

    const yesNo = (v) => (v ? 'detected' : 'none');
    const timerText = (v) => (v === -1 ? 'Idle' : String(v));

    // The values shown for one snapshot, in display order.
    function describe(snap) {
        if (!snap) {
            return null;
        }
        const first = snap.tick === 0;
        const turning = snap.world.turnProgress > 0 ? ` (${snap.world.turnDirection} ${snap.world.turnProgress}/5)` : '';
        return [
            ['Tick', snap.tick],
            ['Position X', snap.world.x],
            ['Position Y', snap.world.y],
            ['Direction (heading)', snap.world.heading + turning],
            ['Previous state', first ? '—' : snap.previous_state],
            ['Current state', snap.state],
            ['Transition', first ? 'Power On' : (snap.previous_state === snap.state ? 'stays in ' + snap.state : snap.previous_state + ' → ' + snap.state)],
            ['Front sensor', yesNo(snap.sensors.front)],
            ['Left sensor', yesNo(snap.sensors.left)],
            ['Right sensor', yesNo(snap.sensors.right)],
            ['Dust sensor', yesNo(snap.sensors.dust)],
            ['Motor output (Direction)', snap.direction],
            ['Cleaner output (Clean)', snap.clean === null ? 'not issued yet' : snap.clean],
            ['Step timer (ticks elapsed)', timerText(snap.step_ticks_elapsed)],
            ['Power-up ticks remaining', snap.remaining_power_up_ticks],
            ['Map events', snap.events.length ? snap.events.join('; ') : '—'],
        ];
    }

    function renderInspector() {
        const body = $('inspector').tBodies[0];
        const now = describe(history[viewIndex]);
        const before = describe(history[viewIndex - 1]);
        body.innerHTML = '<tr><th></th><td class="before">Before</td><td class="now"><strong>This tick</strong></td></tr>';
        (now || []).forEach((row, i) => {
            const tr = body.insertRow();
            const was = before ? String(before[i][1]) : '';
            if (before && i > 0 && was !== String(row[1])) {
                tr.className = 'changed';
            }
            tr.innerHTML = '<th></th><td class="before"></td><td class="now"></td>';
            tr.cells[0].textContent = row[0];
            tr.cells[1].textContent = was;
            tr.cells[2].textContent = row[1];
        });
    }

    function renderHistory() {
        const body = $('history').tBodies[0];
        body.innerHTML = '';
        history.forEach((snap, index) => {
            const tr = body.insertRow();
            const first = snap.tick === 0;
            const flag = (v) => (first ? '—' : (v ? '1' : '0'));
            const cells = [
                snap.tick, `(${snap.world.x},${snap.world.y})`, snap.world.heading,
                flag(snap.sensors.front), flag(snap.sensors.left), flag(snap.sensors.right), flag(snap.sensors.dust),
                first ? 'Power On → ' + snap.state : snap.previous_state + ' → ' + snap.state,
                snap.direction, snap.clean === null ? '—' : snap.clean,
                timerText(snap.step_ticks_elapsed), snap.remaining_power_up_ticks, snap.events.join('; '),
            ];
            cells.forEach((value, i) => {
                const td = tr.insertCell();
                td.textContent = value;
                if (i >= 3 && i <= 6 && value === '1') td.className = 'on';
            });
            if (index === viewIndex) {
                tr.className = 'current';
            }
            tr.addEventListener('click', () => { pause(); viewIndex = index; render(); });
        });
        // Keep the shown tick visible inside the history box without moving the page.
        const current = body.querySelector('tr.current');
        const box = $('history-scroll');
        if (current) {
            const top = current.offsetTop - 30;
            const bottom = current.offsetTop + current.offsetHeight;
            if (top < box.scrollTop) {
                box.scrollTop = top;
            } else if (bottom > box.scrollTop + box.clientHeight) {
                box.scrollTop = bottom - box.clientHeight;
            }
        }
    }

    function render() {
        const last = Math.max(0, history.length - 1);
        $('tick').textContent = history[viewIndex] ? history[viewIndex].tick : 0;
        $('tick-slider').max = last;
        $('tick-slider').value = viewIndex;
        $('viewing-note').textContent = viewIndex < last ? `inspecting a saved tick; the simulation is at tick ${last}` : '';
        $('speed-label').textContent = $('speed').value + ' ticks/s';
        renderGrid();
        renderInspector();
        renderHistory();
    }

    // ---- scenarios and evaluation ----------------------------------------

    function fillScenarioList() {
        const select = $('scenario-select');
        const selected = scenario ? scenario.id : null;
        select.innerHTML = '';
        allScenarios().forEach((s) => {
            const option = document.createElement('option');
            const verdict = evaluations[s.id] ? evaluations[s.id].result : 'Pending';
            option.value = s.id;
            option.textContent = `${s.id} ${s.name} [${verdict}]`;
            select.appendChild(option);
        });
        if (selected) {
            select.value = selected;
        }
    }

    function showScenario() {
        const list = $('scenario-functions');
        list.innerHTML = '';
        (scenario.functions || []).forEach((f) => {
            const li = document.createElement('li');
            li.textContent = `${f}: ${Scenarios.FUNCTIONS[f].name}`;
            list.appendChild(li);
        });
        const custom = !scenario.functions;
        $('scenario-requirements').textContent = custom ? 'Custom map: choose what to check.' : Scenarios.requirementsOf(scenario).join(', ');
        $('scenario-expected').textContent = scenario.expected || 'Custom map: no predefined expectation. Judge the behavior against the requirements.';
        const saved = evaluations[scenario.id] || {};
        document.querySelectorAll('input[name=verdict]').forEach((radio) => { radio.checked = radio.value === saved.result; });
        $('evaluator').value = saved.evaluator || '';
        $('related-ticks').value = saved.related_ticks || '';
        $('observations').value = saved.observations || '';
        const badge = $('scenario-status');
        badge.textContent = saved.result || 'Pending';
        badge.className = 'badge ' + (saved.result || '');
    }

    async function selectScenario(id) {
        scenario = allScenarios().find((s) => s.id === id) || Scenarios.SCENARIOS[0];
        config = copyConfig(scenario);
        $('heading').value = config.heading;
        showScenario();
        await guarded(reset);
    }

    async function saveEvaluation() {
        const checked = document.querySelector('input[name=verdict]:checked');
        if (!checked) {
            showMessage('Choose PASS, FAIL, or INCONCLUSIVE first.');
            return;
        }
        const record = {
            scenario_id: scenario.id,
            scenario_name: scenario.name,
            result: checked.value,
            evaluator: $('evaluator').value,
            related_ticks: $('related-ticks').value,
            observations: $('observations').value,
            evaluated_at: new Date().toISOString(),
            ticks_executed: Math.max(0, history.length - 1),
        };
        evaluations[scenario.id] = record;
        store(EVAL_KEY, evaluations);
        fillScenarioList();
        showScenario();
        try {
            const saved = await api('save-result', Object.assign({}, record, { configuration: config, history }));
            showMessage('Saved: ' + saved.saved);
        } catch (err) {
            showMessage('Saved in this browser only. ' + err.message);
        }
    }

    function download(name, value) {
        const link = document.createElement('a');
        link.href = URL.createObjectURL(new Blob([JSON.stringify(value, null, 2)], { type: 'application/json' }));
        link.download = name;
        link.click();
        URL.revokeObjectURL(link.href);
    }

    // ---- map editing ------------------------------------------------------

    function toggleCell(list, x, y) {
        const index = list.findIndex((c) => c[0] === x && c[1] === y);
        if (index >= 0) {
            list.splice(index, 1);
        } else {
            list.push([x, y]);
        }
    }

    function editCell(x, y) {
        if (!$('edit-mode').checked) {
            return;
        }
        if (history.length > 1) {
            showMessage('Reset to tick 0 before editing the map.');
            return;
        }
        const tool = document.querySelector('input[name=tool]:checked').value;
        const isStart = x === config.start.x && y === config.start.y;
        const hasObstacle = config.obstacles.some((c) => c[0] === x && c[1] === y);
        const hasDust = config.dust.some((c) => c[0] === x && c[1] === y);
        if (tool === 'obstacle') {
            if (isStart) { showMessage('An obstacle cannot be placed on the RVC start position.'); return; }
            if (hasDust) { showMessage('Remove the dust first: an obstacle and dust cannot share a cell.'); return; }
            toggleCell(config.obstacles, x, y);
        } else if (tool === 'dust') {
            if (hasObstacle) { showMessage('Dust cannot be placed on an obstacle.'); return; }
            toggleCell(config.dust, x, y);
        } else {
            if (hasObstacle) { showMessage('The RVC cannot start on an obstacle.'); return; }
            config.start = { x, y };
        }
        guarded(reset);
    }

    function saveCustom() {
        const problems = World.validate(config);
        if (problems.length > 0) {
            showMessage('Invalid map: ' + problems.join(' '));
            return;
        }
        const name = prompt('Name of the new scenario:', 'Custom map');
        if (!name) {
            return;
        }
        const number = customScenarios.reduce((max, s) => Math.max(max, Number(s.id.slice(3)) || 0), 0) + 1;
        const created = Object.assign({ id: 'CU-' + String(number).padStart(2, '0'), name }, copyConfig(config));
        customScenarios.push(created);
        store(CUSTOM_KEY, customScenarios);
        scenario = created;
        fillScenarioList();
        showScenario();
        showMessage(`Saved as ${created.id}.`);
    }

    function importMap(file) {
        const reader = new FileReader();
        reader.onload = () => {
            try {
                const data = JSON.parse(reader.result);
                const candidate = { start: data.start, heading: data.heading, obstacles: data.obstacles || [], dust: data.dust || [] };
                const problems = World.validate(candidate);
                if (problems.length > 0) {
                    showMessage('The file was not loaded. ' + problems.join(' '));
                    return;
                }
                config = copyConfig(candidate);
                $('heading').value = config.heading;
                guarded(reset);
            } catch (err) {
                showMessage('The file is not a valid map: ' + err.message);
            }
        };
        reader.readAsText(file);
    }

    // ---- wiring -----------------------------------------------------------

    $('start').addEventListener('click', start);
    $('pause').addEventListener('click', pause);
    $('step').addEventListener('click', () => { pause(); stepForward(); });
    $('step-back').addEventListener('click', stepBack);
    $('reset').addEventListener('click', () => guarded(reset));
    $('restart').addEventListener('click', () => guarded(async () => { if (await reset()) { start(); } }));
    $('speed').addEventListener('input', render);
    $('tick-slider').addEventListener('input', (e) => { pause(); viewIndex = Number(e.target.value); render(); });
    $('scenario-select').addEventListener('change', (e) => selectScenario(e.target.value));
    $('save-evaluation').addEventListener('click', saveEvaluation);
    $('export-evaluations').addEventListener('click', () => download('rvc_evaluations.json', evaluations));
    $('export-trace').addEventListener('click', () => download(`${scenario.id}_trace.json`, { scenario_id: scenario.id, configuration: config, history }));
    $('edit-mode').addEventListener('change', render);
    $('grid').addEventListener('click', (e) => {
        const cell = e.target.closest('.cell');
        if (cell) {
            editCell(Number(cell.dataset.x), Number(cell.dataset.y));
        }
    });
    $('heading').addEventListener('change', (e) => {
        if (history.length > 1) {
            showMessage('Reset to tick 0 before changing the initial direction.');
            e.target.value = config.heading;
            return;
        }
        config.heading = e.target.value;
        guarded(reset);
    });
    $('clear-map').addEventListener('click', () => { config.obstacles = []; config.dust = []; guarded(reset); });
    $('reload-map').addEventListener('click', () => selectScenario(scenario.id));
    $('save-custom').addEventListener('click', saveCustom);
    $('export-map').addEventListener('click', () => download('rvc_map.json', config));
    $('import-map').addEventListener('change', (e) => { if (e.target.files[0]) { importMap(e.target.files[0]); } e.target.value = ''; });

    fillScenarioList();
    selectScenario(Scenarios.SCENARIOS[0].id);
}());
