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

entity conversions_tb is
end conversions_tb;

architecture rtl of conversions_tb is

    constant LHC_CLK_PERIOD : time :=  25 ns;

--     constant PT_VECTOR_W : natural := EG_PT_HIGH - EG_PT_LOW + 1;
    constant CONF : conversions_conf := (N_OBJ => 2, OBJ_T => muon, OBJ_S => muon_struct);
--     signal data : calo_objects_array(CONF.N_OBJ-1 downto 0) := (X"00000000", X"00000000");
    signal data : objects_array(CONF.N_OBJ-1 downto 0) := (X"0000000000000000", X"0000000000000000"); -- 64 bits - common object bit width

--*********************************Main Body of Code**********************************
begin
    
    process
    begin
        wait for LHC_CLK_PERIOD; 
            data <= (X"0000000000000000", X"0000000000000000");
        wait for LHC_CLK_PERIOD; 
            data <= (X"00000C5CFF978199", X"0000006666AAE1FD");
        wait for LHC_CLK_PERIOD; 
            data <= (X"0000000000000000", X"0000000000000000");
        wait for LHC_CLK_PERIOD; 
            data <= (X"00000000009781FD", X"000000000000E1CE");
        wait for LHC_CLK_PERIOD; 
            data <= (X"0000000000000000", X"0000000000000000");
        wait for LHC_CLK_PERIOD; 
            data <= (X"000000000006D070", X"000000000000E080");
        wait for LHC_CLK_PERIOD; 
            data <= (X"0000000000000000", X"0000000000000000");
        wait for LHC_CLK_PERIOD; 
            data <= (X"000000000006D070", X"000000000000E090");
        wait for LHC_CLK_PERIOD; 
            data <= (X"0000000000000000", X"0000000000000000");
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------

dut: entity work.conversions
    generic map(CONF)
    port map(
        obj => data, pt => open, eta => open, phi => open, iso => open,
        pt_vector => open, eta_integer => open, phi_integer => open, cos_phi => open, sin_phi => open, 
        conv_2_muon_eta_integer => open, conv_2_muon_phi_integer => open,
        conv_mu_cos_phi => open, conv_mu_sin_phi => open
    );

end rtl;

