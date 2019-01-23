
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.ipbus.all;
use work.math_pkg.all;

package gt_mp7_core_addr_decode is

    constant NR_IPB_SLV_GT_MP7_CORE : positive:= 3;

    constant IPBUS_SEL_WIDTH: positive := log2c(NR_IPB_SLV_GT_MP7_CORE);
    subtype ipbus_sel_t is std_logic_vector(IPBUS_SEL_WIDTH - 1 downto 0);
    function ipbus_sel_mp7_payload(addr : in std_logic_vector(31 downto 0)) return ipbus_sel_t;

    constant C_IPB_GT_MP7_FRAME : integer := 0;
    constant C_IPB_GT_MP7_GTLFDL : integer := 1;
    constant C_IPB_GT_MP7_TP_MUX : integer := 2;

end gt_mp7_core_addr_decode;


package body gt_mp7_core_addr_decode is

    function ipbus_sel_mp7_payload(addr : in std_logic_vector(31 downto 0)) return ipbus_sel_t is
        variable sel: ipbus_sel_t;

  begin
        if       std_match(addr, "1000----------------------------") then sel := ipbus_sel_t(to_unsigned(C_IPB_GT_MP7_FRAME, IPBUS_SEL_WIDTH));  --0x80000000
        elsif    std_match(addr, "1001----------------------------") then sel := ipbus_sel_t(to_unsigned(C_IPB_GT_MP7_GTLFDL, IPBUS_SEL_WIDTH)); --0x90000000
        elsif    std_match(addr, "1010----------------------------") then sel := ipbus_sel_t(to_unsigned(C_IPB_GT_MP7_TP_MUX, IPBUS_SEL_WIDTH)); --0xA0000000
        else
            sel := ipbus_sel_t(to_unsigned(NR_IPB_SLV_GT_MP7_CORE, IPBUS_SEL_WIDTH));
        end if;

        return sel;

    end function ipbus_sel_mp7_payload;

end gt_mp7_core_addr_decode;
