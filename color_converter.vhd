library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity color_converter is
	port (
		r_in : in std_logic_vector(1 downto 0);
		g_in : in std_logic_vector(2 downto 0);
		b_in : in std_logic_vector(2 downto 0);
		
		r_out : out std_logic_vector(4 downto 0);
		g_out : out std_logic_vector(5 downto 0);
		b_out : out std_logic_vector(4 downto 0)
	);
end entity;

architecture rtl of color_converter is
	signal r : std_logic_vector(4 downto 0);
	signal g : std_logic_vector(6 downto 0);
	signal b : std_logic_vector(5 downto 0);
begin
	r <= '0'&std_logic_vector(unsigned(r_in)*10);
	g <= '0'&std_logic_vector(unsigned(g_in)*9);
	b <= std_logic_vector(unsigned(b_in)*4);
	
	r_out <= r(4 downto 0);
	g_out <= g(5 downto 0);
	b_out <= b(4 downto 0);
end architecture;