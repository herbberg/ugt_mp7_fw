
-- Desciption:
-- Data clock domain change (240MHz to 40MHz)

library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.VComponents.all;

use work.mp7_data_types.all;
use work.gt_mp7_core_pkg.all;

entity data_cdc is
    port(
        clk240 : in std_logic;
        lhc_clk : in std_logic;
        data_in : in lword;
        data_o : out lane_objects_array_t
    );
end data_cdc;

architecture rtl of data_cdc is

-- OBJECTS_PER_LANE (CLOCK_RATIO) = number of 240MHz frames per lane (link)
  type lword_array is array (OBJECTS_PER_LANE-1 downto 0) of lword;       
  signal data_240mhz : lword_array;

begin

-- With 0x50bc in data, suppressing is done (= 0)
  data_240mhz(0).data   <= (others => '0') when data_in.valid = '0' else data_in.data;
  data_240mhz(0).valid  <= data_in.valid;
  data_240mhz(0).strobe <= data_in.strobe;
  data_240mhz(0).start  <= data_in.start;

-- Pipeline for data (240MHz) coming from MP7 logic (mp7_datapath [GTHs])
  data_240mhz_p: process(clk240, data_240mhz(0))
  begin
    for i in 0 to (OBJECTS_PER_LANE-1)-1 loop
      if (clk'event and clk = '1') then
	data_240mhz(i+1) <= data_240mhz(i);
      end if;
    end loop;
  end process;

-- Clock domain change (240MHz to 40MHz)
  data_40mhz_p: process(lhc_clk, data_240mhz)
  begin
    if lhc_clk'event and lhc_clk = '1' then
--       data_o <= (data_240mhz(0).data, data_240mhz(1).data, data_240mhz(2).data, data_240mhz(3).data, data_240mhz(4).data, data_240mhz(5).data);
      for i in 0 to (OBJECTS_PER_LANE-1)-1 loop
	data_o(i) <= data_240mhz(i).data;
      end loop;
    end if;
  end process;
  
end architecture rtl;
