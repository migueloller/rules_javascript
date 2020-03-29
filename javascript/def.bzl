load(
    "//javascript/private:rules.bzl",
    _js_library = "js_library",
    _nodejs_binary = "nodejs_binary",
)
load(
    "//javascript/private:providers.bzl",
    _JsLibraryInfo = "JsLibraryInfo",
)

nodejs_binary = _nodejs_binary
js_library = _js_library
JsLibraryInfo = _JsLibraryInfo
