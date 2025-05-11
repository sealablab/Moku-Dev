library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.Numeric_Std.all;

entity blink_tb is
end entity;

architecture sim of blink_tb is
  signal clk        : std_logic := '0';
  signal reset      : std_logic := '0';
  signal control0   : std_logic_vector(31 downto 0) := (others => '1');
  signal blink_out  : std_logic;
begin
  -- Instantiate the blink DUT (Design Under Test)
  uut: entity work.blink
    port map (
      clk       => clk,
      reset     => reset,
      control0  => control0,
      blink_out => blink_out
    );

  -- Clock generation: toggles clk every 5 ns (10 ns period = 100 MHz)
  clk_gen: process
  begin
    while true loop
      clk <= '0'; wait for 5 ns;
      clk <= '1'; wait for 5 ns;
    end loop;
  end process;

  -- Stimulus process: applies reset and toggles control signals
  stim: process
  begin
    wait for 10 ns;
    reset <= '1';              -- assert reset
    wait for 10 ns;
    reset <= '0';              -- deassert reset

    wait for 100 ns;
    control0(15) <= '0';       -- enable blink by lowering active-low enable

    wait for 300 ns;
    assert false report "End of simulation." severity failure;
  end process;

end architecture;
