-- Description:
-- Testbench for simulation of conversions.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

use work.gt_mp7_core_pkg.all;
use work.gtl_pkg.all;
use work.rb_pkg.all;

entity tcm_tb is
end tcm_tb;

architecture rtl of tcm_tb is

    constant LHC_CLK_PERIOD : time :=  1000 ps;
    
    signal lhc_clk : std_logic;
    signal lhc_rst : std_logic := '0';
    signal cntr_rst : std_logic := '0';
    signal ec0 : std_logic := '0';
    signal oc0 : std_logic := '0';
    signal start : std_logic := '0';
    signal l1a : std_logic := '0';
    signal bcres_d : std_logic := '0';
    signal bcres_d_FDL : std_logic := '0';
    signal sw_reg_in : sw_reg_tcm_in_t := SW_REG_TCM_IN_RESET;
    signal bx_nr : std_logic_vector(BX_NR_WIDTH-1 downto 0);
    signal bx_nr_d_fdl : std_logic_vector(BX_NR_WIDTH-1 downto 0);
    signal event_nr : std_logic_vector(EVENT_NR_WIDTH-1 downto 0);
    signal trigger_nr : std_logic_vector(TRIGGER_NR_WIDTH-1 downto 0);
    signal orbit_nr : std_logic_vector(ORBIT_NR_WIDTH-1 downto 0);
    signal luminosity_seg_nr : std_logic_vector(LUM_SEG_NR_WIDTH-1 downto 0);
    signal start_lumisection : std_logic;

--*********************************Main Body of Code**********************************
begin
    
    -- Clock
    process
    begin
            lhc_clk  <=  '1';
        wait for LHC_CLK_PERIOD/2;
            lhc_clk  <=  '0';
        wait for LHC_CLK_PERIOD/2;
    end process;

    process
    begin
        wait for 2*LHC_CLK_PERIOD; 
            lhc_rst <= '1';
        wait for LHC_CLK_PERIOD; 
            lhc_rst <= '0';
        wait;
    end process;

    process
    begin
        wait for 4*LHC_CLK_PERIOD; 
            bcres_d <= '1';
        wait for LHC_CLK_PERIOD; 
            bcres_d <= '0';
        wait;
    end process;

    process
    begin
        wait for 4*LHC_CLK_PERIOD; 
            bcres_d_FDL <= '1';
        wait for LHC_CLK_PERIOD; 
            bcres_d_FDL <= '0';
        wait;
    end process;

    process
    begin
        wait for 20*LHC_CLK_PERIOD; 
            oc0 <= '1';
        wait for LHC_CLK_PERIOD; 
            oc0 <= '0';
        wait;
    end process;

    process
    begin
        wait for 30*LHC_CLK_PERIOD; 
            start <= '1';
        wait for LHC_CLK_PERIOD; 
            start <= '0';
        wait;
    end process;

    process
    begin
        wait for 40*LHC_CLK_PERIOD; 
            ec0 <= '1';
        wait for LHC_CLK_PERIOD; 
            ec0 <= '0';
        wait;
    end process;

    process
    begin
        wait for 80*LHC_CLK_PERIOD; 
            l1a <= '1';
        wait for LHC_CLK_PERIOD; 
            l1a <= '0';
        wait for 13*LHC_CLK_PERIOD; 
            l1a <= '1';
        wait for LHC_CLK_PERIOD; 
            l1a <= '0';
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------

dut: entity work.tcm
    port map(
        lhc_clk           => lhc_clk,
        lhc_rst           => lhc_rst,
        cntr_rst          => cntr_rst,
        ec0               => ec0,
        oc0               => oc0,
        start             => start,
        l1a_sync          => l1a,
        bcres_d           => bcres_d,
        bcres_d_FDL       => bcres_d_FDL,
        sw_reg_in         => sw_reg_in,
        bx_nr             => bx_nr,
        bx_nr_d_FDL       => bx_nr_d_FDL,
        orbit_nr          => orbit_nr,
        start_lumisection => open
    );

end rtl;

