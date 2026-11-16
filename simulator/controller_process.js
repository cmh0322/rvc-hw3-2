// Runs the C controller (rvc_sim_host) as a child process and exchanges one
// line per Tick with it. Used by the web server and by the scenario runner.
'use strict';

const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

function findHost() {
    const candidates = [
        process.env.RVC_SIM_HOST,
        path.join(__dirname, '..', 'build', 'rvc_sim_host.exe'),
        path.join(__dirname, '..', 'build', 'rvc_sim_host'),
    ].filter(Boolean);
    const found = candidates.find((file) => fs.existsSync(file));
    if (!found) {
        throw new Error(
            'rvc_sim_host was not found. Build it first: cmake --build build --target rvc_sim_host\n' +
            'Looked in: ' + candidates.join(', '));
    }
    return found;
}

class ControllerProcess {
    constructor() {
        this.child = null;
        this.buffer = '';
        this.lines = [];
        this.waiting = [];
        this.error = null;
    }

    // initialize / reset: starts a fresh C program and returns its power-on state.
    async start() {
        this.stop();
        this.buffer = '';
        this.lines = [];
        this.waiting = [];
        this.error = null;
        const child = spawn(findHost(), [], { stdio: ['pipe', 'pipe', 'pipe'] });
        this.child = child;
        child.stdout.setEncoding('utf8');
        child.stdout.on('data', (chunk) => this.onData(chunk));
        child.stderr.setEncoding('utf8');
        child.stderr.on('data', (chunk) => { this.error = (this.error || '') + chunk; });
        child.on('exit', () => {
            if (this.child === child) {
                this.fail(new Error('The C controller process ended. ' + (this.error || '')));
            }
        });
        child.on('error', (err) => this.fail(err));
        return this.nextLine();
    }

    // step: sends the sensor inputs of one Tick and returns the outputs and state.
    async step(sensors) {
        if (!this.child) {
            throw new Error('The controller is not running. Reset first.');
        }
        const bit = (value) => (value ? 1 : 0);
        this.child.stdin.write(
            `${bit(sensors.front)} ${bit(sensors.left)} ${bit(sensors.right)} ${bit(sensors.dust)}\n`);
        return this.nextLine();
    }

    stop() {
        if (this.child) {
            const child = this.child;
            this.child = null;
            child.stdin.end();
            child.kill();
        }
    }

    onData(chunk) {
        this.buffer += chunk;
        let end = this.buffer.indexOf('\n');
        while (end >= 0) {
            const line = this.buffer.slice(0, end).trim();
            this.buffer = this.buffer.slice(end + 1);
            if (line) {
                const waiter = this.waiting.shift();
                if (waiter) {
                    waiter.resolve(JSON.parse(line));
                } else {
                    this.lines.push(JSON.parse(line));
                }
            }
            end = this.buffer.indexOf('\n');
        }
    }

    nextLine() {
        if (this.lines.length > 0) {
            return Promise.resolve(this.lines.shift());
        }
        return new Promise((resolve, reject) => this.waiting.push({ resolve, reject }));
    }

    fail(err) {
        const waiting = this.waiting;
        this.waiting = [];
        waiting.forEach((waiter) => waiter.reject(err));
    }
}

module.exports = { ControllerProcess, findHost };
