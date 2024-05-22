--------------------------------------------------------------------------------
--
-- Title       : 	FIR filter
-- Design      :	
-- Author      :	Ignacio Aznárez ramos
-- Company     :	Universidad de Nebrija
--------------------------------------------------------------------------------
-- File        : fir.vhd
-- Generated   : 02 May 2024
--------------------------------------------------------------------------------
-- Description : Practica 5
-- Enunciado   :
-- FIR 8 bit filter with four stages
--------------------------------------------------------------------------------
-- Revision History :
-- -----------------------------------------------------------------------------

--   Ver  :| Author            :| Mod. Date :|    Changes Made:

--   v1.0  | Ignacio Aznarez     :| 03/05/22  :| First version


-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fir_filter is
    port (
        clk     : in std_logic;
        rst     : in std_logic;
        -- Coeficientes
        beta1   : in std_logic_vector(7 downto 0);
        beta2   : in std_logic_vector(7 downto 0);
        beta3   : in std_logic_vector(7 downto 0);
        beta4   : in std_logic_vector(7 downto 0);
        -- Entrada de datos de 8 bits
        i_data  : in std_logic_vector(7 downto 0);
        -- Datos filtrados de salida de 10 bits
        o_data  : out std_logic_vector(9 downto 0)
    );
end fir_filter;

architecture rtl of fir_filter is

    -- Definición de tipos de señal para tubería de datos, coeficientes, productos y sumas parciales
    type t_data_pipe is array (0 to 3) of signed(7 downto 0);  -- Almacena los últimos 4 datos de entrada
    type t_coeff     is array (0 to 3) of signed(7 downto 0);  -- Almacena 4 coeficientes
    type t_mult      is array (0 to 3) of signed(15 downto 0); -- Almacena los productos de datos y coeficientes
    type t_add_st0   is array (0 to 1) of signed(16 downto 0); -- Almacena las sumas parciales

    -- Señales internas para coeficientes, datos, productos y sumas parciales
    signal r_coeff  : t_coeff;   -- Señal para los coeficientes
    signal p_data   : t_data_pipe;  -- Señal para la tubería de datos de entrada
    signal r_mult   : t_mult;    -- Señal para los productos
    signal r_add_st0: t_add_st0; -- Señal para las sumas parciales de la primera etapa
    signal r_add_st1: signed(17 downto 0); -- Señal para la suma final

begin

    -- Proceso de entrada: captura los datos de entrada y los desplaza en la tubería de datos
    p_input: process (rst, clk)
    begin
        if (rst = '0') then
            p_data  <= (others => (others => '0'));  -- Reinicia la tubería de datos
            r_coeff <= (others => (others => '0'));  -- Reinicia los coeficientes
        elsif rising_edge(clk) then
            -- Desplaza los datos y coloca el nuevo dato de entrada al inicio
            p_data  <= signed(i_data) & p_data(0 to p_data'length-2);
            -- Captura los coeficientes en cada ciclo de reloj
            r_coeff(0) <= signed(beta1);
            r_coeff(1) <= signed(beta2);
            r_coeff(2) <= signed(beta3);
            r_coeff(3) <= signed(beta4);
        end if;
    end process p_input;

    -- Proceso de multiplicación: multiplica los datos por los coeficientes
    p_mult: process (rst, clk)
    begin
        if (rst = '0') then
            r_mult <= (others => (others => '0'));  -- Reinicia los productos
        elsif rising_edge(clk) then
            for k in 0 to 3 loop  -- Recorre los 4 datos y coeficientes
                r_mult(k) <= p_data(k) * r_coeff(k);  -- Realiza la multiplicación
            end loop;
        end if;
    end process p_mult;

    -- Proceso de sumas parciales: suma los productos en pares
    p_add_st0: process (rst, clk)
    begin
        if (rst = '0') then
            r_add_st0 <= (others => (others => '0'));  -- Reinicia las sumas parciales
        elsif rising_edge(clk) then
            r_add_st0(0) <= resize(r_mult(0), 17) + resize(r_mult(1), 17);  -- Primera suma parcial
            r_add_st0(1) <= resize(r_mult(2), 17) + resize(r_mult(3), 17);  -- Segunda suma parcial
        end if;
    end process p_add_st0;

    -- Proceso de suma final: suma las sumas parciales
    p_add_st1: process (rst, clk)
    begin
        if (rst = '0') then
            r_add_st1 <= (others => '0');  -- Reinicia la suma final
        elsif rising_edge(clk) then
            r_add_st1 <= resize(r_add_st0(0), 18) + resize(r_add_st0(1), 18);  -- Suma final
        end if;
    end process p_add_st1;

    -- Proceso de salida: ajusta y asigna el resultado final a la salida
    p_output: process (rst, clk)
    begin
        if (rst = '0') then
            o_data <= (others => '0');  -- Reinicia la salida
        elsif rising_edge(clk) then
            o_data <= std_logic_vector(resize(r_add_st1, o_data'length)); 
        end if;
    end process p_output;

end rtl;