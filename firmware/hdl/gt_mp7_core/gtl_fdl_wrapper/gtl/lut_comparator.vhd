-- Description:
-- Object cuts lut comparisons.

-- Version-history:
-- HB 2018-12-18: First design.

library ieee;
use ieee.std_logic_1164.all;

-- used for CONV_INTEGER
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;
use work.lut_pkg.all;

entity lut_comparator is
    generic(
        N_OBJ : positive;
        DATA_WIDTH : positive;
        LUT : std_logic_vector(MAX_LUT_WIDTH-1 downto 0) := (others => '0')
    );
    port(
        clk : in std_logic;
        data : in obj_parameter_array;
        comp_o : out std_logic_vector(0 to N_OBJ-1) := (others => '0')
    );
end lut_comparator;

architecture rtl of lut_comparator is

    constant LUT_I : std_logic_vector(2**DATA_WIDTH-1 downto 0) := LUT(2**DATA_WIDTH-1 downto 0);
    type data_i_array is array(0 to N_OBJ-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal data_i : data_i_array;
    signal comp : std_logic_vector(0 to N_OBJ-1);

begin

    l1: for i in 0 to N_OBJ-1 generate
        in_reg_i : entity work.reg_mux
            generic map(DATA_WIDTH, IN_REG_COMP)  
            port map(clk, data(i)(DATA_WIDTH-1 downto 0), data_i(i));
        comp(i) <= LUT_I(CONV_INTEGER(data_i(i)));
    end generate l1;

    out_reg_i : entity work.reg_mux
        generic map(N_OBJ, OUT_REG_COMP)  
        port map(clk, comp, comp_o);

end architecture rtl;
