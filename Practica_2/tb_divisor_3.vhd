--------------------------------------------------------------------------------
--
-- Title       : 	Test bench de divisor de frequencia
-- Author      :	Ignacio Aznarez Ramos
-- Company     :	Universidad de Nebrija
--------------------------------------------------------------------------------
-- File        : tb_divisor_3.vhd
-- Generated   : February 2024
--------------------------------------------------------------------------------
-- Description : 
	
--------------------------------------------------------------------------------
-- Revision History :
-- -----------------------------------------------------------------------------

--   Ver  :| Author            :| Mod. Date :|    Changes Made:

--   v1.0  | Ignacio Aznarez   :| Feb/24    :| First version

-- -----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_divisor_3 is
end entity;

architecture test of tb_divisor_3 is

  component divisor_3 is
    port(
      clk:       in     std_logic;
      nRst:      in     std_logic;
      f_div_2_5: buffer std_logic;
      f_div_1_25: buffer std_logic;
      f_div_500:  buffer std_logic
    );
  end component;
  
  signal clk:         std_logic := '0';
  signal nRst:        std_logic := '0';
  signal f_div_2_5:   std_logic;
  signal f_div_1_25:  std_logic;
  signal f_div_500:   std_logic;
  
  signal end_simulation: boolean := false;
  
  -- modifique la siguiente constante para un reloj de 10 MHz
  constant T_clk: time := 100 ns;
  
begin
----------------------------------------------------------
-- Instancie el bloque divisor de frecuencia que sera testeado
---------------------------------------------------------- 
uut: divisor_3
     port map(
       clk => clk,
       nRst => nRst,
       f_div_2_5 => f_div_2_5,
       f_div_1_25 => f_div_1_25,
       f_div_500 => f_div_500
     );
                                 
-----------------------------------------------              
-- Genere el proceso para un reloj de 10 MHz
-----------------------------------------------
clk_process: process
begin
  while not end_simulation loop
    clk <= not clk;      -- Cambia el valor del reloj cada medio periodo
    wait for T_clk / 2;  -- Espera medio periodo
  end loop;
  wait;
end process clk_process;

-- Secuencia de test
test_process: process
begin
  -- Secuencia de reset
  wait until clk'event and clk = '1';
  wait until clk'event and clk = '1';
  nRst <= '1';                         -- Reset inactivo
  wait until clk'event and clk = '1';
  nRst <= '0';                         -- Reset activo
  wait until clk'event and clk = '1';
  nRst <= '1';                         -- Reset inactivo
  -- Fin de secuencia de reset
  
  -- Complete el test para que puedan observarse
  -- 5 periodos de reloj en la salida f_div_500
  for i in 1 to 5 loop
    wait until clk'event and clk = '1'; 
  end loop;
  end_simulation <= true;  -- Finaliza la simulación
  wait;
end process test_process;

end test;