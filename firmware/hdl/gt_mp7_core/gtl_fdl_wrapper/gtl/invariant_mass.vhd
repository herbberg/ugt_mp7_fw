-- Description:
-- Calculation of invariant mass or transverse mass based on LUTs.

-- Version history:
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.math_pkg.all;

use work.gtl_pkg.all;

entity invariant_mass is
    generic(
        N_OBJ_1 : positive;
        N_OBJ_2 : positive;
        PT1_WIDTH : positive;
        PT2_WIDTH : positive;
        COSH_COS_WIDTH : positive
    );
    port(
        clk : in std_logic;
        pt1 : in pt_array(N_OBJ_1-1 downto 0);
        pt2 : in pt_array(N_OBJ_2-1 downto 0);
        cosh_deta : in cosh_cos_vector_array(N_OBJ_1-1 downto 0, N_OBJ_2-1 downto 0);
        cos_dphi : in cosh_cos_vector_array(N_OBJ_1-1 downto 0, N_OBJ_2-1 downto 0);
        inv_mass_o : out std_logic_3dim_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1, (PT1_WIDTH*PT2_WIDTH+COSH_COS_WIDTH)-1 downto 0) := (others => (others => (others => '0')))
    );
end invariant_mass;

architecture rtl of invariant_mass is

    constant MASS_WIDTH : positive := PT1_WIDTH*PT2_WIDTH+COSH_COS_WIDTH;
    type mass_vector_i_array is array (N_OBJ_1-1 downto 0, N_OBJ_2-1 downto 0) of std_logic_vector(MASS_WIDTH-1 downto 0);
    signal invariant_mass_sq_div2_i : mass_vector_i_array := (others => (others => (others => '0')));
    type mass_o_array is array (N_OBJ_1-1 downto 0, N_OBJ_2-1 downto 0, MASS_WIDTH-1 downto 0) of std_logic_vector(0 downto 0);
    signal invariant_mass_sq_div2 : mass_o_array := (others => (others => (others => "0")));
    signal invariant_mass_sq_div2_r : mass_o_array := (others => (others => (others => "0")));
    
-- HB 2017-09-21: used attribute "use_dsp" instead of "use_dsp48" for "mass" - see warning below
-- MP7 builds, synth_1, runme.log => WARNING: [Synth 8-5974] attribute "use_dsp48" has been deprecated, please use "use_dsp" instead
    attribute use_dsp : string;
    attribute use_dsp of invariant_mass_sq_div2 : signal is "yes";

begin

    l_1: for i in 0 to  N_OBJ_1-1 generate
        l_2: for j in 0 to N_OBJ_2-1 generate
-- HB 2015-10-01: calculation of invariant mass with formular M**2/2=pt1*pt2*(cosh(eta1-eta2)-cos(phi1-phi2))
            invariant_mass_sq_div2_i(i,j) <= pt1(i)(PT1_WIDTH-1 downto 0) * pt2(j)(PT2_WIDTH-1 downto 0) * 
                ((cosh_deta(i,j)(COSH_COS_WIDTH-1 downto 0)) - (cos_dphi(i,j)(COSH_COS_WIDTH-1 downto 0)));
            l_3: for k in 0 to MASS_WIDTH-1 generate
                invariant_mass_sq_div2(i,j,k)(0) <= invariant_mass_sq_div2_i(i,j)(k);                 
                out_reg_i : entity work.reg_mux
                    generic map(1, OUT_REG_CALC)  
                    port map(clk, invariant_mass_sq_div2(i,j,k), invariant_mass_sq_div2_r(i,j,k));
                inv_mass_o(i,j,k) <= invariant_mass_sq_div2_r(i,j,k)(0);
            end generate l_3;
        end generate l_2;
    end generate l_1;
        
end architecture rtl;
