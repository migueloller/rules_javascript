load(":actions.bzl", "js_link")
load(":providers.bzl", "JsLibraryInfo")

def _js_binary_impl(ctx):
    srcs = ctx.files.srcs
    entry_point = ctx.file.entry_point

    if entry_point not in srcs:
        fail(
            "could not find '{entry_point}'"
                .format(entry_point = entry_point.basename) +
            "as specified by 'entry_point' attribute",
        )

    bin = ctx.actions.declare_file(
        ctx.label.name,
        sibling = entry_point,
    )

    deps_set = depset(
        [dep[JsLibraryInfo].info for dep in ctx.attr.deps],
        transitive = [dep[JsLibraryInfo].deps for dep in ctx.attr.deps],
    )
    deps = deps_set.to_list()

    runfiles = ctx.runfiles(srcs + ctx.files.data)
    for dep in deps:
        runfiles = runfiles.merge(ctx.runfiles(dep.srcs + dep.data))

    js_link(
        ctx,
        executable = ctx.file._builder,
        bin = bin,
        entry_point = entry_point,
        deps = deps,
    )

    return [DefaultInfo(
        files = depset([bin]),
        executable = bin,
        runfiles = runfiles,
    )]

js_binary = rule(
    _js_binary_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".js"], mandatory = True),
        "entry_point": attr.label(allow_single_file = [".js"], mandatory = True),
        "data": attr.label_list(allow_files = True),
        "deps": attr.label_list(providers = [JsLibraryInfo]),
        "_builder": attr.label(
            allow_single_file = True,
            default = "//javascript/private:builder/builder.js",
        ),
    },
    executable = True,
)

def _js_library_impl(ctx):
    return [JsLibraryInfo(
        info = struct(
            module_name = ctx.attr.module_name,
            srcs = ctx.files.srcs,
            data = ctx.files.data,
        ),
        deps = depset(
            [dep[JsLibraryInfo].info for dep in ctx.attr.deps],
            transitive = [dep[JsLibraryInfo].deps for dep in ctx.attr.deps],
        ),
    )]

js_library = rule(
    _js_library_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".js"]),
        "module_name": attr.string(mandatory = True),
        "deps": attr.label_list(providers = [JsLibraryInfo]),
        "data": attr.label_list(allow_files = True),
    },
    provides = [JsLibraryInfo],
)
