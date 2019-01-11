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

entity cosh_deta_lut is
    generic(
        N_OBJ_1 : positive;
        N_OBJ_2 : positive;
        COSH_COS_WIDTH : positive;
        OBJ_CORR : obj_corr_type
    );
    port(
        sub_eta : in dim2_max_eta_range_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1);
        cosh_deta_o : out cosh_cos_vector_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1) := (others => (others => (others => '0')))
    );
end cosh_deta_lut;

architecture rtl of cosh_deta_lut is

begin

    loop_1: for i in 0 to N_OBJ_1-1 generate
        loop_2: for j in 0 to N_OBJ_2-1 generate
            calo_calo_i: if (OBJ_CORR = calo_calo) generate
                cosh_deta_o(i,j)(CALO_CALO_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_CALO_COSH_DETA_LUT(sub_eta(i,j)), CALO_CALO_COSH_COS_VECTOR_WIDTH);
            end generate calo_calo_i;
            calo_muon_i: if (OBJ_CORR = calo_muon) generate
                cosh_deta_o(i,j)(CALO_MUON_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_MUON_COSH_DETA_LUT(sub_eta(i,j)), CALO_MUON_COSH_COS_VECTOR_WIDTH);
            end generate calo_muon_i;
            muon_muon_i: if (OBJ_CORR = muon_muon) generate
                cosh_deta_o(i,j)(MUON_MUON_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MU_MU_COSH_DETA_LUT(sub_eta(i,j)), MUON_MUON_COSH_COS_VECTOR_WIDTH);
            end generate muon_muon_i;
        end generate loop_2;
    end generate loop_1;
                    
end architecture rtl;
