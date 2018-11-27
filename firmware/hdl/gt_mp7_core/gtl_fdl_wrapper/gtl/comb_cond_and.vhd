-- Description:
-- Combinatorial conditions AND logic.

-- Version-history:
-- HB 2018-11-26: First design.

entity comb_cond_and is
    generic(
        N_OBJ : natural := 12;
        ETA_SEL : boolean := true;
        PHI_SEL : boolean := true;
        ISO_SEL : boolean := true;
        QUAL_SEL : boolean := false;
        CHARGE_SEL : boolean := false;
    );
    port(
        pt : in std_logic_vector(N_OBJ-1 downto 0);
        eta_w1 : in std_logic_vector(N_OBJ-1 downto 0);
        eta_w2 : in std_logic_vector(N_OBJ-1 downto 0);
        eta_w3 : in std_logic_vector(N_OBJ-1 downto 0);
        eta_w4 : in std_logic_vector(N_OBJ-1 downto 0);
        eta_w5 : in std_logic_vector(N_OBJ-1 downto 0);
        phi_w1 : in std_logic_vector(N_OBJ-1 downto 0);
        phi_w2 : in std_logic_vector(N_OBJ-1 downto 0);
        iso : in std_logic_vector(N_OBJ-1 downto 0);
        qual : in std_logic_vector(N_OBJ-1 downto 0);
        charge : in std_logic_vector(N_OBJ-1 downto 0);
        cond_and : out std_logic_vector(N_OBJ-1 downto 0)
    );
end comb_cond_and;

architecture rtl of comb_cond_single is

    signal eta_i, phi_i, iso_i, qual_i, charge_i : std_logic_vector(N_OBJ-1 downto 0) := (others => '1');
    
begin

    and_i : for i in 0 to N_OBJ-1 generate
        eta_i(i) <= (eta_w1(i) or eta_w2(i) or eta_w3(i) or eta_w4(i) or eta_w5(i)) when ETA_SEL else (others => '1');
        phi_i(i) <= (phi_w1(i) or phi_w2(i)) when PHI_SEL else (others => '1');
        iso_i(i) <= iso(i) when ISO_SEL else (others => '1');
        qual_i(i) <= qual(i) when QUAL_SEL else (others => '1');
        charge_i(i) <= charge(i) when CHARGE_SEL else (others => '1');
        cond_and(i) <= pt(i) and eta_i(i) and phi_i(i) and iso_i(i) and qual_i(i) and charge_i(i);
    end generate and_i;

end architecture rtl;



