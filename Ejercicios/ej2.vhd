
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY FSM IS

    PORT (

        IN : IN STD_LOGIC;

        Reset : IN STD_LOGIC;

        OUT : OUT STD_LOGIC);

END FSM;

ARCHITECTURE behavioral OF FSM IS TYPE estado_t IS (S0, S1, S2, S3);

    SIGNAL estado_actual : estado_t := S0;
    SIGNAL next_estado : estado_t;

BEGIN proceso_secuencial : PROCESS (Reset, clk)

    BEGIN

        IF Reset = '1'

            THEN
            estado_actual <= S0;

        ELSIF clk'event AND clk = '1'

            THEN
            estado_actual <= next_estado;

        END IF;

    END PROCESS;

    proceso_combinacional : PROCESS (estado_actual, X)

    BEGIN

        CASE estado_actual IS WHEN S0 => IF X = '1'

                THEN
                next_estado <= S1;

            ELSE
                next_estado <= S0;

        END IF;

        WHEN S1 => IF X = '1' THEN
        next_estado <= S2;
    ELSE
        next_estado <= S0;

    END IF;

    WHEN S2 => IF X = '1' THEN
    next_estado <= S3;
ELSE
    next_estado <= S0;

END IF;

WHEN S3 => IF X = '0' THEN
next_estado <= S0;

ELSE
next_estado <= S3;
END IF;

END CASE;

Z <= '1' WHEN estado_actual = S3 ELSE
    '0';

END PROCESS;

END behavioral;