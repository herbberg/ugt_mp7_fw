-- Desription:
-- Calculation of charge correlations for muon conditions.

-- Version history:
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use work.lhc_data_pkg.all;
use work.gtl_pkg.all;

entity muon_charge_correlations is
    port(
        in_1: in obj_parameter_array;
        in_2: in obj_parameter_array;
        cc_double: out muon_cc_double_array;
        cc_triple: out muon_cc_triple_array;
        cc_quad: out muon_cc_quad_array
    );
end muon_charge_correlations;

architecture rtl of muon_charge_correlations is
    
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
        for i in N_MUON_OBJECTS-1 downto 0 loop
            for j in N_MUON_OBJECTS-1 downto 0 loop
                charge_bits_obj_1(i) := in_1(i)(NR_MUON_CHARGE_BITS-1 downto 0);
                charge_bits_obj_2(i) := in_2(i)(NR_MUON_CHARGE_BITS-1 downto 0);
                if (charge_bits_obj_1(i)(1)='1' and charge_bits_obj_2(j)(1)='1') then
                    if charge_bits_obj_1(i)(0)='1' and charge_bits_obj_2(j)(0)='1' then
                        cc_double(i,j) <= CC_LS;
                    elsif charge_bits_obj_1(i)(0)='0' and charge_bits_obj_2(j)(0)='0' then
                        cc_double(i,j) <= CC_LS;
                    else
                        cc_double(i,j) <= CC_OS;                        
                    end if;
                else
                    cc_double(i,j) <= CC_NOT_VALID;                                            
                end if;
                for k in N_MUON_OBJECTS-1 downto 0 loop
                    if charge_bits_obj_1(i)(1)='1' and charge_bits_obj_1(j)(1)='1' and charge_bits_obj_1(k)(1)='1' then
                        if charge_bits_obj_1(i)(0)='1' and charge_bits_obj_1(j)(0)='1' and charge_bits_obj_1(k)(0)='1' then
                            cc_triple(i,j,k) <= CC_LS;
                        elsif charge_bits_obj_1(i)(0)='0' and charge_bits_obj_1(j)(0)='0' and charge_bits_obj_1(k)(0)='0' then
                            cc_triple(i,j,k) <= CC_LS;
                        else
                            cc_triple(i,j,k) <= CC_OS;                        
                        end if;
                    else
                        cc_triple(i,j,k) <= CC_NOT_VALID;                                            
                    end if;
                    for l in N_MUON_OBJECTS-1 downto 0 loop
                        if charge_bits_obj_1(i)(1)='1' and charge_bits_obj_1(j)(1)='1' and charge_bits_obj_1(k)(1)='1' and charge_bits_obj_1(l)(1)='1' then
                            if charge_bits_obj_1(i)(0)='1' and charge_bits_obj_1(j)(0)='1' and charge_bits_obj_1(k)(0)='1' and charge_bits_obj_1(l)(0)='1' then
                                cc_quad(i,j,k,l) <= CC_LS;
                            elsif charge_bits_obj_1(i)(0)='0' and charge_bits_obj_1(j)(0)='0' and charge_bits_obj_1(k)(0)='0' and charge_bits_obj_1(l)(0)='0' then
                                cc_quad(i,j,k,l) <= CC_LS;
                            else
                                cc_quad(i,j,k,l) <= CC_OS;                        
                            end if;
                        else
                            cc_quad(i,j,k,l) <= CC_NOT_VALID;                                            
                        end if;
                    end loop;
                end loop;
            end loop;
        end loop;
    end process charge_corr_p;
    
end architecture rtl;
