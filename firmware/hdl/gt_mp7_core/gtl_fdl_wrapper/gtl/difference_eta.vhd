-- Description:
-- Differences in eta.

-- Version-history:
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;

-- used for integer function
use ieee.std_logic_arith.all;
-- use ieee.numeric_std.all;

use work.gtl_pkg.all;

entity difference_eta is
    generic (
        CONF : differences_conf;
        CALO_CALO_LUT : calo_calo_diff_eta_lut_array;
        CALO_MUON_LUT : calo_muon_diff_eta_lut_array;
        MUON_MUON_LUT : muon_muon_diff_phi_lut_array;
        CALO_CALO_COSH_COS_LUT : calo_CALO_cosh_deta_lut_array;
        CALO_MUON_COSH_COS_LUT : calo_muon_cosh_deta_lut_array;
        MUON_MUON_COSH_COS_LUT : muon_muon_cosh_deta_lut_array
    );
    port(
        clk : in std_logic;
        in_1 : in diff_integer_inputs_array(0 to CONF.NR_OBJ_1-1);
        in_2 : in diff_integer_inputs_array(0 to CONF.NR_OBJ_2-1);
        diff_vector_o : out deta_dphi_vector_array(0 to CONF.NR_OBJ_1-1, 0 to CONF.NR_OBJ_2-1) := (others => (others => (others => '0')));
        cosh_deta_vector_o : out cosh_cos_vector_array(0 to CONF.NR_OBJ_1-1, 0 to CONF.NR_OBJ_2-1) := (others => (others => (others => '0')))
    );
end difference_eta;

architecture rtl of difference_eta is

    signal diff_i : dim2_max_eta_range_array(0 to CONF.NR_OBJ_1-1, 0 to CONF.NR_OBJ_2-1);
    signal diff_vector_i : deta_dphi_vector_array(0 to CONF.NR_OBJ_1-1, 0 to CONF.NR_OBJ_2-1);
    signal cosh_deta_vector_i : cosh_cos_vector_array(0 to CONF.NR_OBJ_1-1, 0 to CONF.NR_OBJ_2-1);
    constant COSH_COS_VECTOR_WIDTH : positive;
    
begin

    loop_1: for i in 0 to CONF.NR_OBJ_1-1 generate
        loop_2: for j in 0 to CONF.NR_OBJ_2-1 generate
-- only positive difference in eta
            diff_i(i,j) <= abs(in_1(i) - in_2(j));
            calo_calo_i: if (CONF.OBJ_CORR = calo_calo) generate
                diff_vector_i(i,j) <= CONV_STD_LOGIC_VECTOR(CALO_CALO_LUT(diff_i(i,j)), DETA_DPHI_VECTOR_WIDTH_ALL);
                cosh_deta_vector_i(i,j) <= CONV_STD_LOGIC_VECTOR(CALO_CALO_COSH_COS_LUT(diff_i(i,j)), CALO_CALO_COSH_COS_VECTOR_WIDTH);
                COSH_COS_VECTOR_WIDTH <= CALO_CALO_COSH_COS_VECTOR_WIDTH;
            end generate calo_calo_i;
            calo_muon_i: if (CONF.OBJ_CORR = calo_muon) generate
                diff_vector_i(i,j) <= CONV_STD_LOGIC_VECTOR(CALO_MUON_LUT(diff_i(i,j)), DETA_DPHI_VECTOR_WIDTH_ALL);
                cosh_deta_vector_i(i,j) <= CONV_STD_LOGIC_VECTOR(CALO_MUON_COSH_COS_LUT(diff_i(i,j)), CALO_MUON_COSH_COS_VECTOR_WIDTH);
                COSH_COS_VECTOR_WIDTH <= CALO_MUON_COSH_COS_VECTOR_WIDTH;
            end generate calo_muon_i;
            muon_muon_i: if (CONF.OBJ_CORR = muon_muon) generate
                diff_vector_i(i,j) <= CONV_STD_LOGIC_VECTOR(MUON_MUON_LUT(diff_i(i,j)), DETA_DPHI_VECTOR_WIDTH_ALL);
                cosh_deta_vector_i(i,j) <= CONV_STD_LOGIC_VECTOR(MUON_MUON_COSH_COS_LUT(diff_i(i,j)), MUON_MUON_COSH_COS_VECTOR_WIDTH);
                COSH_COS_VECTOR_WIDTH <= MUON_MUON_COSH_COS_VECTOR_WIDTH;
            end generate muon_muon_i;
            out_reg_diff_i : entity work.out_reg_mux
                generic map(DETA_DPHI_VECTOR_WIDTH_ALL, CONF.OUT_REG);  
                port map(clk, diff_vector_i(i,j), diff_vector_o(i,j)); 
            out_reg_cosh_deta_i : entity work.out_reg_mux               
                generic map(COSH_COS_VECTOR_WIDTH, CONF.OUT_REG);  
                port map(clk, cosh_deta_vector_i(i,j), cosh_deta_vector_o(i,j)); 
        end generate loop_2;
    end generate loop_1;
    
end architecture rtl;
