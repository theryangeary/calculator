library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipe is
  port(
        ALUOp: in std_logic;
        ALUOpO: out std_logic;
        ALUOut: in std_logic_vector(7 downto 0);
        ALUOutO: out std_logic_vector(7 downto 0);
        Cmp: in std_logic;
        CmpO: out std_logic;
        CmpOp: in std_logic;
        CmpOpO: out std_logic;
        ImmEx: in std_logic_vector(7 downto 0);
        ImmExO: out std_logic_vector(7 downto 0);
        wdsel: in std_logic;
        wdselO: out std_logic;
        we: in std_logic;
        weO: out std_logic;
        rd1: in std_logic_vector(7 downto 0);
        rd1O: out std_logic_vector(7 downto 0);
        rd2: in std_logic_vector(7 downto 0);
        rd2O: out std_logic_vector(7 downto 0);
        ws: in std_logic_vector(1 downto 0);
        wsO: out std_logic_vector(1 downto 0);
        print: in std_logic;
        printO: out std_logic;
        clk: in std_logic
);
end pipe;

architecture behav of pipe is

begin

  process (clk) is
  begin
    if (clk = '1') then

      ALUOpO <= ALUOp;
      CmpOpO <= CmpOp;
      CmpO <= Cmp;
      rd1O <= rd1;
      rd2O <= rd2;
      wdselO <= wdsel;
      ImmExO <= ImmEx;
      wsO <= ws;
      weO <= we;
      ALUOutO <= ALUOut;
      printO <= print;

    end if;
  end process;

end behav;

