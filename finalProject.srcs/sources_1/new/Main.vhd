library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.All;


entity Main is
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
end Main;

architecture Behavioral of Main is

signal NumberA : STD_LOGIC_VECTOR(31 downto 0);
signal NumberB : STD_LOGIC_VECTOR(31 downto 0);

--UC
signal Load : STD_LOGIC;
signal LoadRez : STD_LOGIC;
signal ShiftRight : STD_LOGIC := '0';                          
signal SL : STD_LOGIC := '0';                
signal SelectionOp : STD_LOGIC := '0';
signal OverF : STD_LOGIC := '0';
signal UnderF : STD_LOGIC := '0';
signal EnableDec : STD_LOGIC := '0';
signal EnableInc : STD_LOGIC := '0';
signal LDMant : STD_LOGIC := '0';
signal LDMantSum : STD_LOGIC := '0';
signal LDinc : STD_LOGIC := '0';
signal StopSig : STD_LOGIC := '0';

--difExp
signal diff : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
signal Swap_enable : STD_LOGIC;

--ALU
signal SumMant : STD_LOGIC_VECTOR(24 downto 0);
signal Entry1 : STD_LOGIC_VECTOR(24 downto 0);
signal Entry2 : STD_LOGIC_VECTOR(24 downto 0);
signal Carry : std_logic; 

--rounding
signal RotMant : STD_LOGIC_VECTOR(22 downto 0);
signal Rotexp : STD_LOGIC_VECTOR(7 downto 0);
signal SelExp : STD_LOGIC_VECTOR(7 downto 0);

--Mux 
signal Mmin : STD_LOGIC := '0';                    
signal ExpGrt : STD_LOGIC_VECTOR(7 downto 0);
signal LowerMant : STD_LOGIC_VECTOR(23 downto 0);
signal GreaterMant : STD_LOGIC_VECTOR(23 downto 0);
signal LowerMantMux : STD_LOGIC_VECTOR(22 downto 0);
signal GreaterMantMux : STD_LOGIC_VECTOR(22 downto 0);

--ShiftRegisterRight
signal ShiftMant : STD_LOGIC_VECTOR(23 downto 0);

--Decrement
signal ExpDec : STD_LOGIC_VECTOR(8 downto 0);

--Increment
signal ExpInc : STD_LOGIC_VECTOR(8 downto 0);
signal ExpInc1 : STD_LOGIC_VECTOR(7 downto 0);

--Mask
signal cntShift : STD_LOGIC_VECTOR(4 downto 0) := "00000";

--ShiftRegisterLeft
signal MantToRound : STD_LOGIC_VECTOR(24 downto 0);

--LoadReg
signal FinalRez : STD_LOGIC_VECTOR(31 downto 0);

signal RezConcat : STD_LOGIC_VECTOR(31 downto 0);

--sign decide
signal SRez : STD_LOGIC;
signal SwitchNr : STD_LOGIC;

signal MantToShift : STD_LOGIC_VECTOR(23 downto 0);

--verify numbers
signal enableVerif : STD_LOGIC;
signal ZVerif : STD_LOGIC_VECTOR(31 downto 0);

  signal extManX : std_logic_vector(24 downto 0);
   signal extManY : std_logic_vector(24 downto 0);

begin

    NumberB(31) <= Y(31) xor op;
    
    FirstNumber : entity WORK.Load_Register 
    generic map (nrBits=>32) 
    port map (
                        D => X,
                        Load => Load,
                        Clr => '0',
                        Clk => Clk,
                        Q => NumberA
    );
    
    SecondNumber : entity WORK.Load_Register
    generic map (nrBits=>31) 
    port map (
                        D => Y(30 downto 0),
                        Load => Load,
                        Clr => '0',
                        Clk => Clk,
                        Q => NumberB(30 downto 0)
    );
    
    NumbersNature : entity WORK.NumbersNature port map(
                        X => NumberA,
                        Y => NumberB,
                        op => op,
                        enable => enableVerif,
                        Z => ZVerif
    );
    
    DifferenceExponents : entity WORK.Difference_Exponents port map(
                        X => NumberA,
                        Y => NumberB,
                        DifExp => diff,
                        Swap_enable => Swap_enable
    );

    Control : entity WORK.UC 
              port map (SX => NumberA(31),
                        SY => NumberB(31),
                        Clk => Clk,
                        DifExp => diff,
                        ZComp => cntShift,
                        RezHiddenBit => SumMant(23),
                        Carry => Carry,
                        Start => StartOp,
                        op => op,
                        ExpDec => Expdec,
                        ExpInc => ExpInc,
                        SR => ShiftRight,
                        SL => SL,
                        LD => Load,
                        LDRez => LoadRez,
                        LDMant => LDMant,
                        LDMantSum => LDMantSum,
                        SelectionOp => SelectionOp,
                        OverF => OverF,
                        UnderF => UnderF,
                        EnableDec => EnableDec,
                        EnableInc => EnableInc,
                        LDinc => LDinc,
                        StopSig => StopSig );
    
    
    GreaterExp : entity WORK.MUX_2_1 
        generic map (nrBits => 8 )
        port map (X => NumberA(30 downto 23),
                  Y => NumberB(30 downto 23),
                  Sel => Swap_enable,
                  Z => ExpGrt
        );
        
    Mmin <= not Swap_enable;
    
    LowerMantissa : entity WORK.MUX_2_1 
        generic map ( nrBits => 23 )
        port map (X => NumberA(22 downto 0),
                  Y => NumberB(22 downto 0),
                  Sel => Mmin,
                  Z => LowerMantMux
        );
    LowerMant <= '1' & LowerMantMux;
                  
    GreaterMantissa : entity WORK.MUX_2_1 
        generic map (nrBits => 23)
        port map (X => NumberA(22 downto 0),
                  Y => NumberB(22 downto 0),
                  Sel => Swap_enable,
                  Z => GreaterMantMux
        );
    GreaterMant <= '1' & GreaterMantmux;
    
    ShiftMantissaRight : entity WORK.Shift_Left_Right_Register 
        generic map (nrBits => 24)
        port map (Clk => Clk,
                  SL => SL,   
                  SR => ShiftRight,
                  LD => LDMant,
                  Mant => LowerMant,
                  MantOut => ShiftMant
        );  
   
 
   
   extManX <= '0' & GreaterMant;
   extManY <= '0' & ShiftMant;
   UAL : entity WORK.ALU port map (
                        MX => GreaterMant,
                        MY => ShiftMant,
                        Carry => Carry,
                        ALUCtrl => SelectionOp,
                        MS => SumMant
        );
        
    Incrementare : entity WORK.Increment port map ( 
                        Exp => ExpGrt,
                        EnableInc => EnableInc,
                        EnableDec => EnableDec,
                        LDinc => LDinc,
                        Clk => Clk,
                        OutExp => ExpInc
    );  
    
    ExpInc1 <= ExpInc(7 downto 0);
--Returneaza numarul de zerouri de la inceputul semnalului
-- de la iesirea ALU mic (care aduna mantisele) printr-un semanl 
-- de 5 biti (pot fi maxim 24 de zerouri -> 25 de cazuri)
    Masca : entity WORK.Zero_Mantissa port map (
                        mant =>SumMant,
                        ZeroCount => cntShift
    );
    
    ShiftMantissaLeft : entity WORK.Shift_left_Right_Register 
        generic map (nrBits => 25)
        port map (      Clk => Clk,
                        SL => SL,   
                        SR => ShiftRight,
                        LD => LDMantSum,
                        Mant => SumMant,    --MantToNorm
                        MantOut => MantToRound
        );  
        
    Round : entity WORK.Rounding port map (
                        Mant => MantToRound,
                        Exp => ExpInc1,
                        Clk => Clk,
                        OutMant => RotMant,
                        OutExp => RotExp
    );
    
    
    RezConcat <= SRez & RotExp & RotMant;
    SRez <= NumberA(31) when Swap_enable = '0' else NumberB(31);
    FinalResult : entity WORK.Load_Register 
    generic map (nrBits=>32) 
    port map (
                D => RezConcat,
                Load => LoadRez,
                Clr => '0',
                Clk => Clk,
                Q => FinalRez
    );
    
    StopSignal <= StopSig;
    OverflowSignal <= OverF;
    UnderflowSignal <= UnderF;
    
    Z <= FinalRez when enableVerif = '1' else ZVerif;

end Behavioral;
