-- Description:
-- Differences in eta.

-- Version-history:
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;

-- used for integer function
use ieee.std_logic_arith.all;
-- use ieee.numeric_std.all;

use work.gtl_pkg.all;

entity difference_eta is
    generic (
        CONF : differences_conf
    );
    port(
        clk : in std_logic;
        in_1 : in diff_integer_inputs_array(0 to CONF.NR_OBJ_1-1);
        in_2 : in diff_integer_inputs_array(0 to CONF.NR_OBJ_2-1);
        diff_o : out dim2_max_eta_range_array(0 to CONF.NR_OBJ_1-1, 0 to CONF.NR_OBJ_2-1)
    );
end difference_eta;

architecture rtl of difference_eta is

    constant OUT_REG_WIDTH : positive := CONF.NR_OBJ_1 * CONF.NR_OBJ_2 * integer(ETA_RANGE_REAL/MUON_ETA_STEP);
    signal diff_i : dim2_max_eta_range_array(0 to CONF.NR_OBJ_1-1, 0 to CONF.NR_OBJ_2-1);
    
begin
-- instantiation of subtractors for eta
    loop_1: for i in 0 to CONF.NR_OBJ_1-1 generate
        loop_2: for j in 0 to CONF.NR_OBJ_2-1 generate
-- only positive difference in eta
            diff_i(i,j) <= abs(in_1(i) - in_2(j));
        end generate loop_2;
    end generate loop_1;

    out_reg_i : entity work.out_reg_mux
        generic map(OUT_REG_WIDTH, CONF.OUT_REG);  
        port map(clk, diff_i, diff_o); 
    
end architecture rtl;
