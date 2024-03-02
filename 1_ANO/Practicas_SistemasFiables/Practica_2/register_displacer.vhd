library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
entity register_displacer is
    generic(
        N:integer := 4
    );
    port ( clk  : in std_logic;
         rst_n  : in std_logic;
         din    : in std_logic;
         s      : in std_logic_vector (1 downto 0);
         D      : in unsigned(N-1 downto 0);
         dout   : out std_logic;
         Q      : out unsigned(N-1 downto 0)
        );
end register_displacer;

architecture Behavioral of register_displacer is
    signal registro: unsigned(N-1 downto 0);
   
begin
    
    process (clk,rst_n,S) begin
    if (rst_n ='0')then
        registro <= (others => '0');
    else
        if(rising_edge (clk) )then
            case S is
            when "10"   =>
                registro<= din &registro(N-1 downto 1);
            when "11"   =>
                registro <= D;
            when others =>
                registro <= registro;
            end case;
        end if;
    end if;
    end process;
    process(clk) begin
        if (rising_edge (clk))then 
            dout <=registro(0);
            Q<=registro;
        end if;
    end process;
end Behavioral;