-- ####################################################################
-- # delay_b.vhd
-- #
-- # Description:
-- #   This module implements a trigger delay using a programmable
-- #   delay count. When `trig_in` is asserted and `en` is high, the
-- #   module starts counting clock ticks. After the number of ticks
-- #   specified by `delay`, it emits a `trig_out` pulse and asserts
-- #   `fired` until a reset.
-- #
-- # Features:
-- #   - Configurable delay (8-bit unsigned value)
-- #   - Rising edge detection on trig_in
-- #   - Enable control via `en` input
-- #   - Outputs `trig_out` for 1 clock cycle after delay
-- #   - `fired` stays high after triggering until reset
-- #
-- # Compatible with Vivado 2022.2 and Moku Cloud Compile
-- ####################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delay_b is
  port (
    en         : in  std_logic;                        -- Enable input
    clk        : in  std_logic;                        -- Clock input
    reset      : in  std_logic;                        -- Synchronous reset
    trig_in    : in  std_logic;                        -- Trigger input
    delay      : in  std_logic_vector(7 downto 0);     -- Delay in clock ticks
    trig_out   : out std_logic;                        -- Trigger output (1 cycle pulse)
    fired      : out std_logic                         -- Stays high after triggering
  );
end entity delay_b;

architecture rtl of delay_b is

  signal delay_counter : unsigned(7 downto 0) := (others => '0');
  signal counting      : std_logic := '0';
  signal trig_out_r    : std_logic := '0';
  signal fired_r       : std_logic := '0';
  signal trig_in_prev  : std_logic := '0';  -- for rising edge detection

begin

  process(clk)
  begin
    if rising_edge(clk) then

      if reset = '1' then
        delay_counter <= (others => '0');
        counting      <= '0';
        trig_out_r    <= '0';
        fired_r       <= '0';
        trig_in_prev  <= '0';

      else  -- not in reset

        trig_out_r   <= '0';  -- default output pulse (1 cycle only)

        -- Rising edge detection on trig_in
        if en = '1' and trig_in = '1' and trig_in_prev = '0' and counting = '0' then
          delay_counter <= unsigned(delay) - 1;
          counting      <= '1';
        end if;

        -- Countdown logic
        if counting = '1' then
          if delay_counter = 0 then
            trig_out_r <= '1';  -- trigger fires
            fired_r    <= '1';  -- fired stays high
            counting   <= '0';  -- stop counting
          else
            delay_counter <= delay_counter - 1;
          end if;
        end if;

        -- Update edge detector
        trig_in_prev <= trig_in;

      end if;  -- end reset
    end if;  -- end clk rising edge
  end process;

  -- Assign outputs
  trig_out <= trig_out_r;
  fired    <= fired_r;

end architecture rtl;
