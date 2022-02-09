library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
port (
	clk				: in std_logic;
	sw					: in std_logic_vector(8 downto 0);
	key				: in std_logic_vector(3 downto 0);
	joystick			: in std_logic_vector(3 downto 0);	
	resetn	 		: in std_logic;

	-----------------------------------------------------------------
	-- Signaux responsable des afficheurs 7 segments et leds
	-----------------------------------------------------------------	
	hex0				: out std_logic_vector(6 downto 0);
	hex1				: out std_logic_vector(6 downto 0);
	hex2				: out std_logic_vector(6 downto 0);
	hex3				: out std_logic_vector(6 downto 0);
	hex4				: out std_logic_vector(6 downto 0);
	hex5				: out std_logic_vector(6 downto 0);
	ledr				: out std_logic_vector(9 downto 0);

	-----------------------------------------------------------------
	-- Signaux responsable du controle de l'ecran 
	-----------------------------------------------------------------	 
	lt24_reset_n			: out std_logic;
	lt24_cs_n   			: out std_logic;
	lt24_rs     			: out std_logic;
	lt24_rd_n   			: out std_logic;
	lt24_wr_n   			: out std_logic;
	lt24_d      			: out std_logic_vector(15 downto 0);
	lt24_lcd_on 			: out std_logic

);
end entity;

architecture rtl of top is

	-----------------------------------------------------------------
	-- Signaux responsable de la memoire double 
	-----------------------------------------------------------------
	signal mem_q 					: std_logic_vector (23 downto 0) ;
	signal mem_q_debug 			: std_logic_vector (23 downto 0) ;
	signal mem_address 			: std_logic_vector(15 downto 0 );
	signal mem_address_debug 	: std_logic_vector(12 downto 0 );
	signal mem_data 				: std_logic_vector(23 downto 0);
	signal mem_wren 				: std_logic;

	-----------------------------------------------------------------
	-- Signaux responsable de la memoire ecran
	-----------------------------------------------------------------
	signal mem_ecran_address_1	: STD_LOGIC_VECTOR (8 DOWNTO 0);
	signal mem_ecran_address_2	: STD_LOGIC_VECTOR (8 DOWNTO 0);
	signal mem_ecran_wren		: STD_LOGIC ;
	signal mem_ecran_q  			: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal mem_ecran_data 		: std_logic_vector(7 downto 0);

	-----------------------------------------------------------------
	-- Signaux responsable de la fsm pour le datapath
	-----------------------------------------------------------------
	signal sel_next_pc 			: std_logic_vector(1 downto 0 );
	signal sel_next_ir 			: std_logic;
	signal sel_next_r0 			: std_logic_vector (3 downto 0);
	signal sel_next_r1			: std_logic_vector(1 downto 0 );
	signal sel_next_r3			: std_logic_vector (2 downto 0);
	signal sel_address 			: std_logic;
	signal sel_status 			: std_logic;
	signal status 					: std_logic_vector(1 downto 0);
	signal opcode 					: std_logic_vector(7 downto 0);
	signal state 					: std_logic_vector(7 downto 0);
	signal ir 						: std_logic_vector(23 downto 0);
	signal wren 					: std_logic;
	signal cmd_cmp 				: std_logic;
	signal address_inter			: std_logic_vector(9 downto 0);
	signal q 						: std_logic_vector (23 downto 0);
	signal end_tempo				: std_logic;
	signal pb 						: std_logic_vector (3 downto 0);

	-----------------------------------------------------------------
	-- Signaux responsable de l'affichage 7 segments et leds
	-----------------------------------------------------------------
	signal affichage 				: std_logic_vector(23 downto 0);
	signal ledr_reg 				: std_logic_vector(9 downto 0);
	signal ledr_next 				: std_logic_vector(9 downto 0);
	
	-----------------------------------------------------------------
	-- Signaux responsable de l'ecran
	-----------------------------------------------------------------
	signal x    					: std_logic_vector(7 downto 0);-- 0 .. 239 => 8 bits
	signal y    					: std_logic_vector(8 downto 0);-- 0 .. 319 => 9 bits
	signal c    					: std_logic_vector(15 downto 0);-- couleurs 16 bits

	-----------------------------------------------------------------
	-- Signaux responsable du random
	-----------------------------------------------------------------
	signal seed    				:  std_logic_vector(8 downto 0);
	signal cmd_random    		:  std_logic := '0';
	signal result    				:  std_logic_vector(8 downto 0);
	
	-----------------------------------------------------------------
	-- Signaux responsable du random
	-----------------------------------------------------------------
	signal data_in    			:  std_logic_vector(8 downto 0);
	signal data_out    			:  std_logic_vector(11 downto 0);

begin
	

	-----------------------------------------------------------------
	-- Valeur signaux de base
	-----------------------------------------------------------------	
	pb <= not key;
	data_in <= mem_data(8 downto 0) when mem_address(15 downto 14) = "10" and mem_address(0) = '1';

	-----------------------------------------------------------------
	-- Valeur signaux affichage
	-----------------------------------------------------------------	
	affichage <= ir when sw(7) = '1' and sw(8) = '1'
		else X"0000"&state when sw(7) = '1' and sw(8) = '1'
		else mem_q_debug when  sw(8) = '1'
		else mem_data when  mem_address(15 downto 14) = "10" and mem_address(0)='0'
		else "000000000000"&data_out when sw(0)='1' 
		else mem_q;
	
	ledr <= ledr_reg;
	ledr_next <= "000000"&joystick;
	--mem_data(9 downto 0) when  mem_address(15 downto 14) = "10" and wren='1' and mem_address(0)='0'
	--	else ledr_reg;
	
	-----------------------------------------------------------------
	-- Valeur signaux memoire 
	-----------------------------------------------------------------	
	q <= "000000000000"&"00000000"&(not joystick) when mem_address(15 downto 14) = "10" and mem_address(0) = '0'
		else "000000000000000"&std_logic_vector(unsigned(result)-1)when mem_address(15 downto 14) = "11" 
		else mem_q;
	mem_address_debug <= "00000"&sw(7 downto 0) when sw(8) = '1'
		else (others => '0');
	mem_wren <= wren when mem_address(15 downto 14) = "00" 
		else '0' ;

	-----------------------------------------------------------------
	-- Valeur signaux memoire ecran
	-----------------------------------------------------------------
	mem_ecran_data <= mem_data(7 downto 0);
	mem_ecran_address_1 <= mem_address(8 downto 0);
	address_inter<= std_logic_vector(unsigned(y(8 downto 4))*15 + unsigned(x(7 downto 4)));
	mem_ecran_address_2 <= address_inter(8 downto 0);
	mem_ecran_wren <= '1' when mem_address(15 downto 14) = "01" 
		else '0';

	-----------------------------------------------------------------
	-- Valeur signaux couleur
	-----------------------------------------------------------------
	c(0)  <= mem_ecran_q(0);
	c(1)  <= mem_ecran_q(1); c(2)  <= mem_ecran_q(1); c(3)  <= mem_ecran_q(1); c(4)  <= mem_ecran_q(1);
	c(5)  <= mem_ecran_q(2);
	c(6)  <= mem_ecran_q(3);
	c(7)  <= mem_ecran_q(4);
	c(8)  <= mem_ecran_q(5); c(9)  <= mem_ecran_q(5); c(10) <= mem_ecran_q(5);
	c(11) <= mem_ecran_q(6);
	c(12) <= mem_ecran_q(7); c(13) <= mem_ecran_q(7); c(14) <= mem_ecran_q(7); c(15) <= mem_ecran_q(7);
	
	-----------------------------------------------------------------
	-- Appelle du fichier datapath
	-----------------------------------------------------------------
	prog : entity work.datapath
	port map(
		clk => clk,
		resetn => resetn,
		mem_q => q,
		mem_data => mem_data,
		sel_next_pc => sel_next_pc,
		sel_next_ir => sel_next_ir,
		sel_next_r0 => sel_next_r0,
		sel_next_r1 => sel_next_r1,
		sel_next_r3 => sel_next_r3,
		sel_address => sel_address,
		sel_status => sel_status,
		status_send => status,
		mem_address => mem_address,
		opcode => opcode,
		cmd_cmp => cmd_cmp,
		end_tempo => end_tempo,
		ir => ir
	);

	-----------------------------------------------------------------
	-- Appelle du fichier memoire_double
	-----------------------------------------------------------------
	memoire : entity work.memoire_double
	port map(
		address_a	=> mem_address(12 downto 0),
		address_b	=> mem_address_debug,
		clock		=> clk,
		data_a		=> mem_data,
		data_b		=> (others => '0'),
		wren_a		=> mem_wren,
		wren_b		=> '0',
		q_a		=> mem_q,
		q_b		=> mem_q_debug
	);

	-----------------------------------------------------------------
	-- Appelle du fichier fsm
	-----------------------------------------------------------------
	fsm : entity work.fsm
	port map(
		clk => clk,
		resetn => resetn,
		sel_pc_next => sel_next_pc,
		sel_ir_next => sel_next_ir,
		sel_r0_next => sel_next_r0,
		sel_r1_next => sel_next_r1,
		sel_r3_next => sel_next_r3,
		wren => wren,
		sel_address => sel_address,
		sel_status => sel_status,
		status => status,
		OPCODE => opcode,
		cmd_cmp => cmd_cmp,
		end_tempo => end_tempo,
		state_out => state
	);

	-----------------------------------------------------------------
	-- Appelle du fichier decoder_affichage
	-----------------------------------------------------------------
	decoder : entity work.decoder_affichage
	port map(
		affichage	=> affichage,
		hex0  	=> hex0,
		hex1  	=> hex1,
		hex2  	=> hex2,
		hex3  	=> hex3,
		hex4  	=> hex4,
		hex5  	=> hex5
	);
	
	-----------------------------------------------------------------
	-- Appelle du fichier memoire_ecran
	-----------------------------------------------------------------
	memoire_ecran : entity work.memoire_ecran
	port map(
		address_a	=>	mem_ecran_address_1,
		address_b	=>	mem_ecran_address_2,	
		clock			=>	clk,
		data_a		=>	mem_ecran_data,
		data_b		=>	"00000000",
		wren_a		=>	mem_ecran_wren,
		wren_b   	=>	'0',
		q_a	   	=>	open,
		q_b	   	=>	mem_ecran_q
	);
	
	-----------------------------------------------------------------
	-- Appelle du fichier It24ctrl (controle de l'ecran)
	-----------------------------------------------------------------
	ctrl : entity work.lt24ctrl
	port map(
		clk			=> clk,
		resetn			=> resetn,
		x			=> x,
		y			=> y,
		c			=> c,
		lt24_reset_n		=> lt24_reset_n,
		lt24_cs_n		=> lt24_cs_n,
		lt24_rs			=> lt24_rs,
		lt24_rd_n		=> lt24_rd_n,
		lt24_wr_n		=> lt24_wr_n,
		lt24_d			=> lt24_d,
		lt24_lcd_on		=> lt24_lcd_on
	);

	-----------------------------------------------------------------
	-- Appelle du fichier Random
	-----------------------------------------------------------------
	random : entity work.random
	port map(
		clk				=> clk,
		resetn			=> resetn,
		seed				=> seed,
		result			=> result,
		cmd_random		=> cmd_random
	);
	
	-----------------------------------------------------------------
	-- Appelle du fichier convertisseur bin2bcd
	-----------------------------------------------------------------
	bin2bcd : entity work.bin2bcd
   generic map (N => 9)
   port map (
     data_in  => data_in,
     data_out => data_out
   );
	
	-----------------------------------------------------------------
	-- Registre pour les leds
	-----------------------------------------------------------------
	process(clk, resetn) is
	begin
		if resetn <= '0' then
			ledr_reg <= (others => '0');
		elsif rising_edge(clk) then
			ledr_reg <= ledr_next;
		end if;
	end process;
end architecture;
