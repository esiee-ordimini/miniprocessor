library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
port (
	clk 						: in std_logic;
	resetn 					: in std_logic;
	seed						: in std_logic(8 downto 0);
	cmd_random				: in std_logic;
	result					: out std_logic_vector(8 downto 0);
);
end entity;
architecture rtl of datapath is

	-----------------------------------------------------------------
	-- Signaux avant le registre
	-----------------------------------------------------------------
	signal Q0_next 		: std_logic;
	signal Q1_next 		: std_logic;
	signal Q2_next 		: std_logic;
	signal Q3_next 		: std_logic;
	signal Q4_next 		: std_logic;
	signal Q5_next 		: std_logic;
	signal Q6_next 		: std_logic;
	signal Q7_next 		: std_logic;
	signal Q8_next 		: std_logic;

	-----------------------------------------------------------------
	-- Signaux apres le registre
	-----------------------------------------------------------------
	signal Q0_reg 			: std_logic;
	signal Q1_reg  		: std_logic;
	signal Q2_reg  		: std_logic;
	signal Q3_reg 			: std_logic;
	signal Q4_reg 			: std_logic;
	signal Q5_reg  		: std_logic;
	signal Q6_reg  		: std_logic;
	signal Q7_reg  		: std_logic;
	signal Q8_reg 			: std_logic;

	
begin

	Q0_next <= Q8_reg when cmd_random = '0'
			else seed(0);
			
	Q1_next <= Q0_reg when cmd_random = '0'
			else seed(1);
			
	Q2_next <= Q1_reg when cmd_random = '0'
			else seed(2);
			
	Q3_next <= Q2_reg when cmd_random = '0'
			else seed(3);
			
	Q4_next <= Q3_reg xor Q9_reg when cmd_random = '0'
			else seed(4);
			
	Q5_next <= Q4_reg when cmd_random = '0'
			else seed(5);
			
	Q6_next <= Q5_reg when cmd_random = '0'
			else seed(6);
			
	Q7_next <= Q6_reg when cmd_random = '0'
			else seed(7);
			
	Q8_next <= Q7_reg when cmd_random = '0'
			else seed(8);
	
	-----------------------------------------------------------------
	-- Registre pour cadencer les signaux sur les tic du clk
	-----------------------------------------------------------------
	process(clk, resetn) is
	begin
		if resetn <= '0' then
			Q0_reg <= (others => '0');
			Q1_reg <= (others => '0');
			Q2_reg <= (others => '0');
			Q3_reg <= (others => '0');
			Q4_reg <= (others => '0');
			Q5_reg <= (others => '0');
			Q6_reg <= (others => '0');
			Q7_reg <= (others => '0');
			Q8_reg <= (others => '0');

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




