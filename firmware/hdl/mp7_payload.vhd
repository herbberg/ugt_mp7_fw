
-- Description:
-- Payload for Global Trigger of MP7 firmware 
--
-- Version history:
-- HB 2019-01-22: inserted module gt_data - containing "data clock domain change", "lane mapping process" and wrapper for GTL and FDL.
--                Renamed frame.vhd to gt_control.vhd - moved bgo_sync.vhd in gt_control.vhd (removed "data clock domain change" and "lane mapping process").

-- HB 2017-10-06: renamed signal "dsmux_lhc_data" to "lhc_data_2_gtl" (similar to port name of frame).
-- HB 2017-09-13: removed instance tp_mux_i.
-- HB 2016-11-17: inserted port "finor_preview_2_mezz_lemo" for "prescaler preview" in monitoring on gpio(2). No use of tp_mux anymore.
-- HB 2016-10-11: signals finor_2_mezz_lemo and veto_2_mezz_lemo for IOB output FF. Connected directly to gpio without tp_mux.
--                Removed finor_2_mezz_lemo and veto_2_mezz_lemo from tp_mux. Signals local_finor_rop and local_veto_rop used for tp_mux.
-- HB 2016-09-01: added BGo "test-enable" not synchronized (!) occures at bx=~3300 (used to suppress counting algos caused by calibration trigger at bx=3490)
-- HB 2016-04-06: used "algo_after_gtLogic" for read-out-record (changed "algo_before_prescaler" to "algo_after_bxomask") according to fdl_module v0.0.24.
-- HB 2016-02-26: changed inputs of tp_mux.vhd, removed unused signals in frame (v0.0.36) and fdl_module (v0.0.20)
-- HB 2016-02-16: added "l1a" for post dead time counter in fdl_module (v0.0.17)
-- JW 2015-11-04: added bgo sync stage
-- HB 2015-09-16: added "ec0_in", "resync_in" and "oc0_in" from "ctrs" for FDL
-- JW 2015-08-24: modified the core and adapted it for mp7_fw_v1_8_2 usage

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.ipbus.all;
use work.mp7_data_types.all;
use work.lhc_data_pkg.all;
use work.gt_mp7_core_pkg.all;
use work.gt_mp7_core_addr_decode.all;
use work.mp7_brd_decl.all;
use work.mp7_ttc_decl.all;
use work.top_decl.all;

entity mp7_payload is
    port(
        clk : in std_logic; -- ipbus signals
        rst : in std_logic;
        ipb_in : in ipb_wbus;
        ipb_out : out ipb_rbus;
        clk_payload  : in  std_logic_vector(2 downto 0);
        rst_payload  : in  std_logic_vector(2 downto 0);
        clk_p : in std_logic; -- data clock
        rst_loc : in std_logic_vector(N_REGION - 1 downto 0);
        clken_loc : in std_logic_vector(N_REGION - 1 downto 0);
        ctrs : in ttc_stuff_array;
        l1a : in std_logic; -- L1A input from mp7_ttc
        bc0 : out std_logic;
        d : in ldata(4 * N_REGION - 1 downto 0); -- data in
        q : out ldata(4 * N_REGION - 1 downto 0); -- data out
        gpio : out std_logic_vector(29 downto 0); -- IO to mezzanine connector
        gpio_en : out std_logic_vector(29 downto 0) -- IO to mezzanine connector (three-state enables)
    );
end mp7_payload;

architecture rtl of mp7_payload is

    signal ipb_clk : std_logic;
    signal ipb_rst : std_logic;
    signal ipb_to_slaves : ipb_wbus_array(NR_IPB_SLV_GT_MP7_CORE-1 downto 0);
    signal ipb_from_slaves : ipb_rbus_array(NR_IPB_SLV_GT_MP7_CORE-1 downto 0);

    signal lhc_rst : std_logic;
    signal lhc_clk : std_logic;
    signal clk240 : std_logic;
    signal test_en_int : std_logic;
    signal bcres_d : std_logic;
    signal bcres_d_FDL : std_logic;
    signal start_lumisection : std_logic;

    signal lane_data_in : ldata(4 * N_REGION - 1 downto 0);
    signal lane_data_out : ldata(4 * N_REGION - 1 downto 0);
    signal lhc_data_2_ctrl : lhc_data_t;

    signal prescale_factor_set_index_rop : std_logic_vector(7 downto 0);
    signal algo_after_gtLogic_rop : std_logic_vector(MAX_NR_ALGOS-1 downto 0);
    signal algo_after_bxomask_rop : std_logic_vector(MAX_NR_ALGOS-1 downto 0);
    signal algo_after_prescaler_rop : std_logic_vector(MAX_NR_ALGOS-1 downto 0);
    signal local_finor_rop : std_logic;
    signal local_veto_rop : std_logic;
    signal local_finor_with_veto_o  : std_logic;
    signal finor_2_mezz_lemo : std_logic;
    signal finor_preview_2_mezz_lemo : std_logic;
    signal veto_2_mezz_lemo : std_logic;
    signal finor_w_veto_2_mezz_lemo : std_logic;

    signal bx_nr_fdl : std_logic_vector(11 downto 0);
    signal algo_bx_mask_mem_fdl : std_logic_vector(MAX_NR_ALGOS-1 downto 0);

begin

    ipb_clk <= clk;
    ipb_rst <= rst;
    clk240 <= clk_p;
    lhc_clk <= clk_payload(0);

    lane_data_in <= d; -- from mp7_datapath
    q <= lane_data_out; -- to mp7_datapath

    fabric_i: entity work.ipbus_fabric_sel
    generic map(
        NSLV => NR_IPB_SLV_GT_MP7_CORE,
        SEL_WIDTH => IPBUS_SEL_WIDTH)
    port map(
      ipb_in => ipb_in,
      ipb_out => ipb_out,
      sel => ipbus_sel_mp7_payload(ipb_in.ipb_addr),
      ipb_to_slaves => ipb_to_slaves,
      ipb_from_slaves => ipb_from_slaves
    );

-- HB 2019-01-21: renamed frame.vhd to gt_control.vhd and moved bgo_sync.vhd into gt_control.vhd
    gt_control_i: entity work.gt_control
    generic map(
        NR_LANES => (4 * N_REGION)
    )
    port map(
        ipb_clk => ipb_clk,
        ipb_rst => ipb_rst,
        ipb_in => ipb_to_slaves(C_IPB_GT_MP7_FRAME),
        ipb_out => ipb_from_slaves(C_IPB_GT_MP7_FRAME),
        ctrs => ctrs,
        clk240 => clk240,
        lhc_clk => lhc_clk,
        rst_payload => rst_payload(0),
        lhc_rst_o => lhc_rst,
        ttc_in => ctrs(4).ttc_cmd,
        bc0_out => bc0,
        l1a => l1a,
        bcres_d => bcres_d,
        bcres_d_FDL => bcres_d_FDL,
        test_en_out => test_en_int,
        start_lumisection  => start_lumisection,
        lhc_data_i => lhc_data_2_ctrl,
        lane_data_out => lane_data_out,
        bx_nr_fdl => bx_nr_fdl,
        algo_bx_mask_mem_out => algo_bx_mask_mem_fdl,
        prescale_factor_set_index_rop => prescale_factor_set_index_rop,
        algo_after_gtLogic_rop => algo_after_gtLogic_rop,
        algo_after_bxomask_rop => algo_after_bxomask_rop,
        algo_after_prescaler_rop => algo_after_prescaler_rop,
        local_finor_rop => local_finor_rop,
        local_veto_rop => local_veto_rop, -- HB 2014-10-22: added for ROP
        finor_rop => '0', -- HB 2014-10-30: no total_finor to ROP
        local_finor_with_veto_2_spy2 => local_finor_with_veto_o -- HB 2014-10-30: to SPY2_FINOR
    );

-- HB 2019-01-21: "Global Trigger Logic" data flow
    gt_data_i: entity work.gt_data
    generic map(
        NR_LANES => (4 * N_REGION)
    )
    port map(
        ipb_clk => ipb_clk,
        ipb_rst => ipb_rst,
        ipb_in  => ipb_to_slaves(C_IPB_GT_MP7_GTLFDL),
        ipb_out => ipb_from_slaves(C_IPB_GT_MP7_GTLFDL),
        clk240 => clk240,
        lhc_clk => lhc_clk,
        lhc_rst => lhc_rst,
        lane_data_in => lane_data_in,
        lhc_data_2_ctrl => lhc_data_2_ctrl,
        bcres => bcres_d_FDL,
        test_en => test_en_int,
        l1a => l1a,
        start_lumisection => start_lumisection,
        algo_bx_mask_mem_fdl => algo_bx_mask_mem_fdl,
        bx_nr_fdl => bx_nr_fdl,
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

-- Signals to LEMO on mezzanine
    gpio(0) <= finor_2_mezz_lemo;
    gpio(1) <= veto_2_mezz_lemo;
    gpio(2) <= finor_preview_2_mezz_lemo;
    gpio_en(2 downto 0) <= "111"; -- enable outputs 0 to 2
--     gpio_en(0) <= '1'; --enable output 0
--     gpio_en(1) <= '1'; --enable output 1
--     gpio_en(2) <= '1'; --enable output 2

end rtl;

