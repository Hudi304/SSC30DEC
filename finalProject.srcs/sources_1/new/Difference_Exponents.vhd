library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Difference_Exponents is
  Port ( X : in STD_LOGIC_VECTOR(31 downto 0);
         Y : in STD_LOGIC_VECTOR(31 downto 0);
         DifExp : out STD_LOGIC_VECTOR(7 downto 0);
         Swap_enable : out STD_LOGIC      -- determine the largest number
  );
end Difference_Exponents;


architecture Behavioral of Difference_Exponents is

signal EX, EY : STD_LOGIC_VECTOR(7 downto 0);
signal MX, MY : STD_LOGIC_VECTOR(22 downto 0);

signal dif : STD_LOGIC_VECTOR(7 downto 0);
signal C : STD_LOGIC;

begin
    
    EX <= X(30 downto 23);         -- exponent X and Y 
    EY <= Y(30 downto 23);
    
    MX <= X(22 downto 0);          -- mantisa X and Y
    MY <= Y(22 downto 0);
    
    ----------------------------------- Exponent Swap_enablearison --------------------------
    
    C <= '0' when EX > EY else                        -- exponent X > exponent Y
         '1' when EX < EY  else                       -- exponent X < exponent Y
         '0' when MX >= MY else                       -- exponent X = exponent Y -> X > Y
         '1' when MX < MY else                        -- exponent X = exponent Y -> X < Y
         '-';
    Swap_enable <= C;
            
    ---------------------------------- Difference between exponents ------------------
    
    dif <= EX - EY when C = '0' else
           EY - EX when C = '1' else
           "--------";
           
    process(dif)
    begin
        if dif <= x"18" then              -- if the difference is less than or equal to 24
            DifExp <= dif;                -- take subtraction
        elsif dif > x"18" then            -- if the difference is greater than 24
            DifExp <= "00011001";         -- the difference is 25
        else
            DifExp <= "--------";
        end if;
    end process;
     
end Behavioral;
