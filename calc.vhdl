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
      clk: in std_logic
    );
end calc;

architecture behav of calc is
  signal PC, PCrd, PCwr, rd1, rd2, wd, ALUOut, ImmEx: std_logic_vector(7 downto 0);
  signal CmpInc, PCInc: std_logic_vector(1 downto 0);
  signal rs1, rs2, ws, jump_amt: std_logic_vector(1 downto 0);
  signal imm: std_logic_vector(3 downto 0);
  signal Cmp, WdSel: std_logic_vector(0 downto 0);
  signal WrEn, ALUOp: std_logic;
begin

  rs1 <= op3 & op2;
  rs2 <= op1 & op0;
  ws  <= op5 & op4;
  imm <= op3 & op2 & op1 & op0;
  jump_amt <= op4 & '1';

  PCrd <= PC;
  PC <= PCwd;

  reg: entity work.regfile
  port map(
    rs1 => rs1,
    rs2 => rs2,
    ws => ws,
    wd => wd,
    WE => WrEn,
    clk => clk
  );

  wd_choice: entity work.mux
  generic map(
    N => 1
  )
  port map(
    A => ALUOut,
    B => ImmEx,
    C => ALUOut,
    D => ImmEx,
    sel => WdSel,
    O => wd
  );

  alu: entity work.add_sub
  generic map(
    N => 8
  )
  port map(
    A => rd1,
    B => rd2,
    sel => ALUOp,
    clock => clk,
    O => ALUOut
  );

  cmp_adder: entity work.add_sub
  generic map(
    N => 2
  )
  port map(
    A => jump_amt,
    B => "01",
    sel => '0',
    clock => clk,
    O => CmpInc
  );

  pc_mux: entity work.mux
  generic map(
    N => 1,
    INLENGTH => 2
  )
  port map(
    A => CmpInc,
    B => "01",
    C => CmpInc,
    D => "01",
    sel => Cmp,
    O => PCInc
  );

  pc_adder: entity work.add_sub
  generic map(
    N => 8
  )
  port map(
    A => PCrd,
    B => PCInc,
    sel => '0',
    clock => clk,
    O => PCwr
  );

end behav;

