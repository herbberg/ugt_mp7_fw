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
        MIN_REQ : std_logic_vector(MAX_OBJ_PARAMETER_WIDTH-1 downto 0) := (others => '0');
        MAX_REQ : std_logic_vector(MAX_OBJ_PARAMETER_WIDTH-1 downto 0) := (others => '0')
    );
    port(
        clk : in std_logic;
        data : in obj_parameter_array;
        comp_o : out std_logic_vector(0 to N_OBJ-1) := (others => '0')
    );
end range_comparator;

architecture rtl of range_comparator is

    constant MIN_I : std_logic_vector(DATA_WIDTH-1 downto 0) := MIN_REQ(DATA_WIDTH-1 downto 0);
    constant MAX_I : std_logic_vector(DATA_WIDTH-1 downto 0) := MAX_REQ(DATA_WIDTH-1 downto 0);
    signal comp : std_logic_vector(0 to N_OBJ-1);
    type data_i_array is array(0 to N_OBJ-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal data_i : data_i_array;

begin

    l1: for i in 0 to N_OBJ-1 generate
        in_reg_i : entity work.reg_mux
            generic map(DATA_WIDTH, IN_REG_COMP)  
            port map(clk, data(i)(DATA_WIDTH-1 downto 0), data_i(i));
        if_1: if MODE = ETA generate
            comp_signed_i : entity work.comp_signed
                generic map(MIN_I, MAX_I)  
                port map(data_i(i), comp(i));
        end generate if_1;
        if_2: if MODE = PHI generate
            comp(i) <= '1' when (data_i(i) >= MIN_I(DATA_WIDTH-1 downto 0)) and (data_i(i) <= MAX_I(DATA_WIDTH-1 downto 0)) else '0';
        end generate if_2;
    end generate l1;

    out_reg_i : entity work.reg_mux
        generic map(N_OBJ, OUT_REG_COMP)  
        port map(clk, comp, comp_o);

end architecture rtl;
