'use strict';

const crypto = require('node:crypto');
const fs = require('node:fs');
const path = require('node:path');

const CANONICAL_SHA256 =
  '89d54b0cf5852c9212d80729c802a5371b41e8ce1499a32f8133382519c62b37';

const LICENSE_TEXT_URL =
  'https://raw.githubusercontent.com/Ali-A-Alwahed/LGPT/main/LICENSE.txt';
const REPO_URL = 'https://github.com/Ali-A-Alwahed/LGPT';
const COPYRIGHT_HOLDER = 'Ali A Alwahed';
const PROFILE_URL = 'https://github.com/Ali-A-Alwahed';
const ORG = 'Sonzaistudios';
const WEBSITE = 'https://sonzaistudios.org';
const VERSION = '1.0';

// --- Minimal GitHub Actions plumbing, no external dependencies -------------

function input(name, fallback = '') {
  const key = `INPUT_${name.replace(/ /g, '_').toUpperCase()}`;
  const value = process.env[key];
  return value === undefined || value === '' ? fallback : value;
}

function getBoolean(name, fallback) {
  const raw = input(name, String(fallback));
  return ['true', 'yes', '1', 'on'].includes(raw.trim().toLowerCase());
}

function setOutput(key, value) {
  const file = process.env.GITHUB_OUTPUT;
  if (file) {
    fs.appendFileSync(file, `${key}=${value}\n`);
    return;
  }
  process.stdout.write(`::set-output name=${key}::${value}\n`);
}

function info(msg) {
  process.stdout.write(`${msg}\n`);
}

function warn(msg) {
  process.stdout.write(`::warning::${msg}\n`);
}

function error(msg) {
  process.stdout.write(`::error::${msg}\n`);
}

function notice(msg) {
  process.stdout.write(`::notice::${msg}\n`);
}

function setFailed(msg) {
  error(msg);
  process.exitCode = 1;
}

function sha256(buffer) {
  return crypto.createHash('sha256').update(buffer).digest('hex');
}

function workspace() {
  return process.env.GITHUB_WORKSPACE || process.cwd();
}

function resolveInsideWorkspace(relPath) {
  const root = path.resolve(workspace());
  const target = path.resolve(root, relPath);
  if (target !== root && !target.startsWith(root + path.sep)) {
    throw new Error(
      `Refusing to write outside the workspace: "${relPath}" resolves to "${target}", which is not under "${root}".`
    );
  }
  return target;
}

// --- License text ----------------------------------------------------------

async function fetchLicenseText() {
  const url = process.env.LGPT_LICENSE_URL || LICENSE_TEXT_URL;
  const res = await fetch(url, {
    redirect: 'follow',
    headers: { 'user-agent': 'lgpt-github-action' },
  });
  if (!res.ok) {
    throw new Error(`Failed to download the license text from ${url}: HTTP ${res.status}`);
  }
  return Buffer.from(await res.arrayBuffer());
}

function buildNotice(projectName) {
  return `${projectName}
Copyright (c) 2026 ${projectName} contributors

This product includes software developed by ${COPYRIGHT_HOLDER} and
licensed under the LGPT License v${VERSION}.

------------------------------------------------------------------------

Developer:
${COPYRIGHT_HOLDER}

GitHub Profile:
${PROFILE_URL}

Organization:
${ORG}

Website:
${WEBSITE}

License:
LGPT License v${VERSION}

GitHub Link:
${REPO_URL}

------------------------------------------------------------------------

Special Thanks To:
${COPYRIGHT_HOLDER} for creating the LGPT License and establishing the
licensing framework used by this software.
`;
}

// --- Main ------------------------------------------------------------------

async function run() {
  const licenseRel = input('license-file', 'LICENSE.txt');
  const noticeRel = input('notice-file', 'NOTICE');
  const verify = getBoolean('verify-checksum', true);
  const overwrite = getBoolean('overwrite', false);
  const uninstall = getBoolean('uninstall', false);

  const projectName =
    input('project-name') ||
    process.env.GITHUB_REPOSITORY?.split('/')[1] ||
    path.basename(workspace()) ||
    'Unnamed Project';

  const licensePath = resolveInsideWorkspace(licenseRel);

  if (uninstall) {
    info('LGPT: uninstall mode.');
    for (const target of [licensePath, noticeRel ? resolveInsideWorkspace(noticeRel) : null]) {
      if (!target) continue;
      if (!fs.existsSync(target)) {
        info(`  not present, skipping: ${path.relative(workspace(), target)}`);
        continue;
      }
      const contents = fs.readFileSync(target, 'utf8');
      if (!contents.includes('LGPT License') && !contents.includes(projectName)) {
        warn(`Refusing to delete ${path.relative(workspace(), target)}: it does not look like an LGPT file.`);
        continue;
      }
      fs.rmSync(target, { force: true });
      info(`  removed: ${path.relative(workspace(), target)}`);
    }
    setOutput('action', 'uninstalled');
    return;
  }

  info('LGPT: fetching the canonical license text...');
  const text = await fetchLicenseText();
  const digest = sha256(text);

  if (verify && digest !== CANONICAL_SHA256) {
    throw new Error(
      `Checksum mismatch against the canonical LGPT License v${VERSION}.\n` +
        `  expected: ${CANONICAL_SHA256}\n` +
        `  actual:   ${digest}\n` +
        `Set verify-checksum: false only if you have independently confirmed the source.`
    );
  }
  if (verify) {
    info(`LGPT: checksum verified (${digest.slice(0, 16)}...).`);
  } else {
    warn('LGPT: checksum verification disabled by input.');
  }

  const decoded = text.toString('utf8');
  if (!decoded.includes('LGPT License v')) {
    throw new Error('Downloaded content does not look like an LGPT license. Aborting.');
  }

  const isLgpt = (p) => {
    try {
      return fs.readFileSync(p, 'utf8').includes('LGPT License v');
    } catch {
      return false;
    }
  };

  let action;
  if (fs.existsSync(licensePath)) {
    const existing = fs.readFileSync(licensePath);
    if (sha256(existing) === digest) {
      info('LGPT: license file already present and identical. Nothing to do.');
      action = 'already-present';
    } else if (isLgpt(licensePath)) {
      warn('LGPT: license file is an older revision. Upgrading.');
      fs.writeFileSync(licensePath, text, { mode: 0o644 });
      info('LGPT: license file upgraded.');
      action = 'upgraded';
    } else if (overwrite) {
      warn('LGPT: overwriting a non-LGPT license file because overwrite=true.');
      fs.writeFileSync(licensePath, text, { mode: 0o644 });
      info('LGPT: license file overwritten.');
      action = 'installed';
    } else {
      throw new Error(
        `A LICENSE file already exists at "${licenseRel}" and it is not an LGPT license.\n` +
          `Refusing to overwrite it. Delete or back it up, or set overwrite: true if you are sure.`
      );
    }
  } else {
    fs.writeFileSync(licensePath, text, { mode: 0o644 });
    info(`LGPT: wrote ${licenseRel}`);
    action = 'installed';
  }

  if (action !== 'already-present' && noticeRel) {
    const noticePath = resolveInsideWorkspace(noticeRel);
    if (fs.existsSync(noticePath)) {
      warn(`LGPT: ${noticeRel} already exists. Left untouched — merge the notice manually if needed.`);
    } else {
      fs.writeFileSync(noticePath, buildNotice(projectName), { mode: 0o644 });
      info(`LGPT: wrote ${noticeRel}`);
    }
  }

  if (action === 'installed' || action === 'upgraded') {
    notice(
      `Your project is now licensed under LGPT v${VERSION}. ` +
        `Remember to commit the new files and credit ${COPYRIGHT_HOLDER}: ${REPO_URL}`
    );
  }

  setOutput('license-path', licensePath);
  setOutput('action', action);
  setOutput('checksum', digest);
}

run().catch((err) => {
  setFailed(err && err.message ? err.message : String(err));
});