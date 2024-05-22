--------------------------------------------------------------------------------
--
-- Title       : 	Top module for practica 1
-- Design      :	
-- Author      :	Ignacio Aznarez Ramos
-- Company     :	Universidad de Nebrija
--------------------------------------------------------------------------------
-- File        : top_practica1.vhd
-- Generated   : 7 February 2024
--------------------------------------------------------------------------------
-- Description : Inputs and outputs for the practica 1
--------------------------------------------------------------------------------
-- Revision History :
-- -----------------------------------------------------------------------------

--   Ver  :| Author            :| Mod. Date :|    Changes Made:

--   v1.0  | Ignacio Aznarez   :| 02/24     :| First version

-- -----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_practica1 is
  generic (
      g_sys_clock_freq_KHZ  : integer := 100e3; -- Value of the clock frequencies in KHz
      g_debounce_time 		: integer := 20;  -- Time for the debouncer in ms
      g_reset_value 		: std_logic := '0'; -- Value for the synchronizer 
      g_number_flip_flps 	: natural := 2 	-- Number of ffs used to synchronize	
  );
  port (
      rst_n         : in std_logic;	--Negate reset must be connected to the switch 0 
      clk100Mhz     : in std_logic; -- Connect to the main clk
      BTNC           : in std_logic; -- Connect to the BTNC
      LED           : out std_logic --Connect to the LED 0
  );
end top_practica1;

architecture behavioural of top_practica1 is
  component debouncer is
    generic(
		-- In a generic declaration the value is overrided by the top module
        g_timeout         : integer  := 5; -- Time for debouncing (value overrided)			
        g_clock_freq_KHZ  : integer  := 100_000 -- Frequency in KHz of the system (value overrided)	
    );   
    port (  
        rst_n       : in    std_logic; -- asynchronous reset, low -active
        clk         : in    std_logic; -- system clk
        ena         : in    std_logic; -- enable must be on 1 to work (kind of synchronous reset)
        sig_in      : in    std_logic; -- signal to debounce
        debounced   : out   std_logic  -- 1 pulse flag output when the timeout has occurred
    ); 
  end component;

  component synchronizer is
  generic (
    RESET_VALUE    : std_logic 	:= '0'; -- reset value of all flip-flops in the chain
    NUM_FLIP_FLOPS : natural 	:= 2 -- number of flip-flops in the synchronizer chain
  );
  port(
    rst      : in std_logic; -- asynchronous, low-active
    clk      : in std_logic; -- destination clock
    data_in  : in std_logic; -- data that wants to be synchronized
    data_out : out std_logic -- data synchronized
  );
  end component;

  signal BTN_sync : std_logic; -- Synchronized signal of the BTNC 
  signal Toggle_LED : std_logic; -- Internal signal to connect between the 
							     --debouncer and the toggle process
  signal LED_register, state_LED : std_logic; -- The output signal of the LED 
											  --registered and unregisterd
begin
  -- DEBOUNCER
  debouncer_inst: debouncer
    generic map (
      g_timeout        => g_debounce_time, 
      g_clock_freq_KHZ => g_sys_clock_freq_KHZ
    )
    port map (
      rst_n     => rst_n,
      clk       => clk100Mhz,
      ena       => '1', -- Always enabled for this lab
      sig_in    => BTN_sync, -- Synchronized input from the synchronizer
      debounced => toggle_LED -- Output to the toggle LED process
    );
  -- SYNCHRONIZER
  synchronizer_inst: synchronizer
    generic map (
      RESET_VALUE    => g_reset_value,
      NUM_FLIP_FLOPS => g_number_flip_flps
    )
    port map (
      rst      => rst_n,
      clk      => clk100Mhz,
      data_in  => BTNC,
      data_out => BTN_sync
    );
  --  PROCESS to register LED output 
  registerLED: process(clk100Mhz, rst_n) is
  begin
    if (rst_n = '0') then
	  -- -----------------------------------------------------------------------------
      -- Completar con el valor inicial del registro
	  -- -----------------------------------------------------------------------------
    LED_register <= '0';
    elsif rising_edge(clk100Mhz) then
	  -- -----------------------------------------------------------------------------	
      -- Registrar valor
	  -- -----------------------------------------------------------------------------
    LED_register <= state_LED;
    end if;
  end process;  
  -- PROCESS to toggle LED
  toggleLED: process(LED_register, Toggle_LED)
  begin 
  -- -----------------------------------------------------------------------------
    state_LED <= LED_register XOR Toggle_LED; --Completar con la lógica del LED (toggle)
  -- -----------------------------------------------------------------------------		
  end process;
  -- Connect LED_register to the output
  LED <= LED_register;
end behavioural;
  