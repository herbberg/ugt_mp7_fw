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

entity transverse_mass is
    generic (
        NR_OBJ_1 : positive := 12;
        NR_OBJ_2 : positive := 8;
        pt1_width: positive := 12;
        pt2_width: positive := 12;
        cosh_cos_width: positive := 28;
        mass_cosh_cos_precision : positive := 3;
        OUT_REG : boolean
    );
    port(
        pt1 : in pt_array;
        pt2 : in pt_array;
        cos_dphi : in cosh_cos_vector_array;
        transverse_mass_o : out mass_vector_array;
    );
end transverse_mass;

architecture rtl of transverse_mass is

    signal transverse_mass_sq_div2 : mass_vector_array := (others => (others => (others => '0')));
    
-- HB 2017-09-21: used attribute "use_dsp" instead of "use_dsp48" for "mass" - see warning below
-- MP7 builds, synth_1, runme.log => WARNING: [Synth 8-5974] attribute "use_dsp48" has been deprecated, please use "use_dsp" instead
    attribute use_dsp : string;
    attribute use_dsp of transverse_mass_sq_div2 : signal is "yes";

begin

    loop_1: for i in 0 to NR_OBJ_1-1 generate
        loop_2: for j in 0 to NR_OBJ_2-1 generate
-- HB 2016-12-12: calculation of transverse mass with formular M**2/2=pt1*pt2*(1-cos(phi1-phi2))
--                "conv_std_logic_vector((10**mass_cosh_cos_precision), cosh_cos_width)" means 1 multiplied with 10**mass_cosh_cos_precision, converted to std_logic_vector with cosh_cos_width
            transverse_mass_sq_div2(i,j) <= pt1(i)(pt1_width-1 downto 0) * pt2(j)(pt2_width-1 downto 0) * ((conv_std_logic_vector((10**mass_cosh_cos_precision), cosh_cos_width)) - (cos_dphi(i,j)(cosh_cos_width-1 downto 0)));
        end generate loop_2;
    end generate loop_1;

    out_reg_p: process(clk, cond)
    begin
        if OUT_REG = false then
            transverse_mass_o <= transverse_mass_sq_div2;
        else
            if (clk'event and clk = '1') then
                transverse_mass_o <= transverse_mass_sq_div2;
            end if;
        end if;
    end process;

end architecture rtl;
