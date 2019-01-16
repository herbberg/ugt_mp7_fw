-- Description:
-- Conversion logic.

-- Version-history:
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;

-- used for CONV_STD_LOGIC_VECTOR
use ieee.std_logic_arith.all;
-- used for CONV_INTEGER
use ieee.std_logic_unsigned.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;
use work.lut_pkg.all;

entity conversions is
    generic(
        N_OBJ : natural;
        OBJ_T : obj_type
    );
    port(
        pt : in obj_parameter_array;
        eta : in obj_parameter_array;
        phi : in obj_parameter_array;
        pt_vector : out pt_vector_array(0 to N_OBJ-1) := (others => (others => '0'));
        cos_phi : out integer_array(0 to N_OBJ-1) := (others => 0);
        sin_phi : out integer_array(0 to N_OBJ-1) := (others => 0);
        conv_mu_cos_phi : out integer_array(0 to N_OBJ-1) := (others => 0);
        conv_mu_sin_phi : out integer_array(0 to N_OBJ-1) := (others => 0);
        conv_2_muon_eta_integer : out integer_array(0 to N_OBJ-1) := (others => 0);
        conv_2_muon_phi_integer : out integer_array(0 to N_OBJ-1) := (others => 0);
        eta_integer : out integer_array(0 to N_OBJ-1) := (others => 0);
        phi_integer : out integer_array(0 to N_OBJ-1) := (others => 0)
    );
end conversions;

architecture rtl of conversions is

    type pt_i_array is array (0 to N_OBJ-1) of std_logic_vector(MAX_PT_WIDTH-1 downto 0);
    signal pt_i : pt_i_array := (others => (others => '0'));
    type eta_i_array is array (0 to N_OBJ-1) of std_logic_vector(MAX_ETA_WIDTH-1 downto 0);
    signal eta_i : eta_i_array := (others => (others => '0'));
    type phi_i_array is array (0 to N_OBJ-1) of std_logic_vector(MAX_PHI_WIDTH-1 downto 0);
    signal phi_i : phi_i_array := (others => (others => '0'));
    
    signal conv_2_muon_phi_integer_i : integer_array(0 to N_OBJ-1) := (others => 0);
        
begin

    obj_loop: for i in 0 to N_OBJ-1 generate
        calo_i: if ((OBJ_T = eg) or (OBJ_T = jet) or (OBJ_T = tau)) generate
            eg_i: if (OBJ_T = eg) generate
                pt_i(i)(EG_PT_HIGH-EG_PT_LOW downto 0) <= pt(i)(EG_PT_HIGH-EG_PT_LOW downto 0); 
                eta_i(i)(EG_ETA_HIGH-EG_ETA_LOW downto 0) <= eta(i)(EG_ETA_HIGH-EG_ETA_LOW downto 0); 
                phi_i(i)(EG_PHI_HIGH-EG_PHI_LOW downto 0) <= phi(i)(EG_PHI_HIGH-EG_PHI_LOW downto 0); 
                pt_vector(i)(EG_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(EG_PT_LUT(CONV_INTEGER(pt_i(i))), EG_PT_VECTOR_WIDTH);
            end generate eg_i;
            jet_i: if (OBJ_T = jet) generate
                pt_i(i)(JET_PT_HIGH-JET_PT_LOW downto 0) <= pt(i)(JET_PT_HIGH-JET_PT_LOW downto 0); 
                eta_i(i)(JET_ETA_HIGH-JET_ETA_LOW downto 0) <= eta(i)(JET_ETA_HIGH-JET_ETA_LOW downto 0); 
                phi_i(i)(JET_PHI_HIGH-JET_PHI_LOW downto 0) <= phi(i)(JET_PHI_HIGH-JET_PHI_LOW downto 0); 
                pt_vector(i)(JET_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(JET_PT_LUT(CONV_INTEGER(pt_i(i))), JET_PT_VECTOR_WIDTH);
            end generate jet_i;
            tau_i: if (OBJ_T = tau) generate
                pt_i(i)(TAU_PT_HIGH-TAU_PT_LOW downto 0) <= pt(i)(TAU_PT_HIGH-TAU_PT_LOW downto 0); 
                eta_i(i)(TAU_ETA_HIGH-TAU_ETA_LOW downto 0) <= eta(i)(TAU_ETA_HIGH-TAU_ETA_LOW downto 0); 
                phi_i(i)(TAU_PHI_HIGH-TAU_PHI_LOW downto 0) <= phi(i)(TAU_PHI_HIGH-TAU_PHI_LOW downto 0); 
                pt_vector(i)(TAU_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(TAU_PT_LUT(CONV_INTEGER(pt_i(i))), TAU_PT_VECTOR_WIDTH);
            end generate tau_i;       
            cos_phi(i) <= CALO_COS_PHI_LUT(CONV_INTEGER(phi_i(i)));
            sin_phi(i) <= CALO_SIN_PHI_LUT(CONV_INTEGER(phi_i(i)));
            conv_2_muon_phi_integer_i(i) <= CALO_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(phi_i(i)));
            conv_mu_cos_phi(i) <= MUON_COS_PHI_LUT(conv_2_muon_phi_integer_i(i));
            conv_mu_sin_phi(i) <= MUON_SIN_PHI_LUT(conv_2_muon_phi_integer_i(i));
            conv_2_muon_eta_integer(i) <= CALO_ETA_CONV_2_MUON_ETA_LUT(CONV_INTEGER(eta_i(i)));
            conv_2_muon_phi_integer(i) <= conv_2_muon_phi_integer_i(i);
        end generate calo_i;
        muon_i: if (OBJ_T = muon) generate
                pt_i(i)(MUON_PT_HIGH-MUON_PT_LOW downto 0) <= pt(i)(MUON_PT_HIGH-MUON_PT_LOW downto 0); 
                eta_i(i)(MUON_ETA_HIGH-MUON_ETA_LOW downto 0) <= eta(i)(MUON_ETA_HIGH-MUON_ETA_LOW downto 0); 
                phi_i(i)(MUON_PHI_HIGH-MUON_PHI_LOW downto 0) <= phi(i)(MUON_PHI_HIGH-MUON_PHI_LOW downto 0); 
            pt_vector(i)(MUON_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MUON_PT_LUT(CONV_INTEGER(pt_i(i))), MUON_PT_VECTOR_WIDTH);
            cos_phi(i) <= MUON_COS_PHI_LUT(CONV_INTEGER(phi_i(i)));
            sin_phi(i) <= MUON_SIN_PHI_LUT(CONV_INTEGER(phi_i(i)));
        end generate muon_i;
-- outputs for all object types
        eta_integer(i) <= CONV_INTEGER(signed(eta_i(i)));
        phi_integer(i) <= CONV_INTEGER(phi_i(i));
    end generate obj_loop;

end architecture rtl;



