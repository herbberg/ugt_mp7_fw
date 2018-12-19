-- Description:
-- Package for constant and type definitions of GTL firmware in Global Trigger Upgrade system.

-- HB 2018-12-06: changed structure for GTL_v2.x.y.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.lhc_data_pkg.all;
use work.math_pkg.all;
use work.gt_mp7_core_pkg.all;

package gtl_pkg is

{{ugt_constants}}

-- HB 2014-09-09: GTL and FDL firmware major, minor and revision versions moved to gt_mp7_core_pkg.vhd (GTL_FW_MAJOR_VERSION, etc.)
--                for creating a tag name by a script independent from L1Menu.
-- GTL firmware (fix part) version
constant GTL_FW_VERSION : std_logic_vector(31 downto 0) := X"00" &
           std_logic_vector(to_unsigned(GTL_FW_MAJOR_VERSION, 8)) &
           std_logic_vector(to_unsigned(GTL_FW_MINOR_VERSION, 8)) &
           std_logic_vector(to_unsigned(GTL_FW_REV_VERSION, 8));

-- FDL firmware version
constant FDL_FW_VERSION : std_logic_vector(31 downto 0) := X"00" &
           std_logic_vector(to_unsigned(FDL_FW_MAJOR_VERSION, 8)) &
           std_logic_vector(to_unsigned(FDL_FW_MINOR_VERSION, 8)) &
           std_logic_vector(to_unsigned(FDL_FW_REV_VERSION, 8));

-- ==== FDL definitions - begin ============================================================
-- Definitions for prescalers (for FDL !)
constant PRESCALER_COUNTER_WIDTH : integer := 24;

-- HB HB 2016-03-02: type definition for "global" index use.
type prescale_factor_global_array is array (MAX_NR_ALGOS-1 downto 0) of std_logic_vector(31 downto 0);

type prescale_factor_array is array (NR_ALGOS-1 downto 0) of std_logic_vector(31 downto 0); -- same width as PCIe data
-- constant PRESCALE_FACTOR_INIT : ipb_regs_array(0 to MAX_NR_ALGOS-1) := ({AssignmentPrescaleFactors} others => X"00000001"); -- written by TME
constant PRESCALE_FACTOR_INIT : ipb_regs_array(0 to MAX_NR_ALGOS-1) := (others => X"00000001"); -- written by TME

-- Definitions for rate counters
constant RATE_COUNTER_WIDTH : integer := 32;

-- HB HB 2016-03-02: type definition for "global" index use.
type rate_counter_global_array is array (MAX_NR_ALGOS-1 downto 0) of std_logic_vector(RATE_COUNTER_WIDTH-1 downto 0);

type rate_counter_array is array (NR_ALGOS-1 downto 0) of std_logic_vector(RATE_COUNTER_WIDTH-1 downto 0);

-- HB 2014-02-28: changed vector length of init values for finor- and veto-maks, because of min. 32 bits for register
-- constant MASKS_INIT : ipb_regs_array(0 to MAX_NR_ALGOS-1) := ({AssignmentFinorVetoMasks} others => X"00000001"); --Finor and veto masks registers (bit 0 = finor, bit 1 = veto)
constant MASKS_INIT : ipb_regs_array(0 to MAX_NR_ALGOS-1) := (others => X"00000001"); --Finor and veto masks registers (bit 0 = finor, bit 1 = veto)
-- ==== FDL definitions - end ============================================================

-- *******************************************************************************
-- Definitions for GTL v2.x.y

    constant MAX_N_REQ : positive := 4; -- max. number of requirements for combinatorial conditions
    constant MAX_N_OBJ : positive := 12; -- max. number of objects
    constant MAX_LUT_WIDTH : positive := 16; -- muon qual lut
    constant MAX_OBJ_BITS : positive := 64; -- muon

    constant MAX_COMP_DATA_WIDTH : positive := 12; -- max. input data width of comparators (esums pt = 12)
    constant MAX_COMP_CORR_CUTS_DATA_WIDTH : positive := 52; -- max inv mass width (2*MAX_PT_WIDTH+MAX_COSH_COS_WIDTH = 51) - used 52 for hex notation !
    constant MAX_COSH_COS_WIDTH : positive := 27; -- CALO_MUON_COSH_COS_VECTOR_WIDTH 
    constant MAX_PT_WIDTH : positive := 12; -- max. pt width of comparators (esums pt = 12)
    constant MAX_PT_VECTOR_WIDTH : positive := 15; -- esums - max. value 2047.5 GeV => 20475 (2047.5 * 10) => 0x4FFB

    constant OUT_REG_CONV_CALC: boolean := false;
    constant IN_REG_COMP: boolean := true;
    constant OUT_REG_COMP: boolean := true;
    constant OUT_REG_COND: boolean := false;
    
-- *******************************************************************************************************
-- MUON objects bits
--     constant NR_MUON_OBJECTS : positive := MUON_ARRAY_LENGTH; -- from lhc_data_pkg.vhd
    constant MAX_MUON_BITS : positive := MUON_DATA_WIDTH; -- from lhc_data_pkg.vhd

    constant MUON_PHI_LOW : natural := 0;
    constant MUON_PHI_HIGH : natural := 9;
    constant MUON_PT_LOW : natural := 10;
    constant MUON_PT_HIGH : natural := 18;
    constant MUON_QUAL_LOW : natural := 19;
    constant MUON_QUAL_HIGH : natural := 22;
    constant MUON_ETA_LOW : natural := 23;
    constant MUON_ETA_HIGH : natural := 31;
    constant MUON_ISO_LOW : natural := 32;
    constant MUON_ISO_HIGH : natural := 33;
    constant MUON_CHARGE_LOW : natural := 34;
    constant MUON_CHARGE_HIGH : natural := 35;
-- HB 2017-04-11: updated muon structure for "raw" ann "extrapolated" phi and eta bits (phi_high, phi_low, eta_high and eta_low => for "extrapolated").
    constant MUON_IDX_BITS_LOW : natural := 36;
    constant MUON_IDX_BITS_HIGH : natural := 42;
    constant MUON_PHI_RAW_LOW : natural := 43;
    constant MUON_PHI_RAW_HIGH : natural := 52;
    constant MUON_ETA_RAW_LOW : natural := 53;
    constant MUON_ETA_RAW_HIGH : natural := 61;

    constant MUON_PT_VECTOR_WIDTH: positive := 12; -- max. value 255.5 GeV => 2555 (255.5 * 10**MUON_INV_MASS_PT_PRECISION) => 0x9FB

-- *******************************************************************************************************
-- CALO objects bits
--     constant NR_EG_OBJECTS : positive := EG_ARRAY_LENGTH; -- number eg objects, from lhc_data_pkg.vhd
--     constant NR_JET_OBJECTS : positive := JET_ARRAY_LENGTH; -- number jet objects, from lhc_data_pkg.vhd
--     constant NR_TAU_OBJECTS : positive := TAU_ARRAY_LENGTH; -- number tau objects, from lhc_data_pkg.vhd
    constant MAX_CALO_OBJECTS : positive := max(EG_ARRAY_LENGTH, JET_ARRAY_LENGTH, TAU_ARRAY_LENGTH);
    constant MAX_CALO_BITS : positive := max(EG_DATA_WIDTH, JET_DATA_WIDTH, TAU_DATA_WIDTH);

    constant EG_PT_LOW : natural := 0;
    constant EG_PT_HIGH : natural := 8;
    constant EG_ETA_LOW : natural := 9;
    constant EG_ETA_HIGH : natural := 16;
    constant EG_PHI_LOW : natural := 17;
    constant EG_PHI_HIGH : natural := 24;
    constant EG_ISO_LOW : natural := 25;
    constant EG_ISO_HIGH : natural := 26;

    constant JET_PT_LOW : natural := 0;
    constant JET_PT_HIGH : natural := 10;
    constant JET_ETA_LOW : natural := 11;
    constant JET_ETA_HIGH : natural := 18;
    constant JET_PHI_LOW : natural := 19;
    constant JET_PHI_HIGH : natural := 26;

    constant TAU_PT_LOW : natural := 0;
    constant TAU_PT_HIGH : natural := 8;
    constant TAU_ETA_LOW : natural := 9;
    constant TAU_ETA_HIGH : natural := 16;
    constant TAU_PHI_LOW : natural := 17;
    constant TAU_PHI_HIGH : natural := 24;
    constant TAU_ISO_LOW : natural := 25;
    constant TAU_ISO_HIGH : natural := 26;

    constant EG_PT_VECTOR_WIDTH: positive := 12; -- max. value 255.5 GeV => 2555 (255.5 * 10**CALO_INV_MASS_PT_PRECISION) => 0x9FB
    constant JET_PT_VECTOR_WIDTH: positive := 14; -- max. value 1023.5 GeV => 10235 (1023.5 * 10**CALO_INV_MASS_PT_PRECISION) => 0x27FB
    constant TAU_PT_VECTOR_WIDTH: positive := 12; -- max. value 255.5 GeV => 2555 (255.5 * 10**CALO_INV_MASS_PT_PRECISION) => 0x9FB

-- *******************************************************************************************************
-- Esums objects bits
    constant MAX_ESUMS_BITS : positive := 20; -- see ETM, HTM, etc.

    constant ETT_PT_LOW : natural := 0;
    constant ETT_PT_HIGH : natural := 11;

    constant HTT_PT_LOW : natural := 0;
    constant HTT_PT_HIGH : natural := 11;

    constant ETM_PT_LOW : natural := 0;
    constant ETM_PT_HIGH : natural := 11;
    constant ETM_PHI_LOW : natural := 12;
    constant ETM_PHI_HIGH : natural := 19;

    constant HTM_PT_LOW : natural := 0;
    constant HTM_PT_HIGH : natural := 11;
    constant HTM_PHI_LOW : natural := 12;
    constant HTM_PHI_HIGH : natural := 19;

    constant ETTEM_IN_ETT_LOW : natural := 12;
    constant ETTEM_IN_ETT_HIGH : natural := 23;
    constant ETTEM_PT_LOW : natural := 0;
    constant ETTEM_PT_HIGH : natural := 11;

    constant ETMHF_PT_LOW : natural := 0;
    constant ETMHF_PT_HIGH : natural := 11;
    constant ETMHF_PHI_LOW : natural := 12;
    constant ETMHF_PHI_HIGH : natural := 19;

    constant HTMHF_PT_LOW : natural := 0;
    constant HTMHF_PT_HIGH : natural := 11;
    constant HTMHF_PHI_LOW : natural := 12;
    constant HTMHF_PHI_HIGH : natural := 19;

-- *******************************************************************************************************
-- Asymmetry bits
-- HB 2018-08-06: inserted constants and types for "Asymmetry" and "Centrality" (included in esums data structure).
-- see: https://indico.cern.ch/event/746381/contributions/3085360/subcontributions/260912/attachments/1693846/2725976/DemuxOutput.pdf

-- Frame 2, ETM: bits 27..20 => ASYMET
-- Frame 3, HTM: bits 27..20 => ASYMHT
-- Frame 4, ETMHF: bits 27..20 => ASYMETHF
-- Frame 5, HTMHF: bits 27..20 => ASYMHTHF

-- Frame 4, ETMHF: bits 31..28 => CENT3..CENT0
-- Frame 5, HTMHF: bits 31..28 => CENT7..CENT4

    constant ASYMET_IN_ETM_HIGH : natural := 27;
    constant ASYMET_IN_ETM_LOW : natural := 20;
    constant ASYMHT_IN_HTM_HIGH : natural := 27;
    constant ASYMHT_IN_HTM_LOW : natural := 20;
    constant ASYMETHF_IN_ETMHF_HIGH : natural := 27;
    constant ASYMETHF_IN_ETMHF_LOW : natural := 20;
    constant ASYMHTHF_IN_HTMHF_HIGH : natural := 27;
    constant ASYMHTHF_IN_HTMHF_LOW : natural := 20;

    constant ASYM_LOW : natural := 0;
    constant ASYM_HIGH : natural := 7;

-- *******************************************************************************************************
-- Centrality bits
    constant CENT_IN_ETMHF_HIGH : natural := 31;
    constant CENT_IN_ETMHF_LOW : natural := 28;
    constant CENT_IN_HTMHF_HIGH : natural := 31;
    constant CENT_IN_HTMHF_LOW : natural := 28;

    constant CENT_LBITS_LOW : natural := 0;
    constant CENT_LBITS_HIGH: natural := 3;
    constant CENT_UBITS_LOW : natural := 4;
    constant CENT_UBITS_HIGH: natural := 7;

-- *******************************************************************************************************
-- Towercount bits
-- HB 2016-09-16: inserted TOWERCOUNT
    constant TOWERCOUNT_IN_HTT_LOW : natural := 12;
    constant TOWERCOUNT_IN_HTT_HIGH : natural := 24;
    constant TOWERCOUNT_COUNT_LOW : natural := 0;
    constant TOWERCOUNT_COUNT_HIGH : natural := 12;
    constant MAX_TOWERCOUNT_BITS : natural := 16; -- 4 hex digits !

-- *******************************************************************************************************
-- Minimum Bias bits
-- HB 2016-04-18: updates for "min bias trigger" objects (quantities) for Low-pileup-run May 2016
-- HB 2016-04-21: see email from Johannes (Andrew Rose), 2016-04-20 15:34
-- Frame 0: (HF+ thresh 0) ... ... (Scalar ET) - 4 MSBs
-- Frame 1: (HF- thresh 0) ... ... (Scalar HT) - 4 MSBs
-- Frame 2: (HF+ thresh 1) ... ... (Vector ET) - 4 MSBs
-- Frame 3: (HF- thresh 1) ... ... (Vector HT) - 4 MSBs
-- HB 2016-04-26: grammar notation
-- HF+ thresh 0 => MBT0HFP
-- HF- thresh 0 => MBT0HFM
-- HF+ thresh 1 => MBT1HFP
-- HF- thresh 1 => MBT1HFM

    constant MBT0HFP_IN_ETT_HIGH : natural := 31;
    constant MBT0HFP_IN_ETT_LOW : natural := 28;
    constant MBT0HFM_IN_HTT_HIGH : natural := 31;
    constant MBT0HFM_IN_HTT_LOW : natural := 28;
    constant MBT1HFP_IN_ETM_HIGH : natural := 31;
    constant MBT1HFP_IN_ETM_LOW : natural := 28;
    constant MBT1HFM_IN_HTM_HIGH : natural := 31;
    constant MBT1HFM_IN_HTM_LOW : natural := 28;

    constant MB_COUNT_LOW : natural := 0;
    constant MB_COUNT_HIGH : natural := 3;

-- *******************************************************************************
-- Type declarations
    type comp_in_data_array is array (natural range <>) of std_logic_vector(MAX_COMP_DATA_WIDTH-1 downto 0);    
    type cosh_cos_vector_array is array (natural range <>, natural range <>) of std_logic_vector(MAX_COSH_COS_WIDTH-1 downto 0);    
    type pt_array is array (natural range <>) of std_logic_vector((MAX_PT_WIDTH)-1 downto 0);
    type mass_vector_array is array (natural range <>, natural range <>) of std_logic_vector((2*MAX_PT_WIDTH+MAX_COSH_COS_WIDTH)-1 downto 0);
    
    type std_logic_1dim_array is array (natural range <>) of std_logic;
    type std_logic_2dim_array is array (natural range <>, natural range <>) of std_logic;
    type std_logic_3dim_array is array (natural range <>, natural range <>, natural range <>) of std_logic;
    type std_logic_4dim_array is array (natural range <>, natural range <>, natural range <>, natural range <>) of std_logic;
    type integer_array is array (natural range <>) of integer;
    type integer_2dim_array is array (natural range <>, natural range <>) of integer;
    
    type obj_type is (eg, jet, tau, muon, ett, etm, htt, htm, ettem, etmhf);
    type obj_corr_type is (calo_calo, calo_esums, calo_muon, muon_muon, muon_esums);

    type objects_array is array (natural range <>) of std_logic_vector(MAX_OBJ_BITS-1 downto 0);

    type pt_vector_array is array (natural range <>) of std_logic_vector(MAX_PT_VECTOR_WIDTH-1 downto 0);

    type comp_mode is (greater_equal,win_sign,win_unsign,equal,lut);

    type obj_struct is record
        pt_l,pt_h,eta_l,eta_h,phi_l,phi_h,iso_l,
        iso_h,qual_l,qual_h,charge_l,charge_h,
        idx_bits_l, idx_bits_h, phi_raw_l, phi_raw_h, eta_raw_l, eta_raw_h : natural;
    end record obj_struct;
    
    type esums_struct is record
        pt_l,pt_h,phi_l,phi_h : natural;
    end record esums_struct;
    
    type vec_struct is record
        high, low : natural;
    end record vec_struct;

    type conversions_conf is record
        N_OBJ : natural;
        OBJ_T : obj_type;
        OBJ_S : obj_struct;
        PT_VECTOR_WIDTH : positive;
        OUT_REG : boolean;
    end record conversions_conf;

    type differences_conf is record
        N_OBJ_1, N_OBJ_2, PHI_HALF_RANGE, DIFF_WIDTH, COSH_COS_WIDTH : positive;
        OUT_REG : boolean;
        OBJ_CORR : obj_corr_type;
    end record differences_conf;

    type dr_conf is record
        N_OBJ_1, N_OBJ_2, DIFF_WIDTH : positive;
        OUT_REG : boolean;
    end record dr_conf;

    type mass_conf is record
        N_OBJ_1, N_OBJ_2, PT1_WIDTH, PT2_WIDTH, COSH_COS_WIDTH, COSH_COS_PREC : positive;
        OUT_REG : boolean;
    end record mass_conf;

    type comparators_conf is record
        N_OBJ_1_H, N_OBJ_2_H, DATA_WIDTH, LUT_HIGH_BIT : natural;
        MODE : comp_mode;
        IN_REG, OUT_REG : boolean;
    end record comparators_conf;
    
--     type comparator_muon_charge_corr_conf is record
--         OUT_REG : boolean;
--     end record comparator_muon_charge_corr_conf;

    type combinatorial_conditions_conf is record
        OUT_REG, TBPT_SEL, CHARGE_CORR_SEL, CHARGE_SEL, QUAL_SEL, ISO_SEL, PHI_SEL, ETA_SEL : boolean;
        SLICE_4_L, SLICE_4_H, SLICE_3_L, SLICE_3_H, SLICE_2_L, SLICE_2_H, SLICE_1_L, SLICE_1_H, N_OBJ, N_REQ : natural;
    end record combinatorial_conditions_conf;

    type correlation_conditions_conf is record
        OUT_REG, DETA_SEL, DPHI_SEL, DR_SEL, INV_MASS_SEL, TRANS_MASS_SEL, TBPT_SEL, CHARGE_CORR_SEL, 
        CHARGE_1_SEL, QUAL_1_SEL, ISO_1_SEL, PHI_1_SEL, ETA_1_SEL,
        CHARGE_2_SEL, QUAL_2_SEL, ISO_2_SEL, PHI_2_SEL, ETA_2_SEL : boolean;
        SLICE_1_L, SLICE_1_H, SLICE_2_L, SLICE_2_H, N_OBJ_1, N_OBJ_2 : natural;
    end record correlation_conditions_conf;

    type eg_record is record
        pt : std_logic_vector(EG_PT_HIGH downto EG_PT_LOW);
        eta : std_logic_vector(EG_ETA_HIGH downto EG_ETA_LOW);
        phi : std_logic_vector(EG_PHI_HIGH downto EG_PHI_LOW);
        iso : std_logic_vector(EG_ISO_HIGH downto EG_ISO_LOW);
    end record eg_record;
    
    type eg_record_array is array (natural range <>) of eg_record;

    type jet_record is record
        pt : std_logic_vector(JET_PT_HIGH downto JET_PT_LOW);
        eta : std_logic_vector(JET_ETA_HIGH downto JET_ETA_LOW);
        phi : std_logic_vector(JET_PHI_HIGH downto JET_PHI_LOW);
    end record jet_record;
    
    type jet_record_array is array (natural range <>) of jet_record;

    type muon_record is record
        pt : std_logic_vector(MUON_PT_HIGH downto MUON_PT_LOW);
        eta : std_logic_vector(MUON_ETA_HIGH downto MUON_ETA_LOW);
        phi : std_logic_vector(MUON_PHI_HIGH downto MUON_PHI_LOW);
        iso : std_logic_vector(MUON_ISO_HIGH downto MUON_ISO_LOW);
        qual : std_logic_vector(MUON_QUAL_HIGH downto MUON_QUAL_LOW);
        charge : std_logic_vector(MUON_CHARGE_HIGH downto MUON_CHARGE_LOW);
    end record muon_record;
    
    type muon_record_array is array (natural range <>) of muon_record;

-- ==== MUONs - begin ============================================================
    type muon_objects_array is array (natural range <>) of std_logic_vector(MAX_MUON_BITS-1 downto 0);

    constant MUON_STRUCT : obj_struct := (MUON_PT_LOW,MUON_PT_HIGH,MUON_ETA_LOW,MUON_ETA_HIGH,MUON_PHI_LOW,MUON_PHI_HIGH,MUON_ISO_LOW,MUON_ISO_HIGH,
        MUON_QUAL_LOW,MUON_QUAL_HIGH,MUON_CHARGE_LOW,MUON_CHARGE_HIGH,0,0,0,0,0,0);

    constant NR_MUON_CHARGE_BITS : positive := muon_record.charge'length;
    type muon_charge_bits_array is array (0 to MUON_ARRAY_LENGTH-1) of std_logic_vector(NR_MUON_CHARGE_BITS-1 downto 0);
    type muon_cc_double_array is array (0 to MUON_ARRAY_LENGTH-1, 0 to MUON_ARRAY_LENGTH-1) of std_logic_vector(NR_MUON_CHARGE_BITS-1 downto 0);
    type muon_cc_triple_array is array (0 to MUON_ARRAY_LENGTH-1, 0 to MUON_ARRAY_LENGTH-1, 0 to MUON_ARRAY_LENGTH-1) of std_logic_vector(NR_MUON_CHARGE_BITS-1 downto 0);
    type muon_cc_quad_array is array (0 to MUON_ARRAY_LENGTH-1, 0 to MUON_ARRAY_LENGTH-1, 0 to MUON_ARRAY_LENGTH-1, 0 to MUON_ARRAY_LENGTH-1) of std_logic_vector(NR_MUON_CHARGE_BITS-1 downto 0);
    constant CC_NOT_VALID : std_logic_vector(NR_MUON_CHARGE_BITS-1 downto 0) := "00"; 
    constant CC_LS : std_logic_vector(NR_MUON_CHARGE_BITS-1 downto 0) := "01"; 
    constant CC_OS : std_logic_vector(NR_MUON_CHARGE_BITS-1 downto 0) := "10"; 

    constant MUON_PT_WIDTH : natural := MUON_PT_HIGH - MUON_PT_LOW + 1;
    constant MUON_QUAL_WIDTH : natural := MUON_QUAL_HIGH - MUON_QUAL_LOW + 1;

-- ==== CALOs - begin ============================================================
    type calo_objects_array is array (natural range <>) of std_logic_vector(MAX_CALO_BITS-1 downto 0);
    
    constant EG_STRUCT : obj_struct := (EG_PT_LOW,EG_PT_HIGH,EG_ETA_LOW,EG_ETA_HIGH,EG_PHI_LOW,EG_PHI_HIGH,EG_ISO_LOW,EG_ISO_HIGH,0,0,0,0,0,0,0,0,0,0);
    constant JET_STRUCT : obj_struct := (JET_PT_LOW,JET_PT_HIGH,JET_ETA_LOW,JET_ETA_HIGH,JET_PHI_LOW,JET_PHI_HIGH,0,0,0,0,0,0,0,0,0,0,0,0);
    constant TAU_STRUCT : obj_struct := (TAU_PT_LOW,TAU_PT_HIGH,TAU_ETA_LOW,TAU_ETA_HIGH,TAU_PHI_LOW,TAU_PHI_HIGH,TAU_ISO_LOW,TAU_ISO_HIGH,0,0,0,0,0,0,0,0,0,0);

    constant EG_PT_WIDTH : natural := EG_PT_HIGH - EG_PT_LOW + 1;
    constant JET_PT_WIDTH : natural := JET_PT_HIGH - JET_PT_LOW + 1;
    constant JET_ETA_WIDTH : natural := JET_ETA_HIGH - JET_ETA_LOW + 1;
    constant TAU_PT_WIDTH : natural := TAU_PT_HIGH - TAU_PT_LOW + 1;

-- ==== ESUMs - begin ============================================================
    constant ETT_STRUCT : esums_struct := (ETT_PT_LOW,ETT_PT_HIGH,0,0);
    constant HTT_STRUCT : esums_struct := (HTT_PT_LOW,HTT_PT_HIGH,0,0);
    constant ETM_STRUCT : esums_struct := (ETM_PT_LOW,ETM_PT_HIGH,ETM_PHI_LOW,ETM_PHI_HIGH);
    constant HTM_STRUCT : esums_struct := (HTM_PT_LOW,HTM_PT_HIGH,HTM_PHI_LOW,HTM_PHI_HIGH);
    constant ETTEM_STRUCT : esums_struct := (ETTEM_PT_LOW,ETTEM_PT_HIGH,0,0);
    constant ETMHF_STRUCT : esums_struct := (ETMHF_PT_LOW,ETMHF_PT_HIGH,ETMHF_PHI_LOW,ETMHF_PHI_HIGH);
    constant HTMHF_STRUCT : esums_struct := (HTMHF_PT_LOW,HTMHF_PT_HIGH,HTMHF_PHI_LOW,HTMHF_PHI_HIGH);

-- ==== ASYMs - begin ============================================================
    constant ASYMET_STRUCT : vec_struct := (ASYM_HIGH,ASYM_LOW);
    constant ASYMHT_STRUCT : vec_struct := (ASYM_HIGH,ASYM_LOW);
    constant ASYMETHF_STRUCT : vec_struct := (ASYM_HIGH,ASYM_LOW);
    constant ASYMHTHF_STRUCT : vec_struct := (ASYM_HIGH,ASYM_LOW);

-- ==== CENTs - begin ============================================================
    constant NR_CENTRALITY_BITS : positive := CENT_UBITS_HIGH-CENT_LBITS_LOW+1;

-- ==== TOWERCOUNT - begin ============================================================
    constant TOWERCOUNT_STRUCT : vec_struct := (TOWERCOUNT_COUNT_HIGH,TOWERCOUNT_COUNT_LOW);

-- ==== MINBIAS - begin ============================================================
    constant MBT0HFP_STRUCT : vec_struct := (MB_COUNT_HIGH,MB_COUNT_LOW);
    constant MBT0HFM_STRUCT : vec_struct := (MB_COUNT_HIGH,MB_COUNT_LOW);
    constant MBT1HFP_STRUCT : vec_struct := (MB_COUNT_HIGH,MB_COUNT_LOW);
    constant MBT1HFM_STRUCT : vec_struct := (MB_COUNT_HIGH,MB_COUNT_LOW);

-- *******************************************************************************************************
-- "External conditions" (former "Technical Triggers" and "External Algorithms") definitions
--     constant NR_EXTERNAL_CONDITIONS : positive := EXTERNAL_CONDITIONS_DATA_WIDTH; -- number of "External conditions" inputs (proposed max. NR_EXTERNAL_CONDITIONS = 256), from lhc_data_pkg.vhd

end package;
