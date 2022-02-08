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
  constant N          : positive := 8;
  constant Nd         : positive := integer(ceil(log10(real(2**N-1))));
  
  type t_data is array (natural range<>) of natural;
  constant data       : t_data(1 to 6) := ( 174, 0,70, 253, 1 ,10);
  signal data_in      : std_logic_vector( N-1 downto 0);
  signal data_out     : std_logic_vector( 4*Nd -1 downto 0);
  signal data_verif   : natural;

begin

  stimuli : process is
  begin
    for i in data'range loop
      data_in <= std_logic_vector(to_unsigned(data(i),data_in'length));
      wait for per;
    end loop;
    wait;
  end process;
  
  dut : entity work.bin2bcd
    generic map (N => N)
    port map (
      data_in  => data_in,
      data_out => data_out
    );
 
  conv_bcd_bin : process(data_out)
    variable tmp : natural;
  begin 
    tmp := 0;
    for i in 0 to Nd-1 loop
      tmp := tmp + to_integer(unsigned(data_out(4*i+3 downto 4*i)))*(10**i);
    end loop;
    data_verif <= tmp;
  end process;
  
 verif :  process 
   variable ok : boolean := true;
 begin
   
   
   for i in data'range loop
     wait for hp;
     report "Test de " & integer'image(data(i)) & " | Resultat : " & integer'image(data_verif);
      if data(i) /= data_verif then 
        ok := false;
        report "erreur test";
      else 
        report "test ok";
      end if; 
      wait for hp;
    end loop;
    
    if ok then 
      report "all tests succeeded";
    else
      report "At least one test is unsuccessfull";
    end if;
    wait;
 end process;  
end architecture;
	