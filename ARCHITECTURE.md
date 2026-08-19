# Architecture, Git Branching & Portability Plan: `lqcd_softwares_imsc`

This document defines the software engineering architecture, Git management model, feature migration roadmap, and multi-machine deployment strategy for the Lattice QCD software suite at IMSc.

---

## 1. Directory Layout & Organization

The suite at `/lustre/tanishks/lqcd_softwares_imsc` follows a standard modular organization:

```
lqcd_softwares_imsc/
├── env/                     # Machine-specific environment profiles
│   ├── tkamet.sh            # Environment & GPU settings for Kamet cluster (H100 / sm_90)
│   ├── pmnoffice.sh         # Environment & GPU settings for PMN workstation (RTX / sm_70/89)
│   └── generic.sh           # Fallback template for any new HPC site
├── src/                     # Git submodules / source checkouts
│   ├── quda/
│   ├── chroma/
│   ├── qdp-jit/
│   ├── qdpxx/
│   ├── qmp/
│   ├── lalibe/
│   ├── chroma_laph/
│   └── ...
├── build/                   # Out-of-source CMake & Ninja build artifacts
│   ├── build_quda/
│   ├── build_chroma_jit/
│   └── ...
├── install/                 # Installation prefixes (headers, libs, executables)
│   ├── QUDA/
│   ├── CHROMA_JIT/
│   ├── QDP-JIT/
│   └── ...
├── setup.sh                 # Master environment bootstrap loader
├── quda.sh                  # Parameterized build script for QUDA
├── chroma_jit.sh            # Parameterized build script for Chroma-JIT
├── qdp-jit.sh               # Parameterized build script for QDP-JIT
└── ...
```

---

## 2. Git Branching & Upstream Synchronization Model

To allow seamless upgrades whenever upstream releases new versions while maintaining custom features:

### A. Remote Configuration (per package in `src/*`)
```bash
# In src/<package> (e.g. src/quda):
git remote add upstream https://github.com/lattice/quda.git
git remote add origin git@github.com:<your_org>/quda.git
```

### B. Branch Conventions
* **`upstream/develop` (or `upstream/master`)**: Tracks clean, untouched official releases.
* **`imsc-main`**: The stable production branch containing all verified custom modifications.
* **`feature/<feature-name>`**: Branch used when developing, porting, or refactoring a specific physics feature.

### C. Merging Future Upstream Releases
When an upstream package updates:
```bash
git checkout imsc-main
git fetch upstream
git rebase upstream/develop   # Replays custom commits onto new upstream release
# In case of conflicts, Git highlights exact lines; resolve once, test, and commit.
```

---

## 3. Step-by-Step Feature Migration Workflow

We port custom physics features from old scattered directories into `lqcd_softwares_imsc` one by one:

```
[Old Scattered Codebases]
           │
           ▼
 [Create feature branch: git checkout -b feature/<name>]
           │
           ▼
 [Port / clean code & fix API deprecations]
           │
           ▼
 [Build: ./quda.sh (or respective build script)]
           │
           ▼
 [Run automated regression test against baseline data]
           │
           ▼ (Passes)
 [Merge feature into imsc-main & tag release]
```

### Initial Feature Migration Queue:
1. **Feature 1**: NRQCD propagator engine (`nrqcdPropagatorQudaImpl`, Lepage stability, $\delta H$ terms).
2. **Feature 2**: Anisotropic Clover / RHQ operator support (`clover_coeff_E`, `clover_coeff_B`, anisotropy handling).
3. **Feature 3**: Distance preconditioning and Hasenbusch twist clover operators.
4. **Feature 4**: Custom Chroma / LaPH / Lalibe observables and measurements.

---

## 4. Multi-Machine Portability Architecture

To ensure the entire suite builds and runs identically on `tkamet`, `pmnoffice`, or any new cluster without editing individual CMake scripts:

### A. Environment Profiles (`env/*.sh`)
All machine-specific paths, compiler wrappers, module commands, and GPU target architectures live in `env/<machine>.sh`:

#### `env/tkamet.sh`
```bash
module restore chroma_gnu
export LQCD_MACHINE="tkamet"
export CUDA_ARCH="90"
export QUDA_GPU_ARCH="sm_90"
export CMAKE_BIN="/lustre/tanishks/anaconda3/envs/ruby_env/bin/cmake"
export NVSHMEM_HOME="/opt/apps/nvhpc/2025_259/Linux_x86_64/2025/comm_libs/nvshmem"
export QUDA_NVSHMEM_OPT="ON"
```

#### `env/pmnoffice.sh`
```bash
conda activate /home/tanishks/conda_envs/gnu_env
export LQCD_MACHINE="pmnoffice"
export CUDA_ARCH="70"
export QUDA_GPU_ARCH="sm_70"
export CMAKE_BIN="cmake"
export NVSHMEM_HOME=""
export QUDA_NVSHMEM_OPT="OFF"
```

### B. Master Bootstrap (`setup.sh`)
```bash
#!/bin/bash
MACHINE=${1:-"tkamet"}

if [ -f "env/${MACHINE}.sh" ]; then
    source "env/${MACHINE}.sh"
    echo "Loaded environment profile for: ${MACHINE}"
else
    echo "Warning: env/${MACHINE}.sh not found. Using default environment."
fi

export BASEDIR=$(pwd)
export SRCDIR=${BASEDIR}/src
export BUILDDIR=${BASEDIR}/build
export INSTALLDIR=${BASEDIR}/install
export PATH=${INSTALLDIR}/NINJA/bin:${PATH}
export CMAKE_GENERATOR=Ninja

mkdir -p ${BUILDDIR} ${INSTALLDIR}
```

### C. Generalized Build Scripts (e.g. `quda.sh`)
Build scripts reference `${CUDA_ARCH}`, `${QUDA_GPU_ARCH}`, `${CMAKE_BIN}`, and `${INSTALLDIR}` rather than hardcoded machine paths:
```bash
${CMAKE_BIN} -G Ninja -S ${SRCDIR}/quda -B ${BUILDDIR}/build_quda \
  -DCMAKE_BUILD_TYPE=DEVEL \
  -DCMAKE_CUDA_ARCHITECTURES=${CUDA_ARCH} \
  -DCMAKE_INSTALL_PREFIX=${INSTALLDIR}/QUDA \
  -DCMAKE_PREFIX_PATH="${INSTALLDIR}/QMP;${INSTALLDIR}/QDP-JIT/lib/cmake/QIO;${INSTALLDIR}/libxml2;${INSTALLDIR}/QDP-JIT;${INSTALLDIR}/llvm-project" \
  -DQUDA_GPU_ARCH=${QUDA_GPU_ARCH} \
  -DQUDA_NVSHMEM=${QUDA_NVSHMEM_OPT} \
  -DQUDA_DIRAC_DEFAULT_OFF=ON \
  -DQUDA_DIRAC_CLOVER=ON \
  -DQUDA_DIRAC_WILSON=ON \
  -DQUDA_DIRAC_COVDEV=ON \
  -DQUDA_DIRAC_LAPLACE=ON \
  -DQUDA_INTERFACE_QDPJIT=ON \
  -DQUDA_QDPJIT=ON \
  -DQUDA_INTERFACE_QDP=ON \
  -DQUDA_QMP=ON \
  -DQUDA_QIO=ON \
  -DQUDA_MULTIGRID=ON \
  -DQUDA_BUILD_SHAREDLIB=ON
```

---

## 5. Porting to a New Machine in 3 Steps
1. Copy or clone `lqcd_softwares_imsc`.
2. Create `env/<new_cluster>.sh` with the cluster's module/compiler settings and GPU architecture.
3. Run `source setup.sh <new_cluster>` and execute the build scripts.
