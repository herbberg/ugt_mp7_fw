-- Description:
-- Conversion logic for eg.

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

entity jet_conversions is
    port(
        pt : in obj_parameter_array;
        eta : in obj_parameter_array;
        phi : in obj_parameter_array;
--         pt : in obj_parameter_array(0 to JET_ARRAY_LENGTH-1);
--         eta : in obj_parameter_array(0 to JET_ARRAY_LENGTH-1);
--         phi : in obj_parameter_array(0 to JET_ARRAY_LENGTH-1);
        pt_vector : out pt_vector_array(0 to JET_ARRAY_LENGTH-1) := (others => (others => '0'));
        cos_phi : out integer_array(0 to JET_ARRAY_LENGTH-1) := (others => 0);
        sin_phi : out integer_array(0 to JET_ARRAY_LENGTH-1) := (others => 0);
        conv_mu_cos_phi : out integer_array(0 to JET_ARRAY_LENGTH-1) := (others => 0);
        conv_mu_sin_phi : out integer_array(0 to JET_ARRAY_LENGTH-1) := (others => 0);
        eta_integer : out integer_array(0 to JET_ARRAY_LENGTH-1) := (others => 0);
        phi_integer : out integer_array(0 to JET_ARRAY_LENGTH-1) := (others => 0);
        conv_2_muon_eta_integer : out integer_array(0 to JET_ARRAY_LENGTH-1) := (others => 0);
        conv_2_muon_phi_integer : out integer_array(0 to JET_ARRAY_LENGTH-1) := (others => 0)
    );
end jet_conversions;

architecture rtl of jet_conversions is

    type pt_i_array is array (0 to JET_ARRAY_LENGTH-1) of std_logic_vector(jet_record.pt'length-1 downto 0);
    signal pt_i : pt_i_array := (others => (others => '0'));
    type eta_i_array is array (0 to JET_ARRAY_LENGTH-1) of std_logic_vector(jet_record.eta'length-1 downto 0);
    signal eta_i : eta_i_array := (others => (others => '0'));
    type phi_i_array is array (0 to JET_ARRAY_LENGTH-1) of std_logic_vector(jet_record.phi'length-1 downto 0);
    signal phi_i : phi_i_array := (others => (others => '0'));
    
    signal pt_vector_i : pt_vector_array(0 to JET_ARRAY_LENGTH-1) := (others => (others => '0'));

    signal sin_phi_i : integer_array(0 to JET_ARRAY_LENGTH-1) := (others => 0);
    signal cos_phi_i : integer_array(0 to JET_ARRAY_LENGTH-1) := (others => 0);
    signal conv_mu_sin_phi_i : integer_array(0 to JET_ARRAY_LENGTH-1) := (others => 0);
    signal conv_mu_cos_phi_i : integer_array(0 to JET_ARRAY_LENGTH-1) := (others => 0);
    
    type calo_sin_cos_array is array (0 to JET_ARRAY_LENGTH-1) of std_logic_vector(CALO_SIN_COS_VECTOR_WIDTH-1 downto 0);
    signal cos_phi_vec : calo_sin_cos_array;
    signal sin_phi_vec : calo_sin_cos_array;
    type muon_sin_cos_array is array (0 to JET_ARRAY_LENGTH-1) of std_logic_vector(MUON_SIN_COS_VECTOR_WIDTH-1 downto 0);
    signal conv_mu_cos_phi_vec : muon_sin_cos_array;
    signal conv_mu_sin_phi_vec : muon_sin_cos_array;
        
    signal conv_2_muon_phi_integer_i : integer_array(0 to JET_ARRAY_LENGTH-1) := (others => 0);
    
begin

    obj_loop: for i in 0 to JET_ARRAY_LENGTH-1 generate

        pt_i(i) <= pt(i)(jet_record.pt'high - jet_record.pt'low downto 0); 
        eta_i(i) <= eta(i)(jet_record.eta'high - jet_record.eta'low downto 0); 
        phi_i(i) <= phi(i)(jet_record.phi'high - jet_record.phi'low downto 0); 
        
        pt_vector_i(i)(JET_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(JET_PT_LUT(CONV_INTEGER(pt_i(i))), JET_PT_VECTOR_WIDTH);

        cos_phi_i(i) <= CALO_COS_PHI_LUT(CONV_INTEGER(phi_i(i)));
        sin_phi_i(i) <= CALO_SIN_PHI_LUT(CONV_INTEGER(phi_i(i)));

        conv_2_muon_phi_integer_i(i) <= CALO_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(phi_i(i)));
        conv_mu_cos_phi_i(i) <= MUON_COS_PHI_LUT(conv_2_muon_phi_integer_i(i));
        conv_mu_sin_phi_i(i) <= MUON_SIN_PHI_LUT(conv_2_muon_phi_integer_i(i));

        cos_phi_vec(i) <= CONV_STD_LOGIC_VECTOR(cos_phi_i(i), CALO_SIN_COS_VECTOR_WIDTH);
        sin_phi_vec(i) <= CONV_STD_LOGIC_VECTOR(sin_phi_i(i), CALO_SIN_COS_VECTOR_WIDTH);
        conv_mu_cos_phi_vec(i) <= CONV_STD_LOGIC_VECTOR(conv_mu_cos_phi_i(i), MUON_SIN_COS_VECTOR_WIDTH);
        conv_mu_sin_phi_vec(i) <= CONV_STD_LOGIC_VECTOR(conv_mu_sin_phi_i(i), MUON_SIN_COS_VECTOR_WIDTH);
                
-- outputs
        pt_vector(i)(JET_PT_VECTOR_WIDTH-1 downto 0) <=  pt_vector_i(i)(JET_PT_VECTOR_WIDTH-1 downto 0);       
        cos_phi(i) <= CONV_INTEGER(cos_phi_vec(i));
        sin_phi(i) <= CONV_INTEGER(sin_phi_vec(i));
        conv_mu_cos_phi(i) <= CONV_INTEGER(conv_mu_cos_phi_vec(i));
        conv_mu_sin_phi(i) <= CONV_INTEGER(conv_mu_sin_phi_vec(i));
        eta_integer(i) <= CONV_INTEGER(signed(eta_i(i)));
        phi_integer(i) <= CONV_INTEGER(phi_i(i));
        conv_2_muon_eta_integer(i) <= CALO_ETA_CONV_2_MUON_ETA_LUT(CONV_INTEGER(eta_i(i)));
        conv_2_muon_phi_integer(i) <= conv_2_muon_phi_integer_i(i);
        
    end generate obj_loop;

end architecture rtl;



