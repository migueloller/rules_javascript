def _yarn_install_impl(repository_ctx):
    package_json = repository_ctx.attr.package_json
    package_json_path = repository_ctx.path(package_json)
    package_json_dirname = package_json_path.dirname
    package_json_basename = package_json_path.basename
    yarn_lock = repository_ctx.attr.yarn_lock
    yarn_lock_path = repository_ctx.path(yarn_lock)
    yarn_lock_basename = yarn_lock_path.basename

    # Strategy #1, run Yarn where package.json is and symlink the resulting
    # node_modules to the repository.
    repository_ctx.report_progress("Running yarn install on %s." % package_json)
    repository_ctx.execute([
        "yarn",
        "--cwd",
        package_json_dirname,
        "install",
        "--frozen-lockfile",
    ], quiet = False)
    repository_ctx.symlink(
        package_json_dirname.get_child("node_modules"),
        "node_modules",
    )

    repository_ctx.report_progress("Generating BUILD.bazel files.")
    repository_ctx.execute(
        [
            "node",
            repository_ctx.path(repository_ctx.attr._generate_build_files),
        ] + [
            repository_ctx.path(manifest)
            for manifest in repository_ctx.attr.workspaces_package_json
        ],
        quiet = False,
    )

    # # Strategy #2, symlink the directory where the package.json is and run Yarn
    # # in the repository.
    # repository_ctx.report_progress("Running yarn install on %s." % package_json)
    # repository_ctx.symlink(package_json_dirname, "")
    # repository_ctx.execute([
    #     "yarn",
    #     "install",
    #     "--frozen-lockfile",
    # ], quiet = False)

yarn_install = repository_rule(
    implementation = _yarn_install_impl,
    attrs = {
        "package_json": attr.label(
            mandatory = True,
            allow_single_file = [".json"],
        ),
        "yarn_lock": attr.label(
            mandatory = True,
            allow_single_file = [".lock"],
        ),
        "workspaces_package_json": attr.label_list(
            allow_files = [".json"],
        ),
        "_generate_build_files": attr.label(
            default = "//javascript/private:generate_build_files.js",
        ),
    },
)
