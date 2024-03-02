library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm_tb is
end fsm_tb;

architecture Structural of fsm_tb is

    component fsm_sclk is
        generic(
            g_freq_SCLK_KHZ	: integer := 1500000; 
            g_system_clock 	: integer := 100000000 
        );
        port (
            rst_n		: in std_logic;
            clk 		: in std_logic;
            start		: in std_logic;
            SCLK 		: out std_logic;
            SCLK_rise	: out std_logic;
            SCLK_fall	: out std_logic
        );
    end component;

    signal rst_n_tb ,clk_tb, start_tb,SCLK_tb,SCLK_rise_tb,SCLK_fall_tb : std_logic;

begin

    DUT:fsm_sclk generic map (g_freq_SCLK_KHZ => 1500000,
                              g_system_clock => 100000000)
                 port map (rst_n_tb ,clk_tb, start_tb,SCLK_tb,SCLK_rise_tb,SCLK_fall_tb);

    process begin
        rst_n_tb <= '0'; wait for 50ns;
        rst_n_tb <= '1'; wait;
    end process;
     process begin
            start_tb <= '0'; wait for 60ns;
            start_tb <= '1'; wait;
    end process;
    process begin
        clk_tb <= '0'; wait for 50ns;
        clk_tb <= '1'; wait for 50ns;
    end process;
    
   

end Structural;