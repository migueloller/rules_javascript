let fs = require('fs').promises
let path = require('path')

async function permissiveReaddir(...args) {
  try {
    return await fs.readdir(...args)
  } catch (error) {
    if (error.code === 'ENOENT') return []

    throw error
  }
}

async function asyncFlatMap(arr, mapper) {
  let mapped = await Promise.all(arr.map(mapper))

  return mapped.flat()
}

async function isDirectory(dirPath, dirent) {
  return (
    dirent.isDirectory() ||
    (dirent.isSymbolicLink() &&
      (await fs.stat(path.join(dirPath, dirent.name))).isDirectory())
  )
}

async function findPackages(dirPath) {
  let dirents = await permissiveReaddir(dirPath, { withFileTypes: true })

  return asyncFlatMap(dirents, async (dirent) => {
    let direntPath = path.join(dirPath, dirent.name)

    if (!(await isDirectory(dirPath, dirent))) return []

    if (dirent.name.startsWith('@')) return findPackageFiles(direntPath)

    return [direntPath].concat(
      await findPackages(path.join(direntPath, 'node_modules')),
    )
  })
}

async function findFiles(dirPath) {
  let dirents = await permissiveReaddir(dirPath, { withFileTypes: true })

  return asyncFlatMap(dirents, async (dirent) => {
    let direntPath = path.join(dirPath, dirent.name)

    if (await isDirectory(dirPath, dirent)) return findFiles(direntPath)

    return [direntPath]
  })
}

async function findPackageFiles(packagePath) {
  let dirents = await permissiveReaddir(packagePath, { withFileTypes: true })

  return asyncFlatMap(dirents, async (dirent) => {
    let direntPath = path.join(packagePath, dirent.name)

    if (!(await isDirectory(packagePath, dirent))) return [direntPath]

    if (dirent.name === 'node_modules') return []

    return findFiles(direntPath)
  })
}

function getPackageDependenciesInfo(
  { path: packagePath, manifest: { name: packageName, dependencies = {} } },
  packageInfoByPath,
) {
  return Object.keys(dependencies).map((dependency) => {
    let pathSegments = packagePath.split(path.sep)
    let dependencyInfo

    do {
      let dependencyPath = path.join(
        ...pathSegments,
        'node_modules',
        dependency,
      )

      dependencyInfo = packageInfoByPath.get(dependencyPath)
    } while (dependencyInfo == null && pathSegments.pop() != null)

    if (dependencyInfo == null) {
      throw new Error(
        `Cannot find dependency '${dependency}' for package '${packageName}'`,
      )
    }

    return dependencyInfo
  })
}

async function mkdirp(dirPath) {
  try {
    return await fs.mkdir(dirPath)
  } catch (error) {
    if (error.code === 'ENOENT') {
      await mkdirp(path.dirname(dirPath))

      return fs.mkdir(dirPath)
    }

    throw error
  }
}

function toSkylarkLabelList(paths, indentation = 0) {
  return paths.length === 0
    ? '[]'
    : `[
${paths.map((p) => `${'    '.repeat(indentation + 1)}"${p}",`).join('\n')}
${'    '.repeat(indentation)}]`
}

async function generateRootBuildFile(packageInfoByPath) {
  let allFiles = Array.from(packageInfoByPath.values())
    .map((info) => info.files)
    .flat()
  let buildFileContents = `# Generated file from yarn_install repository rule.

exports_files(${toSkylarkLabelList(allFiles)})
`

  await fs.writeFile('BUILD.bazel', buildFileContents, 'utf-8')
}

async function generatePackageBuildFile({
  path: packagePath,
  files,
  dependencies,
}) {
  let buildFileDirname = packagePath.replace(/^node_modules\//, '')
  let buildFileContents = `# Generated file from yarn_install repository rule.

load("@rules_javascript//javascript:def.bzl", "js_library")

package(default_visibility = ["//visibility:public"])

js_library(
    name = "${path.basename(buildFileDirname)}",
    srcs = ${toSkylarkLabelList(
      files.map((f) => `//:${f}`),
      1,
    )},
    deps = ${toSkylarkLabelList(
      dependencies.map((d) => `//${d.path.replace(/^node_modules\//, '')}`),
      1,
    )},
)
`

  await mkdirp(buildFileDirname)
  await fs.writeFile(
    path.join(buildFileDirname, 'BUILD.bazel'),
    buildFileContents,
    'utf-8',
  )
}

async function main(process) {
  let packagePaths = await findPackages('node_modules')
  let packageInfoByPath = new Map()

  await Promise.all(
    packagePaths.map(async (packagePath) => {
      let manifestPath = path.join(packagePath, 'package.json')
      let [manifestContents, packageFilePaths] = await Promise.all([
        fs.readFile(manifestPath, 'utf-8'),
        findPackageFiles(packagePath),
      ])
      let packageInfo = {
        path: packagePath,
        manifest: JSON.parse(manifestContents),
        files: packageFilePaths,
      }

      packageInfoByPath.set(packagePath, packageInfo)
    }),
  )

  await generateRootBuildFile(packageInfoByPath)

  await Promise.all(
    Array.from(packageInfoByPath.entries()).map(
      async ([packagePath, packageInfo]) => {
        let {
          manifest: { name: packageName, dependencies = {} },
        } = packageInfo

        let dependenciesInfo = getPackageDependenciesInfo(
          packageInfo,
          packageInfoByPath,
        )

        await generatePackageBuildFile({
          ...packageInfo,
          dependencies: dependenciesInfo,
        })
      },
    ),
  )

  return 0
}

if (require.main === module) {
  main(process)
    .then(process.exit)
    .catch((error) => {
      console.error(error)
      process.exit(1)
    })
}
