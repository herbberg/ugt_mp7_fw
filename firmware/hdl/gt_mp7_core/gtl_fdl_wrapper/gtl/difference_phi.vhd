-- Description:
-- Differences in phi.

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

entity difference_phi is
    generic(
        N_OBJ_1 : positive;
        N_OBJ_2 : positive;
        PHI_HALF_RANGE : positive;
        COSH_COS_WIDTH : positive;
        OBJ_CORR : obj_corr_type
    );
    port(
        clk : in std_logic;
        phi_1 : in integer_array(0 to N_OBJ_1-1);
        phi_2 : in integer_array(0 to N_OBJ_2-1);
        diff_phi_o : out deta_dphi_vector_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1) := (others => (others => (others => '0')));
        cos_dphi_o : out cosh_cos_vector_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1) := (others => (others => (others => '0')))
    );
end difference_phi;

architecture rtl of difference_phi is

    signal diff_temp : dim2_max_phi_range_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1);
    signal diff_i : dim2_max_phi_range_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1);
    
begin
    
    loop_1: for i in 0 to N_OBJ_1-1 generate
        loop_2: for j in 0 to N_OBJ_2-1 generate
            diff_temp(i,j) <= abs(phi_1(i) - phi_2(j));
            diff_i(i,j) <= diff_temp(i,j) when (diff_temp(i,j) < PHI_HALF_RANGE) else (PHI_HALF_RANGE*2-diff_temp(i,j));
            calo_calo_i: if ((OBJ_CORR = calo_calo) or (OBJ_CORR = calo_esums)) generate
                diff_phi_o(i,j) <= CONV_STD_LOGIC_VECTOR(CALO_CALO_DIFF_PHI_LUT(diff_i(i,j)), DETA_DPHI_VECTOR_WIDTH_ALL);
                cos_dphi_o(i,j)(CALO_CALO_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_CALO_COS_DPHI_LUT(diff_i(i,j)), CALO_CALO_COSH_COS_VECTOR_WIDTH);
            end generate calo_calo_i;
            calo_muon_i: if ((OBJ_CORR = calo_muon) or (OBJ_CORR = muon_esums)) generate
                diff_phi_o(i,j) <= CONV_STD_LOGIC_VECTOR(CALO_MU_DIFF_PHI_LUT(diff_i(i,j)), DETA_DPHI_VECTOR_WIDTH_ALL);
                cos_dphi_o(i,j)(CALO_MUON_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_MUON_COS_DPHI_LUT(diff_i(i,j)), CALO_MUON_COSH_COS_VECTOR_WIDTH);
            end generate calo_muon_i;
            muon_muon_i: if (OBJ_CORR = muon_muon) generate
                diff_phi_o(i,j) <= CONV_STD_LOGIC_VECTOR(MU_MU_DIFF_PHI_LUT(diff_i(i,j)), DETA_DPHI_VECTOR_WIDTH_ALL);
                cos_dphi_o(i,j)(MUON_MUON_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MUON_MUON_COS_DPHI_LUT(diff_i(i,j)), MUON_MUON_COSH_COS_VECTOR_WIDTH);
            end generate muon_muon_i;
        end generate loop_2;
    end generate loop_1;

end architecture rtl;
