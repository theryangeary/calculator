library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity clockfile_tb is
  end clockfile_tb;

architecture behav of clockfile_tb is
  --  Declaration of the component that will be instantiated.
  component clockfile
    port (
           rd: out std_logic_vector(1 downto 0);
           wd: in std_logic_vector(1 downto 0);
           clk_in: in std_logic;
           clk_out: out std_logic

  ); -- output the current register content
  end component;
  --  Specifies which entity is bound with the component.
  -- for shift_reg_0: clockfile use entity work.clockfile(rtl);
  signal rd: std_logic_vector(1 downto 0);
  signal wd: std_logic_vector(1 downto 0);
  signal clk_in: std_logic;
  signal clk_out: std_logic;
begin
  --  Component instantiation.
  clockfile_0: clockfile
  port map (
    rd => rd,
    wd => wd,
    clk_in => clk_in,
    clk_out => clk_out
  );

  --  This process does the real job.
  process
  type pattern_type is record
    wd: std_logic_vector(1 downto 0);
    clk_in: std_logic;
    clk_out: std_logic;
    rd: std_logic_vector(1 downto 0);
  end record;
  --  The patterns to apply.
  type pattern_array is array (natural range <>) of pattern_type;
  constant patterns : pattern_array := (
  --wd    in  out rd
  ("00", '0', '0', "00"),
  ("00", '1', '1', "00"),
  ("10", '0', '0', "00"),
  ("10", '1', '0', "10"),
  ("10", '0', '0', "10"),
  ("10", '1', '0', "10")
);
  begin
    --  Check each pattern.
    for n in patterns'range loop
      --  Set the inputs.
      wd <= patterns(n).wd;
      clk_in <= patterns(n).clk_in;
      --  Wait for the results.
      wait for 1 ns;
      --  Check the outputs.
      assert rd = patterns(n).rd
      report "bad rd1 value" severity error;
      assert clk_out = patterns(n).clk_out
      report "bad rd2 value" severity error;
    end loop;
    assert false report "end of test" severity note;
    --  Wait forever; this will finish the simulation.
    wait;
  end process;
end behav;
