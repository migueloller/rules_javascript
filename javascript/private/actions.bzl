load("@bazel_skylib//lib:shell.bzl", "shell")
load("@bazel_skylib//lib:paths.bzl", "paths")

def js_link(ctx, executable, bin, entry_point):
    args = ctx.actions.args()
    args.add("link")
    args.add(entry_point)
    args.add("-o")
    args.add(bin)
    args.add("--")
    args.add("--preserve-symlinks")
    args.add("--preserve-symlnks-main")

    ctx.actions.run(
        outputs = [bin],
        executable = executable,
        arguments = [args],
        mnemonic = "NodeJsLink",
    )

def js_build_tool(ctx, template, entry_point, bin):
    ctx.actions.expand_template(
        template = template,
        output = bin,
        substitutions = {
            "ENTRY_POINT": shell.quote(paths.join(
                ctx.workspace_name,
                entry_point.path,
            )),
        },
    )
