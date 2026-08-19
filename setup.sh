#!/bin/bash
# SET UP ENVIRONMENT

# use Ninja to build, if Ninja is not available comment out the below line and
export PATH=/lustre/tanishks/lqcd_softwares_imsc/install/NINJA/bin:$PATH
which ninja
export CMAKE_GENERATOR=Ninja
# if not using Ninja please uncomment below line for a parallel build
#export CMAKE_MAKE_OPTS="-- -j$(nproc)"

### COMPILER FLAGS, modify to your need and don't use native if the build machine has a different CPU than the compute nodes
export ARCHFLAGS=""
export DEBUGFLAGS=" "

# define and create some directories, adapt as needed
export BASEDIR=$(pwd)
export SRCDIR=${BASEDIR}/src
export BUILDDIR=${BASEDIR}/build
export INSTALLDIR=${BASEDIR}/install

mkdir -p ${BUILDDIR}
