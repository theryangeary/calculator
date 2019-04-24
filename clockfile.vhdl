library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clockfile is
port(
  rd: out std_logic_vector(1 downto 0) := "00";
  wd: in std_logic_vector(1 downto 0);
  clk_in: in std_logic;
  clk_out: out std_logic

);
end clockfile;

architecture behav of clockfile is

begin

  process (clk_in) is
  begin
    if (wd = "00" and clk_in = '1') then
      clk_out <= clk_in;
    else
      clk_out <= '0';
    end if;

    if (clk_in = '1') then
      rd <= wd;
    end if;
  end process;

end behav;

