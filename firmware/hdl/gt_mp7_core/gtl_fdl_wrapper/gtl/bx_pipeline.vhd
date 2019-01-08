
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

    type array_eg_record_array is array (0 to BX_PIPELINE_STAGES-1) of eg_record_array(0 to EG_ARRAY_LENGTH-1);    
    type array_jet_record_array is array (0 to BX_PIPELINE_STAGES-1) of jet_record_array(0 to JET_ARRAY_LENGTH-1);    
    type array_tau_record_array is array (0 to BX_PIPELINE_STAGES-1) of tau_record_array(0 to TAU_ARRAY_LENGTH-1);    
    type array_muon_record_array is array (0 to BX_PIPELINE_STAGES-1) of muon_record_array(0 to MUON_ARRAY_LENGTH-1);    
    signal eg_tmp : array_eg_record_array;
    signal jet_tmp : array_jet_record_array;
    signal tau_tmp : array_tau_record_array;
    signal muon_tmp : array_muon_record_array;
    
    type ett_array is array (0 to BX_PIPELINE_STAGES-1) of ett_record;    
    type etm_array is array (0 to BX_PIPELINE_STAGES-1) of etm_record;    
    type htt_array is array (0 to BX_PIPELINE_STAGES-1) of htt_record;    
    type htm_array is array (0 to BX_PIPELINE_STAGES-1) of htm_record;    
    type ettem_array is array (0 to BX_PIPELINE_STAGES-1) of ettem_record;    
    type etmhf_array is array (0 to BX_PIPELINE_STAGES-1) of etmhf_record;    
    type htmhf_array is array (0 to BX_PIPELINE_STAGES-1) of htmhf_record;    
    signal ett_tmp : ett_array;
    signal etm_tmp : etm_array;
    signal htt_tmp : htt_array;
    signal htm_tmp : htm_array;
    signal ettem_tmp : ettem_array;
    signal etmhf_tmp : etmhf_array;
    signal htmhf_tmp : htmhf_array;

    type towercount_array is array (0 to BX_PIPELINE_STAGES-1) of towercount_record;    
    signal towercount_tmp : towercount_array;
    
    type mb_array is array (0 to BX_PIPELINE_STAGES-1) of mb_record;    
    signal mbt1hfp_tmp : mb_array;
    signal mbt1hfm_tmp : mb_array;
    signal mbt0hfp_tmp : mb_array;
    signal mbt0hfm_tmp : mb_array;
    
    type asym_array is array (0 to BX_PIPELINE_STAGES-1) of asym_record;    
    signal asymet_tmp : asym_array;
    signal asymht_tmp : asym_array;
    signal asymethf_tmp : asym_array;
    signal asymhthf_tmp : asym_array;
    
    signal centrality_tmp : centrality_array;

    signal ext_cond_tmp : ext_cond_array;

begin

    process(clk, data)
    begin
        muon_tmp(0) <= data.muon_data;
        eg_tmp(0) <= data.eg_data;
        jet_tmp(0) <= data.jet_data;
        tau_tmp(0) <= data.tau_data;
        ett_tmp(0) <= data.ett_data;
        etm_tmp(0) <= data.etm_data;
        htt_tmp(0) <= data.ht_data;
        htm_tmp(0) <= data.htm_data;
        ettem_tmp(0) <= data.ettem_data;
        etmhf_tmp(0) <= data.etmhf_data;
        htmhf_tmp(0) <= data.htmhf_data;
        towercount_tmp(0) <= data.towercount_data;
        mbt1hfp_tmp(0) <= data.mbt1hfp_data;
        mbt1hfm_tmp(0) <= data.mbt1hfm_data;
        mbt0hfp_tmp(0) <= data.mbt0hfp_data;
        mbt0hfm_tmp(0) <= data.mbt0hfm_data;
        asymet_tmp(0) <= data.asymet_data;
        asymht_tmp(0) <= data.asymht_data;
        asymethf_tmp(0) <= data.asymethf_data;
        asymhthf_tmp(0) <= data.asymhthf_data;
        centrality_tmp(0) <= data.centrality_data;
        ext_cond_tmp(0) <= data.external_conditions;
        for i in 0 to (BX_PIPELINE_STAGES-1)-1 loop
            if (clk'event and clk = '1') then
                muon_tmp(i+1) <= muon_tmp(i);
                eg_tmp(i+1) <= eg_tmp(i);
                jet_tmp(i+1) <= jet_tmp(i);
                tau_tmp(i+1) <= tau_tmp(i);
                ett_tmp(i+1) <= ett_tmp(i);
                etm_tmp(i+1) <= etm_tmp(i);
                htt_tmp(i+1) <= htt_tmp(i);
                htm_tmp(i+1) <= htm_tmp(i);
                ettem_tmp(i+1) <= ettem_tmp(i);
                etmhf_tmp(i+1) <= etmhf_tmp(i);
                htmhf_tmp(i+1) <= htmhf_tmp(i);
                towercount_tmp(i+1) <= towercount_tmp(i);
                mbt1hfp_tmp(i+1) <= mbt1hfp_tmp(i);
                mbt1hfm_tmp(i+1) <= mbt1hfm_tmp(i);
                mbt0hfp_tmp(i+1) <= mbt0hfp_tmp(i);
                mbt0hfm_tmp(i+1) <= mbt0hfm_tmp(i);
                asymet_tmp(i+1) <= asymet_tmp(i);
                asymht_tmp(i+1) <= asymht_tmp(i);
                asymethf_tmp(i+1) <= asymethf_tmp(i);
                asymhthf_tmp(i+1) <= asymhthf_tmp(i);
                centrality_tmp(i+1) <= centrality_tmp(i);
                ext_cond_tmp(i+1) <= ext_cond_tmp(i);
            end if;
        end loop;
    end process;

    bx_l: for i in 0 to BX_PIPELINE_STAGES-1 generate
        muon_l: for j in 0 to MUON_ARRAY_LENGTH-1 generate
            pt_muon(i)(j)(muon_tmp(i)(j).pt'length-1 downto 0) <= muon_tmp(i)(j).pt;
            eta_muon(i)(j)(muon_tmp(i)(j).eta'length-1 downto 0) <= muon_tmp(i)(j).eta;
            phi_muon(i)(j)(muon_tmp(i)(j).phi'length-1 downto 0) <= muon_tmp(i)(j).phi;
            iso_muon(i)(j)(muon_tmp(i)(j).iso'length-1 downto 0) <= muon_tmp(i)(j).iso;
            qual_muon(i)(j)(muon_tmp(i)(j).qual'length-1 downto 0) <= muon_tmp(i)(j).qual;
            charge_muon(i)(j)(muon_tmp(i)(j).charge'length-1 downto 0) <= muon_tmp(i)(j).charge;
        end generate muon_l;
        eg_l: for j in 0 to EG_ARRAY_LENGTH-1 generate
            pt_eg(i)(j)(eg_tmp(i)(j).pt'length-1 downto 0) <= eg_tmp(i)(j).pt;
            eta_eg(i)(j)(eg_tmp(i)(j).eta'length-1 downto 0) <= eg_tmp(i)(j).eta;
            phi_eg(i)(j)(eg_tmp(i)(j).phi'length-1 downto 0) <= eg_tmp(i)(j).phi;
            iso_eg(i)(j)(eg_tmp(i)(j).iso'length-1 downto 0) <= eg_tmp(i)(j).iso;
        end generate eg_l;
        jet_l: for j in 0 to JET_ARRAY_LENGTH-1 generate
            pt_jet(i)(j)(jet_tmp(i)(j).pt'length-1 downto 0) <= jet_tmp(i)(j).pt;
            eta_jet(i)(j)(jet_tmp(i)(j).eta'length-1 downto 0) <= jet_tmp(i)(j).eta;
            phi_jet(i)(j)(jet_tmp(i)(j).phi'length-1 downto 0) <= jet_tmp(i)(j).phi;
        end generate jet_l;
        tau_l: for j in 0 to TAU_ARRAY_LENGTH-1 generate
            pt_tau(i)(j)(tau_tmp(i)(j).pt'length-1 downto 0) <= tau_tmp(i)(j).pt;
            eta_tau(i)(j)(tau_tmp(i)(j).eta'length-1 downto 0) <= tau_tmp(i)(j).eta;
            phi_tau(i)(j)(tau_tmp(i)(j).phi'length-1 downto 0) <= tau_tmp(i)(j).phi;
            iso_tau(i)(j)(tau_tmp(i)(j).iso'length-1 downto 0) <= tau_tmp(i)(j).iso;
        end generate tau_l;
        
        pt_ett(i)(0)(ett_tmp(i).pt'length-1 downto 0) <= ett_tmp(i).pt;
        
        pt_ettem(i)(0)(ettem_tmp(i).pt'length-1 downto 0) <= ettem_tmp(i).pt;
        
        pt_etm(i)(0)(etm_tmp(i).pt'length-1 downto 0) <= etm_tmp(i).pt;
        phi_etm(i)(0)(etm_tmp(i).phi'length-1 downto 0) <= etm_tmp(i).phi;
        
        pt_htt(i)(0)(htt_tmp(i).pt'length-1 downto 0) <= htt_tmp(i).pt;
        
        pt_htm(i)(0)(htm_tmp(i).pt'length-1 downto 0) <= htm_tmp(i).pt;
        phi_htm(i)(0)(htm_tmp(i).phi'length-1 downto 0) <= htm_tmp(i).phi;
        
        pt_etmhf(i)(0)(etmhf_tmp(i).pt'length-1 downto 0) <= etmhf_tmp(i).pt;
        phi_etmhf(i)(0)(etmhf_tmp(i).phi'length-1 downto 0) <= etmhf_tmp(i).phi;
        
        pt_htmhf(i)(0)(htmhf_tmp(i).pt'length-1 downto 0) <= htmhf_tmp(i).pt;
        phi_htmhf(i)(0)(htmhf_tmp(i).phi'length-1 downto 0) <= htmhf_tmp(i).phi;
        
        count_towercount(i)(0)(towercount_tmp(i).count'length-1 downto 0) <= towercount_tmp(i).count;
        
        count_mbt1hfp(i)(0)(mbt1hfp_tmp(i).count'length-1 downto 0) <= mbt1hfp_tmp(i).count;
        count_mbt1hfm(i)(0)(mbt1hfm_tmp(i).count'length-1 downto 0) <= mbt1hfm_tmp(i).count;
        count_mbt0hfp(i)(0)(mbt0hfp_tmp(i).count'length-1 downto 0) <= mbt0hfp_tmp(i).count;
        count_mbt0hfm(i)(0)(mbt0hfm_tmp(i).count'length-1 downto 0) <= mbt0hfm_tmp(i).count;
        
        count_asymet(i)(0)(asymet_tmp(i).count'length-1 downto 0) <= asymet_tmp(i).count;
        count_asymht(i)(0)(asymht_tmp(i).count'length-1 downto 0) <= asymht_tmp(i).count;
        count_asymethf(i)(0)(asymethf_tmp(i).count'length-1 downto 0) <= asymethf_tmp(i).count;
        count_asymhthf(i)(0)(asymhthf_tmp(i).count'length-1 downto 0) <= asymhthf_tmp(i).count;
        
-- Additional delay for centrality and ext_cond (no comparators and conditions)

        centrality_pipe_i: entity work.delay_pipeline
            generic map(
                DATA_WIDTH => NR_CENTRALITY_BITS,
                STAGES => CENTRALITY_STAGES
            )
            port map(
                clk, centrality_tmp(i), centrality(i)
            );
            
        ext_cond_pipe_i: entity work.delay_pipeline
            generic map(
                DATA_WIDTH => EXTERNAL_CONDITIONS_DATA_WIDTH,
                STAGES => EXT_COND_STAGES
            )
            port map(
                clk, ext_cond_tmp(i), ext_cond(i)
            );

    end generate bx_l;

end architecture rtl;
