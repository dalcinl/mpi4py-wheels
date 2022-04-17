#!/bin/bash
set -o pipefail
set -eu

mpiexec=mpiexec

if [ $(command -v mpichversion) ]; then
    export HYDRA_LAUNCHER=fork
fi

if [ $(command -v ompi_info) ]; then
    export OMPI_MCA_plm=isolated
    export OMPI_MCA_rmaps_base_oversubscribe=true
    export OMPI_MCA_rmaps_default_mapping_policy=:oversubscribe
    export OMPI_MCA_btl_base_warn_component_unused=false
    export OMPI_MCA_btl_vader_single_copy_mechanism=none
    export OMPI_ALLOW_RUN_AS_ROOT=1
    export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
    mpiexec="mpiexec --allow-run-as-root"
fi

set -x

#$mpiexec -n 2 python -m mpi4py.bench helloworld
#$mpiexec -n 2 python -m mpi4py.bench ringtest

export MPI4PY_RC_INITIALIZE=0
export MPI4PY_RC_FINALIZE=0
python -m mpi4py --version
python -c "from mpi4py import MPI; print(MPI.Get_library_version())"
