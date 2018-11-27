-- Description:
-- Combinatorial conditions

-- Version-history:
-- HB 2018-11-26: First design.

entity comb_cond is
    generic(
        N_REQ : natural := 4;
        N_OBJ : natural := 12;
        SLICE_1_L : natural := 0;
        SLICE_1_H : natural := 11;
        SLICE_2_L : natural := 0;
        SLICE_2_H : natural := 11;
        SLICE_3_L : natural := 0;
        SLICE_3_H : natural := 11;
        SLICE_4_L : natural := 0;
        SLICE_4_H : natural := 11;
        ETA_SEL : boolean := true;
        PHI_SEL : boolean := true;
        ISO_SEL : boolean := true;
        QUAL_SEL : boolean := false;
        CHARGE_SEL : boolean := false;
        CHARGE_CORR_SEL : boolean := false;
        TBPT_SEL : boolean := false;
        OUT_REG : boolean
    );
    port(
        clk : in std_logic;
        pt : in std_logic_2dim_array(1 to N_REQ)(N_OBJ-1 downto 0);
        eta_w1 : in std_logic_2dim_array(1 to N_REQ)(N_OBJ-1 downto 0);
        eta_w2 : in std_logic_2dim_array(1 to N_REQ)(N_OBJ-1 downto 0);
        eta_w3 : in std_logic_2dim_array(1 to N_REQ)(N_OBJ-1 downto 0);
        eta_w4 : in std_logic_2dim_array(1 to N_REQ)(N_OBJ-1 downto 0);
        eta_w5 : in std_logic_2dim_array(1 to N_REQ)(N_OBJ-1 downto 0);
        phi_w1 : in std_logic_2dim_array(1 to N_REQ)(N_OBJ-1 downto 0);
        phi_w2 : in std_logic_2dim_array(1 to N_REQ)(N_OBJ-1 downto 0);
        iso : in std_logic_2dim_array(1 to N_REQ)(N_OBJ-1 downto 0);
        qual : in std_logic_2dim_array(1 to N_REQ)(N_OBJ-1 downto 0);
        charge : in std_logic_2dim_array(1 to N_REQ)(N_OBJ-1 downto 0);
        charge_corr_double : in std_logic_2dim_array(N_OBJ-1 downto 0)(N_OBJ-1 downto 0);
        charge_corr_triple : in std_logic_2dim_array(N_OBJ-1 downto 0)(N_OBJ-1 downto 0)(N_OBJ-1 downto 0);
        charge_corr_quad : in std_logic_2dim_array(N_OBJ-1 downto 0)(N_OBJ-1 downto 0)(N_OBJ-1 downto 0)(N_OBJ-1 downto 0);
        tbpt : in std_logic_2dim_array(N_OBJ-1 downto 0)(N_OBJ-1 downto 0);
        cond_o : out std_logic
    );
end comb_cond;

architecture rtl of comb_cond is

    constant OUT_REG_WIDTH : positive := 1;
    constant N_SLICE_1 : positive := SLICE_1_H - SLICE_1_L + 1;
    constant N_SLICE_2 : positive := SLICE_2_H - SLICE_2_L + 1;
    constant N_SLICE_3 : positive := SLICE_3_H - SLICE_3_L + 1;
    constant N_SLICE_4 : positive := SLICE_4_H - SLICE_4_L + 1;
    signal cond_and : std_logic_2dim_array(1 to N_REQ)(N_OBJ-1 downto 0);
    signal cond_and_or : std_logic;

begin

    and_l : for i in 1 to N_REQ generate 
        and_i : entity work.comb_cond_and
        generic map(N_OBJ, ETA_SEL, PHI_SEL, ISO_SEL, QUAL_SEL, CHARGE_SEL);  
        port map(pt(i), eta_w1(i), eta_w2(i), eta_w3(i), eta_w4(i), eta_w5(i), phi_w1(i), phi_w2(i), iso(i), qual(i), charge(i), cond_and(i)); 
    end generate and_l;
    
    cc_double_i <= charge_corr_double when CHARGE_CORR_SEL else (others => (others => '1'));
    cc_triple_i <= charge_corr_triple when CHARGE_CORR_SEL else (others => (others => (others => '1')));
    cc_quad_i <= charge_corr_quad when CHARGE_CORR_SEL else (others => (others => (others => (others => '1'))));
    tbpt_i <= tbpt when TBPT_SEL else (others => '1');

    and_or_p: process(cond_and, cc_double_i, cc_triple_i, cc_quad_i, tbpt_i)
        variable index : integer := 0;
        variable and_vec : std_logic_vector((N_SLICE_1*N_SLICE_2*N_SLICE_3*N_SLICE_4) downto 1) := (others => '0');
        variable cond_and_or_tmp : std_logic := '0';
    begin
        index := 0;
        and_vec := (others => '0');
        cond_and_or_tmp := '0';
        for i in SLICE_1_L to SLICE_1_H loop
            if N_REQ = 1 then
                index := index + 1;
                and_vec(index) := cond_and(1,i);
            end if;
            for j in SLICE_2_L to SLICE_2_H loop
                if N_REQ = 2 and (j/=i) then
                    index := index + 1;
                    and_vec(index) := cond_and(1,i) and cond_and(2,j) and cc_double_i(i,j) and tbpt_i(i,j);
                end if;
                for k in SLICE_3_L to SLICE_3_H loop
                    if N_REQ = 3 and (j/=i and k/=i and k/=j) then
                        index := index + 1;
                        and_vec(index) := cond_and(1,i) and cond_and(2,j) and cond_and(3,k) and cc_triple_i(i,j,k);
                    end if;
                    for l in SLICE_4_L to SLICE_4_H loop
                        if N_REQ = 4 and (j/=i and k/=i and k/=j and l/=i and l/=j and l/=k) then
                            index := index + 1;
                            and_vec(index) := cond_and(1,i) and cond_and(2,j) and cond_and(3,k) and cond_and(4,l) and cc_quad_i(i,j,k,l);
                        end if;
                    end loop;
                end loop;
            end loop;
        end loop;
        
        for i in 1 to index loop
            cond_and_or_tmp := cond_and_or_tmp or and_vec(i);
        end loop;
        cond_and_or <= cond_and_or_tmp;
    end process and_or_p;

    out_reg_i : entity work.out_reg_mux
    generic map(OUT_REG_WIDTH, OUT_REG);  
    port map(cond_and_or, cond_o); 
    
end architecture rtl;



