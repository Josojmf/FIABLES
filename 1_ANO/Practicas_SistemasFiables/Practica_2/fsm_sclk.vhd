library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity fsm_sclk is
    generic(
        g_freq_SCLK_KHZ	: integer := 1500000; 
        g_system_clock 	: integer := 100000000 
    );
    port (
        clk 		: in std_logic; 
        rst_n		: in std_logic; 
        start		: in std_logic; 
        SCLK 		: out std_logic;
        SCLK_rise	: out std_logic;
        SCLK_fall	: out std_logic 
    );
end fsm_sclk;

architecture behavioural of fsm_sclk is
    constant c_half_T_SCLK : integer := integer (floor(real(g_system_clock) / real( g_freq_SCLK_KHZ ))); 
    constant c_counter_width : integer := integer(ceil(log2(real(c_half_T_SCLK)))); 
    signal count : integer:=0;

    type state_type is (IDLE,SCLK0,SCLK1);
    signal current_state,next_state:state_type;

    signal time_elapsed, enable_count,SCLK_f_aux,SCLK_r_aux: std_logic;
begin

    process (clk ,rst_n ) begin
        if( rst_n = '0') then
            current_state <= IDLE;
            count <= 0;
            time_elapsed <= '0';
            SCLK_fall <= '0';
            SCLK_rise <= '0';
        else
            if ( rising_edge(clk) ) then
                current_state <= next_state;
                SCLK_fall <= SCLK_f_aux;
                SCLK_rise <= SCLK_r_aux;
                if(enable_count = '1') then
                    if (count < c_half_T_SCLK) then
                        count <= count +1;
                        time_elapsed <=  '0';
                    else
                        time_elapsed <= '1';
                        count <= 0;
                    end if;
                end if;
            end if;
        end if;
    end process;

    process (current_state,start,time_elapsed, count) begin
        if(rst_n ='0')then
            SCLK<='0';
            SCLK_f_aux <= '0';
            SCLK_r_aux <= '0';
        end if;
        SCLK_f_aux <= '0';
        SCLK_r_aux <= '0';
        case current_state is
            when IDLE =>
                enable_count <= '0';
                if ( start = '1' ) then
                    next_state <= SCLK0;
                    enable_count <='1';
                else
                    next_state <= current_state;
                end if;
            when SCLK0 =>
                SCLK <='0';
                if (time_elapsed ='1') then
                    next_state <= SCLK1;
                    SCLK_r_aux <= '1';
                else
                    next_state <= current_state;
                end if;
            when SCLK1 =>
                SCLK <= '1';
                if (time_elapsed ='1') then
                    next_state <= SCLK0;
                    SCLK_f_aux <= '1';
                else
                    next_state <= current_state;
                end if;
            when others =>
                next_state <= IDLE;
        end case;

    end process;

end architecture;