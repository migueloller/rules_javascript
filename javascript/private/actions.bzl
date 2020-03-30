load("@bazel_skylib//lib:shell.bzl", "shell")

def js_link(ctx, bin, entry_point):
    cmd = """cat << EOF > {bin}
#!/bin/bash

node \\\\
  --preserve-symlinks \\\\
  --preserve-symlinks-main \\\\
  {entry_point}
EOF""".format(
        entry_point = shell.quote(entry_point.path),
        bin = shell.quote(bin.path),
    )

    ctx.actions.run_shell(
        outputs = [bin],
        command = cmd,
        mnemonic = "NodeJsLink",
    )
