library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity fir_filter_tb is
end fir_filter_tb;

architecture rtl of fir_filter_tb is

    constant beta1 : std_logic_vector(7 downto 0) := std_logic_vector(to_signed(-10, 8));
    constant beta2 : std_logic_vector(7 downto 0) := std_logic_vector(to_signed(110, 8));
    constant beta3 : std_logic_vector(7 downto 0) := std_logic_vector(to_signed(127, 8));
    constant beta4 : std_logic_vector(7 downto 0) := std_logic_vector(to_signed(-20, 8));

    component fir_test_data_generator
        port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            pattern_sel : in  integer;  -- 0 => delta; 1 => step; 2 => sine
            enable      : in  std_logic;
            o_data      : out std_logic_vector(7 downto 0)  -- to FIR
        );
    end component;

    component fir_filter
        port (
            clk     : in std_logic;
            rst     : in std_logic;
            beta1   : in std_logic_vector(7 downto 0);
            beta2   : in std_logic_vector(7 downto 0);
            beta3   : in std_logic_vector(7 downto 0);
            beta4   : in std_logic_vector(7 downto 0);
            i_data  : in std_logic_vector(7 downto 0);
            o_data  : out std_logic_vector(9 downto 0)
        );
    end component;

    file file_input : text;
    constant freq : integer := 100_000;  -- KHZ
    constant clk_period : time := (1 ms / freq);

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal pattern_sel : integer := 0;
    signal enable : std_logic := '0';
    signal w_data_test : std_logic_vector(7 downto 0) := (others => '0');
    signal o_data : std_logic_vector(9 downto 0) := (others => '0');

begin

    U_fir_test_data_generator : fir_test_data_generator
        port map (
            clk => clk,
            rst => rst,
            pattern_sel => pattern_sel,
            enable => enable,
            o_data => w_data_test
        );

    UUT : fir_filter
        port map (
            clk => clk,
            rst => rst,
            beta1 => beta1,
            beta2 => beta2,
            beta3 => beta3,
            beta4 => beta4,
            i_data => w_data_test,
            o_data => o_data
        );
  
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process clk_process;
    

    --=============================================
	--Proceso de generacion de estimulos
	--=============================================	
	process is
	
	    variable v_input_line : line;
        variable v_pattern_sel : integer;
        variable v_file_status : file_open_status;
        
	begin
	
	   -- Abrir el archivo de entrada
        file_open(v_file_status, file_input, "../../../../input.txt", read_mode);
        
        -- Verificar si el archivo se abrió correctamente
        if v_file_status /= open_ok then
            report "Error"
                severity error;
            wait;
        end if;

        -- Leer el contenido del archivo línea por línea
        while not endfile(file_input) loop
            readline(file_input, v_input_line);
            read(v_input_line, v_pattern_sel);
            pattern_sel <= v_pattern_sel;
            enable <= '1';  -- Habilitar el generador de datos
            wait for 1 ms;  -- Esperar tiempo suficiente para observar la salida
            enable <= '0';  -- Deshabilitar el generador de datos
        end loop;
        
        -- Cerrar el archivo de entrada
        file_close(file_input);

		-- Secuencia de reset
		wait until clk'event and clk = '1';
		wait until clk'event and clk = '1';
		rst <= '1';                         -- Reset inactivo
		wait until clk'event and clk = '1';
		rst <= '0';                         -- Reset activo
		wait until clk'event and clk = '1';
		rst <= '1';                         -- Reset inactivo
		--Fin de secuencia de reset
		wait for 100 us;

	end process;
    
end rtl;
