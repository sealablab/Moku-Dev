-- Binkers/blink_g.vhd: This Blinker illustrates how to use [VHDL Generics]()
library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.Numeric_Std.all;

entity blink is
  generic (
    WIDTH : integer := 16
  );
  port (
    clk        : in  std_logic;
    reset      : in  std_logic;
    control0   : in  std_logic_vector(31 downto 0);
    blink_out  : out signed(WIDTH-1 downto 0)
  );
end entity;

architecture rtl of blink is
  signal enable : std_logic;
  signal cnt    : signed(WIDTH-1 downto 0) := (others => '0');
begin
  enable <= not control0(15); -- active-low enable

  process(clk) 
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cnt <= (others => '0');  -- reset logic
      elsif enable = '1' then
        cnt <= cnt + 1;          -- counter updates only when enabled
      end if;                    -- closes: if reset / elsif enable
    end if;                      -- closes: if rising_edge(clk)
  end process;                   -- end process (clk)
        
  -- Synchronous logic:       
  blink_out <= signed(cnt);     -- Assign our counter variable to output

end architecture rtl;

