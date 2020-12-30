library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity UC is
  Port ( SX : in STD_LOGIC;
         SY : in STD_LOGIC;
         Clk : in STD_LOGIC;
         DifExp : in STD_LOGIC_VECTOR(7 downto 0);
         ZComp : in STD_LOGIC_VECTOR(4 downto 0);
         RezHiddenBit : in STD_LOGIC;   
         Carry :  STD_LOGIC;
         Start : in STD_LOGIC;
         op : in STD_LOGIC;
         ExpDec : in STD_LOGIC_VECTOR(8 downto 0);
         ExpInc : in STD_LOGIC_VECTOR(8 downto 0);
         --------------------------------------------
         SR : out STD_LOGIC ;                            
         SL : out STD_LOGIC ;
         LD : out STD_LOGIC ;
         LDRez : out STD_LOGIC;
         LDMant : out STD_LOGIC;
         LDMantSum : out STD_LOGIC;
         SelectionOp : out STD_LOGIC ;
         OverF : out STD_LOGIC ;
         UnderF : out STD_LOGIC ;
         EnableDec : out STD_LOGIC;
         EnableInc : out STD_LOGIC;
         LDinc : out STD_LOGIC;
         StopSig : out STD_LOGIC
  );
end UC;


architecture Behavioral of UC is

    type State_Type is (idle,
                        load,
                        init,
                        dif_exp,
                        shift_mantissa_right ,
                        stop,
                        test_norm,
                        shift_mant_right2,
                        rounding,
                        shift_mantissa_left,
                        report_res,
                        verif_underflow,
                        verif_overflow,
                        Error
                        );
    signal st : State_Type := idle;
    signal SelOp : STD_LOGIC;

begin

    SelectionOp <= SelOp;
    process(Clk)
        variable cntShiftRight : STD_LOGIC_VECTOR(7 downto 0);
        variable cntShiftLeft : STD_LOGIC_VECTOR(4 downto 0);
    begin
        if RISING_EDGE(Clk) then
                case st is
                    when idle => 
                        case Start is 
                            when '0' =>
                                 st <= idle;
                            when '1' =>
                                 st <= load;
                            when others => 
                                 st <= Error; 
                        end case;
                         
                     when load => 
                         st <= init;                   
                     
                     when init => 
                         if (SX xnor SY) = '1' then     
                           SelOp <= '0';
                         else 
                           SelOp <= '1';
                         end if;
                                  
                      st <= dif_exp;   
                      
                     when dif_exp => 
                         if DifExp = x"00" then              
                            if SelOp = '0' then                                
                                st <= test_norm;
                            else 
                                st <= test_norm;
                            end if;
                         elsif DifExp <= x"18" then         
                            st<= shift_mantissa_right;
                         else                                                      
                            st <= report_res;      
                         end if;
                         cntShiftRight := DifExp - 1;
                                     
                    when shift_mantissa_right =>                                       
                         if cntShiftRight > x"00" then
                            st <= shift_mantissa_right;
                            cntShiftRight := cntShiftRight - 1;
                         else
                            if SelOp = '0' then                             
                                st <= test_norm;
                             else 
                                st <= test_norm;
                             end if;
                         end if;        
                                         
                    when test_norm => 
                       if Carry = '0' then 
                            if RezHiddenBit = '0' then 
                                st <= shift_mantissa_left;
                            else st <= rounding;
                            end if;
                        else st <= shift_mant_right2;
                        
                        end if;
                        cntShiftLeft := ZComp - 2;
                                      
                    when shift_mantissa_left =>                                       
                            if cntShiftLeft > "00000" then
                                st <= shift_mantissa_left;
                                cntShiftLeft := cntShiftLeft - 1;
                            else
                                st <= rounding;
                            end if;                   
                                      
                    when rounding =>
                          st <= verif_underflow;                          
                                                     
                    when shift_mant_right2 =>
                          st <= verif_overflow;
                    
                    when verif_overflow =>     
                         if ExpInc(8) = '1' then               
                            OverF <= '1';
                         end if;
                         st <= report_res;                                       
                    
                    when verif_underflow =>
                         if ExpDec = "111111111" then         
                            UnderF <= '1';
                         end if;
                         st <= report_res;                                      
   
                    when report_res =>
                          st <= stop;             
                    
                    when stop =>
                          st <= idle;
                    
                    when others =>
                          st <= Error;
                    
                end case;
        end if;
    end process;
    
    LD <= '1' when st = load else '0';
    SR <= '1' when st = shift_mantissa_right or st = shift_mant_right2 else '0';
    SL <= '1' when st = shift_mantissa_left else '0';
    
    EnableDec <= '1' when st = shift_mantissa_left else '0';
    EnableInc <= '1' when st = shift_mant_right2 else '0';
    
    Ldinc <= '1' when st = init else '0';
    LDRez <= '1' when st = report_res else '0';
    LDMant <= '1' when st = init else '0';
    LDMantSum <= '1' when st = test_norm else '0';
    StopSig <= '1' when st = stop else '0';
   
end Behavioral;
