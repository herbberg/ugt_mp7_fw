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
    
    signal muon_bx, eg_bx, jet_bx, tau_bx : array_obj_bx_record; 
    signal ett_bx, etm_bx, htt_bx, htm_bx, ettem_bx, etmhf_bx, htmhf_bx : array_obj_bx_record; 
    signal towercount_bx : array_obj_bx_record;
    signal mbt1hfp_bx, mbt1hfm_bx, mbt0hfp_bx, mbt0hfm_bx : array_obj_bx_record; 
    signal asymet_bx, asymht_bx, asymethf_bx, asymhthf_bx : array_obj_bx_record; 
    signal centrality : centrality_array;
    signal ext_cond : ext_cond_array;

    signal algo : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '0');

{{gtl_module_signals}}

begin

-- Additional delay for centrality and ext_cond (no comparators register) in "bx_pipeline"

bx_pipeline_i: entity work.bx_pipeline
    port map(
        lhc_clk,
        data,
        muon_bx, eg_bx, jet_bx, tau_bx, 
        ett_bx, etm_bx, htt_bx, htm_bx, ettem_bx, etmhf_bx, htmhf_bx, 
        towercount_bx,
        mbt1hfp_bx, mbt1hfm_bx, mbt0hfp_bx, mbt0hfm_bx, 
        asymet_bx, asymht_bx, asymethf_bx, asymhthf_bx, 
        centrality,
        ext_cond
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
