-- Description:
-- Output register mux.

-- Version-history:
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;

-- used for CONV_STD_LOGIC_VECTOR
use ieee.std_logic_arith.all;
-- used for CONV_INTEGER
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;

entity conversions is
    generic(
        CONF : conversions_conf
    );
    port(
        obj : in objects_array(0 to CONF.N_OBJ-1);
        pt : out pt_array(0 to CONF.N_OBJ-1) := (others => (others => '0'));
        eta : out eta_array(0 to CONF.N_OBJ-1) := (others => (others => '0'));
        phi : out phi_array(0 to CONF.N_OBJ-1) := (others => (others => '0'));
        iso : out iso_array(0 to CONF.N_OBJ-1) := (others => (others => '0'));
        qual : out qual_array(0 to CONF.N_OBJ-1) := (others => (others => '0'));
        charge : out charge_array(0 to CONF.N_OBJ-1) := (others => (others => '0'));
        pt_vector : out pt_vector_array(0 to CONF.N_OBJ-1) := (others => (others => '0'));
        eta_integer : out diff_integer_inputs_array(0 to CONF.N_OBJ-1) := (others => 0);
        phi_integer : out diff_integer_inputs_array(0 to CONF.N_OBJ-1) := (others => 0);
        cos_phi : out sin_cos_integer_array(0 to CONF.N_OBJ-1) := (others => 0);
        sin_phi : out sin_cos_integer_array(0 to CONF.N_OBJ-1) := (others => 0);
        conv_2_muon_eta_integer : out diff_integer_inputs_array(0 to CONF.N_OBJ-1) := (others => 0);
        conv_2_muon_phi_integer : out diff_integer_inputs_array(0 to CONF.N_OBJ-1) := (others => 0);
        conv_mu_cos_phi : out sin_cos_integer_array(0 to CONF.N_OBJ-1) := (others => 0);
        conv_mu_sin_phi : out sin_cos_integer_array(0 to CONF.N_OBJ-1) := (others => 0)
    );
end conversions;

architecture rtl of conversions is

    constant pt_i_width : positive := CONF.OBJ_S.pt_h - CONF.OBJ_S.pt_l + 1;
    constant eta_i_width : positive := CONF.OBJ_S.eta_h - CONF.OBJ_S.eta_l + 1;
    constant phi_i_width : positive := CONF.OBJ_S.phi_h - CONF.OBJ_S.phi_l + 1;
    constant iso_i_width : positive := CONF.OBJ_S.iso_h - CONF.OBJ_S.iso_l + 1;
    
    type pt_i_array is array (0 to CONF.N_OBJ-1) of std_logic_vector(pt_i_width-1 downto 0);
    signal pt_i : pt_i_array := (others => (others => '0'));
    type eta_i_array is array (0 to CONF.N_OBJ-1) of std_logic_vector(eta_i_width-1 downto 0);
    signal eta_i : eta_i_array := (others => (others => '0'));
    type phi_i_array is array (0 to CONF.N_OBJ-1) of std_logic_vector(phi_i_width-1 downto 0);
    signal phi_i : phi_i_array := (others => (others => '0'));
    
    signal iso_def : iso_array(0 to CONF.N_OBJ-1) := (others => (others => '0'));
    signal qual_def : qual_array(0 to CONF.N_OBJ-1) := (others => (others => '0'));
    signal charge_def : charge_array(0 to CONF.N_OBJ-1) := (others => (others => '0'));
    signal conv_2_muon_phi_integer_i : diff_integer_inputs_array(0 to CONF.N_OBJ-1) := (others => 0);
    
begin

    obj_loop: for i in 0 to CONF.N_OBJ-1 generate
        pt_i(i)(pt_i_width-1 downto 0) <= obj(i)(CONF.OBJ_S.pt_h downto CONF.OBJ_S.pt_l);
        eta_i(i)(eta_i_width-1 downto 0) <= obj(i)(CONF.OBJ_S.eta_h downto CONF.OBJ_S.eta_l);
        phi_i(i)(phi_i_width-1 downto 0) <= obj(i)(CONF.OBJ_S.phi_h downto CONF.OBJ_S.phi_l);
        pt(i)(pt_i_width-1 downto 0) <= pt_i(i);
        eta(i)(eta_i_width-1 downto 0) <= eta_i(i);
        phi(i)(phi_i_width-1 downto 0) <= phi_i(i);    
        iso(i) <= obj(i)(CONF.OBJ_S.iso_h downto CONF.OBJ_S.iso_l) when CONF.OBJ_T /= jet else iso_def(i);
        qual(i) <= obj(i)(CONF.OBJ_S.qual_h downto CONF.OBJ_S.qual_l) when CONF.OBJ_T = muon else qual_def(i);
        charge(i) <= obj(i)(CONF.OBJ_S.charge_h downto CONF.OBJ_S.charge_l) when CONF.OBJ_T = muon else charge_def(i);
        eta_integer(i) <= CONV_INTEGER(signed(eta_i(i)));
        phi_integer(i) <= CONV_INTEGER(phi_i(i));            
        calo_i: if ((CONF.OBJ_T = eg) or (CONF.OBJ_T = jet) or (CONF.OBJ_T = tau)) generate
            eg_i: if (CONF.OBJ_T = eg) generate
                pt_vector(i)(EG_PT_VECTOR_WIDTH_NEW-1 downto 0) <= CONV_STD_LOGIC_VECTOR(EG_PT_LUT(CONV_INTEGER(pt_i(i))), EG_PT_VECTOR_WIDTH_NEW);
            end generate eg_i;
            jet_i: if (CONF.OBJ_T = jet) generate
                pt_vector(i)(JET_PT_VECTOR_WIDTH_NEW-1 downto 0) <= CONV_STD_LOGIC_VECTOR(JET_PT_LUT(CONV_INTEGER(pt_i(i))), JET_PT_VECTOR_WIDTH_NEW);
            end generate jet_i;
            tau_i: if (CONF.OBJ_T = tau) generate
                pt_vector(i)(TAU_PT_VECTOR_WIDTH_NEW-1 downto 0) <= CONV_STD_LOGIC_VECTOR(TAU_PT_LUT(CONV_INTEGER(pt_i(i))), TAU_PT_VECTOR_WIDTH_NEW);
            end generate tau_i;        
            cos_phi(i) <= CALO_COS_PHI_LUT(CONV_INTEGER(phi_i(i)));
            sin_phi(i) <= CALO_SIN_PHI_LUT(CONV_INTEGER(phi_i(i)));
            conv_2_muon_eta_integer(i) <= CALO_ETA_CONV_2_MUON_ETA_LUT(CONV_INTEGER(eta_i(i)));
            conv_2_muon_phi_integer_i(i) <= CALO_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(phi_i(i)));
            conv_2_muon_phi_integer(i) <= conv_2_muon_phi_integer_i(i);
            conv_mu_cos_phi(i) <= MUON_COS_PHI_LUT(conv_2_muon_phi_integer_i(i));
            conv_mu_sin_phi(i) <= MUON_SIN_PHI_LUT(conv_2_muon_phi_integer_i(i));            
        end generate calo_i;
        muon_i: if (CONF.OBJ_T = muon) generate
            pt_vector(i)(MUON_PT_VECTOR_WIDTH_NEW-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MU_PT_LUT(CONV_INTEGER(pt_i(i))), MUON_PT_VECTOR_WIDTH_NEW);
            cos_phi(i) <= MUON_COS_PHI_LUT(CONV_INTEGER(phi_i(i)));
            sin_phi(i) <= MUON_SIN_PHI_LUT(CONV_INTEGER(phi_i(i)));
        end generate muon_i;
    end generate obj_loop;

end architecture rtl;



