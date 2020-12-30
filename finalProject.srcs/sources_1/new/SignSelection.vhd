library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SignSelection is
  Port ( SX : in STD_LOGIC;
         SY : in STD_LOGIC;
         op : in STD_LOGIC;
         Swap_enable : in STD_LOGIC;
         SwitchNr : out STD_LOGIC;
         SZ : out STD_LOGIC
  );
end SignSelection;

architecture Behavioral of SignSelection is

begin
    
     
       
        SZ <= '0' when (SX = '0' and SY = '0') or
                       (SX = '0' and SY = '1' and Swap_enable = '0') or
                       (SX = '0' and SY = '1' and Swap_enable = '0') or
                       (SX = '0' and SY = '0') or
                       (SX = '1' and SY = '0' and Swap_enable = '1') or
                       (SX = '1' and SY = '0' and Swap_enable = '1') else
              '1';           
                    

end Behavioral;
