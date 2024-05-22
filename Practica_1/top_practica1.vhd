--------------------------------------------------------------------------------
--
-- Title       : 	Top module for practica 1
-- Design      :
-- Author      :	Pablo Sarabia Ortiz
-- Company     :	Universidad de Nebrija
--------------------------------------------------------------------------------
-- File        : top_practica1.vhd
-- Generated   : 7 February 2022
--------------------------------------------------------------------------------
-- Description : Inputs and outputs for the practica 1
--------------------------------------------------------------------------------
-- Revision History :
-- -----------------------------------------------------------------------------

--   Ver  :| Author            :| Mod. Date :|    Changes Made:

--   v1.0  | Pablo Sarabia     :| 07/02/22  :| First version

-- -----------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY top_practica1 IS
  GENERIC (
    g_sys_clock_freq_KHZ : INTEGER := 100e3; -- Value of the clock frequencies in KHz
    g_debounce_time : INTEGER := 20; -- Time for the debouncer in ms
    g_reset_value : STD_LOGIC := '0'; -- Value for the synchronizer
    g_number_flip_flps : NATURAL := 2 -- Number of ffs used to synchronize
  );
  PORT (
    rst_n : IN STD_LOGIC; --Negate reset must be connected to the switch 0
    clk100Mhz : IN STD_LOGIC; -- Connect to the main clk
    BTNC : IN STD_LOGIC; -- Connect to the BTNC
    LED : OUT STD_LOGIC --Connect to the LED 0
  );
END top_practica1;

ARCHITECTURE behavioural OF top_practica1 IS
  COMPONENT debouncer IS
    GENERIC (
      -- In a generic declaration the value is overrided by the top module
      g_timeout : INTEGER := 5; -- Time for debouncing (value overrided)
      g_clock_freq_KHZ : INTEGER := 100_000 -- Frequency in KHz of the system (value overrided)
    );
    PORT (
      rst_n : IN STD_LOGIC; -- asynchronous reset, low -active
      clk : IN STD_LOGIC; -- system clk
      ena : IN STD_LOGIC; -- enable must be on 1 to work (kind of synchronous reset)
      sig_in : IN STD_LOGIC; -- signal to debounce
      debounced : OUT STD_LOGIC -- 1 pulse flag output when the timeout has occurred
    );
  END COMPONENT;

  COMPONENT synchronizer IS
    GENERIC (
      RESET_VALUE : STD_LOGIC := '0'; -- reset value of all flip-flops in the chain
      NUM_FLIP_FLOPS : NATURAL := 2 -- number of flip-flops in the synchronizer chain
    );
    PORT (
      rst : IN STD_LOGIC; -- asynchronous, low-active
      clk : IN STD_LOGIC; -- destination clock
      data_in : IN STD_LOGIC; -- data that wants to be synchronized
      data_out : OUT STD_LOGIC -- data synchronized
    );
  END COMPONENT;

  SIGNAL BTN_sync : STD_LOGIC; -- Synchronized signal of the BTNC
  SIGNAL Toggle_LED : STD_LOGIC; -- Internal signal to connect between the
  --debouncer and the toggle process
  SIGNAL LED_register, state_LED : STD_LOGIC; -- The output signal of the LED
  --registered and unregisterd
BEGIN
  -- DEBOUNCER
  debouncer_inst : debouncer
  GENERIC MAP(
    g_timeout => g_debounce_time,
    g_clock_freq_KHZ => g_sys_clock_freq_KHZ
  )
  PORT MAP(
    rst_n => rst_n,
    clk => clk100Mhz,
    ena => '1', -- Always enabled for this lab
    sig_in => BTN_sync, -- Synchronized input from the synchronizer
    debounced => toggle_LED -- Output to the toggle LED process
  );
  -- SYNCHRONIZER
  synchronizer_inst : synchronizer
  GENERIC MAP(
    RESET_VALUE => g_reset_value,
    NUM_FLIP_FLOPS => g_number_flip_flps
  )
  PORT MAP(
    rst => rst_n,
    clk => clk100Mhz,
    data_in => BTNC,
    data_out => BTN_sync
  );
  --  PROCESS to register LED output
  registerLED : PROCESS (clk100Mhz, rst_n) IS
  BEGIN
    IF (rst_n = '0') THEN
      -- -----------------------------------------------------------------------------
      -- Completar con el valor inicial del registro
      -- -----------------------------------------------------------------------------
      LED_register <='0';
    ELSIF rising_edge(clk100Mhz) THEN
      -- -----------------------------------------------------------------------------
      -- Registrar valor
      -- -----------------------------------------------------------------------------
      LED_register <= state_LED;
    END IF;
  END PROCESS;
  -- PROCESS to toggle LED
  toggleLED : PROCESS (LED_register, Toggle_LED)
  BEGIN
    -- -----------------------------------------------------------------------------
    state_LED <= LED_register XOR Toggle_LED;
    -- -----------------------------------------------------------------------------
  END PROCESS;
  -- Connect LED_register to the output
  LED <= LED_register;
END behavioural;
