library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is port(
	clk: in std_logic;
	resetn: in std_logic;
	opcode : in std_logic_vector(7 downto 0);
	status : in std_logic_vector(1 downto 0);

	sel_pc_next : out std_logic_vector(1 downto 0);
	sel_ir_next : out std_logic;	
	sel_r0_next : out std_logic_vector(3 downto 0);
	sel_r1_next : out std_logic_vector(1 downto 0);
	sel_r3_next : out std_logic_vector(2 downto 0);
	sel_status : out std_logic;
	sel_address : out std_logic;
	cmd_cmp : out std_logic;
	end_tempo : in std_logic;
	wren : out std_logic;
	state_out : out std_logic_vector(7 downto 0)
);
end entity;

architecture rtl of fsm is 

	-----------------------------------------------------------------
	-- Signaux correspondant a chaque etat
	-----------------------------------------------------------------
	type state is (
		Lit_Inst,
		Ecrit_IR,
		Decode_Inst,
		Ecrit_R1,
		Lit_MemR1,
		Ecrit_MemR1,
		Ecrit_R0,
		Incr_PC,
		Ecrit_R3,
		CMP_R0_R3,
		Sub_R0,
		AND_R0,
		B_JMP,
		Decalage_R0,
		MOV_R3,
		Double_R0,
		ADD_R0_R3,
		ADD_R0_1,
		MOV_R0, 
		Lit_MemR1_R3, 
		ADD_R1_R0, 
		Ecrit_R3_LDRB,
		Attendre,
		Multi
	);

	-----------------------------------------------------------------
	-- Signaux pour les �tats
	-----------------------------------------------------------------
	signal current_state : state;
	signal next_state : state;

	-----------------------------------------------------------------
	-- Signaux de comparaison
	-----------------------------------------------------------------
	signal opcode_value : unsigned(7 downto 0);
	signal status_N : std_logic;
	signal status_Z : std_logic;

begin

	-----------------------------------------------------------------
	-- D�finition des signaux locauxs
	-----------------------------------------------------------------
	status_N <= status(1);
	status_Z <= status(0);
	opcode_value <= unsigned(opcode);

	-----------------------------------------------------------------
	-- Registre pour changer d'etat a chaque frond montant
	-----------------------------------------------------------------
	process(clk, resetn) is
	begin
		if resetn <= '0' then
		current_state <= Lit_Inst;
		elsif rising_edge(clk) then
		current_state <= next_state;
	end if;
	end process;

	-----------------------------------------------------------------
	-- Process pour choisir l'etat
	-----------------------------------------------------------------
	process(current_state, opcode, opcode_value, status_N, status_Z,end_tempo) is
	begin
		next_state <= current_state;

		-- on definie toute nos valeur pour controler nos multiplexeur a 0
		sel_pc_next <= (others => '0');
		sel_ir_next <= '0';
		sel_r0_next <= (others => '0');
		sel_r1_next <= (others => '0');
		sel_r3_next <= (others => '0');
		sel_address <= '0';
		sel_status <= '0';
		cmd_cmp <= '1';
		wren <= '0';	
		state_out <= X"00";

	case current_state is

	--current state == Lit_Inst
	when Lit_Inst => 
		state_out <= X"01";
		next_state <= Ecrit_IR;

	--current state == Ecrit_IR
	when Ecrit_IR => 
		state_out <= X"02";
		next_state <= Decode_Inst;
		sel_ir_next <= '1';

	--current state == Decode_Inst
	when Decode_Inst =>
		state_out <= X"03";
		if opcode_value = x"01" then 
		next_state <= Ecrit_R1;
		elsif opcode_value = x"04" then
		next_state <= Lit_MemR1;
		elsif opcode_value = x"06" then
		next_state <= Ecrit_MemR1;
		elsif opcode_value = x"03" then 
		next_state <= Ecrit_R3;
		elsif opcode_value = x"07" then
		next_state <= CMP_R0_R3;
		elsif opcode_value = x"0E" then 
		next_state <= Sub_R0;
		elsif opcode_value = x"0F" then
		next_state <= AND_R0;
		elsif opcode_value = x"10" then 
		next_state <=Decalage_R0 ;
		elsif opcode_value = x"13" then
		next_state <= MOV_R3;
		elsif opcode_value = x"12" then
		next_state <= Double_R0;
		elsif opcode_value = x"11" then 
		next_state <= ADD_R0_R3;
		elsif opcode_value = x"0D" then
		next_state <= ADD_R0_1;
		elsif opcode_value = x"02" then
		next_state <= MOV_R0;
		elsif opcode_value = x"05" then
		next_state <= Lit_MemR1_R3;
		elsif opcode_value = x"09" then 
		next_state <= ADD_R1_R0;
		elsif opcode_value = x"0B" then
		next_state <= B_JMP;
		elsif opcode_value = x"0A" then
			if status_N = '1' then 
				next_state <= B_JMP;
			else 
				next_state <=Incr_PC;
			end if;
		elsif opcode_value = x"08" then
			if status_Z = '1' then
				next_state <= B_JMP;
			else 
				next_state <= Incr_PC;
			end if;
		elsif opcode_value = x"14" then
			if status_Z = '0' then 
				next_state <= B_JMP;
			else 
				next_state <=Incr_PC;
			end if;
		elsif opcode_value = x"15" then
		next_state <= Attendre;
					cmd_cmp <= '0';
		elsif opcode_value = x"16" then
		next_state <= Multi;
	end if;

	--current state == Ecrit_R1
	when Ecrit_R1 =>
		state_out <= X"04";
		next_state <= Incr_PC;
		sel_r1_next <= "01";

	--current state == Ecrit_MemR1
	when Ecrit_MemR1 =>
		state_out <= X"05";
		next_state <= Incr_PC;
		sel_address <= '1';
		wren <= '1';

	--current state == Lit_MemR1
	when Lit_MemR1 =>
		state_out <= X"06";
		next_state <= Ecrit_R0;
		sel_address <= '1';
	
	--current state == Ecrit_R0
	when Ecrit_R0=>
		state_out <= X"07";
		next_state <= Incr_PC;
		sel_r0_next <= "0001";
		sel_address <= '1';


	--current state == Incr_PC
	when Incr_PC=>
		state_out <= X"08";
		next_state <= Lit_Inst;
		sel_pc_next <= "01";

	
	--current state == Sub_R0
	when Sub_R0=>
		state_out <= X"09";
		next_state <= Incr_PC;
		sel_r0_next <= "0011";

	--current state == Ecrit_R3
	when Ecrit_R3=>
		state_out <= X"0A";
		next_state <= Incr_PC;
		sel_r3_next <= "010";

	--current state == AND_R0
	when AND_R0=>
		state_out <= X"0B";
		next_state <= Incr_PC;
		sel_r0_next <= "0100";

	--current state == Decalage_R0
	when Decalage_R0=>
		state_out <= X"0C";
		next_state <= Incr_PC;
		sel_r0_next <= "0101";

	
	--current state == B_JMP
	when B_JMP=>
		state_out <= X"0D";
		next_state <= Lit_Inst;
		sel_pc_next <= "10";

	--current state == MOV_R3
	when MOV_R3=>
		state_out <= X"0E";
		next_state <= Incr_PC;
		sel_r3_next <= "011";

	--current state == DOUBLE_R0
	when DOUBLE_R0=>
		state_out <= X"0F";
		next_state <= Incr_PC;
		sel_r0_next <= "0110";

	--current state == ADD_R0_R3
	when ADD_R0_R3=>
		state_out <= X"10";
		next_state <= Incr_PC;
		sel_r0_next <= "0111";
	
	--current state == ADD_R0_1
	when ADD_R0_1=>
		state_out <= X"11";
		next_state <= Incr_PC;
		sel_r0_next <= "1000";

	--current state == CMP_R0_R3
	when CMP_R0_R3=>
		state_out <= X"12";
		next_state <= Incr_PC;
		sel_status <= '1';

	--current state == MOV_R0
	when MOV_R0=>
		state_out <= X"13";
		next_state <= Incr_PC;
		sel_r0_next <= "0010";
	
	--current state == Lit_MemR1_R3
	when Lit_MemR1_R3 =>
		state_out <= X"14";
		next_state <= Ecrit_R3_LDRB;
		sel_address <= '1';
	
	--current state == Ecrit_R3_LDRB
	when Ecrit_R3_LDRB=>
		state_out <= X"15";
		next_state <= Incr_PC;
		sel_r3_next <= "001";
		sel_address <= '1';

	--current state == ADD_R1_R0
	when ADD_R1_R0=>
		state_out <= X"16";
		next_state <= Incr_PC;
		sel_r1_next <= "10";

	--current state == Attendre
	when Attendre=>
		state_out <= X"17";
		if (end_tempo = '1')then
			next_state <= Incr_PC;
		elsif (end_tempo = '1')then 
			next_state <= current_state;
		end if;
		
	--current state == Multi
	when Multi=>
		state_out <= X"18";
		next_state <= Incr_PC;
		sel_r0_next <= "1001";

	end case;

	end process;
     
end architecture;





