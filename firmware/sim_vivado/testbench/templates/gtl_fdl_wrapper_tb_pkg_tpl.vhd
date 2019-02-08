
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

    file testvector_file : text open read_mode is "{{TESTVECTOR_FILENAME}}";
    file error_file : text open write_mode is "{{RESULTS_FILE}}";

end package;
