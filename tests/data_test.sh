set -euo pipefail

program="$1"
got=$("$program")
want=(foo.txt bar.txt)

for w in "${want[@]}"; do
  if [[ $got != *$w* ]]; then
    echo $got >&2
    echo "error: program output does not contain $w" >&2
    exit 1
  fi
done
