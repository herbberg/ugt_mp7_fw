-- Description:
-- Package for LUTs of GTL firmware in Global Trigger Upgrade system.

-- HB 2018-12-06: separated from gtl_pkg.vhd.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.lhc_data_pkg.all;
use work.math_pkg.all;
use work.gt_mp7_core_pkg.all;

use work.gtl_pkg.all;

package lut_pkg is

-- deta, dphi and dr parameters

-- constant PI : real :=  3.14159;
constant PI : real :=  3.15; -- TM used this value for PI

constant CALO_ETA_STEP : real := 0.087/2.0; -- values from scales
constant MUON_ETA_STEP : real := 0.087/8.0; -- values from scales

constant CALO_PHI_BINS : positive := 144; -- values from scales
constant MUON_PHI_BINS : positive := 576; -- values from scales
constant CALO_PHI_HALF_RANGE_BINS : positive := CALO_PHI_BINS/2; -- 144/2, because of phi bin width = 2*PI/144
constant MUON_PHI_HALF_RANGE_BINS : positive := MUON_PHI_BINS/2; -- 576/2, because of phi bin width = 2*PI/576

constant PHI_MIN : real := 0.0; -- phi min.: 0.0
constant PHI_MAX : real := 2.0*PI; -- phi max.: 2*PI

constant ETA_MIN : real := -5.0; -- eta min.: -5.0
constant ETA_MAX : real := 5.0; -- eta max.: +5.0
constant ETA_RANGE_REAL : real := 10.0; -- eta range max.: -5.0 to +5.0

constant MAX_CALO_ETA_BITS : positive := max((EG_ETA_HIGH-EG_ETA_LOW+1), (JET_ETA_HIGH-JET_ETA_LOW+1), (TAU_ETA_HIGH-TAU_ETA_LOW+1));
constant MAX_CALO_PHI_BITS : positive := max((EG_PHI_HIGH-EG_PHI_LOW+1), (JET_PHI_HIGH-JET_PHI_LOW+1), (TAU_PHI_HIGH-TAU_PHI_LOW+1));
constant MAX_MUON_PHI_BITS : positive := MUON_PHI_HIGH-MUON_PHI_LOW+1;

-- constant DETA_DPHI_PRECISION_ALL: positive := 3;
constant EG_EG_DETA_PRECISION: positive := 3;
constant EG_JET_DETA_PRECISION: positive := 3;
constant EG_TAU_DETA_PRECISION: positive := 3;
constant JET_EG_DETA_PRECISION: positive := 3;
constant JET_JET_DETA_PRECISION: positive := 3;
constant JET_TAU_DETA_PRECISION: positive := 3;
constant TAU_EG_DETA_PRECISION: positive := 3;
constant TAU_JET_DETA_PRECISION: positive := 3;
constant TAU_TAU_DETA_PRECISION: positive := 3;
constant EG_MUON_DETA_PRECISION: positive := 3;
constant JET_MUON_DETA_PRECISION: positive := 3;
constant TAU_MUON_DETA_PRECISION: positive := 3;
constant MUON_MUON_DETA_PRECISION: positive := 3;

constant EG_EG_DPHI_PRECISION: positive := 3;
constant EG_JET_DPHI_PRECISION: positive := 3;
constant EG_TAU_DPHI_PRECISION: positive := 3;
constant JET_EG_DPHI_PRECISION: positive := 3;
constant JET_JET_DPHI_PRECISION: positive := 3;
constant JET_TAU_DPHI_PRECISION: positive := 3;
constant TAU_EG_DPHI_PRECISION: positive := 3;
constant TAU_JET_DPHI_PRECISION: positive := 3;
constant TAU_TAU_DPHI_PRECISION: positive := 3;
constant EG_MUON_DPHI_PRECISION: positive := 3;
constant JET_MUON_DPHI_PRECISION: positive := 3;
constant TAU_MUON_DPHI_PRECISION: positive := 3;
constant MUON_MUON_DPHI_PRECISION: positive := 3;

constant EG_ETM_DPHI_PRECISION: positive := 3;
constant JET_ETM_DPHI_PRECISION: positive := 3;
constant TAU_ETM_DPHI_PRECISION: positive := 3;
constant MUON_ETM_DPHI_PRECISION: positive := 3;
constant EG_HTM_DPHI_PRECISION: positive := 3;
constant JET_HTM_DPHI_PRECISION: positive := 3;
constant TAU_HTM_DPHI_PRECISION: positive := 3;
constant MUON_HTM_DPHI_PRECISION: positive := 3;
constant EG_ETMHF_DPHI_PRECISION: positive := 3;
constant JET_ETMHF_DPHI_PRECISION: positive := 3;
constant TAU_ETMHF_DPHI_PRECISION: positive := 3;
constant MUON_ETMHF_DPHI_PRECISION: positive := 3;
-- HB 2017-06-21: for correlation conditions v2
constant MU_ETM_DPHI_PRECISION: positive := 3;
constant MU_HTM_DPHI_PRECISION: positive := 3;
constant MU_ETMHF_DPHI_PRECISION: positive := 3;

constant EG_EG_DETA_DPHI_PRECISION: positive := max(EG_EG_DETA_PRECISION, EG_EG_DPHI_PRECISION);
constant EG_JET_DETA_DPHI_PRECISION: positive := max(EG_JET_DETA_PRECISION, EG_JET_DPHI_PRECISION);
constant EG_TAU_DETA_DPHI_PRECISION: positive := max(EG_TAU_DETA_PRECISION, EG_TAU_DPHI_PRECISION);
constant JET_EG_DETA_DPHI_PRECISION: positive := max(JET_EG_DETA_PRECISION, JET_EG_DPHI_PRECISION);
constant JET_JET_DETA_DPHI_PRECISION: positive := max(JET_JET_DETA_PRECISION, JET_JET_DPHI_PRECISION);
constant JET_TAU_DETA_DPHI_PRECISION: positive := max(JET_TAU_DETA_PRECISION, JET_TAU_DPHI_PRECISION);
constant TAU_EG_DETA_DPHI_PRECISION: positive := max(TAU_EG_DETA_PRECISION, TAU_EG_DPHI_PRECISION);
constant TAU_JET_DETA_DPHI_PRECISION: positive := max(TAU_JET_DETA_PRECISION, TAU_JET_DPHI_PRECISION);
constant TAU_TAU_DETA_DPHI_PRECISION: positive := max(TAU_TAU_DETA_PRECISION, TAU_TAU_DPHI_PRECISION);
constant EG_MUON_DETA_DPHI_PRECISION: positive := max(EG_MUON_DETA_PRECISION, EG_MUON_DPHI_PRECISION);
constant JET_MUON_DETA_DPHI_PRECISION: positive := max(JET_MUON_DETA_PRECISION, JET_MUON_DPHI_PRECISION);
constant TAU_MUON_DETA_DPHI_PRECISION: positive := max(TAU_MUON_DETA_PRECISION, TAU_MUON_DPHI_PRECISION);
constant MUON_MUON_DETA_DPHI_PRECISION: positive := max(MUON_MUON_DETA_PRECISION, MUON_MUON_DPHI_PRECISION);
-- HB 2017-01-20: for correlation conditions v2
constant EG_MU_DETA_DPHI_PRECISION: positive := max(EG_MUON_DETA_PRECISION, EG_MUON_DPHI_PRECISION);
constant JET_MU_DETA_DPHI_PRECISION: positive := max(JET_MUON_DETA_PRECISION, JET_MUON_DPHI_PRECISION);
constant TAU_MU_DETA_DPHI_PRECISION: positive := max(TAU_MUON_DETA_PRECISION, TAU_MUON_DPHI_PRECISION);
constant MU_MU_DETA_DPHI_PRECISION: positive := max(MUON_MUON_DETA_PRECISION, MUON_MUON_DPHI_PRECISION);

constant MAX_DETA_DPHI_TEMP_1: positive := max(EG_EG_DETA_DPHI_PRECISION, EG_JET_DETA_DPHI_PRECISION, EG_TAU_DETA_DPHI_PRECISION);
constant MAX_DETA_DPHI_TEMP_2: positive := max(JET_JET_DETA_DPHI_PRECISION, JET_TAU_DETA_DPHI_PRECISION, TAU_TAU_DETA_DPHI_PRECISION);
constant MAX_DETA_DPHI_TEMP_3: positive := max(EG_MUON_DETA_DPHI_PRECISION, JET_MUON_DETA_DPHI_PRECISION, TAU_MUON_DETA_DPHI_PRECISION);
constant MAX_DETA_DPHI_TEMP_4: positive := max(MUON_MUON_DETA_DPHI_PRECISION, MAX_DETA_DPHI_TEMP_1, MAX_DETA_DPHI_TEMP_2);
constant DETA_DPHI_PRECISION_ALL: positive := max(MAX_DETA_DPHI_TEMP_3, MAX_DETA_DPHI_TEMP_4);

constant DETA_DPHI_VECTOR_WIDTH_ALL: positive := log2c(max(integer(ETA_RANGE_REAL*(real(10**DETA_DPHI_PRECISION_ALL))),integer(PHI_MAX*(real(10**DETA_DPHI_PRECISION_ALL))))); -- length of DETA/DPHI vector for Delta-R calculation
type deta_dphi_vector_array is array (natural range <>, natural range <>) of std_logic_vector(DETA_DPHI_VECTOR_WIDTH_ALL-1 downto 0);

-- subtypes for ranges of limits
subtype diff_eta_range_real is real range 0.0 to ETA_RANGE_REAL;
subtype diff_phi_range_real is real range 0.0 to PHI_MAX/2.0;
subtype dr_squared_range_real is real range 0.0 to ((ETA_RANGE_REAL*(real(10**DETA_DPHI_PRECISION_ALL)))**2+(PI*(real(10**DETA_DPHI_PRECISION_ALL))**2));

-- mass parameters

-- HB 2105-10-21: INV_MASS_LIMITS_PRECISION_ALL must be less than 2*INV_MASS_PT_PRECISION+INV_MASS_COSH_COS_PRECISION !!!
-- constant INV_MASS_LIMITS_PRECISION_ALL : positive range 1 to 3 := 1; -- 1 => first digit after decimal point
constant EG_EG_INV_MASS_PRECISION : positive range 1 to 3 := 1;
constant EG_JET_INV_MASS_PRECISION : positive range 1 to 3 := 1;
constant EG_TAU_INV_MASS_PRECISION : positive range 1 to 3 := 1;
constant JET_JET_INV_MASS_PRECISION : positive range 1 to 3 := 1;
constant JET_TAU_INV_MASS_PRECISION : positive range 1 to 3 := 1;
constant TAU_TAU_INV_MASS_PRECISION : positive range 1 to 3 := 1;
constant EG_MUON_INV_MASS_PRECISION : positive range 1 to 3 := 1;
constant JET_MUON_INV_MASS_PRECISION : positive range 1 to 3 := 1;
constant TAU_MUON_INV_MASS_PRECISION : positive range 1 to 3 := 1;
constant MUON_MUON_INV_MASS_PRECISION : positive range 1 to 3 := 1;

-- HB 2016-12-13: updated for mass (invariant or transverse).
constant EG_EG_MASS_PRECISION : positive range 1 to 3 := 1;
constant EG_JET_MASS_PRECISION : positive range 1 to 3 := 1;
constant EG_TAU_MASS_PRECISION : positive range 1 to 3 := 1;
constant JET_EG_MASS_PRECISION : positive range 1 to 3 := 1;
constant JET_JET_MASS_PRECISION : positive range 1 to 3 := 1;
constant JET_TAU_MASS_PRECISION : positive range 1 to 3 := 1;
constant TAU_EG_MASS_PRECISION : positive range 1 to 3 := 1;
constant TAU_JET_MASS_PRECISION : positive range 1 to 3 := 1;
constant TAU_TAU_MASS_PRECISION : positive range 1 to 3 := 1;
constant EG_MU_MASS_PRECISION : positive range 1 to 3 := 1;
constant JET_MU_MASS_PRECISION : positive range 1 to 3 := 1;
constant TAU_MU_MASS_PRECISION : positive range 1 to 3 := 1;
constant MU_MU_MASS_PRECISION : positive range 1 to 3 := 1;
constant EG_ETM_MASS_PRECISION : positive range 1 to 3 := 1;
constant JET_ETM_MASS_PRECISION : positive range 1 to 3 := 1;
constant TAU_ETM_MASS_PRECISION : positive range 1 to 3 := 1;
constant MU_ETM_MASS_PRECISION : positive range 1 to 3 := 1;
constant EG_ETMHF_MASS_PRECISION : positive range 1 to 3 := 1;
constant JET_ETMHF_MASS_PRECISION : positive range 1 to 3 := 1;
constant TAU_ETMHF_MASS_PRECISION : positive range 1 to 3 := 1;
constant MU_ETMHF_MASS_PRECISION : positive range 1 to 3 := 1;
constant EG_HTM_MASS_PRECISION : positive range 1 to 3 := 1;
constant JET_HTM_MASS_PRECISION : positive range 1 to 3 := 1;
constant TAU_HTM_MASS_PRECISION : positive range 1 to 3 := 1;
constant MU_HTM_MASS_PRECISION : positive range 1 to 3 := 1;

-- calo-calo-correlation
-- constant CALO_INV_MASS_PT_PRECISION : positive := 1;
constant EG_PT_PRECISION : positive := 1;
constant JET_PT_PRECISION : positive := 1;
constant TAU_PT_PRECISION : positive := 1;
constant ETM_PT_PRECISION : positive := 1;
constant ETMHF_PT_PRECISION : positive := 1;
constant HTM_PT_PRECISION : positive := 1;
constant ETM_PT_VECTOR_WIDTH: positive := log2c((2**(ETM_STRUCT.pt_h-ETM_STRUCT.pt_l+1)-1)*(10**ETM_PT_PRECISION));
constant ETMHF_PT_VECTOR_WIDTH: positive := log2c((2**(ETMHF_STRUCT.pt_h-ETMHF_STRUCT.pt_l+1)-1)*(10**ETMHF_PT_PRECISION));
constant HTM_PT_VECTOR_WIDTH: positive := log2c((2**(HTM_STRUCT.pt_h-HTM_STRUCT.pt_l+1)-1)*(10**HTM_PT_PRECISION));
-- constant EG_PT_VECTOR_WIDTH: positive := 12; -- max. value 255.5 GeV => 2555 (255.5 * 10**CALO_INV_MASS_PT_PRECISION) => 0x9FB
-- constant JET_PT_VECTOR_WIDTH: positive := 14; -- max. value 1023.5 GeV => 10235 (1023.5 * 10**CALO_INV_MASS_PT_PRECISION) => 0x27FB
-- constant TAU_PT_VECTOR_WIDTH: positive := 12; -- max. value 255.5 GeV => 2555 (255.5 * 10**CALO_INV_MASS_PT_PRECISION) => 0x9FB

-- constant CALO_INV_MASS_COSH_COS_PRECISION : positive := 3; -- 3 digits after decimal point (after roundimg to the 5th digit)
constant EG_EG_COSH_COS_PRECISION : positive := 3;
constant EG_JET_COSH_COS_PRECISION : positive := 3;
constant EG_TAU_COSH_COS_PRECISION : positive := 3;
constant JET_EG_COSH_COS_PRECISION : positive := 3;
constant JET_JET_COSH_COS_PRECISION : positive := 3;
constant JET_TAU_COSH_COS_PRECISION : positive := 3;
constant TAU_EG_COSH_COS_PRECISION : positive := 3;
constant TAU_JET_COSH_COS_PRECISION : positive := 3;
constant TAU_TAU_COSH_COS_PRECISION : positive := 3;
constant EG_ETM_COSH_COS_PRECISION : positive := 3;
constant JET_ETM_COSH_COS_PRECISION : positive := 3;
constant TAU_ETM_COSH_COS_PRECISION : positive := 3;
constant EG_ETMHF_COSH_COS_PRECISION : positive := 3;
constant JET_ETMHF_COSH_COS_PRECISION : positive := 3;
constant TAU_ETMHF_COSH_COS_PRECISION : positive := 3;
constant EG_HTM_COSH_COS_PRECISION : positive := 3;
constant JET_HTM_COSH_COS_PRECISION : positive := 3;
constant TAU_HTM_COSH_COS_PRECISION : positive := 3;

-- constant CALO_COSH_COS_VECTOR_WIDTH: positive := 24; -- max. value cosh_deta-cos_dphi => [10597282-(-1000)]=10598282 => 0xA1B78A
constant EG_EG_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000)); -- [10597282-(-1000)]=10598282 => 0xA1B78A
constant EG_JET_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000));
constant EG_TAU_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000));
constant JET_EG_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000));
constant JET_JET_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000));
constant JET_TAU_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000));
constant TAU_EG_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000));
constant TAU_JET_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000));
constant TAU_TAU_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000));
constant EG_ETM_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000));
constant EG_ETMHF_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000));
constant EG_HTM_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000));
constant JET_ETM_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000));
constant JET_ETMHF_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000));
constant JET_HTM_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000));
constant TAU_ETM_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000));
constant TAU_ETMHF_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000));
constant TAU_HTM_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000));
-- HB 2017-01-19: fix value for CALO_COSH_COS_VECTOR_WIDTH
constant CALO_COSH_COS_VECTOR_WIDTH: positive := log2c(10597282-(-1000));
type calo_cosh_cos_vector_array is array (natural range <>, natural range <>) of std_logic_vector(CALO_COSH_COS_VECTOR_WIDTH-1 downto 0);
constant CALO_CALO_COSH_COS_VECTOR_WIDTH: positive := CALO_COSH_COS_VECTOR_WIDTH;

-- HB 2016-12-13: Calos -> type definition for twobody-pt calculation
constant EG_ETM_PT_PRECISION : positive := 1;
constant JET_ETM_PT_PRECISION : positive := 1;
constant TAU_ETM_PT_PRECISION : positive := 1;
constant EG_ETMHF_PT_PRECISION : positive := 1;
constant JET_ETMHF_PT_PRECISION : positive := 1;
constant TAU_ETMHF_PT_PRECISION : positive := 1;
constant EG_HTM_PT_PRECISION : positive := 1;
constant JET_HTM_PT_PRECISION : positive := 1;
constant TAU_HTM_PT_PRECISION : positive := 1;
constant EG_EG_PT_PRECISION : positive := 1;
constant EG_JET_PT_PRECISION : positive := 1;
constant EG_TAU_PT_PRECISION : positive := 1;
constant JET_EG_PT_PRECISION : positive := 1;
constant JET_JET_PT_PRECISION : positive := 1;
constant JET_TAU_PT_PRECISION : positive := 1;
constant TAU_EG_PT_PRECISION : positive := 1;
constant TAU_JET_PT_PRECISION : positive := 1;
constant TAU_TAU_PT_PRECISION : positive := 1;
-- HB 2017-03-29: Calos -> calculation of cosine(phi) and sine(phi) for twobody-pt with 3 digits after decimal point
constant EG_ETM_SIN_COS_PRECISION : positive := 3;
constant JET_ETM_SIN_COS_PRECISION : positive := 3;
constant TAU_ETM_SIN_COS_PRECISION : positive := 3;
constant EG_ETMHF_SIN_COS_PRECISION : positive := 3;
constant JET_ETMHF_SIN_COS_PRECISION : positive := 3;
constant TAU_ETMHF_SIN_COS_PRECISION : positive := 3;
constant EG_HTM_SIN_COS_PRECISION : positive := 3;
constant JET_HTM_SIN_COS_PRECISION : positive := 3;
constant TAU_HTM_SIN_COS_PRECISION : positive := 3;
constant EG_EG_SIN_COS_PRECISION : positive := 3;
constant EG_JET_SIN_COS_PRECISION : positive := 3;
constant EG_TAU_SIN_COS_PRECISION : positive := 3;
constant JET_EG_SIN_COS_PRECISION : positive := 3;
constant JET_JET_SIN_COS_PRECISION : positive := 3;
constant JET_TAU_SIN_COS_PRECISION : positive := 3;
constant TAU_EG_SIN_COS_PRECISION : positive := 3;
constant TAU_JET_SIN_COS_PRECISION : positive := 3;
constant TAU_TAU_SIN_COS_PRECISION : positive := 3;
constant CALO_SIN_COS_VECTOR_WIDTH: positive := log2c(1000-(-1000));
type calo_sin_cos_vector_array is array (natural range <>) of std_logic_vector(CALO_SIN_COS_VECTOR_WIDTH-1 downto 0);

-- muon-muon-correlation
constant MUON_PT_PRECISION : positive := 1; -- 1 digit after decimal point
constant MUON_MUON_COSH_COS_PRECISION : positive := 4; -- 4 digits after decimal point (after roundimg to the 5th digit)
constant MUON_ETM_COSH_COS_PRECISION : positive := 4; -- 4 digits after decimal point (after roundimg to the 5th digit)
constant MUON_ETMHF_COSH_COS_PRECISION : positive := 4; -- 4 digits after decimal point (after roundimg to the 5th digit)
constant MUON_HTM_COSH_COS_PRECISION : positive := 4; -- 4 digits after decimal point (after roundimg to the 5th digit)
constant MU_MU_COSH_COS_PRECISION : positive := MUON_MUON_COSH_COS_PRECISION; -- 4 digits after decimal point (after roundimg to the 5th digit)
constant MU_ETM_COSH_COS_PRECISION : positive := MUON_ETM_COSH_COS_PRECISION;
constant MU_ETMHF_COSH_COS_PRECISION : positive := MUON_ETMHF_COSH_COS_PRECISION;
constant MU_HTM_COSH_COS_PRECISION : positive := MUON_HTM_COSH_COS_PRECISION;

-- constant MUON_PT_VECTOR_WIDTH: positive := log2c((2**(D_S_I_MUON_V2.pt_high-D_S_I_MUON_V2.pt_low+1)-1)*(10**MUON_PT_PRECISION)); -- max. value 255.5 GeV => 2555 => 0x9FB
-- constant MUON_PT_VECTOR_WIDTH: positive := 12; -- max. value 255.5 GeV => 2555 (255.5 * 10**MUON_INV_MASS_PT_PRECISION) => 0x9FB
constant MU_PT_VECTOR_WIDTH: positive := MUON_PT_VECTOR_WIDTH; -- dummy for VHDL-Producer output (correlation conditions)

constant MUON_MUON_COSH_COS_VECTOR_WIDTH: positive := log2c(677303); -- max. value cosh_deta-cos_dphi => [667303-(-10000)]=677303 => 0xA55B7 - highest value in LUT
constant MU_MU_COSH_COS_VECTOR_WIDTH: positive := MUON_MUON_COSH_COS_VECTOR_WIDTH; -- max. value cosh_deta-cos_dphi => [667303-(-10000)]=677303 => 0xA55B7 - highest value in LUT
-- constant MUON_MUON_COSH_COS_VECTOR_WIDTH: positive := 20; -- max. value cosh_deta-cos_dphi => [667303-(-10000)]=677303 => 0xA55B7
type muon_cosh_cos_vector_array is array (natural range <>, natural range <>) of std_logic_vector(MUON_MUON_COSH_COS_VECTOR_WIDTH-1 downto 0);

-- calo-muon-correlation
-- constant CALO_MUON_INV_MASS_PT_PRECISION : positive := 1; -- 1 digit after decimal point
-- constant CALO_MUON_INV_MASS_COSH_COS_PRECISION : positive := 4; -- 4 digits after decimal point (after roundimg to the 5th digit)
constant EG_MUON_COSH_COS_PRECISION : positive := 4;
constant JET_MUON_COSH_COS_PRECISION : positive := 4;
constant TAU_MUON_COSH_COS_PRECISION : positive := 4;
constant EG_MU_COSH_COS_PRECISION : positive := EG_MUON_COSH_COS_PRECISION;
constant JET_MU_COSH_COS_PRECISION : positive := JET_MUON_COSH_COS_PRECISION;
constant TAU_MU_COSH_COS_PRECISION : positive := TAU_MUON_COSH_COS_PRECISION;

-- constant CALO_MUON_COSH_COS_VECTOR_WIDTH: positive := log2c(109497199); -- = 27 -> max. value cosh_deta-cos_dphi => [109487199-(-10000)]=109497199 => 0x686CB6F
constant EG_MUON_COSH_COS_VECTOR_WIDTH: positive := log2c(109487199-(-10000));
constant JET_MUON_COSH_COS_VECTOR_WIDTH: positive := log2c(109487199-(-10000));
constant TAU_MUON_COSH_COS_VECTOR_WIDTH: positive := log2c(109487199-(-10000));
constant MUON_ETM_COSH_COS_VECTOR_WIDTH: positive := log2c(109487199-(-10000));
constant MUON_ETMHF_COSH_COS_VECTOR_WIDTH: positive := log2c(109487199-(-10000));
constant MUON_HTM_COSH_COS_VECTOR_WIDTH: positive := log2c(109487199-(-10000));
constant EG_MU_COSH_COS_VECTOR_WIDTH: positive := EG_MUON_COSH_COS_VECTOR_WIDTH;
constant JET_MU_COSH_COS_VECTOR_WIDTH: positive := JET_MUON_COSH_COS_VECTOR_WIDTH;
constant TAU_MU_COSH_COS_VECTOR_WIDTH: positive := TAU_MUON_COSH_COS_VECTOR_WIDTH;
constant MU_ETM_COSH_COS_VECTOR_WIDTH: positive := MUON_ETM_COSH_COS_VECTOR_WIDTH;
constant MU_ETMHF_COSH_COS_VECTOR_WIDTH: positive := MUON_ETMHF_COSH_COS_VECTOR_WIDTH;
constant MU_HTM_COSH_COS_VECTOR_WIDTH: positive := MUON_HTM_COSH_COS_VECTOR_WIDTH;
-- constant CALO_MUON_COSH_COS_VECTOR_WIDTH: positive := max(EG_MUON_COSH_COS_VECTOR_WIDTH, JET_MUON_COSH_COS_VECTOR_WIDTH, TAU_MUON_COSH_COS_VECTOR_WIDTH);
-- HB 2017-01-19: fix value for CALO_MUON_COSH_COS_VECTOR_WIDTH
constant CALO_MUON_COSH_COS_VECTOR_WIDTH: positive := log2c(109487199-(-10000));
type calo_muon_cosh_cos_vector_array is array (natural range <>, natural range <>) of std_logic_vector(CALO_MUON_COSH_COS_VECTOR_WIDTH-1 downto 0);

-- HB 2017-03-29: Muon -> type definition for twobody-pt calculation in mass_cuts.vhd
constant MU_ETM_PT_PRECISION : positive := 1;
constant MU_ETMHF_PT_PRECISION : positive := 1;
constant MU_HTM_PT_PRECISION : positive := 1;
constant EG_MU_PT_PRECISION : positive := 1;
constant JET_MU_PT_PRECISION : positive := 1;
constant TAU_MU_PT_PRECISION : positive := 1;
constant MU_MU_PT_PRECISION : positive := 1;
-- HB 2017-03-29: Muon -> calculation of cosine(phi) and sine(phi) for twobody-pt with 4 digits after decimal point
constant MU_ETM_SIN_COS_PRECISION : positive := 4;
constant MU_ETMHF_SIN_COS_PRECISION : positive := 4;
constant MU_HTM_SIN_COS_PRECISION : positive := 4;
constant EG_MU_SIN_COS_PRECISION : positive := 4;
constant JET_MU_SIN_COS_PRECISION : positive := 4;
constant TAU_MU_SIN_COS_PRECISION : positive := 4;
constant MU_MU_SIN_COS_PRECISION : positive := 4;
-- constant MUON_SIN_COS_VECTOR_WIDTH: positive := log2c(1000-(-1000));
constant MUON_SIN_COS_VECTOR_WIDTH: positive := log2c(10000-(-10000));
type muon_sin_cos_vector_array is array (natural range <>) of std_logic_vector(MUON_SIN_COS_VECTOR_WIDTH-1 downto 0);

-- subtypes used in sub_eta_integer_obj_vs_obj.vhd and sub_phi_integer_obj_vs_obj
subtype max_eta_range_integer is integer range 0 to integer(ETA_RANGE_REAL/MUON_ETA_STEP)-1; -- 10.0/0.010875 = 919.54 => rounded(919.54) = 920 - number of bins with muon bin width for full (calo) eta range
type dim2_max_eta_range_array is array (natural range <>, natural range <>) of max_eta_range_integer;
subtype max_phi_range_integer is integer range 0 to max(MUON_PHI_BINS, CALO_PHI_BINS)-1; -- number of bins with muon bin width (=576)
type dim2_max_phi_range_array is array (natural range <>, natural range <>) of max_phi_range_integer;

-- HB 2017-10-02: Max. vector width for limits of correlation cuts
constant MAX_WIDTH_DETA_DPHI_LIMIT_VECTOR : positive := 32;
constant MAX_WIDTH_DR_LIMIT_VECTOR : positive := 64;
constant MAX_WIDTH_MASS_LIMIT_VECTOR : positive := 64;
constant MAX_WIDTH_TBPT_LIMIT_VECTOR : positive := 64;

-- ********************************************************
-- conversion LUTs
type calo_eta_conv_2_muon_eta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of integer range -510 to 510;
-- type eg_eta_conv_2_muon_eta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of integer range -510 to 510;
-- type jet_eta_conv_2_muon_eta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of integer range -510 to 510;
-- type tau_eta_conv_2_muon_eta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of integer range -510 to 510;

constant CALO_ETA_CONV_2_MUON_ETA_LUT : calo_eta_conv_2_muon_eta_lut_array := (
2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62,
66, 70, 74, 78, 82, 86, 90, 94, 98, 102, 106, 110, 114, 118, 122, 126,
130, 134, 138, 142, 146, 150, 154, 158, 162, 166, 170, 174, 178, 182, 186, 190,
194, 198, 202, 206, 210, 214, 218, 222, 226, 230, 234, 238, 242, 246, 250, 254,
258, 262, 266, 270, 274, 278, 282, 286, 290, 294, 298, 302, 306, 310, 314, 318,
322, 326, 330, 334, 338, 342, 346, 350, 354, 358, 362, 366, 370, 374, 378, 382,
386, 390, 394, 398, 402, 406, 410, 414, 418, 422, 426, 430, 434, 438, 442, 446,
450, 454, 458, 462, 466, 470, 474, 478, 482, 486, 490, 494, 498, 502, 506, 510,
-510, -506, -502, -498, -494, -490, -486, -482, -478, -474, -470, -466, -462, -458, -454, -450,
-446, -442, -438, -434, -430, -426, -422, -418, -414, -410, -406, -402, -398, -394, -390, -386,
-382, -378, -374, -370, -366, -362, -358, -354, -350, -346, -342, -338, -334, -330, -326, -322,
-318, -314, -310, -306, -302, -298, -294, -290, -286, -282, -278, -274, -270, -266, -262, -258,
-254, -250, -246, -242, -238, -234, -230, -226, -222, -218, -214, -210, -206, -202, -198, -194,
-190, -186, -182, -178, -174, -170, -166, -162, -158, -154, -150, -146, -142, -138, -134, -130,
-126, -122, -118, -114, -110, -106, -102, -98, -94, -90, -86, -82, -78, -74, -70, -66,
-62, -58, -54, -50, -46, -42, -38, -34, -30, -26, -22, -18, -14, -10, -6, -2
);

constant EG_ETA_CONV_2_MUON_ETA_LUT : calo_eta_conv_2_muon_eta_lut_array := CALO_ETA_CONV_2_MUON_ETA_LUT;
constant TAU_ETA_CONV_2_MUON_ETA_LUT : calo_eta_conv_2_muon_eta_lut_array := CALO_ETA_CONV_2_MUON_ETA_LUT;
constant JET_ETA_CONV_2_MUON_ETA_LUT : calo_eta_conv_2_muon_eta_lut_array := CALO_ETA_CONV_2_MUON_ETA_LUT;

type calo_phi_conv_2_muon_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range 0 to 574;
-- type eg_phi_conv_2_muon_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range 0 to 574;
-- type jet_phi_conv_2_muon_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range 0 to 574;
-- type tau_phi_conv_2_muon_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range 0 to 574;
-- type etm_phi_conv_2_muon_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range 0 to 574;
-- type etmhf_phi_conv_2_muon_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range 0 to 574;
-- type htm_phi_conv_2_muon_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range 0 to 574;

constant CALO_PHI_CONV_2_MUON_PHI_LUT : calo_phi_conv_2_muon_phi_lut_array := (
2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62,
66, 70, 74, 78, 82, 86, 90, 94, 98, 102, 106, 110, 114, 118, 122, 126,
130, 134, 138, 142, 146, 150, 154, 158, 162, 166, 170, 174, 178, 182, 186, 190,
194, 198, 202, 206, 210, 214, 218, 222, 226, 230, 234, 238, 242, 246, 250, 254,
258, 262, 266, 270, 274, 278, 282, 286, 290, 294, 298, 302, 306, 310, 314, 318,
322, 326, 330, 334, 338, 342, 346, 350, 354, 358, 362, 366, 370, 374, 378, 382,
386, 390, 394, 398, 402, 406, 410, 414, 418, 422, 426, 430, 434, 438, 442, 446,
450, 454, 458, 462, 466, 470, 474, 478, 482, 486, 490, 494, 498, 502, 506, 510,
514, 518, 522, 526, 530, 534, 538, 542, 546, 550, 554, 558, 562, 566, 570, 574,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

constant EG_PHI_CONV_2_MUON_PHI_LUT : calo_phi_conv_2_muon_phi_lut_array := CALO_PHI_CONV_2_MUON_PHI_LUT;
constant TAU_PHI_CONV_2_MUON_PHI_LUT : calo_phi_conv_2_muon_phi_lut_array := CALO_PHI_CONV_2_MUON_PHI_LUT;
constant JET_PHI_CONV_2_MUON_PHI_LUT : calo_phi_conv_2_muon_phi_lut_array := CALO_PHI_CONV_2_MUON_PHI_LUT;
constant HTM_PHI_CONV_2_MUON_PHI_LUT : calo_phi_conv_2_muon_phi_lut_array := CALO_PHI_CONV_2_MUON_PHI_LUT;
constant ETM_PHI_CONV_2_MUON_PHI_LUT : calo_phi_conv_2_muon_phi_lut_array := CALO_PHI_CONV_2_MUON_PHI_LUT;
constant ETMHF_PHI_CONV_2_MUON_PHI_LUT : calo_phi_conv_2_muon_phi_lut_array := CALO_PHI_CONV_2_MUON_PHI_LUT;

-- ********************************************************
-- delta LUTs

-- calo-calo differences LUTs
type calo_calo_diff_eta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range 0 to 9962;
-- type eg_eg_diff_eta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range 0 to 9962;
-- type eg_jet_diff_eta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range 0 to 9962;
-- type eg_tau_diff_eta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range 0 to 9962;
-- type jet_jet_diff_eta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range 0 to 9962;
-- type jet_tau_diff_eta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range 0 to 9962;
-- type tau_tau_diff_eta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range 0 to 9962;

constant CALO_CALO_DIFF_ETA_LUT : calo_calo_diff_eta_lut_array := (
0, 44, 87, 131, 174, 217, 261, 305, 348, 391, 435, 479, 522, 566, 609, 653,
696, 739, 783, 826, 870, 914, 957, 1001, 1044, 1088, 1131, 1174, 1218, 1261, 1305, 1348,
1392, 1436, 1479, 1523, 1566, 1610, 1653, 1697, 1740, 1783, 1827, 1870, 1914, 1957, 2001, 2044,
2088, 2132, 2175, 2218, 2262, 2306, 2349, 2392, 2436, 2480, 2523, 2567, 2610, 2653, 2697, 2741,
2784, 2827, 2871, 2915, 2958, 3001, 3045, 3089, 3132, 3176, 3219, 3262, 3306, 3350, 3393, 3436,
3480, 3524, 3567, 3610, 3654, 3698, 3741, 3784, 3828, 3871, 3915, 3959, 4002, 4045, 4089, 4132,
4176, 4220, 4263, 4307, 4350, 4393, 4437, 4480, 4524, 4568, 4611, 4655, 4698, 4741, 4785, 4829,
4872, 4916, 4959, 5002, 5046, 5089, 5133, 5177, 5220, 5264, 5307, 5350, 5394, 5438, 5481, 5525,
5568, 5611, 5655, 5698, 5742, 5786, 5829, 5873, 5916, 5959, 6003, 6047, 6090, 6134, 6177, 6220,
6264, 6307, 6351, 6395, 6438, 6482, 6525, 6568, 6612, 6656, 6699, 6743, 6786, 6829, 6873, 6916,
6960, 7004, 7047, 7091, 7134, 7177, 7221, 7264, 7308, 7352, 7395, 7438, 7482, 7525, 7569, 7613,
7656, 7700, 7743, 7786, 7830, 7873, 7917, 7961, 8004, 8047, 8091, 8134, 8178, 8221, 8265, 8308,
8352, 8396, 8439, 8483, 8526, 8570, 8613, 8657, 8700, 8744, 8787, 8830, 8874, 8917, 8961, 9005,
9048, 9092, 9135, 9179, 9222, 9266, 9309, 9353, 9396, 9439, 9483, 9526, 9570, 9614, 9657, 9701,
9744, 9788, 9831, 9875, 9918, 9962, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

constant EG_EG_DIFF_ETA_LUT : calo_calo_diff_eta_lut_array := CALO_CALO_DIFF_ETA_LUT;
constant EG_TAU_DIFF_ETA_LUT : calo_calo_diff_eta_lut_array := CALO_CALO_DIFF_ETA_LUT;
constant EG_JET_DIFF_ETA_LUT : calo_calo_diff_eta_lut_array := CALO_CALO_DIFF_ETA_LUT;
constant JET_EG_DIFF_ETA_LUT : calo_calo_diff_eta_lut_array := CALO_CALO_DIFF_ETA_LUT;
constant JET_JET_DIFF_ETA_LUT : calo_calo_diff_eta_lut_array := CALO_CALO_DIFF_ETA_LUT;
constant JET_TAU_DIFF_ETA_LUT : calo_calo_diff_eta_lut_array := CALO_CALO_DIFF_ETA_LUT;
constant TAU_EG_DIFF_ETA_LUT : calo_calo_diff_eta_lut_array := CALO_CALO_DIFF_ETA_LUT;
constant TAU_JET_DIFF_ETA_LUT : calo_calo_diff_eta_lut_array := CALO_CALO_DIFF_ETA_LUT;
constant TAU_TAU_DIFF_ETA_LUT : calo_calo_diff_eta_lut_array := CALO_CALO_DIFF_ETA_LUT;

type calo_calo_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range 0 to 6240;
-- type eg_eg_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range 0 to 6240;
-- type eg_jet_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range 0 to 6240;
-- type eg_tau_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range 0 to 6240;
-- type jet_jet_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range 0 to 6240;
-- type jet_tau_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range 0 to 6240;
-- type tau_tau_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range 0 to 6240;

constant CALO_CALO_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := (
0, 44, 87, 131, 175, 218, 262, 305, 349, 393, 436, 480, 524, 567, 611, 654,
698, 742, 785, 829, 873, 916, 960, 1004, 1047, 1091, 1134, 1178, 1222, 1265, 1309, 1353,
1396, 1440, 1484, 1527, 1571, 1614, 1658, 1702, 1745, 1789, 1833, 1876, 1920, 1963, 2007, 2051,
2094, 2138, 2182, 2225, 2269, 2313, 2356, 2400, 2443, 2487, 2531, 2574, 2618, 2662, 2705, 2749,
2793, 2836, 2880, 2923, 2967, 3011, 3054, 3098, 3142, 3185, 3229, 3272, 3316, 3360, 3403, 3447,
3491, 3534, 3578, 3622, 3665, 3709, 3752, 3796, 3840, 3883, 3927, 3971, 4014, 4058, 4102, 4145,
4189, 4232, 4276, 4320, 4363, 4407, 4451, 4494, 4538, 4581, 4625, 4669, 4712, 4756, 4800, 4843,
4887, 4931, 4974, 5018, 5061, 5105, 5149, 5192, 5236, 5280, 5323, 5367, 5411, 5454, 5498, 5541,
5585, 5629, 5672, 5716, 5760, 5803, 5847, 5890, 5934, 5978, 6021, 6065, 6109, 6152, 6196, 6240,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

constant EG_EG_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := CALO_CALO_DIFF_PHI_LUT;
constant EG_TAU_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := CALO_CALO_DIFF_PHI_LUT;
constant EG_JET_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := CALO_CALO_DIFF_PHI_LUT;
constant JET_EG_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := CALO_CALO_DIFF_PHI_LUT;
constant JET_JET_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := CALO_CALO_DIFF_PHI_LUT;
constant JET_TAU_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := CALO_CALO_DIFF_PHI_LUT;
constant TAU_EG_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := CALO_CALO_DIFF_PHI_LUT;
constant TAU_JET_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := CALO_CALO_DIFF_PHI_LUT;
constant TAU_TAU_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := CALO_CALO_DIFF_PHI_LUT;

-- calo-esums differences LUTs
-- type eg_etm_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range 0 to 6240;
-- type jet_etm_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range 0 to 6240;
-- type tau_etm_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range 0 to 6240;
-- type eg_etmhf_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range 0 to 6240;
-- type jet_etmhf_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range 0 to 6240;
-- type tau_etmhf_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range 0 to 6240;
-- type eg_htm_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range 0 to 6240;
-- type jet_htm_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range 0 to 6240;
-- type tau_htm_diff_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of natural range 0 to 6240;

constant EG_HTM_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := CALO_CALO_DIFF_PHI_LUT;
constant EG_ETM_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := CALO_CALO_DIFF_PHI_LUT;
constant EG_ETMHF_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := CALO_CALO_DIFF_PHI_LUT;
constant TAU_HTM_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := CALO_CALO_DIFF_PHI_LUT;
constant TAU_ETM_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := CALO_CALO_DIFF_PHI_LUT;
constant TAU_ETMHF_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := CALO_CALO_DIFF_PHI_LUT;
constant JET_HTM_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := CALO_CALO_DIFF_PHI_LUT;
constant JET_ETM_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := CALO_CALO_DIFF_PHI_LUT;
constant JET_ETMHF_DIFF_PHI_LUT : calo_calo_diff_phi_lut_array := CALO_CALO_DIFF_PHI_LUT;

-- muon-muon differences LUTs
type muon_muon_diff_eta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1)-1) of natural range 0 to 4894;

constant MU_MU_DIFF_ETA_LUT : muon_muon_diff_eta_lut_array := (
0, 11, 22, 33, 44, 54, 65, 76, 87, 98, 109, 120, 131, 141, 152, 163,
174, 185, 196, 207, 217, 228, 239, 250, 261, 272, 283, 294, 305, 315, 326, 337,
348, 359, 370, 381, 391, 402, 413, 424, 435, 446, 457, 468, 479, 489, 500, 511,
522, 533, 544, 555, 566, 576, 587, 598, 609, 620, 631, 642, 653, 663, 674, 685,
696, 707, 718, 729, 739, 750, 761, 772, 783, 794, 805, 816, 826, 837, 848, 859,
870, 881, 892, 903, 914, 924, 935, 946, 957, 968, 979, 990, 1001, 1011, 1022, 1033,
1044, 1055, 1066, 1077, 1088, 1098, 1109, 1120, 1131, 1142, 1153, 1164, 1174, 1185, 1196, 1207,
1218, 1229, 1240, 1251, 1261, 1272, 1283, 1294, 1305, 1316, 1327, 1338, 1348, 1359, 1370, 1381,
1392, 1403, 1414, 1425, 1436, 1446, 1457, 1468, 1479, 1490, 1501, 1512, 1523, 1533, 1544, 1555,
1566, 1577, 1588, 1599, 1610, 1620, 1631, 1642, 1653, 1664, 1675, 1686, 1697, 1707, 1718, 1729,
1740, 1751, 1762, 1773, 1783, 1794, 1805, 1816, 1827, 1838, 1849, 1860, 1870, 1881, 1892, 1903,
1914, 1925, 1936, 1947, 1957, 1968, 1979, 1990, 2001, 2012, 2023, 2034, 2044, 2055, 2066, 2077,
2088, 2099, 2110, 2121, 2132, 2142, 2153, 2164, 2175, 2186, 2197, 2208, 2218, 2229, 2240, 2251,
2262, 2273, 2284, 2295, 2306, 2316, 2327, 2338, 2349, 2360, 2371, 2382, 2392, 2403, 2414, 2425,
2436, 2447, 2458, 2469, 2480, 2490, 2501, 2512, 2523, 2534, 2545, 2556, 2567, 2577, 2588, 2599,
2610, 2621, 2632, 2643, 2653, 2664, 2675, 2686, 2697, 2708, 2719, 2730, 2741, 2751, 2762, 2773,
2784, 2795, 2806, 2817, 2827, 2838, 2849, 2860, 2871, 2882, 2893, 2904, 2915, 2925, 2936, 2947,
2958, 2969, 2980, 2991, 3001, 3012, 3023, 3034, 3045, 3056, 3067, 3078, 3089, 3099, 3110, 3121,
3132, 3143, 3154, 3165, 3176, 3186, 3197, 3208, 3219, 3230, 3241, 3252, 3262, 3273, 3284, 3295,
3306, 3317, 3328, 3339, 3350, 3360, 3371, 3382, 3393, 3404, 3415, 3426, 3436, 3447, 3458, 3469,
3480, 3491, 3502, 3513, 3524, 3534, 3545, 3556, 3567, 3578, 3589, 3600, 3610, 3621, 3632, 3643,
3654, 3665, 3676, 3687, 3698, 3708, 3719, 3730, 3741, 3752, 3763, 3774, 3784, 3795, 3806, 3817,
3828, 3839, 3850, 3861, 3871, 3882, 3893, 3904, 3915, 3926, 3937, 3948, 3959, 3969, 3980, 3991,
4002, 4013, 4024, 4035, 4045, 4056, 4067, 4078, 4089, 4100, 4111, 4122, 4132, 4143, 4154, 4165,
4176, 4187, 4198, 4209, 4220, 4230, 4241, 4252, 4263, 4274, 4285, 4296, 4307, 4317, 4328, 4339,
4350, 4361, 4372, 4383, 4393, 4404, 4415, 4426, 4437, 4448, 4459, 4470, 4480, 4491, 4502, 4513,
4524, 4535, 4546, 4557, 4568, 4578, 4589, 4600, 4611, 4622, 4633, 4644, 4655, 4665, 4676, 4687,
4698, 4709, 4720, 4731, 4741, 4752, 4763, 4774, 4785, 4796, 4807, 4818, 4829, 4839, 4850, 4861,
4872, 4883, 4894, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

type muon_muon_diff_phi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of natural range 0 to 6272;

constant MU_MU_DIFF_PHI_LUT : muon_muon_diff_phi_lut_array := (
0, 11, 22, 33, 44, 55, 65, 76, 87, 98, 109, 120, 131, 142, 153, 164,
175, 185, 196, 207, 218, 229, 240, 251, 262, 273, 284, 295, 305, 316, 327, 338,
349, 360, 371, 382, 393, 404, 415, 425, 436, 447, 458, 469, 480, 491, 502, 513,
524, 535, 545, 556, 567, 578, 589, 600, 611, 622, 633, 644, 654, 665, 676, 687,
698, 709, 720, 731, 742, 753, 764, 774, 785, 796, 807, 818, 829, 840, 851, 862,
873, 884, 894, 905, 916, 927, 938, 949, 960, 971, 982, 993, 1004, 1014, 1025, 1036,
1047, 1058, 1069, 1080, 1091, 1102, 1113, 1124, 1134, 1145, 1156, 1167, 1178, 1189, 1200, 1211,
1222, 1233, 1244, 1254, 1265, 1276, 1287, 1298, 1309, 1320, 1331, 1342, 1353, 1364, 1374, 1385,
1396, 1407, 1418, 1429, 1440, 1451, 1462, 1473, 1484, 1494, 1505, 1516, 1527, 1538, 1549, 1560,
1571, 1582, 1593, 1604, 1614, 1625, 1636, 1647, 1658, 1669, 1680, 1691, 1702, 1713, 1724, 1734,
1745, 1756, 1767, 1778, 1789, 1800, 1811, 1822, 1833, 1844, 1854, 1865, 1876, 1887, 1898, 1909,
1920, 1931, 1942, 1953, 1963, 1974, 1985, 1996, 2007, 2018, 2029, 2040, 2051, 2062, 2073, 2083,
2094, 2105, 2116, 2127, 2138, 2149, 2160, 2171, 2182, 2193, 2203, 2214, 2225, 2236, 2247, 2258,
2269, 2280, 2291, 2302, 2313, 2323, 2334, 2345, 2356, 2367, 2378, 2389, 2400, 2411, 2422, 2433,
2443, 2454, 2465, 2476, 2487, 2498, 2509, 2520, 2531, 2542, 2553, 2563, 2574, 2585, 2596, 2607,
2618, 2629, 2640, 2651, 2662, 2673, 2683, 2694, 2705, 2716, 2727, 2738, 2749, 2760, 2771, 2782,
2793, 2803, 2814, 2825, 2836, 2847, 2858, 2869, 2880, 2891, 2902, 2913, 2923, 2934, 2945, 2956,
2967, 2978, 2989, 3000, 3011, 3022, 3033, 3043, 3054, 3065, 3076, 3087, 3098, 3109, 3120, 3131,
3142, 3153, 3163, 3174, 3185, 3196, 3207, 3218, 3229, 3240, 3251, 3262, 3272, 3283, 3294, 3305,
3316, 3327, 3338, 3349, 3360, 3371, 3382, 3392, 3403, 3414, 3425, 3436, 3447, 3458, 3469, 3480,
3491, 3502, 3512, 3523, 3534, 3545, 3556, 3567, 3578, 3589, 3600, 3611, 3622, 3632, 3643, 3654,
3665, 3676, 3687, 3698, 3709, 3720, 3731, 3742, 3752, 3763, 3774, 3785, 3796, 3807, 3818, 3829,
3840, 3851, 3862, 3872, 3883, 3894, 3905, 3916, 3927, 3938, 3949, 3960, 3971, 3982, 3992, 4003,
4014, 4025, 4036, 4047, 4058, 4069, 4080, 4091, 4102, 4112, 4123, 4134, 4145, 4156, 4167, 4178,
4189, 4200, 4211, 4222, 4232, 4243, 4254, 4265, 4276, 4287, 4298, 4309, 4320, 4331, 4342, 4352,
4363, 4374, 4385, 4396, 4407, 4418, 4429, 4440, 4451, 4461, 4472, 4483, 4494, 4505, 4516, 4527,
4538, 4549, 4560, 4571, 4581, 4592, 4603, 4614, 4625, 4636, 4647, 4658, 4669, 4680, 4691, 4701,
4712, 4723, 4734, 4745, 4756, 4767, 4778, 4789, 4800, 4811, 4821, 4832, 4843, 4854, 4865, 4876,
4887, 4898, 4909, 4920, 4931, 4941, 4952, 4963, 4974, 4985, 4996, 5007, 5018, 5029, 5040, 5051,
5061, 5072, 5083, 5094, 5105, 5116, 5127, 5138, 5149, 5160, 5171, 5181, 5192, 5203, 5214, 5225,
5236, 5247, 5258, 5269, 5280, 5291, 5301, 5312, 5323, 5334, 5345, 5356, 5367, 5378, 5389, 5400,
5411, 5421, 5432, 5443, 5454, 5465, 5476, 5487, 5498, 5509, 5520, 5531, 5541, 5552, 5563, 5574,
5585, 5596, 5607, 5618, 5629, 5640, 5651, 5661, 5672, 5683, 5694, 5705, 5716, 5727, 5738, 5749,
5760, 5770, 5781, 5792, 5803, 5814, 5825, 5836, 5847, 5858, 5869, 5880, 5890, 5901, 5912, 5923,
5934, 5945, 5956, 5967, 5978, 5989, 6000, 6010, 6021, 6032, 6043, 6054, 6065, 6076, 6087, 6098,
6109, 6120, 6130, 6141, 6152, 6163, 6174, 6185, 6196, 6207, 6218, 6229, 6240, 6250, 6261, 6272,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

-- calo-muon differences LUTs
type calo_muon_diff_eta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1+1)-1) of natural range 0 to 9994;
-- type eg_muon_diff_eta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1+1)-1) of natural range 0 to 9994;
-- type jet_muon_diff_eta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1+1)-1) of natural range 0 to 9994;
-- type tau_muon_diff_eta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1+1)-1) of natural range 0 to 9994;

constant CALO_MU_DIFF_ETA_LUT : calo_muon_diff_eta_lut_array := (
0, 11, 22, 33, 44, 54, 65, 76, 87, 98, 109, 120, 131, 141, 152, 163,
174, 185, 196, 207, 217, 228, 239, 250, 261, 272, 283, 294, 305, 315, 326, 337,
348, 359, 370, 381, 391, 402, 413, 424, 435, 446, 457, 468, 479, 489, 500, 511,
522, 533, 544, 555, 566, 576, 587, 598, 609, 620, 631, 642, 653, 663, 674, 685,
696, 707, 718, 729, 739, 750, 761, 772, 783, 794, 805, 816, 826, 837, 848, 859,
870, 881, 892, 903, 914, 924, 935, 946, 957, 968, 979, 990, 1001, 1011, 1022, 1033,
1044, 1055, 1066, 1077, 1088, 1098, 1109, 1120, 1131, 1142, 1153, 1164, 1174, 1185, 1196, 1207,
1218, 1229, 1240, 1251, 1261, 1272, 1283, 1294, 1305, 1316, 1327, 1338, 1348, 1359, 1370, 1381,
1392, 1403, 1414, 1425, 1436, 1446, 1457, 1468, 1479, 1490, 1501, 1512, 1523, 1533, 1544, 1555,
1566, 1577, 1588, 1599, 1610, 1620, 1631, 1642, 1653, 1664, 1675, 1686, 1697, 1707, 1718, 1729,
1740, 1751, 1762, 1773, 1783, 1794, 1805, 1816, 1827, 1838, 1849, 1860, 1870, 1881, 1892, 1903,
1914, 1925, 1936, 1947, 1957, 1968, 1979, 1990, 2001, 2012, 2023, 2034, 2044, 2055, 2066, 2077,
2088, 2099, 2110, 2121, 2132, 2142, 2153, 2164, 2175, 2186, 2197, 2208, 2218, 2229, 2240, 2251,
2262, 2273, 2284, 2295, 2306, 2316, 2327, 2338, 2349, 2360, 2371, 2382, 2392, 2403, 2414, 2425,
2436, 2447, 2458, 2469, 2480, 2490, 2501, 2512, 2523, 2534, 2545, 2556, 2567, 2577, 2588, 2599,
2610, 2621, 2632, 2643, 2653, 2664, 2675, 2686, 2697, 2708, 2719, 2730, 2741, 2751, 2762, 2773,
2784, 2795, 2806, 2817, 2827, 2838, 2849, 2860, 2871, 2882, 2893, 2904, 2915, 2925, 2936, 2947,
2958, 2969, 2980, 2991, 3001, 3012, 3023, 3034, 3045, 3056, 3067, 3078, 3089, 3099, 3110, 3121,
3132, 3143, 3154, 3165, 3176, 3186, 3197, 3208, 3219, 3230, 3241, 3252, 3262, 3273, 3284, 3295,
3306, 3317, 3328, 3339, 3350, 3360, 3371, 3382, 3393, 3404, 3415, 3426, 3436, 3447, 3458, 3469,
3480, 3491, 3502, 3513, 3524, 3534, 3545, 3556, 3567, 3578, 3589, 3600, 3610, 3621, 3632, 3643,
3654, 3665, 3676, 3687, 3698, 3708, 3719, 3730, 3741, 3752, 3763, 3774, 3784, 3795, 3806, 3817,
3828, 3839, 3850, 3861, 3871, 3882, 3893, 3904, 3915, 3926, 3937, 3948, 3959, 3969, 3980, 3991,
4002, 4013, 4024, 4035, 4045, 4056, 4067, 4078, 4089, 4100, 4111, 4122, 4132, 4143, 4154, 4165,
4176, 4187, 4198, 4209, 4220, 4230, 4241, 4252, 4263, 4274, 4285, 4296, 4307, 4317, 4328, 4339,
4350, 4361, 4372, 4383, 4393, 4404, 4415, 4426, 4437, 4448, 4459, 4470, 4480, 4491, 4502, 4513,
4524, 4535, 4546, 4557, 4568, 4578, 4589, 4600, 4611, 4622, 4633, 4644, 4655, 4665, 4676, 4687,
4698, 4709, 4720, 4731, 4741, 4752, 4763, 4774, 4785, 4796, 4807, 4818, 4829, 4839, 4850, 4861,
4872, 4883, 4894, 4905, 4916, 4926, 4937, 4948, 4959, 4970, 4981, 4992, 5002, 5013, 5024, 5035,
5046, 5057, 5068, 5079, 5089, 5100, 5111, 5122, 5133, 5144, 5155, 5166, 5177, 5187, 5198, 5209,
5220, 5231, 5242, 5253, 5264, 5274, 5285, 5296, 5307, 5318, 5329, 5340, 5350, 5361, 5372, 5383,
5394, 5405, 5416, 5427, 5438, 5448, 5459, 5470, 5481, 5492, 5503, 5514, 5525, 5535, 5546, 5557,
5568, 5579, 5590, 5601, 5611, 5622, 5633, 5644, 5655, 5666, 5677, 5688, 5698, 5709, 5720, 5731,
5742, 5753, 5764, 5775, 5786, 5796, 5807, 5818, 5829, 5840, 5851, 5862, 5873, 5883, 5894, 5905,
5916, 5927, 5938, 5949, 5959, 5970, 5981, 5992, 6003, 6014, 6025, 6036, 6047, 6057, 6068, 6079,
6090, 6101, 6112, 6123, 6134, 6144, 6155, 6166, 6177, 6188, 6199, 6210, 6220, 6231, 6242, 6253,
6264, 6275, 6286, 6297, 6307, 6318, 6329, 6340, 6351, 6362, 6373, 6384, 6395, 6405, 6416, 6427,
6438, 6449, 6460, 6471, 6482, 6492, 6503, 6514, 6525, 6536, 6547, 6558, 6568, 6579, 6590, 6601,
6612, 6623, 6634, 6645, 6656, 6666, 6677, 6688, 6699, 6710, 6721, 6732, 6743, 6753, 6764, 6775,
6786, 6797, 6808, 6819, 6829, 6840, 6851, 6862, 6873, 6884, 6895, 6906, 6916, 6927, 6938, 6949,
6960, 6971, 6982, 6993, 7004, 7014, 7025, 7036, 7047, 7058, 7069, 7080, 7091, 7101, 7112, 7123,
7134, 7145, 7156, 7167, 7177, 7188, 7199, 7210, 7221, 7232, 7243, 7254, 7264, 7275, 7286, 7297,
7308, 7319, 7330, 7341, 7352, 7362, 7373, 7384, 7395, 7406, 7417, 7428, 7438, 7449, 7460, 7471,
7482, 7493, 7504, 7515, 7525, 7536, 7547, 7558, 7569, 7580, 7591, 7602, 7613, 7623, 7634, 7645,
7656, 7667, 7678, 7689, 7700, 7710, 7721, 7732, 7743, 7754, 7765, 7776, 7786, 7797, 7808, 7819,
7830, 7841, 7852, 7863, 7873, 7884, 7895, 7906, 7917, 7928, 7939, 7950, 7961, 7971, 7982, 7993,
8004, 8015, 8026, 8037, 8047, 8058, 8069, 8080, 8091, 8102, 8113, 8124, 8134, 8145, 8156, 8167,
8178, 8189, 8200, 8211, 8221, 8232, 8243, 8254, 8265, 8276, 8287, 8298, 8308, 8319, 8330, 8341,
8352, 8363, 8374, 8385, 8396, 8406, 8417, 8428, 8439, 8450, 8461, 8472, 8483, 8493, 8504, 8515,
8526, 8537, 8548, 8559, 8570, 8580, 8591, 8602, 8613, 8624, 8635, 8646, 8657, 8667, 8678, 8689,
8700, 8711, 8722, 8733, 8744, 8754, 8765, 8776, 8787, 8798, 8809, 8820, 8830, 8841, 8852, 8863,
8874, 8885, 8896, 8907, 8917, 8928, 8939, 8950, 8961, 8972, 8983, 8994, 9005, 9015, 9026, 9037,
9048, 9059, 9070, 9081, 9092, 9102, 9113, 9124, 9135, 9146, 9157, 9168, 9179, 9189, 9200, 9211,
9222, 9233, 9244, 9255, 9266, 9276, 9287, 9298, 9309, 9320, 9331, 9342, 9353, 9363, 9374, 9385,
9396, 9407, 9418, 9429, 9439, 9450, 9461, 9472, 9483, 9494, 9505, 9516, 9526, 9537, 9548, 9559,
9570, 9581, 9592, 9603, 9614, 9624, 9635, 9646, 9657, 9668, 9679, 9690, 9701, 9711, 9722, 9733,
9744, 9755, 9766, 9777, 9788, 9798, 9809, 9820, 9831, 9842, 9853, 9864, 9875, 9885, 9896, 9907,
9918, 9929, 9940, 9951, 9962, 9972, 9983, 9994, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

constant EG_MU_DIFF_ETA_LUT : calo_muon_diff_eta_lut_array := CALO_MU_DIFF_ETA_LUT;
constant TAU_MU_DIFF_ETA_LUT : calo_muon_diff_eta_lut_array := CALO_MU_DIFF_ETA_LUT;
constant JET_MU_DIFF_ETA_LUT : calo_muon_diff_eta_lut_array := CALO_MU_DIFF_ETA_LUT;

type calo_muon_diff_phi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of natural range 0 to 6272;
-- type eg_muon_diff_phi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of natural range 0 to 6272;
-- type jet_muon_diff_phi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of natural range 0 to 6272;
-- type tau_muon_diff_phi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of natural range 0 to 6272;

constant CALO_MU_DIFF_PHI_LUT : calo_muon_diff_phi_lut_array := (
0, 11, 22, 33, 44, 55, 65, 76, 87, 98, 109, 120, 131, 142, 153, 164,
175, 185, 196, 207, 218, 229, 240, 251, 262, 273, 284, 295, 305, 316, 327, 338,
349, 360, 371, 382, 393, 404, 415, 425, 436, 447, 458, 469, 480, 491, 502, 513,
524, 535, 545, 556, 567, 578, 589, 600, 611, 622, 633, 644, 654, 665, 676, 687,
698, 709, 720, 731, 742, 753, 764, 774, 785, 796, 807, 818, 829, 840, 851, 862,
873, 884, 894, 905, 916, 927, 938, 949, 960, 971, 982, 993, 1004, 1014, 1025, 1036,
1047, 1058, 1069, 1080, 1091, 1102, 1113, 1124, 1134, 1145, 1156, 1167, 1178, 1189, 1200, 1211,
1222, 1233, 1244, 1254, 1265, 1276, 1287, 1298, 1309, 1320, 1331, 1342, 1353, 1364, 1374, 1385,
1396, 1407, 1418, 1429, 1440, 1451, 1462, 1473, 1484, 1494, 1505, 1516, 1527, 1538, 1549, 1560,
1571, 1582, 1593, 1604, 1614, 1625, 1636, 1647, 1658, 1669, 1680, 1691, 1702, 1713, 1724, 1734,
1745, 1756, 1767, 1778, 1789, 1800, 1811, 1822, 1833, 1844, 1854, 1865, 1876, 1887, 1898, 1909,
1920, 1931, 1942, 1953, 1963, 1974, 1985, 1996, 2007, 2018, 2029, 2040, 2051, 2062, 2073, 2083,
2094, 2105, 2116, 2127, 2138, 2149, 2160, 2171, 2182, 2193, 2203, 2214, 2225, 2236, 2247, 2258,
2269, 2280, 2291, 2302, 2313, 2323, 2334, 2345, 2356, 2367, 2378, 2389, 2400, 2411, 2422, 2433,
2443, 2454, 2465, 2476, 2487, 2498, 2509, 2520, 2531, 2542, 2553, 2563, 2574, 2585, 2596, 2607,
2618, 2629, 2640, 2651, 2662, 2673, 2683, 2694, 2705, 2716, 2727, 2738, 2749, 2760, 2771, 2782,
2793, 2803, 2814, 2825, 2836, 2847, 2858, 2869, 2880, 2891, 2902, 2913, 2923, 2934, 2945, 2956,
2967, 2978, 2989, 3000, 3011, 3022, 3033, 3043, 3054, 3065, 3076, 3087, 3098, 3109, 3120, 3131,
3142, 3153, 3163, 3174, 3185, 3196, 3207, 3218, 3229, 3240, 3251, 3262, 3272, 3283, 3294, 3305,
3316, 3327, 3338, 3349, 3360, 3371, 3382, 3392, 3403, 3414, 3425, 3436, 3447, 3458, 3469, 3480,
3491, 3502, 3512, 3523, 3534, 3545, 3556, 3567, 3578, 3589, 3600, 3611, 3622, 3632, 3643, 3654,
3665, 3676, 3687, 3698, 3709, 3720, 3731, 3742, 3752, 3763, 3774, 3785, 3796, 3807, 3818, 3829,
3840, 3851, 3862, 3872, 3883, 3894, 3905, 3916, 3927, 3938, 3949, 3960, 3971, 3982, 3992, 4003,
4014, 4025, 4036, 4047, 4058, 4069, 4080, 4091, 4102, 4112, 4123, 4134, 4145, 4156, 4167, 4178,
4189, 4200, 4211, 4222, 4232, 4243, 4254, 4265, 4276, 4287, 4298, 4309, 4320, 4331, 4342, 4352,
4363, 4374, 4385, 4396, 4407, 4418, 4429, 4440, 4451, 4461, 4472, 4483, 4494, 4505, 4516, 4527,
4538, 4549, 4560, 4571, 4581, 4592, 4603, 4614, 4625, 4636, 4647, 4658, 4669, 4680, 4691, 4701,
4712, 4723, 4734, 4745, 4756, 4767, 4778, 4789, 4800, 4811, 4821, 4832, 4843, 4854, 4865, 4876,
4887, 4898, 4909, 4920, 4931, 4941, 4952, 4963, 4974, 4985, 4996, 5007, 5018, 5029, 5040, 5051,
5061, 5072, 5083, 5094, 5105, 5116, 5127, 5138, 5149, 5160, 5171, 5181, 5192, 5203, 5214, 5225,
5236, 5247, 5258, 5269, 5280, 5291, 5301, 5312, 5323, 5334, 5345, 5356, 5367, 5378, 5389, 5400,
5411, 5421, 5432, 5443, 5454, 5465, 5476, 5487, 5498, 5509, 5520, 5531, 5541, 5552, 5563, 5574,
5585, 5596, 5607, 5618, 5629, 5640, 5651, 5661, 5672, 5683, 5694, 5705, 5716, 5727, 5738, 5749,
5760, 5770, 5781, 5792, 5803, 5814, 5825, 5836, 5847, 5858, 5869, 5880, 5890, 5901, 5912, 5923,
5934, 5945, 5956, 5967, 5978, 5989, 6000, 6010, 6021, 6032, 6043, 6054, 6065, 6076, 6087, 6098,
6109, 6120, 6130, 6141, 6152, 6163, 6174, 6185, 6196, 6207, 6218, 6229, 6240, 6250, 6261, 6272,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

constant EG_MU_DIFF_PHI_LUT : calo_muon_diff_phi_lut_array := CALO_MU_DIFF_PHI_LUT;
constant TAU_MU_DIFF_PHI_LUT : calo_muon_diff_phi_lut_array := CALO_MU_DIFF_PHI_LUT;
constant JET_MU_DIFF_PHI_LUT : calo_muon_diff_phi_lut_array := CALO_MU_DIFF_PHI_LUT;

-- muon-esums differences LUTs
-- type muon_etm_diff_phi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of natural range 0 to 6272;
-- type muon_etmhf_diff_phi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of natural range 0 to 6272;
-- type muon_htm_diff_phi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of natural range 0 to 6272;

constant MU_HTM_DIFF_PHI_LUT : calo_muon_diff_phi_lut_array := CALO_MU_DIFF_PHI_LUT;
constant MU_ETM_DIFF_PHI_LUT : calo_muon_diff_phi_lut_array := CALO_MU_DIFF_PHI_LUT;
constant MU_ETMHF_DIFF_PHI_LUT : calo_muon_diff_phi_lut_array := CALO_MU_DIFF_PHI_LUT;

-- ********************************************************
-- mass LUTs

-- calo pt LUTs
-- HB 2016-04-07: TM updated LUTs for PTto the center of bins, so max. values increased by 3
-- (bin width = 0.5 => 0.5/2 = 0.25 => selected 0.3, multiplied by 10 because of one digit after comma)

-- type eg_pt_lut_array is array (0 to 2**(D_S_I_EG_V2.et_high-D_S_I_EG_V2.et_low+1)-1) of natural range 0 to 2555;
-- type tau_pt_lut_array is array (0 to 2**(D_S_I_TAU_V2.et_high-D_S_I_TAU_V2.et_low+1)-1) of natural range 0 to 2555;
-- HB 2017-01-20: updated for corrected scale
-- type eg_pt_lut_array is array (0 to 2**(D_S_I_EG_V2.et_high-D_S_I_EG_V2.et_low+1)-1) of natural range 0 to 2558;
type eg_pt_lut_array is array (0 to 2**EG_PT_WIDTH-1) of natural range 0 to 2558;
-- type tau_pt_lut_array is array (0 to 2**(D_S_I_TAU_V2.et_high-D_S_I_TAU_V2.et_low+1)-1) of natural range 0 to 2558;

-- HB 2017-01-20: updated for corrected scale
constant EG_PT_LUT : eg_pt_lut_array := (
3, 8, 13, 18, 23, 28, 33, 38, 43, 48, 53, 58, 63, 68, 73, 78,
83, 88, 93, 98, 103, 108, 113, 118, 123, 128, 133, 138, 143, 148, 153, 158,
163, 168, 173, 178, 183, 188, 193, 198, 203, 208, 213, 218, 223, 228, 233, 238,
243, 248, 253, 258, 263, 268, 273, 278, 283, 288, 293, 298, 303, 308, 313, 318,
323, 328, 333, 338, 343, 348, 353, 358, 363, 368, 373, 378, 383, 388, 393, 398,
403, 408, 413, 418, 423, 428, 433, 438, 443, 448, 453, 458, 463, 468, 473, 478,
483, 488, 493, 498, 503, 508, 513, 518, 523, 528, 533, 538, 543, 548, 553, 558,
563, 568, 573, 578, 583, 588, 593, 598, 603, 608, 613, 618, 623, 628, 633, 638,
643, 648, 653, 658, 663, 668, 673, 678, 683, 688, 693, 698, 703, 708, 713, 718,
723, 728, 733, 738, 743, 748, 753, 758, 763, 768, 773, 778, 783, 788, 793, 798,
803, 808, 813, 818, 823, 828, 833, 838, 843, 848, 853, 858, 863, 868, 873, 878,
883, 888, 893, 898, 903, 908, 913, 918, 923, 928, 933, 938, 943, 948, 953, 958,
963, 968, 973, 978, 983, 988, 993, 998, 1003, 1008, 1013, 1018, 1023, 1028, 1033, 1038,
1043, 1048, 1053, 1058, 1063, 1068, 1073, 1078, 1083, 1088, 1093, 1098, 1103, 1108, 1113, 1118,
1123, 1128, 1133, 1138, 1143, 1148, 1153, 1158, 1163, 1168, 1173, 1178, 1183, 1188, 1193, 1198,
1203, 1208, 1213, 1218, 1223, 1228, 1233, 1238, 1243, 1248, 1253, 1258, 1263, 1268, 1273, 1278,
1283, 1288, 1293, 1298, 1303, 1308, 1313, 1318, 1323, 1328, 1333, 1338, 1343, 1348, 1353, 1358,
1363, 1368, 1373, 1378, 1383, 1388, 1393, 1398, 1403, 1408, 1413, 1418, 1423, 1428, 1433, 1438,
1443, 1448, 1453, 1458, 1463, 1468, 1473, 1478, 1483, 1488, 1493, 1498, 1503, 1508, 1513, 1518,
1523, 1528, 1533, 1538, 1543, 1548, 1553, 1558, 1563, 1568, 1573, 1578, 1583, 1588, 1593, 1598,
1603, 1608, 1613, 1618, 1623, 1628, 1633, 1638, 1643, 1648, 1653, 1658, 1663, 1668, 1673, 1678,
1683, 1688, 1693, 1698, 1703, 1708, 1713, 1718, 1723, 1728, 1733, 1738, 1743, 1748, 1753, 1758,
1763, 1768, 1773, 1778, 1783, 1788, 1793, 1798, 1803, 1808, 1813, 1818, 1823, 1828, 1833, 1838,
1843, 1848, 1853, 1858, 1863, 1868, 1873, 1878, 1883, 1888, 1893, 1898, 1903, 1908, 1913, 1918,
1923, 1928, 1933, 1938, 1943, 1948, 1953, 1958, 1963, 1968, 1973, 1978, 1983, 1988, 1993, 1998,
2003, 2008, 2013, 2018, 2023, 2028, 2033, 2038, 2043, 2048, 2053, 2058, 2063, 2068, 2073, 2078,
2083, 2088, 2093, 2098, 2103, 2108, 2113, 2118, 2123, 2128, 2133, 2138, 2143, 2148, 2153, 2158,
2163, 2168, 2173, 2178, 2183, 2188, 2193, 2198, 2203, 2208, 2213, 2218, 2223, 2228, 2233, 2238,
2243, 2248, 2253, 2258, 2263, 2268, 2273, 2278, 2283, 2288, 2293, 2298, 2303, 2308, 2313, 2318,
2323, 2328, 2333, 2338, 2343, 2348, 2353, 2358, 2363, 2368, 2373, 2378, 2383, 2388, 2393, 2398,
2403, 2408, 2413, 2418, 2423, 2428, 2433, 2438, 2443, 2448, 2453, 2458, 2463, 2468, 2473, 2478,
-- 2483, 2488, 2493, 2498, 2503, 2508, 2513, 2518, 2523, 2528, 2533, 2538, 2543, 2548, 2555, 2555
2483, 2488, 2493, 2498, 2503, 2508, 2513, 2518, 2523, 2528, 2533, 2538, 2543, 2548, 2553, 2558
);

constant TAU_PT_LUT : eg_pt_lut_array := EG_PT_LUT;

-- type jet_pt_lut_array is array (0 to 2**(D_S_I_JET_V2.et_high-D_S_I_JET_V2.et_low+1)-1) of natural range 0 to 10235;
-- HB 2017-01-20: updated for corrected scale
-- type jet_pt_lut_array is array (0 to 2**(D_S_I_JET_V2.et_high-D_S_I_JET_V2.et_low+1)-1) of natural range 0 to 10238;
type jet_pt_lut_array is array (0 to 2**JET_PT_WIDTH-1) of natural range 0 to 10238;

-- HB 2017-01-20: updated for corrected scale
constant JET_PT_LUT : jet_pt_lut_array := (
3, 8, 13, 18, 23, 28, 33, 38, 43, 48, 53, 58, 63, 68, 73, 78,
83, 88, 93, 98, 103, 108, 113, 118, 123, 128, 133, 138, 143, 148, 153, 158,
163, 168, 173, 178, 183, 188, 193, 198, 203, 208, 213, 218, 223, 228, 233, 238,
243, 248, 253, 258, 263, 268, 273, 278, 283, 288, 293, 298, 303, 308, 313, 318,
323, 328, 333, 338, 343, 348, 353, 358, 363, 368, 373, 378, 383, 388, 393, 398,
403, 408, 413, 418, 423, 428, 433, 438, 443, 448, 453, 458, 463, 468, 473, 478,
483, 488, 493, 498, 503, 508, 513, 518, 523, 528, 533, 538, 543, 548, 553, 558,
563, 568, 573, 578, 583, 588, 593, 598, 603, 608, 613, 618, 623, 628, 633, 638,
643, 648, 653, 658, 663, 668, 673, 678, 683, 688, 693, 698, 703, 708, 713, 718,
723, 728, 733, 738, 743, 748, 753, 758, 763, 768, 773, 778, 783, 788, 793, 798,
803, 808, 813, 818, 823, 828, 833, 838, 843, 848, 853, 858, 863, 868, 873, 878,
883, 888, 893, 898, 903, 908, 913, 918, 923, 928, 933, 938, 943, 948, 953, 958,
963, 968, 973, 978, 983, 988, 993, 998, 1003, 1008, 1013, 1018, 1023, 1028, 1033, 1038,
1043, 1048, 1053, 1058, 1063, 1068, 1073, 1078, 1083, 1088, 1093, 1098, 1103, 1108, 1113, 1118,
1123, 1128, 1133, 1138, 1143, 1148, 1153, 1158, 1163, 1168, 1173, 1178, 1183, 1188, 1193, 1198,
1203, 1208, 1213, 1218, 1223, 1228, 1233, 1238, 1243, 1248, 1253, 1258, 1263, 1268, 1273, 1278,
1283, 1288, 1293, 1298, 1303, 1308, 1313, 1318, 1323, 1328, 1333, 1338, 1343, 1348, 1353, 1358,
1363, 1368, 1373, 1378, 1383, 1388, 1393, 1398, 1403, 1408, 1413, 1418, 1423, 1428, 1433, 1438,
1443, 1448, 1453, 1458, 1463, 1468, 1473, 1478, 1483, 1488, 1493, 1498, 1503, 1508, 1513, 1518,
1523, 1528, 1533, 1538, 1543, 1548, 1553, 1558, 1563, 1568, 1573, 1578, 1583, 1588, 1593, 1598,
1603, 1608, 1613, 1618, 1623, 1628, 1633, 1638, 1643, 1648, 1653, 1658, 1663, 1668, 1673, 1678,
1683, 1688, 1693, 1698, 1703, 1708, 1713, 1718, 1723, 1728, 1733, 1738, 1743, 1748, 1753, 1758,
1763, 1768, 1773, 1778, 1783, 1788, 1793, 1798, 1803, 1808, 1813, 1818, 1823, 1828, 1833, 1838,
1843, 1848, 1853, 1858, 1863, 1868, 1873, 1878, 1883, 1888, 1893, 1898, 1903, 1908, 1913, 1918,
1923, 1928, 1933, 1938, 1943, 1948, 1953, 1958, 1963, 1968, 1973, 1978, 1983, 1988, 1993, 1998,
2003, 2008, 2013, 2018, 2023, 2028, 2033, 2038, 2043, 2048, 2053, 2058, 2063, 2068, 2073, 2078,
2083, 2088, 2093, 2098, 2103, 2108, 2113, 2118, 2123, 2128, 2133, 2138, 2143, 2148, 2153, 2158,
2163, 2168, 2173, 2178, 2183, 2188, 2193, 2198, 2203, 2208, 2213, 2218, 2223, 2228, 2233, 2238,
2243, 2248, 2253, 2258, 2263, 2268, 2273, 2278, 2283, 2288, 2293, 2298, 2303, 2308, 2313, 2318,
2323, 2328, 2333, 2338, 2343, 2348, 2353, 2358, 2363, 2368, 2373, 2378, 2383, 2388, 2393, 2398,
2403, 2408, 2413, 2418, 2423, 2428, 2433, 2438, 2443, 2448, 2453, 2458, 2463, 2468, 2473, 2478,
2483, 2488, 2493, 2498, 2503, 2508, 2513, 2518, 2523, 2528, 2533, 2538, 2543, 2548, 2553, 2558,
2563, 2568, 2573, 2578, 2583, 2588, 2593, 2598, 2603, 2608, 2613, 2618, 2623, 2628, 2633, 2638,
2643, 2648, 2653, 2658, 2663, 2668, 2673, 2678, 2683, 2688, 2693, 2698, 2703, 2708, 2713, 2718,
2723, 2728, 2733, 2738, 2743, 2748, 2753, 2758, 2763, 2768, 2773, 2778, 2783, 2788, 2793, 2798,
2803, 2808, 2813, 2818, 2823, 2828, 2833, 2838, 2843, 2848, 2853, 2858, 2863, 2868, 2873, 2878,
2883, 2888, 2893, 2898, 2903, 2908, 2913, 2918, 2923, 2928, 2933, 2938, 2943, 2948, 2953, 2958,
2963, 2968, 2973, 2978, 2983, 2988, 2993, 2998, 3003, 3008, 3013, 3018, 3023, 3028, 3033, 3038,
3043, 3048, 3053, 3058, 3063, 3068, 3073, 3078, 3083, 3088, 3093, 3098, 3103, 3108, 3113, 3118,
3123, 3128, 3133, 3138, 3143, 3148, 3153, 3158, 3163, 3168, 3173, 3178, 3183, 3188, 3193, 3198,
3203, 3208, 3213, 3218, 3223, 3228, 3233, 3238, 3243, 3248, 3253, 3258, 3263, 3268, 3273, 3278,
3283, 3288, 3293, 3298, 3303, 3308, 3313, 3318, 3323, 3328, 3333, 3338, 3343, 3348, 3353, 3358,
3363, 3368, 3373, 3378, 3383, 3388, 3393, 3398, 3403, 3408, 3413, 3418, 3423, 3428, 3433, 3438,
3443, 3448, 3453, 3458, 3463, 3468, 3473, 3478, 3483, 3488, 3493, 3498, 3503, 3508, 3513, 3518,
3523, 3528, 3533, 3538, 3543, 3548, 3553, 3558, 3563, 3568, 3573, 3578, 3583, 3588, 3593, 3598,
3603, 3608, 3613, 3618, 3623, 3628, 3633, 3638, 3643, 3648, 3653, 3658, 3663, 3668, 3673, 3678,
3683, 3688, 3693, 3698, 3703, 3708, 3713, 3718, 3723, 3728, 3733, 3738, 3743, 3748, 3753, 3758,
3763, 3768, 3773, 3778, 3783, 3788, 3793, 3798, 3803, 3808, 3813, 3818, 3823, 3828, 3833, 3838,
3843, 3848, 3853, 3858, 3863, 3868, 3873, 3878, 3883, 3888, 3893, 3898, 3903, 3908, 3913, 3918,
3923, 3928, 3933, 3938, 3943, 3948, 3953, 3958, 3963, 3968, 3973, 3978, 3983, 3988, 3993, 3998,
4003, 4008, 4013, 4018, 4023, 4028, 4033, 4038, 4043, 4048, 4053, 4058, 4063, 4068, 4073, 4078,
4083, 4088, 4093, 4098, 4103, 4108, 4113, 4118, 4123, 4128, 4133, 4138, 4143, 4148, 4153, 4158,
4163, 4168, 4173, 4178, 4183, 4188, 4193, 4198, 4203, 4208, 4213, 4218, 4223, 4228, 4233, 4238,
4243, 4248, 4253, 4258, 4263, 4268, 4273, 4278, 4283, 4288, 4293, 4298, 4303, 4308, 4313, 4318,
4323, 4328, 4333, 4338, 4343, 4348, 4353, 4358, 4363, 4368, 4373, 4378, 4383, 4388, 4393, 4398,
4403, 4408, 4413, 4418, 4423, 4428, 4433, 4438, 4443, 4448, 4453, 4458, 4463, 4468, 4473, 4478,
4483, 4488, 4493, 4498, 4503, 4508, 4513, 4518, 4523, 4528, 4533, 4538, 4543, 4548, 4553, 4558,
4563, 4568, 4573, 4578, 4583, 4588, 4593, 4598, 4603, 4608, 4613, 4618, 4623, 4628, 4633, 4638,
4643, 4648, 4653, 4658, 4663, 4668, 4673, 4678, 4683, 4688, 4693, 4698, 4703, 4708, 4713, 4718,
4723, 4728, 4733, 4738, 4743, 4748, 4753, 4758, 4763, 4768, 4773, 4778, 4783, 4788, 4793, 4798,
4803, 4808, 4813, 4818, 4823, 4828, 4833, 4838, 4843, 4848, 4853, 4858, 4863, 4868, 4873, 4878,
4883, 4888, 4893, 4898, 4903, 4908, 4913, 4918, 4923, 4928, 4933, 4938, 4943, 4948, 4953, 4958,
4963, 4968, 4973, 4978, 4983, 4988, 4993, 4998, 5003, 5008, 5013, 5018, 5023, 5028, 5033, 5038,
5043, 5048, 5053, 5058, 5063, 5068, 5073, 5078, 5083, 5088, 5093, 5098, 5103, 5108, 5113, 5118,
5123, 5128, 5133, 5138, 5143, 5148, 5153, 5158, 5163, 5168, 5173, 5178, 5183, 5188, 5193, 5198,
5203, 5208, 5213, 5218, 5223, 5228, 5233, 5238, 5243, 5248, 5253, 5258, 5263, 5268, 5273, 5278,
5283, 5288, 5293, 5298, 5303, 5308, 5313, 5318, 5323, 5328, 5333, 5338, 5343, 5348, 5353, 5358,
5363, 5368, 5373, 5378, 5383, 5388, 5393, 5398, 5403, 5408, 5413, 5418, 5423, 5428, 5433, 5438,
5443, 5448, 5453, 5458, 5463, 5468, 5473, 5478, 5483, 5488, 5493, 5498, 5503, 5508, 5513, 5518,
5523, 5528, 5533, 5538, 5543, 5548, 5553, 5558, 5563, 5568, 5573, 5578, 5583, 5588, 5593, 5598,
5603, 5608, 5613, 5618, 5623, 5628, 5633, 5638, 5643, 5648, 5653, 5658, 5663, 5668, 5673, 5678,
5683, 5688, 5693, 5698, 5703, 5708, 5713, 5718, 5723, 5728, 5733, 5738, 5743, 5748, 5753, 5758,
5763, 5768, 5773, 5778, 5783, 5788, 5793, 5798, 5803, 5808, 5813, 5818, 5823, 5828, 5833, 5838,
5843, 5848, 5853, 5858, 5863, 5868, 5873, 5878, 5883, 5888, 5893, 5898, 5903, 5908, 5913, 5918,
5923, 5928, 5933, 5938, 5943, 5948, 5953, 5958, 5963, 5968, 5973, 5978, 5983, 5988, 5993, 5998,
6003, 6008, 6013, 6018, 6023, 6028, 6033, 6038, 6043, 6048, 6053, 6058, 6063, 6068, 6073, 6078,
6083, 6088, 6093, 6098, 6103, 6108, 6113, 6118, 6123, 6128, 6133, 6138, 6143, 6148, 6153, 6158,
6163, 6168, 6173, 6178, 6183, 6188, 6193, 6198, 6203, 6208, 6213, 6218, 6223, 6228, 6233, 6238,
6243, 6248, 6253, 6258, 6263, 6268, 6273, 6278, 6283, 6288, 6293, 6298, 6303, 6308, 6313, 6318,
6323, 6328, 6333, 6338, 6343, 6348, 6353, 6358, 6363, 6368, 6373, 6378, 6383, 6388, 6393, 6398,
6403, 6408, 6413, 6418, 6423, 6428, 6433, 6438, 6443, 6448, 6453, 6458, 6463, 6468, 6473, 6478,
6483, 6488, 6493, 6498, 6503, 6508, 6513, 6518, 6523, 6528, 6533, 6538, 6543, 6548, 6553, 6558,
6563, 6568, 6573, 6578, 6583, 6588, 6593, 6598, 6603, 6608, 6613, 6618, 6623, 6628, 6633, 6638,
6643, 6648, 6653, 6658, 6663, 6668, 6673, 6678, 6683, 6688, 6693, 6698, 6703, 6708, 6713, 6718,
6723, 6728, 6733, 6738, 6743, 6748, 6753, 6758, 6763, 6768, 6773, 6778, 6783, 6788, 6793, 6798,
6803, 6808, 6813, 6818, 6823, 6828, 6833, 6838, 6843, 6848, 6853, 6858, 6863, 6868, 6873, 6878,
6883, 6888, 6893, 6898, 6903, 6908, 6913, 6918, 6923, 6928, 6933, 6938, 6943, 6948, 6953, 6958,
6963, 6968, 6973, 6978, 6983, 6988, 6993, 6998, 7003, 7008, 7013, 7018, 7023, 7028, 7033, 7038,
7043, 7048, 7053, 7058, 7063, 7068, 7073, 7078, 7083, 7088, 7093, 7098, 7103, 7108, 7113, 7118,
7123, 7128, 7133, 7138, 7143, 7148, 7153, 7158, 7163, 7168, 7173, 7178, 7183, 7188, 7193, 7198,
7203, 7208, 7213, 7218, 7223, 7228, 7233, 7238, 7243, 7248, 7253, 7258, 7263, 7268, 7273, 7278,
7283, 7288, 7293, 7298, 7303, 7308, 7313, 7318, 7323, 7328, 7333, 7338, 7343, 7348, 7353, 7358,
7363, 7368, 7373, 7378, 7383, 7388, 7393, 7398, 7403, 7408, 7413, 7418, 7423, 7428, 7433, 7438,
7443, 7448, 7453, 7458, 7463, 7468, 7473, 7478, 7483, 7488, 7493, 7498, 7503, 7508, 7513, 7518,
7523, 7528, 7533, 7538, 7543, 7548, 7553, 7558, 7563, 7568, 7573, 7578, 7583, 7588, 7593, 7598,
7603, 7608, 7613, 7618, 7623, 7628, 7633, 7638, 7643, 7648, 7653, 7658, 7663, 7668, 7673, 7678,
7683, 7688, 7693, 7698, 7703, 7708, 7713, 7718, 7723, 7728, 7733, 7738, 7743, 7748, 7753, 7758,
7763, 7768, 7773, 7778, 7783, 7788, 7793, 7798, 7803, 7808, 7813, 7818, 7823, 7828, 7833, 7838,
7843, 7848, 7853, 7858, 7863, 7868, 7873, 7878, 7883, 7888, 7893, 7898, 7903, 7908, 7913, 7918,
7923, 7928, 7933, 7938, 7943, 7948, 7953, 7958, 7963, 7968, 7973, 7978, 7983, 7988, 7993, 7998,
8003, 8008, 8013, 8018, 8023, 8028, 8033, 8038, 8043, 8048, 8053, 8058, 8063, 8068, 8073, 8078,
8083, 8088, 8093, 8098, 8103, 8108, 8113, 8118, 8123, 8128, 8133, 8138, 8143, 8148, 8153, 8158,
8163, 8168, 8173, 8178, 8183, 8188, 8193, 8198, 8203, 8208, 8213, 8218, 8223, 8228, 8233, 8238,
8243, 8248, 8253, 8258, 8263, 8268, 8273, 8278, 8283, 8288, 8293, 8298, 8303, 8308, 8313, 8318,
8323, 8328, 8333, 8338, 8343, 8348, 8353, 8358, 8363, 8368, 8373, 8378, 8383, 8388, 8393, 8398,
8403, 8408, 8413, 8418, 8423, 8428, 8433, 8438, 8443, 8448, 8453, 8458, 8463, 8468, 8473, 8478,
8483, 8488, 8493, 8498, 8503, 8508, 8513, 8518, 8523, 8528, 8533, 8538, 8543, 8548, 8553, 8558,
8563, 8568, 8573, 8578, 8583, 8588, 8593, 8598, 8603, 8608, 8613, 8618, 8623, 8628, 8633, 8638,
8643, 8648, 8653, 8658, 8663, 8668, 8673, 8678, 8683, 8688, 8693, 8698, 8703, 8708, 8713, 8718,
8723, 8728, 8733, 8738, 8743, 8748, 8753, 8758, 8763, 8768, 8773, 8778, 8783, 8788, 8793, 8798,
8803, 8808, 8813, 8818, 8823, 8828, 8833, 8838, 8843, 8848, 8853, 8858, 8863, 8868, 8873, 8878,
8883, 8888, 8893, 8898, 8903, 8908, 8913, 8918, 8923, 8928, 8933, 8938, 8943, 8948, 8953, 8958,
8963, 8968, 8973, 8978, 8983, 8988, 8993, 8998, 9003, 9008, 9013, 9018, 9023, 9028, 9033, 9038,
9043, 9048, 9053, 9058, 9063, 9068, 9073, 9078, 9083, 9088, 9093, 9098, 9103, 9108, 9113, 9118,
9123, 9128, 9133, 9138, 9143, 9148, 9153, 9158, 9163, 9168, 9173, 9178, 9183, 9188, 9193, 9198,
9203, 9208, 9213, 9218, 9223, 9228, 9233, 9238, 9243, 9248, 9253, 9258, 9263, 9268, 9273, 9278,
9283, 9288, 9293, 9298, 9303, 9308, 9313, 9318, 9323, 9328, 9333, 9338, 9343, 9348, 9353, 9358,
9363, 9368, 9373, 9378, 9383, 9388, 9393, 9398, 9403, 9408, 9413, 9418, 9423, 9428, 9433, 9438,
9443, 9448, 9453, 9458, 9463, 9468, 9473, 9478, 9483, 9488, 9493, 9498, 9503, 9508, 9513, 9518,
9523, 9528, 9533, 9538, 9543, 9548, 9553, 9558, 9563, 9568, 9573, 9578, 9583, 9588, 9593, 9598,
9603, 9608, 9613, 9618, 9623, 9628, 9633, 9638, 9643, 9648, 9653, 9658, 9663, 9668, 9673, 9678,
9683, 9688, 9693, 9698, 9703, 9708, 9713, 9718, 9723, 9728, 9733, 9738, 9743, 9748, 9753, 9758,
9763, 9768, 9773, 9778, 9783, 9788, 9793, 9798, 9803, 9808, 9813, 9818, 9823, 9828, 9833, 9838,
9843, 9848, 9853, 9858, 9863, 9868, 9873, 9878, 9883, 9888, 9893, 9898, 9903, 9908, 9913, 9918,
9923, 9928, 9933, 9938, 9943, 9948, 9953, 9958, 9963, 9968, 9973, 9978, 9983, 9988, 9993, 9998,
10003, 10008, 10013, 10018, 10023, 10028, 10033, 10038, 10043, 10048, 10053, 10058, 10063, 10068, 10073, 10078,
10083, 10088, 10093, 10098, 10103, 10108, 10113, 10118, 10123, 10128, 10133, 10138, 10143, 10148, 10153, 10158,
-- 10163, 10168, 10173, 10178, 10183, 10188, 10193, 10198, 10203, 10208, 10213, 10218, 10223, 10228, 10235, 10235
10163, 10168, 10173, 10178, 10183, 10188, 10193, 10198, 10203, 10208, 10213, 10218, 10223, 10228, 10233, 10238
);

type etm_pt_lut_array is array (0 to 2**(ETM_STRUCT.pt_h-ETM_STRUCT.pt_l+1)-1) of natural range 0 to 20478;
-- type etm_pt_lut_array is array (0 to 2**(D_S_I_ETM_V2.et_high-D_S_I_ETM_V2.et_low+1)-1) of natural range 0 to 20478;

constant ETM_PT_LUT : etm_pt_lut_array := (
3, 8, 13, 18, 23, 28, 33, 38, 43, 48, 53, 58, 63, 68, 73, 78,
83, 88, 93, 98, 103, 108, 113, 118, 123, 128, 133, 138, 143, 148, 153, 158,
163, 168, 173, 178, 183, 188, 193, 198, 203, 208, 213, 218, 223, 228, 233, 238,
243, 248, 253, 258, 263, 268, 273, 278, 283, 288, 293, 298, 303, 308, 313, 318,
323, 328, 333, 338, 343, 348, 353, 358, 363, 368, 373, 378, 383, 388, 393, 398,
403, 408, 413, 418, 423, 428, 433, 438, 443, 448, 453, 458, 463, 468, 473, 478,
483, 488, 493, 498, 503, 508, 513, 518, 523, 528, 533, 538, 543, 548, 553, 558,
563, 568, 573, 578, 583, 588, 593, 598, 603, 608, 613, 618, 623, 628, 633, 638,
643, 648, 653, 658, 663, 668, 673, 678, 683, 688, 693, 698, 703, 708, 713, 718,
723, 728, 733, 738, 743, 748, 753, 758, 763, 768, 773, 778, 783, 788, 793, 798,
803, 808, 813, 818, 823, 828, 833, 838, 843, 848, 853, 858, 863, 868, 873, 878,
883, 888, 893, 898, 903, 908, 913, 918, 923, 928, 933, 938, 943, 948, 953, 958,
963, 968, 973, 978, 983, 988, 993, 998, 1003, 1008, 1013, 1018, 1023, 1028, 1033, 1038,
1043, 1048, 1053, 1058, 1063, 1068, 1073, 1078, 1083, 1088, 1093, 1098, 1103, 1108, 1113, 1118,
1123, 1128, 1133, 1138, 1143, 1148, 1153, 1158, 1163, 1168, 1173, 1178, 1183, 1188, 1193, 1198,
1203, 1208, 1213, 1218, 1223, 1228, 1233, 1238, 1243, 1248, 1253, 1258, 1263, 1268, 1273, 1278,
1283, 1288, 1293, 1298, 1303, 1308, 1313, 1318, 1323, 1328, 1333, 1338, 1343, 1348, 1353, 1358,
1363, 1368, 1373, 1378, 1383, 1388, 1393, 1398, 1403, 1408, 1413, 1418, 1423, 1428, 1433, 1438,
1443, 1448, 1453, 1458, 1463, 1468, 1473, 1478, 1483, 1488, 1493, 1498, 1503, 1508, 1513, 1518,
1523, 1528, 1533, 1538, 1543, 1548, 1553, 1558, 1563, 1568, 1573, 1578, 1583, 1588, 1593, 1598,
1603, 1608, 1613, 1618, 1623, 1628, 1633, 1638, 1643, 1648, 1653, 1658, 1663, 1668, 1673, 1678,
1683, 1688, 1693, 1698, 1703, 1708, 1713, 1718, 1723, 1728, 1733, 1738, 1743, 1748, 1753, 1758,
1763, 1768, 1773, 1778, 1783, 1788, 1793, 1798, 1803, 1808, 1813, 1818, 1823, 1828, 1833, 1838,
1843, 1848, 1853, 1858, 1863, 1868, 1873, 1878, 1883, 1888, 1893, 1898, 1903, 1908, 1913, 1918,
1923, 1928, 1933, 1938, 1943, 1948, 1953, 1958, 1963, 1968, 1973, 1978, 1983, 1988, 1993, 1998,
2003, 2008, 2013, 2018, 2023, 2028, 2033, 2038, 2043, 2048, 2053, 2058, 2063, 2068, 2073, 2078,
2083, 2088, 2093, 2098, 2103, 2108, 2113, 2118, 2123, 2128, 2133, 2138, 2143, 2148, 2153, 2158,
2163, 2168, 2173, 2178, 2183, 2188, 2193, 2198, 2203, 2208, 2213, 2218, 2223, 2228, 2233, 2238,
2243, 2248, 2253, 2258, 2263, 2268, 2273, 2278, 2283, 2288, 2293, 2298, 2303, 2308, 2313, 2318,
2323, 2328, 2333, 2338, 2343, 2348, 2353, 2358, 2363, 2368, 2373, 2378, 2383, 2388, 2393, 2398,
2403, 2408, 2413, 2418, 2423, 2428, 2433, 2438, 2443, 2448, 2453, 2458, 2463, 2468, 2473, 2478,
2483, 2488, 2493, 2498, 2503, 2508, 2513, 2518, 2523, 2528, 2533, 2538, 2543, 2548, 2553, 2558,
2563, 2568, 2573, 2578, 2583, 2588, 2593, 2598, 2603, 2608, 2613, 2618, 2623, 2628, 2633, 2638,
2643, 2648, 2653, 2658, 2663, 2668, 2673, 2678, 2683, 2688, 2693, 2698, 2703, 2708, 2713, 2718,
2723, 2728, 2733, 2738, 2743, 2748, 2753, 2758, 2763, 2768, 2773, 2778, 2783, 2788, 2793, 2798,
2803, 2808, 2813, 2818, 2823, 2828, 2833, 2838, 2843, 2848, 2853, 2858, 2863, 2868, 2873, 2878,
2883, 2888, 2893, 2898, 2903, 2908, 2913, 2918, 2923, 2928, 2933, 2938, 2943, 2948, 2953, 2958,
2963, 2968, 2973, 2978, 2983, 2988, 2993, 2998, 3003, 3008, 3013, 3018, 3023, 3028, 3033, 3038,
3043, 3048, 3053, 3058, 3063, 3068, 3073, 3078, 3083, 3088, 3093, 3098, 3103, 3108, 3113, 3118,
3123, 3128, 3133, 3138, 3143, 3148, 3153, 3158, 3163, 3168, 3173, 3178, 3183, 3188, 3193, 3198,
3203, 3208, 3213, 3218, 3223, 3228, 3233, 3238, 3243, 3248, 3253, 3258, 3263, 3268, 3273, 3278,
3283, 3288, 3293, 3298, 3303, 3308, 3313, 3318, 3323, 3328, 3333, 3338, 3343, 3348, 3353, 3358,
3363, 3368, 3373, 3378, 3383, 3388, 3393, 3398, 3403, 3408, 3413, 3418, 3423, 3428, 3433, 3438,
3443, 3448, 3453, 3458, 3463, 3468, 3473, 3478, 3483, 3488, 3493, 3498, 3503, 3508, 3513, 3518,
3523, 3528, 3533, 3538, 3543, 3548, 3553, 3558, 3563, 3568, 3573, 3578, 3583, 3588, 3593, 3598,
3603, 3608, 3613, 3618, 3623, 3628, 3633, 3638, 3643, 3648, 3653, 3658, 3663, 3668, 3673, 3678,
3683, 3688, 3693, 3698, 3703, 3708, 3713, 3718, 3723, 3728, 3733, 3738, 3743, 3748, 3753, 3758,
3763, 3768, 3773, 3778, 3783, 3788, 3793, 3798, 3803, 3808, 3813, 3818, 3823, 3828, 3833, 3838,
3843, 3848, 3853, 3858, 3863, 3868, 3873, 3878, 3883, 3888, 3893, 3898, 3903, 3908, 3913, 3918,
3923, 3928, 3933, 3938, 3943, 3948, 3953, 3958, 3963, 3968, 3973, 3978, 3983, 3988, 3993, 3998,
4003, 4008, 4013, 4018, 4023, 4028, 4033, 4038, 4043, 4048, 4053, 4058, 4063, 4068, 4073, 4078,
4083, 4088, 4093, 4098, 4103, 4108, 4113, 4118, 4123, 4128, 4133, 4138, 4143, 4148, 4153, 4158,
4163, 4168, 4173, 4178, 4183, 4188, 4193, 4198, 4203, 4208, 4213, 4218, 4223, 4228, 4233, 4238,
4243, 4248, 4253, 4258, 4263, 4268, 4273, 4278, 4283, 4288, 4293, 4298, 4303, 4308, 4313, 4318,
4323, 4328, 4333, 4338, 4343, 4348, 4353, 4358, 4363, 4368, 4373, 4378, 4383, 4388, 4393, 4398,
4403, 4408, 4413, 4418, 4423, 4428, 4433, 4438, 4443, 4448, 4453, 4458, 4463, 4468, 4473, 4478,
4483, 4488, 4493, 4498, 4503, 4508, 4513, 4518, 4523, 4528, 4533, 4538, 4543, 4548, 4553, 4558,
4563, 4568, 4573, 4578, 4583, 4588, 4593, 4598, 4603, 4608, 4613, 4618, 4623, 4628, 4633, 4638,
4643, 4648, 4653, 4658, 4663, 4668, 4673, 4678, 4683, 4688, 4693, 4698, 4703, 4708, 4713, 4718,
4723, 4728, 4733, 4738, 4743, 4748, 4753, 4758, 4763, 4768, 4773, 4778, 4783, 4788, 4793, 4798,
4803, 4808, 4813, 4818, 4823, 4828, 4833, 4838, 4843, 4848, 4853, 4858, 4863, 4868, 4873, 4878,
4883, 4888, 4893, 4898, 4903, 4908, 4913, 4918, 4923, 4928, 4933, 4938, 4943, 4948, 4953, 4958,
4963, 4968, 4973, 4978, 4983, 4988, 4993, 4998, 5003, 5008, 5013, 5018, 5023, 5028, 5033, 5038,
5043, 5048, 5053, 5058, 5063, 5068, 5073, 5078, 5083, 5088, 5093, 5098, 5103, 5108, 5113, 5118,
5123, 5128, 5133, 5138, 5143, 5148, 5153, 5158, 5163, 5168, 5173, 5178, 5183, 5188, 5193, 5198,
5203, 5208, 5213, 5218, 5223, 5228, 5233, 5238, 5243, 5248, 5253, 5258, 5263, 5268, 5273, 5278,
5283, 5288, 5293, 5298, 5303, 5308, 5313, 5318, 5323, 5328, 5333, 5338, 5343, 5348, 5353, 5358,
5363, 5368, 5373, 5378, 5383, 5388, 5393, 5398, 5403, 5408, 5413, 5418, 5423, 5428, 5433, 5438,
5443, 5448, 5453, 5458, 5463, 5468, 5473, 5478, 5483, 5488, 5493, 5498, 5503, 5508, 5513, 5518,
5523, 5528, 5533, 5538, 5543, 5548, 5553, 5558, 5563, 5568, 5573, 5578, 5583, 5588, 5593, 5598,
5603, 5608, 5613, 5618, 5623, 5628, 5633, 5638, 5643, 5648, 5653, 5658, 5663, 5668, 5673, 5678,
5683, 5688, 5693, 5698, 5703, 5708, 5713, 5718, 5723, 5728, 5733, 5738, 5743, 5748, 5753, 5758,
5763, 5768, 5773, 5778, 5783, 5788, 5793, 5798, 5803, 5808, 5813, 5818, 5823, 5828, 5833, 5838,
5843, 5848, 5853, 5858, 5863, 5868, 5873, 5878, 5883, 5888, 5893, 5898, 5903, 5908, 5913, 5918,
5923, 5928, 5933, 5938, 5943, 5948, 5953, 5958, 5963, 5968, 5973, 5978, 5983, 5988, 5993, 5998,
6003, 6008, 6013, 6018, 6023, 6028, 6033, 6038, 6043, 6048, 6053, 6058, 6063, 6068, 6073, 6078,
6083, 6088, 6093, 6098, 6103, 6108, 6113, 6118, 6123, 6128, 6133, 6138, 6143, 6148, 6153, 6158,
6163, 6168, 6173, 6178, 6183, 6188, 6193, 6198, 6203, 6208, 6213, 6218, 6223, 6228, 6233, 6238,
6243, 6248, 6253, 6258, 6263, 6268, 6273, 6278, 6283, 6288, 6293, 6298, 6303, 6308, 6313, 6318,
6323, 6328, 6333, 6338, 6343, 6348, 6353, 6358, 6363, 6368, 6373, 6378, 6383, 6388, 6393, 6398,
6403, 6408, 6413, 6418, 6423, 6428, 6433, 6438, 6443, 6448, 6453, 6458, 6463, 6468, 6473, 6478,
6483, 6488, 6493, 6498, 6503, 6508, 6513, 6518, 6523, 6528, 6533, 6538, 6543, 6548, 6553, 6558,
6563, 6568, 6573, 6578, 6583, 6588, 6593, 6598, 6603, 6608, 6613, 6618, 6623, 6628, 6633, 6638,
6643, 6648, 6653, 6658, 6663, 6668, 6673, 6678, 6683, 6688, 6693, 6698, 6703, 6708, 6713, 6718,
6723, 6728, 6733, 6738, 6743, 6748, 6753, 6758, 6763, 6768, 6773, 6778, 6783, 6788, 6793, 6798,
6803, 6808, 6813, 6818, 6823, 6828, 6833, 6838, 6843, 6848, 6853, 6858, 6863, 6868, 6873, 6878,
6883, 6888, 6893, 6898, 6903, 6908, 6913, 6918, 6923, 6928, 6933, 6938, 6943, 6948, 6953, 6958,
6963, 6968, 6973, 6978, 6983, 6988, 6993, 6998, 7003, 7008, 7013, 7018, 7023, 7028, 7033, 7038,
7043, 7048, 7053, 7058, 7063, 7068, 7073, 7078, 7083, 7088, 7093, 7098, 7103, 7108, 7113, 7118,
7123, 7128, 7133, 7138, 7143, 7148, 7153, 7158, 7163, 7168, 7173, 7178, 7183, 7188, 7193, 7198,
7203, 7208, 7213, 7218, 7223, 7228, 7233, 7238, 7243, 7248, 7253, 7258, 7263, 7268, 7273, 7278,
7283, 7288, 7293, 7298, 7303, 7308, 7313, 7318, 7323, 7328, 7333, 7338, 7343, 7348, 7353, 7358,
7363, 7368, 7373, 7378, 7383, 7388, 7393, 7398, 7403, 7408, 7413, 7418, 7423, 7428, 7433, 7438,
7443, 7448, 7453, 7458, 7463, 7468, 7473, 7478, 7483, 7488, 7493, 7498, 7503, 7508, 7513, 7518,
7523, 7528, 7533, 7538, 7543, 7548, 7553, 7558, 7563, 7568, 7573, 7578, 7583, 7588, 7593, 7598,
7603, 7608, 7613, 7618, 7623, 7628, 7633, 7638, 7643, 7648, 7653, 7658, 7663, 7668, 7673, 7678,
7683, 7688, 7693, 7698, 7703, 7708, 7713, 7718, 7723, 7728, 7733, 7738, 7743, 7748, 7753, 7758,
7763, 7768, 7773, 7778, 7783, 7788, 7793, 7798, 7803, 7808, 7813, 7818, 7823, 7828, 7833, 7838,
7843, 7848, 7853, 7858, 7863, 7868, 7873, 7878, 7883, 7888, 7893, 7898, 7903, 7908, 7913, 7918,
7923, 7928, 7933, 7938, 7943, 7948, 7953, 7958, 7963, 7968, 7973, 7978, 7983, 7988, 7993, 7998,
8003, 8008, 8013, 8018, 8023, 8028, 8033, 8038, 8043, 8048, 8053, 8058, 8063, 8068, 8073, 8078,
8083, 8088, 8093, 8098, 8103, 8108, 8113, 8118, 8123, 8128, 8133, 8138, 8143, 8148, 8153, 8158,
8163, 8168, 8173, 8178, 8183, 8188, 8193, 8198, 8203, 8208, 8213, 8218, 8223, 8228, 8233, 8238,
8243, 8248, 8253, 8258, 8263, 8268, 8273, 8278, 8283, 8288, 8293, 8298, 8303, 8308, 8313, 8318,
8323, 8328, 8333, 8338, 8343, 8348, 8353, 8358, 8363, 8368, 8373, 8378, 8383, 8388, 8393, 8398,
8403, 8408, 8413, 8418, 8423, 8428, 8433, 8438, 8443, 8448, 8453, 8458, 8463, 8468, 8473, 8478,
8483, 8488, 8493, 8498, 8503, 8508, 8513, 8518, 8523, 8528, 8533, 8538, 8543, 8548, 8553, 8558,
8563, 8568, 8573, 8578, 8583, 8588, 8593, 8598, 8603, 8608, 8613, 8618, 8623, 8628, 8633, 8638,
8643, 8648, 8653, 8658, 8663, 8668, 8673, 8678, 8683, 8688, 8693, 8698, 8703, 8708, 8713, 8718,
8723, 8728, 8733, 8738, 8743, 8748, 8753, 8758, 8763, 8768, 8773, 8778, 8783, 8788, 8793, 8798,
8803, 8808, 8813, 8818, 8823, 8828, 8833, 8838, 8843, 8848, 8853, 8858, 8863, 8868, 8873, 8878,
8883, 8888, 8893, 8898, 8903, 8908, 8913, 8918, 8923, 8928, 8933, 8938, 8943, 8948, 8953, 8958,
8963, 8968, 8973, 8978, 8983, 8988, 8993, 8998, 9003, 9008, 9013, 9018, 9023, 9028, 9033, 9038,
9043, 9048, 9053, 9058, 9063, 9068, 9073, 9078, 9083, 9088, 9093, 9098, 9103, 9108, 9113, 9118,
9123, 9128, 9133, 9138, 9143, 9148, 9153, 9158, 9163, 9168, 9173, 9178, 9183, 9188, 9193, 9198,
9203, 9208, 9213, 9218, 9223, 9228, 9233, 9238, 9243, 9248, 9253, 9258, 9263, 9268, 9273, 9278,
9283, 9288, 9293, 9298, 9303, 9308, 9313, 9318, 9323, 9328, 9333, 9338, 9343, 9348, 9353, 9358,
9363, 9368, 9373, 9378, 9383, 9388, 9393, 9398, 9403, 9408, 9413, 9418, 9423, 9428, 9433, 9438,
9443, 9448, 9453, 9458, 9463, 9468, 9473, 9478, 9483, 9488, 9493, 9498, 9503, 9508, 9513, 9518,
9523, 9528, 9533, 9538, 9543, 9548, 9553, 9558, 9563, 9568, 9573, 9578, 9583, 9588, 9593, 9598,
9603, 9608, 9613, 9618, 9623, 9628, 9633, 9638, 9643, 9648, 9653, 9658, 9663, 9668, 9673, 9678,
9683, 9688, 9693, 9698, 9703, 9708, 9713, 9718, 9723, 9728, 9733, 9738, 9743, 9748, 9753, 9758,
9763, 9768, 9773, 9778, 9783, 9788, 9793, 9798, 9803, 9808, 9813, 9818, 9823, 9828, 9833, 9838,
9843, 9848, 9853, 9858, 9863, 9868, 9873, 9878, 9883, 9888, 9893, 9898, 9903, 9908, 9913, 9918,
9923, 9928, 9933, 9938, 9943, 9948, 9953, 9958, 9963, 9968, 9973, 9978, 9983, 9988, 9993, 9998,
10003, 10008, 10013, 10018, 10023, 10028, 10033, 10038, 10043, 10048, 10053, 10058, 10063, 10068, 10073, 10078,
10083, 10088, 10093, 10098, 10103, 10108, 10113, 10118, 10123, 10128, 10133, 10138, 10143, 10148, 10153, 10158,
10163, 10168, 10173, 10178, 10183, 10188, 10193, 10198, 10203, 10208, 10213, 10218, 10223, 10228, 10233, 10238,
10243, 10248, 10253, 10258, 10263, 10268, 10273, 10278, 10283, 10288, 10293, 10298, 10303, 10308, 10313, 10318,
10323, 10328, 10333, 10338, 10343, 10348, 10353, 10358, 10363, 10368, 10373, 10378, 10383, 10388, 10393, 10398,
10403, 10408, 10413, 10418, 10423, 10428, 10433, 10438, 10443, 10448, 10453, 10458, 10463, 10468, 10473, 10478,
10483, 10488, 10493, 10498, 10503, 10508, 10513, 10518, 10523, 10528, 10533, 10538, 10543, 10548, 10553, 10558,
10563, 10568, 10573, 10578, 10583, 10588, 10593, 10598, 10603, 10608, 10613, 10618, 10623, 10628, 10633, 10638,
10643, 10648, 10653, 10658, 10663, 10668, 10673, 10678, 10683, 10688, 10693, 10698, 10703, 10708, 10713, 10718,
10723, 10728, 10733, 10738, 10743, 10748, 10753, 10758, 10763, 10768, 10773, 10778, 10783, 10788, 10793, 10798,
10803, 10808, 10813, 10818, 10823, 10828, 10833, 10838, 10843, 10848, 10853, 10858, 10863, 10868, 10873, 10878,
10883, 10888, 10893, 10898, 10903, 10908, 10913, 10918, 10923, 10928, 10933, 10938, 10943, 10948, 10953, 10958,
10963, 10968, 10973, 10978, 10983, 10988, 10993, 10998, 11003, 11008, 11013, 11018, 11023, 11028, 11033, 11038,
11043, 11048, 11053, 11058, 11063, 11068, 11073, 11078, 11083, 11088, 11093, 11098, 11103, 11108, 11113, 11118,
11123, 11128, 11133, 11138, 11143, 11148, 11153, 11158, 11163, 11168, 11173, 11178, 11183, 11188, 11193, 11198,
11203, 11208, 11213, 11218, 11223, 11228, 11233, 11238, 11243, 11248, 11253, 11258, 11263, 11268, 11273, 11278,
11283, 11288, 11293, 11298, 11303, 11308, 11313, 11318, 11323, 11328, 11333, 11338, 11343, 11348, 11353, 11358,
11363, 11368, 11373, 11378, 11383, 11388, 11393, 11398, 11403, 11408, 11413, 11418, 11423, 11428, 11433, 11438,
11443, 11448, 11453, 11458, 11463, 11468, 11473, 11478, 11483, 11488, 11493, 11498, 11503, 11508, 11513, 11518,
11523, 11528, 11533, 11538, 11543, 11548, 11553, 11558, 11563, 11568, 11573, 11578, 11583, 11588, 11593, 11598,
11603, 11608, 11613, 11618, 11623, 11628, 11633, 11638, 11643, 11648, 11653, 11658, 11663, 11668, 11673, 11678,
11683, 11688, 11693, 11698, 11703, 11708, 11713, 11718, 11723, 11728, 11733, 11738, 11743, 11748, 11753, 11758,
11763, 11768, 11773, 11778, 11783, 11788, 11793, 11798, 11803, 11808, 11813, 11818, 11823, 11828, 11833, 11838,
11843, 11848, 11853, 11858, 11863, 11868, 11873, 11878, 11883, 11888, 11893, 11898, 11903, 11908, 11913, 11918,
11923, 11928, 11933, 11938, 11943, 11948, 11953, 11958, 11963, 11968, 11973, 11978, 11983, 11988, 11993, 11998,
12003, 12008, 12013, 12018, 12023, 12028, 12033, 12038, 12043, 12048, 12053, 12058, 12063, 12068, 12073, 12078,
12083, 12088, 12093, 12098, 12103, 12108, 12113, 12118, 12123, 12128, 12133, 12138, 12143, 12148, 12153, 12158,
12163, 12168, 12173, 12178, 12183, 12188, 12193, 12198, 12203, 12208, 12213, 12218, 12223, 12228, 12233, 12238,
12243, 12248, 12253, 12258, 12263, 12268, 12273, 12278, 12283, 12288, 12293, 12298, 12303, 12308, 12313, 12318,
12323, 12328, 12333, 12338, 12343, 12348, 12353, 12358, 12363, 12368, 12373, 12378, 12383, 12388, 12393, 12398,
12403, 12408, 12413, 12418, 12423, 12428, 12433, 12438, 12443, 12448, 12453, 12458, 12463, 12468, 12473, 12478,
12483, 12488, 12493, 12498, 12503, 12508, 12513, 12518, 12523, 12528, 12533, 12538, 12543, 12548, 12553, 12558,
12563, 12568, 12573, 12578, 12583, 12588, 12593, 12598, 12603, 12608, 12613, 12618, 12623, 12628, 12633, 12638,
12643, 12648, 12653, 12658, 12663, 12668, 12673, 12678, 12683, 12688, 12693, 12698, 12703, 12708, 12713, 12718,
12723, 12728, 12733, 12738, 12743, 12748, 12753, 12758, 12763, 12768, 12773, 12778, 12783, 12788, 12793, 12798,
12803, 12808, 12813, 12818, 12823, 12828, 12833, 12838, 12843, 12848, 12853, 12858, 12863, 12868, 12873, 12878,
12883, 12888, 12893, 12898, 12903, 12908, 12913, 12918, 12923, 12928, 12933, 12938, 12943, 12948, 12953, 12958,
12963, 12968, 12973, 12978, 12983, 12988, 12993, 12998, 13003, 13008, 13013, 13018, 13023, 13028, 13033, 13038,
13043, 13048, 13053, 13058, 13063, 13068, 13073, 13078, 13083, 13088, 13093, 13098, 13103, 13108, 13113, 13118,
13123, 13128, 13133, 13138, 13143, 13148, 13153, 13158, 13163, 13168, 13173, 13178, 13183, 13188, 13193, 13198,
13203, 13208, 13213, 13218, 13223, 13228, 13233, 13238, 13243, 13248, 13253, 13258, 13263, 13268, 13273, 13278,
13283, 13288, 13293, 13298, 13303, 13308, 13313, 13318, 13323, 13328, 13333, 13338, 13343, 13348, 13353, 13358,
13363, 13368, 13373, 13378, 13383, 13388, 13393, 13398, 13403, 13408, 13413, 13418, 13423, 13428, 13433, 13438,
13443, 13448, 13453, 13458, 13463, 13468, 13473, 13478, 13483, 13488, 13493, 13498, 13503, 13508, 13513, 13518,
13523, 13528, 13533, 13538, 13543, 13548, 13553, 13558, 13563, 13568, 13573, 13578, 13583, 13588, 13593, 13598,
13603, 13608, 13613, 13618, 13623, 13628, 13633, 13638, 13643, 13648, 13653, 13658, 13663, 13668, 13673, 13678,
13683, 13688, 13693, 13698, 13703, 13708, 13713, 13718, 13723, 13728, 13733, 13738, 13743, 13748, 13753, 13758,
13763, 13768, 13773, 13778, 13783, 13788, 13793, 13798, 13803, 13808, 13813, 13818, 13823, 13828, 13833, 13838,
13843, 13848, 13853, 13858, 13863, 13868, 13873, 13878, 13883, 13888, 13893, 13898, 13903, 13908, 13913, 13918,
13923, 13928, 13933, 13938, 13943, 13948, 13953, 13958, 13963, 13968, 13973, 13978, 13983, 13988, 13993, 13998,
14003, 14008, 14013, 14018, 14023, 14028, 14033, 14038, 14043, 14048, 14053, 14058, 14063, 14068, 14073, 14078,
14083, 14088, 14093, 14098, 14103, 14108, 14113, 14118, 14123, 14128, 14133, 14138, 14143, 14148, 14153, 14158,
14163, 14168, 14173, 14178, 14183, 14188, 14193, 14198, 14203, 14208, 14213, 14218, 14223, 14228, 14233, 14238,
14243, 14248, 14253, 14258, 14263, 14268, 14273, 14278, 14283, 14288, 14293, 14298, 14303, 14308, 14313, 14318,
14323, 14328, 14333, 14338, 14343, 14348, 14353, 14358, 14363, 14368, 14373, 14378, 14383, 14388, 14393, 14398,
14403, 14408, 14413, 14418, 14423, 14428, 14433, 14438, 14443, 14448, 14453, 14458, 14463, 14468, 14473, 14478,
14483, 14488, 14493, 14498, 14503, 14508, 14513, 14518, 14523, 14528, 14533, 14538, 14543, 14548, 14553, 14558,
14563, 14568, 14573, 14578, 14583, 14588, 14593, 14598, 14603, 14608, 14613, 14618, 14623, 14628, 14633, 14638,
14643, 14648, 14653, 14658, 14663, 14668, 14673, 14678, 14683, 14688, 14693, 14698, 14703, 14708, 14713, 14718,
14723, 14728, 14733, 14738, 14743, 14748, 14753, 14758, 14763, 14768, 14773, 14778, 14783, 14788, 14793, 14798,
14803, 14808, 14813, 14818, 14823, 14828, 14833, 14838, 14843, 14848, 14853, 14858, 14863, 14868, 14873, 14878,
14883, 14888, 14893, 14898, 14903, 14908, 14913, 14918, 14923, 14928, 14933, 14938, 14943, 14948, 14953, 14958,
14963, 14968, 14973, 14978, 14983, 14988, 14993, 14998, 15003, 15008, 15013, 15018, 15023, 15028, 15033, 15038,
15043, 15048, 15053, 15058, 15063, 15068, 15073, 15078, 15083, 15088, 15093, 15098, 15103, 15108, 15113, 15118,
15123, 15128, 15133, 15138, 15143, 15148, 15153, 15158, 15163, 15168, 15173, 15178, 15183, 15188, 15193, 15198,
15203, 15208, 15213, 15218, 15223, 15228, 15233, 15238, 15243, 15248, 15253, 15258, 15263, 15268, 15273, 15278,
15283, 15288, 15293, 15298, 15303, 15308, 15313, 15318, 15323, 15328, 15333, 15338, 15343, 15348, 15353, 15358,
15363, 15368, 15373, 15378, 15383, 15388, 15393, 15398, 15403, 15408, 15413, 15418, 15423, 15428, 15433, 15438,
15443, 15448, 15453, 15458, 15463, 15468, 15473, 15478, 15483, 15488, 15493, 15498, 15503, 15508, 15513, 15518,
15523, 15528, 15533, 15538, 15543, 15548, 15553, 15558, 15563, 15568, 15573, 15578, 15583, 15588, 15593, 15598,
15603, 15608, 15613, 15618, 15623, 15628, 15633, 15638, 15643, 15648, 15653, 15658, 15663, 15668, 15673, 15678,
15683, 15688, 15693, 15698, 15703, 15708, 15713, 15718, 15723, 15728, 15733, 15738, 15743, 15748, 15753, 15758,
15763, 15768, 15773, 15778, 15783, 15788, 15793, 15798, 15803, 15808, 15813, 15818, 15823, 15828, 15833, 15838,
15843, 15848, 15853, 15858, 15863, 15868, 15873, 15878, 15883, 15888, 15893, 15898, 15903, 15908, 15913, 15918,
15923, 15928, 15933, 15938, 15943, 15948, 15953, 15958, 15963, 15968, 15973, 15978, 15983, 15988, 15993, 15998,
16003, 16008, 16013, 16018, 16023, 16028, 16033, 16038, 16043, 16048, 16053, 16058, 16063, 16068, 16073, 16078,
16083, 16088, 16093, 16098, 16103, 16108, 16113, 16118, 16123, 16128, 16133, 16138, 16143, 16148, 16153, 16158,
16163, 16168, 16173, 16178, 16183, 16188, 16193, 16198, 16203, 16208, 16213, 16218, 16223, 16228, 16233, 16238,
16243, 16248, 16253, 16258, 16263, 16268, 16273, 16278, 16283, 16288, 16293, 16298, 16303, 16308, 16313, 16318,
16323, 16328, 16333, 16338, 16343, 16348, 16353, 16358, 16363, 16368, 16373, 16378, 16383, 16388, 16393, 16398,
16403, 16408, 16413, 16418, 16423, 16428, 16433, 16438, 16443, 16448, 16453, 16458, 16463, 16468, 16473, 16478,
16483, 16488, 16493, 16498, 16503, 16508, 16513, 16518, 16523, 16528, 16533, 16538, 16543, 16548, 16553, 16558,
16563, 16568, 16573, 16578, 16583, 16588, 16593, 16598, 16603, 16608, 16613, 16618, 16623, 16628, 16633, 16638,
16643, 16648, 16653, 16658, 16663, 16668, 16673, 16678, 16683, 16688, 16693, 16698, 16703, 16708, 16713, 16718,
16723, 16728, 16733, 16738, 16743, 16748, 16753, 16758, 16763, 16768, 16773, 16778, 16783, 16788, 16793, 16798,
16803, 16808, 16813, 16818, 16823, 16828, 16833, 16838, 16843, 16848, 16853, 16858, 16863, 16868, 16873, 16878,
16883, 16888, 16893, 16898, 16903, 16908, 16913, 16918, 16923, 16928, 16933, 16938, 16943, 16948, 16953, 16958,
16963, 16968, 16973, 16978, 16983, 16988, 16993, 16998, 17003, 17008, 17013, 17018, 17023, 17028, 17033, 17038,
17043, 17048, 17053, 17058, 17063, 17068, 17073, 17078, 17083, 17088, 17093, 17098, 17103, 17108, 17113, 17118,
17123, 17128, 17133, 17138, 17143, 17148, 17153, 17158, 17163, 17168, 17173, 17178, 17183, 17188, 17193, 17198,
17203, 17208, 17213, 17218, 17223, 17228, 17233, 17238, 17243, 17248, 17253, 17258, 17263, 17268, 17273, 17278,
17283, 17288, 17293, 17298, 17303, 17308, 17313, 17318, 17323, 17328, 17333, 17338, 17343, 17348, 17353, 17358,
17363, 17368, 17373, 17378, 17383, 17388, 17393, 17398, 17403, 17408, 17413, 17418, 17423, 17428, 17433, 17438,
17443, 17448, 17453, 17458, 17463, 17468, 17473, 17478, 17483, 17488, 17493, 17498, 17503, 17508, 17513, 17518,
17523, 17528, 17533, 17538, 17543, 17548, 17553, 17558, 17563, 17568, 17573, 17578, 17583, 17588, 17593, 17598,
17603, 17608, 17613, 17618, 17623, 17628, 17633, 17638, 17643, 17648, 17653, 17658, 17663, 17668, 17673, 17678,
17683, 17688, 17693, 17698, 17703, 17708, 17713, 17718, 17723, 17728, 17733, 17738, 17743, 17748, 17753, 17758,
17763, 17768, 17773, 17778, 17783, 17788, 17793, 17798, 17803, 17808, 17813, 17818, 17823, 17828, 17833, 17838,
17843, 17848, 17853, 17858, 17863, 17868, 17873, 17878, 17883, 17888, 17893, 17898, 17903, 17908, 17913, 17918,
17923, 17928, 17933, 17938, 17943, 17948, 17953, 17958, 17963, 17968, 17973, 17978, 17983, 17988, 17993, 17998,
18003, 18008, 18013, 18018, 18023, 18028, 18033, 18038, 18043, 18048, 18053, 18058, 18063, 18068, 18073, 18078,
18083, 18088, 18093, 18098, 18103, 18108, 18113, 18118, 18123, 18128, 18133, 18138, 18143, 18148, 18153, 18158,
18163, 18168, 18173, 18178, 18183, 18188, 18193, 18198, 18203, 18208, 18213, 18218, 18223, 18228, 18233, 18238,
18243, 18248, 18253, 18258, 18263, 18268, 18273, 18278, 18283, 18288, 18293, 18298, 18303, 18308, 18313, 18318,
18323, 18328, 18333, 18338, 18343, 18348, 18353, 18358, 18363, 18368, 18373, 18378, 18383, 18388, 18393, 18398,
18403, 18408, 18413, 18418, 18423, 18428, 18433, 18438, 18443, 18448, 18453, 18458, 18463, 18468, 18473, 18478,
18483, 18488, 18493, 18498, 18503, 18508, 18513, 18518, 18523, 18528, 18533, 18538, 18543, 18548, 18553, 18558,
18563, 18568, 18573, 18578, 18583, 18588, 18593, 18598, 18603, 18608, 18613, 18618, 18623, 18628, 18633, 18638,
18643, 18648, 18653, 18658, 18663, 18668, 18673, 18678, 18683, 18688, 18693, 18698, 18703, 18708, 18713, 18718,
18723, 18728, 18733, 18738, 18743, 18748, 18753, 18758, 18763, 18768, 18773, 18778, 18783, 18788, 18793, 18798,
18803, 18808, 18813, 18818, 18823, 18828, 18833, 18838, 18843, 18848, 18853, 18858, 18863, 18868, 18873, 18878,
18883, 18888, 18893, 18898, 18903, 18908, 18913, 18918, 18923, 18928, 18933, 18938, 18943, 18948, 18953, 18958,
18963, 18968, 18973, 18978, 18983, 18988, 18993, 18998, 19003, 19008, 19013, 19018, 19023, 19028, 19033, 19038,
19043, 19048, 19053, 19058, 19063, 19068, 19073, 19078, 19083, 19088, 19093, 19098, 19103, 19108, 19113, 19118,
19123, 19128, 19133, 19138, 19143, 19148, 19153, 19158, 19163, 19168, 19173, 19178, 19183, 19188, 19193, 19198,
19203, 19208, 19213, 19218, 19223, 19228, 19233, 19238, 19243, 19248, 19253, 19258, 19263, 19268, 19273, 19278,
19283, 19288, 19293, 19298, 19303, 19308, 19313, 19318, 19323, 19328, 19333, 19338, 19343, 19348, 19353, 19358,
19363, 19368, 19373, 19378, 19383, 19388, 19393, 19398, 19403, 19408, 19413, 19418, 19423, 19428, 19433, 19438,
19443, 19448, 19453, 19458, 19463, 19468, 19473, 19478, 19483, 19488, 19493, 19498, 19503, 19508, 19513, 19518,
19523, 19528, 19533, 19538, 19543, 19548, 19553, 19558, 19563, 19568, 19573, 19578, 19583, 19588, 19593, 19598,
19603, 19608, 19613, 19618, 19623, 19628, 19633, 19638, 19643, 19648, 19653, 19658, 19663, 19668, 19673, 19678,
19683, 19688, 19693, 19698, 19703, 19708, 19713, 19718, 19723, 19728, 19733, 19738, 19743, 19748, 19753, 19758,
19763, 19768, 19773, 19778, 19783, 19788, 19793, 19798, 19803, 19808, 19813, 19818, 19823, 19828, 19833, 19838,
19843, 19848, 19853, 19858, 19863, 19868, 19873, 19878, 19883, 19888, 19893, 19898, 19903, 19908, 19913, 19918,
19923, 19928, 19933, 19938, 19943, 19948, 19953, 19958, 19963, 19968, 19973, 19978, 19983, 19988, 19993, 19998,
20003, 20008, 20013, 20018, 20023, 20028, 20033, 20038, 20043, 20048, 20053, 20058, 20063, 20068, 20073, 20078,
20083, 20088, 20093, 20098, 20103, 20108, 20113, 20118, 20123, 20128, 20133, 20138, 20143, 20148, 20153, 20158,
20163, 20168, 20173, 20178, 20183, 20188, 20193, 20198, 20203, 20208, 20213, 20218, 20223, 20228, 20233, 20238,
20243, 20248, 20253, 20258, 20263, 20268, 20273, 20278, 20283, 20288, 20293, 20298, 20303, 20308, 20313, 20318,
20323, 20328, 20333, 20338, 20343, 20348, 20353, 20358, 20363, 20368, 20373, 20378, 20383, 20388, 20393, 20398,
20403, 20408, 20413, 20418, 20423, 20428, 20433, 20438, 20443, 20448, 20453, 20458, 20463, 20468, 20473, 20478
);

constant ETMHF_PT_LUT : etm_pt_lut_array := ETM_PT_LUT;
constant HTM_PT_LUT : etm_pt_lut_array := ETM_PT_LUT;

-- muon pt LUTs
-- type muon_pt_lut_array is array (0 to 2**(D_S_I_MUON_V2.pt_high-D_S_I_MUON_V2.pt_low+1)-1) of natural range 0 to 2555;
-- HB 2017-01-20: updated for corrected scale
-- type muon_pt_lut_array is array (0 to 2**(D_S_I_MUON_V2.pt_high-D_S_I_MUON_V2.pt_low+1)-1) of natural range 0 to 2553;
type muon_pt_lut_array is array (0 to 2**MUON_PT_WIDTH-1) of natural range 0 to 2553;

-- HB 2017-01-20: updated for corrected scale
constant MU_PT_LUT : muon_pt_lut_array := (
0, 3, 8, 13, 18, 23, 28, 33, 38, 43, 48, 53, 58, 63, 68, 73,
78, 83, 88, 93, 98, 103, 108, 113, 118, 123, 128, 133, 138, 143, 148, 153,
158, 163, 168, 173, 178, 183, 188, 193, 198, 203, 208, 213, 218, 223, 228, 233,
238, 243, 248, 253, 258, 263, 268, 273, 278, 283, 288, 293, 298, 303, 308, 313,
318, 323, 328, 333, 338, 343, 348, 353, 358, 363, 368, 373, 378, 383, 388, 393,
398, 403, 408, 413, 418, 423, 428, 433, 438, 443, 448, 453, 458, 463, 468, 473,
478, 483, 488, 493, 498, 503, 508, 513, 518, 523, 528, 533, 538, 543, 548, 553,
558, 563, 568, 573, 578, 583, 588, 593, 598, 603, 608, 613, 618, 623, 628, 633,
638, 643, 648, 653, 658, 663, 668, 673, 678, 683, 688, 693, 698, 703, 708, 713,
718, 723, 728, 733, 738, 743, 748, 753, 758, 763, 768, 773, 778, 783, 788, 793,
798, 803, 808, 813, 818, 823, 828, 833, 838, 843, 848, 853, 858, 863, 868, 873,
878, 883, 888, 893, 898, 903, 908, 913, 918, 923, 928, 933, 938, 943, 948, 953,
958, 963, 968, 973, 978, 983, 988, 993, 998, 1003, 1008, 1013, 1018, 1023, 1028, 1033,
1038, 1043, 1048, 1053, 1058, 1063, 1068, 1073, 1078, 1083, 1088, 1093, 1098, 1103, 1108, 1113,
1118, 1123, 1128, 1133, 1138, 1143, 1148, 1153, 1158, 1163, 1168, 1173, 1178, 1183, 1188, 1193,
1198, 1203, 1208, 1213, 1218, 1223, 1228, 1233, 1238, 1243, 1248, 1253, 1258, 1263, 1268, 1273,
1278, 1283, 1288, 1293, 1298, 1303, 1308, 1313, 1318, 1323, 1328, 1333, 1338, 1343, 1348, 1353,
1358, 1363, 1368, 1373, 1378, 1383, 1388, 1393, 1398, 1403, 1408, 1413, 1418, 1423, 1428, 1433,
1438, 1443, 1448, 1453, 1458, 1463, 1468, 1473, 1478, 1483, 1488, 1493, 1498, 1503, 1508, 1513,
1518, 1523, 1528, 1533, 1538, 1543, 1548, 1553, 1558, 1563, 1568, 1573, 1578, 1583, 1588, 1593,
1598, 1603, 1608, 1613, 1618, 1623, 1628, 1633, 1638, 1643, 1648, 1653, 1658, 1663, 1668, 1673,
1678, 1683, 1688, 1693, 1698, 1703, 1708, 1713, 1718, 1723, 1728, 1733, 1738, 1743, 1748, 1753,
1758, 1763, 1768, 1773, 1778, 1783, 1788, 1793, 1798, 1803, 1808, 1813, 1818, 1823, 1828, 1833,
1838, 1843, 1848, 1853, 1858, 1863, 1868, 1873, 1878, 1883, 1888, 1893, 1898, 1903, 1908, 1913,
1918, 1923, 1928, 1933, 1938, 1943, 1948, 1953, 1958, 1963, 1968, 1973, 1978, 1983, 1988, 1993,
1998, 2003, 2008, 2013, 2018, 2023, 2028, 2033, 2038, 2043, 2048, 2053, 2058, 2063, 2068, 2073,
2078, 2083, 2088, 2093, 2098, 2103, 2108, 2113, 2118, 2123, 2128, 2133, 2138, 2143, 2148, 2153,
2158, 2163, 2168, 2173, 2178, 2183, 2188, 2193, 2198, 2203, 2208, 2213, 2218, 2223, 2228, 2233,
2238, 2243, 2248, 2253, 2258, 2263, 2268, 2273, 2278, 2283, 2288, 2293, 2298, 2303, 2308, 2313,
2318, 2323, 2328, 2333, 2338, 2343, 2348, 2353, 2358, 2363, 2368, 2373, 2378, 2383, 2388, 2393,
2398, 2403, 2408, 2413, 2418, 2423, 2428, 2433, 2438, 2443, 2448, 2453, 2458, 2463, 2468, 2473,
-- 2478, 2483, 2488, 2493, 2498, 2503, 2508, 2513, 2518, 2523, 2528, 2533, 2538, 2543, 2548, 2555
2478, 2483, 2488, 2493, 2498, 2503, 2508, 2513, 2518, 2523, 2528, 2533, 2538, 2543, 2548, 2553
);

constant MUON_PT_LUT : muon_pt_lut_array := MU_PT_LUT;

-- calo-calo cosh deta LUTs
type calo_calo_cosh_deta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range 0 to 10597282;
-- type eg_eg_cosh_deta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range 0 to 10597282;
-- type eg_jet_cosh_deta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range 0 to 10597282;
-- type eg_tau_cosh_deta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range 0 to 10597282;
-- type jet_jet_cosh_deta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range 0 to 10597282;
-- type jet_tau_cosh_deta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range 0 to 10597282;
-- type tau_tau_cosh_deta_lut_array is array (0 to 2**MAX_CALO_ETA_BITS-1) of natural range 0 to 10597282;

constant CALO_CALO_COSH_DETA_LUT : calo_calo_cosh_deta_lut_array := (
1000, 1001, 1004, 1009, 1015, 1024, 1034, 1047, 1061, 1078, 1096, 1117, 1139, 1164, 1191, 1221,
1252, 1286, 1323, 1361, 1403, 1447, 1494, 1544, 1596, 1652, 1711, 1773, 1838, 1907, 1979, 2056,
2136, 2220, 2308, 2401, 2498, 2600, 2707, 2819, 2936, 3059, 3188, 3323, 3464, 3611, 3766, 3927,
4096, 4273, 4458, 4651, 4853, 5064, 5285, 5516, 5757, 6010, 6273, 6548, 6836, 7137, 7451, 7780,
8123, 8481, 8856, 9247, 9656, 10083, 10529, 10995, 11482, 11990, 12522, 13077, 13656, 14262, 14894, 15555,
16245, 16966, 17719, 18506, 19327, 20186, 21082, 22018, 22996, 24018, 25085, 26199, 27363, 28579, 29848, 31175,
32560, 34007, 35518, 37097, 38746, 40468, 42266, 44145, 46107, 48157, 50297, 52533, 54868, 57307, 59855, 62516,
65295, 68197, 71229, 74396, 77703, 81157, 84765, 88534, 92470, 96581, 100875, 105359, 110043, 114936, 120045, 125382,
130957, 136779, 142860, 149211, 155845, 162774, 170011, 177569, 185464, 193709, 202322, 211317, 220712, 230525, 240774, 251478,
262659, 274337, 286534, 299273, 312578, 326476, 340991, 356151, 371985, 388524, 405798, 423839, 442683, 462365, 482921, 504392,
526817, 550240, 574703, 600254, 626942, 654815, 683928, 714336, 746095, 779267, 813913, 850099, 887895, 927370, 968601, 1011665,
1056644, 1103622, 1152689, 1203938, 1257465, 1313372, 1371764, 1432753, 1496453, 1562985, 1632476, 1705055, 1780862, 1860039, 1942737, 2029111,
2119325, 2213550, 2311964, 2414754, 2522114, 2634248, 2751366, 2873692, 3001456, 3134901, 3274279, 3419853, 3571900, 3730706, 3896573, 4069815,
4250759, 4439748, 4637139, 4843306, 5058639, 5283546, 5518453, 5763803, 6020062, 6287714, 6567266, 6859246, 7164208, 7482729, 7815411, 8162884,
8525806, 8904863, 9300773, 9714286, 10146183, 10597282, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

constant EG_EG_COSH_DETA_LUT : calo_calo_cosh_deta_lut_array := CALO_CALO_COSH_DETA_LUT;
constant EG_TAU_COSH_DETA_LUT : calo_calo_cosh_deta_lut_array := CALO_CALO_COSH_DETA_LUT;
constant EG_JET_COSH_DETA_LUT : calo_calo_cosh_deta_lut_array := CALO_CALO_COSH_DETA_LUT;
constant JET_EG_COSH_DETA_LUT : calo_calo_cosh_deta_lut_array := CALO_CALO_COSH_DETA_LUT;
constant JET_JET_COSH_DETA_LUT : calo_calo_cosh_deta_lut_array := CALO_CALO_COSH_DETA_LUT;
constant JET_TAU_COSH_DETA_LUT : calo_calo_cosh_deta_lut_array := CALO_CALO_COSH_DETA_LUT;
constant TAU_EG_COSH_DETA_LUT : calo_calo_cosh_deta_lut_array := CALO_CALO_COSH_DETA_LUT;
constant TAU_JET_COSH_DETA_LUT : calo_calo_cosh_deta_lut_array := CALO_CALO_COSH_DETA_LUT;
constant TAU_TAU_COSH_DETA_LUT : calo_calo_cosh_deta_lut_array := CALO_CALO_COSH_DETA_LUT;

-- calo-calo cos dphi LUTs
type calo_calo_cos_dphi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range -1000 to 1000;
-- type eg_eg_cos_dphi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range -1000 to 1000;
-- type eg_jet_cos_dphi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range -1000 to 1000;
-- type eg_tau_cos_dphi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range -1000 to 1000;
-- type jet_jet_cos_dphi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range -1000 to 1000;
-- type jet_tau_cos_dphi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range -1000 to 1000;
-- type tau_tau_cos_dphi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range -1000 to 1000;
-- type eg_etm_cos_dphi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range -1000 to 1000;
-- type jet_etm_cos_dphi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range -1000 to 1000;
-- type tau_etm_cos_dphi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range -1000 to 1000;

constant CALO_CALO_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := (
1000, 999, 996, 991, 985, 976, 966, 954, 940, 924, 906, 887, 866, 843, 819, 793,
766, 737, 707, 676, 643, 609, 574, 537, 500, 462, 423, 383, 342, 301, 259, 216,
174, 131, 87, 44, 0, -44, -87, -131, -174, -216, -259, -301, -342, -383, -423, -462,
-500, -537, -574, -609, -643, -676, -707, -737, -766, -793, -819, -843, -866, -887, -906, -924,
-940, -954, -966, -976, -985, -991, -996, -999, -1000, -999, -996, -991, -985, -976, -966, -954,
-940, -924, -906, -887, -866, -843, -819, -793, -766, -737, -707, -676, -643, -609, -574, -537,
-500, -462, -423, -383, -342, -301, -259, -216, -174, -131, -87, -44, 0, 44, 87, 131,
174, 216, 259, 301, 342, 383, 423, 462, 500, 537, 574, 609, 643, 676, 707, 737,
766, 793, 819, 843, 866, 887, 906, 924, 940, 954, 966, 976, 985, 991, 996, 999,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

constant EG_EG_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := CALO_CALO_COS_DPHI_LUT;
constant EG_TAU_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := CALO_CALO_COS_DPHI_LUT;
constant EG_JET_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := CALO_CALO_COS_DPHI_LUT;
constant JET_EG_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := CALO_CALO_COS_DPHI_LUT;
constant JET_JET_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := CALO_CALO_COS_DPHI_LUT;
constant JET_TAU_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := CALO_CALO_COS_DPHI_LUT;
constant TAU_EG_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := CALO_CALO_COS_DPHI_LUT;
constant TAU_JET_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := CALO_CALO_COS_DPHI_LUT;
constant TAU_TAU_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := CALO_CALO_COS_DPHI_LUT;
constant EG_ETM_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := CALO_CALO_COS_DPHI_LUT;
constant JET_ETM_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := CALO_CALO_COS_DPHI_LUT;
constant TAU_ETM_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := CALO_CALO_COS_DPHI_LUT;
constant EG_ETMHF_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := CALO_CALO_COS_DPHI_LUT;
constant JET_ETMHF_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := CALO_CALO_COS_DPHI_LUT;
constant TAU_ETMHF_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := CALO_CALO_COS_DPHI_LUT;
constant EG_HTM_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := CALO_CALO_COS_DPHI_LUT;
constant JET_HTM_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := CALO_CALO_COS_DPHI_LUT;
constant TAU_HTM_COS_DPHI_LUT : calo_calo_cos_dphi_lut_array := CALO_CALO_COS_DPHI_LUT;

-- muon-muon cosh deta LUTs
type muon_muon_cosh_deta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1)-1) of natural range 0 to 667303;

constant MU_MU_COSH_DETA_LUT : muon_muon_cosh_deta_lut_array := (
10000, 10001, 10002, 10005, 10009, 10015, 10021, 10029, 10038, 10048, 10059, 10072, 10085, 10100, 10116, 10133,
10152, 10171, 10192, 10214, 10237, 10262, 10288, 10314, 10343, 10372, 10402, 10434, 10467, 10501, 10537, 10574,
10612, 10651, 10691, 10733, 10776, 10821, 10866, 10913, 10961, 11011, 11061, 11113, 11167, 11222, 11278, 11335,
11394, 11454, 11515, 11578, 11642, 11708, 11774, 11843, 11912, 11984, 12056, 12130, 12205, 12282, 12360, 12440,
12521, 12604, 12688, 12774, 12861, 12950, 13040, 13132, 13225, 13320, 13417, 13515, 13614, 13716, 13819, 13923,
14029, 14137, 14247, 14358, 14471, 14585, 14702, 14820, 14940, 15061, 15185, 15310, 15437, 15565, 15696, 15829,
15963, 16099, 16237, 16378, 16520, 16664, 16809, 16957, 17107, 17259, 17413, 17569, 17727, 17888, 18050, 18215,
18381, 18550, 18721, 18894, 19070, 19247, 19427, 19610, 19794, 19981, 20171, 20362, 20556, 20753, 20952, 21153,
21357, 21564, 21773, 21984, 22199, 22416, 22635, 22857, 23082, 23310, 23540, 23773, 24009, 24248, 24490, 24734,
24982, 25232, 25486, 25742, 26001, 26264, 26530, 26799, 27070, 27346, 27624, 27906, 28191, 28479, 28771, 29066,
29364, 29666, 29972, 30281, 30593, 30910, 31230, 31553, 31881, 32212, 32547, 32885, 33228, 33575, 33925, 34280,
34638, 35001, 35368, 35739, 36114, 36494, 36877, 37266, 37658, 38055, 38457, 38863, 39274, 39689, 40109, 40534,
40963, 41398, 41837, 42282, 42731, 43185, 43645, 44109, 44579, 45054, 45534, 46020, 46512, 47008, 47511, 48018,
48532, 49051, 49577, 50108, 50645, 51187, 51736, 52291, 52853, 53420, 53994, 54574, 55161, 55754, 56354, 56961,
57574, 58194, 58821, 59455, 60095, 60743, 61399, 62061, 62731, 63408, 64093, 64785, 65485, 66193, 66908, 67632,
68363, 69102, 69850, 70606, 71370, 72143, 72924, 73714, 74513, 75320, 76137, 76962, 77796, 78640, 79493, 80355,
81227, 82109, 83000, 83901, 84812, 85732, 86664, 87605, 88557, 89519, 90491, 91475, 92469, 93474, 94491, 95518,
96557, 97607, 98669, 99742, 100827, 101924, 103033, 104155, 105288, 106434, 107593, 108764, 109949, 111146, 112356, 113580,
114817, 116068, 117332, 118610, 119903, 121209, 122530, 123866, 125215, 126580, 127960, 129355, 130765, 132191, 133632, 135089,
136562, 138052, 139557, 141079, 142618, 144174, 145746, 147336, 148943, 150568, 152211, 153872, 155551, 157248, 158964, 160699,
162453, 164226, 166018, 167830, 169662, 171514, 173386, 175279, 177192, 179127, 181082, 183059, 185058, 187078, 189121, 191186,
193274, 195384, 197518, 199675, 201855, 204060, 206289, 208542, 210819, 213122, 215450, 217803, 220182, 222587, 225018, 227476,
229961, 232473, 235013, 237580, 240176, 242800, 245452, 248134, 250845, 253586, 256356, 259157, 261989, 264852, 267745, 270671,
273629, 276619, 279641, 282697, 285786, 288909, 292066, 295258, 298485, 301747, 305044, 308378, 311748, 315155, 318599, 322081,
325601, 329160, 332757, 336394, 340071, 343788, 347545, 351344, 355184, 359066, 362991, 366958, 370969, 375024, 379123, 383267,
387457, 391692, 395974, 400302, 404678, 409101, 413573, 418094, 422664, 427284, 431955, 436677, 441451, 446276, 451155, 456087,
461073, 466113, 471208, 476360, 481567, 486832, 492154, 497534, 502973, 508472, 514030, 519650, 525331, 531074, 536880, 542749,
548683, 554682, 560746, 566876, 573074, 579339, 585673, 592076, 598549, 605092, 611708, 618396, 625156, 631991, 638901, 645886,
652947, 660086, 667303, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

-- muon-muon cos dphi LUTs
type muon_muon_cos_dphi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of integer range -10000 to 10000;

constant MU_MU_COS_DPHI_LUT : muon_muon_cos_dphi_lut_array := (
10000, 9999, 9998, 9995, 9990, 9985, 9979, 9971, 9962, 9952, 9941, 9928, 9914, 9900, 9884, 9866,
9848, 9829, 9808, 9786, 9763, 9739, 9713, 9687, 9659, 9630, 9600, 9569, 9537, 9504, 9469, 9434,
9397, 9359, 9320, 9280, 9239, 9197, 9153, 9109, 9063, 9016, 8969, 8920, 8870, 8819, 8767, 8714,
8660, 8605, 8549, 8492, 8434, 8375, 8315, 8254, 8192, 8128, 8064, 7999, 7934, 7867, 7799, 7730,
7660, 7590, 7518, 7446, 7373, 7299, 7224, 7148, 7071, 6994, 6915, 6836, 6756, 6675, 6593, 6511,
6428, 6344, 6259, 6174, 6088, 6001, 5913, 5825, 5736, 5646, 5556, 5465, 5373, 5281, 5188, 5094,
5000, 4905, 4810, 4714, 4617, 4520, 4423, 4325, 4226, 4127, 4027, 3927, 3827, 3726, 3624, 3523,
3420, 3317, 3214, 3111, 3007, 2903, 2798, 2693, 2588, 2483, 2377, 2271, 2164, 2058, 1951, 1844,
1736, 1629, 1521, 1413, 1305, 1197, 1089, 980, 872, 763, 654, 545, 436, 327, 218, 109,
0, -109, -218, -327, -436, -545, -654, -763, -872, -980, -1089, -1197, -1305, -1413, -1521, -1629,
-1736, -1844, -1951, -2058, -2164, -2271, -2377, -2483, -2588, -2693, -2798, -2903, -3007, -3111, -3214, -3317,
-3420, -3523, -3624, -3726, -3827, -3927, -4027, -4127, -4226, -4325, -4423, -4520, -4617, -4714, -4810, -4905,
-5000, -5094, -5188, -5281, -5373, -5465, -5556, -5646, -5736, -5825, -5913, -6001, -6088, -6174, -6259, -6344,
-6428, -6511, -6593, -6675, -6756, -6836, -6915, -6994, -7071, -7148, -7224, -7299, -7373, -7446, -7518, -7590,
-7660, -7730, -7799, -7867, -7934, -7999, -8064, -8128, -8192, -8254, -8315, -8375, -8434, -8492, -8549, -8605,
-8660, -8714, -8767, -8819, -8870, -8920, -8969, -9016, -9063, -9109, -9153, -9197, -9239, -9280, -9320, -9359,
-9397, -9434, -9469, -9504, -9537, -9569, -9600, -9630, -9659, -9687, -9713, -9739, -9763, -9786, -9808, -9829,
-9848, -9866, -9884, -9900, -9914, -9928, -9941, -9952, -9962, -9971, -9979, -9985, -9990, -9995, -9998, -9999,
-10000, -9999, -9998, -9995, -9990, -9985, -9979, -9971, -9962, -9952, -9941, -9928, -9914, -9900, -9884, -9866,
-9848, -9829, -9808, -9786, -9763, -9739, -9713, -9687, -9659, -9630, -9600, -9569, -9537, -9504, -9469, -9434,
-9397, -9359, -9320, -9280, -9239, -9197, -9153, -9109, -9063, -9016, -8969, -8920, -8870, -8819, -8767, -8714,
-8660, -8605, -8549, -8492, -8434, -8375, -8315, -8254, -8192, -8128, -8064, -7999, -7934, -7867, -7799, -7730,
-7660, -7590, -7518, -7446, -7373, -7299, -7224, -7148, -7071, -6994, -6915, -6836, -6756, -6675, -6593, -6511,
-6428, -6344, -6259, -6174, -6088, -6001, -5913, -5825, -5736, -5646, -5556, -5465, -5373, -5281, -5188, -5094,
-5000, -4905, -4810, -4714, -4617, -4520, -4423, -4325, -4226, -4127, -4027, -3927, -3827, -3726, -3624, -3523,
-3420, -3317, -3214, -3111, -3007, -2903, -2798, -2693, -2588, -2483, -2377, -2271, -2164, -2058, -1951, -1844,
-1736, -1629, -1521, -1413, -1305, -1197, -1089, -980, -872, -763, -654, -545, -436, -327, -218, -109,
0, 109, 218, 327, 436, 545, 654, 763, 872, 980, 1089, 1197, 1305, 1413, 1521, 1629,
1736, 1844, 1951, 2058, 2164, 2271, 2377, 2483, 2588, 2693, 2798, 2903, 3007, 3111, 3214, 3317,
3420, 3523, 3624, 3726, 3827, 3927, 4027, 4127, 4226, 4325, 4423, 4520, 4617, 4714, 4810, 4905,
5000, 5094, 5188, 5281, 5373, 5465, 5556, 5646, 5736, 5825, 5913, 6001, 6088, 6174, 6259, 6344,
6428, 6511, 6593, 6675, 6756, 6836, 6915, 6994, 7071, 7148, 7224, 7299, 7373, 7446, 7518, 7590,
7660, 7730, 7799, 7867, 7934, 7999, 8064, 8128, 8192, 8254, 8315, 8375, 8434, 8492, 8549, 8605,
8660, 8714, 8767, 8819, 8870, 8920, 8969, 9016, 9063, 9109, 9153, 9197, 9239, 9280, 9320, 9359,
9397, 9434, 9469, 9504, 9537, 9569, 9600, 9630, 9659, 9687, 9713, 9739, 9763, 9786, 9808, 9829,
9848, 9866, 9884, 9900, 9914, 9928, 9941, 9952, 9962, 9971, 9979, 9985, 9990, 9995, 9998, 9999,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

constant MUON_MUON_COS_DPHI_LUT : muon_muon_cos_dphi_lut_array := MU_MU_COS_DPHI_LUT;

-- muon-muon cosh deta LUTs
type calo_muon_cosh_deta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1+1)-1) of natural range 0 to 109487199;
-- type eg_muon_cosh_deta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1+1)-1) of natural range 0 to 109487199;
-- type jet_muon_cosh_deta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1+1)-1) of natural range 0 to 109487199;
-- type tau_muon_cosh_deta_lut_array is array (0 to 2**(MUON_ETA_HIGH-MUON_ETA_LOW+1+1)-1) of natural range 0 to 109487199;

constant CALO_MUON_COSH_DETA_LUT : calo_muon_cosh_deta_lut_array := (
10000, 10001, 10002, 10005, 10009, 10015, 10021, 10029, 10038, 10048, 10059, 10072, 10085, 10100, 10116, 10133,
10152, 10171, 10192, 10214, 10237, 10262, 10288, 10314, 10343, 10372, 10402, 10434, 10467, 10501, 10537, 10574,
10612, 10651, 10691, 10733, 10776, 10821, 10866, 10913, 10961, 11011, 11061, 11113, 11167, 11222, 11278, 11335,
11394, 11454, 11515, 11578, 11642, 11708, 11774, 11843, 11912, 11984, 12056, 12130, 12205, 12282, 12360, 12440,
12521, 12604, 12688, 12774, 12861, 12950, 13040, 13132, 13225, 13320, 13417, 13515, 13614, 13716, 13819, 13923,
14029, 14137, 14247, 14358, 14471, 14585, 14702, 14820, 14940, 15061, 15185, 15310, 15437, 15565, 15696, 15829,
15963, 16099, 16237, 16378, 16520, 16664, 16809, 16957, 17107, 17259, 17413, 17569, 17727, 17888, 18050, 18215,
18381, 18550, 18721, 18894, 19070, 19247, 19427, 19610, 19794, 19981, 20171, 20362, 20556, 20753, 20952, 21153,
21357, 21564, 21773, 21984, 22199, 22416, 22635, 22857, 23082, 23310, 23540, 23773, 24009, 24248, 24490, 24734,
24982, 25232, 25486, 25742, 26001, 26264, 26530, 26799, 27070, 27346, 27624, 27906, 28191, 28479, 28771, 29066,
29364, 29666, 29972, 30281, 30593, 30910, 31230, 31553, 31881, 32212, 32547, 32885, 33228, 33575, 33925, 34280,
34638, 35001, 35368, 35739, 36114, 36494, 36877, 37266, 37658, 38055, 38457, 38863, 39274, 39689, 40109, 40534,
40963, 41398, 41837, 42282, 42731, 43185, 43645, 44109, 44579, 45054, 45534, 46020, 46512, 47008, 47511, 48018,
48532, 49051, 49577, 50108, 50645, 51187, 51736, 52291, 52853, 53420, 53994, 54574, 55161, 55754, 56354, 56961,
57574, 58194, 58821, 59455, 60095, 60743, 61399, 62061, 62731, 63408, 64093, 64785, 65485, 66193, 66908, 67632,
68363, 69102, 69850, 70606, 71370, 72143, 72924, 73714, 74513, 75320, 76137, 76962, 77796, 78640, 79493, 80355,
81227, 82109, 83000, 83901, 84812, 85732, 86664, 87605, 88557, 89519, 90491, 91475, 92469, 93474, 94491, 95518,
96557, 97607, 98669, 99742, 100827, 101924, 103033, 104155, 105288, 106434, 107593, 108764, 109949, 111146, 112356, 113580,
114817, 116068, 117332, 118610, 119903, 121209, 122530, 123866, 125215, 126580, 127960, 129355, 130765, 132191, 133632, 135089,
136562, 138052, 139557, 141079, 142618, 144174, 145746, 147336, 148943, 150568, 152211, 153872, 155551, 157248, 158964, 160699,
162453, 164226, 166018, 167830, 169662, 171514, 173386, 175279, 177192, 179127, 181082, 183059, 185058, 187078, 189121, 191186,
193274, 195384, 197518, 199675, 201855, 204060, 206289, 208542, 210819, 213122, 215450, 217803, 220182, 222587, 225018, 227476,
229961, 232473, 235013, 237580, 240176, 242800, 245452, 248134, 250845, 253586, 256356, 259157, 261989, 264852, 267745, 270671,
273629, 276619, 279641, 282697, 285786, 288909, 292066, 295258, 298485, 301747, 305044, 308378, 311748, 315155, 318599, 322081,
325601, 329160, 332757, 336394, 340071, 343788, 347545, 351344, 355184, 359066, 362991, 366958, 370969, 375024, 379123, 383267,
387457, 391692, 395974, 400302, 404678, 409101, 413573, 418094, 422664, 427284, 431955, 436677, 441451, 446276, 451155, 456087,
461073, 466113, 471208, 476360, 481567, 486832, 492154, 497534, 502973, 508472, 514030, 519650, 525331, 531074, 536880, 542749,
548683, 554682, 560746, 566876, 573074, 579339, 585673, 592076, 598549, 605092, 611708, 618396, 625156, 631991, 638901, 645886,
652947, 660086, 667303, 674599, 681974, 689430, 696968, 704588, 712291, 720079, 727952, 735911, 743957, 752091, 760314, 768627,
777030, 785526, 794114, 802797, 811574, 820448, 829418, 838486, 847654, 856922, 866291, 875763, 885338, 895018, 904804, 914697,
924698, 934808, 945029, 955362, 965808, 976368, 987043, 997835, 1008745, 1019775, 1030925, 1042197, 1053592, 1065112, 1076757, 1088531,
1100432, 1112465, 1124628, 1136925, 1149356, 1161923, 1174627, 1187470, 1200454, 1213580, 1226849, 1240264, 1253825, 1267534, 1281393, 1295404,
1309568, 1323887, 1338362, 1352996, 1367790, 1382745, 1397864, 1413148, 1428600, 1444220, 1460012, 1475975, 1492114, 1508429, 1524922, 1541596,
1558452, 1575492, 1592719, 1610134, 1627739, 1645537, 1663530, 1681719, 1700107, 1718696, 1737489, 1756487, 1775693, 1795108, 1814736, 1834579,
1854639, 1874918, 1895418, 1916143, 1937095, 1958275, 1979688, 2001334, 2023217, 2045339, 2067703, 2090312, 2113168, 2136274, 2159632, 2183246,
2207118, 2231252, 2255649, 2280312, 2305246, 2330452, 2355934, 2381694, 2407736, 2434063, 2460678, 2487583, 2514783, 2542280, 2570078, 2598180,
2626590, 2655309, 2684343, 2713695, 2743367, 2773364, 2803688, 2834345, 2865336, 2896667, 2928340, 2960359, 2992728, 3025452, 3058533, 3091976,
3125784, 3159962, 3194514, 3229444, 3264756, 3300454, 3336542, 3373025, 3409906, 3447191, 3484884, 3522989, 3561510, 3600453, 3639821, 3679620,
3719854, 3760528, 3801647, 3843215, 3885238, 3927721, 3970668, 4014084, 4057975, 4102346, 4147203, 4192550, 4238392, 4284736, 4331587, 4378950,
4426831, 4475235, 4524169, 4573637, 4623647, 4674204, 4725313, 4776981, 4829214, 4882018, 4935400, 4989365, 5043920, 5099072, 5154827, 5211192,
5268173, 5325776, 5384010, 5442881, 5502395, 5562560, 5623383, 5684871, 5747031, 5809871, 5873398, 5937620, 6002544, 6068177, 6134529, 6201606,
6269416, 6337968, 6407270, 6477329, 6548154, 6619754, 6692137, 6765311, 6839285, 6914068, 6989669, 7066096, 7143359, 7221467, 7300429, 7380254,
7460952, 7542533, 7625006, 7708380, 7792666, 7877874, 7964013, 8051094, 8139128, 8228124, 8318093, 8409046, 8500993, 8593946, 8687915, 8782911,
8878947, 8976032, 9074179, 9173399, 9273705, 9375106, 9477617, 9581248, 9686013, 9791923, 9898992, 10007231, 10116653, 10227272, 10339100, 10452152,
10566439, 10681976, 10798777, 10916854, 11036223, 11156897, 11278890, 11402217, 11526893, 11652932, 11780349, 11909159, 12039378, 12171021, 12304103, 12438640,
12574649, 12712144, 12851143, 12991662, 13133717, 13277326, 13422505, 13569271, 13717642, 13867636, 14019269, 14172561, 14327528, 14484191, 14642566, 14802673,
14964530, 15128158, 15293574, 15460799, 15629853, 15800755, 15973526, 16148186, 16324756, 16503257, 16683709, 16866134, 17050554, 17236991, 17425466, 17616002,
17808622, 18003347, 18200202, 18399210, 18600393, 18803776, 19009383, 19217238, 19427366, 19639792, 19854540, 20071636, 20291107, 20512977, 20737273, 20964021,
21193249, 21424983, 21659252, 21896081, 22135501, 22377538, 22622222, 22869581, 23119645, 23372443, 23628005, 23886362, 24147544, 24411582, 24678506, 24948350,
25221144, 25496920, 25775712, 26057553, 26342475, 26630513, 26921700, 27216072, 27513662, 27814506, 28118639, 28426098, 28736919, 29051138, 29368793, 29689922,
30014562, 30342752, 30674530, 31009936, 31349009, 31691790, 32038319, 32388637, 32742786, 33100807, 33462743, 33828636, 34198530, 34572468, 34950496, 35332657,
35718996, 36109560, 36504395, 36903546, 37307062, 37714991, 38127380, 38544278, 38965734, 39391799, 39822523, 40257956, 40698150, 41143158, 41593032, 42047824,
42507590, 42972383, 43442258, 43917270, 44397477, 44882935, 45373700, 45869832, 46371389, 46878430, 47391015, 47909204, 48433060, 48962644, 49498019, 50039247,
50586394, 51139523, 51698700, 52263992, 52835465, 53413186, 53997224, 54587649, 55184529, 55787936, 56397940, 57014615, 57638033, 58268267, 58905393, 59549485,
60200619, 60858874, 61524326, 62197054, 62877139, 63564659, 64259697, 64962335, 65672656, 66390743, 67116683, 67850560, 68592462, 69342475, 70100690, 70867195,
71642082, 72425441, 73217366, 74017950, 74827288, 75645476, 76472610, 77308788, 78154109, 79008673, 79872582, 80745936, 81628841, 82521399, 83423716, 84335900,
85258058, 86190300, 87132734, 88085474, 89048631, 90022320, 91006655, 92001753, 93007733, 94024712, 95052810, 96092151, 97142856, 98205050, 99278858, 100364407,
101461827, 102571246, 103692795, 104826608, 105972819, 107131563, 108302976, 109487199, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

constant EG_MU_COSH_DETA_LUT : calo_muon_cosh_deta_lut_array := CALO_MUON_COSH_DETA_LUT;
constant TAU_MU_COSH_DETA_LUT : calo_muon_cosh_deta_lut_array := CALO_MUON_COSH_DETA_LUT;
constant JET_MU_COSH_DETA_LUT : calo_muon_cosh_deta_lut_array := CALO_MUON_COSH_DETA_LUT;

-- calo-muon cos dphi LUTs
type calo_muon_cos_dphi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of integer range -10000 to 10000;
-- type eg_muon_cos_dphi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of integer range -10000 to 10000;
-- type jet_muon_cos_dphi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of integer range -10000 to 10000;
-- type tau_muon_cos_dphi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of integer range -10000 to 10000;

constant CALO_MUON_COS_DPHI_LUT : calo_muon_cos_dphi_lut_array := (
10000, 9999, 9998, 9995, 9990, 9985, 9979, 9971, 9962, 9952, 9941, 9928, 9914, 9900, 9884, 9866,
9848, 9829, 9808, 9786, 9763, 9739, 9713, 9687, 9659, 9630, 9600, 9569, 9537, 9504, 9469, 9434,
9397, 9359, 9320, 9280, 9239, 9197, 9153, 9109, 9063, 9016, 8969, 8920, 8870, 8819, 8767, 8714,
8660, 8605, 8549, 8492, 8434, 8375, 8315, 8254, 8192, 8128, 8064, 7999, 7934, 7867, 7799, 7730,
7660, 7590, 7518, 7446, 7373, 7299, 7224, 7148, 7071, 6994, 6915, 6836, 6756, 6675, 6593, 6511,
6428, 6344, 6259, 6174, 6088, 6001, 5913, 5825, 5736, 5646, 5556, 5465, 5373, 5281, 5188, 5094,
5000, 4905, 4810, 4714, 4617, 4520, 4423, 4325, 4226, 4127, 4027, 3927, 3827, 3726, 3624, 3523,
3420, 3317, 3214, 3111, 3007, 2903, 2798, 2693, 2588, 2483, 2377, 2271, 2164, 2058, 1951, 1844,
1736, 1629, 1521, 1413, 1305, 1197, 1089, 980, 872, 763, 654, 545, 436, 327, 218, 109,
0, -109, -218, -327, -436, -545, -654, -763, -872, -980, -1089, -1197, -1305, -1413, -1521, -1629,
-1736, -1844, -1951, -2058, -2164, -2271, -2377, -2483, -2588, -2693, -2798, -2903, -3007, -3111, -3214, -3317,
-3420, -3523, -3624, -3726, -3827, -3927, -4027, -4127, -4226, -4325, -4423, -4520, -4617, -4714, -4810, -4905,
-5000, -5094, -5188, -5281, -5373, -5465, -5556, -5646, -5736, -5825, -5913, -6001, -6088, -6174, -6259, -6344,
-6428, -6511, -6593, -6675, -6756, -6836, -6915, -6994, -7071, -7148, -7224, -7299, -7373, -7446, -7518, -7590,
-7660, -7730, -7799, -7867, -7934, -7999, -8064, -8128, -8192, -8254, -8315, -8375, -8434, -8492, -8549, -8605,
-8660, -8714, -8767, -8819, -8870, -8920, -8969, -9016, -9063, -9109, -9153, -9197, -9239, -9280, -9320, -9359,
-9397, -9434, -9469, -9504, -9537, -9569, -9600, -9630, -9659, -9687, -9713, -9739, -9763, -9786, -9808, -9829,
-9848, -9866, -9884, -9900, -9914, -9928, -9941, -9952, -9962, -9971, -9979, -9985, -9990, -9995, -9998, -9999,
-10000, -9999, -9998, -9995, -9990, -9985, -9979, -9971, -9962, -9952, -9941, -9928, -9914, -9900, -9884, -9866,
-9848, -9829, -9808, -9786, -9763, -9739, -9713, -9687, -9659, -9630, -9600, -9569, -9537, -9504, -9469, -9434,
-9397, -9359, -9320, -9280, -9239, -9197, -9153, -9109, -9063, -9016, -8969, -8920, -8870, -8819, -8767, -8714,
-8660, -8605, -8549, -8492, -8434, -8375, -8315, -8254, -8192, -8128, -8064, -7999, -7934, -7867, -7799, -7730,
-7660, -7590, -7518, -7446, -7373, -7299, -7224, -7148, -7071, -6994, -6915, -6836, -6756, -6675, -6593, -6511,
-6428, -6344, -6259, -6174, -6088, -6001, -5913, -5825, -5736, -5646, -5556, -5465, -5373, -5281, -5188, -5094,
-5000, -4905, -4810, -4714, -4617, -4520, -4423, -4325, -4226, -4127, -4027, -3927, -3827, -3726, -3624, -3523,
-3420, -3317, -3214, -3111, -3007, -2903, -2798, -2693, -2588, -2483, -2377, -2271, -2164, -2058, -1951, -1844,
-1736, -1629, -1521, -1413, -1305, -1197, -1089, -980, -872, -763, -654, -545, -436, -327, -218, -109,
0, 109, 218, 327, 436, 545, 654, 763, 872, 980, 1089, 1197, 1305, 1413, 1521, 1629,
1736, 1844, 1951, 2058, 2164, 2271, 2377, 2483, 2588, 2693, 2798, 2903, 3007, 3111, 3214, 3317,
3420, 3523, 3624, 3726, 3827, 3927, 4027, 4127, 4226, 4325, 4423, 4520, 4617, 4714, 4810, 4905,
5000, 5094, 5188, 5281, 5373, 5465, 5556, 5646, 5736, 5825, 5913, 6001, 6088, 6174, 6259, 6344,
6428, 6511, 6593, 6675, 6756, 6836, 6915, 6994, 7071, 7148, 7224, 7299, 7373, 7446, 7518, 7590,
7660, 7730, 7799, 7867, 7934, 7999, 8064, 8128, 8192, 8254, 8315, 8375, 8434, 8492, 8549, 8605,
8660, 8714, 8767, 8819, 8870, 8920, 8969, 9016, 9063, 9109, 9153, 9197, 9239, 9280, 9320, 9359,
9397, 9434, 9469, 9504, 9537, 9569, 9600, 9630, 9659, 9687, 9713, 9739, 9763, 9786, 9808, 9829,
9848, 9866, 9884, 9900, 9914, 9928, 9941, 9952, 9962, 9971, 9979, 9985, 9990, 9995, 9998, 9999,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

constant EG_MU_COS_DPHI_LUT : calo_muon_cos_dphi_lut_array := CALO_MUON_COS_DPHI_LUT;
constant TAU_MU_COS_DPHI_LUT : calo_muon_cos_dphi_lut_array := CALO_MUON_COS_DPHI_LUT;
constant JET_MU_COS_DPHI_LUT : calo_muon_cos_dphi_lut_array := CALO_MUON_COS_DPHI_LUT;

-- muon-esums cos dphi LUTs
-- type muon_etm_cos_dphi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of integer range -10000 to 10000;
-- type muon_etmhf_cos_dphi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of integer range -10000 to 10000;
-- type muon_htm_cos_dphi_lut_array is array (0 to 2**(MUON_PHI_HIGH-MUON_PHI_LOW+1)-1) of integer range -10000 to 10000;

constant MU_ETM_COS_DPHI_LUT : calo_muon_cos_dphi_lut_array := CALO_MUON_COS_DPHI_LUT;
constant MU_ETMHF_COS_DPHI_LUT : calo_muon_cos_dphi_lut_array := CALO_MUON_COS_DPHI_LUT;
constant MU_HTM_COS_DPHI_LUT : calo_muon_cos_dphi_lut_array := CALO_MUON_COS_DPHI_LUT;

-- twobody-pt LUTs (for mass_cuts.vhd)

-- HB 2016-12-13: LUTs for cosine(phi) and sine(phi) for twobody-pt calculation of calo objecttypes.
-- Center of phi bins for calculation of cosine and sine with 3 digits after decimal point
type calo_sin_cos_phi_lut_array is array (0 to 2**MAX_CALO_PHI_BITS-1) of integer range -1000 to 1000;

constant CALO_COS_PHI_LUT : calo_sin_cos_phi_lut_array := (
1000, 998, 994, 988, 981, 971, 960, 947, 932, 915, 897, 877, 855, 831, 806, 780,
752, 722, 692, 659, 626, 591, 556, 519, 481, 442, 403, 362, 321, 280, 238, 195,
152, 109, 65, 22, -22, -65, -109, -152, -195, -238, -280, -321, -362, -403, -442, -481,
-519, -556, -591, -626, -659, -692, -722, -752, -780, -806, -831, -855, -877, -897, -915, -932,
-947, -960, -971, -981, -988, -994, -998, -1000, -1000, -998, -994, -988, -981, -971, -960, -947,
-932, -915, -897, -877, -855, -831, -806, -780, -752, -722, -692, -659, -626, -591, -556, -519,
-481, -442, -403, -362, -321, -280, -238, -195, -152, -109, -65, -22, 22, 65, 109, 152,
195, 238, 280, 321, 362, 403, 442, 481, 519, 556, 591, 626, 659, 692, 722, 752,
780, 806, 831, 855, 877, 897, 915, 932, 947, 960, 971, 981, 988, 994, 998, 1000,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

constant EG_COS_PHI_LUT : calo_sin_cos_phi_lut_array := CALO_COS_PHI_LUT;
constant TAU_COS_PHI_LUT : calo_sin_cos_phi_lut_array := CALO_COS_PHI_LUT;
constant JET_COS_PHI_LUT : calo_sin_cos_phi_lut_array := CALO_COS_PHI_LUT;
constant ETM_COS_PHI_LUT : calo_sin_cos_phi_lut_array := CALO_COS_PHI_LUT;
constant ETMHF_COS_PHI_LUT : calo_sin_cos_phi_lut_array := CALO_COS_PHI_LUT;
constant HTM_COS_PHI_LUT : calo_sin_cos_phi_lut_array := CALO_COS_PHI_LUT;

constant CALO_SIN_PHI_LUT : calo_sin_cos_phi_lut_array := (
22, 65, 109, 152, 195, 238, 280, 321, 362, 403, 442, 481, 519, 556, 591, 626,
659, 692, 722, 752, 780, 806, 831, 855, 877, 897, 915, 932, 947, 960, 971, 981,
988, 994, 998, 1000, 1000, 998, 994, 988, 981, 971, 960, 947, 932, 915, 897, 877,
855, 831, 806, 780, 752, 722, 692, 659, 626, 591, 556, 519, 481, 442, 403, 362,
321, 280, 238, 195, 152, 109, 65, 22, -22, -65, -109, -152, -195, -238, -280, -321,
-362, -403, -442, -481, -519, -556, -591, -626, -659, -692, -722, -752, -780, -806, -831, -855,
-877, -897, -915, -932, -947, -960, -971, -981, -988, -994, -998, -1000, -1000, -998, -994, -988,
-981, -971, -960, -947, -932, -915, -897, -877, -855, -831, -806, -780, -752, -722, -692, -659,
-626, -591, -556, -519, -481, -442, -403, -362, -321, -280, -238, -195, -152, -109, -65, -22,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

constant EG_SIN_PHI_LUT : calo_sin_cos_phi_lut_array := CALO_SIN_PHI_LUT;
constant TAU_SIN_PHI_LUT : calo_sin_cos_phi_lut_array := CALO_SIN_PHI_LUT;
constant JET_SIN_PHI_LUT : calo_sin_cos_phi_lut_array := CALO_SIN_PHI_LUT;
constant ETM_SIN_PHI_LUT : calo_sin_cos_phi_lut_array := CALO_SIN_PHI_LUT;
constant ETMHF_SIN_PHI_LUT : calo_sin_cos_phi_lut_array := CALO_SIN_PHI_LUT;
constant HTM_SIN_PHI_LUT : calo_sin_cos_phi_lut_array := CALO_SIN_PHI_LUT;

-- HB 2017-03-29: LUTs for cosine(phi) and sine(phi) for twobody-pt calculation of muon objects and converted phi values for correlations with muon.
-- Center of phi bins for calculation of cosine and sine with 4 digits after decimal point
type muon_sin_cos_phi_lut_array is array (0 to 2**MAX_MUON_PHI_BITS-1) of integer range -10000 to 10000;

constant MUON_COS_PHI_LUT : muon_sin_cos_phi_lut_array := (
10000, 9999, 9996, 9993, 9988, 9982, 9975, 9967, 9957, 9946, 9934, 9921, 9907, 9892, 9875, 9857,
9838, 9818, 9797, 9775, 9751, 9726, 9700, 9673, 9645, 9616, 9585, 9553, 9521, 9487, 9452, 9415,
9378, 9340, 9300, 9260, 9218, 9175, 9131, 9086, 9040, 8993, 8944, 8895, 8845, 8793, 8741, 8687,
8633, 8577, 8521, 8463, 8404, 8345, 8284, 8223, 8160, 8097, 8032, 7967, 7900, 7833, 7765, 7695,
7625, 7554, 7482, 7410, 7336, 7261, 7186, 7110, 7032, 6954, 6876, 6796, 6716, 6634, 6552, 6470,
6386, 6302, 6217, 6131, 6044, 5957, 5869, 5780, 5691, 5601, 5510, 5419, 5327, 5234, 5141, 5047,
4953, 4858, 4762, 4666, 4569, 4472, 4374, 4276, 4177, 4077, 3977, 3877, 3776, 3675, 3574, 3471,
3369, 3266, 3163, 3059, 2955, 2851, 2746, 2641, 2535, 2430, 2324, 2218, 2111, 2004, 1897, 1790,
1683, 1575, 1467, 1359, 1251, 1143, 1034, 926, 817, 708, 600, 491, 382, 273, 164, 55,
-55, -164, -273, -382, -491, -600, -708, -817, -926, -1034, -1143, -1251, -1359, -1467, -1575, -1683,
-1790, -1897, -2004, -2111, -2218, -2324, -2430, -2535, -2641, -2746, -2851, -2955, -3059, -3163, -3266, -3369,
-3471, -3573, -3675, -3776, -3877, -3977, -4077, -4177, -4276, -4374, -4472, -4569, -4666, -4762, -4858, -4953,
-5047, -5141, -5234, -5327, -5419, -5510, -5601, -5691, -5780, -5869, -5957, -6044, -6131, -6217, -6302, -6386,
-6470, -6552, -6634, -6716, -6796, -6876, -6954, -7032, -7110, -7186, -7261, -7336, -7409, -7482, -7554, -7625,
-7695, -7765, -7833, -7900, -7967, -8032, -8097, -8160, -8223, -8284, -8345, -8404, -8463, -8521, -8577, -8633,
-8687, -8741, -8793, -8845, -8895, -8944, -8993, -9040, -9086, -9131, -9175, -9218, -9260, -9300, -9340, -9378,
-9415, -9452, -9487, -9521, -9553, -9585, -9616, -9645, -9673, -9700, -9726, -9751, -9775, -9797, -9818, -9838,
-9857, -9875, -9892, -9907, -9921, -9934, -9946, -9957, -9967, -9975, -9982, -9988, -9993, -9996, -9999, -10000,
-10000, -9999, -9996, -9993, -9988, -9982, -9975, -9967, -9957, -9946, -9934, -9921, -9907, -9892, -9875, -9857,
-9838, -9818, -9797, -9775, -9751, -9726, -9700, -9673, -9645, -9616, -9585, -9553, -9521, -9487, -9452, -9415,
-9378, -9340, -9300, -9260, -9218, -9175, -9131, -9086, -9040, -8993, -8944, -8895, -8845, -8793, -8741, -8687,
-8633, -8577, -8521, -8463, -8405, -8345, -8284, -8223, -8160, -8097, -8032, -7967, -7900, -7833, -7765, -7695,
-7625, -7554, -7482, -7410, -7336, -7261, -7186, -7110, -7032, -6954, -6876, -6796, -6716, -6634, -6552, -6470,
-6386, -6302, -6217, -6131, -6044, -5957, -5869, -5780, -5691, -5601, -5510, -5419, -5327, -5234, -5141, -5047,
-4953, -4858, -4762, -4666, -4569, -4472, -4374, -4276, -4177, -4077, -3978, -3877, -3776, -3675, -3574, -3471,
-3369, -3266, -3163, -3059, -2955, -2851, -2746, -2641, -2536, -2430, -2324, -2218, -2111, -2004, -1897, -1790,
-1683, -1575, -1467, -1359, -1251, -1143, -1034, -926, -817, -708, -600, -491, -382, -273, -164, -55,
55, 164, 273, 382, 491, 600, 708, 817, 926, 1034, 1143, 1251, 1359, 1467, 1575, 1683,
1790, 1897, 2004, 2111, 2218, 2324, 2430, 2535, 2641, 2746, 2851, 2955, 3059, 3163, 3266, 3369,
3471, 3573, 3675, 3776, 3877, 3977, 4077, 4177, 4276, 4374, 4472, 4569, 4666, 4762, 4858, 4953,
5047, 5141, 5234, 5327, 5419, 5510, 5601, 5691, 5780, 5869, 5957, 6044, 6131, 6217, 6302, 6386,
6470, 6552, 6634, 6716, 6796, 6876, 6954, 7032, 7109, 7186, 7261, 7336, 7409, 7482, 7554, 7625,
7695, 7765, 7833, 7900, 7967, 8032, 8097, 8160, 8223, 8284, 8345, 8404, 8463, 8521, 8577, 8633,
8687, 8741, 8793, 8845, 8895, 8944, 8993, 9040, 9086, 9131, 9175, 9218, 9260, 9300, 9340, 9378,
9415, 9452, 9487, 9521, 9553, 9585, 9616, 9645, 9673, 9700, 9726, 9751, 9775, 9797, 9818, 9838,
9857, 9875, 9892, 9907, 9921, 9934, 9946, 9957, 9967, 9975, 9982, 9988, 9993, 9996, 9999, 10000,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

constant MUON_SIN_PHI_LUT : muon_sin_cos_phi_lut_array := (
55, 164, 273, 382, 491, 600, 708, 817, 926, 1034, 1143, 1251, 1359, 1467, 1575, 1683,
1790, 1897, 2004, 2111, 2218, 2324, 2430, 2535, 2641, 2746, 2851, 2955, 3059, 3163, 3266, 3369,
3471, 3573, 3675, 3776, 3877, 3977, 4077, 4177, 4276, 4374, 4472, 4569, 4666, 4762, 4858, 4953,
5047, 5141, 5234, 5327, 5419, 5510, 5601, 5691, 5780, 5869, 5957, 6044, 6131, 6217, 6302, 6386,
6470, 6552, 6634, 6716, 6796, 6876, 6954, 7032, 7110, 7186, 7261, 7336, 7410, 7482, 7554, 7625,
7695, 7765, 7833, 7900, 7967, 8032, 8097, 8160, 8223, 8284, 8345, 8404, 8463, 8521, 8577, 8633,
8687, 8741, 8793, 8845, 8895, 8944, 8993, 9040, 9086, 9131, 9175, 9218, 9260, 9300, 9340, 9378,
9415, 9452, 9487, 9521, 9553, 9585, 9616, 9645, 9673, 9700, 9726, 9751, 9775, 9797, 9818, 9838,
9857, 9875, 9892, 9907, 9921, 9934, 9946, 9957, 9967, 9975, 9982, 9988, 9993, 9996, 9999, 10000,
10000, 9999, 9996, 9993, 9988, 9982, 9975, 9967, 9957, 9946, 9934, 9921, 9907, 9892, 9875, 9857,
9838, 9818, 9797, 9775, 9751, 9726, 9700, 9673, 9645, 9616, 9585, 9553, 9521, 9487, 9452, 9415,
9378, 9340, 9300, 9260, 9218, 9175, 9131, 9086, 9040, 8993, 8944, 8895, 8845, 8793, 8741, 8687,
8633, 8577, 8521, 8463, 8404, 8345, 8284, 8223, 8160, 8097, 8032, 7967, 7900, 7833, 7765, 7695,
7625, 7554, 7482, 7410, 7336, 7261, 7186, 7110, 7032, 6954, 6876, 6796, 6716, 6634, 6552, 6470,
6386, 6302, 6217, 6131, 6044, 5957, 5869, 5780, 5691, 5601, 5510, 5419, 5327, 5234, 5141, 5047,
4953, 4858, 4762, 4666, 4569, 4472, 4374, 4276, 4177, 4077, 3978, 3877, 3776, 3675, 3574, 3471,
3369, 3266, 3163, 3059, 2955, 2851, 2746, 2641, 2535, 2430, 2324, 2218, 2111, 2004, 1897, 1790,
1683, 1575, 1467, 1359, 1251, 1143, 1034, 926, 817, 708, 600, 491, 382, 273, 164, 55,
-55, -164, -273, -382, -491, -600, -708, -817, -926, -1034, -1143, -1251, -1359, -1467, -1575, -1683,
-1790, -1897, -2004, -2111, -2218, -2324, -2430, -2535, -2641, -2746, -2851, -2955, -3059, -3163, -3266, -3369,
-3471, -3573, -3675, -3776, -3877, -3977, -4077, -4177, -4276, -4374, -4472, -4569, -4666, -4762, -4858, -4953,
-5047, -5141, -5234, -5327, -5419, -5510, -5601, -5691, -5780, -5869, -5957, -6044, -6131, -6217, -6302, -6386,
-6470, -6552, -6634, -6716, -6796, -6876, -6954, -7032, -7110, -7186, -7261, -7336, -7409, -7482, -7554, -7625,
-7695, -7765, -7833, -7900, -7967, -8032, -8097, -8160, -8223, -8284, -8345, -8404, -8463, -8521, -8577, -8633,
-8687, -8741, -8793, -8845, -8895, -8944, -8993, -9040, -9086, -9131, -9175, -9218, -9260, -9300, -9340, -9378,
-9415, -9452, -9487, -9521, -9553, -9585, -9616, -9645, -9673, -9700, -9726, -9751, -9775, -9797, -9818, -9838,
-9857, -9875, -9892, -9907, -9921, -9934, -9946, -9957, -9967, -9975, -9982, -9988, -9993, -9996, -9999, -10000,
-10000, -9999, -9996, -9993, -9988, -9982, -9975, -9967, -9957, -9946, -9934, -9921, -9907, -9892, -9875, -9857,
-9838, -9818, -9797, -9775, -9751, -9726, -9700, -9673, -9645, -9616, -9585, -9553, -9521, -9487, -9452, -9415,
-9378, -9340, -9300, -9260, -9218, -9175, -9131, -9086, -9040, -8993, -8944, -8895, -8845, -8793, -8741, -8687,
-8633, -8577, -8521, -8463, -8405, -8345, -8284, -8223, -8160, -8097, -8032, -7967, -7900, -7833, -7765, -7695,
-7625, -7554, -7482, -7410, -7336, -7261, -7186, -7110, -7032, -6954, -6876, -6796, -6716, -6634, -6552, -6470,
-6386, -6302, -6217, -6131, -6044, -5957, -5869, -5780, -5691, -5601, -5510, -5419, -5327, -5234, -5141, -5047,
-4953, -4858, -4762, -4666, -4569, -4472, -4374, -4276, -4177, -4077, -3978, -3877, -3776, -3675, -3574, -3471,
-3369, -3266, -3163, -3059, -2955, -2851, -2746, -2641, -2536, -2430, -2324, -2218, -2111, -2004, -1897, -1790,
-1683, -1575, -1467, -1359, -1251, -1143, -1034, -926, -817, -708, -600, -491, -382, -273, -164, -55,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

end package;
