#!/bin/bash
set -e

cd /app/qwen-gate

RAILWAY_PORT="${PORT:-8080}"
bun -e "
const fs = require('fs');
let raw = fs.readFileSync('config.json', 'utf8');
raw = raw.replace(/\/\/[^\n]*/g, '').replace(/\/\*[\s\S]*?\*\//g, '');
const cfg = JSON.parse(raw);
cfg.HOST = '0.0.0.0';
cfg.PORT = '$RAILWAY_PORT';
fs.writeFileSync('config.json', JSON.stringify(cfg, null, 2));
console.log('Patched HOST:', cfg.HOST, 'PORT:', cfg.PORT);
"

bun start
