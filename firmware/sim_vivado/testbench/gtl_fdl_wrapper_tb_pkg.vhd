
library ieee;
use ieee.std_logic_1164.all;
-- use ieee.std_logic_arith.all;
-- use ieee.std_logic_unsigned.all;
-- use ieee.std_logic_textio.all;
-- use ieee.numeric_std.all;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library std;
use std.textio.all;
use work.txt_util.all;

package gtl_fdl_wrapper_tb_pkg is 

    file testvector_file : text open read_mode is "/home/bergauer/vivado_sim_test/mp7_ugt/0xf888/mp7fw_v2_4_1/build/L1Menu_GTL_v2_x_y_test-d1/sim/sim_results/module_0/testvector/TestVector_GTL_v2_x_y_test_module_0.txt";
    file error_file : text open write_mode is "/home/bergauer/vivado_sim_test/mp7_ugt/0xf888/mp7fw_v2_4_1/build/L1Menu_GTL_v2_x_y_test-d1/sim/sim_results/module_0/results_module_0.json";

end package;
