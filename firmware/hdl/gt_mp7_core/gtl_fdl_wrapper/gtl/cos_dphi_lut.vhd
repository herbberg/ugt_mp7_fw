-- Description:
-- COS LUTs of Differences in eta.

-- Version-history:
-- HB 2019-01-11: First design.

library ieee;
use ieee.std_logic_1164.all;

-- used for CONV_STD_LOGIC_VECTOR
use ieee.std_logic_arith.all;
-- used for CONV_INTEGER
use ieee.std_logic_unsigned.all;

use work.gtl_pkg.all;
use work.lut_pkg.all;

entity cos_dphi_lut is
    generic(
        N_OBJ_1 : positive;
        N_OBJ_2 : positive;
        OBJ : obj_type_array
    );
    port(
        sub_phi : in dim2_max_phi_range_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1);
        cos_dphi_o : out cosh_cos_vector_array(0 to N_OBJ_1-1, 0 to N_OBJ_2-1) := (others => (others => (others => '0')))
    );
end cos_dphi_lut;

architecture rtl of cos_dphi_lut is

begin

    cos_dphi_p: process(sub_phi)
        variable calo_calo, calo_muon, muon_muon : boolean := false;    
    begin
        if_1: if OBJ(1) = eg or OBJ(1) = jet or OBJ(1) = tau then
            if_2: if OBJ(2) = eg or OBJ(2) = jet or OBJ(2) = tau or OBJ(2) = etm or OBJ(2) = htm or OBJ(2) = etmhf or OBJ(2) = htmhf then
                calo_calo := true;
            end if;
        end if;
        if_3: if OBJ(1) = eg or OBJ(1) = jet or OBJ(1) = tau then
            if_4: if OBJ(2) = muon then
                calo_muon := true;
            end if;
        end if;
        if_5: if OBJ(1) = muon then
            if_6: if OBJ(2) = etm or OBJ(2) = htm or OBJ(2) = etmhf or OBJ(2) = htmhf then
                calo_muon := true;
            end if;
        end if;
        if_7: if OBJ(1) = muon then
            if_8: if OBJ(2) = muon then
                muon_muon := true;
            end if;
        end if;
        loop_1: for i in 0 to N_OBJ_1-1 loop
            loop_2: for j in 0 to N_OBJ_2-1 loop
                calo_calo_i: if (calo_calo) then
                    cos_dphi_o(i,j)(CALO_CALO_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_CALO_COS_DPHI_LUT(sub_phi(i,j)), CALO_CALO_COSH_COS_VECTOR_WIDTH);
                end if;
                calo_muon_i: if (calo_muon) then
                    cos_dphi_o(i,j)(CALO_MUON_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(CALO_MUON_COS_DPHI_LUT(sub_phi(i,j)), CALO_MUON_COSH_COS_VECTOR_WIDTH);
                end if;
                muon_muon_i: if (muon_muon) then
                    cos_dphi_o(i,j)(MUON_MUON_COSH_COS_VECTOR_WIDTH-1 downto 0) <= CONV_STD_LOGIC_VECTOR(MUON_MUON_COS_DPHI_LUT(sub_phi(i,j)), MUON_MUON_COSH_COS_VECTOR_WIDTH);
                end if;
            end loop loop_2;
        end loop loop_1;
    end process cos_dphi_p;

end architecture rtl;
