
-- Version-history: 

library ieee;
use ieee.std_logic_1164.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;

entity bx_pipeline is
    port(
        clk : in std_logic;
        data : in gtl_data_record;
        muon_bx_p2: out muon_objects_array(0 to MUON_ARRAY_LENGTH-1);
        muon_bx_p1: out muon_objects_array(0 to MUON_ARRAY_LENGTH-1);
        muon_bx_0 : out muon_objects_array(0 to MUON_ARRAY_LENGTH-1);
        muon_bx_m1: out muon_objects_array(0 to MUON_ARRAY_LENGTH-1);
        muon_bx_m2: out muon_objects_array(0 to MUON_ARRAY_LENGTH-1);
        eg_bx_p2 : out calo_objects_array(0 to EG_ARRAY_LENGTH-1);
        eg_bx_p1 : out calo_objects_array(0 to EG_ARRAY_LENGTH-1);
        eg_bx_0 : out calo_objects_array(0 to EG_ARRAY_LENGTH-1);
        eg_bx_m1 : out calo_objects_array(0 to EG_ARRAY_LENGTH-1);
        eg_bx_m2 : out calo_objects_array(0 to EG_ARRAY_LENGTH-1);
        jet_bx_p2 : out calo_objects_array(0 to JET_ARRAY_LENGTH-1);
        jet_bx_p1 : out calo_objects_array(0 to JET_ARRAY_LENGTH-1);
        jet_bx_0 : out calo_objects_array(0 to JET_ARRAY_LENGTH-1);
        jet_bx_m1 : out calo_objects_array(0 to JET_ARRAY_LENGTH-1);
        jet_bx_m2 : out calo_objects_array(0 to JET_ARRAY_LENGTH-1);
        tau_bx_p2 : out calo_objects_array(0 to TAU_ARRAY_LENGTH-1);
        tau_bx_p1 : out calo_objects_array(0 to TAU_ARRAY_LENGTH-1);
        tau_bx_0 : out calo_objects_array(0 to TAU_ARRAY_LENGTH-1);
        tau_bx_m1 : out calo_objects_array(0 to TAU_ARRAY_LENGTH-1);
        tau_bx_m2 : out calo_objects_array(0 to TAU_ARRAY_LENGTH-1);
        ett_bx_p2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ett_bx_p1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ett_bx_0 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ett_bx_m1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ett_bx_m2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ht_bx_p2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ht_bx_p1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ht_bx_0 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ht_bx_m1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ht_bx_m2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etm_bx_p2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etm_bx_p1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etm_bx_0 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etm_bx_m1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etm_bx_m2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htm_bx_p2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htm_bx_p1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htm_bx_0 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htm_bx_m1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htm_bx_m2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt1hfp_bx_p2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt1hfp_bx_p1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt1hfp_bx_0 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt1hfp_bx_m1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt1hfp_bx_m2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt1hfm_bx_p2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt1hfm_bx_p1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt1hfm_bx_0 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt1hfm_bx_m1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt1hfm_bx_m2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt0hfp_bx_p2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt0hfp_bx_p1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt0hfp_bx_0 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt0hfp_bx_m1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt0hfp_bx_m2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt0hfm_bx_p2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt0hfm_bx_p1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt0hfm_bx_0 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt0hfm_bx_m1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        mbt0hfm_bx_m2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ettem_bx_p2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ettem_bx_p1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ettem_bx_0 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ettem_bx_m1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        ettem_bx_m2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etmhf_bx_p2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etmhf_bx_p1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etmhf_bx_0 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etmhf_bx_m1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        etmhf_bx_m2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htmhf_bx_p2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htmhf_bx_p1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htmhf_bx_0 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htmhf_bx_m1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        htmhf_bx_m2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        towercount_bx_p2 : out std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
        towercount_bx_p1 : out std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
        towercount_bx_0 : out std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
        towercount_bx_m1 : out std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
        towercount_bx_m2 : out std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0);
        asymet_bx_p2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymet_bx_p1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymet_bx_0 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymet_bx_m1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymet_bx_m2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymht_bx_p2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymht_bx_p1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymht_bx_0 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymht_bx_m1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymht_bx_m2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymethf_bx_p2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymethf_bx_p1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymethf_bx_0 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymethf_bx_m1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymethf_bx_m2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymhthf_bx_p2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymhthf_bx_p1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymhthf_bx_0 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymhthf_bx_m1 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        asymhthf_bx_m2 : out std_logic_vector(MAX_ESUMS_BITS-1 downto 0);
        centrality_bx_p2 : out std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
        centrality_bx_p1 : out std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
        centrality_bx_0 : out std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
        centrality_bx_m1 : out std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
        centrality_bx_m2 : out std_logic_vector(NR_CENTRALITY_BITS-1 downto 0);
        ext_cond_bx_p2 : out std_logic_vector(EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto 0);
        ext_cond_bx_p1 : out std_logic_vector(EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto 0);
        ext_cond_bx_0 : out std_logic_vector(EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto 0);
        ext_cond_bx_m1 : out std_logic_vector(EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto 0);
        ext_cond_bx_m2 : out std_logic_vector(EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto 0)
    );
end bx_pipeline;

architecture rtl of bx_pipeline is

    signal eg_bx_p1_tmp, eg_bx_0_tmp, eg_bx_m1_tmp, eg_bx_m2_tmp : calo_objects_array(0 to EG_ARRAY_LENGTH-1) := (others => (others => '0'));
    signal jet_bx_p1_tmp, jet_bx_0_tmp, jet_bx_m1_tmp, jet_bx_m2_tmp : calo_objects_array(0 to JET_ARRAY_LENGTH-1) := (others => (others => '0'));
    signal tau_bx_p1_tmp, tau_bx_0_tmp, tau_bx_m1_tmp, tau_bx_m2_tmp : calo_objects_array(0 to TAU_ARRAY_LENGTH-1) := (others => (others => '0'));
    signal muon_bx_p1_tmp, muon_bx_0_tmp, muon_bx_m1_tmp, muon_bx_m2_tmp : muon_objects_array(0 to MUON_ARRAY_LENGTH-1) := (others => (others => '0'));
    signal ett_bx_p1_tmp, ett_bx_0_tmp, ett_bx_m1_tmp, ett_bx_m2_tmp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal ht_bx_p1_tmp, ht_bx_0_tmp, ht_bx_m1_tmp, ht_bx_m2_tmp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal etm_bx_p1_tmp, etm_bx_0_tmp, etm_bx_m1_tmp, etm_bx_m2_tmp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal htm_bx_p1_tmp, htm_bx_0_tmp, htm_bx_m1_tmp, htm_bx_m2_tmp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
-- ****************************************************************************************
-- HB 2016-04-18: updates for "min bias trigger" objects (quantities) for Low-pileup-run May 2016
    signal mbt1hfp_bx_p1_tmp, mbt1hfp_bx_0_tmp, mbt1hfp_bx_m1_tmp, mbt1hfp_bx_m2_tmp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal mbt1hfm_bx_p1_tmp, mbt1hfm_bx_0_tmp, mbt1hfm_bx_m1_tmp, mbt1hfm_bx_m2_tmp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal mbt0hfp_bx_p1_tmp, mbt0hfp_bx_0_tmp, mbt0hfp_bx_m1_tmp, mbt0hfp_bx_m2_tmp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal mbt0hfm_bx_p1_tmp, mbt0hfm_bx_0_tmp, mbt0hfm_bx_m1_tmp, mbt0hfm_bx_m2_tmp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
-- HB 2016-06-07: inserted new esums quantities (ETTEM and ETMHF).
    signal ettem_bx_p1_tmp, ettem_bx_0_tmp, ettem_bx_m1_tmp, ettem_bx_m2_tmp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal etmhf_bx_p1_tmp, etmhf_bx_0_tmp, etmhf_bx_m1_tmp, etmhf_bx_m2_tmp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
-- HB 2016-09-16: inserted HTMHF and TOWERCNT
    signal htmhf_bx_p1_tmp, htmhf_bx_0_tmp, htmhf_bx_m1_tmp, htmhf_bx_m2_tmp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal towercount_bx_p1_tmp, towercount_bx_0_tmp, towercount_bx_m1_tmp, towercount_bx_m2_tmp : std_logic_vector(MAX_TOWERCOUNT_BITS-1 downto 0) := (others => '0');
-- HB 2018-08-06: inserted "Asymmetry" and "Centrality"
    signal asymet_bx_p1_tmp, asymet_bx_0_tmp, asymet_bx_m1_tmp, asymet_bx_m2_tmp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal asymht_bx_p1_tmp, asymht_bx_0_tmp, asymht_bx_m1_tmp, asymht_bx_m2_tmp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal asymethf_bx_p1_tmp, asymethf_bx_0_tmp, asymethf_bx_m1_tmp, asymethf_bx_m2_tmp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal asymhthf_bx_p1_tmp, asymhthf_bx_0_tmp, asymhthf_bx_m1_tmp, asymhthf_bx_m2_tmp : std_logic_vector(MAX_ESUMS_BITS-1 downto 0) := (others => '0');
    signal centrality_bx_p1_tmp, centrality_bx_0_tmp, centrality_bx_m1_tmp, centrality_bx_m2_tmp : std_logic_vector(NR_CENTRALITY_BITS-1 downto 0) := (others => '0');
-- ****************************************************************************************
    signal ext_cond_bx_p1_tmp, ext_cond_bx_0_tmp, ext_cond_bx_m1_tmp, ext_cond_bx_m2_tmp : std_logic_vector(EXTERNAL_CONDITIONS_DATA_WIDTH-1 downto 0) := (others => '0');

begin

process(clk, data.eg_data, data.jet_data, data.tau_data, data.muon_data, data.ett_data, data.ht_data, data.etm_data, data.htm_data, data.ettem_data, data.etmhf_data,       data.htmhf_data, data.towercount_data, data.external_conditions, data.mbt1hfp_data, data.mbt1hfm_data, data.mbt0hfp_data, data.mbt0hfm_data, data.asymet_data, data.asymht_data, data.asymethf_data, data.asymhthf_data, data.centrality_data)
begin
    if (clk'event and clk = '1') then
        muon_bx_p1_tmp <= data.muon_data;
        muon_bx_0_tmp <= muon_bx_p1_tmp;
        muon_bx_m1_tmp <= muon_bx_0_tmp;
        muon_bx_m2_tmp <= muon_bx_m1_tmp;

        eg_bx_p1_tmp <= data.eg_data;
        eg_bx_0_tmp <= eg_bx_p1_tmp;
        eg_bx_m1_tmp <= eg_bx_0_tmp;
        eg_bx_m2_tmp <= eg_bx_m1_tmp;

        jet_bx_p1_tmp <= data.jet_data;
        jet_bx_0_tmp <= jet_bx_p1_tmp;
        jet_bx_m1_tmp <= jet_bx_0_tmp;
        jet_bx_m2_tmp <= jet_bx_m1_tmp;

        tau_bx_p1_tmp <= data.tau_data;
        tau_bx_0_tmp <= tau_bx_p1_tmp;
        tau_bx_m1_tmp <= tau_bx_0_tmp;
        tau_bx_m2_tmp <= tau_bx_m1_tmp;

        ett_bx_p1_tmp <= data.ett_data;
        ett_bx_0_tmp <= ett_bx_p1_tmp;
        ett_bx_m1_tmp <= ett_bx_0_tmp;
        ett_bx_m2_tmp <= ett_bx_m1_tmp;

        ht_bx_p1_tmp <= data.ht_data;
        ht_bx_0_tmp <= ht_bx_p1_tmp;
        ht_bx_m1_tmp <= ht_bx_0_tmp;
        ht_bx_m2_tmp <= ht_bx_m1_tmp;

        etm_bx_p1_tmp <= data.etm_data;
        etm_bx_0_tmp <= etm_bx_p1_tmp;
        etm_bx_m1_tmp <= etm_bx_0_tmp;
        etm_bx_m2_tmp <= etm_bx_m1_tmp;

        htm_bx_p1_tmp <= data.htm_data;
        htm_bx_0_tmp <= htm_bx_p1_tmp;
        htm_bx_m1_tmp <= htm_bx_0_tmp;
        htm_bx_m2_tmp <= htm_bx_m1_tmp;

        mbt1hfp_bx_p1_tmp <= data.mbt1hfp_data;
        mbt1hfp_bx_0_tmp <= mbt1hfp_bx_p1_tmp;
        mbt1hfp_bx_m1_tmp <= mbt1hfp_bx_0_tmp;
        mbt1hfp_bx_m2_tmp <= mbt1hfp_bx_m1_tmp;

        mbt1hfm_bx_p1_tmp <= data.mbt1hfm_data;
        mbt1hfm_bx_0_tmp <= mbt1hfm_bx_p1_tmp;
        mbt1hfm_bx_m1_tmp <= mbt1hfm_bx_0_tmp;
        mbt1hfm_bx_m2_tmp <= mbt1hfm_bx_m1_tmp;

        mbt0hfp_bx_p1_tmp <= data.mbt0hfp_data;
        mbt0hfp_bx_0_tmp <= mbt0hfp_bx_p1_tmp;
        mbt0hfp_bx_m1_tmp <= mbt0hfp_bx_0_tmp;
        mbt0hfp_bx_m2_tmp <= mbt0hfp_bx_m1_tmp;

        mbt0hfm_bx_p1_tmp <= data.mbt0hfm_data;
        mbt0hfm_bx_0_tmp <= mbt0hfm_bx_p1_tmp;
        mbt0hfm_bx_m1_tmp <= mbt0hfm_bx_0_tmp;
        mbt0hfm_bx_m2_tmp <= mbt0hfm_bx_m1_tmp;

        ettem_bx_p1_tmp <= data.ettem_data;
        ettem_bx_0_tmp <= ettem_bx_p1_tmp;
        ettem_bx_m1_tmp <= ettem_bx_0_tmp;
        ettem_bx_m2_tmp <= ettem_bx_m1_tmp;

        etmhf_bx_p1_tmp <= data.etmhf_data;
        etmhf_bx_0_tmp <= etmhf_bx_p1_tmp;
        etmhf_bx_m1_tmp <= etmhf_bx_0_tmp;
        etmhf_bx_m2_tmp <= etmhf_bx_m1_tmp;

        htmhf_bx_p1_tmp <= data.htmhf_data;
        htmhf_bx_0_tmp <= htmhf_bx_p1_tmp;
        htmhf_bx_m1_tmp <= htmhf_bx_0_tmp;
        htmhf_bx_m2_tmp <= htmhf_bx_m1_tmp;

        towercount_bx_p1_tmp <= data.towercount_data;
        towercount_bx_0_tmp <= towercount_bx_p1_tmp;
        towercount_bx_m1_tmp <= towercount_bx_0_tmp;
        towercount_bx_m2_tmp <= towercount_bx_m1_tmp;

        ext_cond_bx_p1_tmp <= data.external_conditions;
        ext_cond_bx_0_tmp <= ext_cond_bx_p1_tmp;
        ext_cond_bx_m1_tmp <= ext_cond_bx_0_tmp;
        ext_cond_bx_m2_tmp <= ext_cond_bx_m1_tmp;

        asymet_bx_p1_tmp <= data.asymet_data;
        asymet_bx_0_tmp <= asymet_bx_p1_tmp;
        asymet_bx_m1_tmp <= asymet_bx_0_tmp;
        asymet_bx_m2_tmp <= asymet_bx_m1_tmp;

        asymht_bx_p1_tmp <= data.asymht_data;
        asymht_bx_0_tmp <= asymht_bx_p1_tmp;
        asymht_bx_m1_tmp <= asymht_bx_0_tmp;
        asymht_bx_m2_tmp <= asymht_bx_m1_tmp;

        asymethf_bx_p1_tmp <= data.asymethf_data;
        asymethf_bx_0_tmp <= asymethf_bx_p1_tmp;
        asymethf_bx_m1_tmp <= asymethf_bx_0_tmp;
        asymethf_bx_m2_tmp <= asymethf_bx_m1_tmp;

        asymhthf_bx_p1_tmp <= data.asymhthf_data;
        asymhthf_bx_0_tmp <= asymhthf_bx_p1_tmp;
        asymhthf_bx_m1_tmp <= asymhthf_bx_0_tmp;
        asymhthf_bx_m2_tmp <= asymhthf_bx_m1_tmp;

        centrality_bx_p1_tmp <= data.centrality_data;
        centrality_bx_0_tmp <= centrality_bx_p1_tmp;
        centrality_bx_m1_tmp <= centrality_bx_0_tmp;
        centrality_bx_m2_tmp <= centrality_bx_m1_tmp;

    end if;
end process;

    muon_bx_p2 <= data.muon_data;
    muon_bx_p1 <= muon_bx_p1_tmp;
    muon_bx_0 <= muon_bx_0_tmp;
    muon_bx_m1 <= muon_bx_m1_tmp;
    muon_bx_m2 <= muon_bx_m2_tmp;

    eg_bx_p2 <= data.eg_data;
    eg_bx_p1 <= eg_bx_p1_tmp;
    eg_bx_0 <= eg_bx_0_tmp;
    eg_bx_m1 <= eg_bx_m1_tmp;
    eg_bx_m2 <= eg_bx_m2_tmp;

    jet_bx_p2 <= data.jet_data;
    jet_bx_p1 <= jet_bx_p1_tmp;
    jet_bx_0 <= jet_bx_0_tmp;
    jet_bx_m1 <= jet_bx_m1_tmp;
    jet_bx_m2 <= jet_bx_m2_tmp;

    tau_bx_p2 <= data.tau_data;
    tau_bx_p1 <= tau_bx_p1_tmp;
    tau_bx_0 <= tau_bx_0_tmp;
    tau_bx_m1 <= tau_bx_m1_tmp;
    tau_bx_m2 <= tau_bx_m2_tmp;

    ett_bx_p2 <= data.ett_data;
    ett_bx_p1 <= ett_bx_p1_tmp;
    ett_bx_0 <= ett_bx_0_tmp;
    ett_bx_m1 <= ett_bx_m1_tmp;
    ett_bx_m2 <= ett_bx_m2_tmp;

    ht_bx_p2 <= data.ht_data;
    ht_bx_p1 <= ht_bx_p1_tmp;
    ht_bx_0 <= ht_bx_0_tmp;
    ht_bx_m1 <= ht_bx_m1_tmp;
    ht_bx_m2 <= ht_bx_m2_tmp;

    etm_bx_p2 <= data.etm_data;
    etm_bx_p1 <= etm_bx_p1_tmp;
    etm_bx_0 <= etm_bx_0_tmp;
    etm_bx_m1 <= etm_bx_m1_tmp;
    etm_bx_m2 <= etm_bx_m2_tmp;

    htm_bx_p2 <= data.htm_data;
    htm_bx_p1 <= htm_bx_p1_tmp;
    htm_bx_0 <= htm_bx_0_tmp;
    htm_bx_m1 <= htm_bx_m1_tmp;
    htm_bx_m2 <= htm_bx_m2_tmp;

    mbt1hfp_bx_p2 <= data.mbt1hfp_data;
    mbt1hfp_bx_p1 <= mbt1hfp_bx_p1_tmp;
    mbt1hfp_bx_0 <= mbt1hfp_bx_0_tmp;
    mbt1hfp_bx_m1 <= mbt1hfp_bx_m1_tmp;
    mbt1hfp_bx_m2 <= mbt1hfp_bx_m2_tmp;

    mbt1hfm_bx_p2 <= data.mbt1hfm_data;
    mbt1hfm_bx_p1 <= mbt1hfm_bx_p1_tmp;
    mbt1hfm_bx_0 <= mbt1hfm_bx_0_tmp;
    mbt1hfm_bx_m1 <= mbt1hfm_bx_m1_tmp;
    mbt1hfm_bx_m2 <= mbt1hfm_bx_m2_tmp;

    mbt0hfp_bx_p2 <= data.mbt0hfp_data;
    mbt0hfp_bx_p1 <= mbt0hfp_bx_p1_tmp;
    mbt0hfp_bx_0 <= mbt0hfp_bx_0_tmp;
    mbt0hfp_bx_m1 <= mbt0hfp_bx_m1_tmp;
    mbt0hfp_bx_m2 <= mbt0hfp_bx_m2_tmp;

    mbt0hfm_bx_p2 <= data.mbt0hfm_data;
    mbt0hfm_bx_p1 <= mbt0hfm_bx_p1_tmp;
    mbt0hfm_bx_0 <= mbt0hfm_bx_0_tmp;
    mbt0hfm_bx_m1 <= mbt0hfm_bx_m1_tmp;
    mbt0hfm_bx_m2 <= mbt0hfm_bx_m2_tmp;

    ettem_bx_p2 <= data.ettem_data;
    ettem_bx_p1 <= ettem_bx_p1_tmp;
    ettem_bx_0 <= ettem_bx_0_tmp;
    ettem_bx_m1 <= ettem_bx_m1_tmp;
    ettem_bx_m2 <= ettem_bx_m2_tmp;

    etmhf_bx_p2 <= data.etmhf_data;
    etmhf_bx_p1 <= etmhf_bx_p1_tmp;
    etmhf_bx_0 <= etmhf_bx_0_tmp;
    etmhf_bx_m1 <= etmhf_bx_m1_tmp;
    etmhf_bx_m2 <= etmhf_bx_m2_tmp;

    htmhf_bx_p2 <= data.htmhf_data;
    htmhf_bx_p1 <= htmhf_bx_p1_tmp;
    htmhf_bx_0 <= htmhf_bx_0_tmp;
    htmhf_bx_m1 <= htmhf_bx_m1_tmp;
    htmhf_bx_m2 <= htmhf_bx_m2_tmp;

    towercount_bx_p2 <= data.towercount_data;
    towercount_bx_p1 <= towercount_bx_p1_tmp;
    towercount_bx_0 <= towercount_bx_0_tmp;
    towercount_bx_m1 <= towercount_bx_m1_tmp;
    towercount_bx_m2 <= towercount_bx_m2_tmp;

    ext_cond_bx_p2 <= data.external_conditions;
    ext_cond_bx_p1 <= ext_cond_bx_p1_tmp;
    ext_cond_bx_0 <= ext_cond_bx_0_tmp;
    ext_cond_bx_m1 <= ext_cond_bx_m1_tmp;
    ext_cond_bx_m2 <= ext_cond_bx_m2_tmp;

    asymet_bx_p2 <= data.asymet_data;
    asymet_bx_p1 <= asymet_bx_p1_tmp;
    asymet_bx_0 <= asymet_bx_0_tmp;
    asymet_bx_m1 <= asymet_bx_m1_tmp;
    asymet_bx_m2 <= asymet_bx_m2_tmp;

    asymht_bx_p2 <= data.asymht_data;
    asymht_bx_p1 <= asymht_bx_p1_tmp;
    asymht_bx_0 <= asymht_bx_0_tmp;
    asymht_bx_m1 <= asymht_bx_m1_tmp;
    asymht_bx_m2 <= asymht_bx_m2_tmp;

    asymethf_bx_p2 <= data.asymethf_data;
    asymethf_bx_p1 <= asymethf_bx_p1_tmp;
    asymethf_bx_0 <= asymethf_bx_0_tmp;
    asymethf_bx_m1 <= asymethf_bx_m1_tmp;
    asymethf_bx_m2 <= asymethf_bx_m2_tmp;

    asymhthf_bx_p2 <= data.asymhthf_data;
    asymhthf_bx_p1 <= asymhthf_bx_p1_tmp;
    asymhthf_bx_0 <= asymhthf_bx_0_tmp;
    asymhthf_bx_m1 <= asymhthf_bx_m1_tmp;
    asymhthf_bx_m2 <= asymhthf_bx_m2_tmp;

    centrality_bx_p2 <= data.centrality_data;
    centrality_bx_p1 <= centrality_bx_p1_tmp;
    centrality_bx_0 <= centrality_bx_0_tmp;
    centrality_bx_m1 <= centrality_bx_m1_tmp;
    centrality_bx_m2 <= centrality_bx_m2_tmp;

end architecture rtl;
