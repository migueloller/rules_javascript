def js_link(ctx, executable, bin, entry_point, deps):
    args = ctx.actions.args()
    args.add("link")
    args.add(entry_point)
    args.add("-o")
    args.add(bin)
    args.add_all(deps)
    args.add("--")
    args.add("--preserve-symlinks")
    args.add("--preserve-symlnks-main")

    ctx.actions.run(
        outputs = [bin],
        executable = executable,
        arguments = [args],
        mnemonic = "NodeJsLink",
    )
