library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MainTB is
--  Port ( );
end MainTB;

architecture Behavioral of MainTB is

component Main is
  Port ( X : in STD_LOGIC_VECTOR(31 downto 0);
         Y : in STD_LOGIC_VECTOR(31 downto 0);
         Clk : in STD_LOGIC;
         StartOp : in STD_LOGIC;
         op : in STD_LOGIC;
         StopSignal : out STD_LOGIC;
         OverflowSignal : out STD_LOGIC;
         UnderflowSignal : out STD_LOGIC;
         Z : out STD_LOGIC_VECTOR(31 downto 0)  
  );
end component;

signal X :  STD_LOGIC_VECTOR(31 downto 0);
signal Y  : STD_LOGIC_VECTOR(31 downto 0);
signal Clk :  STD_LOGIC;
signal StartOp :  STD_LOGIC;
signal op :  STD_LOGIC;
signal StopSignal : STD_LOGIC;
signal OverflowSignal : STD_LOGIC;
signal UnderflowSignal : STD_LOGIC;
signal Z :   STD_LOGIC_VECTOR(31 downto 0);

   constant CLK_PERIOD : TIME := 10 ns;

constant NaN : std_logic_vector(31 downto 0) := '0' &  x"FF" & b"000_0000_0000_0000_0000_1111";


begin

       gen_clk: process
                  begin
                     Clk <= '0';
                     wait for (CLK_PERIOD/2);
                     Clk <= '1';
                     wait for (CLK_PERIOD/2);
                end process gen_clk;

DUT : Main port map (
         X => X,
         Y => Y,
         Clk => Clk,
         StartOp => StartOp,
         op => op,
         StopSignal => StopSignal,
         OverflowSignal => OverflowSignal,
         UnderflowSignal => UnderflowSignal,
         Z => Z
);


process

variable expected_result : STD_LOGIC_VECTOR (31 downto 0);
variable counter_errors : INTEGER := 0; 

begin 
     StartOp <= '1';
     op <= '0';
     X <= X"00000001";   -- x0.000002 * 2^-126
     Y <= X"00000001";   -- x0.000002 * 2^-126
     wait for 10ns;
     StartOp <= '0';
     wait for 300ns;
     StartOp <= '1';
     wait for 10ns;


     StartOp <= '1';
     op <= '0';
     X <= "11000010111100000000000000000000";   -- -120
     Y <= "11000001101101001100110011001101";   -- -22.6
     wait for 10ns;
     StartOp <= '0';
     wait for 300ns;
     expected_result := "11000011000011101001100110011001";
     if (expected_result /= Z) then 
         report "Wrong for -120+(-22.6)";
         counter_errors := counter_errors + 1;
     end if;
     
     StartOp <= '1';
     wait for 10ns;
     StartOp <= '0';
     op <= '0';
     X <= "01000010111100000000000000000000";   -- 120
     Y <= "11000001101101001100110011001101";   -- -22.6
     wait for 10ns;
     StartOp <= '0';
     wait for 300ns;
     expected_result := "01000010110000101100110011001101";
     if (expected_result /= Z) then 
         report "Wrong for 120+(-22.6)";
         counter_errors := counter_errors + 1;
     end if;
     
     StartOp <= '1';
     wait for 10ns;
     StartOp <= '0';
     op <= '1';
      X <= "11000010111100000000000000000000";  -- -120
     Y <= "11000001101101001100110011001101";   -- -22.6
     wait for 10ns;
     StartOp <= '0';
     wait for 300ns;
     expected_result := "11000010110000101100110011001101";
     if (expected_result /= Z) then 
         report "Wrong for -120-(-22.6)";
         counter_errors := counter_errors + 1;
     end if;
     
     StartOp <= '1';
     wait for 10ns;
     StartOp <= '0';
     op <= '1';
     X <= "01000010111100000000000000000000";   -- 120
     Y <= "11000001101101001100110011001101";   -- -22.6
     wait for 300ns;
     expected_result := "01000011000011101001100110011001";
     if (expected_result /= Z) then 
         report "Wrong for 120-(-22.6)";
         counter_errors := counter_errors + 1;
     end if;
     
     ---------------------------------------------
     op <= '0';
     X <= "01000010111100000000000000000000";   -- 120
     Y <= "01000001101101001100110011001101";   -- -22.6
     wait for 10ns;
     StartOp <= '0';
     wait for 300ns;
     expected_result := "01000011000011101001100110011001";
     if (expected_result /= Z) then 
         report "Wrong for 120+22.6";
         counter_errors := counter_errors + 1;
     end if;
     
     StartOp <= '1';
     wait for 10ns;
     StartOp <= '0';
     op <= '0';
     X <= "11000010111100000000000000000000";   -- 120
     Y <= "01000001101101001100110011001101";   -- -22.6
     wait for 10ns;
     StartOp <= '0';
     wait for 300ns;
     expected_result := "11000010110000101100110011001101";
     if (expected_result /= Z) then 
         report "Wrong for -120+22.6";
         counter_errors := counter_errors + 1;
     end if;
     
     StartOp <= '1';
     wait for 10ns;
     StartOp <= '0';
     op <= '1';
      X <= "01000010111100000000000000000000";   -- 120
     Y <= "01000001101101001100110011001101";   -- -22.6
     wait for 10ns;
     StartOp <= '0';
     wait for 300ns;
     expected_result := "01000010110000101100110011001101";
     if (expected_result /= Z) then 
         report "Wrong for 120-22.6";
         counter_errors := counter_errors + 1;
     end if;
     
     StartOp <= '1';
     wait for 10ns;
     StartOp <= '0';
     op <= '1';
     X <= "11000010111100000000000000000000";   -- 120
     Y <= "01000001101101001100110011001101";   -- -22.6
     wait for 300ns;
     expected_result := "11000011000011101001100110011001";
     if (expected_result /= Z) then 
         report "Wrong for -120-22.6";
         counter_errors := counter_errors + 1;
     end if;
     
     ---------------------------------------------------------------------------
     
     
     StartOp <= '1';
     op <= '0';
     X <= NaN;   -- 120
     Y <= "11000000101000000000000000000000";   
     wait for 10ns;
     StartOp <= '0';
     wait for 300ns;

     StartOp <= '1';
     op <= '0';
     X <= "11000010111100000000000000000000";   
     Y <= "11000000101000000000000000000000";  
     wait for 10ns;
     StartOp <= '0';
     wait for 300ns;
     expected_result := "11000010111110100000000000000000";
     if (expected_result /= Z) then 
         report "Wrong for -120+(-5)";
         counter_errors := counter_errors + 1;
     end if;
     
     StartOp <= '1';
     wait for 10ns;
     StartOp <= '0';
     op <= '0';
     X <= "01000010111100000000000000000000";   
     Y <= "11000000101000000000000000000000";   
     wait for 10ns;
     StartOp <= '0';
     wait for 300ns;
     expected_result := "01000010111001100000000000000000";
     if (expected_result /= Z) then 
         report "Wrong for 120-5";
         counter_errors := counter_errors + 1;
     end if;
     
     StartOp <= '1';
     wait for 10ns;
     StartOp <= '0';
     op <= '1';
      X <= "11000010111100000000000000000000";  
     Y <= "11000000101000000000000000000000";   
     wait for 10ns;
     StartOp <= '0';
     wait for 300ns;
     expected_result := "11000010111001100000000000000000";
     if (expected_result /= Z) then 
         report "Wrong for -120-(-5)";
         counter_errors := counter_errors + 1;
     end if;
     
     StartOp <= '1';
     wait for 10ns;
     StartOp <= '0';
     op <= '1';
     X <= "01000010111100000000000000000000";   
     Y <= "11000000101000000000000000000000";   
     wait for 300ns;
     expected_result := "01000010111110100000000000000000";
     if (expected_result /= Z) then 
         report "Wrong for 120-(-5)";
         counter_errors := counter_errors + 1;
     end if;
     
     ---------------------------------------------
     op <= '0';
     X <= "01000010111100000000000000000000";   
     Y <= "01000000101000000000000000000000";   
     wait for 10ns;
     StartOp <= '0';
     wait for 300ns;
     expected_result := "01000010111110100000000000000000";
     if (expected_result /= Z) then 
         report "Wrong for 120+5";
         counter_errors := counter_errors + 1;
     end if;
     
     StartOp <= '1';
     wait for 10ns;
     StartOp <= '0';
     op <= '0';
     X <= "11000010111100000000000000000000";  
     Y <= "01000000101000000000000000000000";   
     wait for 10ns;
     StartOp <= '0';
     wait for 300ns;
     expected_result := "11000010111001100000000000000000";
     if (expected_result /= Z) then 
         report "Wrong for -120+5";
         counter_errors := counter_errors + 1;
     end if;
     
     StartOp <= '1';
     wait for 10ns;
     StartOp <= '0';
     op <= '1';
      X <= "01000010111100000000000000000000";   
     Y <= "01000000101000000000000000000000";  
     wait for 10ns;
     StartOp <= '0';
     wait for 300ns;
     expected_result := "01000010111001100000000000000000";
     if (expected_result /= Z) then 
         report "Wrong for 120-5";
         counter_errors := counter_errors + 1;
     end if;
     
     StartOp <= '1';
     wait for 10ns;
     StartOp <= '0';
     op <= '1';
     X <= "11000010111100000000000000000000";  
     Y <= "01000000101000000000000000000000";  
      wait for 10ns;
     StartOp <= '0';
     wait for 300ns;
     expected_result := "11000010111110100000000000000000";
     if (expected_result /= Z) then 
         report "Wrong for -120-5";
         counter_errors := counter_errors + 1;
     end if;
     
     StartOp <= '1';
     wait for 10ns;
     StartOp <= '0';
     op <= '0';
     X <= "01111111011111111111111111111111";   
     Y <=  "01111111011111111111111111111111";  
     wait for 10ns;
     StartOp <= '0';
     wait for 300ns;
     
     StartOp <= '1';
     wait for 10ns;
     StartOp <= '0';
     op <= '0';
     X <= "11000010111100000000000000000000";  
     Y <= "01000000101000000000000000000000";  
     wait for 300ns;
     expected_result := "11000010111001100000000000000000";
     if (expected_result /= Z) then 
         report "Wrong for -120+5";
         counter_errors := counter_errors + 1;
     end if;
     
     if counter_errors /= 0 then
            report "Found " & INTEGER'image (counter_errors) & " errors";
        else 
            report "Simulation Ended Successfully!";
        end if;
     
    wait for 100000ns; 
    
end process;






end Behavioral;
