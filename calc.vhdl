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
  signal ImmEx: std_logic_vector(7 downto 0);
  signal jump_amt: std_logic_vector(1 downto 0);
  signal imm: std_logic_vector(3 downto 0);
  signal WdSel: std_logic;
  signal clk: std_logic := '0';
  signal clk_rd, clk_wd: std_logic_vector(1 downto 0) := "00";

  signal ALUOp, ALUOpE, ALUOpW: std_logic;
  signal CmpOpE, CmpOpW: std_logic;
  signal Cmp, CmpE: std_logic;
  signal CmpResult, CmpW: std_logic := '0';
  signal rs1, rs2: std_logic_vector(1 downto 0);
  signal rd1, rd1E, rd1W: std_logic_vector(7 downto 0);
  signal rd2, rd2E, rd2W: std_logic_vector(7 downto 0);
  signal ws, wsE, wsW: std_logic_vector(1 downto 0);
  signal we, weE, weW: std_logic;
  signal print, printE, printW: std_logic;
  signal wd: std_logic_vector(7 downto 0);
  signal ALUOut, ALUOutW: std_logic_vector(7 downto 0);

  signal oldws: std_logic_vector(1 downto 0);
signal tmpws: std_logic_vector(1 downto 0);
  signal hazard: std_logic;

  signal opcode: std_logic_vector(7 downto 0);
begin

  opcode <= op7& op6 & op5 & op4 & op3 & op2 & op1 & op0;
  --Control logic
  ALUOp <= op6;
  WdSel <= op7 and (not op6);
  we <= op6 nand op6;
  Cmp <= op7 and op6 and (not op5);
  print <= op7 and op6 and op5;
  hazard <= (op7 and not op6) or (op7 and op6 and op5);
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
    WE => we,
    clk => clk
  );

  IDEXE: entity work.pipe
  port map(
    ALUOp => ALUOp,
    ALUOpO => ALUOpE,
    CmpOp => op4,
    CmpOpO => CmpOpE,
    Cmp => Cmp,
    CmpO => CmpE,
    rd1 => rd1,
    rd1O => rd1E,
    rd2 => rd2,
    rd2O => rd2E,
    ws => ws,
    wsO => wsE,
    we => we,
    weO => weE,
    ALUOut => "00000000",
    print => print,
    printO => printE,
    clk => clk_input
  );

  EXEWB: entity work.pipe
  port map(
    CmpOp => CmpOpE,
    CmpOpO => CmpOpW,
    Cmp => CmpE,
    CmpO => CmpW,
    ALUOut => ALUOut,
    ALUOutO => ALUOutW,
    ws => wsE,
    wsO => wsW,
    we => weE,
    weO => weW,
    ALUOp => '0',
    rd1 => rd1E,
    rd1O => rd1W,
    rd2 => rd2E,
    rd2O => rd2W,
    print => printE,
    printO => printW,
    clk => clk_input
  );

  with WdSel select
    wd <= ALUOutW when '0',
          ImmEx when others;

  alu: entity work.add_sub
  generic map(
               N => 8
             )
  port map(
            A => rd1E,
            B => rd2E,
            sel => ALUOpE,
            O => ALUOut
          );

  with CmpResult select
    clk_wd <= '0' & clk_rd(1) when '0',
              CmpOpW & '1' when others;

  with ALUOutW select
    CmpResult <= CmpW when "00000000",
                 '0' when others;

  clockfile0: entity work.clockfile
  port map(
            clk_in => clk_input,
            clk_out => clk,
            wd => clk_wd,
            rd => clk_rd
          );

  process(clk) is
  begin
    if (clk = '0' and print = '1' and rd1W(7) = '0') then
      report integer'image(to_integer(signed(rd1W)) mod 10000 / 1000) &
      integer'image(to_integer(signed(rd1W)) mod 1000 / 100) &
      integer'image(to_integer(signed(rd1W)) mod 100 / 10) &
      integer'image(to_integer(signed(rd1W)) mod 10 / 1);
    end if;
    if (clk = '0' and print = '1' and rd1W(7) = '1') then
      report '-' &
      integer'image(abs(to_integer(signed(rd1W)) rem 1000 / 100)) &
      integer'image(abs(to_integer(signed(rd1W)) rem 100 / 10)) &
      integer'image(abs(to_integer(signed(rd1W)) rem 10 / 1));
    end if;
  end process;

  process(clk) is
  begin
    if (clk = '1') then
      tmpws <= ws;
      oldws <= tmpws;
    end if;
  end process;

end behav;

