#!/usr/bin/env bash

set -euo pipefail

bazelisk clean --expunge
rm -rf node_modules packages/*/node_modules
