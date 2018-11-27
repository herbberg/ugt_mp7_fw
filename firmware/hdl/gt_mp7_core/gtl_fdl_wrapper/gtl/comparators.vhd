-- Description:
-- Comparators for all objects and cuts comparisons.

-- Version-history:
-- HB 2018-11-26: First design.

entity comparators is
    generic     (
        CONF : comparators_conf;
        REQ_L : std_logic_Vector(CONF.C_WIDTH-1 downto 0);
        REQ_H : std_logic_Vector(CONF.C_WIDTH-1 downto 0)
    );
    port(
        clk : in std_logic;
        data : in std_logic_3dim(CONF.N_OBJ_1_H downto 0)(CONF.N_OBJ_2_H downto 0)(CONF.C_WIDTH-1 downto 0);
        comp_o : out std_logic_2dim(CONF.N_OBJ_1_H downto 0)(CONF.N_OBJ_2_H downto 0) := (others => (others => '0'))
    );
end comparators;

architecture rtl of comparators is
begin

    constant OUT_REG_WIDTH : positive := 1;
    type std_logic_vector_2dim is array(CONF.N_OBJ_1_H downto 0)(CONF.N_OBJ_2_H downto 0) of std_logic_Vector(CONF.C_WIDTH-1 downto 0);
    signal data_vec : std_logic_vector_2dim(CONF.N_OBJ_1_H downto 0)CONF.(N_OBJ_2_H downto 0);
    signal comp : std_logic_2dim(CONF.N_OBJ_1_H downto 0)(CONF.N_OBJ_2_H downto 0);

    l1: for i in 0 to CONF.N_OBJ_1_H generate
        l2: for j in 0 to CONF.N_OBJ_2_H generate
            l3: for k in 0 to CONF.C_WIDTH-1 generate
                data_vec(i,j)(k) <= data(i,j)(k);
            end generate l3;
            if_m: if CONF.GE_MODE generate
                if_w: if CONF.WINDOW generate
                comp(i,j) => (data_vec(i,j) >= REQ_L) and (data_vec(i,j) <= REQ_H);
                end generate;
                if_n_w: if not WINDOW generate
                comp(i,j) => data_vec(i,j) >= REQ_L;
                end generate;
            end generate;
            if_n_m: if not GE_MODE generate
                comp(i,j) => data_vec(i,j) = REQ_L;
            end generate;
            out_reg_i : entity work.out_reg_mux
                generic map(OUT_REG_WIDTH, CONF.OUT_REG);  
                port map(clk, comp(i,j), comp_o(i,j)); 
        end generate l2;
    end generate l1;

end architecture rtl;
