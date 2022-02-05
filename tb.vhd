LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity tb is
end entity;

architecture testbench of tb is 

	-- déclaration signaux
	constant hp: 	time := 100 ns;
	signal clk:	STD_LOGIC  := '0';
	signal resetn :  std_logic;
	signal sw : std_logic_vector(9 downto 0);
	signal hex0:  std_logic_vector(6 downto 0);
	signal hex1:  std_logic_vector(6 downto 0);
	signal hex2:  std_logic_vector(6 downto 0);
	signal hex3:  std_logic_vector(6 downto 0);
	signal hex4:  std_logic_vector(6 downto 0);
	signal hex5:  std_logic_vector(6 downto 0);
	signal debug :  std_logic;

	signal lt24_reset_n: std_logic;
	signal lt24_cs_n   : std_logic;
	signal lt24_rs     : std_logic;
	signal lt24_rd_n   : std_logic;
	signal lt24_wr_n   : std_logic;
	signal lt24_d      : std_logic_vector(15 downto 0);
	signal lt24_lcd_on : std_logic;
begin
	clk<= not clk after hp;
	process is	
	begin
		sw <= "0000000000";
		resetn<= '0';  --initialisation active
		wait for 4*hp ;
		wait; 
       
	end process;

	dut: entity work.top
		port map(
			clk 	=>clk,
			resetn	=>resetn,
			sw 	=> sw,
			hex0	=> hex0,
			hex1	=> hex1,
			hex2	=> hex2,
			hex3	=> hex3,
			hex4	=> hex4,
			hex5	=> hex5,
			debug	=> debug,
			lt24_reset_n => lt24_reset_n,
			lt24_cs_n => lt24_cs_n,
			lt24_rs => lt24_rs,
			lt24_rd_n => lt24_rd_n,
			lt24_wr_n => lt24_wr_n,
			lt24_d => lt24_d,
			lt24_lcd_on => lt24_lcd_on
		);

	

end architecture;

	
