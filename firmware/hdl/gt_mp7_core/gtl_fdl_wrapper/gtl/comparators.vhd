-- Description:
-- Comparators for object cuts comparisons (except with LUTs).

-- Version-history:
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;

-- used for CONV_INTEGER
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;

entity comparators is
    generic(
        CONF : comparators_conf;
        REQ_L : std_logic_vector(MAX_COMP_IN_DATA_WIDTH-1 downto 0) := (others => '0');
        REQ_H : std_logic_vector(MAX_COMP_IN_DATA_WIDTH-1 downto 0) := (others => '0');
        LUT_REQ : std_logic_vector(MAX_LUT_WIDTH-1 downto 0) := (others => '0') 
    );
    port(
        clk : in std_logic;
        data : in comp_in_data_array(0 to CONF.N_OBJ_1_H);
        comp_o : out std_logic_1dim_array(CONF.N_OBJ_1_H downto 0) := (others => '0')
    );
end comparators;

architecture rtl of comparators is

    constant REQ_L_I : std_logic_vector(CONF.DATA_WIDTH-1 downto 0) := REQ_L(CONF.DATA_WIDTH-1 downto 0);
    constant REQ_H_I : std_logic_vector(CONF.DATA_WIDTH-1 downto 0) := REQ_H(CONF.DATA_WIDTH-1 downto 0);
    constant LUT_REQ_I : std_logic_vector(CONF.LUT_HIGH_BIT downto 0) := LUT_REQ(CONF.LUT_HIGH_BIT downto 0);
    signal comp : std_logic_1dim_array(CONF.N_OBJ_1_H downto 0);
    type comp_i_array is array (CONF.N_OBJ_1_H downto 0) of std_logic_vector(0 downto 0);
    signal comp_i : comp_i_array;
    signal comp_r : comp_i_array;

begin

    l1: for i in 0 to CONF.N_OBJ_1_H generate
        if_ge: if CONF.GE_MODE generate
            if_w: if CONF.WINDOW generate
            comp(i) <= '1' when (data(i)(CONF.DATA_WIDTH-1 downto 0) >= REQ_L_I(CONF.DATA_WIDTH-1 downto 0)) and (data(i)(CONF.DATA_WIDTH-1 downto 0) <= REQ_H_I(CONF.DATA_WIDTH-1 downto 0)) else '0';
            end generate if_w;
            if_n_w: if not CONF.WINDOW generate
            comp(i) <= '1' when (data(i)(CONF.DATA_WIDTH-1 downto 0) >= REQ_L_I(CONF.DATA_WIDTH-1 downto 0)) else '0';
            end generate if_n_w;
        end generate if_ge;
        if_eq: if not CONF.GE_MODE generate
            comp(i) <= '1' when (data(i)(CONF.DATA_WIDTH-1 downto 0) = REQ_L_I(CONF.DATA_WIDTH-1 downto 0)) else '0';
        end generate if_eq;
        if_lut: if CONF.LUT generate
            comp(i) <= LUT_REQ_I(CONV_INTEGER(data(i)(CONF.DATA_WIDTH-1 downto 0)));
        end generate if_lut;
        comp_i(i)(0) <= comp(i);
        out_reg_i : entity work.out_reg_mux
            generic map(1, CONF.OUT_REG)  
            port map(clk, comp_i(i), comp_r(i));
        comp_o(i) <= comp_r(i)(0);
    end generate l1;

end architecture rtl;
