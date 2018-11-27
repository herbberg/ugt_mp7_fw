-- Desription:
-- Calculation of charge correlations for muon conditions.

-- Version history:
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity muon_charge_correlations is
    generic (
        OUT_REG : boolean
    );
    port(
        charge_bits_obj_1: in muon_charge_bits_array;
        charge_bits_obj_2: in muon_charge_bits_array;
        cc_double: out muon_charcorr_double_array;
        cc_triple: out muon_charcorr_triple_array;
        cc_quad: out muon_charcorr_quad_array
    );
end muon_charge_correlations;

architecture rtl of muon_charge_correlations is
    
    constant OUT_REG_WIDTH_DOUBLE : positive := NR_MUON_OBJECTS * NR_MUON_OBJECTS * N_MU_CHARGE_BITS;
    constant OUT_REG_WIDTH_TRIPLE : positive := NR_MUON_OBJECTS * NR_MUON_OBJECTS * NR_MUON_OBJECTS * N_MU_CHARGE_BITS;
    constant OUT_REG_WIDTH_QUAD : positive := NR_MUON_OBJECTS * NR_MUON_OBJECTS * NR_MUON_OBJECTS * NR_MUON_OBJECTS * N_MU_CHARGE_BITS;
    constant not_valid : std_logic_vector(N_MU_CHARGE_BITS-1 downto 0) := "00"; 
    constant ls : std_logic_vector(N_MU_CHARGE_BITS-1  downto 0) := "01"; 
    constant os : std_logic_vector(N_MU_CHARGE_BITS-1  downto 0) := "10"; 

begin

-- *********************************************************
-- CHARGE: 2 bits => charge_valid, charge_sign
-- definition:
-- charge_bits(1) = charge_valid
-- charge_bits(0) = charge_sign
-- charge_sign = '0' => positive muon
-- charge_sign = '1' => negative muon
-- *********************************************************
-- "like sign" (LS) = 1, "opposite sign" (OS) = 2, "not valid charge" = 0
-- *********************************************************

    charge_corr_p: process(charge_bits_obj_1, charge_bits_obj_2)
    begin
        for i in 0 to NR_MUON_OBJECTS-1 loop
            for j in 0 to NR_MUON_OBJECTS-1 loop
                if charge_bits_obj_1(i)(1) and charge_bits_obj_2(j)(1) then
                    if charge_bits_obj_1(i)(0) and charge_bits_obj_2(j)(0) then
                        cc_double_i(i)(j) = ls;
                    elsif not charge_bits_obj_1(i)(0) and not charge_bits_obj_2(j)(0) then
                        cc_double_i(i)(j) = ls;
                    else
                        cc_double_i(i)(j) = os;                        
                    end if;
                else
                    cc_double_i(i)(j) = not_valid;                                            
                end if;
                for k in 0 to NR_MUON_OBJECTS-1 loop
                    if charge_bits_obj_1(i)(1) and charge_bits_obj_1(j)(1) and charge_bits_obj_1(k)(1) then
                        if charge_bits_obj_1(i)(0) and charge_bits_obj_1(j)(0) and charge_bits_obj_1(k)(0) then
                            cc_triple_i(i)(j)(k) = ls;
                        elsif not charge_bits_obj_1(i)(0) and not charge_bits_obj_1(j)(0) and not charge_bits_obj_1(k)(0) then
                            cc_triple_i(i)(j)(k) = ls;
                        else
                            cc_triple_i(i)(j)(k) = os;                        
                        end if;
                    else
                        cc_triple_i(i)(j)(k) = not_valid;                                            
                    end if;
                    for l in 0 to NR_MUON_OBJECTS-1 loop
                        if charge_bits_obj_1(i)(1) and charge_bits_obj_1(j)(1) and charge_bits_obj_1(k)(1) and charge_bits_obj_1(l)(1) then
                            if charge_bits_obj_1(i)(0) and charge_bits_obj_1(j)(0) and charge_bits_obj_1(k)(0) and charge_bits_obj_1(l)(0) then
                                cc_quad_i(i)(j)(k)(l) = ls;
                            elsif not charge_bits_obj_1(i)(0) and not harge_bits1(j)(0) and not charge_bits_obj_1(k)(0) and not charge_bits_obj_1(l)(0) then
                                cc_quad_i(i)(j)(k)(l) = ls;
                            else
                                cc_quad_i(i)(j)(k)(l) = os;                        
                            end if;
                        else
                            cc_quad_i(i)(j)(k)(l) = not_valid;                                            
                        end if;
                    end loop;
                end loop;
            end loop;
        end loop;
    end process charge_corr_p;

    out_reg_double_i : entity work.out_reg_mux
        generic map(OUT_REG_WIDTH_DOUBLE, OUT_REG);  
        port map(clk, cc_double_i, cc_double); 
    
    out_reg_triple_i : entity work.out_reg_mux
        generic map(OUT_REG_WIDTH_TRIPLE, OUT_REG);  
        port map(clk, cc_triple_i, cc_triple); 
    
    out_reg_quad_i : entity work.out_reg_mux
        generic map(OUT_REG_WIDTH_QUAD, OUT_REG);  
        port map(clk, cc_quad_i, cc_quad); 
    

end architecture rtl;
