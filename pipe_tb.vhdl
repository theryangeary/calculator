library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity pipe_tb is
  end pipe_tb;

architecture behav of pipe_tb is
  --  Declaration of the component that will be instantiated.
  component pipe
    port (
ALUOp: in std_logic;
CmpOp: in std_logic;
Cmp: in std_logic;
rd1: in std_logic_vector(7 downto 0);
rd2: in std_logic_vector(7 downto 0);
ws: in std_logic_vector(1 downto 0);
WE: in std_logic;
ALUOut: in std_logic_vector(7 downto 0);
ALUOpO: out std_logic;
CmpOpO: out std_logic;
CmpO: out std_logic;
rd1O: out std_logic_vector(7 downto 0);
rd2O: out std_logic_vector(7 downto 0);
wsO: out std_logic_vector(1 downto 0);
WEO: out std_logic;
ALUOutO: out std_logic_vector(7 downto 0);
print: in std_logic;
printO: out std_logic;
clk: in std_logic
  ); -- output the current register content
  end component;
  --  Specifies which entity is bound with the component.
  -- for shift_reg_0: pipe use entity work.pipe(rtl);
begin
  --  Component instantiation.
  --  This process does the real job.
end behav;
