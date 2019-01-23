
-- Description:

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.ipbus.all;

use work.gtl_pkg.all;

use work.gt_mp7_core_pkg.all;
use work.lhc_data_pkg.all;

entity gt_data is
    generic(
        NR_LANES : positive;
        SIM_MODE : boolean := false -- if SIM_MODE = true, "algo_bx_mask" by default = 1.
    );
    port
    (
        ipb_clk : in std_logic;
        ipb_rst : in std_logic;
        ipb_in : in ipb_wbus;
        ipb_out : out ipb_rbus;
        clk240 : in std_logic;
        lhc_clk : in std_logic;
        lhc_rst : in std_logic;
        lane_data_in : in lword; -- 240MHZ
        lhc_data_2_ctrl : out lhc_data_t;
        bcres : in std_logic;
        test_en : in std_logic;
        l1a : in std_logic;
        start_lumisection : in std_logic;
        prescale_factor_set_index_rop : out std_logic_vector(7 downto 0);
        algo_after_gtLogic_rop : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_bxomask_rop : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        algo_after_prescaler_rop : out std_logic_vector(MAX_NR_ALGOS-1 downto 0);
        local_finor_rop : out std_logic;
        local_veto_rop : out std_logic;
        finor_2_mezz_lemo : out std_logic;
        finor_preview_2_mezz_lemo : out std_logic;
        veto_2_mezz_lemo : out std_logic;
        finor_w_veto_2_mezz_lemo : out std_logic;
        local_finor_with_veto_o : out std_logic
    );
end gt_data;

architecture rtl of gt_data is

  signal lhc_data_2_gtl : lhc_data_t;

begin

-- HB 2019-01-21: "clock domain change" and "line mapping process" of data
  data_cdc_lmp_i: entity work.data_cdc_lmp
    generic map(
        NR_LANES => NR_LANES
    )
    port map(
        clk240 => clk240,
        lhc_clk => lhc_clk,
        data_in => lane_data_in,
        data_o => lhc_data_2_gtl
    );

-- HB 2019-01-21: wrapper for "Global Trigger Logic" and "Final Decision Logic". (Module used for simulation.)
  gtl_fdl_wrapper_i: entity work.gtl_fdl_wrapper
    generic map(
        NR_LANES => NR_LANES, SIM_MODE => SIM_MODE
    )
    port map(
        ipb_clk => ipb_clk,
        ipb_rst => ipb_rst,
        ipb_in  => ipb_in,
        ipb_out => ipb_out,
        lhc_clk => lhc_clk,
        lhc_rst => lhc_rst,
        lhc_data => lhc_data_2_gtl,
        bcres => bcres,
        test_en => test_en,
        l1a => l1a,
        begin_lumi_section => start_lumisection,
        prescale_factor_set_index_rop => prescale_factor_set_index_rop,
        algo_after_gtLogic_rop => algo_after_gtLogic_rop,
        algo_after_bxomask_rop => algo_after_bxomask_rop,
        algo_after_prescaler_rop => algo_after_prescaler_rop,
        local_finor_rop => local_finor_rop,
        local_veto_rop => local_veto_rop,
        finor_2_mezz_lemo => finor_2_mezz_lemo,
        finor_preview_2_mezz_lemo => finor_preview_2_mezz_lemo,
        veto_2_mezz_lemo => veto_2_mezz_lemo,
        finor_w_veto_2_mezz_lemo => finor_w_veto_2_mezz_lemo,
        local_finor_with_veto_o => local_finor_with_veto_o
    );
    
-- HB 2019-01-21: data to gt_control for memories
  lhc_data_2_ctrl <= lhc_data_2_gtl;

end architecture rtl;
