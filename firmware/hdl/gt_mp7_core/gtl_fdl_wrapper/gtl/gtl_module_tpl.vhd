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
    
    signal muon_d, eg_d, jet_d, tau_d : array_obj_bx_record; 
    signal ett_d, etm_d, htt_d, htm_d, ettem_d, etmhf_d, htmhf_d : array_obj_bx_record; 
    signal towercount_d : array_obj_bx_record;
    signal mbt1hfp_d, mbt1hfm_d, mbt0hfp_d, mbt0hfm_d : array_obj_bx_record; 
    signal asymet_d, asymht_d, asymethf_d, asymhthf_d : array_obj_bx_record; 
    signal centrality_d : centrality_array;
    signal ext_cond_d : ext_cond_array;

    signal algo : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '0');

{{gtl_module_signals}}

begin

-- Additional delay for centrality and ext_cond (no comparators register) in "bx_pipeline"

    bx_pipeline_i: entity work.bx_pipeline
        port map(
            lhc_clk,
            data,
            muon_d, eg_d, jet_d, tau_d, 
            ett_d, etm_d, htt_d, htm_d, ettem_d, etmhf_d, htmhf_d, 
            towercount_d,
            mbt1hfp_d, mbt1hfm_d, mbt0hfp_d, mbt0hfm_d, 
            asymet_d, asymht_d, asymethf_d, asymhthf_d, 
            centrality_d,
            ext_cond_d
        );

{{gtl_module_instances}}

-- Pipeline stages for algorithms
    algo_pipeline_i: entity work.delay_pipeline
        generic map(
            DATA_WIDTH => NR_ALGOS,
            STAGES => ALGO_REG_STAGES
        )
        port map(
            lhc_clk, algo, algo_o
        );

end architecture rtl;
