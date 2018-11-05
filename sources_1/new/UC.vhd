library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity UC is
    port ( 
           Operatie: in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite: out STD_LOGIC;
           ALUOp: out STD_LOGIC_VECTOR (2 downto 0)); 
end UC;

architecture Behavioral of UC is

begin
    process (Operatie)
        begin 
        RegDst <= '0';
        ExtOp <= '0';
        ALUSrc <= '0';
        Branch <= '0';
        Jump <= '0';
        MemWrite <= '0';
        MemtoReg <= '0';
        RegWrite <= '0';
        ALUOp <= "000";
            case Operatie is
                when "000" => ALUOp <= "010"; RegWrite <= '1'; RegDst <= '1';   -- tip R
                when "001" => ALUOp <= "001"; RegWrite <= '1'; ALUSrc <= '1'; ExtOp <= '1'; -- addi
                when "010" => ALUOp <= "001"; RegWrite <= '1'; ALUSrc <= '1'; ExtOp <= '1'; MemtoReg <= '1'; -- lw 
                when "011" => ALUOp <= "001"; RegWrite <= '0'; ALUSrc <= '1'; ExtOp <= '1'; MemWrite <= '1'; -- sw
                when "100" => ALUOp <= "000"; RegWrite <= '0';                ExtOp <= '1'; Branch <= '1'; -- beq
                when "101" => ALUOp <= "101"; RegWrite <= '1'; ALUSrc <='1'; -- ori
                when "111" => ALUOp <= "111"; RegWrite <= '1'; ALUSrc <='1'; -- xori
				when others => Jump <= '1'; -- jump            
			end case;
        end process;

end Behavioral;