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

use work.gtl_pkg.all;

entity muon_charge_correlation_tb is
end muon_charge_correlation_tb;

architecture rtl of muon_charge_correlation_tb is

    constant LHC_CLK_PERIOD : time :=  25 ns;
    signal lhc_clk: std_logic;

    signal in_1, in_2 : muon_charge_bits_array;
    signal in_1_i, in_2_i : obj_parameter_array(0 to NR_MUON_OBJECTS-1) := (others => (others => '0'));
    signal cc_double: muon_cc_double_array;
    signal cc_triple: muon_cc_triple_array;
    signal cc_quad: muon_cc_quad_array;

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
        wait for LHC_CLK_PERIOD; 
            in_1 <= ("00", "00", "00", "00", "00", "00", "00", "00");
            in_2 <= ("00", "00", "00", "00", "00", "00", "00", "00");
        wait for LHC_CLK_PERIOD; 
            in_1 <= ("11", "11", "10", "11", "00", "00", "00", "00");
            in_2 <= ("11", "11", "10", "11", "00", "00", "00", "00");
        wait for LHC_CLK_PERIOD; 
            in_1 <= ("00", "00", "00", "00", "00", "00", "00", "00");
            in_2 <= ("00", "00", "00", "00", "00", "00", "00", "00");
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------
 
l1: for i in 0 to NR_MUON_OBJECTS-1 generate
    in_1_i(i)(NR_MUON_CHARGE_BITS-1 downto 0) <= in_1(i);
    in_2_i(i)(NR_MUON_CHARGE_BITS-1 downto 0) <= in_2(i);
end generate l1;

dut_1: entity work.muon_charge_correlations
    generic map(false)
    port map(
        clk => lhc_clk, in_1 => in_1_i,  in_2 => in_2_i,
        cc_double => cc_double, cc_triple => cc_triple, cc_quad => cc_quad
    );

dut_2: entity work.comparator_muon_charge_corr
    generic map(true, true, CC_OS)
    port map(
        clk => lhc_clk, cc_double => cc_double, cc_triple => cc_triple, cc_quad => cc_quad, 
        comp_o_double => open, comp_o_triple => open, comp_o_quad => open
    );

end rtl;

