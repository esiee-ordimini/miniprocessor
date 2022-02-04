library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	port (
		clk: in std_logic;
		sw: in std_logic_vector(9 downto 0);
		resetn: in std_logic;
		debug: in std_logic;
		hex0: out std_logic_vector(6 downto 0);
		hex1: out std_logic_vector(6 downto 0);
		hex2: out std_logic_vector(6 downto 0);
		hex3: out std_logic_vector(6 downto 0);
		hex4: out std_logic_vector(6 downto 0);
		hex5: out std_logic_vector(6 downto 0);
		ledr: out std_logic_vector(8 downto 0);
	 
		lt24_reset_n: out std_logic;
		lt24_cs_n   : out std_logic;
		lt24_rs     : out std_logic;
		lt24_rd_n   : out std_logic;
		lt24_wr_n   : out std_logic;
		lt24_d      : out std_logic_vector(15 downto 0);
		lt24_lcd_on : out std_logic
	);
end entity;

architecture rtl of top is
	signal mem_q : std_logic_vector (23 downto 0) ;
	signal gel :std_logic ; 
	signal gel_valide :std_logic ; 
	signal mem_address : std_logic_vector(15 downto 0 );
	signal mem_address_send : std_logic_vector(15 downto 0 );
	signal mem_data : std_logic_vector(23 downto 0);
	signal mem_wren : std_logic;
	signal mem_wren_send : std_logic;
	signal sel_next_pc : std_logic_vector(1 downto 0 );
	signal sel_next_ir : std_logic;
	signal sel_next_r0 : std_logic_vector (3 downto 0);
	signal sel_next_r1 : std_logic_vector(1 downto 0 );
	signal sel_next_r3 : std_logic_vector (2 downto 0);
	signal sel_address : std_logic;
	signal sel_status : std_logic;
	signal readmem : std_logic;
	signal status : std_logic_vector(1 downto 0 ) ;
	signal opcode : std_logic_vector (7 downto 0) ;
	signal affichage : std_logic_vector(23 downto 0);
	
	
	signal state : std_logic_vector(7 downto 0);
	signal ir : std_logic_vector(23 downto 0);
	
	signal sel_ir_send : std_logic;
	
	signal address_1		: STD_LOGIC_VECTOR (8 DOWNTO 0);
	signal address_2		: STD_LOGIC_VECTOR (8 DOWNTO 0);
	signal wren_1		: STD_LOGIC  := '0';
	signal q_2  		: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	signal x    :  std_logic_vector(7 downto 0);    -- 0 .. 239 => 8 bits
	signal y    :  std_logic_vector(8 downto 0);    -- 0 .. 319 => 9 bits
	signal c    :  std_logic_vector(15 downto 0);   -- couleurs 16 bits

	signal address_inter : std_logic_vector(9 downto 0);
begin

	gel <= not debug;
	
	ledr(7 downto 0) <= mem_address_send(7 downto 0);
	
	ledr(8) <= sel_next_ir;

	gel_valide <= '1' when gel = '1' and readmem = '0'
		else '0';

	mem_wren_send <= '0' when mem_address(9)='1'
		else mem_wren;
		
	wren_1 <= '0' when mem_address(9)='0'
		else mem_wren;

	mem_address_send <= "00000000"&sw(7 downto 0) when gel_valide = '1'
		else mem_address;
		
		
	affichage <= ir when sw(9) = '1'
		else X"0000"&state when sw(8) = '1'
		else mem_q;
		
	sel_ir_send <= sel_next_ir when gel= '0' else '0';
	
	address_1 <= mem_address(8 downto 0);
	
	address_inter<= std_logic_vector(unsigned(y(8 downto 4))*15 + unsigned(x(7 downto 4)));

	address_2 <= address_inter(8 downto 0);
	
	
	c(0) <= q_2(0);
	c(1) <= q_2(1);
	c(2) <= q_2(1);
	c(3) <= q_2(1);
	c(4) <= q_2(1);
	c(5) <= q_2(2);
	c(6) <= q_2(3);
	c(7) <= q_2(4);
	c(8) <= q_2(5);
	c(9) <= q_2(5);
	c(10) <= q_2(5);
	c(11) <= q_2(6);
	c(12) <= q_2(7);
	c(13) <= q_2(7);
	c(14) <= q_2(7);
	c(15) <= q_2(7);
	

	prog : entity work.datapath
	port map(
		clk => clk,
		resetn => resetn,
		mem_q => mem_q,
		mem_data => mem_data,
		sel_next_pc => sel_next_pc,
		sel_next_ir => sel_ir_send,
		sel_next_r0 => sel_next_r0,
		sel_next_r1 => sel_next_r1,
		sel_next_r3 => sel_next_r3,
		sel_address => sel_address,
		sel_status => sel_status,
		status_send => status,
		mem_address => mem_address,
		opcode => opcode,
		gel => gel_valide,
		ir => ir
	);

	memoire : entity work.memoire
	port map(
		address	=> mem_address_send(7 downto 0),
		clock		=> clk,
		data		=> mem_data,
		wren		=> mem_wren_send,
		q		=> mem_q
	);
	
	fsm : entity work.fsm
	port map(
		clk => clk,
		resetn => resetn,
		sel_pc_next => sel_next_pc,
		sel_ir_next => sel_next_ir,
		sel_r0_next => sel_next_r0,
		sel_r1_next => sel_next_r1,
		sel_r3_next => sel_next_r3,
		mem_wren => mem_wren,
		sel_address => sel_address,
		sel_status => sel_status,
		status => status,
		OPCODE => opcode,
		readmem => readmem,
		gel => gel_valide,
		state_out => state
	);


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
	
	memoire2 : entity work.memoire_ecran
	port map(
		address_a	=>	address_1,
		address_b	=>	address_2,	
		clock			=>	clk,
		data_a		=>	mem_data(7 downto 0),
		data_b		=>	"00000000",
		wren_a		=>	wren_1,
		wren_b   	=>	'0',
		q_a	   	=>	open,
		q_b	   	=>	q_2
	);
	
	
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
end architecture;