#!/bin/bash
set -o pipefail
set -eu

here=$(dirname $(readlink -f "$0"))
auditwheel=$(command -v auditwheel)
interpreter=$(head -n 1 "$auditwheel")
set -x
sed "1 s|^.*$|$interpreter|" "$here"/auditwheel.py > "$auditwheel"
