library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity ALU is
  Port ( MX : in STD_LOGIC_VECTOR(23 downto 0);
         MY : in STD_LOGIC_VECTOR(23 downto 0);
         AluCTRL : in STD_LOGIC;
         Carry : out STD_LOGIC;
         MS : out STD_LOGIC_VECTOR(24 downto 0)
  );
end ALU;


architecture Behavioral of ALU is

signal aux : STD_LOGIC_VECTOR(24 downto 0) := B"00000_0000_0000_0000_0000_0000";

begin
    
    process(AluCTRL, MX, MY)
    begin
            case AluCTRL is
                when '0' => aux <= ('0' & MX) + ('0' & MY);                      -- add mantissas
                when '1' => aux <= ('0' & MX) - ('0' & MY);                   -- sub mantissas
                when others =>  aux <= B"0000_0000_0000_0000_0000_00000";
            end case;
    end process;
-- nu se poate sa avem borrow
    carry <= aux(24);
    MS <= aux;

end Behavioral;
