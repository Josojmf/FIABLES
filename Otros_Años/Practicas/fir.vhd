--------------------------------------------------------------------------------
--
-- Title       : 	FIR filter
-- Design      :	
-- Author      :	Pablo Sarabia Ortiz
-- Company     :	Universidad de Nebrija
--------------------------------------------------------------------------------
-- File        : fir.vhd
-- Generated   : 03 May 2022
--------------------------------------------------------------------------------
-- Description : Problema 2.4 Arbitro prioridad dinamica
-- Enunciado   :
-- FIR 8 bit filter with four stages
--------------------------------------------------------------------------------
-- Revision History :
-- -----------------------------------------------------------------------------

--   Ver  :| Author            :| Mod. Date :|    Changes Made:

--   v1.0  | Pablo Sarabia     :| 03/05/22  :| First version

-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir_filter is
port (
	clk		:in std_logic;
	rst		:in std_logic;
	-- Coeficientes
	beta1	:in std_logic_vector(7 downto 0);
 	beta2	:in std_logic_vector(7 downto 0);
	beta3	:in std_logic_vector(7 downto 0);
	beta4	:in std_logic_vector(7 downto 0);
	-- Data input 8 bit
	i_data 	:in std_logic_vector(7 downto 0);
	-- Filtered data
	o_data 	:out std_logic_vector(9 downto 0)
	);
end fir_filter;

