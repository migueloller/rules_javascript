load("//javascript:def.bzl", "js_binary", "js_library")

js_binary(
    name = "hello",
    srcs = [
        "hello.js",
        "message.js",
    ],
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

js_binary(
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

js_library(
    name = "list_data_lib",
    srcs = ["list_data_lib.js"],
    data = ["bar.txt"],
)

js_binary(
    name = "list_data_bin",
    srcs = ["list_data_bin.js"],
    data = ["foo.txt"],
    entry_point = "list_data_bin.js",
    deps = [":list_data_lib"],
)

sh_test(
    name = "data_test",
    srcs = ["data_test.sh"],
    args = ["$(rootpath :list_data_bin)"],
    data = [":list_data_bin"],
)
