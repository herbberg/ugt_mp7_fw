-- Description:
-- Differences in eta.

-- Version-history:
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity difference_eta is
    generic (
        NR_OBJ_1 : positive := 12;
        NR_OBJ_2 : positive := 8
    );
    port(
        in_1 : in diff_integer_inputs_array(0 to NR_OBJ_1-1);
        in_2 : in diff_integer_inputs_array(0 to NR_OBJ_2-1);
        diff_o : out dim2_max_eta_range_array(0 to NR_OBJ_1-1, 0 to NR_OBJ_2-1)
    );
end difference_eta;

architecture rtl of difference_eta is
begin
-- instantiation of subtractors for eta
    loop_1: for i in 0 to NR_OBJ_1-1 generate
        loop_2: for j in 0 to NR_OBJ_2-1 generate
-- only positive difference in eta
            diff_o(i,j) <= abs(in_1(i) - in_2(j));
        end generate loop_2;
    end generate loop_1;
end architecture rtl;
