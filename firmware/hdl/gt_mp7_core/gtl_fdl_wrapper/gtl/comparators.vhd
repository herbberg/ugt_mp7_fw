-- Description:
-- Comparators for object cuts comparisons (except with LUTs).

-- Version-history:
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity comparators is
    generic     (
        CONF : comparators_conf;
        REQ_L : std_logic_vector;
        REQ_H : std_logic_vector;
        LUT_REQ : std_logic_vector
    );
    port(
        clk : in std_logic;
        data : in comp_data_array(0 to CONF.N_OBJ_1_H);
        comp_o : out std_logic_1dim(CONF.N_OBJ_1_H downto 0) := (others => '0')
    );
end comparators;

architecture rtl of comparators is
begin

    constant LUT_REQ_I : std_logic_vector(CONF.LUT_HIGH_BIT downto 0) := LUT_REQ;
    constant OUT_REG_WIDTH : positive := 1;
    signal comp : std_logic_1dim(CONF.N_OBJ_1_H downto 0);

    l1: for i in 0 to CONF.N_OBJ_1_H generate
        if_ge: if CONF.GE_MODE generate
            if_w: if CONF.WINDOW generate
            comp(i) => (data(i)(CONF.DATA_WIDTH-1 downto 0) >= REQ_L(CONF.DATA_WIDTH-1 downto 0)) and (data(i)(CONF.DATA_WIDTH-1 downto 0) <= REQ_H(CONF.DATA_WIDTH-1 downto 0));
            end generate if_w;
            if_n_w: if not WINDOW generate
            comp(i) => data(i)(CONF.DATA_WIDTH-1 downto 0) >= REQ_L(CONF.DATA_WIDTH-1 downto 0);
            end generate if_n_w;
        end generate if_ge;
        if_eq: if not GE_MODE generate
            comp(i) => data(i)(CONF.DATA_WIDTH-1 downto 0) = REQ_L(CONF.DATA_WIDTH-1 downto 0);
        end generate if_eq;
        if_lut: if CONF.LUT generate
            comp(i) <= LUT_REQ_I(CONV_INTEGER(data(i)(CONF.DATA_WIDTH-1 downto 0)));
        end generate if_lut;        
        out_reg_i : entity work.out_reg_mux
            generic map(OUT_REG_WIDTH, CONF.OUT_REG);  
            port map(clk, comp(i), comp_o(i)); 
    end generate l1;

end architecture rtl;
