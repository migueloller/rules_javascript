load(
    "//javascript/private:rules.bzl",
    _js_binary = "js_binary",
    _js_library = "js_library",
)
load(
    "//javascript/private:providers.bzl",
    _JsLibraryInfo = "JsLibraryInfo",
)
load("//javascript/private:repo.bzl", _yarn_install = "yarn_install")

js_binary = _js_binary
js_library = _js_library
JsLibraryInfo = _JsLibraryInfo

yarn_install = _yarn_install
