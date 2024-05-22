--------------------------------------------------------------------------------
--
-- Title       : 	Divisor de frequencia
-- Author      :	Ignacio Aznarez Ramos
-- Company     :	Universidad de Nebrija
--------------------------------------------------------------------------------
-- File        : divisor_3.vhd
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

entity divisor_3 is
  port(clk:       in     std_logic;
       nRst:      in     std_logic;
       f_div_2_5: buffer std_logic;
       f_div_1_25: buffer std_logic;
       f_div_500:  buffer std_logic);
end entity;

architecture rtl of divisor_3 is
  signal cnt_div_2_5: std_logic_vector(1 downto 0);
  signal cnt_div_1_25 : std_logic;
  signal cnt_div_500 : std_logic_vector(2 downto 0);
begin

  -- Generador de reloj síncrono para f_div_2_5
    process(clk, nRst)
    begin
      if nRst = '0' then
        cnt_div_2_5 <= (others=> '0');
      elsif rising_edge(clk) then
        if (cnt_div_2_5 < 4) then
          cnt_div_2_5 <= (others => '0');
        else
          cnt_div_2_5 <= cnt_div_2_5 + 1;
        end if;
      end if;
    end process;

  f_div_2_5 <= '1' when cnt_div_2_5 = 3 else '0'; -- Frecuencia dividida por 2.5

  -- Registro de desplazamiento para f_div_1_25
    process(clk, nRst)
    begin
      if nRst = '0' then
        cnt_div_1_25 <= '0';
      elsif rising_edge(clk) then
      if (f_div_2_5 = '1') then
        if (cnt_div_1_25 = '1') then
          cnt_div_1_25 <= '0';
        else
          cnt_div_1_25 <= '1';
        end if;
        end if;
      end if;
    end process;

  f_div_1_25 <= '1' when cnt_div_1_25 = '1' and f_div_2_5 = '1' else '0'; -- Frecuencia dividida por 1.25

  -- Contador para f_div_500
process(clk, nRst)
    begin
      if nRst = '0' then
        cnt_div_500 <= (others=> '0');
      elsif rising_edge(clk) then
      if (f_div_2_5 = '1') then
        if (cnt_div_500 < 5) then
          cnt_div_500 <= (others => '0');
        else
          cnt_div_500 <= cnt_div_500 + 1;
        end if;
        end if;
      end if;
    end process;

  f_div_500 <= '1' when cnt_div_500 = 5 and f_div_2_5 = '1' else '0'; -- Frecuencia dividida por 500


end rtl;