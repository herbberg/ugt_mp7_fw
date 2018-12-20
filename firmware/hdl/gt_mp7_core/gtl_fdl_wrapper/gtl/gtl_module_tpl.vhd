-- Description:
-- Global Trigger Logic module.

-- Version-history:
-- HB 2018-11-29: v2.0.0: Version for GTL_v2.x.y.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;
use work.lut_pkg.all;

entity gtl_module is
    port(
        lhc_clk : in std_logic;
        data : in gtl_data_record;
--         eg_data : in calo_objects_array(0 to EG_ARRAY_LENGTH-1);
--         jet_data : in calo_objects_array(0 to JET_ARRAY_LENGTH-1);
--         tau_data : in calo_objects_array(0 to TAU_ARRAY_LENGTH-1);
--         ett_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--         ht_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--         etm_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--         htm_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
-- -- ****************************************************************************************
-- -- HB 2016-04-18: updates for "min bias trigger" objects (quantities) for Low-pileup-run May 2016
--         mbt1hfp_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--         mbt1hfm_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--         mbt0hfp_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--         mbt0hfm_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
-- -- HB 2016-06-07: inserted new esums quantities (ETTEM and ETMHF).
--         ettem_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--         etmhf_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
-- -- HB 2016-09-16: inserted HTMHF and TOWERCNT
--         htmhf_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--         towercount_data : in std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
-- -- HB 2018-08-06: inserted signals for "Asymmetry" and "Centrality" (included in esums data structure).
--         asymet_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--         asymht_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--         asymethf_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--         asymhthf_data : in std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
--         centrality_data : in std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
-- -- ****************************************************************************************
--         muon_data : in muon_objects_array(0 to MUON_ARRAY_LENGTH-1);
--         external_conditions : in std_logic_vector(EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto 0);
        algo_o : out std_logic_vector(NR_ALGOS-1 downto 0));
end gtl_module;

architecture rtl of gtl_module is
    constant external_conditions_pipeline_stages: natural := 2; -- pipeline stages for "External conditions" to get same pipeline to algos as conditions
    constant centrality_bits_pipeline_stages: natural := 2; -- pipeline stages for "Centrality" to get same pipeline to algos as conditions

    signal muon_data_i : objects_array(0 to MUON_ARRAY_LENGTH-1) := (others => (others => '0'));
    signal eg_data_i : objects_array(0 to EG_ARRAY_LENGTH-1) := (others => (others => '0'));
    signal jet_data_i : objects_array(0 to JET_ARRAY_LENGTH-1) := (others => (others => '0'));
    signal tau_data_i : objects_array(0 to TAU_ARRAY_LENGTH-1) := (others => (others => '0'));
    
    signal muon_bx_p2, muon_bx_p1, muon_bx_0, muon_bx_m1, muon_bx_m2 : objects_array(0 to MUON_ARRAY_LENGTH-1);
    signal eg_bx_p2, eg_bx_p1, eg_bx_0, eg_bx_m1, eg_bx_m2 : objects_array(0 to EG_ARRAY_LENGTH-1);
    signal jet_bx_p2, jet_bx_p1, jet_bx_0, jet_bx_m1, jet_bx_m2 : objects_array(0 to JET_ARRAY_LENGTH-1);
    signal tau_bx_p2, tau_bx_p1, tau_bx_0, tau_bx_m1, tau_bx_m2 : objects_array(0 to TAU_ARRAY_LENGTH-1);
    signal ett_bx_p2, ett_bx_p1, ett_bx_0, ett_bx_m1, ett_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
-- HB 2015-04-28: changed for "htt" - object type from TME [string(1 to 3)] in esums_conditions.vhd
    signal htt_bx_p2, htt_bx_p1, htt_bx_0, htt_bx_m1, htt_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal etm_bx_p2, etm_bx_p1, etm_bx_0, etm_bx_m1, etm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal htm_bx_p2, htm_bx_p1, htm_bx_0, htm_bx_m1, htm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
-- ****************************************************************************************
-- HB 2016-04-18: updates for "min bias trigger" objects (quantities) for Low-pileup-run May 2016
    signal mbt1hfp_bx_p2, mbt1hfp_bx_p1, mbt1hfp_bx_0, mbt1hfp_bx_m1, mbt1hfp_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal mbt1hfm_bx_p2, mbt1hfm_bx_p1, mbt1hfm_bx_0, mbt1hfm_bx_m1, mbt1hfm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal mbt0hfp_bx_p2, mbt0hfp_bx_p1, mbt0hfp_bx_0, mbt0hfp_bx_m1, mbt0hfp_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal mbt0hfm_bx_p2, mbt0hfm_bx_p1, mbt0hfm_bx_0, mbt0hfm_bx_m1, mbt0hfm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
-- HB 2016-06-07: inserted new esums quantities (ETTEM and ETMHF).
    signal ettem_bx_p2, ettem_bx_p1, ettem_bx_0, ettem_bx_m1, ettem_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal etmhf_bx_p2, etmhf_bx_p1, etmhf_bx_0, etmhf_bx_m1, etmhf_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
-- HB 2016-09-16: inserted HTMHF and TOWERCNT
    signal htmhf_bx_p2, htmhf_bx_p1, htmhf_bx_0, htmhf_bx_m1, htmhf_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal towercount_bx_p2, towercount_bx_p1, towercount_bx_0, towercount_bx_m1, towercount_bx_m2 : std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
-- HB 2018-08-06: inserted "Asymmetry" and "Centrality"
    signal asymet_bx_p2, asymet_bx_p1, asymet_bx_0, asymet_bx_m1, asymet_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal asymht_bx_p2, asymht_bx_p1, asymht_bx_0, asymht_bx_m1, asymht_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal asymethf_bx_p2, asymethf_bx_p1, asymethf_bx_0, asymethf_bx_m1, asymethf_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal asymhthf_bx_p2, asymhthf_bx_p1, asymhthf_bx_0, asymhthf_bx_m1, asymhthf_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal centrality_bx_p2_int, centrality_bx_p1_int, centrality_bx_0_int, centrality_bx_m1_int, centrality_bx_m2_int : std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
    signal centrality_bx_p2, centrality_bx_p1, centrality_bx_0, centrality_bx_m1, centrality_bx_m2 : std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
    signal cent0_bx_p2, cent0_bx_p1, cent0_bx_0, cent0_bx_m1, cent0_bx_m2 : std_logic;
    signal cent1_bx_p2, cent1_bx_p1, cent1_bx_0, cent1_bx_m1, cent1_bx_m2 : std_logic;
    signal cent2_bx_p2, cent2_bx_p1, cent2_bx_0, cent2_bx_m1, cent2_bx_m2 : std_logic;
    signal cent3_bx_p2, cent3_bx_p1, cent3_bx_0, cent3_bx_m1, cent3_bx_m2 : std_logic;
    signal cent4_bx_p2, cent4_bx_p1, cent4_bx_0, cent4_bx_m1, cent4_bx_m2 : std_logic;
    signal cent5_bx_p2, cent5_bx_p1, cent5_bx_0, cent5_bx_m1, cent5_bx_m2 : std_logic;
    signal cent6_bx_p2, cent6_bx_p1, cent6_bx_0, cent6_bx_m1, cent6_bx_m2 : std_logic;
    signal cent7_bx_p2, cent7_bx_p1, cent7_bx_0, cent7_bx_m1, cent7_bx_m2 : std_logic;
-- ****************************************************************************************
-- HB 2016-01-08: renamed ext_cond after +/-2bx to ext_cond_bx_p2_int, etc., because ext_cond_bx_p2, etc. used in algos (names coming from TME grammar).
    signal ext_cond_bx_p2_int, ext_cond_bx_p1_int, ext_cond_bx_0_int, ext_cond_bx_m1_int, ext_cond_bx_m2_int : std_logic_vector(EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto 0);
    signal ext_cond_bx_p2, ext_cond_bx_p1, ext_cond_bx_0, ext_cond_bx_m1, ext_cond_bx_m2 : std_logic_vector(EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto 0);

    signal algo : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '0');

{{gtl_module_signals}}

begin

muon_data_l1: for i in 0 to MUON_ARRAY_LENGTH-1 generate
    muon_data_l2: for j in 0 to MUON_DATA_WIDTH-1 generate
        muon_data_i(i)(j) <= muon_data(i)(j);
    end generate muon_data_l2;
end generate muon_data_l1;

eg_data_l1: for i in 0 to EG_ARRAY_LENGTH-1 generate
    eg_data_l2: for j in 0 to EG_DATA_WIDTH-1 generate
        eg_data_i(i)(j) <= eg_data(i)(j);
    end generate eg_data_l2;
end generate eg_data_l1;

jet_data_l1: for i in 0 to JET_ARRAY_LENGTH-1 generate
    jet_data_l2: for j in 0 to JET_DATA_WIDTH-1 generate
        jet_data_i(i)(j) <= jet_data(i)(j);
    end generate jet_data_l2;
end generate jet_data_l1;

tau_data_l1: for i in 0 to TAU_ARRAY_LENGTH-1 generate
    tau_data_l2: for j in 0 to TAU_DATA_WIDTH-1 generate
        tau_data_i(i)(j) <= tau_data(i)(j);
    end generate tau_data_l2;
end generate tau_data_l1;

p_m_2_bx_pipeline_i: entity work.p_m_2_bx_pipeline
    port map(
        lhc_clk,
        muon_data_i, muon_bx_p2, muon_bx_p1, muon_bx_0, muon_bx_m1, muon_bx_m2,
        eg_data_i, eg_bx_p2, eg_bx_p1, eg_bx_0, eg_bx_m1, eg_bx_m2,
        jet_data_i, jet_bx_p2, jet_bx_p1, jet_bx_0, jet_bx_m1, jet_bx_m2,
        tau_data_i, tau_bx_p2, tau_bx_p1, tau_bx_0, tau_bx_m1, tau_bx_m2,
        ett_data, ett_bx_p2, ett_bx_p1, ett_bx_0, ett_bx_m1, ett_bx_m2,
        ht_data, htt_bx_p2, htt_bx_p1, htt_bx_0, htt_bx_m1, htt_bx_m2,
        etm_data, etm_bx_p2, etm_bx_p1, etm_bx_0, etm_bx_m1, etm_bx_m2,
        htm_data, htm_bx_p2, htm_bx_p1, htm_bx_0, htm_bx_m1, htm_bx_m2,
-- ****************************************************************************************
-- HB 2016-04-18: updates for "min bias trigger" objects (quantities) for Low-pileup-run May 2016
        mbt1hfp_data, mbt1hfp_bx_p2, mbt1hfp_bx_p1, mbt1hfp_bx_0, mbt1hfp_bx_m1, mbt1hfp_bx_m2,
        mbt1hfm_data, mbt1hfm_bx_p2, mbt1hfm_bx_p1, mbt1hfm_bx_0, mbt1hfm_bx_m1, mbt1hfm_bx_m2,
        mbt0hfp_data, mbt0hfp_bx_p2, mbt0hfp_bx_p1, mbt0hfp_bx_0, mbt0hfp_bx_m1, mbt0hfp_bx_m2,
        mbt0hfm_data, mbt0hfm_bx_p2, mbt0hfm_bx_p1, mbt0hfm_bx_0, mbt0hfm_bx_m1, mbt0hfm_bx_m2,
-- HB 2016-06-07: inserted new esums quantities (ETTEM and ETMHF).
        ettem_data, ettem_bx_p2, ettem_bx_p1, ettem_bx_0, ettem_bx_m1, ettem_bx_m2,
        etmhf_data, etmhf_bx_p2, etmhf_bx_p1, etmhf_bx_0, etmhf_bx_m1, etmhf_bx_m2,
-- HB 2016-09-16: inserted HTMHF and TOWERCNT
        htmhf_data, htmhf_bx_p2, htmhf_bx_p1, htmhf_bx_0, htmhf_bx_m1, htmhf_bx_m2,
        towercount_data, towercount_bx_p2, towercount_bx_p1, towercount_bx_0, towercount_bx_m1, towercount_bx_m2,
-- HB 2018-08-06: inserted "Asymmetry" and "Centrality"
        asymet_data, asymet_bx_p2, asymet_bx_p1, asymet_bx_0, asymet_bx_m1, asymet_bx_m2,
        asymht_data, asymht_bx_p2, asymht_bx_p1, asymht_bx_0, asymht_bx_m1, asymht_bx_m2,
        asymethf_data, asymethf_bx_p2, asymethf_bx_p1, asymethf_bx_0, asymethf_bx_m1, asymethf_bx_m2,
        asymhthf_data, asymhthf_bx_p2, asymhthf_bx_p1, asymhthf_bx_0, asymhthf_bx_m1, asymhthf_bx_m2,
        centrality_data, centrality_bx_p2_int, centrality_bx_p1_int, centrality_bx_0_int, centrality_bx_m1_int, centrality_bx_m2_int,
-- ****************************************************************************************
-- HB 2016-01-08: renamed ext_cond after +/-2bx to ext_cond_bx_p2_int, etc., because ext_cond_bx_p2, etc. used in algos (names coming from TME grammar).
        external_conditions, ext_cond_bx_p2_int, ext_cond_bx_p1_int, ext_cond_bx_0_int, ext_cond_bx_m1_int, ext_cond_bx_m2_int
    );

-- Parameterized pipeline stages for External conditions, actually 2 stages (fixed) in conditions, see "constant external_conditions_pipeline_stages ..."
-- HB 2016-01-08: renamed ext_cond after +/-2bx to ext_cond_bx_p2_int, etc., because ext_cond_bx_p2, etc. used in algos (names coming from TME grammar).
ext_cond_pipe_p: process(lhc_clk, ext_cond_bx_p2_int, ext_cond_bx_p1_int, ext_cond_bx_0_int, ext_cond_bx_m1_int, ext_cond_bx_m2_int)
    type ext_cond_pipe_array is array (0 to external_conditions_pipeline_stages+1) of std_logic_vector(EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto 0);
    variable ext_cond_bx_p2_pipe_temp : ext_cond_pipe_array := (others => (others => '0'));
    variable ext_cond_bx_p1_pipe_temp : ext_cond_pipe_array := (others => (others => '0'));
    variable ext_cond_bx_0_pipe_temp : ext_cond_pipe_array := (others => (others => '0'));
    variable ext_cond_bx_m1_pipe_temp : ext_cond_pipe_array := (others => (others => '0'));
    variable ext_cond_bx_m2_pipe_temp : ext_cond_pipe_array := (others => (others => '0'));
    begin
        ext_cond_bx_p2_pipe_temp(external_conditions_pipeline_stages+1) := ext_cond_bx_p2_int;
        ext_cond_bx_p1_pipe_temp(external_conditions_pipeline_stages+1) := ext_cond_bx_p1_int;
        ext_cond_bx_0_pipe_temp(external_conditions_pipeline_stages+1) := ext_cond_bx_0_int;
        ext_cond_bx_m1_pipe_temp(external_conditions_pipeline_stages+1) := ext_cond_bx_m1_int;
        ext_cond_bx_m2_pipe_temp(external_conditions_pipeline_stages+1) := ext_cond_bx_m2_int;
        if (external_conditions_pipeline_stages > 0) then 
            if (lhc_clk'event and (lhc_clk = '1') ) then
                ext_cond_bx_p2_pipe_temp(0 to external_conditions_pipeline_stages) := ext_cond_bx_p2_pipe_temp(1 to external_conditions_pipeline_stages+1);
                ext_cond_bx_p1_pipe_temp(0 to external_conditions_pipeline_stages) := ext_cond_bx_p1_pipe_temp(1 to external_conditions_pipeline_stages+1);
                ext_cond_bx_0_pipe_temp(0 to external_conditions_pipeline_stages) := ext_cond_bx_0_pipe_temp(1 to external_conditions_pipeline_stages+1);
                ext_cond_bx_m1_pipe_temp(0 to external_conditions_pipeline_stages) := ext_cond_bx_m1_pipe_temp(1 to external_conditions_pipeline_stages+1);
                ext_cond_bx_m2_pipe_temp(0 to external_conditions_pipeline_stages) := ext_cond_bx_m2_pipe_temp(1 to external_conditions_pipeline_stages+1);
            end if;
        end if;
        ext_cond_bx_p2 <= ext_cond_bx_p2_pipe_temp(1); -- used pipe_temp(1) instead of pipe_temp(0), to prevent warnings in compilation
        ext_cond_bx_p1 <= ext_cond_bx_p1_pipe_temp(1);
        ext_cond_bx_0 <= ext_cond_bx_0_pipe_temp(1);
        ext_cond_bx_m1 <= ext_cond_bx_m1_pipe_temp(1);
        ext_cond_bx_m2 <= ext_cond_bx_m2_pipe_temp(1);
end process;

-- Parameterized pipeline stages for Centrality bits, actually 2 stages (fixed) in conditions, see "constant centrality_bits_pipeline_stages ..."
centrality_pipe_p: process(lhc_clk, centrality_bx_p2_int, centrality_bx_p1_int, centrality_bx_0_int, centrality_bx_m1_int, centrality_bx_m2_int)
    type centrality_pipe_array is array (0 to centrality_bits_pipeline_stages+1) of std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
    variable centrality_bx_p2_pipe_temp : centrality_pipe_array := (others => (others => '0'));
    variable centrality_bx_p1_pipe_temp : centrality_pipe_array := (others => (others => '0'));
    variable centrality_bx_0_pipe_temp : centrality_pipe_array := (others => (others => '0'));
    variable centrality_bx_m1_pipe_temp : centrality_pipe_array := (others => (others => '0'));
    variable centrality_bx_m2_pipe_temp : centrality_pipe_array := (others => (others => '0'));
    begin
        centrality_bx_p2_pipe_temp(centrality_bits_pipeline_stages+1) := centrality_bx_p2_int;
        centrality_bx_p1_pipe_temp(centrality_bits_pipeline_stages+1) := centrality_bx_p1_int;
        centrality_bx_0_pipe_temp(centrality_bits_pipeline_stages+1) := centrality_bx_0_int;
        centrality_bx_m1_pipe_temp(centrality_bits_pipeline_stages+1) := centrality_bx_m1_int;
        centrality_bx_m2_pipe_temp(centrality_bits_pipeline_stages+1) := centrality_bx_m2_int;
        if (centrality_bits_pipeline_stages > 0) then 
            if (lhc_clk'event and (lhc_clk = '1') ) then
                centrality_bx_p2_pipe_temp(0 to centrality_bits_pipeline_stages) := centrality_bx_p2_pipe_temp(1 to centrality_bits_pipeline_stages+1);
                centrality_bx_p1_pipe_temp(0 to centrality_bits_pipeline_stages) := centrality_bx_p1_pipe_temp(1 to centrality_bits_pipeline_stages+1);
                centrality_bx_0_pipe_temp(0 to centrality_bits_pipeline_stages) := centrality_bx_0_pipe_temp(1 to centrality_bits_pipeline_stages+1);
                centrality_bx_m1_pipe_temp(0 to centrality_bits_pipeline_stages) := centrality_bx_m1_pipe_temp(1 to centrality_bits_pipeline_stages+1);
                centrality_bx_m2_pipe_temp(0 to centrality_bits_pipeline_stages) := centrality_bx_m2_pipe_temp(1 to centrality_bits_pipeline_stages+1);
            end if;
        end if;
        centrality_bx_p2 <= centrality_bx_p2_pipe_temp(1); -- used pipe_temp(1) instead of pipe_temp(0), to prevent warnings in compilation
        centrality_bx_p1 <= centrality_bx_p1_pipe_temp(1);
        centrality_bx_0 <= centrality_bx_0_pipe_temp(1);
        centrality_bx_m1 <= centrality_bx_m1_pipe_temp(1);
        centrality_bx_m2 <= centrality_bx_m2_pipe_temp(1);
end process;

-- -- Centrality bit assignment - ?????? not needed - use e.g. centrality_bx_0(0) directly ?????
-- cent0_bx_p2 <= centrality_bx_p2(0);
-- cent1_bx_p2 <= centrality_bx_p2(1);
-- cent2_bx_p2 <= centrality_bx_p2(2);
-- cent3_bx_p2 <= centrality_bx_p2(3);
-- cent4_bx_p2 <= centrality_bx_p2(4);
-- cent5_bx_p2 <= centrality_bx_p2(5);
-- cent6_bx_p2 <= centrality_bx_p2(6);
-- cent7_bx_p2 <= centrality_bx_p2(7);
-- cent0_bx_p1 <= centrality_bx_p1(0);
-- cent1_bx_p1 <= centrality_bx_p1(1);
-- cent2_bx_p1 <= centrality_bx_p1(2);
-- cent3_bx_p1 <= centrality_bx_p1(3);
-- cent4_bx_p1 <= centrality_bx_p1(4);
-- cent5_bx_p1 <= centrality_bx_p1(5);
-- cent6_bx_p1 <= centrality_bx_p1(6);
-- cent7_bx_p1 <= centrality_bx_p1(7);
-- cent0_bx_0 <= centrality_bx_0(0);
-- cent1_bx_0 <= centrality_bx_0(1);
-- cent2_bx_0 <= centrality_bx_0(2);
-- cent3_bx_0 <= centrality_bx_0(3);
-- cent4_bx_0 <= centrality_bx_0(4);
-- cent5_bx_0 <= centrality_bx_0(5);
-- cent6_bx_0 <= centrality_bx_0(6);
-- cent7_bx_0 <= centrality_bx_0(7);
-- cent0_bx_m1 <= centrality_bx_m1(0);
-- cent1_bx_m1 <= centrality_bx_m1(1);
-- cent2_bx_m1 <= centrality_bx_m1(2);
-- cent3_bx_m1 <= centrality_bx_m1(3);
-- cent4_bx_m1 <= centrality_bx_m1(4);
-- cent5_bx_m1 <= centrality_bx_m1(5);
-- cent6_bx_m1 <= centrality_bx_m1(6);
-- cent7_bx_m1 <= centrality_bx_m1(7);
-- cent0_bx_m2 <= centrality_bx_m2(0);
-- cent1_bx_m2 <= centrality_bx_m2(1);
-- cent2_bx_m2 <= centrality_bx_m2(2);
-- cent3_bx_m2 <= centrality_bx_m2(3);
-- cent4_bx_m2 <= centrality_bx_m2(4);
-- cent5_bx_m2 <= centrality_bx_m2(5);
-- cent6_bx_m2 <= centrality_bx_m2(6);
-- cent7_bx_m2 <= centrality_bx_m2(7);

{{gtl_module_instances}}

-- One pipeline stages for algorithms
algo_pipeline_p: process(lhc_clk, algo)
    begin
    if (lhc_clk'event and lhc_clk = '1') then
        algo_o <= algo;
    end if;
end process;

end architecture rtl;
