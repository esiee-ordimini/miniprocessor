-------------------------------------------
-- decodeur 7 segments
-------------------------------------------
-- ESIEE
-- Creation     : A. Exertier, 11/2004
-- Modification : A. Exertier, 08/2008
-------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
---------------------------------------------------
--               Entrees
---------------------------------------------------
-- hexa 	    : entree code hexadacimal (4 bits)
---------------------------------------------------
--             sorties
---------------------------------------------------
--		a : segment horizontal superieur
--		b : segment vertical superieur droit
--		c : segment vertical inferieur droit
--		d : segment horizontal inferieur
--		e : segment vertical indefieur gauche
--		f : segment vertical superieur gauche
--		g : segment horizontal milieu
---------------------------------------------------
entity seven_segment_decoder  is
  port (
        hexa : in  std_logic_vector(3 downto 0);
			abcdefg : out std_logic_vector(6 downto 0)
        );
end ;

----------------------------------------------------------------------
architecture RTL of  seven_segment_decoder is
	signal i_abcdefg : std_logic_vector(6 downto 0);
begin

	abcdefg(6) <= i_abcdefg(0);
	abcdefg(5) <= i_abcdefg(1);
	abcdefg(4) <= i_abcdefg(2);
	abcdefg(3) <= i_abcdefg(3);
	abcdefg(2) <= i_abcdefg(4);
	abcdefg(1) <= i_abcdefg(5);
	abcdefg(0) <= i_abcdefg(6);

 process(hexa)
 begin
  case hexa is
    when "0000" => i_abcdefg <= "0000001";  -- 0
    when "0001" => i_abcdefg <= "1001111";  -- 1
    when "0010" => i_abcdefg <= "0010010";  -- 2
    when "0011" => i_abcdefg <= "0000110";  -- 3
    when "0100" => i_abcdefg <= "1001100";  -- 4
    when "0101" => i_abcdefg <= "0100100";  -- 5
    when "0110" => i_abcdefg <= "0100000";  -- 6
    when "0111" => i_abcdefg <= "0001111";  -- 7
    when "1000" => i_abcdefg <= "0000000";  -- 8
    when "1001" => i_abcdefg <= "0000100";  -- 9
    when "1010" => i_abcdefg <= "0001000";  -- A
    when "1011" => i_abcdefg <= "1100000";  -- B
    when "1100" => i_abcdefg <= "0110001";  -- C
    when "1101" => i_abcdefg <= "1000010";  -- D
    when "1110" => i_abcdefg <= "0110000";  -- E
    when "1111" => i_abcdefg <= "0111000";  -- F
    when others => i_abcdefg <= "1111111";
  end case;
 end process;
end ;