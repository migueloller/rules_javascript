# rules_javascript

JavaScript rules for [Bazel](https://bazel.build).

## 🚧🚧🚧 Under Construction 🚧🚧🚧

This repository is currently under construction. Handle with care.

## Setup

```starlark
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "rules_javascript",
    branch = "master",
    urls = ["https://github.com/migueloller/rules_javascript"],
)

load("@rules_javascript//javascript:deps.bzl", "javascript_rules_dependencies")

javascript_rules_dependencies()
```
