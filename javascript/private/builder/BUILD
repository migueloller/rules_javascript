load("//javascript/private:rules.bzl", "js_tool_binary")

package(default_visibility = ["//visibility:public"])

js_tool_binary(
    name = "builder",
    srcs = [
        "builder.js",
        "link.js",
        "minimist.js",
    ],
    entry_point = "builder.js",
)
