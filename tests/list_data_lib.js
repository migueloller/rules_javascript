let { readdir } = require('fs').promises
let { join } = require('path')

async function walk(path) {
  let dirents = await readdir(path, { withFileTypes: true })

  return await dirents.reduce(
    (promise, dirent) =>
      promise.then(async paths =>
        dirent.isDirectory()
          ? [...paths, ...(await walk(join(path, dirent.name)))]
          : [...paths, dirent.name]
      ),
    Promise.resolve([]),
  )
}

module.exports.listData = async function listData() {
  return await walk('.')
}
