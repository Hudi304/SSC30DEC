library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Load_Register is
  generic( nrBits: integer );
  Port ( D : in STD_LOGIC_VECTOR(nrBits-1 downto 0);
         Load : in STD_LOGIC;       -- load/enable
         Clr : in STD_LOGIC;      -- asynchronous clear
         Clk : in STD_LOGIC;     -- clock
         Q : out STD_LOGIC_VECTOR(nrBits-1 downto 0)  -- output
  );
end Load_Register;

architecture Behavioral of Load_Register is

begin

    process(Clk, Clr)
    begin
        if Clr = '1' then
            Q <= (others => '0');
        elsif rising_edge(Clk) then
            if Load = '1' then
                Q <= D;
            end if;
        end if;
    end process;

end Behavioral;
