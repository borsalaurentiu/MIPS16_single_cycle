library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
    port ( sa : in STD_LOGIC;
           ALUCtrl : in STD_LOGIC_VECTOR (2 downto 0);
           ZF : out STD_LOGIC;
           RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           ALURes : out STD_LOGIC_VECTOR (15 downto 0));         
end ALU;

architecture Behavioral of ALU is

signal shiftll, shiftrl, ALU_out : std_logic_vector (15 downto 0); 

begin
    
    ALURes <= ALU_out;
    ZF <= '1' when ALU_out = x"0000" else '0';
    
    process(ALUCtrl, RD1, RD2, shiftll, shiftrl)
    begin
        case (ALUCtrl) is
            when "000" => ALU_out <= RD1 - RD2; -- sub
            when "001" => ALU_out <= RD1 + RD2; -- add
            when "010" => ALU_out <= shiftll; -- shift left
            when "011" => ALU_out <= shiftrl; -- shift right
            when "100" => ALU_out <= RD1 and RD2; -- and
            when "101" => ALU_out <= RD1 or RD2; -- or
            when "110" => ALU_out <= RD1 nor RD2; -- nor
            when others => ALU_out <= RD1 xor RD2; -- xor
        end case;
    end process;
    
    process (sa, RD2)
    begin
        if (sa = '1') then
            shiftll <= RD2(14 downto 0) & "0";
            shiftrl <= "0" & RD2(15 downto 1);
        else
            shiftll <= RD2;
            shiftrl <= RD2;
        end if;
    end process;
    
end Behavioral;
