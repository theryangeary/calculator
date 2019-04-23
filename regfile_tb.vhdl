library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity regfile_tb is
  end regfile_tb;

architecture behav of regfile_tb is
  --  Declaration of the component that will be instantiated.
  component regfile
    port (
    rs1, rs2, ws: in std_logic_vector(1 downto 0);
    wd: in std_logic_vector(7 downto 0);
    WE: in std_logic;
    clk: in std_logic;

    rd1, rd2: out std_logic_vector(7 downto 0)
  ); -- output the current register content
  end component;
  --  Specifies which entity is bound with the component.
  -- for shift_reg_0: regfile use entity work.regfile(rtl);
  signal rs1, rs2, ws: std_logic_vector(1 downto 0);
  signal wd, rd1, rd2: std_logic_vector(7 downto 0);
  signal WE, clk: std_logic;
begin
  --  Component instantiation.
  regfile_0: regfile
  port map (
    rs1 => rs1,
    rs2 => rs2,
    ws => ws,
    wd => wd,
    WE => WE,
    clk => clk,
    rd1 => rd1,
    rd2 => rd2
  );

  --  This process does the real job.
  process
  type pattern_type is record
    rs1, rs2, ws: std_logic_vector(1 downto 0);
    wd: std_logic_vector(7 downto 0);
    WE: std_logic;
    clk: std_logic;
    rd1, rd2: std_logic_vector(7 downto 0);
  end record;
  --  The patterns to apply.
  type pattern_array is array (natural range <>) of pattern_type;
  constant patterns : pattern_array := (
  ("00", "00", "00", "00000000", '0', '0', "00000000", "00000000"),
  ("00", "00", "00", "00000000", '0', '0', "00000000", "00000000")
);
  begin
    --  Check each pattern.
    for n in patterns'range loop
      --  Set the inputs.
      rs1 <= patterns(n).rs1;
      rs2 <= patterns(n).rs2;
      ws  <= patterns(n).ws ;
      wd  <= patterns(n).wd ;
      WE  <= patterns(n).WE ;
      clk <= patterns(n).clk;
      --  Wait for the results.
      wait for 1 ns;
      --  Check the outputs.
      assert rd1 = patterns(n).rd1
      report "bad rd1 value" severity error;
      assert rd2 = patterns(n).rd2
      report "bad rd2 value" severity error;
    end loop;
    assert false report "end of test" severity note;
    --  Wait forever; this will finish the simulation.
    wait;
  end process;
end behav;
