library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Rounding is
  Port ( Mant : in STD_LOGIC_VECTOR(24 downto 0);
         Exp : in STD_LOGIC_VECTOR(7 downto 0);
         Clk : in STD_LOGIC; 
         OutMant : out STD_LOGIC_VECTOR(22 downto 0);
         OutExp : out STD_LOGIC_VECTOR( 7 downto 0)      
  );
end Rounding;

architecture Behavioral of Rounding is

begin
    process(Clk)
    begin
        if RISING_EDGE(Clk) then
            OutMant <= Mant(22 downto 0);
            OutExp <= Exp;
        end if;
    end process;

end Behavioral;
