#!/bin/bash

set -euo pipefail

program="$1"
got=$("$program")
want="foo
bar
qux
baz
qux
baz"

if [ "$got" != "$want" ]; then
  cat >&2 << EOF
got:
$got

want:
$want
EOF
  exit 1
fi
