#!/bin/bash
set -o pipefail
set -eu

here=$(dirname $(readlink -f "$0"))
set -x
"$here"/patch-auditwheel.sh
"$here"/install-mpi.sh $MPI_NAME $MPI_VERSION
