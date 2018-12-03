-- Description:
-- Correlation conditions

-- Version-history:
-- HB 2018-11-29: First design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity correlation_conditions is
    generic(
        CONF : correlation_conditions_conf
    );
    port(
        clk : in std_logic;
        pt_1 : in std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1'));
        eta_1_w1 : in std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1'));
        eta_1_w2 : in std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1'));
        eta_1_w3 : in std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1'));
        eta_1_w4 : in std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1'));
        eta_1_w5 : in std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1'));
        phi_1_w1 : in std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1'));
        phi_1_w2 : in std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1'));
        iso_1 : in std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1'));
        qual_1 : in std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1'));
        charge_1 : in std_logic_vector(CONF.N_OBJ_1-1 downto 0) := (others => '1'));
        pt_2 : in std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1'));
        eta_2_w1 : in std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1'));
        eta_2_w2 : in std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1'));
        eta_2_w3 : in std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1'));
        eta_2_w4 : in std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1'));
        eta_2_w5 : in std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1'));
        phi_2_w1 : in std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1'));
        phi_2_w2 : in std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1'));
        iso_2 : in std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1'));
        qual_2 : in std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1'));
        charge_2 : in std_logic_vector(CONF.N_OBJ_2-1 downto 0) := (others => '1'));
        deta : in std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0) := (others => (others => '1'));
        dphi : in std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0) := (others => (others => '1'));
        inv_mass : in std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0) := (others => (others => '1'));
        trans_mass : in std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0) := (others => (others => '1'));
        tbpt : in std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0) := (others => (others => '1'));
        charge_corr_double : in std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0) := (others => (others => '1'));
        cond_o : out std_logic
    );
end correlation_conditions;

architecture rtl of correlation_conditions is

    constant OUT_REG_WIDTH : positive := 1;
    constant N_SLICE_1 : positive := CONF.SLICE_1_H - CONF.SLICE_1_L + 1;
    constant N_SLICE_2 : positive := CONF.SLICE_2_H - CONF.SLICE_2_L + 1;
    constant DEF_VAL_2DIM : std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0) := (others => (others => '1'));
    signal cond_and_1 : std_logic_vector(CONF.N_OBJ_1-1 downto 0);
    signal cond_and_2 : std_logic_vector(CONF.N_OBJ_2-1 downto 0);
    signal deta_i : std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0);
    signal dphi_i : std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0);
    signal inv_mass_i : std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0);
    signal trans_mass_i : std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0);
    signal tbpt_i : std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0);
    signal cc_double_i : std_logic_2dim_array(CONF.N_OBJ_1-1 downto 0, CONF.N_OBJ_2-1 downto 0);
    signal cond_and_or, cond_o_v : std_logic_vector(0 to 0);

begin

    and_1_i : entity work.combinatorial_and
        generic map(CONF.N_OBJ_1, CONF.ETA_1_SEL, CONF.PHI_1_SEL, CONF.ISO_1_SEL, CONF.QUAL_1_SEL, CONF.CHARGE_1_SEL)  
        port map(pt_1, eta_1_w1, eta_1_w2, eta_1_w3, eta_1_w4, eta_1_w5,
            phi_1_w1, phi_1_w2, iso_1, qual_1, charge_1, cond_and_1); 

    and_2_i : entity work.combinatorial_and
        generic map(CONF.N_OBJ_2, CONF.ETA_2_SEL, CONF.PHI_2_SEL, CONF.ISO_2_SEL, CONF.QUAL_2_SEL, CONF.CHARGE_2_SEL)  
        port map(pt_2, eta_2_w1, eta_2_w2, eta_2_w3, eta_2_w4, eta_2_w5,
            phi_2_w1, phi_2_w2, iso_2, qual_2, charge_2, cond_and_2); 

    deta_i <= deta when CONF.DETA_SEL else DEF_VAL_2DIM;
    dphi_i <= dphi when CONF.DPHI_SEL else DEF_VAL_2DIM;
    inv_mass_i <= inv_mass when CONF.INV_MASS_SEL else DEF_VAL_2DIM;
    trans_mass_i <= trans_mass when CONF.TRANS_MASS_SEL else DEF_VAL_2DIM;
    tbpt_i <= tbpt when CONF.TBPT_SEL else DEF_VAL_2DIM;
    cc_double_i <= charge_corr_double when CONF.CHARGE_CORR_SEL else DEF_VAL_2DIM;

    and_or_p: process(cond_and_1, cond_and_2, deta_i, dphi_i, inv_mass_i, trans_mass_i, tbpt_i, cc_double_i)
        variable index : integer := 0;
        variable and_vec : std_logic_vector((N_SLICE_1*N_SLICE_2) downto 1) := (others => '0');
        variable tmp : std_logic := '0';
    begin
        index := 0;
        and_vec := (others => '0');
        tmp := '0';
        for i in CONF.SLICE_1_L to CONF.SLICE_1_H loop
            for j in CONF.SLICE_2_L to CONF.SLICE_2_H loop
                index := index + 1;
                and_vec(index) := cond_and_1(i) and cond_and_2(j) and deta_i(i,j) and dphi_i(i,j) and 
                    inv_mass_i(i,j) and trans_mass_i(i,j) and tbpt_i(i,j) and cc_double_i(i,j);
            end loop;
        end loop;
        for i in 1 to index loop
            tmp := tmp or and_vec(i);
        end loop;
        cond_and_or(0) <= tmp;
    end process and_or_p;

    out_reg_i : entity work.out_reg_mux
        generic map(OUT_REG_WIDTH, CONF.OUT_REG)  
        port map(clk, cond_and_or, cond_o_v);
    
    cond_o <= cond_o_v(0);
    
end architecture rtl;



