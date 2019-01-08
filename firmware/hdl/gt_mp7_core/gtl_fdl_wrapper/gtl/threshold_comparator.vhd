-- Description:
-- Object cuts threshold comparisons.

-- Version-history:
-- HB 2018-12-18: First design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity threshold_comparator is
    generic(
        N_OBJ : positive;
        DATA_WIDTH : positive;
        MODE : comp_mode := greater_equal;
        THRESHOLD : std_logic_vector(MAX_OBJ_PARAMETER_WIDTH-1 downto 0) := (others => '0')
    );
    port(
        clk : in std_logic;
        data : in obj_parameter_array;
--         data : in obj_parameter_array(0 to N_OBJ-1);
        comp_o : out std_logic_vector(0 to N_OBJ-1) := (others => '0')
    );
end threshold_comparator;

architecture rtl of threshold_comparator is

    constant THRESHOLD_I : std_logic_vector(DATA_WIDTH-1 downto 0) := THRESHOLD(DATA_WIDTH-1 downto 0);
    signal comp : std_logic_vector(0 to N_OBJ-1);
    type data_i_array is array(0 to N_OBJ-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal data_i : data_i_array;

begin

    l1: for i in 0 to N_OBJ-1 generate
        in_reg_i : entity work.reg_mux
            generic map(DATA_WIDTH, IN_REG_COMP)  
            port map(clk, data(i)(DATA_WIDTH-1 downto 0), data_i(i));
        if_ge: if MODE = greater_equal generate
            comp(i) <= '1' when (data_i(i) >= THRESHOLD_I) else '0';
        end generate if_ge;
        if_eq: if MODE = equal generate
            comp(i) <= '1' when (data_i(i) = THRESHOLD_I) else '0';
        end generate if_eq;
    end generate l1;

    out_reg_i : entity work.reg_mux
        generic map(N_OBJ, OUT_REG_COMP)  
        port map(clk, comp, comp_o);

end architecture rtl;
