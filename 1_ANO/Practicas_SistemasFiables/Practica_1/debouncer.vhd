--------------------------------------------------------------------------------
--
-- Title       : 	Debounce Logic module
-- Design      :	
-- Author      :	Pablo Sarabia Ortiz
-- Company     :	Universidad de Nebrija
--------------------------------------------------------------------------------
-- File        : debouncer.vhd
-- Generated   : 7 February 2022
--------------------------------------------------------------------------------
-- Description : Given a synchronous signal it debounces it.
--------------------------------------------------------------------------------
-- Revision History :
-- -----------------------------------------------------------------------------

--   Ver  :| Author            :| Mod. Date :|    Changes Made:

--   v1.0  | Pablo Sarabia     :| 07/02/22  :| First version

--   v1.1  | Jorge Callado, Pablo rayon, Fernando perez

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
    
    SIGNAL COUNT : integer:=0;
    SIGNAL Time_elapsed : std_logic;
    -- -----------------------------------------------------------------------------
    -- Declarar un tipo para los estados de la fsm usando type
    TYPE State_type IS (IDLE, BTN_PRS, VALID, BTN_UNPRS);
    SIGNAL State : State_type := IDLE;
    SIGNAL NextState : State_type := IDLE;
    -- -----------------------------------------------------------------------------
    
    
begin
    --Timer
    process (clk, rst_n)
    begin
    -- -----------------------------------------------------------------------------
	-- Completar el timer que genera la señal de time_elapsed para trancionar en 
	-- las máquinas de estados
        if (rising_edge(CLK)) then
            if (COUNT = c_counter_width) then
                time_elapsed <= '1';
                COUNT <= 0;
            elsif(state = BTN_PRS or state = BTN_UNPRS )then
                COUNT <= COUNT + 1;
                time_elapsed <= '0';
            end if;
            
            
        end if;
	-- -----------------------------------------------------------------------------
    end process;

    --FSM Register of next state
    process (clk, rst_n)
    begin
  
    -- -----------------------------------------------------------------------------
	-- Completar 
	    if(rst_n='0')then
            state <= IDLE;   
	    elsif (rising_edge(clk)) then
            state <= NextState; 
        end if;
	-- -----------------------------------------------------------------------------
  
    end process;
	
    process (clk)--sensitivity list)
    begin
    -- -----------------------------------------------------------------------------
	-- Completar el bloque combinacional de la FSM usar case when
	case STATE is
	when IDLE =>
	   if (sig_in = '1') then
	       NextState <= BTN_PRS;
	   else NextState <= state;
	   end if;
	   debounced <= '0';
	when BTN_PRS =>
        if ((time_elapsed = '1') and (sig_in = '0')) then
            NextState <= IDLE;
        elsif ((time_elapsed = '1') and (sig_in = '1')) then
            NextState <= VALID;
        else    
            NextState <= state;
        end if;
        debounced <= '0';
	when VALID =>
	    if (sig_in = '0') then
            NextState <= BTN_UNPRS;
        else
            NextState <= State;
        end if;
            debounced <= '1';
	when BTN_UNPRS =>
	    if ( time_elapsed = '0') then
            NextState <= State;
        elsif ((sig_in = '0') and (time_elapsed = '1')) then
            NextState <= IDLE;
         else
            NextState <= VALID;
         end if;
         debounced <= '1';
	end case;
	-- -----------------------------------------------------------------------------
      
    end process;
end Behavioural;