// Web server of the RVC simulator. No dependencies beyond Node.js.
//
//   node simulator/server.js        then open http://localhost:8765
//
// It serves the pages in simulator/public and connects them to the C
// controller process:
//   POST /api/reset          initialize / reset: fresh controller, power-on state
//   POST /api/step           step(sensor_inputs): one Tick, returns outputs + state
//   POST /api/save-result    stores an evaluation with its trace under simulator/results
'use strict';

const http = require('http');
const fs = require('fs');
const path = require('path');
const { ControllerProcess } = require('./controller_process');

const PORT = Number(process.env.PORT) || 8765;
const PUBLIC_DIR = path.join(__dirname, 'public');
const RESULTS_DIR = path.join(__dirname, 'results');
const TYPES = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css', '.json': 'application/json' };

const controller = new ControllerProcess();

function readBody(req) {
    return new Promise((resolve, reject) => {
        let body = '';
        req.on('data', (chunk) => { body += chunk; });
        req.on('end', () => {
            try {
                resolve(body ? JSON.parse(body) : {});
            } catch (err) {
                reject(err);
            }
        });
        req.on('error', reject);
    });
}

function sendJson(res, status, value) {
    res.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8' });
    res.end(JSON.stringify(value));
}

function serveFile(req, res) {
    if (req.url === '/favicon.ico') {
        res.writeHead(204);
        res.end();
        return;
    }
    const name = req.url === '/' ? 'index.html' : decodeURIComponent(req.url.split('?')[0]).replace(/^\/+/, '');
    const file = path.normalize(path.join(PUBLIC_DIR, name));
    if (!file.startsWith(PUBLIC_DIR)) {
        res.writeHead(403);
        res.end();
        return;
    }
    fs.readFile(file, (err, data) => {
        if (err) {
            res.writeHead(404);
            res.end('Not found');
            return;
        }
        res.writeHead(200, { 'Content-Type': (TYPES[path.extname(file)] || 'application/octet-stream') + '; charset=utf-8' });
        res.end(data);
    });
}

async function handleApi(req, res) {
    const body = await readBody(req);
    if (req.url === '/api/reset') {
        sendJson(res, 200, await controller.start());
    } else if (req.url === '/api/step') {
        sendJson(res, 200, await controller.step(body));
    } else if (req.url === '/api/save-result') {
        fs.mkdirSync(RESULTS_DIR, { recursive: true });
        const id = String(body.scenario_id || 'custom').replace(/[^A-Za-z0-9_-]/g, '_');
        const stamp = new Date().toISOString().replace(/[:.]/g, '-');
        const file = path.join(RESULTS_DIR, `${id}_${stamp}.json`);
        fs.writeFileSync(file, JSON.stringify(body, null, 2));
        sendJson(res, 200, { saved: path.relative(path.join(__dirname, '..'), file).replace(/\\/g, '/') });
    } else {
        sendJson(res, 404, { error: 'Unknown API' });
    }
}

http.createServer((req, res) => {
    if (req.method === 'POST' && req.url.startsWith('/api/')) {
        handleApi(req, res).catch((err) => sendJson(res, 500, { error: String(err.message || err) }));
    } else if (req.method === 'GET') {
        serveFile(req, res);
    } else {
        res.writeHead(405);
        res.end();
    }
}).listen(PORT, '127.0.0.1', () => {
    console.log(`RVC simulator: http://localhost:${PORT}`);
});

process.on('exit', () => controller.stop());
process.on('SIGINT', () => process.exit(0));
