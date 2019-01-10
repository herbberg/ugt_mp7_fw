
-- Version-history: 

library ieee;
use ieee.std_logic_1164.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;

entity bx_pipeline is
    port(
        clk : in std_logic;
        data : in gtl_data_record;
        muon_bx, eg_bx, jet_bx, tau_bx : out array_obj_bx_record := (others => (others => (others => (others => '0'))));
        ett_bx, etm_bx, htt_bx, htm_bx, ettem_bx, etmhf_bx, htmhf_bx : out array_obj_bx_record := (others => (others => (others => (others => '0'))));
        towercount_bx : out array_obj_bx_record := (others => (others => (others => (others => '0'))));
        mbt1hfp_bx, mbt1hfm_bx, mbt0hfp_bx, mbt0hfm_bx : out array_obj_bx_record := (others => (others => (others => (others => '0'))));
        asymet_bx, asymht_bx, asymethf_bx, asymhthf_bx : out array_obj_bx_record := (others => (others => (others => (others => '0'))));
        centrality : out centrality_array := (others => (others => '0'));
        ext_cond : out ext_cond_array := (others => (others => '0'))
    );
end bx_pipeline;

architecture rtl of bx_pipeline is

    type array_gtl_data_record is array (0 to BX_PIPELINE_STAGES-1) of gtl_data_record;       
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
            muon_bx(i).pt(j)(data_tmp(i).muon_data(j).pt'length-1 downto 0) <= data_tmp(i).muon_data(j).pt;
            muon_bx(i).eta(j)(data_tmp(i).muon_data(j).eta'length-1 downto 0) <= data_tmp(i).muon_data(j).eta;
            muon_bx(i).phi(j)(data_tmp(i).muon_data(j).phi'length-1 downto 0) <= data_tmp(i).muon_data(j).phi;
            muon_bx(i).iso(j)(data_tmp(i).muon_data(j).iso'length-1 downto 0) <= data_tmp(i).muon_data(j).iso;
            muon_bx(i).qual(j)(data_tmp(i).muon_data(j).qual'length-1 downto 0) <= data_tmp(i).muon_data(j).qual;
            muon_bx(i).charge(j)(data_tmp(i).muon_data(j).charge'length-1 downto 0) <= data_tmp(i).muon_data(j).charge;
        end generate muon_l;
        eg_l: for j in 0 to EG_ARRAY_LENGTH-1 generate            
            eg_bx(i).pt(j)(data_tmp(i).eg_data(j).pt'length-1 downto 0) <= data_tmp(i).eg_data(j).pt;
            eg_bx(i).eta(j)(data_tmp(i).eg_data(j).eta'length-1 downto 0) <= data_tmp(i).eg_data(j).eta;
            eg_bx(i).phi(j)(data_tmp(i).eg_data(j).phi'length-1 downto 0) <= data_tmp(i).eg_data(j).phi;
            eg_bx(i).iso(j)(data_tmp(i).eg_data(j).iso'length-1 downto 0) <= data_tmp(i).eg_data(j).iso;
        end generate eg_l;
        jet_l: for j in 0 to JET_ARRAY_LENGTH-1 generate
            jet_bx(i).pt(j)(data_tmp(i).jet_data(j).pt'length-1 downto 0) <= data_tmp(i).jet_data(j).pt;
            jet_bx(i).eta(j)(data_tmp(i).jet_data(j).eta'length-1 downto 0) <= data_tmp(i).jet_data(j).eta;
            jet_bx(i).phi(j)(data_tmp(i).jet_data(j).phi'length-1 downto 0) <= data_tmp(i).jet_data(j).phi;
        end generate jet_l;
        tau_l: for j in 0 to TAU_ARRAY_LENGTH-1 generate
            tau_bx(i).pt(j)(data_tmp(i).tau_data(j).pt'length-1 downto 0) <= data_tmp(i).tau_data(j).pt;
            tau_bx(i).eta(j)(data_tmp(i).tau_data(j).eta'length-1 downto 0) <= data_tmp(i).tau_data(j).eta;
            tau_bx(i).phi(j)(data_tmp(i).tau_data(j).phi'length-1 downto 0) <= data_tmp(i).tau_data(j).phi;
            tau_bx(i).iso(j)(data_tmp(i).tau_data(j).iso'length-1 downto 0) <= data_tmp(i).tau_data(j).iso;
        end generate tau_l;
        
        ett_bx(i).pt(0)(data_tmp(i).ett_data.pt'length-1 downto 0) <= data_tmp(i).ett_data.pt;
        
        ettem_bx(i).pt(0)(data_tmp(i).ettem_data.pt'length-1 downto 0) <= data_tmp(i).ettem_data.pt;
        
        etm_bx(i).pt(0)(data_tmp(i).etm_data.pt'length-1 downto 0) <= data_tmp(i).etm_data.pt;
        etm_bx(i).phi(0)(data_tmp(i).etm_data.phi'length-1 downto 0) <= data_tmp(i).etm_data.phi;
        
        htt_bx(i).pt(0)(data_tmp(i).htt_data.pt'length-1 downto 0) <= data_tmp(i).htt_data.pt;
        
        htm_bx(i).pt(0)(data_tmp(i).htm_data.pt'length-1 downto 0) <= data_tmp(i).htm_data.pt;
        htm_bx(i).phi(0)(data_tmp(i).htm_data.phi'length-1 downto 0) <= data_tmp(i).htm_data.phi;
        
        etmhf_bx(i).pt(0)(data_tmp(i).etmhf_data.pt'length-1 downto 0) <= data_tmp(i).etmhf_data.pt;
        etmhf_bx(i).phi(0)(data_tmp(i).etmhf_data.phi'length-1 downto 0) <= data_tmp(i).etmhf_data.phi;
        
        htmhf_bx(i).pt(0)(data_tmp(i).htmhf_data.pt'length-1 downto 0) <= data_tmp(i).htmhf_data.pt;
        htmhf_bx(i).phi(0)(data_tmp(i).htmhf_data.phi'length-1 downto 0) <= data_tmp(i).htmhf_data.phi;
        
        towercount_bx(i).count(0)(data_tmp(i).towercount_data.count'length-1 downto 0) <= data_tmp(i).towercount_data.count;
        
        mbt1hfp_bx(i).count(0)(data_tmp(i).mbt1hfp_data.count'length-1 downto 0) <= data_tmp(i).mbt1hfp_data.count;
        mbt1hfm_bx(i).count(0)(data_tmp(i).mbt1hfm_data.count'length-1 downto 0) <= data_tmp(i).mbt1hfm_data.count;
        mbt0hfp_bx(i).count(0)(data_tmp(i).mbt0hfp_data.count'length-1 downto 0) <= data_tmp(i).mbt0hfp_data.count;
        mbt0hfm_bx(i).count(0)(data_tmp(i).mbt0hfm_data.count'length-1 downto 0) <= data_tmp(i).mbt0hfm_data.count;
        
        asymet_bx(i).count(0)(data_tmp(i).asymet_data.count'length-1 downto 0) <= data_tmp(i).asymet_data.count;
        asymht_bx(i).count(0)(data_tmp(i).asymht_data.count'length-1 downto 0) <= data_tmp(i).asymht_data.count;
        asymethf_bx(i).count(0)(data_tmp(i).asymethf_data.count'length-1 downto 0) <= data_tmp(i).asymethf_data.count;
        asymhthf_bx(i).count(0)(data_tmp(i).asymhthf_data.count'length-1 downto 0) <= data_tmp(i).asymhthf_data.count;
        
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
