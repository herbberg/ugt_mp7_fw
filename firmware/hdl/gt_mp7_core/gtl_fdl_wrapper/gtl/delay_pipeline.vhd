
-- Version-history: 

library ieee;
use ieee.std_logic_1164.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;

entity delay_pipeline is
    generic(
        DATA_WIDTH : positive;
        STAGES : natural
    );
    port(
        clk : in std_logic;
        in_1: in std_logic_vector(DATA_WIDTH-1 downto 0);
        in_2: in std_logic_vector(DATA_WIDTH-1 downto 0);
        in_3: in std_logic_vector(DATA_WIDTH-1 downto 0);
        in_4: in std_logic_vector(DATA_WIDTH-1 downto 0);
        in_5: in std_logic_vector(DATA_WIDTH-1 downto 0);
        out_1 : out std_logic_vector(DATA_WIDTH-1 downto 0);
        out_2 : out std_logic_vector(DATA_WIDTH-1 downto 0);
        out_3 : out std_logic_vector(DATA_WIDTH-1 downto 0);
        out_4 : out std_logic_vector(DATA_WIDTH-1 downto 0);
        out_5 : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end delay_pipeline;

architecture rtl of delay_pipeline is

begin

    pipe_p: process(clk, in_1, in_2, in_3, in_4, in_5)
        type pipe_array is array (0 to STAGES+1) of std_logic_vector(DATA_WIDTH-1 downto 0);
        variable in_1_tmp : pipe_array := (others => (others => '0'));
        variable in_2_tmp : pipe_array := (others => (others => '0'));
        variable in_3_tmp : pipe_array := (others => (others => '0'));
        variable in_4_tmp : pipe_array := (others => (others => '0'));
        variable in_5_tmp : pipe_array := (others => (others => '0'));
        begin
            in_1_tmp(STAGES+1) := in_1;
            in_2_tmp(STAGES+1) := in_2;
            in_3_tmp(STAGES+1) := in_3;
            in_4_tmp(STAGES+1) := in_4;
            in_5_tmp(STAGES+1) := in_5;
            if (STAGES > 0) then 
                if (clk'event and (clk = '1') ) then
                    in_1_tmp(0 to STAGES) := in_1_tmp(1 to STAGES+1);
                    in_2_tmp(0 to STAGES) := in_2_tmp(1 to STAGES+1);
                    in_3_tmp(0 to STAGES) := in_3_tmp(1 to STAGES+1);
                    in_4_tmp(0 to STAGES) := in_4_tmp(1 to STAGES+1);
                    in_5_tmp(0 to STAGES) := in_5_tmp(1 to STAGES+1);
                end if;
            end if;
            out_1 <= in_1_tmp(1); -- used pipe_temp(1) instead of pipe_temp(0), to prevent warnings in compilation
            out_2 <= in_2_tmp(1);
            out_3 <= in_3_tmp(1);
            out_4 <= in_4_tmp(1);
            out_5 <= in_5_tmp(1);
    end process;

end architecture rtl;
