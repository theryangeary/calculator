library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calc is
port(
      op0: in std_logic;
      op1: in std_logic;
      op2: in std_logic;
      op3: in std_logic;
      op4: in std_logic;
      op5: in std_logic;
      op6: in std_logic;
      op7: in std_logic;
      clk: in std_logic;
    );
end calc;

architecture behav of calc is
  signal PCrd, PCwr, rd1, rd2, wd, ALUOut, ImmEx: std_logic_vector(7 downto 0);
  signal CmpInc, PCInc: std_logic_vector(1 downto 0);
  signal Cmp, Imm, WrEn, ALUOp: std_logic;
begin

end behav;

