--------------------------------------------------------------------------------
--
-- Title       : 	Testbench for the top module
-- Design      :	
-- Author      :	Ignacio Aznarez Ramos
-- Company     :	Universidad de Nebrija
--------------------------------------------------------------------------------
-- File        : tb_debouncer.vhd
-- Generated   : February 2024
--------------------------------------------------------------------------------
-- Description : This testbench based on an async signal will test if the output 
--    toggles when the duration of the debounce has finished
--    
--------------------------------------------------------------------------------
-- Revision History :
-- -----------------------------------------------------------------------------

--   Ver  :| Author            :| Mod. Date :|    Changes Made:

--   v1.0  | Ignacio Aznarez   :| 02/24  :| First version


-- -----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library std;
use STD.TEXTIO.ALL;

entity tb_top is 
end tb_top;

architecture testBench of tb_top is
  component top_practica1 is
  port (
      rst_n         : in std_logic;
      clk100Mhz     : in std_logic;
      BTNC           : in std_logic;
      LED           : out std_logic
  );
end component;

  constant timer_debounce : integer := 10; --ms
  constant freq : integer := 100_000; --KHZ
  constant clk_period : time := (1 ms/ freq);
  
  file file_input : text; -- Manejar ficheros
  file file_output : text;

  -- Inputs 
  signal  rst_n       :   std_logic := '0';
  signal  clk         :   std_logic := '0';
  signal  BTN     :   std_logic := '0';
  -- Output
  signal  LED   :   std_logic;
  --Senhal fin de simulacion
  signal  fin_sim : boolean := false;
  
begin
  UUT: top_practica1
    port map (
      rst_n     => rst_n,
      clk100Mhz => clk,
      BTNC       => BTN,
      LED       => LED
    );
	
  --Proceso de generacion del reloj 
  clock: process
  begin
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
      if fin_sim = true then
        wait;
      end if;
  end process;
  
  process is 
  
    -- Variables para manejar los ficheros
    variable v_estado_input : file_open_status;
    variable v_estado_output : file_open_status;
    
    variable v_iLINE : line;
    variable V_oLine : line;
    
    -- Variables para los valores de entrada
    
    variable v_time : time;
    variable v_rst : integer;
    variable v_btn : integer;
  
    -- Variables para los valores de salida
    
    variable v_xptc_led : integer;
    
  begin
  
  file_open(v_estado_input, file_input, "../../../../input.txt", read_mode);
  file_open(v_estado_input, file_output, "../../../../output.txt", write_mode);
  
  -- Verificamos que se haya abierto
  assert v_estado_input = open_ok
    report "Could not open file input.txt"
    severity failure;
    
  assert v_estado_output = open_ok
    report "Could not open file output.txt"
    severity failure;
   
   wait until rising_edge(clk);
   wait until rising_edge(clk);
   rst_n <= '1';
   wait until rising_edge(clk);
   rst_n <= '0';
   wait until rising_edge(clk);
   rst_n <= '1';
   
   -- Fin de secuencia de reset
   wait until rising_edge(clk);
   
   
   
   while not endfile(file_input) loop
    readline(file_input, v_iline);
    
    read(v_iline, v_time);
        report "The value of v_time is " & time'image(v_time);
        
    read(v_iline, v_rst);
        report "The value of v_rst is " & integer'image(v_rst);

    read(v_iline, v_btn);
        report "The value of v_btn is " & integer'image(v_btn);

    read(v_iline, v_xptc_led);
        report "The value of v_xptc_led is " & integer'image(v_xptc_led);
        
     rst_n <= to_unsigned(v_rst, 1)(0);
     BTN <= to_unsigned(v_btn, 1)(0);
     
     wait for v_time;
     
     write(file_output, "Time value is:" &time'image(v_time));
     write(file_output, "nRst value is:" &integer'image(v_rst));
     write(file_output, "Led value is:" &integer'image(v_xptc_led));
     writeline(file_output, v_oLINE);

    
   end loop;
   
   write(file_output, "End simulation");
   
  

	-- Fin simulacion
	fin_sim <= true;
	wait;
	
  end process;
end testBench;