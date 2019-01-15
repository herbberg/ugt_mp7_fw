-- Description:
-- Register multiplexer.

-- Version-history:
-- HB 2018-12-17: First design.

library ieee;
use ieee.std_logic_1164.all;

entity reg_mux is
    generic(
        R_WIDTH : natural := 12;
        REG : boolean := true
    );
    port(
        clk : in std_logic;
        reg_in : in std_logic_vector(R_WIDTH-1 downto 0);
        reg_out : out std_logic_vector(R_WIDTH-1 downto 0)
    );
end reg_mux;

architecture rtl of reg_mux is

begin

    reg_p: process(clk, reg_in)
    begin
        if REG = false then
            reg_out <= reg_in;
        else
            if (clk'event and clk = '1') then
                reg_out <= reg_in;
            end if;
        end if;
    end process reg_p;

end architecture rtl;



