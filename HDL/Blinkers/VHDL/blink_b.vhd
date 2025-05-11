-- Binkers/blink_b.vhd: The most basic of blinkers

library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.Numeric_Std.all;
-- #entity
entity blink_b is
  port (
    clk        : in  std_logic;
    reset      : in  std_logic;
    control0   : in  std_logic_vector(31 downto 0);
    blink_out  : out signed(15 downto 0)
  );
end entity;
-- # architecture
architecture rtl of blink_b is
  signal enable : std_logic;
  signal cnt    : signed(15 downto 0) := (others => '0');

begin
  enable <= not control0(31); -- active-low enable

process(clk) 
begin
  if rising_edge(clk) then
    if reset = '1' then
      cnt <= (others => '0');  -- reset logic
    elsif enable = '1' then
      cnt <= cnt + 1;          -- counter updates only when enabled
    end if;                    -- closes: if reset / elsif enable
  end if;                      -- closes: if rising_edge(clk)
end process;                 -- end process (clk)
      
-- # Synronous logic:       
  blink_out <= signed(cnt);       -- 2) Assing our counter variable to output

end architecture; --blink_b

-- Blinkers/blink_b.vhd: The most basic of blinkers (EOF)


