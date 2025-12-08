const fs = require('fs');
const path = require('path');

const feedPath = process.argv[2];
const feedsConf = feedPath && fs.existsSync(feedPath)
  ? fs.readFileSync(feedPath, 'utf8')
    .split('\n')
    .map(l => l.trim())
    .filter(l => l && !l.startsWith('#'))
  : [];
const feedNames =
  feedsConf.map(line => {
    const parts = line.split(/\s+/);
    return parts[1];
  });

const allPackages = [];
for (const feed of feedNames) {
  // This is after `scripts/feeds install -a`
  // And we are under openwrt directory surely
  const indexFile = path.join('feeds', feed + '.index');
  if (!fs.existsSync(indexFile)) continue;

  const lines = fs.readFileSync(indexFile, 'utf8').split('\n');
  for (const line of lines) {
    if (line.startsWith('Source-Makefile:')) {
      const match = line.match(/([^/]+)\/Makefile(?:\s|$)/);
      if (match) {
        const pkg = match[1];
        allPackages.push(pkg);
      }
    }
  }
}

const combos = [];
const allTargets = JSON.parse(process.env.ALL_TARGETS);
for (const t of allTargets) {
  for (const p of allPackages) {
    combos.push({ target: t, package: p });
  }
  combos.push({ target: t, package: '' })
}

// Write to GITHUB_OUTPUT
// Much like `echo "matrix=_JSON_STRING_" >> $GITHUB_OUTPUT`
fs.appendFileSync(
  process.env.GITHUB_OUTPUT,
  `matrix=${JSON.stringify(combos)}\n`
);
