library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity InstrF is
    port ( clk : in STD_LOGIC;
           enable_MPG : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           Jump : in STD_LOGIC;
           next_instruction: out STD_LOGIC_VECTOR (15 downto 0);
           current_instruction: out STD_LOGIC_VECTOR (15 downto 0);
           jump_address : in STD_LOGIC_VECTOR (15 downto 0);
           branch_address : in STD_LOGIC_VECTOR (15 downto 0));              
end InstrF;

architecture Behavioral of InstrF is

type Mem_ROM is array (0 to 255) of std_logic_vector(15 downto 0);
signal instructions : Mem_ROM :=(
B"001_000_010_0000011",   --210C $2 = 12 = xC                   x1
B"000_001_000_010_0_001",   --208F $1 = 15 = xF                   x0
--B"001_000_010_0001100",   --210C $2 = 12 = xC                   x1
--B"110_0000000001101",     --C00D sare la xD                     x2
--B"000_001_010_011_0_000", --0000 0011  x0003                    x3  
--B"000_001_010_011_0_001", --0001 1011  x001B                    x4
--B"000_001_010_011_0_100", --0000 1100  x000C                    x5
--B"000_001_010_011_0_101", --0000 1111  x000F                    x6
--B"000_001_010_011_0_110", --1111 0000  xFFF0                    x7
--B"000_001_010_011_0_111", --0000 0011  x0003                    x8
--B"000_000_010_011_0_010", --0000 1100  x000C                    x9
--B"000_000_010_011_0_011", --0000 1100  x000C                    xA
--B"000_000_010_011_1_010", --0001 1000  x0018                    xB
--B"000_000_010_011_1_011", --0000 0110  x0006                    xC
--B"000_001_010_011_0_001", --0531 $3 = $1 + $2 = 27 = x1B        xD 
--B"001_000_100_0010100",   --2214 $4 = 20 = x14                  xE
--B"100_100_011_1111101",   --91FD if($4 == $3) sare la 2         xF
--B"001_000_101_0000111",   --2287 $5 = 7                         x10
--B"000_011_101_011_0_000", --0EB0 $3 = $3 - $5 = 20 = x14        x11
--B"100_011_100_0000011",   --8E03 if($3 == $4) sare la 11        x12
--B"001_000_111_0010100",   --2394 $7 = 20 = x14                  x13
--B"100_111_100_1111000",   --9E78 if($7 == $4) sare la 2         x14
--B"001_000_100_0101000",   --2228 $4 = 40 = x28                  x15
--B"001_000_111_0101010",   --23AA $7 = 42 = x2A                  x16
--B"001_000_111_0101011",   --23AB $7 = 43 = x2B                  x17
--B"011_000_111_0001000",   --6388 store 8($0) = $7 = 43 = x2B    x18
--B"011_000_100_0001001",   --6209 store 9($0) = $4 = 20 = x14    x19
--B"010_000_100_0000111",   --4207 load $4 = 7($0) xCCCC          x1A
--B"010_000_100_0001000",   --4208 load $4 = 8($0) x2B            x1B
--B"010_000_100_0001001",   --4209 load $4 = 9($0) x14            x1C
B"110_000_000_0000000",   --C000 jump                           x1D
others => x"FFFF");

signal PC_out, PC_in, PC_next, aux : STD_LOGIC_VECTOR (15 downto 0);

begin
    process(clk, enable_MPG)
    begin
        if(clk = '1' and clk'event) then
            if(enable_MPG = '1') then
                PC_out <= PC_in;
            end if;
        end if;
    end process;
    
    process(PCSrc)
        begin
            if (PCSrc = '1') then
                aux <= branch_address;
                else
                aux <= PC_next;
            end if;
    end process;
        
    process(Jump)
        begin
            if (Jump = '1') then
                PC_in <= jump_address;
            else
                PC_in <= aux;
            end if;
    end process;
            
    PC_next <= PC_out + 1; -- ALU +1
    -- next_instruction <= PC_out + 1;
    next_instruction <= PC_next;
	current_instruction <= instructions (conv_integer(PC_out));
            
end Behavioral;

