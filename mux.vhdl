library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
generic (
  N : integer:= 2;
  INLENGTH : integer:= 8); --Number of bits in select
port(
      A: in std_logic_vector(INLENGTH-1 downto 0);
      B: in std_logic_vector(INLENGTH-1 downto 0);
      C: in std_logic_vector(INLENGTH-1 downto 0);
      D: in std_logic_vector(INLENGTH-1 downto 0);
      --I:  in std_logic_vector (INLENGTH*2**N-1 downto 0); -- for loading
      sel: in std_logic_vector(N-1 downto 0); -- Choose input
      O:  out std_logic_vector(INLENGTH-1 downto 0)); -- output the current register content
end mux;

architecture behav of mux is
  signal I: std_logic_vector (INLENGTH*2**N-1 downto 0); -- for loading
begin
  I <= D & C & B & A;
  O <= I((to_integer(unsigned(sel))+1)*INLENGTH -1 downto to_integer(unsigned(sel))*INLENGTH);
end behav;

