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
    
    signal muon_arr, eg_arr, jet_arr, tau_arr : array_obj_bx_record; 
    signal ett_arr, etm_arr, htt_arr, htm_arr, ettem_arr, etmhf_arr, htmhf_arr : array_obj_bx_record; 
    signal towercount_arr : array_obj_bx_record;
    signal mbt1hfp_arr, mbt1hfm_arr, mbt0hfp_arr, mbt0hfm_arr : array_obj_bx_record; 
    signal asymet_arr, asymht_arr, asymethf_arr, asymhthf_arr : array_obj_bx_record; 
    signal centrality_arr : centrality_array;
    signal ext_cond_arr : ext_cond_array;

    signal algo : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '0');

{{gtl_module_signals}}

begin

-- Additional delay for centrality and ext_cond (no comparators register) in "bx_pipeline"

bx_pipeline_i: entity work.bx_pipeline
    port map(
        lhc_clk,
        data,
        muon_arr, eg_arr, jet_arr, tau_arr, 
        ett_arr, etm_arr, htt_arr, htm_arr, ettem_arr, etmhf_arr, htmhf_arr, 
        towercount_arr,
        mbt1hfp_arr, mbt1hfm_arr, mbt0hfp_arr, mbt0hfm_arr, 
        asymet_arr, asymht_arr, asymethf_arr, asymhthf_arr, 
        centrality_arr,
        ext_cond_arr
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
