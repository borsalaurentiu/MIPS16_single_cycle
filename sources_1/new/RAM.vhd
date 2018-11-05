library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAM is
    port ( clk : in std_logic;
           we : in std_logic;
           en : in std_logic;
           addr : in std_logic_vector(15 downto 0);
           din : in std_logic_vector(15 downto 0);
           dout : out std_logic_vector(15 downto 0));
end RAM;

architecture Behavioral of RAM is
type ram_array is array (0 to 2**16-1) of STD_LOGIC_VECTOR(15 downto 0);
signal ram_file: ram_array := (others => x"F0F0");


begin
process(clk, en, din, addr)
begin
    if(clk'event and clk = '1') then
        if(en = '1') then
            if(we = '1') then
                ram_file(conv_integer(addr)) <= din;
                dout <= ram_file(conv_integer(addr));
            else
                dout <= ram_file(conv_integer(addr));
            end if;
        end if;
    end if;
end process;


end Behavioral;