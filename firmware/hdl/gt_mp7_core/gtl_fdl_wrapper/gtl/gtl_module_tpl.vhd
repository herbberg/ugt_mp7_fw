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
    
    signal pt_muon_bx, eta_muon_bx, phi_muon_bx, iso_muon_bx, qual_muon_bx, charge_muon_bx : array_obj_parameter_array; 
    signal pt_eg_bx, eta_eg_bx, phi_eg_bx, iso_eg_bx : array_obj_parameter_array; 
    signal pt_jet_bx, eta_jet_bx, phi_jet_bx : array_obj_parameter_array;
    signal pt_tau_bx, eta_tau_bx, phi_tau_bx, iso_tau_bx : array_obj_parameter_array; 
    signal pt_ett_bx, pt_etm_bx, phi_etm_bx : array_obj_parameter_array; 
    signal pt_htt_bx, pt_htm_bx, phi_htm_bx : array_obj_parameter_array; 
    signal pt_ettem_bx, pt_etmhf_bx, phi_etmhf_bx : array_obj_parameter_array; 
    signal pt_htmhf_bx, phi_htmhf_bx : array_obj_parameter_array; 
    signal count_towercount : array_obj_parameter_array;
    signal count_mbt1hfp, count_mbt1hfm, count_mbt0hfp, count_mbt0hfm : array_obj_parameter_array; 
    signal count_asymet, count_asymht, count_asymethf, count_asymhthf : array_obj_parameter_array; 
    signal centrality_int, centrality : centrality_array;
    signal ext_cond_int, ext_cond : ext_cond_array;

    signal algo : std_logic_vector(NR_ALGOS-1 downto 0) := (others => '0');

{{gtl_module_signals}}

begin

-- Additional delay for centrality and ext_cond (no comparators and conditions) in "bx_pipeline"

bx_pipeline_i: entity work.bx_pipeline
    port map(
        lhc_clk,
        data, 
        pt_muon_bx, eta_muon_bx, phi_muon_bx, iso_muon_bx, qual_muon_bx, charge_muon_bx, 
        pt_eg_bx, eta_eg_bx, phi_eg_bx, iso_eg_bx, 
        pt_jet_bx, eta_jet_bx, phi_jet_bx, 
        pt_tau_bx, eta_tau_bx, phi_tau_bx, iso_tau_bx, 
        pt_ett_bx, pt_etm_bx, phi_etm_bx, 
        pt_htt_bx, pt_htm_bx, phi_htm_bx, 
        pt_ettem_bx, pt_etmhf_bx, phi_etmhf_bx, 
        pt_htmhf_bx, phi_htmhf_bx, 
        count_towercount,
        count_mbt1hfp, count_mbt1hfm, count_mbt0hfp, count_mbt0hfm, 
        count_asymet, count_asymht, count_asymethf, count_asymhthf, 
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
