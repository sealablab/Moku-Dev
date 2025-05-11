# [Blinkers](https://github.com/sealablab/Moku-Dev/tree/main/HDL/Blinkers)

``` python
## [Top.vhd](https://github.com/sealablab/Moku-Dev/blob/main/HDL/Blinkers/VHDL/Top.vhdl)
**Top.vhd**  **`VHDL`** Top file. Should always implement a [MokuCustomWrapper]()

## [Top.v](https://github.com/sealablab/Moku-Dev/blob/main/HDL/Blinkers/Verilog/Top.v)
**Top.v**  **`Verilog`** Top file. Should always implement a [MokuCustomWrapper]()
```

## Basic-Blinker
```
entity blink_b is
  port (
    clk        : in  std_logic;
    reset      : in  std_logic;
    control0   : in  std_logic_vector(31 downto 0);
    blink_out  : out signed(15 downto 0)
  );
end entity;
```
### [blink_b.vhd](https://github.com/sealablab/Moku-Dev/blob/main/HDL/Blinkers/VHDL/blink_b.vhd)

### [blink_b.vhd](https://github.com/sealablab/Moku-Dev/blob/main/HDL/Blinkers/VHDL/blink_b.vhd)





## 
