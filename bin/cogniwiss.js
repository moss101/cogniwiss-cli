#!/usr/bin/env node

/**
 * Cogniwiss CLI Launcher
 * 
 * This is a thin Node.js launcher that executes the platform-specific
 * native binary. No business logic resides here.
 * 
 * Zero npm dependencies - pure Node.js stdlib.
 */

'use strict';

const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');
const os = require('os');

/**
 * Detect the platform and architecture to select the correct binary.
 * @returns {{ platform: string, arch: string, binaryName: string }}
 */
function detectPlatform() {
    const platform = os.platform();
    const arch = os.arch();

    let platformKey;
    let archKey;

    // Map Node.js platform to our binary naming convention
    switch (platform) {
        case 'darwin':
            platformKey = 'darwin';
            break;
        case 'linux':
            platformKey = 'linux';
            break;
        case 'win32':
            platformKey = 'win';
            break;
        default:
            console.error(`Unsupported platform: ${platform}`);
            process.exit(1);
    }

    // Map Node.js arch to our binary naming convention
    switch (arch) {
        case 'arm64':
            archKey = 'arm64';
            break;
        case 'x64':
            archKey = 'x64';
            break;
        default:
            console.error(`Unsupported architecture: ${arch}`);
            process.exit(1);
    }

    // Linux only supports x64 for now
    if (platformKey === 'linux' && archKey !== 'x64') {
        console.error(`Unsupported architecture for Linux: ${arch}. Only x64 is supported.`);
        process.exit(1);
    }

    const extension = platformKey === 'win' ? '.exe' : '';
    const binaryName = `cogniwiss-${platformKey}-${archKey}${extension}`;

    return { platform: platformKey, arch: archKey, binaryName };
}

/**
 * Find the native binary path.
 * @param {string} binaryName 
 * @returns {string}
 */
function findBinary(binaryName) {
    // Binary is located in ../native/ relative to this script
    const nativeDir = path.join(__dirname, '..', 'native');
    const binaryPath = path.join(nativeDir, binaryName);

    if (!fs.existsSync(binaryPath)) {
        console.error(`Binary not found: ${binaryPath}`);
        console.error(`\nThis may indicate an incomplete installation. Try reinstalling:`);
        console.error(`  npm uninstall -g cogniwiss && npm install -g cogniwiss`);
        process.exit(1);
    }

    return binaryPath;
}

/**
 * Execute the native binary with forwarded arguments.
 * @param {string} binaryPath 
 * @param {string[]} args 
 */
function executeBinary(binaryPath, args) {
    // Ensure binary is executable on Unix-like systems
    if (process.platform !== 'win32') {
        try {
            fs.chmodSync(binaryPath, 0o755);
        } catch (err) {
            // Ignore chmod errors - binary might already be executable
        }
    }

    const child = spawn(binaryPath, args, {
        stdio: 'inherit',
        windowsHide: false
    });

    child.on('error', (err) => {
        console.error(`Failed to execute binary: ${err.message}`);
        process.exit(1);
    });

    child.on('close', (code) => {
        process.exit(code ?? 0);
    });
}

// Main execution
const { binaryName } = detectPlatform();
const binaryPath = findBinary(binaryName);
const args = process.argv.slice(2);

executeBinary(binaryPath, args);
