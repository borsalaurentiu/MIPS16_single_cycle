library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity InstrD is
    port ( clk : in STD_LOGIC;
           current_instruction: in STD_LOGIC_VECTOR (12 downto 0);
           RegEnable : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1: out STD_LOGIC_VECTOR (15 downto 0);
           RD2: out STD_LOGIC_VECTOR (15 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (15 downto 0);
           Func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);              
end InstrD;

architecture Behavioral of InstrD is

signal WAdd : STD_LOGIC_VECTOR(2 downto 0);

component RF
 port ( clk : in STD_LOGIC;
        Add1 : in STD_LOGIC_VECTOR(2 downto 0);
        Add2 : in STD_LOGIC_VECTOR(2 downto 0);
        WAdd : in STD_LOGIC_VECTOR(2 downto 0);
        WD : in STD_LOGIC_VECTOR(15 downto 0);
        RegEnable: in STD_LOGIC;
        RD1 : out STD_LOGIC_VECTOR(15 downto 0);
        RD2 : out STD_LOGIC_VECTOR(15 downto 0));
end component;

begin

    label_RF: RF port map (clk, current_instruction(12 downto 10), current_instruction(9 downto 7), WAdd, WD, RegEnable, RD1, RD2);
    
	process (RegDst)
        begin
        if (RegDst = '1') then
            WAdd <= current_instruction (6 downto 4);
            else
            WAdd <= current_instruction (9 downto 7);
        end if;
    end process;
    
    process (ExtOp)
        begin
        if (ExtOp = '1') then
            if (current_instruction(6) = '1') then
                Ext_Imm <= x"FF"&"1" & current_instruction(6 downto 0);
                else
                Ext_Imm <= x"00"&"0" & current_instruction(6 downto 0);
            end if;
            else
            Ext_Imm <= x"00"&"0" & current_instruction(6 downto 0);         
        end if;
    end process;
    Func <= current_instruction(2 downto 0);
    sa <= current_instruction(3);
    
end Behavioral;