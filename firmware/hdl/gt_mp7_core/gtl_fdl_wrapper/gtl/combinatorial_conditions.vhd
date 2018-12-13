-- Description:
-- Combinatorial conditions

-- Version-history:
-- HB 2018-11-26: First design.

library ieee;
use ieee.std_logic_1164.all;

use work.gtl_pkg.all;

entity combinatorial_conditions is
    generic(
        CONF : combinatorial_conditions_conf
    );
    port(
        clk : in std_logic;        
        in_1 : in std_logic_vector(0 to CONF.N_OBJ-1) := (others => '0');
        in_2 : in std_logic_vector(0 to CONF.N_OBJ-1) := (others => '0');
        in_3 : in std_logic_vector(0 to CONF.N_OBJ-1) := (others => '0');
        in_4 : in std_logic_vector(0 to CONF.N_OBJ-1) := (others => '0');
        tbpt : in std_logic_2dim_array(0 to CONF.N_OBJ-1, 0 to CONF.N_OBJ-1) := (others => (others => '0'));
        charge_corr_double : in std_logic_2dim_array(0 to CONF.N_OBJ-1, 0 to CONF.N_OBJ-1) := (others => (others => '0'));
        charge_corr_triple : in std_logic_3dim_array(0 to CONF.N_OBJ-1, 0 to CONF.N_OBJ-1, 0 to CONF.N_OBJ-1) := (others => (others => (others => '0')));
        charge_corr_quad : in std_logic_4dim_array(0 to CONF.N_OBJ-1, 0 to CONF.N_OBJ-1, 0 to CONF.N_OBJ-1, 0 to CONF.N_OBJ-1) := (others => (others => (others => (others => '0'))));
        cond_o : out std_logic
    );
end combinatorial_conditions;

architecture rtl of combinatorial_conditions is

    constant N_SLICE_1 : positive := CONF.SLICE_1_H - CONF.SLICE_1_L + 1;
    constant N_SLICE_2 : positive := CONF.SLICE_2_H - CONF.SLICE_2_L + 1;
    constant N_SLICE_3 : positive := CONF.SLICE_3_H - CONF.SLICE_3_L + 1;
    constant N_SLICE_4 : positive := CONF.SLICE_4_H - CONF.SLICE_4_L + 1;
    
    type req_obj_array is array (1 to CONF.N_REQ) of std_logic_1dim_array(0 to CONF.N_OBJ-1);    
    signal pt_i, eta_w1_i, eta_w2_i, eta_w3_i, eta_w4_i, eta_w5_i, phi_w1_i,phi_w2_i, iso_i, qual_i, charge_i, cond_and_i : req_obj_array;
    
    signal cc_double_i : std_logic_2dim_array(0 to CONF.N_OBJ-1, 0 to CONF.N_OBJ-1);
    signal cc_triple_i : std_logic_3dim_array(0 to CONF.N_OBJ-1, 0 to CONF.N_OBJ-1, 0 to CONF.N_OBJ-1);
    signal cc_quad_i : std_logic_4dim_array(0 to CONF.N_OBJ-1, 0 to CONF.N_OBJ-1, 0 to CONF.N_OBJ-1, 0 to CONF.N_OBJ-1);
    signal tbpt_i : std_logic_2dim_array(0 to CONF.N_OBJ-1, 0 to CONF.N_OBJ-1);
    signal cond_and : std_logic_2dim_array(1 to CONF.N_REQ, 0 to CONF.N_OBJ-1);
    signal cond_and_or, cond_o_v : std_logic_vector(0 to 0);

begin

    cc_double_i <= charge_corr_double when (CONF.CHARGE_CORR_SEL and CONF.N_REQ = 2) else (others => (others => '1'));
    cc_triple_i <= charge_corr_triple when (CONF.CHARGE_CORR_SEL and CONF.N_REQ = 3) else (others => (others => (others => '1')));
    cc_quad_i <= charge_corr_quad when (CONF.CHARGE_CORR_SEL and CONF.N_REQ = 4) else (others => (others => (others => (others => '1'))));
    tbpt_i <= tbpt when CONF.TBPT_SEL else (others => (others => '1'));

    and_or_p: process(in_1, in_2, in_3, in_4, cc_double_i, cc_triple_i, cc_quad_i, tbpt_i)
        variable index : integer := 0;
        variable and_vec : std_logic_vector((N_SLICE_1*N_SLICE_2*N_SLICE_3*N_SLICE_4) downto 1) := (others => '0');
        variable tmp : std_logic := '0';
    begin
        index := 0;
        and_vec := (others => '0');
        tmp := '0';
        for i in CONF.SLICE_1_L to CONF.SLICE_1_H loop
            if CONF.N_REQ = 1 then
                index := index + 1;
                and_vec(index) := in_1(i);
            end if;
            for j in CONF.SLICE_2_L to CONF.SLICE_2_H loop
                if CONF.N_REQ = 2 and (j/=i) then
                    index := index + 1;
                    and_vec(index) := in_1(i) and in_2(j) and cc_double_i(i,j) and tbpt_i(i,j);
                end if;
                for k in CONF.SLICE_3_L to CONF.SLICE_3_H loop
                    if CONF.N_REQ = 3 and (j/=i and k/=i and k/=j) then
                        index := index + 1;
                        and_vec(index) := in_1(i) and in_2(j) and in_3(k) and cc_triple_i(i,j,k);
                    end if;
                    for l in CONF.SLICE_4_L to CONF.SLICE_4_H loop
                        if CONF.N_REQ = 4 and (j/=i and k/=i and k/=j and l/=i and l/=j and l/=k) then
                            index := index + 1;
                            and_vec(index) := in_1(i) and in_2(j) and in_3(k) and in_4(l) and cc_quad_i(i,j,k,l);
                        end if;
                    end loop;
                end loop;
            end loop;
        end loop;
        for i in 1 to index loop
            tmp := tmp or and_vec(i);
        end loop;
        cond_and_or(0) <= tmp;
    end process and_or_p;

    out_reg_i : entity work.out_reg_mux
        generic map(1, CONF.OUT_REG)  
        port map(clk, cond_and_or, cond_o_v);
    
    cond_o <= cond_o_v(0);
    
end architecture rtl;



