library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all; -- for eta comparison with "signed", because of Eta-scale with Two's Complement notation for HW index.

entity comp_signed is
	generic	(
        limit_l: std_logic_vector;
        limit_h: std_logic_vector
    );
    port(
        data: in std_logic_vector;
        comp_o: out std_logic
    );
end comp_signed;

architecture rtl of comp_signed is
begin

    comp_o <= '1' when data >= limit_l and data <= limit_h else '0';

end architecture rtl;
