-- Description:
-- Combinatorial conditions for all object types.

-- Version-history:
-- HB 2018-11-26: First design.

-- comb_cond_record:
-- n_req
-- slice_l
-- slice_h
-- n_eta_w
-- n_phi_w
-- iso_sel
-- charge_sel
-- tbpt_sel
-- charge_corr_sel	
-- 
-- obj_cuts_type: array(N_REQ_MAX-1 downto 0) of std_logic_vector(N_OBJ_MAX-1 downto 0)
-- tbpt_cut_type: ?
-- charge_corr_type: ?

entity comb_cond is
    generic     (
        CONFIG : comb_cond_record;
        OUT_REG : boolean
    );
    port(
        clk : out std_logic
        pt : in obj_cuts_type;
        eta_w1 : in obj_cuts_type;
        eta_w2 : in obj_cuts_type;
        eta_w3 : in obj_cuts_type;
        eta_w4 : in obj_cuts_type;
        eta_w5 : in obj_cuts_type;
        phi_w1 : in obj_cuts_type;
        phi_w2 : in obj_cuts_type;
        iso : in obj_cuts_type;
        charge : in obj_cuts_type;
        tbpt : in tbpt_cut_type;
        charge_corr : in charge_corr_type;
        cond_o : out std_logic
    );
end comb_cond;

architecture rtl of comb_cond is
begin

    out_reg_p: process(clk, cond)
    begin
        if OUT_REG = false then
            cond_o <= cond;
        else
            if (clk'event and clk = '1') then
                cond_o <= cond;
            end if;
        end if;
    end process;

end architecture rtl;



