library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RF is
    port ( clk : in STD_LOGIC;
           Add1 : in STD_LOGIC_VECTOR(2 downto 0);
           Add2 : in STD_LOGIC_VECTOR(2 downto 0);
           WAdd : in STD_LOGIC_VECTOR(2 downto 0);
           WD : in STD_LOGIC_VECTOR(15 downto 0);
                   RegEnable: in STD_LOGIC;
                   RD1 : out STD_LOGIC_VECTOR(15 downto 0);
                   RD2 : out STD_LOGIC_VECTOR(15 downto 0));
end RF;

architecture Behavioral of RF is

type reg_array is array (0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
signal reg_file: reg_array := (others => x"0000");
begin
    process(clk)
    begin
    if (clk = '1' and clk'event) then
        if (RegEnable = '1') then
            reg_file(conv_integer(WAdd)) <= WD;
        end if;
    end if;
    end process;
    
    RD1 <= reg_file(conv_integer(Add1));
    RD2 <= reg_file(conv_integer(Add2));

end Behavioral;
