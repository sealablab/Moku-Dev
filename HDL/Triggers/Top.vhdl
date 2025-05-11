-- Triggers/Top.vhd

library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.Numeric_Std.all;


architecture Behavioural of CustomWrapper is
begin

  u_blink: entity work.blink
    port map (
      clk       => Clk,
      reset     => Reset,
      control0  => Control0,
      blink_out => OutputA
    );

end architecture Behavioural;
