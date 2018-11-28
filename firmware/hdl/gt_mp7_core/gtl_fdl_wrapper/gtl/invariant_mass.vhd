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
    generic (
        CONF : mass_conf
    );
    port(
        clk : in std_logic;
        pt1 : in pt_array(CONF.NR_OBJ_1-1 downto 0);
        pt2 : in pt_array(CONF.NR_OBJ_1-1 downto 0);
        cosh_deta : in cosh_cos_vector_array(CONF.NR_OBJ_1-1 downto 0)(CONF.NR_OBJ_1-1 downto 0);
        cos_dphi : in cosh_cos_vector_array(CONF.NR_OBJ_1-1 downto 0)(CONF.NR_OBJ_1-1 downto 0);
        inv_mass_o : out mass_vector_array(CONF.NR_OBJ_1-1 downto 0)CONF.(NR_OBJ_1-1 downto 0) := (others => (others => (others => '0')))
    );
end invariant_mass;

architecture rtl of invariant_mass is

    constant OUT_REG_WIDTH : positive := CONF.PT1_WIDTH*CONF.PT2_WIDTH+CONF.COSH_COS_WIDTH;
    signal invariant_mass_sq_div2 : mass_vector_array := (others => (others => (others => '0')));
    
-- HB 2017-09-21: used attribute "use_dsp" instead of "use_dsp48" for "mass" - see warning below
-- MP7 builds, synth_1, runme.log => WARNING: [Synth 8-5974] attribute "use_dsp48" has been deprecated, please use "use_dsp" instead
    attribute use_dsp : string;
    attribute use_dsp of invariant_mass_sq_div2 : signal is "yes";

begin

    loop_1: for i in 0 toCONF. NR_OBJ_1-1 generate
        loop_2: for j in 0 to CONF.NR_OBJ_2-1 generate
-- HB 2015-10-01: calculation of invariant mass with formular M**2/2=pt1*pt2*(cosh(eta1-eta2)-cos(phi1-phi2))
            invariant_mass_sq_div2(i,j) <= pt1(i)(CONF.PT1_WIDTH-1 downto 0) * pt2(j)(CONF.PT2_WIDTH-1 downto 0) * 
                ((cosh_deta(i,j)(CONF.COSH_COS_WIDTH-1 downto 0)) - (cos_dphi(i,j)(CONF.COSH_COS_WIDTH-1 downto 0)));
            out_reg_i : entity work.out_reg_mux
                generic map(OUT_REG_WIDTH, CONF.OUT_REG);  
                port map(clk, invariant_mass_sq_div2(i,j), inv_mass_o(i,j)); 
        end generate loop_2;
    end generate loop_1;
        
end architecture rtl;
