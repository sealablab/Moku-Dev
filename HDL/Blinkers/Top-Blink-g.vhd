-- Blinkers/Top-Blink-g.vhd
-- This file instantiates a blinker (blink_g) using the generic feature of VHDL
-- See Also: blink_b.vhd

library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.Numeric_Std.all;

architecture Behavioural of CustomWrapper is
begin

-- Instantiate a blinker using the generic feature of VHDL.
-- NOTE the use of the `generic map` keyword to pass the WIDTH parameter to the blink_g entity.
  u_blink: entity work.blink
    generic map (
      WIDTH => 16
    )
    port map (
      clk       => Clk,
      reset     => Reset,
      control0  => Control0,
      blink_out => OutputA
    );

end architecture Behavioural;
-- Blinkers/Top-Blink-g.vhd
