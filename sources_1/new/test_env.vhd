library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
    port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
signal digits, RD1, RD2, WD, Ext_Imm, next_instruction, current_instruction, switch, DMAdd, DMout, ALURes, branch_address, jump_address : std_logic_vector(15 downto 0) := x"0000";
signal sa, RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegWrite, ZF, PCSrc, RegEnable, enable_MPG : STD_LOGIC := '0';
signal ALUOp, Func : STD_LOGIC_VECTOR (2 downto 0) :="000";

component MPG is
    port(
	    btn: in STD_LOGIC;
	    clk: in STD_LOGIC;
	    enable: out STD_LOGIC
	    );
end component;

component SSD
    port ( clk : in STD_LOGIC;
           digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component InstrF
    port ( clk : in STD_LOGIC;
           enable_MPG : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           Jump : in STD_LOGIC;
           next_instruction: out STD_LOGIC_VECTOR (15 downto 0);
           current_instruction: out STD_LOGIC_VECTOR (15 downto 0);
           jump_address : in STD_LOGIC_VECTOR (15 downto 0);
           branch_address : in STD_LOGIC_VECTOR (15 downto 0));              
end component;

component InstrD
    port ( clk : in STD_LOGIC;
           current_instruction: in STD_LOGIC_VECTOR (12 downto 0);
           RegEnable : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           RD1: out STD_LOGIC_VECTOR (15 downto 0);
           RD2: out STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (15 downto 0);
           Func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);              
end component;

component UC
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
end component;

component MEM
    port ( clk : in std_logic;
          MemWrite : in std_logic;
          inALURes : in std_logic_vector(15 downto 0);
          RD2 : in std_logic_vector(15 downto 0);
          MemData : out std_logic_vector(15 downto 0);
          outALURes : out std_logic_vector(15 downto 0));      
end component;

component EX
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
end component;

signal mul2: std_logic;
signal RD22: std_logic_vector(15 downto 0);
begin
    label_MPG: MPG port map (btn(0), clk, enable_MPG);
    label_SSD: SSD port map (clk, digits(15 downto 12), digits(11 downto 8), digits(7 downto 4), digits(3 downto 0), an, cat);   
    label_EX: EX port map (next_instruction, RD22, ALUSrc, RD2, Ext_Imm, sa, func, ALUOp, branch_address, ZF, DMAdd);
    label_IF: InstrF port map (clk, enable_MPG, PCSrc, Jump, next_instruction, current_instruction, jump_address, branch_address);
    label_ID: InstrD port map (clk, current_instruction(12 downto 0), RegEnable, RegDst, ExtOp, WD, RD1, RD2, Ext_Imm, Func, sa);
    label_UC: UC port map (current_instruction(15 downto 13), RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegWrite, ALUOp);
    label_MEM: MEM port map (clk, MemWrite, DMAdd, RD2, DMout, ALURes);



    RD22 <= RD2 when mul2 = '1' else RD1;
    process(clk, next_instruction)
    begin   
        if(clk = '1' and clk'event) then
            if(next_instruction = x"0002") then
                mul2 <= '1';
                else
                mul2 <= '0';
            end if;
        end if;
    end process;
    
    
    
    RegEnable <= enable_MPG and RegWrite; 
    jump_address <= "000" & current_instruction(12 downto 0);
    
        process (MemtoReg)
            begin
                if MemtoReg = '1' then
                    WD <= DMout;
                    else
                    WD <= ALURes;
                end if;
            end process;
        PCSrc <=  Branch and ZF;






    led(15) <= ZF;   
    switch <= sw;
   
    process(switch(0), clk)
    begin
        if(clk = '1' and clk'event) then
            if (switch(0) = '0' )then
                led(7) <= RegDst;
                led(6) <= ExtOp;
                led(5) <= ALUSrc;
                led(4) <= Branch;
                led(3) <= Jump;
                led(2) <= MemWrite;
                led(1) <= MemtoReg;
                led(0) <= RegWrite;
            else
                led(7 downto 0) <= "00000" & ALUOp;
            end if;  
        end if;
    end process;

    process( switch(7 downto 5) )
    begin
        case (switch(7 downto 5)) is
            when "000" => digits <= current_instruction; 
            when "001" => digits <= next_instruction;
            when "010" => digits <= RD1; 
            when "011" => digits <= RD2;
            when "100" => digits <= Ext_Imm;
            when "101" => digits <= DMAdd;
            when "110" => digits <= DMout;            
            when others => digits <= WD;
        end case;
    end process;

end Behavioral;
