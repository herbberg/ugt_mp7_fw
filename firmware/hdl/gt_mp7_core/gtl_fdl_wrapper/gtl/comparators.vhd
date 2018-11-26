-- Description:
-- Comparators for all objects and cuts comparisons.

-- Version-history:
-- HB 2018-11-26: First design.

entity comparators is
    generic     (
        N_OBJ_1_H : integer := 11;
        N_OBJ_2_H : integer := 0;
        C_WIDTH : integer := 9;
        MODE : bool := true;
        WINDOW : bool := false;
        REQ_L : std_logic_Vector(C_WIDTH-1 downto 0)
        REQ_H : std_logic_Vector(C_WIDTH-1 downto 0)
        OUT_REG : boolean
    );
    port(
        data : in std_logic_3dim(N_OBJ_1_H downto 0)(N_OBJ_2_H downto 0)(C_WIDTH-1 downto 0);
        comp_o : out std_logic_2dim(N_OBJ_1_H downto 0)(N_OBJ_2_H downto 0) := (others => (others => '0'))
    );
end comparators;

architecture rtl of comparators is
begin

    type std_logic_vector_2dim is array(N_OBJ_1_H downto 0)(N_OBJ_2_H downto 0) of std_logic_Vector(C_WIDTH-1 downto 0);
    signal data_vec : std_logic_vector_2dim(N_OBJ_1_H downto 0)(N_OBJ_2_H downto 0);
    signal comp : std_logic_2dim(N_OBJ_1_H downto 0)(N_OBJ_2_H downto 0);

    l1: for i in 0 to N_OBJ_1_H generate
        l2: for j in 0 to N_OBJ_2_H generate
            l3: for k in 0 to C_WIDTH-1 generate
                data_vec(i)(j)(k) <= data(i)(j)(k);
            end generate l3;
            if_m: if MODE generate
                if_w: if WINDOW generate
                comp => (data_vec(i)(j) >= REQ_L) and (data_vec(i)(j) <= REQ_H);
                end generate;
                if_n_w: if not WINDOW generate
                comp => data_vec(i)(j) >= REQ_L;
                end generate;
            end generate;
            if_n_m: if not MODE generate
                comp => data_vec(i)(j) = REQ_L;
            end generate;
        end generate l2;
    end generate l1;

    out_reg_p: process(clk, cond)
    begin
        if OUT_REG = false then
            comp_o <= comp;
        else
            if (clk'event and clk = '1') then
                comp_o <= comp;
            end if;
        end if;
    end process;

end architecture rtl;
