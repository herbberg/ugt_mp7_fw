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

entity correlation_conditions_tb is
end correlation_conditions_tb;

architecture rtl of correlation_conditions_tb is

    constant LHC_CLK_PERIOD : time :=  25 ns;
    signal lhc_clk: std_logic;

--     type correlation_conditions_conf is record
--         OUT_REG, DETA_SEL, DPHI_SEL, INV_MASS_SEL, TRANS_MASS_SEL, TBPT_SEL, CHARGE_CORR_SEL, 
--         CHARGE_1_SEL, QUAL_1_SEL, ISO_1_SEL, PHI_1_SEL, ETA_1_SEL,
--         CHARGE_2_SEL, QUAL_2_SEL, ISO_2_SEL, PHI_2_SEL, ETA_2_SEL : boolean;
--         SLICE_1_L, SLICE_1_H, SLICE_2_L, SLICE_2_H, SLICE_2_L, N_OBJ_1, N_OBJ_2 : natural;
--     end record correlation_conditions_conf;
    constant CONF : correlation_conditions_conf := (
        true, true, false, false, false, false, false, 
        false, false, false, false, false,
        false, false, false, false, false,
        0, 11, 0, 7, 12, 8
    );
    
    signal pt_1 : std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1');
    signal eta_1_w1 : std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1');
    signal eta_1_w2 : std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1');
    signal eta_1_w3 : std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1');
    signal eta_1_w4 : std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1');
    signal eta_1_w5 : std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1');
    signal phi_1_w1 : std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1');
    signal phi_1_w2 : std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1');
    signal iso_1 : std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1');
    signal qual_1 : std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1');
    signal charge_1 : std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1');
    signal pt_2 : std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1');
    signal eta_2_w1 : std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1');
    signal eta_2_w2 : std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1');
    signal eta_2_w3 : std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1');
    signal eta_2_w4 : std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1');
    signal eta_2_w5 : std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1');
    signal phi_2_w1 : std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1');
    signal phi_2_w2 : std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1');
    signal iso_2 : std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1');
    signal qual_2 : std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1');
    signal charge_2 : std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1');
    signal deta : std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0) := (others => (others => '1'));
    signal dphi : std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0) := (others => (others => '1'));
    signal inv_mass : std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0) := (others => (others => '1'));
    signal trans_mass : std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0) := (others => (others => '1'));
    signal tbpt : std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0) := (others => (others => '1'));
    signal charge_corr_double : std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0) := (others => (others => '1'));

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
            pt_1 <= "000000001000";
            pt_2 <= "00000100";
            deta <= ("00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000001", "00000000"); -- no trigger
        wait for 3*LHC_CLK_PERIOD; 
            pt_1 <= "000000000100";
            pt_2 <= "00000001";
            deta <= ("00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000001", "00000000", "00000000"); -- trigger
        wait for LHC_CLK_PERIOD; 
            pt_1 <= "000000000001";
            pt_2 <= "00000010";
            deta <= ("00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000001"); -- no trigger
        wait for LHC_CLK_PERIOD; 
            pt_1 <= "000000000001";
            pt_2 <= "00000010";
            deta <= ("00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000010"); -- trigger
        wait for LHC_CLK_PERIOD; 
            pt_1 <= "000000000000";
            pt_2 <= "00000000";
            deta <= ("00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000", "00000000"); -- no trigger
        wait;
    end process;

 ------------------- Instantiate  modules  -----------------

dut: entity work.correlation_conditions
    generic map(CONF)
    port map(lhc_clk, 
        pt_1, 
        eta_1_w1, 
        eta_1_w2, 
        eta_1_w3, 
        eta_1_w4, 
        eta_1_w5, 
        phi_1_w1, 
        phi_1_w2, 
        iso_1, 
        qual_1, 
        charge_1, 
        pt_2, 
        eta_2_w1, 
        eta_2_w2, 
        eta_2_w3, 
        eta_2_w4, 
        eta_2_w5, 
        phi_2_w1, 
        phi_2_w2, 
        iso_2, 
        qual_2, 
        charge_2,
        deta,
        dphi,
        inv_mass,
        trans_mass,
        tbpt,
        charge_corr_double,
        open 
    );

end rtl;

