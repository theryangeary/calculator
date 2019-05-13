library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile is
port(
  rs1, rs2, ws: in std_logic_vector(1 downto 0);
  wd: in std_logic_vector(7 downto 0);
  WE: in std_logic;
  clk: in std_logic;

  rd1, rd2: out std_logic_vector(7 downto 0) := "00000000"
);
end regfile;

architecture behav of regfile is

  signal r0, r1, r2, r3, mux1out, mux2out: std_logic_vector(7 downto 0) := "00000000";

begin

  mux1: entity work.mux
  port map(
    A => r0,
    B => r1,
    C => r2,
    D => r3,
    sel => rs1,
    O => mux1out
  );

  mux2: entity work.mux
  port map(
    A => r0,
    B => r1,
    C => r2,
    D => r3,
    sel => rs2,
    O => mux2out
  );

  process (clk) is
  begin
    if (WE = '1' and clk = '1') then
      if (ws = "00") then
        r0 <= wd;
      elsif (ws = "01" ) then
        r1 <= wd;
      elsif (ws = "10") then
        r2 <= wd;
      else
        r3 <= wd;
      end if;
    end if;
  end process;

  process(clk, mux1out, mux2out) is
  begin
    if (clk = '0') then
      rd1 <= mux1out;
      rd2 <= mux2out;
    end if;
  end process;

end behav;

