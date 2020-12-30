
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity test is
--  Port ( );
end test;

architecture Behavioral of test is

signal X : STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
signal Y : STD_LOGIC_VECTOR(31 downto 0) := x"00000000";

signal Sign_x : std_logic := '0';
signal Sign_y : std_logic := '0';

signal Exp_x : std_logic_vector := X"00";
signal Exp_y : std_logic_vector := X"00";

signal Mantisa_x : std_logic_vector := B"0000_0000_0000_0000_0000_0";
signal Mantisa_y : std_logic_vector := B"0000_0000_0000_0000_0000_0";


signal Clk : STD_LOGIC;
signal StartOp : STD_LOGIC;
signal op : STD_LOGIC;

signal Z : STD_LOGIC_VECTOR(31 downto 0) := x"00000000";

constant CLK_PERIOD : TIME := 10 ns;

begin
        test : entity WORK.Main port map (
                X => X,
                Y => Y,
                Clk => Clk,
                StartOp => StartOp,
                op => op,
                Z => Z
        );
        
         gen_clk: process
                  begin
                     Clk <= '0';
                     wait for (CLK_PERIOD/2);
                     Clk <= '1';
                     wait for (CLK_PERIOD/2);
                  end process gen_clk;
    
        gen_test : process
                   begin
                         
                        StartOp <= '0';

--                        X <= "01000000101000000000000000000000";   -- 5.0
--                        Y <= "01000000110000000000000000000000";   -- 6.0
--                        wait for 10ns;
--                       -- result : 41300000 => adunare
--                     --   result : BF800000 => scadere
                        
--                        X <= "01000010000011110000000000000000";   -- 35.75
--                        Y <= "01000001101001000000000000000000";   -- 20.5
--                         wait for 10ns;
--                          --        result : 42610000 => adunare
--                        --          result : 41740000 => scadere

--                        X <= "01000001100001000000000000000000";   -- 16.5    
--                        Y <= "01000000110010011001100110011010";   -- 6.3
--                         wait for 10ns;
--                           --       result : 41B66666 => adunare
--                           --       result : 41233334 => scadere

--                        X <= "01000000110000000000000000000000";   -- 6.0
--                        Y <= "01000000101000000000000000000000";   -- 5.0
--                         wait for 10ns;
--                             --     result : 3F800000 => scadere

--                        X <= "11000000101000000000000000000000";   -- -5.0
--                        Y <= "11000000110000000000000000000000";   -- -6.0
--                         wait for 10ns;
--                              --   result : C1300000 => adunare
--                              --   result : 3F800000 => scadere

--                         X <= "01000001011100000000000000000000";   -- 15.0
--                         Y <= "01000001101101001100110011001101";   -- 22.6
--                          wait for 10ns;
                               --  result : 42166666 => adunare   + + +
                               --  result : C0F33334 => scadere   + - +

                         X <= "01000010111100000000000000000000";   -- -120
                         Y <= "11000001101101001100110011001101";   -- -22.6
                          wait for 10ns;
--                                 result : C0F33334 => adunare   + + -
--                                 result : 42166666 => scadere   + - -

--                         X <= "11000001011100000000000000000000";   -- -15.0
--                         Y <= "01000001101101001100110011001101";   -- 22.6
--                                 result : 40F33334 => adunare   - + +
--                                 result : C2166666 => scadere   - - +

--                         X <= "11000001011100000000000000000000";   -- -15.0
--                         Y <= "11000001101101001100110011001101";   -- -22.6
--                                 result : C2166666 => adunare   - + -
--                                 result : 40F33334 => scadere   - - -

--                         X <= "01000010001101000111111001011101";   -- 45.1234
--                         Y <= "01000000000110111010010111100011";   -- 2.432
--                                result : 423E38BB => adunare
--                                result : 422AC3FF => scadere

--                         X <= "01000000000110111010010111100011";   -- 2.432
--                         Y <= "00000000000000000000000000000000";   -- 0.0
--                                result : 401BA5E3

                        op <= '0';
                        
                        wait;
                   end process;

end Behavioral;
