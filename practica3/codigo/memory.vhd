library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity memory is
	Port( dir : in STD_LOGIC_VECTOR(5 downto 0); --Entradas + edo presente
			data : out STD_LOGIC_VECTOR(6 downto 0) --Liga + Salidas
			);
end memory;

architecture Behavioral of memory is
	--Arreglo ROM de 64 palabras de 7 bits  (Memoria = 2^6 x 7 = 448 bits)
	type rom_type is array (0 to 63) of std_logic_vector(6 downto 0);
	signal internal_mem : rom_type;

begin
	--	dir  = Edo.Presente(2..0) & Q1 & Q2 & Q3
	--	data = Liga(L2 L1 L0) & Salidas(S1 S2 S3 S4)
	--	S1 y S2: logica estandar  (1 = activa)
	--	S3 y S4: logica negada    (0 = activa)

	-- EST0 (000) -- direcciones 0 a 7
	internal_mem( 0) <= "000" & "1011";	-- Q1Q2Q3=000 -> liga 000 | S1
	internal_mem( 1) <= "000" & "1011";	-- Q1Q2Q3=001 -> liga 000 | S1
	internal_mem( 2) <= "000" & "1011";	-- Q1Q2Q3=010 -> liga 000 | S1
	internal_mem( 3) <= "000" & "1011";	-- Q1Q2Q3=011 -> liga 000 | S1
	internal_mem( 4) <= "001" & "1011";	-- Q1Q2Q3=100 -> liga 001 | S1
	internal_mem( 5) <= "001" & "1011";	-- Q1Q2Q3=101 -> liga 001 | S1
	internal_mem( 6) <= "001" & "1011";	-- Q1Q2Q3=110 -> liga 001 | S1
	internal_mem( 7) <= "001" & "1011";	-- Q1Q2Q3=111 -> liga 001 | S1

	-- EST1 (001) -- direcciones 8 a 15
	internal_mem( 8) <= "011" & "0001";	-- Q1Q2Q3=000 -> liga 011 | S3* cond.
	internal_mem( 9) <= "011" & "0001";	-- Q1Q2Q3=001 -> liga 011 | S3* cond.
	internal_mem(10) <= "010" & "0111";	-- Q1Q2Q3=010 -> liga 010 | S2 cond.
	internal_mem(11) <= "010" & "0111";	-- Q1Q2Q3=011 -> liga 010 | S2 cond.
	internal_mem(12) <= "011" & "0001";	-- Q1Q2Q3=100 -> liga 011 | S3* cond.
	internal_mem(13) <= "011" & "0001";	-- Q1Q2Q3=101 -> liga 011 | S3* cond.
	internal_mem(14) <= "010" & "0111";	-- Q1Q2Q3=110 -> liga 010 | S2 cond.
	internal_mem(15) <= "010" & "0111";	-- Q1Q2Q3=111 -> liga 010 | S2 cond.

	-- EST2 (010) -- direcciones 16 a 23
	internal_mem(16) <= "000" & "0010";	-- Q1Q2Q3=000 -> liga 000 | S4*
	internal_mem(17) <= "100" & "0010";	-- Q1Q2Q3=001 -> liga 100 | S4*
	internal_mem(18) <= "000" & "0010";	-- Q1Q2Q3=010 -> liga 000 | S4*
	internal_mem(19) <= "100" & "0010";	-- Q1Q2Q3=011 -> liga 100 | S4*
	internal_mem(20) <= "000" & "0010";	-- Q1Q2Q3=100 -> liga 000 | S4*
	internal_mem(21) <= "100" & "0010";	-- Q1Q2Q3=101 -> liga 100 | S4*
	internal_mem(22) <= "000" & "0010";	-- Q1Q2Q3=110 -> liga 000 | S4*
	internal_mem(23) <= "100" & "0010";	-- Q1Q2Q3=111 -> liga 100 | S4*

	-- EST3 (011) -- direcciones 24 a 31
	internal_mem(24) <= "011" & "0111";	-- Q1Q2Q3=000 -> liga 011 | S2
	internal_mem(25) <= "011" & "0111";	-- Q1Q2Q3=001 -> liga 011 | S2
	internal_mem(26) <= "011" & "0111";	-- Q1Q2Q3=010 -> liga 011 | S2
	internal_mem(27) <= "011" & "0111";	-- Q1Q2Q3=011 -> liga 011 | S2
	internal_mem(28) <= "100" & "0111";	-- Q1Q2Q3=100 -> liga 100 | S2
	internal_mem(29) <= "100" & "0111";	-- Q1Q2Q3=101 -> liga 100 | S2
	internal_mem(30) <= "100" & "0111";	-- Q1Q2Q3=110 -> liga 100 | S2
	internal_mem(31) <= "100" & "0111";	-- Q1Q2Q3=111 -> liga 100 | S2

	-- EST4 (100) -- direcciones 32 a 39
	internal_mem(32) <= "100" & "0010";	-- Q1Q2Q3=000 -> liga 100 | S4* cond.
	internal_mem(33) <= "000" & "1011";	-- Q1Q2Q3=001 -> liga 000 | S1 cond.
	internal_mem(34) <= "100" & "0010";	-- Q1Q2Q3=010 -> liga 100 | S4* cond.
	internal_mem(35) <= "000" & "1011";	-- Q1Q2Q3=011 -> liga 000 | S1 cond.
	internal_mem(36) <= "100" & "0010";	-- Q1Q2Q3=100 -> liga 100 | S4* cond.
	internal_mem(37) <= "000" & "1011";	-- Q1Q2Q3=101 -> liga 000 | S1 cond.
	internal_mem(38) <= "100" & "0010";	-- Q1Q2Q3=110 -> liga 100 | S4* cond.
	internal_mem(39) <= "000" & "1011";	-- Q1Q2Q3=111 -> liga 000 | S1 cond.

	-- Estados no utilizados (101, 110, 111) -- regresan a EST0, salidas en reposo
	internal_mem(40) <= "000" & "0011";
	internal_mem(41) <= "000" & "0011";
	internal_mem(42) <= "000" & "0011";
	internal_mem(43) <= "000" & "0011";
	internal_mem(44) <= "000" & "0011";
	internal_mem(45) <= "000" & "0011";
	internal_mem(46) <= "000" & "0011";
	internal_mem(47) <= "000" & "0011";
	internal_mem(48) <= "000" & "0011";
	internal_mem(49) <= "000" & "0011";
	internal_mem(50) <= "000" & "0011";
	internal_mem(51) <= "000" & "0011";
	internal_mem(52) <= "000" & "0011";
	internal_mem(53) <= "000" & "0011";
	internal_mem(54) <= "000" & "0011";
	internal_mem(55) <= "000" & "0011";
	internal_mem(56) <= "000" & "0011";
	internal_mem(57) <= "000" & "0011";
	internal_mem(58) <= "000" & "0011";
	internal_mem(59) <= "000" & "0011";
	internal_mem(60) <= "000" & "0011";
	internal_mem(61) <= "000" & "0011";
	internal_mem(62) <= "000" & "0011";
	internal_mem(63) <= "000" & "0011";

	process(dir, internal_mem)
	begin
		data <= internal_mem(conv_integer(unsigned(dir))); --conversion de palabra a entero
	end process;
end Behavioral;
