--------------------------------------------------------------------------------
--
-- Title       : 	Debounce Logic module
-- Design      :	
-- Author      :	Ignacio Aznarez Ramos
-- Company     :	Universidad de Nebrija
--------------------------------------------------------------------------------
-- File        : debouncer.vhd
-- Generated   : February 2024
--------------------------------------------------------------------------------
-- Description : Given a synchronous signal it debounces it.
--------------------------------------------------------------------------------
-- Revision History :
-- -----------------------------------------------------------------------------

--   Ver  :| Author            :| Mod. Date :|    Changes Made:

--   v1.0  | Ignacio Aznarez     :| 02/24  :| First version

-- -----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity debouncer is
    generic(
        g_timeout          : integer   := 5;        -- Time in ms
        g_clock_freq_KHZ   : integer   := 100_000   -- Frequency in KHz of the system 
    );   
    port (  
        rst_n       : in    std_logic; -- asynchronous reset, low -active
        clk         : in    std_logic; -- system clk
        ena         : in    std_logic; -- enable must be on 1 to work (kind of synchronous reset)
        sig_in      : in    std_logic; -- signal to debounce
        debounced   : out   std_logic  -- 1 pulse flag output when the timeout has occurred
    ); 
end debouncer;


architecture Behavioural of debouncer is 
      
    -- Calculate the number of cycles of the counter (debounce_time * freq), result in cycles
    constant c_cycles           : integer := integer(g_timeout * g_clock_freq_KHZ) ;
	-- Calculate the length of the counter so the count fits
    constant c_counter_width    : integer := integer(ceil(log2(real(c_cycles))));
    
    -- -----------------------------------------------------------------------------
    -- Declarar un tipo para los estados de la fsm usando type
    -- -----------------------------------------------------------------------------
    
    type state is (IDLE, BTN_PRS, VALID, BTN_UNPRS);
    signal current_state, next_state: state;
    
    signal count: unsigned (c_counter_width-1 downto 0);
    signal time_elapsed, debounced_aux: std_logic;
    
begin
    --Timer
    process (clk, rst_n)
    begin
    -- -----------------------------------------------------------------------------
	-- Completar el timer que genera la señal de time_elapsed para trancionar en 
	-- las máquinas de estados
	-- -----------------------------------------------------------------------------
     if(rst_n = '0') then
                count <= (others => '0');
            elsif (rising_edge(clk)) then
                time_elapsed <= '0';
                if(current_state=BTN_PRS) then
                    if ((count < c_cycles) and (next_state /= VALID))then
                        count<= count +1;
                    else
                        time_elapsed <= '1';
                        count <= (others => '0');
                    end if;
                elsif(current_state=BTN_UNPRS) then
                    if (count < c_cycles) and (next_state /= VALID)then
                        count<= count +1;
                    else
                        time_elapsed <= '1';
                        count <= (others => '0');
                    end if;
                elsif((current_state=IDLE) or ((current_state=VALID) and (next_state = BTN_PRS or next_state= BTN_UNPRS ))) then
                    count <= count+1;
                end if;
                end if;
        end process;

    --FSM Register of next state
    process (clk, rst_n) begin
        if(rst_n = '0') then
            current_state <= IDLE;
            debounced <='0';
        elsif (rising_edge(clk)) then
            current_state <= next_state;
            debounced <= debounced_aux;
        end if;

    end process;
	
	process (ena,sig_in, current_state,time_elapsed)
    begin
    -- -----------------------------------------------------------------------------
	-- Completar el bloque combinacional de la FSM usar case when
	-- -----------------------------------------------------------------------------
      debounced_aux<='0';
        case current_state is
            when IDLE =>
                if(sig_in = '1') then
                    next_state <= BTN_PRS;
                else
                    next_state <= current_state;
                end if;
            when VALID =>
                if (ena = '0') then
                    next_state <= IDLE;
                elsif (sig_in = '0') then
                    next_state <= BTN_UNPRS;
                else
                    next_state <= current_state;
                end if;
                when BTN_PRS =>
                if( ena = '0') then
                    next_state <= IDLE;
                elsif (time_elapsed = '0') then
                    next_state <= current_state;
                elsif ((time_elapsed = '1') and (sig_in = '0')) then
                    next_state <= IDLE;
                elsif ((sig_in = '1') and (time_elapsed = '1')) then
                    next_state <= VALID;
                    debounced_aux<='1';
                else
                    next_state <= current_state;
                end if;
            when BTN_UNPRS =>
                if ( time_elapsed = '0') then
                    next_state <= current_state;
                elsif ((ena = '0') or (time_elapsed = '1')) then
                    next_state <= IDLE;
                else
                    next_state <= current_state;
                end if;
            when others =>
                next_state <= IDLE;
        end case;
    end process;
end Behavioural;