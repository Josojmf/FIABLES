--------------------------------------------------------------------------------
--
-- Title       : 	Registro de desplazamiento
-- Author      :	Ignacio Aznarez Ramos
-- Company     :	Universidad de Nebrija
--------------------------------------------------------------------------------
-- File        : shift_register.vhd
-- Generated   : February 2024
--------------------------------------------------------------------------------
-- Description : 
	
--------------------------------------------------------------------------------
-- Revision History :
-- -----------------------------------------------------------------------------

--   Ver  :| Author            :| Mod. Date :|    Changes Made:

--   v1.0  | Ignacio Aznarez   :| Feb/24    :| First version

-- -----------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY shift_register IS
    GENERIC (
        g_N : INTEGER := 16 -- Size of the register
    );
    PORT (
        rst_n : IN std_logic; -- asynchronous reset, low active
        clk : IN std_logic; -- system clk
        s0 : IN std_logic;
        s1 : IN std_logic;
        din : IN std_logic; -- Serial IN. One bit serial input
        D : IN std_logic_vector(g_N - 1 DOWNTO 0);-- Paralel IN. Vector of generic g_n bits.
        Q : OUT std_logic_vector(g_N - 1 DOWNTO 0);-- Paralel OUT.
        dout : OUT std_logic -- Serial OUT.
    );
END shift_register;

ARCHITECTURE behavioural OF shift_register IS

    SIGNAL registro : std_logic_vector(g_N - 1 DOWNTO 0);
 
BEGIN
    PROCESS (rst_n, clk)
    BEGIN
        IF rst_n = '0' THEN
            --- Reset asincrono del registro
            registro <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            ------------------------
            -- Completar la lógica combinacional de acuerdo a los valores de entrada s0 y s1
            -----------------------
            IF (s0 = '0') AND (s1 = '1') THEN
                registro <= din & registro(g_N - 2 DOWNTO 0);
            ELSIF (s0 = '1') AND (s1 = '1') THEN
                registro <= D;
            ELSIF (s0 = '1') AND (s1 = '1') THEN 
                registro <= din & registro(g_N - 2 DOWNTO 0);
            ELSE 
                registro <= registro;
            END IF;
        END IF;
    END PROCESS;
    ------------------------
    -- Completar con la asignación final a Q y dout con los valores correspondientes del registro
    ------------------------
     process(clk) begin
        if (rising_edge (clk))then 
            dout <=registro(g_N -1);
            Q<=registro;
        end if;
    end process;
END behavioural;





