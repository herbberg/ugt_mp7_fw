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

-- Output signals - conversions
    signal eg_pt_vector : bx_eg_pt_vector_array;
    signal eg_cos_phi : bx_eg_integer_array;
    signal eg_sin_phi : bx_eg_integer_array;
    signal eg_conv_mu_cos_phi : bx_eg_integer_array;
    signal eg_conv_mu_sin_phi : bx_eg_integer_array;
    signal eg_conv_2_muon_eta_integer : bx_eg_integer_array;
    signal eg_conv_2_muon_phi_integer : bx_eg_integer_array;
    signal eg_eta_integer : bx_eg_integer_array;
    signal eg_phi_integer : bx_eg_integer_array;

    signal jet_pt_vector : bx_jet_pt_vector_array;
    signal jet_cos_phi : bx_jet_integer_array;
    signal jet_sin_phi : bx_jet_integer_array;
    signal jet_conv_mu_cos_phi : bx_jet_integer_array;
    signal jet_conv_mu_sin_phi : bx_jet_integer_array;
    signal jet_conv_2_muon_eta_integer : bx_jet_integer_array;
    signal jet_conv_2_muon_phi_integer : bx_jet_integer_array;
    signal jet_eta_integer : bx_jet_integer_array;
    signal jet_phi_integer : bx_jet_integer_array;

    signal tau_pt_vector : bx_tau_pt_vector_array;
    signal tau_cos_phi : bx_tau_integer_array;
    signal tau_sin_phi : bx_tau_integer_array;
    signal tau_conv_mu_cos_phi : bx_tau_integer_array;
    signal tau_conv_mu_sin_phi : bx_tau_integer_array;
    signal tau_conv_2_muon_eta_integer : bx_tau_integer_array;
    signal tau_conv_2_muon_phi_integer : bx_tau_integer_array;
    signal tau_eta_integer : bx_tau_integer_array;
    signal tau_phi_integer : bx_tau_integer_array;

    signal muon_pt_vector : bx_muon_pt_vector_array;
    signal muon_cos_phi : bx_muon_integer_array;
    signal muon_sin_phi : bx_muon_integer_array;
    signal muon_eta_integer : bx_muon_integer_array;
    signal muon_phi_integer : bx_muon_integer_array;

{{gtl_module_signals}}

begin

-- Additional delay for centrality and ext_cond (no comparators register) and 
-- conversions for eg, jet, tau and muon in "bx_pipeline"

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
            ext_cond_d,
            eg_pt_vector, eg_cos_phi, eg_sin_phi, eg_conv_mu_cos_phi, eg_conv_mu_sin_phi,
            eg_conv_2_muon_eta_integer, eg_conv_2_muon_phi_integer, eg_eta_integer, eg_phi_integer,
            jet_pt_vector, jet_cos_phi, jet_sin_phi, jet_conv_mu_cos_phi, jet_conv_mu_sin_phi,
            jet_conv_2_muon_eta_integer, jet_conv_2_muon_phi_integer, jet_eta_integer, jet_phi_integer,
            tau_pt_vector, tau_cos_phi, tau_sin_phi, tau_conv_mu_cos_phi, tau_conv_mu_sin_phi,
            tau_conv_2_muon_eta_integer, tau_conv_2_muon_phi_integer, tau_eta_integer, tau_phi_integer,
            muon_pt_vector, muon_cos_phi, muon_sin_phi, muon_eta_integer, muon_phi_integer
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
