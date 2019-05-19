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
  signal ImmEx, ImmExE, ImmExW: std_logic_vector(7 downto 0);
  signal jump_amt: std_logic_vector(1 downto 0);
  signal imm: std_logic_vector(3 downto 0);
  signal wdsel, wdselE, wdselW: std_logic;
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
  signal wereg: std_logic;
  signal print, printE, printW: std_logic;
  signal wd: std_logic_vector(7 downto 0);
  signal ALUOut, ALUOutW: std_logic_vector(7 downto 0);

  signal oldws: std_logic_vector(1 downto 0);
  signal tmpws: std_logic_vector(1 downto 0);
  signal potential_hazard, hazard: std_logic;

  signal opcode: std_logic_vector(7 downto 0);
begin

  --Control logic
  ALUOp <= opcode(6);
  wdsel <= opcode(7) and (not opcode(6));
  we <= opcode(7) nand opcode(6);
  Cmp <= opcode(7) and opcode(6) and (not opcode(5));

  process(clk) is
  begin
    if (clk'event and clk = '1') then
      print <= opcode(7) and opcode(6) and opcode(5) and (not opcode(4));
    end if;
  end process;
  --End control logic

  -- hazard stuff
  with hazard select
    opcode <= "11111111" when '1',
              op7 & op6 & op5 & op4 & op3 & op2 & op1 & op0 when others;

  process(clk) is
  begin
    if (clk'event and clk = '0') then
      potential_hazard <= (((not op7) or (op7 and (not op6))) and (not (opcode(7) and opcode(6) and opcode(5) and opcode(4))));
    end if;
  end process;

  process(hazard) is
  begin
    if (hazard = '1') then
      potential_hazard <= '0';
    end if;
  end process;

  process(clk) is
  begin
    if (clk'event and clk = '0') then
      if ((potential_hazard = '1') and ((oldws = rs1) or (oldws = rs2))) then
        hazard <= '1';
      else
        hazard <= '0';
      end if;
    end if;
  end process;


  rs1 <= op3 & op2;
  rs2 <= op1 & op0;
  ws  <= opcode(5) & opcode(4);
  imm <= opcode(3) & opcode(2) & opcode(1) & opcode(0);
  jump_amt <= opcode(4) & '1';

  ImmEx <= opcode(3) & opcode(3) & opcode(3) & opcode(3) & opcode(3) & opcode(2) & opcode(1) & opcode(0);

  reg: entity work.regfile
  port map(
    rs1 => rs1,
    rs2 => rs2,
    rd1 => rd1,
    rd2 => rd2,
    ws => wsw,
    wd => wd,
    WE => wew,
    clk => clk
  );

  IDEXE: entity work.pipe
  port map(
    ALUOp => ALUOp,
    ALUOpO => ALUOpE,
    CmpOp => opcode(4),
    CmpOpO => CmpOpE,
    Cmp => Cmp,
    CmpO => CmpE,
    rd1 => rd1,
    rd1O => rd1E,
    rd2 => rd2,
    ImmEx => ImmEx,
    ImmExO => ImmExE,
    rd2O => rd2E,
    wdsel => wdsel,
    wdselO => wdselE,
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
    ImmEx => ImmExE,
    ImmExO => ImmExW,
    wdsel => wdselE,
    wdselO => wdselW,
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

  with wdselW select
    wd <= ALUOutW when '0',
          ImmExW when others;

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
    if (clk = '0' and printE = '1' and rd1E(7) = '0') then
      report integer'image(to_integer(signed(rd1E)) mod 10000 / 1000) &
      integer'image(to_integer(signed(rd1E)) mod 1000 / 100) &
      integer'image(to_integer(signed(rd1E)) mod 100 / 10) &
      integer'image(to_integer(signed(rd1E)) mod 10 / 1);
    end if;
    if (clk = '0' and printE = '1' and rd1E(7) = '1') then
      report '-' &
      integer'image(abs(to_integer(signed(rd1E)) rem 1000 / 100)) &
      integer'image(abs(to_integer(signed(rd1E)) rem 100 / 10)) &
      integer'image(abs(to_integer(signed(rd1E)) rem 10 / 1));
    end if;
  end process;

  process(clk) is
  begin
    if (clk'event and clk = '1') then
      oldws <= ws;
    end if;
  end process;

end behav;

