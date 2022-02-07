library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity random is
port (
	clk 					: in std_logic;
	resetn 					: in std_logic;
	seed					: in std_logic_vector(8 downto 0);
	cmd_random				: in std_logic;
	result					: out std_logic_vector(8 downto 0)
);
end entity;
architecture rtl of random is

	-----------------------------------------------------------------
	-- Signaux avant le registre
	-----------------------------------------------------------------
	signal Q0_next 				: std_logic;
	signal Q1_next 				: std_logic;
	signal Q2_next 				: std_logic;
	signal Q3_next 				: std_logic;
	signal Q4_next 				: std_logic;
	signal Q5_next 				: std_logic;
	signal Q6_next 				: std_logic;
	signal Q7_next 				: std_logic;
	signal Q8_next 				: std_logic;

	-----------------------------------------------------------------
	-- Signaux apres le registre
	-----------------------------------------------------------------
	signal Q0_reg 				: std_logic;
	signal Q1_reg  				: std_logic;
	signal Q2_reg  				: std_logic;
	signal Q3_reg 				: std_logic;
	signal Q4_reg 				: std_logic;
	signal Q5_reg  				: std_logic;
	signal Q6_reg  				: std_logic;
	signal Q7_reg  				: std_logic;
	signal Q8_reg 				: std_logic;

	
begin

	Q0_next <= seed(0) when cmd_random = '1'
			else Q8_reg;
			
	Q1_next <= seed(1) when cmd_random = '1'
			else Q0_reg;
			
	Q2_next <= seed(2) when cmd_random = '1'
			else Q1_reg ;
			
	Q3_next <= seed(3) when cmd_random = '1'
			else Q2_reg;
			
	Q4_next <= seed(4) when cmd_random = '1'
			else Q3_reg xor Q8_reg;
			
	Q5_next <= seed(5) when cmd_random = '1'
			else Q4_reg;
			
	Q6_next <= seed(6) when cmd_random = '1'
			else Q5_reg;
			
	Q7_next <= seed(7) when cmd_random = '1'
			else Q6_reg;
			
	Q8_next <= seed(7) when cmd_random = '1'
			else Q7_reg;

	result <= Q0_reg&Q1_reg&Q2_reg&Q3_reg&Q4_reg&Q5_reg&Q6_reg&Q7_reg&Q8_reg;
	
	-----------------------------------------------------------------
	-- Registre pour cadencer les signaux sur les tic du clk
	-----------------------------------------------------------------
	process(clk, resetn) is
	begin
		if resetn <= '0' then
			Q0_reg <= '0';
			Q1_reg <= '0';
			Q2_reg <= '0';
			Q3_reg <= '0';
			Q4_reg <= '0';
			Q5_reg <= '0';
			Q6_reg <= '0';
			Q7_reg <= '0';
			Q8_reg <= '0';

		elsif rising_edge(clk) then
			Q0_reg <= Q0_next;
			Q1_reg <= Q1_next;
			Q2_reg <= Q2_next;
			Q3_reg <= Q3_next;
			Q4_reg <= Q4_next;
			Q5_reg <= Q5_next;
			Q6_reg <= Q6_next;
			Q7_reg <= Q7_next;
			Q8_reg <= Q8_next;
		end if;
	end process;

end architecture;




