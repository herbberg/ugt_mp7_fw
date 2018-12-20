-- Description:
-- Comparators for correlation cuts comparisons.

-- Version-history:
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity comparators_corr_cuts is
    generic(
        N_OBJ_1 : positive;
        N_OBJ_2 : positive;
        DATA_WIDTH : positive;
        MODE : comp_mode;
        MINI : std_logic_vector(MAX_COMP_CORR_CUTS_DATA_WIDTH-1 downto 0) := (others => '0');
        MAXI : std_logic_vector(MAX_COMP_CORR_CUTS_DATA_WIDTH-1 downto 0) := (others => '0')
    );
    port(
        clk : in std_logic;
        data : in std_logic_3dim_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1, DATA_WIDTH-1 downto 0) := (others => (others => (others => '0')));
        comp_o : out std_logic_2dim_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1) := (others => (others => '0'))
    );
end comparators_corr_cuts;

architecture rtl of comparators_corr_cuts is

    constant MINI_I : std_logic_vector(DATA_WIDTH-1 downto 0) := MINI(DATA_WIDTH-1 downto 0);
    constant MAXI_I : std_logic_vector(DATA_WIDTH-1 downto 0) := MAXI(DATA_WIDTH-1 downto 0);
    type data_vec_array is array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal data_vec, data_vec_i : data_vec_array;
    signal comp : std_logic_2dim_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1);
    type comp_i_array is array (0 to N_OBJ_1, 0 to N_OBJ_2-1) of std_logic_vector(0 downto 0);
    signal comp_i : comp_i_array;
    signal comp_r : comp_i_array;

begin

    l1: for i in 0 to N_OBJ_1-1 generate
        l2: for j in 0 to N_OBJ_2-1 generate
            l3: for k in 0 to DATA_WIDTH-1 generate
                data_vec(i,j)(k) <= data(i,j,k);
            end generate l3;
            in_reg_i : entity work.reg_mux
                generic map(DATA_WIDTH, IN_REG_COMP)  
                port map(clk, data_vec(i,j), data_vec_i(i,j));
            if_ge: if MODE = greater_equal generate
                comp(i,j) <= '1' when (data_vec_i(i,j) >= MINI_I) else '0';
            end generate if_ge;
            if_win_sign: if MODE = win_sign generate
                comp_signed_i : entity work.comp_signed
                    generic map(MINI_I, MAXI_I)  
                    port map(data_vec_i(i,j), comp(i,j));
            end generate if_win_sign;
            if_win_unsign: if MODE = win_unsign generate
                comp(i,j) <= '1' when ((data_vec_i(i,j) >= MINI_I) and (data_vec_i(i,j) <= MAXI_I)) else '0';
            end generate if_win_unsign;
            if_eq: if MODE = equal generate
                comp(i,j) <= '1' when (data_vec_i(i,j) = MINI_I) else '0';
            end generate if_eq;
            comp_i(i,j)(0) <= comp(i,j);
            out_reg_i : entity work.reg_mux
                generic map(1, OUT_REG_COMP) 
                port map(clk, comp_i(i,j), comp_r(i,j)); 
            comp_o(i,j) <= comp_r(i,j)(0);
        end generate l2;
    end generate l1;

end architecture rtl;
