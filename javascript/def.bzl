load(
    "//javascript/private:rules.bzl",
    _js_binary = "js_binary",
    _js_library = "js_library",
)
load(
    "//javascript/private:providers.bzl",
    _JsLibraryInfo = "JsLibraryInfo",
)

js_binary = _js_binary
js_library = _js_library
JsLibraryInfo = _JsLibraryInfo
