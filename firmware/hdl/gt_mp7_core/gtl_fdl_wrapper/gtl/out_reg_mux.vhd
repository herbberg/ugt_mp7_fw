-- Description:
-- Output register mux.

-- Version-history:
-- HB 2018-11-26: First design.

entity out_reg_mux is
    generic(
        R_WIDTH : natural := 12;
        REG : boolean := true
    );
    port(
        clk : in std_logic;
        reg_in : in std_logic_vector(R_WIDTH-1 downto 0);
        reg_out : out std_logic_vector(R_WIDTH-1 downto 0)
    );
end out_reg_mux;

architecture rtl of out_reg_mux is

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



