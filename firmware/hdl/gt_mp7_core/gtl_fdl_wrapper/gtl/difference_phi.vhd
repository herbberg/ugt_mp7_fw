-- Description:
-- Differences in phi.

-- Version-history:
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity difference_phi is
    generic (
        NR_OBJ_1 : positive := 12;
        NR_OBJ_2 : positive := 8;
        PHI_HALF_RANGE: positive := 72 -- in bins
    );
    port(
        in_1 : in diff_integer_inputs_array(0 to NR_OBJ_1-1);
        in_2 : in diff_integer_inputs_array(0 to NR_OBJ_2-1);
        diff_o : out dim2_max_phi_range_array(0 to NR_OBJ_1-1, 0 to NR_OBJ_2-1)
    );
end difference_phi;

architecture rtl of difference_phi is
    signal diff_temp : dim2_max_phi_range_array(0 to NR_OBJ_1-1, 0 to NR_OBJ_2-1);
    
begin
-- instantiation of subtractors for phi
    loop_1: for i in 0 to NR_OBJ_1-1 generate
        loop_2: for j in 0 to NR_OBJ_2-1 generate
            diff_temp(i,j) <= abs(in_1(i) - in_2(j));
            diff_o(i,j) <= diff_temp(i,j) when diff_temp(i,j) < PHI_HALF_RANGE else PHI_HALF_RANGE*2-diff_temp(i,j);
        end generate loop_2;
    end generate loop_1;
end architecture rtl;
