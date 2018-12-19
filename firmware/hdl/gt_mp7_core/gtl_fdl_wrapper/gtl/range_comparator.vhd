-- Description:
-- Object cuts range comparisons.

-- Version-history:
-- HB 2018-12-18: First design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity range_comparator is
    generic(
        N_OBJ : positive;
        DATA_WIDTH : positive;
        MODE : comp_mode;
        MIN : std_logic_vector(MAX_COMP_DATA_WIDTH-1 downto 0) := (others => '0');
        MAX : std_logic_vector(MAX_COMP_DATA_WIDTH-1 downto 0) := (others => '0')
    );
    port(
        clk : in std_logic;
        data : in comp_in_data_array(0 to N_OBJ-1);
        comp_o : out std_logic_vector(0 to N_OBJ-1) := (others => '0')
    );
end range_comparator;

architecture rtl of range_comparator is

    constant MIN_I : std_logic_vector(DATA_WIDTH-1 downto 0) := MIN(DATA_WIDTH-1 downto 0);
    constant MAX_I : std_logic_vector(DATA_WIDTH-1 downto 0) := MAX(DATA_WIDTH-1 downto 0);
    signal comp : std_logic_vector(0 to N_OBJ-1);
    type data_i_array is array(0 to N_OBJ-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal data_i : data_i_array;

begin

    l1: for i in 0 to N_OBJ-1 generate
        in_reg_i : entity work.reg_mux
            generic map(DATA_WIDTH, IN_REG_COMP)  
            port map(clk, data(i)(DATA_WIDTH-1 downto 0), data_i(i));
        if_win_sign: if MODE = win_sign generate
            comp_signed_i : entity work.comp_signed
                generic map(MIN_I, MAX_I)  
                port map(data_i(i), comp(i));
        end generate if_win_sign;
        if_win_unsign: if MODE = win_unsign generate
            comp(i) <= '1' when (data_i(i) >= MIN_I(DATA_WIDTH-1 downto 0)) and (data_i(i) <= MAX_I(DATA_WIDTH-1 downto 0)) else '0';
        end generate if_win_unsign;
    end generate l1;

    out_reg_i : entity work.reg_mux
        generic map(N_OBJ, OUT_REG_COMP)  
        port map(clk, comp, comp_o);

end architecture rtl;
