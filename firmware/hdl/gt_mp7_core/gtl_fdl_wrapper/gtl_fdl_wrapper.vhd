-- Description:
-- Wrapper for GTL and FDL

-- Version-history:
-- HB 2018-08-08: changed names for internal signals.
-- HB 2018-08-06: inserted signals for "Asymmetry" and "Centrality" (included in esums data structure).
-- HB 2016-11-17: inserted port "finor_preview_2_mezz_lemo" for "prescaler preview" in monitoring.
-- HB 2016-09-16: removed algo_after_finor_mask_rop, not used anymore in read-out record. Inserted new esums.
-- HB 2016-09-01: added BGo "test-enable" not synchronized (!) occures at bx=~3300 (used to suppress counting algos caused by calibration trigger at bx=3490) for fdl_module.
-- HB 2016-04-06: used algo_mapping_rop with "algo_after_gtLogic" for read-out-record (changed "algo_before_prescaler" to "algo_after_bxomask") according to fdl_module v0.0.24.
-- HB 2016-02-26: inserted finor_w_veto_2_mezz_lemo with 1.5bx delay. Removed unused inputs (ec0, oc0, etc.) and fdl_status output (see fdl_module v0.0.20).
-- HB 2016-02-16: added "l1a" for algo post dead time counter in fdl_module (v0.0.17).
-- HB 2015-09-17: added "ec0", "resync" and "oc0" from "ctrs" for fdl_module (v0.0.14).
-- HB 2015-08-24: added algo_bx_mask_sim input for fdl_module (v0.0.13).
-- HB 2015-06-26: used an additional port "veto_2_mezz_lemo" (in fdl_module), which goes to MP7-mezzanine (with 3 LEMOs) to send finor and veto to FINOR-FMC on AMC502.
-- HB 2015-05-29: renamed port "ser_finor_veto" to "finor_2_mezz_lemo", because of renaming in fdl_module. 
-- HB 2014-12-10: added clk160 for serializer in fdl_module.vhd
-- HB 2014-10-30: updated for local_finor_with_veto_2_spy2 output - fdl v0.0.4.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.ipbus.all;

use work.gtl_pkg.all;

use work.gt_mp7_core_pkg.all;
use work.lhc_data_pkg.all;

entity gtl_fdl_wrapper is
    generic(
        SIM_MODE : boolean := false -- if SIM_MODE = true, "algo_bx_mask" by default = 1.
    );
    port
    (
        ipb_clk             : in std_logic;
        ipb_rst             : in std_logic;
        ipb_in              : in ipb_wbus;
        ipb_out             : out ipb_rbus;
-- ==========================================================================
        lhc_clk             : in std_logic;
        lhc_rst             : in std_logic;
        lhc_data            : in lhc_data_t;
        bcres               : in std_logic;
        test_en             : in std_logic;
        l1a                 : in std_logic;
        begin_lumi_section  : in std_logic;
        prescale_factor_set_index_rop : out std_logic_vector(7 downto 0);
        algo_after_gtLogic_rop        : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_bxomask_rop        : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_prescaler_rop      : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        local_finor_rop     : out std_logic;
        local_veto_rop      : out std_logic;
        finor_2_mezz_lemo      : out std_logic;
        finor_preview_2_mezz_lemo      : out std_logic;
        veto_2_mezz_lemo      : out std_logic;
        finor_w_veto_2_mezz_lemo      : out std_logic;
        local_finor_with_veto_o      : out std_logic
    );
end gtl_fdl_wrapper;

architecture rtl of gtl_fdl_wrapper is

    signal algo : std_logic_vector(nr_algos-1 downto 0);

    signal data : gtl_data_record;

begin

    eg_data_l: for i in 0 to EG_ARRAY_LENGTH-1 generate
       data.eg_data(i).pt <= lhc_data.eg(i)(EG_PT_HIGH downto EG_PT_LOW);
       data.eg_data(i).eta <= lhc_data.eg(i)(EG_ETA_HIGH downto EG_ETA_LOW);
       data.eg_data(i).phi <= lhc_data.eg(i)(EG_PHI_HIGH downto EG_PHI_LOW);
       data.eg_data(i).iso <= lhc_data.eg(i)(EG_ISO_HIGH downto EG_ISO_LOW);
    end generate eg_data_l;

    jet_data_l: for i in 0 to JET_ARRAY_LENGTH-1 generate
       data.jet_data(i).pt <= lhc_data.jet(i)(JET_PT_HIGH downto JET_PT_LOW);
       data.jet_data(i).eta <= lhc_data.jet(i)(JET_ETA_HIGH downto JET_ETA_LOW);
       data.jet_data(i).phi <= lhc_data.jet(i)(JET_PHI_HIGH downto JET_PHI_LOW);
    end generate jet_data_l;

    tau_data_l: for i in 0 to TAU_ARRAY_LENGTH-1 generate
       data.tau_data(i).pt <= lhc_data.tau(i)(TAU_PT_HIGH downto TAU_PT_LOW);
       data.tau_data(i).eta <= lhc_data.tau(i)(TAU_ETA_HIGH downto TAU_ETA_LOW);
       data.tau_data(i).phi <= lhc_data.tau(i)(TAU_PHI_HIGH downto TAU_PHI_LOW);
       data.tau_data(i).iso <= lhc_data.tau(i)(TAU_ISO_HIGH downto TAU_ISO_LOW);
    end generate tau_data_l;

    muon_data_l: for i in 0 to MUON_ARRAY_LENGTH-1 generate
       data.muon_data(i).pt <= lhc_data.muon(i)(MUON_PT_HIGH downto MUON_PT_LOW);
       data.muon_data(i).eta <= lhc_data.muon(i)(MUON_ETA_HIGH downto MUON_ETA_LOW);
       data.muon_data(i).phi <= lhc_data.muon(i)(MUON_PHI_HIGH downto MUON_PHI_LOW);
       data.muon_data(i).iso <= lhc_data.muon(i)(MUON_ISO_HIGH downto MUON_ISO_LOW);
       data.muon_data(i).qual <= lhc_data.muon(i)(MUON_QUAL_HIGH downto MUON_QUAL_LOW);
       data.muon_data(i).charge <= lhc_data.muon(i)(MUON_CHARGE_HIGH downto MUON_CHARGE_LOW);
    end generate muon_data_l;

-- ****************************************************************************************
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

    data.ett_data.pt <= lhc_data.ett(ETT_PT_HIGH downto ETT_PT_LOW);
    data.htt_data.pt <= lhc_data.ht(HTT_PT_HIGH downto HTT_PT_LOW);
    data.etm_data.pt <= lhc_data.etm(ETM_PT_HIGH downto ETM_PT_LOW);
    data.etm_data.phi <= lhc_data.etm(ETM_PHI_HIGH downto ETM_PHI_LOW);
    data.htm_data.pt <= lhc_data.htm(HTM_PT_HIGH downto HTM_PT_LOW);
    data.htm_data.phi <= lhc_data.htm(HTM_PHI_HIGH downto HTM_PHI_LOW);
    data.ettem_data.pt <= lhc_data.ett(ETTEM_IN_ETT_HIGH downto ETTEM_IN_ETT_LOW);
    data.etmhf_data.pt <= lhc_data.etmhf(ETMHF_PT_HIGH downto ETMHF_PT_LOW);
    data.etmhf_data.phi <= lhc_data.etmhf(ETMHF_PHI_HIGH downto ETMHF_PHI_LOW);
    data.htmhf_data.pt <= lhc_data.htmhf(HTMHF_PT_HIGH downto HTMHF_PT_LOW);
    data.htmhf_data.phi <= lhc_data.htmhf(HTMHF_PHI_HIGH downto HTMHF_PHI_LOW);

    data.towercount_data.count <= lhc_data.ht(TOWERCOUNT_IN_HTT_HIGH downto TOWERCOUNT_IN_HTT_LOW);

    data.mbt0hfp_data.count <= lhc_data.ett(MBT0HFP_IN_ETT_HIGH downto MBT0HFP_IN_ETT_LOW);
    data.mbt0hfm_data.count <= lhc_data.ht(MBT0HFM_IN_HTT_HIGH downto MBT0HFM_IN_HTT_LOW);
    data.mbt1hfp_data.count <= lhc_data.etm(MBT1HFP_IN_ETM_HIGH downto MBT1HFP_IN_ETM_LOW);
    data.mbt1hfm_data.count <= lhc_data.htm(MBT1HFM_IN_HTM_HIGH downto MBT1HFM_IN_HTM_LOW);

-- HB 2018-08-06: inserted signals for "Asymmetry" and "Centrality" (included in esums data structure).
-- see: https://indico.cern.ch/event/746381/contributions/3085360/subcontributions/260912/attachments/1693846/2725976/DemuxOutput.pdf

-- Frame 2, ETM: bits 27..20 => ASYMET
-- Frame 3, HTM: bits 27..20 => ASYMHT
-- Frame 4, ETMHF: bits 27..20 => ASYMETHF
-- Frame 5, HTMHF: bits 27..20 => ASYMHTHF

-- Frame 4, ETMHF: bits 31..28 => CENT3..CENT0
-- Frame 5, HTMHF: bits 31..28 => CENT7..CENT4

    data.asymet_data.count <= lhc_data.etm(ASYMET_IN_ETM_HIGH downto ASYMET_IN_ETM_LOW);
    data.asymht_data.count <= lhc_data.htm(ASYMHT_IN_HTM_HIGH downto ASYMHT_IN_HTM_LOW);
    data.asymethf_data.count <= lhc_data.etmhf(ASYMETHF_IN_ETMHF_HIGH downto ASYMETHF_IN_ETMHF_LOW);
    data.asymhthf_data.count <= lhc_data.htmhf(ASYMHTHF_IN_HTMHF_HIGH downto ASYMHTHF_IN_HTMHF_LOW);
    
    data.centrality_data(CENT_LBITS_HIGH downto CENT_LBITS_LOW) <= lhc_data.etmhf(CENT_IN_ETMHF_HIGH downto CENT_IN_ETMHF_LOW);
    data.centrality_data(CENT_UBITS_HIGH downto CENT_UBITS_LOW) <= lhc_data.htmhf(CENT_IN_HTMHF_HIGH downto CENT_IN_HTMHF_LOW);
    
-- ****************************************************************************************
    
    data.external_conditions <= lhc_data.external_conditions(EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto 0);

gtl_module_i: entity work.gtl_module
    port map( 
        lhc_clk => lhc_clk,
        data => data,
        algo_o          => algo
    );

fdl_module_i: entity work.fdl_module
    generic map(
        SIM_MODE => SIM_MODE,
        PRESCALE_FACTOR_INIT => PRESCALE_FACTOR_INIT,
        MASKS_INIT => MASKS_INIT
    )
    port map( 
        ipb_clk         => ipb_clk,
        ipb_rst         => ipb_rst,
        ipb_in          => ipb_in,
        ipb_out         => ipb_out,
-- ========================================================
        lhc_clk         => lhc_clk,
        lhc_rst         => lhc_rst,
        bcres           => bcres,
        test_en         => test_en,
        l1a             => l1a,
        begin_lumi_section => begin_lumi_section,
        algo_i          => algo,
        prescale_factor_set_index_rop => prescale_factor_set_index_rop,
        algo_after_gtLogic_rop => algo_after_gtLogic_rop,
        algo_after_bxomask_rop => algo_after_bxomask_rop,
        algo_after_prescaler_rop  => algo_after_prescaler_rop,
        local_finor_rop => local_finor_rop,
        local_veto_rop  => local_veto_rop,
        finor_2_mezz_lemo  => finor_2_mezz_lemo,
        finor_preview_2_mezz_lemo  => finor_preview_2_mezz_lemo,
        veto_2_mezz_lemo  => veto_2_mezz_lemo,
        finor_w_veto_2_mezz_lemo  => finor_w_veto_2_mezz_lemo,
        local_finor_with_veto_o  => local_finor_with_veto_o,
        algo_bx_mask_sim => (others => '1')  
    );

end architecture rtl;
