-- Binkers/blink_g.vhd: This Blinker illustrates how to use [VHDL Generics]()
library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.Numeric_Std.all;

entity blink is
  port (
    clk        : in  std_logic;
    reset      : in  std_logic;
    control0   : in  std_logic_vector(31 downto 0);
    blink_out  : out signed(15 downto 0)
  );
end entity;

architecture rtl of blink is
  signal enable : std_logic;
begin
  enable <= not control0(15); -- active-low enable

  u_box: entity work.blink_box
    generic map (
      WIDTH => 16,
      OUTPUT_BIT => 15
    )
    port map (
      clk       => clk,
      reset     => reset,
      enable    => enable,
      blink_out => blink_out
    );

