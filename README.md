# gtl_v2.x.y

GTL version 2.x.y for new structure of GTL logic with 3 stages: 1. conversions and calculations, 2. comparisons and 3. conditions and algos

Naming conventions:

1. Conversions and calculations

1.1 Conversions

 Configuration constants for conversions:

  conversions_conf_<object type>_bx_<bx notation> 

  list of bx notation:
    p2, p1, 0, m1, m2

  Example of declaration:
    constant conversions_conf_eg_bx_0 : conversions_conf := (N_OBJ => NR_EG_OBJECTS, OBJ_T => eg, OBJ_S => eg_struct);
 
 Output signals of conversions:

  <conversion name>_<object type>_bx_<bx notation>

  list of conversion names:
    pt, eta, phi, iso, qual, charge, pt_vector, eta_integer, phi_integer, 
    cos_phi, sin_phi, conv_2_muon_eta_integer, conv_2_muon_phi_integer, conv_mu_cos_phi, conv_mu_sin_phi

  Example of declaration:
    signal phi_eg_bx_0 : phi_array(0 to NR_EG_OBJECTS-1);

1.2 Calculations of differences

 Configuration constants for differences:
 
  differences_conf_<object type>_bx_<bx notation> 

  Example of declaration:
    constant differences_conf_eg_bx_0_jet_bx_0 : differences_conf := (N_OBJ_1 => NR_EG_OBJECTS, N_OBJ_2 => NR_JET_OBJECTS, PHI_HALF_RANGE => CALO_PHI_HALF_RANGE_BINS, OUT_REG => true, OBJ_CORR => calo_calo);
 
 Output signals of differences in eta:
 
  deta_<object type>_bx_<bx notation>
  cosh_deta_<object type>_bx_<bx notation>

  Example of declaration:
    deta_eg_bx_0_jet_bx_0 : ....
    
1.3 Calculations of delta-Rs

 Configuration constants for delta-R:
 
 Output signals of delta-R:

1.4 Calculations of invariant mass

 Configuration constants for invariant mass:
 
 Output signals of invariant mass:

1.5 Calculations of transverse mass

 Configuration constants for transverse mass:
 
 Output signals of transverse mass:

1.6 Calculations of two-body-pt

 Configuration constants for two-body-pt:
 
 Output signals of two-body-pt:

1.7 Calculations of charge correlation

 Output signals of charge correlation:
 
  <charge correlation type>_<object type>_bx_<bx notation>_<object type>_bx_<bx notation>

  list of charge correlation types:
    cc_double, cc_triple, cc_quad

  Example of declaration:
    cc_double_bx_0_bx_0 : ....

2. Comparisons

 Configuration constants for comparators
 
  comparators_conf_<object type>_bx_<bx notation> 

  Example of declaration:
    constant comparators_conf_pt_eg_bx_0 : conversions_conf := (N_OBJ_1_H => 0, N_OBJ_2_H => NR_EG_OBJECTS-1, C_WIDTH => EG_PT_WIDTH, GE_MODE => true, WINDOW => false, OUT_REG => true);

 Output signals of comparators
 
  comp_<comparison name>_<object type>_bx_<bx notation>_req_<req name>_<req #>
 
  list of comparison names:
    pt, eta, phi, iso, qual, charge,
    deta, dphi, dr, inv_mass, trans_mass, tbpt, char_corr
    
  Examples of declaration:
    signal comp_pt_eg_bx_0_req_xyz_1 : std_logic_2dim(pt_eg_bx_0_comparators_conf.N_OBJ_1_H downto 0)(pt_eg_bx_0_comparators_conf.N_OBJ_2_H downto 0);
    signal comp_pt_eg_bx_0_req_xyz_2 : std_logic_2dim(pt_eg_bx_0_comparators_conf.N_OBJ_1_H downto 0)(pt_eg_bx_0_comparators_conf.N_OBJ_2_H downto 0);

3. Conditions and algos

 Configuration constants for conditions
 
 Output signals of conditions


