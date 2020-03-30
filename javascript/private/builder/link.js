let fs = require('fs').promises
let path = require('path')

let minimist = require('./minimist')

async function link(args) {
  let {
    o: outFile,
    _: [entryPoint],
    ['--']: nodeArgs,
  } = minimist(args, { '--': true })
  let executableContents = `#!/bin/bash

set -euo pipefail

node ${entryPoint} ${nodeArgs.join(' ')}`

  await fs.writeFile(path.join(outFile), executableContents)
}

module.exports = link
