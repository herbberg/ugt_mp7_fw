-- Description:
-- Testbench for simulation of correlation_conditions.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library std;                  -- for Printing
use std.textio.all;

use work.gtl_pkg.all;

entity combinatorial_conditions_tb is
end combinatorial_conditions_tb;

architecture rtl of combinatorial_conditions_tb is

    constant LHC_CLK_PERIOD : time :=  25 ns;
    signal lhc_clk: std_logic;

--     type combinatorial_conditions_conf is record
--         OUT_REG, TBPT_SEL, CHARGE_CORR_SEL, CHARGE_SEL, QUAL_SEL, ISO_SEL, PHI_SEL, ETA_SEL : boolean;
--         SLICE_4_L, SLICE_4_H, SLICE_3_L, SLICE_3_H, SLICE_2_L, SLICE_2_H, SLICE_1_L, SLICE_1_H, N_OBJ, N_REQ : natural;
--     end record combinatorial_conditions_conf;

    constant CONF : combinatorial_conditions_conf := (
        true, false, false, false, false, false, false, false, 
        0, 7, 0, 7, 0, 7, 0, 7, 8, 4
    );
    
    signal pt : std_logic_2dim_array(1 to CONF.N_REQ, CONF.N_OBJ-1 downto 0);
--     signal eta_w1 : std_logic_2dim_array(1 to CONF.N_REQ, CONF.N_OBJ-1 downto 0) := (others => (others => '1'));
--     signal eta_w2 : std_logic_2dim_array(1 to CONF.N_REQ, CONF.N_OBJ-1 downto 0) := (others => (others => '1'));
--     signal eta_w3 : std_logic_2dim_array(1 to CONF.N_REQ, CONF.N_OBJ-1 downto 0) := (others => (others => '1'));
--     signal eta_w4 : std_logic_2dim_array(1 to CONF.N_REQ, CONF.N_OBJ-1 downto 0) := (others => (others => '1'));
--     signal eta_w5 : std_logic_2dim_array(1 to CONF.N_REQ, CONF.N_OBJ-1 downto 0) := (others => (others => '1'));
--     signal phi_w1 : std_logic_2dim_array(1 to CONF.N_REQ, CONF.N_OBJ-1 downto 0) := (others => (others => '1'));
--     signal phi_w2 : std_logic_2dim_array(1 to CONF.N_REQ, CONF.N_OBJ-1 downto 0) := (others => (others => '1'));
--     signal iso : std_logic_2dim_array(1 to CONF.N_REQ, CONF.N_OBJ-1 downto 0) := (others => (others => '1'));
--     signal qual : std_logic_2dim_array(1 to CONF.N_REQ, CONF.N_OBJ-1 downto 0) := (others => (others => '1'));
--     signal charge : std_logic_2dim_array(1 to CONF.N_REQ, CONF.N_OBJ-1 downto 0) := (others => (others => '1'));
--     signal tbpt : std_logic_2dim_array(CONF.N_OBJ-1 downto 0, CONF.N_OBJ-1 downto 0) := (others => (others => '1'));
--     signal charge_corr_double : std_logic_2dim_array(CONF.N_OBJ-1 downto 0, CONF.N_OBJ-1 downto 0) := (others => (others => '1'));
--     signal charge_corr_triple : std_logic_3dim_array(CONF.N_OBJ-1 downto 0, CONF.N_OBJ-1 downto 0, CONF.N_OBJ-1 downto 0) := (others => (others => (others => '1')));
--     signal charge_corr_quad : std_logic_4dim_array(CONF.N_OBJ-1 downto 0, CONF.N_OBJ-1 downto 0, CONF.N_OBJ-1 downto 0, CONF.N_OBJ-1 downto 0) := (others => (others => (others => (others => '1'))));

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
            pt <= ("00011111", "00000011", "00000000", "00000000");
        wait for 3*LHC_CLK_PERIOD; 
            pt <= ("00111111", "00001111", "00000111", "00001111");
        wait for LHC_CLK_PERIOD; 
            pt <= ("00011111", "00000011", "00000000", "00000000");
        wait for LHC_CLK_PERIOD; 
            pt <= ("00111111", "00001111", "00000111", "00001111");
        wait for LHC_CLK_PERIOD; 
            pt <= ("00011111", "00000011", "00000000", "00000000");
        wait for LHC_CLK_PERIOD; 
            pt <= ("00111111", "00001111", "00000111", "00001111");
        wait for LHC_CLK_PERIOD; 
            pt <= ("00011111", "00000011", "00000000", "00000000");
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------

dut: entity work.combinatorial_conditions
    generic map(CONF)
    port map(lhc_clk, 
        pt => pt, 
--         eta_w1, 
--         eta_w2, 
--         eta_w3, 
--         eta_w4, 
--         eta_w5, 
--         phi_w1, 
--         phi_w2, 
--         iso, 
--         qual, 
--         charge, 
--         tbpt,
--         charge_corr_double,
--         charge_corr_triple,
--         charge_corr_quad,
        cond_o => open 
    );

end rtl;

