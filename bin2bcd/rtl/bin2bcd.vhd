----------------------------------------
--    binary => BCD                   --
----------------------------------------
-- Creation : A. Exertier, 19/12/2014
-- Modification : 07/2017, A. Exertier
----------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity bin2BCD is
  generic (N : positive := 32);
  port (
    data_in  : in  std_logic_vector( N-1 downto 0);
    data_out : out std_logic_vector( 4*integer(ceil(real(N)*log10(2.0)))-1 downto 0)
  );
end entity;

architecture rtl of bin2BCD is
begin
  process (data_in) is
    variable tmp : unsigned(data_out'range);	  
  begin
    tmp := (others => '0');
	for i in data_in'range loop	    
	  --tmp := tmp(tmp'high -1 downto tmp'low)&data_in(i);   
	  for j in 0 to tmp'length/4-1 loop
	    if tmp(4*j+3 downto 4*j) >= 5 then  
	      tmp(4*j+3 downto 4*j) := tmp(4*j+3 downto 4*j)+3; 
	    end if;	
	  end loop;
	  tmp := tmp(tmp'high -1 downto tmp'low)&data_in(i);  
	end loop;
	data_out <= std_logic_vector(tmp); 
  end process;
end architecture;
	
