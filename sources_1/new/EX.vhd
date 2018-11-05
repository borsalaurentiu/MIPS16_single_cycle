library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity EX is
    Port ( 
    next_instruction : in std_logic_vector (15 downto 0);
    RD1 : in std_logic_vector (15 downto 0);
    ALUSrc : in std_logic;
    RD2 : in std_logic_vector (15 downto 0);
    Ext_Imm : in std_logic_vector (15 downto 0);
    sa : in std_logic;
    Func : in std_logic_vector (2 downto 0);
    ALUOp : in std_logic_vector (2 downto 0);
    branch_address : out std_logic_vector (15 downto 0);
    ZF : out std_logic;
    ALURes : out std_logic_vector (15 downto 0));
end EX;

architecture Behavioral of EX is

component ALU
    port ( sa : in STD_LOGIC;
           ALUCtrl : in STD_LOGIC_VECTOR (2 downto 0);
           ZF : out STD_LOGIC;
           RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           ALURes : out STD_LOGIC_VECTOR (15 downto 0));         
end component;

signal ALUCtrl : STD_LOGIC_VECTOR (2 downto 0);
signal ALU_in2 : STD_LOGIC_VECTOR (15 downto 0);
begin

    label_ALU: ALU port map (sa, ALUCtrl, ZF, RD1, ALU_in2, ALURes); 
    branch_address <= next_instruction + Ext_Imm;

    process (ALUSrc)
    begin
        if ALUSrc = '1' then
            ALU_in2 <= Ext_Imm;
            else
            ALU_in2 <= RD2;
        end if;
    end process;
    
    process (ALUOp)
    begin
        case ALUOp is
            when "000" => ALUCtrl <= "000";  --ALUOp: beq            ALUCtrl: scadere
            when "001" => ALUCtrl <= "001";  --ALUOp: addi, lw, sw   ALUCtrl: adunare 
            when "010" => ALUCtrl <= Func;   --ALUOp: Functii        ALUCtrl: Functii
            when "101" => ALUCtrl <= "101";  --ALUOp: ori            ALUCtrl: sau
            when "111" => ALUCtrl <= "111";  --ALUOp: xori           ALUCtrl: sau-exclusiv  
            when others => ALUCtrl <= "000";
        end case;
    end process;
    
end Behavioral;
