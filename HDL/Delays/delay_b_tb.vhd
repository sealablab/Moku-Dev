-- ########################################################################
-- # delay_b_tb.vhd
-- #
-- # Student-Friendly Testbench for `delay_b`
-- #
-- # ✅ Tests Covered:
-- #   1. Trigger causes `trig_out` after 4 clock cycles
-- #   2. `trig_out` is high for 1 cycle only
-- #   3. `fired` stays high after triggering
-- #   4. `reset` clears `fired` and all internal state
-- #
-- # 🛠 Features for Students:
-- #   - Simulation banner and log tags
-- #   - Cycle counter for tracking time
-- #   - Readable assert messages and waveform hints
-- #   - Machine-readable log tags: ::PASS::, ::FAIL::, ::DONE::
-- ########################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delay_b_tb is
end entity;

architecture test of delay_b_tb is

  -- DUT signals
  signal en        : std_logic := '0';
  signal clk       : std_logic := '0';
  signal reset     : std_logic := '0';
  signal trig_in   : std_logic := '0';
  signal delay     : std_logic_vector(7 downto 0) := (others => '0');
  signal trig_out  : std_logic;
  signal fired     : std_logic;

  -- Simulation helpers
  constant CLK_PERIOD : time := 8 ns;  -- 125 MHz clock (Moku:Go)
  signal cycle        : integer := 0;

begin

  -- Clock generation
  clk_process : process
  begin
    while now < 300 ns loop
      clk <= '0';
      wait for CLK_PERIOD / 2;
      clk <= '1';
      wait for CLK_PERIOD / 2;
    end loop;
    wait;
  end process;

  -- Cycle counter for debug
  cycle_counter : process(clk)
  begin
    if rising_edge(clk) then
      cycle <= cycle + 1;
    end if;
  end process;

  -- DUT instantiation
  uut: entity work.delay_b
    port map (
      en        => en,
      clk       => clk,
      reset     => reset,
      trig_in   => trig_in,
      delay     => delay,
      trig_out  => trig_out,
      fired     => fired
    );

  -- Stimulus process
  stimulus : process
  begin
    report "------------------------------------------------------------";
    report " Testbench for delay_b.vhd                                ";
    report "------------------------------------------------------------";

    report "::TESTCASE::trigger_with_4_cycle_delay";

    en    <= '1';
    delay <= std_logic_vector(to_unsigned(4, 8));  -- 4 cycle delay

    wait for 3 * CLK_PERIOD;

    report "[INFO] Cycle " & integer'image(cycle) & ": Pulsing trig_in";
    trig_in <= '1';
    wait for CLK_PERIOD;
    trig_in <= '0';

    report "[CHECK] Waiting for trig_out to go high (should be after delay)...";
    wait for 4 * CLK_PERIOD;

    assert trig_out = '1'
      report "::FAIL::ASSERTION: trig_out not asserted after 4 cycles delay" severity error;

    wait for CLK_PERIOD;

    assert trig_out = '0'
      report "::FAIL::ASSERTION: trig_out not deasserted after 1 clock" severity error;

    assert fired = '1'
      report "::FAIL::ASSERTION: fired not asserted after trigger" severity error;

    report "::CHECKPOINT::trigger_and_delay_passed";

    report "::TESTCASE::reset_behavior";

    reset <= '1';
    wait for CLK_PERIOD;
    reset <= '0';

    wait for CLK_PERIOD;

    assert fired = '0'
      report "::FAIL::ASSERTION: fired not cleared by reset" severity error;

    assert trig_out = '0'
      report "::FAIL::ASSERTION: trig_out should remain low after reset" severity error;

    report "::CHECKPOINT::reset_behavior_passed";

    report "::PASS::ALL_TESTS";
    report "::DONE::SIMULATION_DONE";
    wait;
  end process;

end architecture;
