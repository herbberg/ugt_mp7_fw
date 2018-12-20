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
        algo_o : out std_logic_vector(NR_ALGOS-1 downto 0));
end gtl_module;

architecture rtl of gtl_module is
    
    signal muon_bx_p2, muon_bx_p1, muon_bx_0, muon_bx_m1, muon_bx_m2 : muon_objects_array(0 to MUON_ARRAY_LENGTH-1);
    signal eg_bx_p2, eg_bx_p1, eg_bx_0, eg_bx_m1, eg_bx_m2 : calo_objects_array(0 to EG_ARRAY_LENGTH-1);
    signal jet_bx_p2, jet_bx_p1, jet_bx_0, jet_bx_m1, jet_bx_m2 : calo_objects_array(0 to JET_ARRAY_LENGTH-1);
    signal tau_bx_p2, tau_bx_p1, tau_bx_0, tau_bx_m1, tau_bx_m2 : calo_objects_array(0 to TAU_ARRAY_LENGTH-1);
    signal ett_bx_p2, ett_bx_p1, ett_bx_0, ett_bx_m1, ett_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal htt_bx_p2, htt_bx_p1, htt_bx_0, htt_bx_m1, htt_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal etm_bx_p2, etm_bx_p1, etm_bx_0, etm_bx_m1, etm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal htm_bx_p2, htm_bx_p1, htm_bx_0, htm_bx_m1, htm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal mbt1hfp_bx_p2, mbt1hfp_bx_p1, mbt1hfp_bx_0, mbt1hfp_bx_m1, mbt1hfp_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal mbt1hfm_bx_p2, mbt1hfm_bx_p1, mbt1hfm_bx_0, mbt1hfm_bx_m1, mbt1hfm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal mbt0hfp_bx_p2, mbt0hfp_bx_p1, mbt0hfp_bx_0, mbt0hfp_bx_m1, mbt0hfp_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal mbt0hfm_bx_p2, mbt0hfm_bx_p1, mbt0hfm_bx_0, mbt0hfm_bx_m1, mbt0hfm_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal ettem_bx_p2, ettem_bx_p1, ettem_bx_0, ettem_bx_m1, ettem_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal etmhf_bx_p2, etmhf_bx_p1, etmhf_bx_0, etmhf_bx_m1, etmhf_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal htmhf_bx_p2, htmhf_bx_p1, htmhf_bx_0, htmhf_bx_m1, htmhf_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal towercount_bx_p2, towercount_bx_p1, towercount_bx_0, towercount_bx_m1, towercount_bx_m2 : std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
    signal asymet_bx_p2, asymet_bx_p1, asymet_bx_0, asymet_bx_m1, asymet_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal asymht_bx_p2, asymht_bx_p1, asymht_bx_0, asymht_bx_m1, asymht_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal asymethf_bx_p2, asymethf_bx_p1, asymethf_bx_0, asymethf_bx_m1, asymethf_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal asymhthf_bx_p2, asymhthf_bx_p1, asymhthf_bx_0, asymhthf_bx_m1, asymhthf_bx_m2 : std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
    signal centrality_bx_p2_int, centrality_bx_p1_int, centrality_bx_0_int, centrality_bx_m1_int, centrality_bx_m2_int : std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
    signal centrality_bx_p2, centrality_bx_p1, centrality_bx_0, centrality_bx_m1, centrality_bx_m2 : std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
    signal ext_cond_bx_p2_int, ext_cond_bx_p1_int, ext_cond_bx_0_int, ext_cond_bx_m1_int, ext_cond_bx_m2_int : std_logic_vector(EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto 0);
    signal ext_cond_bx_p2, ext_cond_bx_p1, ext_cond_bx_0, ext_cond_bx_m1, ext_cond_bx_m2 : std_logic_vector(EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto 0);

    signal algo : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '0');

{{gtl_module_signals}}

begin

bx_pipeline_i: entity work.bx_pipeline
    port map(
        lhc_clk,
        data, 
        muon_bx_p2, muon_bx_p1, muon_bx_0, muon_bx_m1, muon_bx_m2,
        eg_bx_p2, eg_bx_p1, eg_bx_0, eg_bx_m1, eg_bx_m2,
        jet_bx_p2, jet_bx_p1, jet_bx_0, jet_bx_m1, jet_bx_m2,
        tau_bx_p2, tau_bx_p1, tau_bx_0, tau_bx_m1, tau_bx_m2,
        ett_bx_p2, ett_bx_p1, ett_bx_0, ett_bx_m1, ett_bx_m2,
        htt_bx_p2, htt_bx_p1, htt_bx_0, htt_bx_m1, htt_bx_m2,
        etm_bx_p2, etm_bx_p1, etm_bx_0, etm_bx_m1, etm_bx_m2,
        htm_bx_p2, htm_bx_p1, htm_bx_0, htm_bx_m1, htm_bx_m2,
        mbt1hfp_bx_p2, mbt1hfp_bx_p1, mbt1hfp_bx_0, mbt1hfp_bx_m1, mbt1hfp_bx_m2,
        mbt1hfm_bx_p2, mbt1hfm_bx_p1, mbt1hfm_bx_0, mbt1hfm_bx_m1, mbt1hfm_bx_m2,
        mbt0hfp_bx_p2, mbt0hfp_bx_p1, mbt0hfp_bx_0, mbt0hfp_bx_m1, mbt0hfp_bx_m2,
        mbt0hfm_bx_p2, mbt0hfm_bx_p1, mbt0hfm_bx_0, mbt0hfm_bx_m1, mbt0hfm_bx_m2,
        ettem_bx_p2, ettem_bx_p1, ettem_bx_0, ettem_bx_m1, ettem_bx_m2,
        etmhf_bx_p2, etmhf_bx_p1, etmhf_bx_0, etmhf_bx_m1, etmhf_bx_m2,
        htmhf_bx_p2, htmhf_bx_p1, htmhf_bx_0, htmhf_bx_m1, htmhf_bx_m2,
        towercount_bx_p2, towercount_bx_p1, towercount_bx_0, towercount_bx_m1, towercount_bx_m2,
        asymet_bx_p2, asymet_bx_p1, asymet_bx_0, asymet_bx_m1, asymet_bx_m2,
        asymht_bx_p2, asymht_bx_p1, asymht_bx_0, asymht_bx_m1, asymht_bx_m2,
        asymethf_bx_p2, asymethf_bx_p1, asymethf_bx_0, asymethf_bx_m1, asymethf_bx_m2,
        asymhthf_bx_p2, asymhthf_bx_p1, asymhthf_bx_0, asymhthf_bx_m1, asymhthf_bx_m2,
        centrality_bx_p2_int, centrality_bx_p1_int, centrality_bx_0_int, centrality_bx_m1_int, centrality_bx_m2_int,
        ext_cond_bx_p2_int, ext_cond_bx_p1_int, ext_cond_bx_0_int, ext_cond_bx_m1_int, ext_cond_bx_m2_int
    );

ext_cond_pipe_i: entity work.delay_pipeline
    generic map(
        DATA_WIDTH => EXTERNAL_CONDITIONS_DATA_WIDTH,
        STAGES => EXT_COND_STAGES
    )
    port map(
        lhc_clk,
        ext_cond_bx_p2_int, ext_cond_bx_p1_int, ext_cond_bx_0_int, ext_cond_bx_m1_int, ext_cond_bx_m2_int,
        ext_cond_bx_p2, ext_cond_bx_p1, ext_cond_bx_0, ext_cond_bx_m1, ext_cond_bx_m2
    );

centrality_pipe_i: entity work.delay_pipeline
    generic map(
        DATA_WIDTH => NR_CENTRALITY_BITS,
        STAGES => CENTRALITY_STAGES
    )
    port map(
        lhc_clk,
        centrality_bx_p2_int, centrality_bx_p1_int, centrality_bx_0_int, centrality_bx_m1_int, centrality_bx_m2_int,
        centrality_bx_p2, centrality_bx_p1, centrality_bx_0, centrality_bx_m1, centrality_bx_m2
    );

{{gtl_module_instances}}

-- One pipeline stages for algorithms
algo_pipeline_p: process(lhc_clk, algo)
    begin
    if (lhc_clk'event and lhc_clk = '1') then
        algo_o <= algo;
    end if;
end process;

end architecture rtl;
