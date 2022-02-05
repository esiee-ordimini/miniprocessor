library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder_affichage is
port (
	-----------------------------------------------------------------
	-- Signaux d'affichage
	-----------------------------------------------------------------
	affichage 		: in std_logic_vector(23 downto 0 );
	hex0			: out std_logic_vector(6 downto 0);
	hex1			: out std_logic_vector(6 downto 0);
	hex2			: out std_logic_vector(6 downto 0);
	hex3			: out std_logic_vector(6 downto 0);
	hex4			: out std_logic_vector(6 downto 0);
	hex5			: out std_logic_vector(6 downto 0);
	ledr			: out std_logic_vector(8 downto 0)
);
end entity;

architecture rtl of decoder_affichage is
begin
	-----------------------------------------------------------------
	-- Appelle de chaque decoder
	-----------------------------------------------------------------

	decoder0 : entity work.seven_segment_decoder
	port map(
			hexa		=> affichage(3 downto 0),
			abcdefg  => hex0
	);

	decoder1 : entity work.seven_segment_decoder
	port map(
			hexa		=> affichage(7 downto 4),
			abcdefg  => hex1
	);

	decoder2 : entity work.seven_segment_decoder
	port map(
			hexa		=> affichage(11 downto 8),
			abcdefg  => hex2
	);

	decoder3 : entity work.seven_segment_decoder
	port map(
			hexa		=> affichage(15 downto 12),
			abcdefg  => hex3
	);

	decoder4 : entity work.seven_segment_decoder
	port map(
			hexa		=> affichage(19 downto 16),
			abcdefg  => hex4
	);

	decoder5 : entity work.seven_segment_decoder
	port map(
			hexa		=> affichage(23 downto 20),
			abcdefg  => hex5
	);
	
end architecture;