-- Binkers/blink_b.vhd: The most basic of blinkers
library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.Numeric_Std.all;

entity blink_b is
  port (
    clk        : in  std_logic;
    reset      : in  std_logic;
    control0   : in  std_logic_vector(31 downto 0);
    blink_out  : out signed(15 downto 0)
  );
end entity;

architecture rtl of blink_b is
  signal enable : std_logic;
  signal cnt    : unsigned(15 downto 0) := (others => '0');

begin
  enable <= not control0(15); -- active-low enable

 process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cnt <= (others => '0');
      else
        cnt <= cnt + 1; -- This is the whole enchilada 
      end if; -- if (reset)
    end if; -- if (rising_ede)
  end process; -- clk

end architecture; --blink_b
      
