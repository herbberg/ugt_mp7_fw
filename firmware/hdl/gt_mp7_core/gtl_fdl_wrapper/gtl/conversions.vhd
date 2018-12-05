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

entity conversions is
    generic(
        CONF : conversions_conf
    );
    port(
        clk : in std_logic;
        obj : in objects_array(0 to CONF.N_OBJ-1);
-- Output signals registered, for direct used in next stage => comparison
        pt : out comp_in_data_array(0 to CONF.N_OBJ-1) := (others => (others => '0'));
        eta : out comp_in_data_array(0 to CONF.N_OBJ-1) := (others => (others => '0'));
        phi : out comp_in_data_array(0 to CONF.N_OBJ-1) := (others => (others => '0'));
        iso : out comp_in_data_array(0 to CONF.N_OBJ-1) := (others => (others => '0'));
        qual : out comp_in_data_array(0 to CONF.N_OBJ-1) := (others => (others => '0'));
        charge : out comp_in_data_array(0 to CONF.N_OBJ-1) := (others => (others => '0'));
        pt_vector : out pt_vector_array(0 to CONF.N_OBJ-1) := (others => (others => '0'));
        cos_phi : out sin_cos_integer_array(0 to CONF.N_OBJ-1) := (others => 0);
        sin_phi : out sin_cos_integer_array(0 to CONF.N_OBJ-1) := (others => 0);
        conv_mu_cos_phi : out sin_cos_integer_array(0 to CONF.N_OBJ-1) := (others => 0);
        conv_mu_sin_phi : out sin_cos_integer_array(0 to CONF.N_OBJ-1) := (others => 0);
-- Output signals without register for use in 
        eta_integer : out diff_integer_inputs_array(0 to CONF.N_OBJ-1) := (others => 0);
        phi_integer : out diff_integer_inputs_array(0 to CONF.N_OBJ-1) := (others => 0);
        conv_2_muon_eta_integer : out diff_integer_inputs_array(0 to CONF.N_OBJ-1) := (others => 0);
        conv_2_muon_phi_integer : out diff_integer_inputs_array(0 to CONF.N_OBJ-1) := (others => 0)
    );
end conversions;

architecture rtl of conversions is

    constant pt_width : positive := CONF.OBJ_S.pt_h - CONF.OBJ_S.pt_l + 1;
    constant eta_width : positive := CONF.OBJ_S.eta_h - CONF.OBJ_S.eta_l + 1;
    constant phi_width : positive := CONF.OBJ_S.phi_h - CONF.OBJ_S.phi_l + 1;
    constant iso_width : positive := CONF.OBJ_S.iso_h - CONF.OBJ_S.iso_l + 1;
    constant qual_width : positive := CONF.OBJ_S.qual_h - CONF.OBJ_S.qual_l + 1;
    constant charge_width : positive := CONF.OBJ_S.charge_h - CONF.OBJ_S.charge_l + 1;
    
    type pt_i_array is array (0 to CONF.N_OBJ-1) of std_logic_vector(pt_width-1 downto 0);
    signal pt_i : pt_i_array := (others => (others => '0'));
    type eta_i_array is array (0 to CONF.N_OBJ-1) of std_logic_vector(eta_width-1 downto 0);
    signal eta_i : eta_i_array := (others => (others => '0'));
    type phi_i_array is array (0 to CONF.N_OBJ-1) of std_logic_vector(phi_width-1 downto 0);
    signal phi_i : phi_i_array := (others => (others => '0'));
    type iso_i_array is array (0 to CONF.N_OBJ-1) of std_logic_vector(iso_width-1 downto 0);
    signal iso_i : iso_i_array := (others => (others => '0'));
    type qual_i_array is array (0 to CONF.N_OBJ-1) of std_logic_vector(qual_width-1 downto 0);
    signal qual_i : qual_i_array := (others => (others => '0'));
    type charge_i_array is array (0 to CONF.N_OBJ-1) of std_logic_vector(charge_width-1 downto 0);
    signal charge_i : charge_i_array := (others => (others => '0'));
    type pt_vector_i_array is array (0 to CONF.N_OBJ-1) of std_logic_vector(CONF.PT_VECTOR_WIDTH-1 downto 0);
    signal pt_vector_i : pt_vector_i_array := (others => (others => '0'));

    signal sin_phi_i : sin_cos_integer_array(0 to CONF.N_OBJ-1) := (others => 0);
    signal cos_phi_i : sin_cos_integer_array(0 to CONF.N_OBJ-1) := (others => 0);
    signal conv_mu_sin_phi_i : sin_cos_integer_array(0 to CONF.N_OBJ-1) := (others => 0);
    signal conv_mu_cos_phi_i : sin_cos_integer_array(0 to CONF.N_OBJ-1) := (others => 0);
    
    type calo_sin_cos_array is array (0 to CONF.N_OBJ-1) of std_logic_vector(CALO_SIN_COS_VECTOR_WIDTH-1 downto 0);
    signal calo_cos_phi_vec : calo_sin_cos_array;
    signal calo_sin_phi_vec : calo_sin_cos_array;
    signal calo_cos_phi_vec_i : calo_sin_cos_array;
    signal calo_sin_phi_vec_i : calo_sin_cos_array;
    type muon_sin_cos_array is array (0 to CONF.N_OBJ-1) of std_logic_vector(MUON_SIN_COS_VECTOR_WIDTH-1 downto 0);
    signal conv_mu_cos_phi_vec : muon_sin_cos_array;
    signal conv_mu_sin_phi_vec : muon_sin_cos_array;
    signal conv_mu_cos_phi_vec_i : muon_sin_cos_array;
    signal conv_mu_sin_phi_vec_i : muon_sin_cos_array;
    signal muon_cos_phi_vec : muon_sin_cos_array;
    signal muon_sin_phi_vec : muon_sin_cos_array;
    signal muon_cos_phi_vec_i : muon_sin_cos_array;
    signal muon_sin_phi_vec_i : muon_sin_cos_array;
        
    signal iso_def : iso_i_array := (others => (others => '0'));
    signal qual_def : qual_i_array := (others => (others => '0'));
    signal charge_def : charge_i_array := (others => (others => '0'));
    signal conv_2_muon_phi_integer_i : diff_integer_inputs_array(0 to CONF.N_OBJ-1) := (others => 0);
    
begin

    obj_loop: for i in 0 to CONF.N_OBJ-1 generate

        pt_i(i)(pt_width-1 downto 0) <= obj(i)(CONF.OBJ_S.pt_h downto CONF.OBJ_S.pt_l);
        eta_i(i)(eta_width-1 downto 0) <= obj(i)(CONF.OBJ_S.eta_h downto CONF.OBJ_S.eta_l);
        phi_i(i)(phi_width-1 downto 0) <= obj(i)(CONF.OBJ_S.phi_h downto CONF.OBJ_S.phi_l);        
        iso_i(i)(iso_width-1 downto 0) <= obj(i)(CONF.OBJ_S.iso_h downto CONF.OBJ_S.iso_l) when CONF.OBJ_T /= jet else iso_def(i);
        qual_i(i)(qual_width-1 downto 0) <= obj(i)(CONF.OBJ_S.qual_h downto CONF.OBJ_S.qual_l) when CONF.OBJ_T = muon else qual_def(i);
        charge_i(i)(charge_width-1 downto 0) <= obj(i)(CONF.OBJ_S.charge_h downto CONF.OBJ_S.charge_l) when CONF.OBJ_T = muon else charge_def(i);

        eg_i: if (CONF.OBJ_T = eg) generate
            pt_vector_i(i)(EG_PT_VECTOR_WIDTH_NEW-1 downto 0) <= CONV_STD_LOGIC_VECTOR(EG_PT_LUT(CONV_INTEGER(pt_i(i))), EG_PT_VECTOR_WIDTH_NEW);
        end generate eg_i;

        jet_i: if (CONF.OBJ_T = jet) generate
            pt_vector_i(i)(JET_PT_VECTOR_WIDTH_NEW-1 downto 0) <= CONV_STD_LOGIC_VECTOR(JET_PT_LUT(CONV_INTEGER(pt_i(i))), JET_PT_VECTOR_WIDTH_NEW);
        end generate jet_i;

        tau_i: if (CONF.OBJ_T = tau) generate
            pt_vector_i(i)(TAU_PT_VECTOR_WIDTH_NEW-1 downto 0) <= CONV_STD_LOGIC_VECTOR(TAU_PT_LUT(CONV_INTEGER(pt_i(i))), TAU_PT_VECTOR_WIDTH_NEW);
        end generate tau_i;

        calo_i: if ((CONF.OBJ_T = eg) or (CONF.OBJ_T = jet) or (CONF.OBJ_T = tau)) generate
        
            cos_phi_i(i) <= CALO_COS_PHI_LUT(CONV_INTEGER(phi_i(i)));
            sin_phi_i(i) <= CALO_SIN_PHI_LUT(CONV_INTEGER(phi_i(i)));
            
            conv_2_muon_phi_integer_i(i) <= CALO_PHI_CONV_2_MUON_PHI_LUT(CONV_INTEGER(phi_i(i)));
            conv_mu_cos_phi_i(i) <= MUON_COS_PHI_LUT(conv_2_muon_phi_integer_i(i));
            conv_mu_sin_phi_i(i) <= MUON_SIN_PHI_LUT(conv_2_muon_phi_integer_i(i));
            
            conv_2_muon_eta_integer(i) <= CALO_ETA_CONV_2_MUON_ETA_LUT(CONV_INTEGER(eta_i(i)));
            conv_2_muon_phi_integer(i) <= conv_2_muon_phi_integer_i(i);
            
-- Internal register for integer signals used directly in next stage => comparison
            calo_cos_phi_vec_i(i) <= CONV_STD_LOGIC_VECTOR(cos_phi_i(i), CALO_SIN_COS_VECTOR_WIDTH);
            calo_sin_phi_vec_i(i) <= CONV_STD_LOGIC_VECTOR(sin_phi_i(i), CALO_SIN_COS_VECTOR_WIDTH);
            conv_mu_cos_phi_vec_i(i) <= CONV_STD_LOGIC_VECTOR(conv_mu_cos_phi_i(i), MUON_SIN_COS_VECTOR_WIDTH);
            conv_mu_sin_phi_vec_i(i) <= CONV_STD_LOGIC_VECTOR(conv_mu_cos_phi_i(i), MUON_SIN_COS_VECTOR_WIDTH);
            cos_phi_vec_reg_i : entity work.out_reg_mux
                    generic map(CALO_SIN_COS_VECTOR_WIDTH, CONF.OUT_REG) 
                    port map(clk, calo_cos_phi_vec_i(i), calo_cos_phi_vec(i)); 
            sin_phi_vec_reg_i : entity work.out_reg_mux
                    generic map(CALO_SIN_COS_VECTOR_WIDTH, CONF.OUT_REG)  
                    port map(clk, calo_sin_phi_vec_i(i), calo_sin_phi_vec(i)); 
            conv_mu_cos_phi_vec_reg_i : entity work.out_reg_mux
                    generic map(MUON_SIN_COS_VECTOR_WIDTH, CONF.OUT_REG)  
                    port map(clk, conv_mu_cos_phi_vec_i(i), conv_mu_cos_phi_vec(i)); 
            conv_mu_sin_phi_vec_reg_i : entity work.out_reg_mux
                    generic map(MUON_SIN_COS_VECTOR_WIDTH, CONF.OUT_REG)  
                    port map(clk, conv_mu_sin_phi_vec_i(i), conv_mu_sin_phi_vec(i));
                    
            cos_phi(i) <= CONV_INTEGER(calo_cos_phi_vec(i));
            sin_phi(i) <= CONV_INTEGER(calo_sin_phi_vec(i));
            conv_mu_cos_phi(i) <= CONV_INTEGER(conv_mu_cos_phi_vec(i));
            conv_mu_sin_phi(i) <= CONV_INTEGER(conv_mu_sin_phi_vec(i));

        end generate calo_i;

        muon_i: if (CONF.OBJ_T = muon) generate
        
            pt_vector_i(i)(MUON_PT_VECTOR_WIDTH_NEW-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MU_PT_LUT(CONV_INTEGER(pt_i(i))), MUON_PT_VECTOR_WIDTH_NEW);
            cos_phi_i(i) <= MUON_COS_PHI_LUT(CONV_INTEGER(phi_i(i)));
            sin_phi_i(i) <= MUON_SIN_PHI_LUT(CONV_INTEGER(phi_i(i)));
            
-- Internal register for integer signals directly used directly in next stage => comparison
            muon_cos_phi_vec_i(i) <= CONV_STD_LOGIC_VECTOR(cos_phi_i(i), MUON_SIN_COS_VECTOR_WIDTH);
            muon_sin_phi_vec_i(i) <= CONV_STD_LOGIC_VECTOR(sin_phi_i(i), MUON_SIN_COS_VECTOR_WIDTH);            
            cos_phi_vec_reg_i : entity work.out_reg_mux
                    generic map(MUON_SIN_COS_VECTOR_WIDTH, CONF.OUT_REG)  
                    port map(clk, muon_sin_phi_vec_i(i), muon_cos_phi_vec(i)); 
            sin_phi_vec_reg_i : entity work.out_reg_mux
                    generic map(MUON_SIN_COS_VECTOR_WIDTH, CONF.OUT_REG)  
                    port map(clk, muon_sin_phi_vec_i(i), muon_sin_phi_vec(i));                    
            cos_phi(i) <= CONV_INTEGER(muon_cos_phi_vec(i));
            sin_phi(i) <= CONV_INTEGER(muon_sin_phi_vec(i));

        end generate muon_i;
        
        eta_integer(i) <= CONV_INTEGER(signed(eta_i(i)));
        phi_integer(i) <= CONV_INTEGER(phi_i(i));
            
-- Output register for signals directly used directly in next stage => comparison
        pt_out_reg_i : entity work.out_reg_mux
            generic map(pt_width, CONF.OUT_REG)  
            port map(clk, pt_i(i), pt(i)); 
        eta_out_reg_i : entity work.out_reg_mux
            generic map(eta_width, CONF.OUT_REG)  
            port map(clk, eta_i(i), eta(i)); 
        phi_out_reg_i : entity work.out_reg_mux
            generic map(phi_width, CONF.OUT_REG)  
            port map(clk, phi_i(i), phi(i)); 
        iso_out_reg_i : entity work.out_reg_mux
            generic map(iso_width, CONF.OUT_REG)  
            port map(clk, iso_i(i), iso(i)); 
        qual_out_reg_i : entity work.out_reg_mux
            generic map(qual_width, CONF.OUT_REG)  
            port map(clk, qual_i(i), qual(i)); 
        charge_out_reg_i : entity work.out_reg_mux
            generic map(charge_width, CONF.OUT_REG)  
            port map(clk, charge_i(i), charge(i)); 
        pt_vector_out_reg_i : entity work.out_reg_mux
            generic map(CONF.PT_VECTOR_WIDTH, CONF.OUT_REG)  
            port map(clk, pt_vector_i(i), pt_vector(i)); 

    end generate obj_loop;

end architecture rtl;



