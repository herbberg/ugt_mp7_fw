
-- Description: 
-- Data clock domain change (240MHz to 40MHz) and lane mapping process

library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.VComponents.all;

use work.mp7_data_types.all;
use work.gt_mp7_core_pkg.all;

entity data_cdc_lmp is
  generic
  (
    NR_LANES: positive
  );
  port(
    clk240 : in std_logic;
    lhc_clk : in std_logic;
    data_in : in ldata(NR_LANES-1 downto 0); -- 240MHZ
    data_o : out lhc_data_t
  );
end data_cdc_lmp;

architecture rtl of data_cdc_lmp is

-- update for better names - to be done !!!
  constant N_MUON_WORDS : positive := 2;
  constant N_MUON_LANES_PER_OBJ : positive := 2;
  constant MUON_OBJ_OFFSET : positive := 2;
  constant N_MUON_OBJ_PER_LANE : positive := N_MUON_OBJECTS/N_MUON_LANES_PER_OBJ; -- => 8/2=4
  constant N_CALO_LANES_PER_OBJ_TYPE : positive := 2;
  constant N_CALO_OBJ_PER_LANE : positive := MAX_CALO_OBJECTS/N_CALO_LANES_PER_OBJ_TYPE; -- => 12/2=6
  constant N_EXT_COND_WORDS : positive := 2;
  constant N_EXT_COND_LANES : positive := EXTERNAL_CONDITIONS_DATA_WIDTH/64; -- => 4
  
  type data_cdc_out_array is array (NR_LANES-1 downto 0) of lane_objects_array_t;
  signal data_40mhz : data_cdc_out_array;
   
begin

-- Data clock domain change
  data_cdc_l: for i in 0 to NR_LANES-1 generate
    data_cdc_i: entity work.data_cdc
      port map(clk240, lhc_clk, data_in(i), data_40mhz(i));
  end generate;
  
-- Data lane mapping process

-- HEPHY 2015-05-20: changed lane mapping for muons 0,1,2,3 to 2,3,4,5 of 240MHz objects (offset = 2).
  muon_lmp_p: process(data_40mhz)
  begin
    for i in 0 to N_MUON_OBJ_PER_LANE-1 loop
--     for i in 0 to 3 loop
      for j in 0 to N_MUON_LANES_PER_OBJ-1 loop
--       for j in 0 to 1 loop
	for k in 0 to N_MUON_WORDS-1 loop
-- 	for k in 0 to 1 loop
	  data_o.muon(i*N_MUON_OBJ_PER_LANE+j)(k*32+31 downto k*32) <= data_40mhz(OFFSET_MUON_LANES+i)(j*N_MUON_WORDS+k+MUON_OBJ_OFFSET);
-- 	  data_o.muon(i*2+j)(k*32+31 downto k*32)  <= data_40mhz(OFFSET_MUON_LANES+i)(j*2+k+2);
	end loop;
      end loop;
    end loop;
  end process;

-- data_o.muon(0)(31 downto 0)  <= data_40mhz(OFFSET_MUON_LANES+0)(2);
-- data_o.muon(0)(63 downto 32) <= data_40mhz(OFFSET_MUON_LANES+0)(3);
-- data_o.muon(1)(31 downto 0)  <= data_40mhz(OFFSET_MUON_LANES+0)(4);
-- data_o.muon(1)(63 downto 32) <= data_40mhz(OFFSET_MUON_LANES+0)(5);
-- data_o.muon(2)(31 downto 0)  <= data_40mhz(OFFSET_MUON_LANES+1)(2);
-- data_o.muon(2)(63 downto 32) <= data_40mhz(OFFSET_MUON_LANES+1)(3);
-- data_o.muon(3)(31 downto 0)  <= data_40mhz(OFFSET_MUON_LANES+1)(4);
-- data_o.muon(3)(63 downto 32) <= data_40mhz(OFFSET_MUON_LANES+1)(5);
-- data_o.muon(4)(31 downto 0)  <= data_40mhz(OFFSET_MUON_LANES+2)(2);
-- data_o.muon(4)(63 downto 32) <= data_40mhz(OFFSET_MUON_LANES+2)(3);
-- data_o.muon(5)(31 downto 0)  <= data_40mhz(OFFSET_MUON_LANES+2)(4);
-- data_o.muon(5)(63 downto 32) <= data_40mhz(OFFSET_MUON_LANES+2)(5);
-- data_o.muon(6)(31 downto 0)  <= data_40mhz(OFFSET_MUON_LANES+3)(2);
-- data_o.muon(6)(63 downto 32) <= data_40mhz(OFFSET_MUON_LANES+3)(3);
-- data_o.muon(7)(31 downto 0)  <= data_40mhz(OFFSET_MUON_LANES+3)(4);
-- data_o.muon(7)(63 downto 32) <= data_40mhz(OFFSET_MUON_LANES+3)(5);

-- calo data
  calo_lmp_p: process(data_40mhz)
  begin
    for i in 0 to N_CALO_LANES_PER_OBJ_TYPE-1 loop
--     for i in 0 to 1 loop
      for j in 0 to N_CALO_OBJ_PER_LANE-1 loop
--       for j in 0 to 5 loop
	data_o.eg(i*N_CALO_OBJ_PER_LANE+j) <= data_40mhz(OFFSET_EG_LANES+i)(i*N_CALO_OBJ_PER_LANE+j);
	data_o.jet(i*N_CALO_OBJ_PER_LANE+j) <= data_40mhz(OFFSET_JET_LANES+i)(i*N_CALO_OBJ_PER_LANE+j);
	data_o.tau(i*N_CALO_OBJ_PER_LANE+j) <= data_40mhz(OFFSET_TAU_LANES+i)(i*N_CALO_OBJ_PER_LANE+j);
-- 	data_o.eg(i*6+j) <= data_40mhz(OFFSET_EG_LANES+i)(i*6+j);
-- 	data_o.jet(i*6+j) <= data_40mhz(OFFSET_JET_LANES+i)(i*6+j);
-- 	data_o.tau(i*6+j) <= data_40mhz(OFFSET_TAU_LANES+i)(i*6+j);
      end loop;
    end loop;
  end process;
  
-- -- eg data
-- data_o.eg(0)  <= data_40mhz(OFFSET_EG_LANES+0)(0);
-- data_o.eg(1)  <= data_40mhz(OFFSET_EG_LANES+0)(1);
-- data_o.eg(2)  <= data_40mhz(OFFSET_EG_LANES+0)(2);
-- data_o.eg(3)  <= data_40mhz(OFFSET_EG_LANES+0)(3);
-- data_o.eg(4)  <= data_40mhz(OFFSET_EG_LANES+0)(4);
-- data_o.eg(5)  <= data_40mhz(OFFSET_EG_LANES+0)(5);
-- data_o.eg(6)  <= data_40mhz(OFFSET_EG_LANES+1)(0);
-- data_o.eg(7)  <= data_40mhz(OFFSET_EG_LANES+1)(1);
-- data_o.eg(8)  <= data_40mhz(OFFSET_EG_LANES+1)(2);
-- data_o.eg(9)  <= data_40mhz(OFFSET_EG_LANES+1)(3);
-- data_o.eg(10) <= data_40mhz(OFFSET_EG_LANES+1)(4);
-- data_o.eg(11) <= data_40mhz(OFFSET_EG_LANES+1)(5);
-- 
-- -- jet data
-- data_o.jet(0)  <= data_40mhz(OFFSET_JET_LANES+0)(0);
-- data_o.jet(1)  <= data_40mhz(OFFSET_JET_LANES+0)(1);
-- data_o.jet(2)  <= data_40mhz(OFFSET_JET_LANES+0)(2);
-- data_o.jet(3)  <= data_40mhz(OFFSET_JET_LANES+0)(3);
-- data_o.jet(4)  <= data_40mhz(OFFSET_JET_LANES+0)(4);
-- data_o.jet(5)  <= data_40mhz(OFFSET_JET_LANES+0)(5);
-- data_o.jet(6)  <= data_40mhz(OFFSET_JET_LANES+1)(0);
-- data_o.jet(7)  <= data_40mhz(OFFSET_JET_LANES+1)(1);
-- data_o.jet(8)  <= data_40mhz(OFFSET_JET_LANES+1)(2);
-- data_o.jet(9)  <= data_40mhz(OFFSET_JET_LANES+1)(3);
-- data_o.jet(10) <= data_40mhz(OFFSET_JET_LANES+1)(4);
-- data_o.jet(11) <= data_40mhz(OFFSET_JET_LANES+1)(5);
-- 
-- -- tau data
-- data_o.tau(0)  <= data_40mhz(OFFSET_TAU_LANES+0)(0);
-- data_o.tau(1)  <= data_40mhz(OFFSET_TAU_LANES+0)(1);
-- data_o.tau(2)  <= data_40mhz(OFFSET_TAU_LANES+0)(2);
-- data_o.tau(3)  <= data_40mhz(OFFSET_TAU_LANES+0)(3);
-- data_o.tau(4)  <= data_40mhz(OFFSET_TAU_LANES+0)(4);
-- data_o.tau(5)  <= data_40mhz(OFFSET_TAU_LANES+0)(5);
-- data_o.tau(6)  <= data_40mhz(OFFSET_TAU_LANES+1)(0);
-- data_o.tau(7)  <= data_40mhz(OFFSET_TAU_LANES+1)(1);
-- -- HB 2016-10-17: or memory structure with all frames of calo links for extended test-vector-file structure (see data_pkg.vhd)
-- data_o.tau(8)  <= data_40mhz(OFFSET_TAU_LANES+1)(2);
-- data_o.tau(9)  <= data_40mhz(OFFSET_TAU_LANES+1)(3);
-- data_o.tau(10)  <= data_40mhz(OFFSET_TAU_LANES+1)(4);
-- data_o.tau(11)  <= data_40mhz(OFFSET_TAU_LANES+1)(5);

-- Esums data
  data_o.ett <= data_40mhz(OFFSET_ESUMS_LANES)(0);
  data_o.ht <= data_40mhz(OFFSET_ESUMS_LANES)(1);
  data_o.etm <= data_40mhz(OFFSET_ESUMS_LANES)(2);
  data_o.htm <= data_40mhz(OFFSET_ESUMS_LANES)(3);
  data_o.etmhf <= data_40mhz(OFFSET_ESUMS_LANES)(4);
  data_o.htmhf <= data_40mhz(OFFSET_ESUMS_LANES)(5);

-- Spare link 11
  data_o.link_11_fr_0_data <= data_40mhz(OFFSET_LINK_11_LANES)(0);
  data_o.link_11_fr_1_data <= data_40mhz(OFFSET_LINK_11_LANES)(1);
  data_o.link_11_fr_2_data <= data_40mhz(OFFSET_LINK_11_LANES)(2);
  data_o.link_11_fr_3_data <= data_40mhz(OFFSET_LINK_11_LANES)(3);
  data_o.link_11_fr_4_data <= data_40mhz(OFFSET_LINK_11_LANES)(4);
  data_o.link_11_fr_5_data <= data_40mhz(OFFSET_LINK_11_LANES)(5);

-- External condition data
  ext_cond_lmp_p: process(data_40mhz)
    variable index : natural := 0;
  begin
    index := 0;
    for i in 0 to N_EXT_COND_LANES-1 loop
--     for i in 0 to 3 loop
      for j in 0 to N_EXT_COND_WORDS-1 loop
--       for j in 0 to 1 loop
	data_o.external_conditions(index*32+31 downto index*32) <= data_40mhz(OFFSET_EXT_COND_LANES+i)(j);
	index := index + 1;
      end loop;
    end loop;
  end process;
  
-- -- HEPHY 2015-05-01: added external-conditions.
-- data_o.external_conditions(31 downto 0) <= data_40mhz(OFFSET_EXT_COND_LANES+0)(0);
-- data_o.external_conditions(63 downto 32) <= data_40mhz(OFFSET_EXT_COND_LANES+0)(1);
-- data_o.external_conditions(95 downto 64) <= data_40mhz(OFFSET_EXT_COND_LANES+1)(0);
-- data_o.external_conditions(127 downto 96) <= data_40mhz(OFFSET_EXT_COND_LANES+1)(1);
-- data_o.external_conditions(159 downto 128) <= data_40mhz(OFFSET_EXT_COND_LANES+2)(0);
-- data_o.external_conditions(191 downto 160) <= data_40mhz(OFFSET_EXT_COND_LANES+2)(1);
-- data_o.external_conditions(223 downto 192) <= data_40mhz(OFFSET_EXT_COND_LANES+3)(0);
-- data_o.external_conditions(255 downto 224) <= data_40mhz(OFFSET_EXT_COND_LANES+3)(1);

end architecture rtl;
