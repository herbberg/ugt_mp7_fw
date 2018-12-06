-- Desription:
-- Calculation of charge correlations for muon conditions.

-- Version history:
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.gtl_pkg.all;

entity muon_charge_correlations is
    generic(
        OUT_REG : boolean
    );
    port(
        clk : in std_logic;
        in_1: in comp_in_data_array(0 to NR_MUON_OBJECTS-1);
        in_2: in comp_in_data_array(0 to NR_MUON_OBJECTS-1);
        cc_double: out muon_cc_double_array;
        cc_triple: out muon_cc_triple_array;
        cc_quad: out muon_cc_quad_array
    );
end muon_charge_correlations;

architecture rtl of muon_charge_correlations is
    
    signal cc_double_i : muon_cc_double_array;
    signal cc_triple_i : muon_cc_triple_array;
    signal cc_quad_i : muon_cc_quad_array;
    
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

    charge_corr_p: process(in_1, in_2)
        variable charge_bits_obj_1, charge_bits_obj_2 : muon_charge_bits_array;
    begin
        for i in 0 to NR_MUON_OBJECTS-1 loop
            for j in 0 to NR_MUON_OBJECTS-1 loop
                charge_bits_obj_1(i) := in_1(i)(NR_MUON_CHARGE_BITS-1 downto 0);
                charge_bits_obj_2(i) := in_2(i)(NR_MUON_CHARGE_BITS-1 downto 0);
                if (charge_bits_obj_1(i)(1)='1' and charge_bits_obj_2(j)(1)='1') then
                    if charge_bits_obj_1(i)(0)='1' and charge_bits_obj_2(j)(0)='1' then
                        cc_double_i(i,j) <= CC_LS;
                    elsif charge_bits_obj_1(i)(0)='0' and charge_bits_obj_2(j)(0)='0' then
                        cc_double_i(i,j) <= CC_LS;
                    else
                        cc_double_i(i,j) <= CC_OS;                        
                    end if;
                else
                    cc_double_i(i,j) <= CC_NOT_VALID;                                            
                end if;
                for k in 0 to NR_MUON_OBJECTS-1 loop
                    if charge_bits_obj_1(i)(1)='1' and charge_bits_obj_1(j)(1)='1' and charge_bits_obj_1(k)(1)='1' then
                        if charge_bits_obj_1(i)(0)='1' and charge_bits_obj_1(j)(0)='1' and charge_bits_obj_1(k)(0)='1' then
                            cc_triple_i(i,j,k) <= CC_LS;
                        elsif charge_bits_obj_1(i)(0)='0' and charge_bits_obj_1(j)(0)='0' and charge_bits_obj_1(k)(0)='0' then
                            cc_triple_i(i,j,k) <= CC_LS;
                        else
                            cc_triple_i(i,j,k) <= CC_OS;                        
                        end if;
                    else
                        cc_triple_i(i,j,k) <= CC_NOT_VALID;                                            
                    end if;
                    for l in 0 to NR_MUON_OBJECTS-1 loop
                        if charge_bits_obj_1(i)(1)='1' and charge_bits_obj_1(j)(1)='1' and charge_bits_obj_1(k)(1)='1' and charge_bits_obj_1(l)(1)='1' then
                            if charge_bits_obj_1(i)(0)='1' and charge_bits_obj_1(j)(0)='1' and charge_bits_obj_1(k)(0)='1' and charge_bits_obj_1(l)(0)='1' then
                                cc_quad_i(i,j,k,l) <= CC_LS;
                            elsif charge_bits_obj_1(i)(0)='0' and charge_bits_obj_1(j)(0)='0' and charge_bits_obj_1(k)(0)='0' and charge_bits_obj_1(l)(0)='0' then
                                cc_quad_i(i,j,k,l) <= CC_LS;
                            else
                                cc_quad_i(i,j,k,l) <= CC_OS;                        
                            end if;
                        else
                            cc_quad_i(i,j,k,l) <= CC_NOT_VALID;                                            
                        end if;
                    end loop;
                end loop;
            end loop;
        end loop;
    end process charge_corr_p;
    
    l_1 : for i in 0 to NR_MUON_OBJECTS-1 generate
        l_2 : for j in 0 to NR_MUON_OBJECTS-1 generate
            out_reg_double_i : entity work.out_reg_mux
                generic map(NR_MUON_CHARGE_BITS, OUT_REG)  
                port map(clk, cc_double_i(i,j), cc_double(i,j)); 
            l_3 : for k in 0 to NR_MUON_OBJECTS-1 generate
                out_reg_triple_i : entity work.out_reg_mux
                    generic map(NR_MUON_CHARGE_BITS, OUT_REG)  
                    port map(clk, cc_triple_i(i,j,k), cc_triple(i,j,k)); 
                l_4 : for l in 0 to NR_MUON_OBJECTS-1 generate
                    out_reg_quad_i : entity work.out_reg_mux
                        generic map(NR_MUON_CHARGE_BITS, OUT_REG)  
                        port map(clk, cc_quad_i(i,j,k,l), cc_quad(i,j,k,l)); 
                end generate l_4;
            end generate l_3;
        end generate l_2;
    end generate l_1;

end architecture rtl;
