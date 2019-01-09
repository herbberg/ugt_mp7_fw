
-- Version-history: 

library ieee;
use ieee.std_logic_1164.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;

entity bx_pipeline is
    port(
        clk : in std_logic;
        data : in gtl_data_record;
        pt_muon : out array_obj_parameter_array := (others => (others => (others => '0')));
        eta_muon : out array_obj_parameter_array := (others => (others => (others => '0')));
        phi_muon : out array_obj_parameter_array := (others => (others => (others => '0')));
        iso_muon : out array_obj_parameter_array := (others => (others => (others => '0')));
        qual_muon : out array_obj_parameter_array := (others => (others => (others => '0')));
        charge_muon : out array_obj_parameter_array := (others => (others => (others => '0')));
        pt_eg : out array_obj_parameter_array := (others => (others => (others => '0')));
        eta_eg : out array_obj_parameter_array := (others => (others => (others => '0')));
        phi_eg : out array_obj_parameter_array := (others => (others => (others => '0')));
        iso_eg : out array_obj_parameter_array := (others => (others => (others => '0')));
        pt_jet : out array_obj_parameter_array := (others => (others => (others => '0')));
        eta_jet : out array_obj_parameter_array := (others => (others => (others => '0')));
        phi_jet : out array_obj_parameter_array := (others => (others => (others => '0')));
        pt_tau : out array_obj_parameter_array := (others => (others => (others => '0')));
        eta_tau : out array_obj_parameter_array := (others => (others => (others => '0')));
        phi_tau : out array_obj_parameter_array := (others => (others => (others => '0')));
        iso_tau : out array_obj_parameter_array := (others => (others => (others => '0')));

        pt_ett : out array_obj_parameter_array := (others => (others => (others => '0')));
        pt_etm : out array_obj_parameter_array := (others => (others => (others => '0')));
        phi_etm : out array_obj_parameter_array := (others => (others => (others => '0')));
        pt_htt : out array_obj_parameter_array := (others => (others => (others => '0')));
        pt_htm : out array_obj_parameter_array := (others => (others => (others => '0')));
        phi_htm : out array_obj_parameter_array := (others => (others => (others => '0')));
        pt_ettem : out array_obj_parameter_array := (others => (others => (others => '0')));
        pt_etmhf : out array_obj_parameter_array := (others => (others => (others => '0')));
        phi_etmhf : out array_obj_parameter_array := (others => (others => (others => '0')));
        pt_htmhf : out array_obj_parameter_array := (others => (others => (others => '0')));
        phi_htmhf : out array_obj_parameter_array := (others => (others => (others => '0')));

        count_towercount : out array_obj_parameter_array := (others => (others => (others => '0')));
        
        count_mbt1hfp : out array_obj_parameter_array := (others => (others => (others => '0')));
        count_mbt1hfm : out array_obj_parameter_array := (others => (others => (others => '0')));
        count_mbt0hfp : out array_obj_parameter_array := (others => (others => (others => '0')));
        count_mbt0hfm : out array_obj_parameter_array := (others => (others => (others => '0')));
        
        count_asymet : out array_obj_parameter_array := (others => (others => (others => '0')));
        count_asymht : out array_obj_parameter_array := (others => (others => (others => '0')));
        count_asymethf : out array_obj_parameter_array := (others => (others => (others => '0')));
        count_asymhthf : out array_obj_parameter_array := (others => (others => (others => '0')));

        centrality : out centrality_array := (others => (others => '0'));
        ext_cond : out ext_cond_array := (others => (others => '0'))
    );
end bx_pipeline;

architecture rtl of bx_pipeline is

    signal data_tmp : array_gtl_data_record;

begin

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
        muon_l: for j in 0 to MUON_ARRAY_LENGTH-1 generate
            pt_muon(i)(j)(data_tmp(i).muon_data(j).pt'length-1 downto 0) <= data_tmp(i).muon_data(j).pt;
            eta_muon(i)(j)(data_tmp(i).muon_data(j).eta'length-1 downto 0) <= data_tmp(i).muon_data(j).eta;
            phi_muon(i)(j)(data_tmp(i).muon_data(j).phi'length-1 downto 0) <= data_tmp(i).muon_data(j).phi;
            iso_muon(i)(j)(data_tmp(i).muon_data(j).iso'length-1 downto 0) <= data_tmp(i).muon_data(j).iso;
            qual_muon(i)(j)(data_tmp(i).muon_data(j).qual'length-1 downto 0) <= data_tmp(i).muon_data(j).qual;
            charge_muon(i)(j)(data_tmp(i).muon_data(j).charge'length-1 downto 0) <= data_tmp(i).muon_data(j).charge;
        end generate muon_l;
        eg_l: for j in 0 to EG_ARRAY_LENGTH-1 generate
            pt_eg(i)(j)(data_tmp(i).eg_data(j).pt'length-1 downto 0) <= data_tmp(i).eg_data(j).pt;
            eta_eg(i)(j)(data_tmp(i).eg_data(j).eta'length-1 downto 0) <= data_tmp(i).eg_data(j).eta;
            phi_eg(i)(j)(data_tmp(i).eg_data(j).phi'length-1 downto 0) <= data_tmp(i).eg_data(j).phi;
            iso_eg(i)(j)(data_tmp(i).eg_data(j).iso'length-1 downto 0) <= data_tmp(i).eg_data(j).iso;
        end generate eg_l;
        jet_l: for j in 0 to JET_ARRAY_LENGTH-1 generate
            pt_jet(i)(j)(data_tmp(i).jet_data(j).pt'length-1 downto 0) <= data_tmp(i).jet_data(j).pt;
            eta_jet(i)(j)(data_tmp(i).jet_data(j).eta'length-1 downto 0) <= data_tmp(i).jet_data(j).eta;
            phi_jet(i)(j)(data_tmp(i).jet_data(j).phi'length-1 downto 0) <= data_tmp(i).jet_data(j).phi;
        end generate jet_l;
        tau_l: for j in 0 to TAU_ARRAY_LENGTH-1 generate
            pt_tau(i)(j)(data_tmp(i).tau_data(j).pt'length-1 downto 0) <= data_tmp(i).tau_data(j).pt;
            eta_tau(i)(j)(data_tmp(i).tau_data(j).eta'length-1 downto 0) <= data_tmp(i).tau_data(j).eta;
            phi_tau(i)(j)(data_tmp(i).tau_data(j).phi'length-1 downto 0) <= data_tmp(i).tau_data(j).phi;
            iso_tau(i)(j)(data_tmp(i).tau_data(j).iso'length-1 downto 0) <= data_tmp(i).tau_data(j).iso;
        end generate tau_l;
        
        pt_ett(i)(0)(data_tmp(i).ett_data.pt'length-1 downto 0) <= data_tmp(i).ett_data.pt;
        
        pt_ettem(i)(0)(data_tmp(i).ettem_data.pt'length-1 downto 0) <= data_tmp(i).ettem_data.pt;
        
        pt_etm(i)(0)(data_tmp(i).etm_data.pt'length-1 downto 0) <= data_tmp(i).etm_data.pt;
        phi_etm(i)(0)(data_tmp(i).etm_data.phi'length-1 downto 0) <= data_tmp(i).etm_data.phi;
        
        pt_htt(i)(0)(data_tmp(i).htt_data.pt'length-1 downto 0) <= data_tmp(i).htt_data.pt;
        
        pt_htm(i)(0)(data_tmp(i).htm_data.pt'length-1 downto 0) <= data_tmp(i).htm_data.pt;
        phi_htm(i)(0)(data_tmp(i).htm_data.phi'length-1 downto 0) <= data_tmp(i).htm_data.phi;
        
        pt_etmhf(i)(0)(data_tmp(i).etmhf_data.pt'length-1 downto 0) <= data_tmp(i).etmhf_data.pt;
        phi_etmhf(i)(0)(data_tmp(i).etmhf_data.phi'length-1 downto 0) <= data_tmp(i).etmhf_data.phi;
        
        pt_htmhf(i)(0)(data_tmp(i).htmhf_data.pt'length-1 downto 0) <= data_tmp(i).htmhf_data.pt;
        phi_htmhf(i)(0)(data_tmp(i).htmhf_data.phi'length-1 downto 0) <= data_tmp(i).htmhf_data.phi;
        
        count_towercount(i)(0)(data_tmp(i).towercount_data.count'length-1 downto 0) <= data_tmp(i).towercount_data.count;
        
        count_mbt1hfp(i)(0)(data_tmp(i).mbt1hfp_data.count'length-1 downto 0) <= data_tmp(i).mbt1hfp_data.count;
        count_mbt1hfm(i)(0)(data_tmp(i).mbt1hfm_data.count'length-1 downto 0) <= data_tmp(i).mbt1hfm_data.count;
        count_mbt0hfp(i)(0)(data_tmp(i).mbt0hfp_data.count'length-1 downto 0) <= data_tmp(i).mbt0hfp_data.count;
        count_mbt0hfm(i)(0)(data_tmp(i).mbt0hfm_data.count'length-1 downto 0) <= data_tmp(i).mbt0hfm_data.count;
        
        count_asymet(i)(0)(data_tmp(i).asymet_data.count'length-1 downto 0) <= data_tmp(i).asymet_data.count;
        count_asymht(i)(0)(data_tmp(i).asymht_data.count'length-1 downto 0) <= data_tmp(i).asymht_data.count;
        count_asymethf(i)(0)(data_tmp(i).asymethf_data.count'length-1 downto 0) <= data_tmp(i).asymethf_data.count;
        count_asymhthf(i)(0)(data_tmp(i).asymhthf_data.count'length-1 downto 0) <= data_tmp(i).asymhthf_data.count;
        
-- Additional delay for centrality and ext_cond (no comparators and conditions)

        centrality_pipe_i: entity work.delay_pipeline
            generic map(
                DATA_WIDTH => NR_CENTRALITY_BITS,
                STAGES => CENTRALITY_STAGES
            )
            port map(
                clk, data_tmp(i).centrality_data, centrality(i)
            );
            
        ext_cond_pipe_i: entity work.delay_pipeline
            generic map(
                DATA_WIDTH => EXTERNAL_CONDITIONS_DATA_WIDTH,
                STAGES => EXT_COND_STAGES
            )
            port map(
                clk, data_tmp(i).external_conditions, ext_cond(i)
            );
    end generate bx_l;

end architecture rtl;
