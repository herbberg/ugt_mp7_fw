-- Description:
-- Pipeline for +/-2 bx data.

-- Version-history: 
-- HB 2019-02-25: included conversions for eg, jet, tau and muon.
-- HB 2019-01-23: included additional delay for centrality and ext_cond (no comparators and conditions)

library ieee;
use ieee.std_logic_1164.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;

entity bx_pipeline is
    port(
        clk : in std_logic;
        data : in gtl_data_record;
--         muon_bx, eg_bx, jet_bx, tau_bx : out array_obj_bx_record := (others => (others => (others => (others => '0'))));
        muon_bx_o, eg_bx_o, jet_bx_o, tau_bx_o : out array_obj_bx_record := (others => (others => (others => (others => '0'))));
        ett_bx, etm_bx, htt_bx, htm_bx, ettem_bx, etmhf_bx, htmhf_bx : out array_obj_bx_record := (others => (others => (others => (others => '0'))));
        towercount_bx : out array_obj_bx_record := (others => (others => (others => (others => '0'))));
        mbt1hfp_bx, mbt1hfm_bx, mbt0hfp_bx, mbt0hfm_bx : out array_obj_bx_record := (others => (others => (others => (others => '0'))));
        asymet_bx, asymht_bx, asymethf_bx, asymhthf_bx : out array_obj_bx_record := (others => (others => (others => (others => '0'))));
        centrality : out centrality_array := (others => (others => '0'));
        ext_cond : out ext_cond_array := (others => (others => '0'));
        eg_pt_vector : out bx_eg_pt_vector_array;
        eg_cos_phi : out bx_eg_integer_array;
        eg_sin_phi : out bx_eg_integer_array;
        eg_conv_mu_cos_phi : out bx_eg_integer_array;
        eg_conv_mu_sin_phi : out bx_eg_integer_array;
        eg_conv_2_muon_eta_integer : out bx_eg_integer_array;
        eg_conv_2_muon_phi_integer : out bx_eg_integer_array;
        eg_eta_integer : out bx_eg_integer_array;
        eg_phi_integer : out bx_eg_integer_array;
        jet_pt_vector : out bx_jet_pt_vector_array;
        jet_cos_phi : out bx_jet_integer_array;
        jet_sin_phi : out bx_jet_integer_array;
        jet_conv_mu_cos_phi : out bx_jet_integer_array;
        jet_conv_mu_sin_phi : out bx_jet_integer_array;
        jet_conv_2_muon_eta_integer : out bx_jet_integer_array;
        jet_conv_2_muon_phi_integer : out bx_jet_integer_array;
        jet_eta_integer : out bx_jet_integer_array;
        jet_phi_integer : out bx_jet_integer_array;
        tau_pt_vector : out bx_tau_pt_vector_array;
        tau_cos_phi : out bx_tau_integer_array;
        tau_sin_phi : out bx_tau_integer_array;
        tau_conv_mu_cos_phi : out bx_tau_integer_array;
        tau_conv_mu_sin_phi : out bx_tau_integer_array;
        tau_conv_2_muon_eta_integer : out bx_tau_integer_array;
        tau_conv_2_muon_phi_integer : out bx_tau_integer_array;
        tau_eta_integer : out bx_tau_integer_array;
        tau_phi_integer : out bx_tau_integer_array;
        muon_pt_vector : out bx_muon_pt_vector_array;
        muon_cos_phi : out bx_muon_integer_array;
        muon_sin_phi : out bx_muon_integer_array;
        muon_eta_integer : out bx_muon_integer_array;
        muon_phi_integer : out bx_muon_integer_array
    );
end bx_pipeline;

architecture rtl of bx_pipeline is

    type array_gtl_data_record is array (0 to BX_PIPELINE_STAGES-1) of gtl_data_record;       
    signal data_tmp : array_gtl_data_record;
    signal muon_bx, eg_bx, jet_bx, tau_bx : array_obj_bx_record;

begin

-- BX pipeline
    process(clk, data)
    begin
        data_tmp(0) <= data;
        for i in 0 to (BX_PIPELINE_STAGES-1)-1 loop
            if (clk'event and clk = '1') then
                data_tmp(i+1) <= data_tmp(i);
            end if;
        end loop;
    end process;
    
    bx_l: for i in 0 to BX_PIPELINE_STAGES-1 generate
        muon_l: for j in 0 to N_MUON_OBJECTS-1 generate
            muon_bx(i).pt(j)(data_tmp(i).muon(j).pt'length-1 downto 0) <= data_tmp(i).muon(j).pt;
            muon_bx(i).eta(j)(data_tmp(i).muon(j).eta'length-1 downto 0) <= data_tmp(i).muon(j).eta;
            muon_bx(i).phi(j)(data_tmp(i).muon(j).phi'length-1 downto 0) <= data_tmp(i).muon(j).phi;
            muon_bx(i).iso(j)(data_tmp(i).muon(j).iso'length-1 downto 0) <= data_tmp(i).muon(j).iso;
            muon_bx(i).qual(j)(data_tmp(i).muon(j).qual'length-1 downto 0) <= data_tmp(i).muon(j).qual;
            muon_bx(i).charge(j)(data_tmp(i).muon(j).charge'length-1 downto 0) <= data_tmp(i).muon(j).charge;
        end generate muon_l;
        eg_l: for j in 0 to N_EG_OBJECTS-1 generate            
            eg_bx(i).pt(j)(data_tmp(i).eg(j).pt'length-1 downto 0) <= data_tmp(i).eg(j).pt;
            eg_bx(i).eta(j)(data_tmp(i).eg(j).eta'length-1 downto 0) <= data_tmp(i).eg(j).eta;
            eg_bx(i).phi(j)(data_tmp(i).eg(j).phi'length-1 downto 0) <= data_tmp(i).eg(j).phi;
            eg_bx(i).iso(j)(data_tmp(i).eg(j).iso'length-1 downto 0) <= data_tmp(i).eg(j).iso;
        end generate eg_l;
        jet_l: for j in 0 to N_JET_OBJECTS-1 generate
            jet_bx(i).pt(j)(data_tmp(i).jet(j).pt'length-1 downto 0) <= data_tmp(i).jet(j).pt;
            jet_bx(i).eta(j)(data_tmp(i).jet(j).eta'length-1 downto 0) <= data_tmp(i).jet(j).eta;
            jet_bx(i).phi(j)(data_tmp(i).jet(j).phi'length-1 downto 0) <= data_tmp(i).jet(j).phi;
        end generate jet_l;
        tau_l: for j in 0 to N_TAU_OBJECTS-1 generate
            tau_bx(i).pt(j)(data_tmp(i).tau(j).pt'length-1 downto 0) <= data_tmp(i).tau(j).pt;
            tau_bx(i).eta(j)(data_tmp(i).tau(j).eta'length-1 downto 0) <= data_tmp(i).tau(j).eta;
            tau_bx(i).phi(j)(data_tmp(i).tau(j).phi'length-1 downto 0) <= data_tmp(i).tau(j).phi;
            tau_bx(i).iso(j)(data_tmp(i).tau(j).iso'length-1 downto 0) <= data_tmp(i).tau(j).iso;
        end generate tau_l;
        
        ett_bx(i).pt(0)(data_tmp(i).ett.pt'length-1 downto 0) <= data_tmp(i).ett.pt;
        
        ettem_bx(i).pt(0)(data_tmp(i).ettem.pt'length-1 downto 0) <= data_tmp(i).ettem.pt;
        
        etm_bx(i).pt(0)(data_tmp(i).etm.pt'length-1 downto 0) <= data_tmp(i).etm.pt;
        etm_bx(i).phi(0)(data_tmp(i).etm.phi'length-1 downto 0) <= data_tmp(i).etm.phi;
        
        htt_bx(i).pt(0)(data_tmp(i).htt.pt'length-1 downto 0) <= data_tmp(i).htt.pt;
        
        htm_bx(i).pt(0)(data_tmp(i).htm.pt'length-1 downto 0) <= data_tmp(i).htm.pt;
        htm_bx(i).phi(0)(data_tmp(i).htm.phi'length-1 downto 0) <= data_tmp(i).htm.phi;
        
        etmhf_bx(i).pt(0)(data_tmp(i).etmhf.pt'length-1 downto 0) <= data_tmp(i).etmhf.pt;
        etmhf_bx(i).phi(0)(data_tmp(i).etmhf.phi'length-1 downto 0) <= data_tmp(i).etmhf.phi;
        
        htmhf_bx(i).pt(0)(data_tmp(i).htmhf.pt'length-1 downto 0) <= data_tmp(i).htmhf.pt;
        htmhf_bx(i).phi(0)(data_tmp(i).htmhf.phi'length-1 downto 0) <= data_tmp(i).htmhf.phi;
        
        towercount_bx(i).count(0)(data_tmp(i).towercount.count'length-1 downto 0) <= data_tmp(i).towercount.count;
        
        mbt1hfp_bx(i).count(0)(data_tmp(i).mbt1hfp.count'length-1 downto 0) <= data_tmp(i).mbt1hfp.count;
        mbt1hfm_bx(i).count(0)(data_tmp(i).mbt1hfm.count'length-1 downto 0) <= data_tmp(i).mbt1hfm.count;
        mbt0hfp_bx(i).count(0)(data_tmp(i).mbt0hfp.count'length-1 downto 0) <= data_tmp(i).mbt0hfp.count;
        mbt0hfm_bx(i).count(0)(data_tmp(i).mbt0hfm.count'length-1 downto 0) <= data_tmp(i).mbt0hfm.count;
        
        asymet_bx(i).count(0)(data_tmp(i).asymet.count'length-1 downto 0) <= data_tmp(i).asymet.count;
        asymht_bx(i).count(0)(data_tmp(i).asymht.count'length-1 downto 0) <= data_tmp(i).asymht.count;
        asymethf_bx(i).count(0)(data_tmp(i).asymethf.count'length-1 downto 0) <= data_tmp(i).asymethf.count;
        asymhthf_bx(i).count(0)(data_tmp(i).asymhthf.count'length-1 downto 0) <= data_tmp(i).asymhthf.count;
        
-- Additional delay for centrality and ext_cond (no comparators and conditions)

        centrality_pipe_i: entity work.delay_pipeline
            generic map(
                DATA_WIDTH => NR_CENTRALITY_BITS,
                STAGES => CENTRALITY_STAGES
            )
            port map(
                clk, data_tmp(i).centrality, centrality(i)
            );
            
        ext_cond_pipe_i: entity work.delay_pipeline
            generic map(
                DATA_WIDTH => EXTERNAL_CONDITIONS_DATA_WIDTH,
                STAGES => EXT_COND_STAGES
            )
            port map(
                clk, data_tmp(i).external_conditions, ext_cond(i)
            );
            
-- Conversions for muon, eg, jet and tau parameters - NOCH ERWEITERN !!! 2019-02-22

        eg_conversions_i: entity work.conversions
            generic map(
                N_EG_OBJECTS, eg
            )
            port map(
                pt => eg_bx(i).pt, eta => eg_bx(i).eta, phi => eg_bx(i).phi,
                pt_vector => eg_pt_vector(i), cos_phi => eg_cos_phi(i), sin_phi => eg_sin_phi(i),
                conv_mu_cos_phi => eg_conv_mu_cos_phi(i), conv_mu_sin_phi => eg_conv_mu_sin_phi(i),
                conv_2_muon_eta_integer => eg_conv_2_muon_eta_integer(i), conv_2_muon_phi_integer => eg_conv_2_muon_phi_integer(i),
                eta_integer => eg_eta_integer(i), phi_integer => eg_phi_integer(i) 
            );
            
        jet_conversions_i: entity work.conversions
            generic map(
                N_JET_OBJECTS, jet
            )
            port map(
                pt => jet_bx(i).pt, eta => jet_bx(i).eta, phi => jet_bx(i).phi,        
                pt_vector => jet_pt_vector(i), cos_phi => jet_cos_phi(i), sin_phi => jet_sin_phi(i),
                conv_mu_cos_phi => jet_conv_mu_cos_phi(i), conv_mu_sin_phi => jet_conv_mu_sin_phi(i),
                conv_2_muon_eta_integer => jet_conv_2_muon_eta_integer(i), conv_2_muon_phi_integer => jet_conv_2_muon_phi_integer(i),
                eta_integer => jet_eta_integer(i), phi_integer => jet_phi_integer(i) 
            );
            
        tau_conversions_i: entity work.conversions
            generic map(
                N_TAU_OBJECTS, tau
            )
            port map(
                pt => tau_bx(i).pt, eta => tau_bx(i).eta, phi => tau_bx(i).phi,        
                pt_vector => tau_pt_vector(i), cos_phi => tau_cos_phi(i), sin_phi => tau_sin_phi(i),
                conv_mu_cos_phi => tau_conv_mu_cos_phi(i), conv_mu_sin_phi => tau_conv_mu_sin_phi(i),
                conv_2_muon_eta_integer => tau_conv_2_muon_eta_integer(i), conv_2_muon_phi_integer => tau_conv_2_muon_phi_integer(i),
                eta_integer => tau_eta_integer(i), phi_integer => tau_phi_integer(i) 
            );
            
        muon_conversions_i: entity work.conversions
            generic map(
                N_MUON_OBJECTS, muon
            )
            port map(
                pt => muon_bx(i).pt, eta => muon_bx(i).eta, phi => muon_bx(i).phi,        
                pt_vector => muon_pt_vector(i), cos_phi => muon_cos_phi(i), sin_phi => muon_sin_phi(i),
                eta_integer => muon_eta_integer(i), phi_integer => muon_phi_integer(i) 
            );
            
    end generate bx_l;
    
-- Output bx object parameters (muon, eg, jet and tau)

    muon_bx_o <= muon_bx;
    eg_bx_o <= eg_bx;
    jet_bx_o <= jet_bx;
    tau_bx_o <= tau_bx;

end architecture rtl;
