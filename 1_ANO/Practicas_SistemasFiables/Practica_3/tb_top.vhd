library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity tb_top is 
end tb_top;

architecture testBench of tb_top is
    component top_practica1 is
    generic (
        g_sys_clock_freq_KHZ: integer := 100e3; -- Value of the clock frequencies in KHz
        g_debounce_time     : integer := 20;  -- Time for the debouncer in ms
        g_reset_value 		: std_logic := '0'; -- Value for the synchronizer 
        g_number_flip_flps  : natural := 2 	-- Number of ffs used to synchronize	
    );
    port (
        rst_n       : in std_logic;
        clk100Mhz   : in std_logic;
        BTNC        : in std_logic;
        LED         : out std_logic
    );
    end component;

    -- Frecuencia reducida y timeout al minimo para una visualización más sencilla.
    constant timer_debounce : integer := 1; --ms
    constant freq : integer := 30; --KHZ
    constant clk_period : time := (1 ms/ freq);

    -- Inputs 
    signal  rst_n       :   std_logic := '0';
    signal  clk         :   std_logic := '0';
    signal  BTN     :   std_logic := '0';
    -- Output
    signal  LED   :   std_logic;
  
    -- archivos .txt
    file file_INPUT : text;
    file file_OUTPUT : text;
  
    begin
        UUT: top_practica1
        generic map ( 
            g_sys_clock_freq_KHZ  => freq, 
            g_debounce_time       => timer_debounce,
            g_reset_value         => '0',
            g_number_flip_flps 	=> 2
        )
        port map (
            rst_n     => rst_n,
            clk100Mhz => clk,
            BTNC      => BTN,
            LED       => LED
        );
        clk <= not clk after clk_period/2;
        process is 
            variable v_ILINE   : line;
            variable v_OLINE   : line;
            variable estado    : file_open_status;
            variable v_RST     : integer;
            variable V_TIME    : time;
            variable V_BTNC    : integer;
            variable V_LED     : integer;
            variable E_LED     : std_logic;
            variable T_TIME    : integer:=0;
        begin
            file_open(estado, file_INPUT, "C:\Users\jorge\P3\input.txt", read_mode);
            assert estado=open_ok 
                report "no se pudo abrir el archivo de entrada"
                severity warning;   
            file_open(estado, file_OUTPUT, "C:\Users\jorge\P3\output.txt", write_mode);
            assert estado=open_ok
                report "no se pudo abrir el archivo de salida"
                severity warning;
            write(v_oline,string'("Simulation of tb_top.vhd"));
            writeline(file_OUTPUT,v_oline);
            while ( not endFile(file_INPUT)) loop
                readline(file_INPUT, v_ILINE);
                read(v_ILINE, v_TIME); 
                read(v_ILINE, v_RST);
                read(v_ILINE, V_BTNC);
                read(v_ILINE, v_LED);
                T_TIME := t_time+(v_time/1us);
                wait for v_TIME;
                if(v_rst=0)then
                    rst_n<='0';
                elsif(v_rst=1)then
                    rst_n<='1';
                end if;
                if(v_btnc=0)then
                    btn<='0';
                elsif(v_btnc=1)then
                    btn<='1';
                end if;
                if(v_led=0)then
                    e_led:='0';
                elsif(v_led=1)then
                    e_led:='1';
                end if;               
                if(not e_led=led)then
                    
                    write(v_oline,string'("time: "));
                    write(v_oline,integer'image(t_time));
                    write(v_oline,string'(" us; rst_n: "));
                    write(v_oline,integer'image(v_rst));
                    write(v_oline,string'("; BTNC: "));
                    write(v_oline,integer'image(v_btnc));
                    write(v_oline,string'(";"));
                    writeline(file_OUTPUT,v_oline);
                case(led) is
                    when '1'=>write(v_oline,string'("Error: led is 1, expected 0"));
                    when '0'=>write(v_oline,string'("Error: led is 0, expected 1"));
                    when others =>null;
                end case;
                writeline(file_OUTPUT,v_oline);
                report "error" severity warning;
            end if;
        end loop;
        write(v_oline,string'("time: "));
        write(v_oline,integer'image(t_time));
        write(v_oline,string'(" us; rst_n: "));
        write(v_oline,integer'image(v_rst));
        write(v_oline,string'("; BTNC: "));
        write(v_oline,integer'image(v_btnc));
        write(v_oline,string'(";"));
        writeline(file_OUTPUT,v_oline);
        write(v_oline,string'("Finished simulation"));
        writeline(file_OUTPUT,v_oline);
        wait;
    end process;
end testBench;