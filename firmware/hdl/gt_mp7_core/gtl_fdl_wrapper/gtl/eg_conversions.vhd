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

use work.gtl_pkg.all;
use work.lut_pkg.all;

entity eg_conversions is
    generic(
        N_OBJ : positive
    );
    port(
        clk : in std_logic;
        obj : in objects_array(0 to N_OBJ-1);
        pt : out comp_in_data_array(0 to N_OBJ-1) := (others => (others => '0'));
        eta : out comp_in_data_array(0 to N_OBJ-1) := (others => (others => '0'));
        phi : out comp_in_data_array(0 to N_OBJ-1) := (others => (others => '0'));
        iso : out comp_in_data_array(0 to N_OBJ-1) := (others => (others => '0'));
        pt_vector : out pt_vector_array(0 to N_OBJ-1) := (others => (others => '0'));
        cos_phi : out integer_array(0 to N_OBJ-1) := (others => 0);
        sin_phi : out integer_array(0 to N_OBJ-1) := (others => 0);
        conv_mu_cos_phi : out integer_array(0 to N_OBJ-1) := (others => 0);
        conv_mu_sin_phi : out integer_array(0 to N_OBJ-1) := (others => 0);
        eta_integer : out integer_array(0 to N_OBJ-1) := (others => 0);
        phi_integer : out integer_array(0 to N_OBJ-1) := (others => 0);
        conv_2_muon_eta_integer : out integer_array(0 to N_OBJ-1) := (others => 0);
        conv_2_muon_phi_integer : out integer_array(0 to N_OBJ-1) := (others => 0)
    );
end eg_conversions;

architecture rtl of eg_conversions is

    signal obj_i : eg_record_array(0 to N_OBJ-1);
    
    type pt_i_array is array (0 to N_OBJ-1) of std_logic_vector(obj_i(0).pt'length-1 downto 0);
    signal pt_i : pt_i_array := (others => (others => '0'));
    type eta_i_array is array (0 to N_OBJ-1) of std_logic_vector(obj_i(0).eta'length-1 downto 0);
    signal eta_i : eta_i_array := (others => (others => '0'));
    type phi_i_array is array (0 to N_OBJ-1) of std_logic_vector(obj_i(0).phi'length-1 downto 0);
    signal phi_i : phi_i_array := (others => (others => '0'));
    type iso_i_array is array (0 to N_OBJ-1) of std_logic_vector(obj_i(0).iso'length-1 downto 0);
    signal iso_i : iso_i_array := (others => (others => '0'));
--     type pt_vector_i_array is array (0 to N_OBJ-1) of std_logic_vector(EG_PT_VECTOR_WIDTH-1 downto 0);
    signal pt_vector_i : pt_vector_array(0 to N_OBJ-1) := (others => (others => '0'));

    signal sin_phi_i : integer_array(0 to N_OBJ-1) := (others => 0);
    signal cos_phi_i : integer_array(0 to N_OBJ-1) := (others => 0);
    signal conv_mu_sin_phi_i : integer_array(0 to N_OBJ-1) := (others => 0);
    signal conv_mu_cos_phi_i : integer_array(0 to N_OBJ-1) := (others => 0);
    
    type calo_sin_cos_array is array (0 to N_OBJ-1) of std_logic_vector(CALO_SIN_COS_VECTOR_WIDTH-1 downto 0);
    signal calo_cos_phi_vec : calo_sin_cos_array;
    signal calo_sin_phi_vec : calo_sin_cos_array;
    signal calo_cos_phi_vec_i : calo_sin_cos_array;
    signal calo_sin_phi_vec_i : calo_sin_cos_array;
    type muon_sin_cos_array is array (0 to N_OBJ-1) of std_logic_vector(MUON_SIN_COS_VECTOR_WIDTH-1 downto 0);
    signal conv_mu_cos_phi_vec : muon_sin_cos_array;
    signal conv_mu_sin_phi_vec : muon_sin_cos_array;
    signal conv_mu_cos_phi_vec_i : muon_sin_cos_array;
    signal conv_mu_sin_phi_vec_i : muon_sin_cos_array;
    signal muon_cos_phi_vec : muon_sin_cos_array;
    signal muon_sin_phi_vec : muon_sin_cos_array;
    signal muon_cos_phi_vec_i : muon_sin_cos_array;
    signal muon_sin_phi_vec_i : muon_sin_cos_array;
        
    signal conv_2_muon_phi_integer_i : integer_array(0 to N_OBJ-1) := (others => 0);
    
begin

    obj_loop: for i in 0 to N_OBJ-1 generate

        obj_i(i).pt <= obj(i)(obj_i(0).pt'high downto obj_i(0).pt'low); 
        pt_i(i)(obj_i(0).pt'high - obj_i(0).pt'low downto 0) <= obj(i)(obj_i(0).pt'high downto obj_i(0).pt'low); 
        obj_i(i).eta <= obj(i)(obj_i(0).eta'high downto obj_i(0).eta'low); 
        eta_i(i)(obj_i(0).eta'high - obj_i(0).eta'low downto 0) <= obj(i)(obj_i(0).eta'high downto obj_i(0).eta'low); 
        obj_i(i).phi <= obj(i)(obj_i(0).phi'high downto obj_i(0).phi'low); 
        phi_i(i)(obj_i(0).phi'high - obj_i(0).phi'low downto 0) <= obj(i)(obj_i(0).phi'high downto obj_i(0).phi'low); 
        obj_i(i).iso <= obj(i)(obj_i(0).iso'high downto obj_i(0).iso'low);
        iso_i(i)(obj_i(0).iso'high - obj_i(0).iso'low downto 0) <= obj(i)(obj_i(0).iso'high downto obj_i(0).iso'low); 
        
        pt_i(i)(obj_i(0).pt'length-1 downto 0) <= obj_i(i).pt;
        eta_i(i)(obj_i(0).eta'length-1 downto 0) <= obj_i(i).eta;
        phi_i(i)(obj_i(0).phi'length-1 downto 0) <= obj_i(i).phi;        
        iso_i(i)(obj_i(0).iso'length-1 downto 0) <= obj_i(i).iso;

        pt_vector_i(i)(EG_PT_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(EG_PT_LUT(CONV_INTEGER(pt_i(i))), EG_PT_VECTOR_WIDTH);

        cos_phi_i(i) <= CALO_COS_PHI_LUT(CONV_INTEGER(phi_i(i)));
        sin_phi_i(i) <= CALO_SIN_PHI_LUT(CONV_INTEGER(phi_i(i)));

        conv_2_muon_phi_integer_i(i) <= CALO_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(phi_i(i)));
        conv_mu_cos_phi_i(i) <= MUON_COS_PHI_LUT(conv_2_muon_phi_integer_i(i));
        conv_mu_sin_phi_i(i) <= MUON_SIN_PHI_LUT(conv_2_muon_phi_integer_i(i));

        calo_cos_phi_vec_i(i) <= CONV_STD_LOGIC_VECTOR(cos_phi_i(i), CALO_SIN_COS_VECTOR_WIDTH);
        calo_sin_phi_vec_i(i) <= CONV_STD_LOGIC_VECTOR(sin_phi_i(i), CALO_SIN_COS_VECTOR_WIDTH);
        conv_mu_cos_phi_vec_i(i) <= CONV_STD_LOGIC_VECTOR(conv_mu_cos_phi_i(i), MUON_SIN_COS_VECTOR_WIDTH);
        conv_mu_sin_phi_vec_i(i) <= CONV_STD_LOGIC_VECTOR(conv_mu_cos_phi_i(i), MUON_SIN_COS_VECTOR_WIDTH);
                
-- outputs
        pt(i)(obj_i(0).pt'length-1 downto 0) <= pt_i(i);
        eta(i)(obj_i(0).eta'length-1 downto 0) <= eta_i(i);
        phi(i)(obj_i(0).phi'length-1 downto 0) <= phi_i(i);        
        iso(i)(obj_i(0).iso'length-1 downto 0) <= iso_i(i);
        pt_vector(i)(EG_PT_VECTOR_WIDTH-1 downto 0) <=  pt_vector_i(i)(EG_PT_VECTOR_WIDTH-1 downto 0);       
        cos_phi(i) <= CONV_INTEGER(calo_cos_phi_vec(i));
        sin_phi(i) <= CONV_INTEGER(calo_sin_phi_vec(i));
        conv_mu_cos_phi(i) <= CONV_INTEGER(conv_mu_cos_phi_vec(i));
        conv_mu_sin_phi(i) <= CONV_INTEGER(conv_mu_sin_phi_vec(i));
        eta_integer(i) <= CONV_INTEGER(signed(eta_i(i)));
        phi_integer(i) <= CONV_INTEGER(phi_i(i));
        conv_2_muon_eta_integer(i) <= CALO_ETA_CONV_2_MUON_ETA_LUT(CONV_INTEGER(eta_i(i)));
        conv_2_muon_phi_integer(i) <= conv_2_muon_phi_integer_i(i);
        
    end generate obj_loop;

end architecture rtl;



