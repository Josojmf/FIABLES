--------------------------------------------------------------------------------
--
-- Title       : 	FSM for the Synchronous clock
-- Design      :	Synchronous Clock generator
-- Author      :	Pablo Sarabia Ortiz
-- Company     :	Universidad de Nebrija
--------------------------------------------------------------------------------
-- File        : fsm_sclk.vhd
-- Generated   : 20 February 2022
--------------------------------------------------------------------------------
-- Description : Generates a synchronous clock (SCLK) and a rising/falling edge 
--				signal (SCLK_rise/ SCLK_fall) it has a negative asynchronous 
--				reset (n_rst) and a generic to indicate the period of the 
-- 				synchronous clock.  
	
--------------------------------------------------------------------------------
-- Revision History :
-- -----------------------------------------------------------------------------

--   Ver  :| Author            :| Mod. Date :|    Changes Made:

--   v1.0  | Pablo Sarabia     :| 20/02/22  :| First version

-- -----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm_sclk is
	generic(
		g_freq_SCLK_KHZ	: integer := 1_500; -- Frequency in KHz of the 
											--synchronous generated clk
		g_system_clock 	: integer := 100_000 --Frequency in KHz of the system clk
	);
	port (
		rst_n		: in std_logic; -- asynchronous reset, low active
		clk 		: in std_logic; -- system clk
		start		: in std_logic; -- signal to start the synchronous clk
		SCLK 		: out std_logic;-- Synchronous clock at the g_freq_SCLK_KHZ
		SCLK_rise	: out std_logic;-- one cycle signal of the rising edge of SCLK
		SCLK_fall	: out std_logic -- one cycle signal of the falling edge of SCLK
	);
end fsm_sclk;

architecture behavioural of fsm_sclk is

	-- Tenéis que hacer la conversion necesaria para sacar la constante que indique
	--	el número de ciclos para medio periodo del SCLK. Debéis usar floor 
	-- para el redondeo (que opera con reales)
	constant c_half_T_SCLK : integer := integer(); --constant value to compare and generate the rising/falling edge 
	constant c_counter_width : integer := integer(); -- the width of the counter, take as reference the debouncer
	begin
	end