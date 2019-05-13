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
      clk_input: in std_logic
    );
end calc;

architecture behav of calc is
  signal rd1, rd2, wd, ALUOut, ImmEx: std_logic_vector(7 downto 0);
  signal CmpInc, PCInc: std_logic_vector(1 downto 0);
  signal rs1, rs2, ws, jump_amt: std_logic_vector(1 downto 0);
  signal imm: std_logic_vector(3 downto 0);
  signal Cmp: std_logic_vector(0 downto 0);
  signal WdSel, WrEn, ALUOp: std_logic;
  signal clk: std_logic := '0';
  signal clk_rd, clk_wd: std_logic_vector(1 downto 0) := "00";
begin

  --Control logic
  ALUOp <= op6;
  WdSel <= op7 and (not op6);
  WrEn <= op7 nand op6;
  process(ALUOut, op7, op6, op5) is
  begin
    if (ALUOut = "00000000" and op7 = '1' and op6 = '1' and op5 = '0') then
      Cmp(0) <= '0';
    else
      Cmp(0) <= '1';
    end if;
  end process;
  --End control logic

  rs1 <= op3 & op2;
  rs2 <= op1 & op0;
  ws  <= op5 & op4;
  imm <= op3 & op2 & op1 & op0;
  jump_amt <= op4 & '1';

  ImmEx <= op3 & op3 & op3 & op3 & op3 & op2 & op1 & op0;

  reg: entity work.regfile
  port map(
    rs1 => rs1,
    rs2 => rs2,
    rd1 => rd1,
    rd2 => rd2,
    ws => ws,
    wd => wd,
    WE => WrEn,
    clk => clk
  );

  with WdSel select
    wd <= ALUOut when '0',
          ImmEx when others;

  alu: entity work.add_sub
  generic map(
    N => 8
  )
  port map(
    A => rd1,
    B => rd2,
    sel => ALUOp,
    O => ALUOut
  );

  with Cmp select
    clk_wd <= '0' & clk_rd(1) when "1",
              op4 & '1' when others;

  clockfile0: entity work.clockfile
  port map(
    clk_in => clk_input,
    clk_out => clk,
    wd => clk_wd,
    rd => clk_rd
  );

  process(clk) is
  begin
    if (clk = '0' and op7 = '1' and op6 = '1' and op5 = '1' and rd1(7) = '0') then
      report integer'image(to_integer(signed(rd1)) mod 10000 / 1000) &
      integer'image(to_integer(signed(rd1)) mod 1000 / 100) &
      integer'image(to_integer(signed(rd1)) mod 100 / 10) &
      integer'image(to_integer(signed(rd1)) mod 10 / 1);
    end if;
    if (clk = '0' and op7 = '1' and op6 = '1' and op5 = '1' and rd1(7) = '1') then
      report '-' &
      integer'image(abs(to_integer(signed(rd1)) rem 1000 / 100)) &
      integer'image(abs(to_integer(signed(rd1)) rem 100 / 10)) &
      integer'image(abs(to_integer(signed(rd1)) rem 10 / 1));
    end if;
  end process;

end behav;

