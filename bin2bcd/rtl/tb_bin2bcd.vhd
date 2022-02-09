----------------------------------------
--    binary => BCD                   --
----------------------------------------
-- Creation : A. Exertier, 19/12/2014
----------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_bin2bcd is
end entity;

architecture testbench of tb_bin2bcd is
  constant hp         : time := 5 ns;
  constant per        : time := 2*hp;
  constant N          : positive := 9;
  constant Nd         : positive := integer(ceil(log10(real(2**N-1))));
  
  signal data	      : std_logic_vector(8 downto 0);
  signal data_in      : std_logic_vector( N-1 downto 0);
  signal data_out     : std_logic_vector( 4*Nd -1 downto 0);
  signal data_verif   : natural;

begin

	data_in <= "000001111";
  
  dut : entity work.bin2bcd
    generic map (N => N)
    port map (
      data_in  => data_in,
      data_out => data_out
    );
 
end architecture;
	