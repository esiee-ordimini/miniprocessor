library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
port (
	clk 			: in std_logic;
	resetn 			: in std_logic;
	mem_q 			: in std_logic_vector(23 downto 0);
	mem_data 		: out std_logic_vector(23 downto 0);
	mem_address 		: out std_logic_vector(15 downto 0);
	sel_next_pc 		: in std_logic_vector(1 downto 0);
	sel_next_ir 		: in std_logic;
	sel_next_r0 		: in std_logic_vector(3 downto 0);
	sel_next_r1 		: in std_logic_vector(1 downto 0);
	sel_next_r3 		: in std_logic_vector(2 downto 0);
	sel_address 		: in std_logic;
	sel_status 		: in std_logic;
	status_send 		: out std_logic_vector(1 downto 0);
	opcode 			: out std_logic_vector(7 downto 0);
	ir 			: out std_logic_vector(23 downto 0)
);
end entity;
architecture rtl of datapath is

	-----------------------------------------------------------------
	-- Signaux sans le registre
	-----------------------------------------------------------------
	signal param : std_logic_vector(15 downto 0);

	-----------------------------------------------------------------
	-- Signaux avant le registre
	-----------------------------------------------------------------
	signal r0_next 		: std_logic_vector(23 downto 0);
	signal r1_next 		: std_logic_vector(23 downto 0);
	signal r3_next 		: std_logic_vector(23 downto 0);
	signal pc_next 		: std_logic_vector(15 downto 0);
	signal ir_next 		: std_logic_vector(23 downto 0);
	signal status_next 	: std_logic_vector(1 downto 0);

	-----------------------------------------------------------------
	-- Signaux apres le registre
	-----------------------------------------------------------------
	signal r0_reg 		: std_logic_vector(23 downto 0);
	signal r1_reg 		: std_logic_vector(23 downto 0);
	signal r3_reg 		: std_logic_vector(23 downto 0);
	signal pc_reg 		: std_logic_vector(15 downto 0);
	signal ir_reg 		: std_logic_vector(23 downto 0);
	signal status_reg 	: std_logic_vector(1 downto 0);
	
begin

	-----------------------------------------------------------------
	-- Action réaliser sur le registre R0
	-----------------------------------------------------------------
	r0_next <= r0_reg when sel_next_r0 = "0000"
		else mem_q when sel_next_r0 = "0001"
		else "00000000"&param when sel_next_r0 = "0010"
		else std_logic_vector(unsigned(r0_reg) - unsigned(r3_reg)) when sel_next_r0 = "0011"
		else r0_reg and r3_reg when sel_next_r0 = "0100"
		else '0'&r0_reg(23 downto 1) when sel_next_r0 = "0101"
		else std_logic_vector(unsigned(r0_reg) + unsigned(r0_reg)) when sel_next_r0 = "0110"
		else std_logic_vector(unsigned(r0_reg) + unsigned(r3_reg)) when sel_next_r0 = "0111"
		else std_logic_vector(unsigned(r0_reg) + unsigned(param)) when sel_next_r0 = "1000"
		else (others => '1');

	-----------------------------------------------------------------
	-- Action réaliser sur le registre R3
	-----------------------------------------------------------------
	r3_next <= r3_reg when sel_next_r3 = "000"
		else mem_q when sel_next_r3 = "001"
		else ir_reg when sel_next_r3 = "010"
		else r0_reg when sel_next_r3 = "011"
		else (others => '1');

	-----------------------------------------------------------------
	-- Action réaliser sur le registre R1
	-----------------------------------------------------------------
	r1_next <= r1_reg when sel_next_r1 ="00"
		else ir_reg when sel_next_r1 ="01"
		else std_logic_vector(unsigned(r1_reg) + unsigned(r0_reg)) when sel_next_r1 ="10"
		else (others => '1');

	-----------------------------------------------------------------
	-- Action réaliser sur le registre PC 
	-----------------------------------------------------------------
	pc_next <= pc_reg when sel_next_pc="00"
		else std_logic_vector(unsigned(pc_reg)+1) when sel_next_pc ="01"
		else param when sel_next_pc ="10"
		else (others => '1');

	-----------------------------------------------------------------
	-- Action réaliser sur le registre IR
	-----------------------------------------------------------------
	ir_next <= ir_reg when sel_next_ir ='0'
		else mem_q ;

	-----------------------------------------------------------------
	-- Action réaliser sur le status pour comparar des nombres
	-----------------------------------------------------------------
	status_next(0) <= status_reg(0) when sel_status = '0'
		else '1' when (unsigned(r0_reg(15 downto 0)) - unsigned(r3_reg(15 downto 0))) = 0
		else '0';
	status_next(1) <= status_reg(1) when sel_status = '0'
		else '1' when (signed('0'&r0_reg(15 downto 0)) - signed('0'&r3_reg(15 downto 0))) < 0
		else '0';
	

	-----------------------------------------------------------------
	-- Action réaliser sur le l'address envoyer a la mémoire
	-----------------------------------------------------------------
	mem_address <= r1_reg(15 downto 0 ) when sel_address = '1'
		else pc_reg ;

	-----------------------------------------------------------------
	-- Action réaliser sur les différents signaux
	-----------------------------------------------------------------
	mem_data <= r0_reg ;
	status_send <= status_reg;
	param <= ir_reg(15 downto 0 );
	opcode <= ir_reg(23 downto 16);
	ir <= ir_reg;
	
	-----------------------------------------------------------------
	-- Registre pour cadencer les signaux sur les tic du clk
	-----------------------------------------------------------------
	process(clk, resetn) is
	begin
		if resetn <= '0' then
			r0_reg <= (others => '0');
			r1_reg <= (others => '0');
			r3_reg <= (others => '0');
			pc_reg <= (others => '0');
			ir_reg <= (others => '0');
			status_reg <= (others => '0');
		elsif rising_edge(clk) then
			r0_reg <= r0_next;
			r1_reg <= r1_next;
			r3_reg <= r3_next;
			pc_reg <= pc_next;
			ir_reg <= ir_next;
			status_reg <= status_next;
		end if;
	end process;

end architecture;




