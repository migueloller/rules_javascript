load("//:def.bzl", "js_library", "nodejs_binary")

nodejs_binary(
    name = "hello",
    srcs = ["hello.js"],
    data = ["message.js"],
    entry_point = "hello.js",
)

sh_test(
    name = "hello_test",
    srcs = ["hello_test.sh"],
    args = ["$(rootpath :hello)"],
    data = [":hello"],
)

js_library(
    name = "baz",
    srcs = ["baz.js"],
    data = ["qux.js"],
)

js_library(
    name = "bar",
    srcs = ["bar.js"],
    deps = [":baz"],
)

js_library(
    name = "foo",
    srcs = ["foo.js"],
    deps = [
        ":bar",
        ":baz",
    ],
)

nodejs_binary(
    name = "bin_with_libs",
    srcs = ["bin_with_libs.js"],
    entry_point = "bin_with_libs.js",
    deps = [":foo"],
)

sh_test(
    name = "bin_with_libs_test",
    srcs = ["bin_with_libs_test.sh"],
    args = ["$(rootpath :bin_with_libs)"],
    data = [":bin_with_libs"],
)
