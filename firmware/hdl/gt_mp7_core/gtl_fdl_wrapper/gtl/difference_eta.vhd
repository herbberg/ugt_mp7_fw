-- Description:
-- Differences in eta.

-- Version-history:
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;

-- used for CONV_STD_LOGIC_VECTOR
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity difference_eta is
    generic (
        CONF : differences_conf
    );
    port(
        clk : in std_logic;
        eta_1 : in diff_integer_inputs_array(0 to CONF.N_OBJ_1-1);
        eta_2 : in diff_integer_inputs_array(0 to CONF.N_OBJ_2-1);
        diff_eta_o : out std_logic_3dim_array(0 to CONF.N_OBJ_1-1, 0 to CONF.N_OBJ_2-1, 0 to CONF.DIFF_WIDTH-1);
        cosh_deta_o : out std_logic_3dim_array(0 to CONF.N_OBJ_1-1, 0 to CONF.N_OBJ_2-1, 0 to CONF.COSH_COS_WIDTH-1)
    );
end difference_eta;

architecture rtl of difference_eta is

    signal diff_i : dim2_max_eta_range_array(0 to CONF.N_OBJ_1-1, 0 to CONF.N_OBJ_2-1);
    signal diff_eta_vector_i : deta_dphi_vector_array(0 to CONF.N_OBJ_1-1, 0 to CONF.N_OBJ_2-1) := (others => (others => (others => '0')));
    signal cosh_deta_vector_i : cosh_cos_vector_array(0 to CONF.N_OBJ_1-1, 0 to CONF.N_OBJ_2-1) := (others => (others => (others => '0')));
    
begin

    loop_1: for i in 0 to CONF.N_OBJ_1-1 generate
        loop_2: for j in 0 to CONF.N_OBJ_2-1 generate
-- only positive difference in eta
            diff_i(i,j) <= abs(eta_1(i) - eta_2(j));
            calo_calo_i: if (CONF.OBJ_CORR = calo_calo) generate
                diff_eta_vector_i(i,j) <= CONV_STD_LOGIC_VECTOR(CALO_CALO_DIFF_ETA_LUT(diff_i(i,j)), DETA_DPHI_VECTOR_WIDTH_ALL);
                cosh_deta_vector_i(i,j)(CALO_CALO_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_CALO_COSH_DETA_LUT(diff_i(i,j)), CALO_CALO_COSH_COS_VECTOR_WIDTH);
            end generate calo_calo_i;
            calo_muon_i: if (CONF.OBJ_CORR = calo_muon) generate
                diff_eta_vector_i(i,j) <= CONV_STD_LOGIC_VECTOR(CALO_MU_DIFF_ETA_LUT(diff_i(i,j)), DETA_DPHI_VECTOR_WIDTH_ALL);
                cosh_deta_vector_i(i,j)(CALO_MUON_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_MUON_COSH_DETA_LUT(diff_i(i,j)), CALO_MUON_COSH_COS_VECTOR_WIDTH);
            end generate calo_muon_i;
            muon_muon_i: if (CONF.OBJ_CORR = muon_muon) generate
                diff_eta_vector_i(i,j) <= CONV_STD_LOGIC_VECTOR(MU_MU_DIFF_ETA_LUT(diff_i(i,j)), DETA_DPHI_VECTOR_WIDTH_ALL);
                cosh_deta_vector_i(i,j)(MUON_MUON_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MU_MU_COSH_DETA_LUT(diff_i(i,j)), MUON_MUON_COSH_COS_VECTOR_WIDTH);
            end generate muon_muon_i;
            out_loop_diff: for k in 0 to CONF.DIFF_WIDTH-1 generate 
                out_reg_diff_i : entity work.out_reg_mux
                    generic map(1, CONF.OUT_REG)  
                    port map(clk, diff_eta_vector_i(i,j)(k), diff_eta_o(i,j,k)); 
            end generate out_loop_diff;
            out_loop_cosh_cos: for k in 0 to CONF.COSH_COS_WIDTH-1 generate 
                out_reg_cosh_deta_i : entity work.out_reg_mux               
                    generic map(1, CONF.OUT_REG)  
                    port map(clk, cosh_deta_vector_i(i,j)(k), cosh_deta_o(i,j,k)); 
            end generate out_loop_cosh_cos;
        end generate loop_2;
    end generate loop_1;
    
end architecture rtl;
