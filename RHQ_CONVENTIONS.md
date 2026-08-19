# RHQ / Anisotropic Clover Parameter & Coefficient Mapping Reference
**Chroma <-> QUDA**

---

## 1. Parameter Translation Formulas

Given Chroma XML inputs:
- Mass
- xi_0 (bare anisotropy)
- nu (fermion anisotropy / velocity factor)
- c_R = clovCoeffR (spatial/magnetic clover coefficient)
- c_T = clovCoeffT (temporal/electric clover coefficient)

### Step 1: Diagonal Mass & effective kappa
ff = nu / xi_0
diag_mass = 1.0 + 3.0 * ff + Mass
kappa_eff = 1.0 / (2.0 * diag_mass)

The Chroma XML may instead provide the isotropic bare kappa, for which
`Mass = 1/(2*kappa) - 4`.  The anisotropic operator must use `kappa_eff`.

### Step 2: QUDA Gauge Parameters
The gauge anisotropy is a property of the resident gauge field and is not the
fermion hopping factor.  Keep `gauge_param.anisotropy` equal to the value used
to load the gauge configuration.

Set the gauge temporal boundary independently, for example
`QUDA_ANTI_PERIODIC_T` for antiperiodic time boundaries.

### Step 3: QUDA Inverter Parameters
inv_param.kappa          = kappa_eff
inv_param.nu              = ff
inv_param.clover_coeff_B = kappa_eff * c_R / xi_0
inv_param.clover_coeff_E = kappa_eff * c_T

`inv_param.nu` is consumed by the Wilson-clover dslash as the multiplier of
the three spatial forward and backward hops.  The clover coefficients include
the effective kappa because QUDA stores the mass-normalized clover field.

### Step 4: Propagator Rescaling
psi_Chroma = diag_mass * psi_QUDA
psi_QUDA   = (1.0 / diag_mass) * psi_Chroma

---

## 2. Isotropic Limit (xi_0 = 1, nu = 1)
- diag_mass = 4 + Mass
- gauge_param.anisotropy = 1.0
- inv_param.kappa = 1.0 / (2.0 * (4 + Mass))
- inv_param.nu = 1.0
- clover_coeff_B = kappa * c_sw
- clover_coeff_E = kappa * c_sw
