library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MPG is
    port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
end MPG;

architecture Behavioral of MPG is
signal count_int : std_logic_vector(15 downto 0) :=x"0000";
signal Q1 : std_logic;
signal Q2 : std_logic;
signal Q3 : std_logic;

begin
    enable <= Q2 AND (not Q3);
    process (clk)
        begin
            if (clk='1' and clk'event) then
                count_int <= count_int + 1;
            end if;
    end process;

    process (clk, count_int, btn)
        begin
            if (clk='1' and clk'event) then
                if count_int(15 downto 0) = x"FFFF" then
                    Q1 <= btn;
                end if;
            end if;
    end process;
    process (clk, Q1, Q2)
        begin
            if (clk='1' and clk'event) then
                Q2 <= Q1;
                Q3 <= Q2;
            end if;
    end process;
end Behavioral;