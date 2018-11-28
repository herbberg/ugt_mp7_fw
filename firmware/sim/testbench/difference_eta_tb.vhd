-- Description:
-- Testbench for simulation of difference_eta.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

use work.gtl_pkg.all;

entity difference_eta_tb is
end difference_eta_tb;

architecture rtl of difference_eta_tb is

    constant LHC_CLK_PERIOD : time :=  25 ns;
    signal lhc_clk: std_logic;

    constant CONF : differences_conf := (NR_OBJ_1 => 2, NR_OBJ_2 => 2, PHI_HALF_RANGE => 72, OUT_REG => true, OBJ_CORR => calo_calo);
    signal eg_data : calo_objects_array(CONF.NR_OBJ_1-1 downto 0) := (X"00000000", X"00000000");
    signal eg_eta_integer: diff_integer_inputs_array(0 to CONF.NR_OBJ_1-1) := (others => 0);
    signal diff_eta_vector : deta_dphi_vector_array(0 to CONF.NR_OBJ_1-1, 0 to CONF.NR_OBJ_2-1) := (others => (others => (others => '0')));
    signal cosh_deta_vector : cosh_cos_vector_array(0 to CONF.NR_OBJ_1-1, 0 to CONF.NR_OBJ_2-1) := (others => (others => (others => '0')));

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
            eg_data <= (X"00000000", X"00000000");
        wait for LHC_CLK_PERIOD; 
            eg_data <= (X"00978199", X"0000E1FD");
        wait for LHC_CLK_PERIOD; 
            eg_data <= (X"00000000", X"00000000");
        wait for LHC_CLK_PERIOD; 
            eg_data <= (X"009781FD", X"0000E1CE");
        wait for LHC_CLK_PERIOD; 
            eg_data <= (X"00000000", X"00000000");
        wait for LHC_CLK_PERIOD; 
            eg_data <= (X"0006D070", X"0000E080");
        wait for LHC_CLK_PERIOD; 
            eg_data <= (X"00000000", X"00000000");
        wait for LHC_CLK_PERIOD; 
            eg_data <= (X"0006D070", X"0000E090");
        wait for LHC_CLK_PERIOD; 
            eg_data <= (X"00000000", X"00000000");
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------

eg_data_l: for i in 0 to CONF.NR_OBJ_1-1 generate
--     eg_eta_integer(i) <= CONV_INTEGER(signed(eg_data(i)(D_S_I_EG_V2.eta_high downto D_S_I_EG_V2.eta_low)));
    eg_eta_integer(i) <= CONV_INTEGER(signed(eg_data(i)(eg_struct.eta_h downto eg_struct.eta_l)));
end generate;

dut: entity work.difference_eta
    generic map(CONF)
    port map(lhc_clk, eg_eta_integer, eg_eta_integer, diff_eta_vector, cosh_deta_vector);

end rtl;

