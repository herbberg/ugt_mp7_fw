-- Description:
-- Comparators for object cuts comparisons (except with LUTs).

-- Version-history:
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;

-- used for CONV_INTEGER
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;

entity comparator_muon_charge_corr is
    generic(
        CONF : comparator_muon_charge_corr_conf;
        REQ : string(1 to 2)
    );
    port(
        clk : in std_logic;
        cc_double: in muon_cc_double_array := (others => (others => (others => '0')));
        cc_triple: in muon_cc_triple_array := (others => (others => (others => (others => '0'))));
        cc_quad: in muon_cc_quad_array := (others => (others => (others => (others => (others => '0')))));
        comp_o_double : out std_logic_2dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1);
        comp_o_triple : out std_logic_3dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1);
        comp_o_quad : out std_logic_4dim_array(0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1)
    );
end comparator_muon_charge_corr;

architecture rtl of comparator_muon_charge_corr is

    type comp_i_double_array is array (0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) of std_logic_vector(0 downto 0);
    type comp_i_triple_array is array (0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) of std_logic_vector(0 downto 0);
    type comp_i_quad_array is array (0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1, 0 to NR_MUON_OBJECTS-1) of std_logic_vector(0 downto 0);
    signal comp_i_double : comp_i_double_array := (others => (others => (others => '0')));
    signal comp_r_double : comp_i_double_array;
    signal comp_i_triple : comp_i_triple_array := (others => (others => (others => (others => '0'))));
    signal comp_r_triple : comp_i_triple_array;
    signal comp_i_quad : comp_i_quad_array := (others => (others => (others => (others => (others => '0')))));
    signal comp_r_quad : comp_i_quad_array;

begin

    l1: for i in 0 to NR_MUON_OBJECTS-1 generate
        l2: for j in 0 to NR_MUON_OBJECTS-1 generate
            comp_i_double(i,j)(0) <= '1' when (((cc_double(i,j) = CC_LS) and (REQ = "LS")) or ((cc_double(i,j) = CC_OS) and (REQ = "OS"))) else '0';
            out_reg_i : entity work.out_reg_mux
                generic map(1, CONF.OUT_REG)  
                port map(clk, comp_i_double(i,j), comp_r_double(i,j));
            comp_o_double(i,j) <= comp_r_double(i,j)(0);
            l3: for k in 0 to NR_MUON_OBJECTS-1 generate
                comp_i_triple(i,j,k)(0) <= '1' when (((cc_triple(i,j,k) = CC_LS) and (REQ = "LS")) or ((cc_triple(i,j,k) = CC_OS) and (REQ = "OS"))) else '0';
                out_reg_i : entity work.out_reg_mux
                    generic map(1, CONF.OUT_REG)  
                    port map(clk, comp_i_triple(i,j,k), comp_r_triple(i,j,k));
                comp_o_triple(i,j,k) <= comp_r_triple(i,j,k)(0);
                l4: for l in 0 to NR_MUON_OBJECTS-1 generate
                    comp_i_quad(i,j,k,l)(0) <= '1' when (((cc_quad(i,j,k,l) = CC_LS) and (REQ = "LS")) or ((cc_quad(i,j,k,l) = CC_OS) and (REQ = "OS"))) else '0';
                    out_reg_i : entity work.out_reg_mux
                        generic map(1, CONF.OUT_REG)  
                        port map(clk, comp_i_quad(i,j,k,l), comp_r_quad(i,j,k,l));
                    comp_o_quad(i,j,k,l) <= comp_r_quad(i,j,k,l)(0);
                end generate l4;
            end generate l3;
        end generate l2;
    end generate l1;

end architecture rtl;
