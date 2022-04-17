#!/bin/bash
set -o pipefail
set -eu

case $1 in
    mpich)
        MPI=mpich; version="${2-4.0.2}";
        ;;
    mpich-*)
        MPI=mpich; version="${1#*-}";
        ;;
    openmpi)
        MPI=openmpi; version="${2-4.1.4}";
        ;;
    openmpi-*)
        MPI=openmpi; version="${1#*-}";
        ;;
    *)
        echo "Unknown MPI: '$1'"
        exit 1
        ;;
esac

major=$(echo $version | cut -d. -f1)
minor=$(echo $version | cut -d. -f2)

case $MPI in
    mpich)
        baseurl=https://www.mpich.org/static/downloads/$version/
        download=$baseurl/$MPI-$version.tar.gz
        configure_options=(
            --with-device=ch3
            --disable-wrapper-rpath
            --with-wrapper-dl-type=none
            --disable-maintainer-mode
            --disable-dependency-tracking
        )
        ;;
    openmpi)
        baseurl=https://download.open-mpi.org/release/open-mpi/v${major}.${minor}
        download=$baseurl/$MPI-$version.tar.gz
        configure_options=(
            --disable-wrapper-rpath
            --disable-wrapper-runpath
            --disable-dependency-tracking
        )
        ;;
    *)
        echo "Unknown MPI implementation:" $MPI
        exit 1
        ;;
esac

if [ "$MPI" == "mpich" ]; then
    if [ $(($(gfortran -dumpversion | cut -d. -f1) >= 10)) == 1 ]; then
        export FFLAGS=-fallow-argument-mismatch
        export FCFLAGS=-fallow-argument-mismatch
    fi
    if [ ! -f /usr/bin/python3 ] && [ -d /opt/python/cp310-cp310/bin ]; then
        export PATH=/opt/python/cp310-cp310/bin:$PATH
    fi
fi

CPU_COUNT=${CPU_COUNT-$((($(nproc)+1)/2))}

set -x

mkdir $MPI-$version
curl -s $download -o $MPI-$version.tar.gz
tar --strip-components=1 -zxf $MPI-$version.tar.gz -C $MPI-$version
cd $MPI-$version

./configure ${configure_options[@]} || cat config.log
make -j${CPU_COUNT}
make install

ldconfig || true
mpicc -show
