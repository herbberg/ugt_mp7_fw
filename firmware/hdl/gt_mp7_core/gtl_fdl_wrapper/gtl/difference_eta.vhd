-- Description:
-- Differences in eta.

-- Version-history:
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;

-- used for CONV_STD_LOGIC_VECTOR
use ieee.std_logic_arith.all;
-- used for CONV_INTEGER
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;
use work.lut_pkg.all;

entity difference_eta is
    generic(
        N_OBJ_1 : positive;
        N_OBJ_2 : positive;
        COSH_COS_WIDTH : positive;
        OBJ_CORR : obj_corr_type
    );
    port(
        clk : in std_logic;
        eta_1 : in integer_array(0 to N_OBJ_1-1);
        eta_2 : in integer_array(0 to N_OBJ_2-1);
        diff_eta_o : out deta_dphi_vector_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1) := (others => (others => (others => '0')));
        cosh_deta_o : out cosh_cos_vector_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1) := (others => (others => (others => '0')))
    );
end difference_eta;

architecture rtl of difference_eta is

    signal diff_i : dim2_max_eta_range_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1);
   
begin

    loop_1: for i in 0 to N_OBJ_1-1 generate
        loop_2: for j in 0 to N_OBJ_2-1 generate
-- only positive difference in eta
            diff_i(i,j) <= abs(eta_1(i) - eta_2(j));
            calo_calo_i: if (OBJ_CORR = calo_calo) generate
                diff_eta_o(i,j) <= CONV_STD_LOGIC_VECTOR(CALO_CALO_DIFF_ETA_LUT(diff_i(i,j)), DETA_DPHI_VECTOR_WIDTH);
                cosh_deta_o(i,j)(CALO_CALO_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_CALO_COSH_DETA_LUT(diff_i(i,j)), CALO_CALO_COSH_COS_VECTOR_WIDTH);
            end generate calo_calo_i;
            calo_muon_i: if (OBJ_CORR = calo_muon) generate
                diff_eta_o(i,j) <= CONV_STD_LOGIC_VECTOR(CALO_MU_DIFF_ETA_LUT(diff_i(i,j)), DETA_DPHI_VECTOR_WIDTH);
                cosh_deta_o(i,j)(CALO_MUON_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_MUON_COSH_DETA_LUT(diff_i(i,j)), CALO_MUON_COSH_COS_VECTOR_WIDTH);
            end generate calo_muon_i;
            muon_muon_i: if (OBJ_CORR = muon_muon) generate
                diff_eta_o(i,j) <= CONV_STD_LOGIC_VECTOR(MU_MU_DIFF_ETA_LUT(diff_i(i,j)), DETA_DPHI_VECTOR_WIDTH);
                cosh_deta_o(i,j)(MUON_MUON_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MU_MU_COSH_DETA_LUT(diff_i(i,j)), MUON_MUON_COSH_COS_VECTOR_WIDTH);
            end generate muon_muon_i;
        end generate loop_2;
    end generate loop_1;
                    
end architecture rtl;
