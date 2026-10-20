library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity memory is
	Port( dir : in STD_LOGIC_VECTOR(3 downto 0); --Tamaño de direccion (solo el edo. presente)
			data : out STD_LOGIC_VECTOR(17 downto 0) --Tamaño de memoria por registro
			);
end memory;

architecture Behavioral of memory is
	type mem is array(0 to 15) of std_logic_vector(17 downto 0); --tamaño de memoria por registro
	signal internal_mem : mem;

begin
	--Llenado de memoria
	--	Palabra = Prueba(2) & LigaFalsa(4) & LigaVerdadera(4) & SalFalsas(4) & SalVerdaderas(4)
	--	Memoria = 2^4 x 18 = 288 bits
	--
	--	Prueba:  00=Q1  01=Q2  10=Q3  11=Q4
	--	Salidas: S1 S2 S3 S4   (S1,S2 logica estandar: 1=activa)
	--	                       (S3,S4 logica negada:   0=activa)
	--
	--	En EST8 y en los estados no usados la prueba es indiferente (LF=LV);
	--	se escribe 00 para dejar el campo en un valor definido.

	--                       Prueba  LigaF    LigaV    SalFalsas  SalVerdaderas
	internal_mem( 0) <= "00" & "0000" & "0001" & "0011" & "0011"; --EST0: sin salidas, prueba Q1
	internal_mem( 1) <= "01" & "0010" & "0011" & "1001" & "1111"; --EST1: S1, prueba Q2, cond. S3*/S2
	internal_mem( 2) <= "10" & "0010" & "0100" & "0010" & "0010"; --EST2: S4*, prueba Q3
	internal_mem( 3) <= "11" & "0101" & "0100" & "0111" & "0111"; --EST3: S2, prueba Q4
	internal_mem( 4) <= "00" & "0110" & "0111" & "1011" & "0011"; --EST4: sin salidas, prueba Q1, cond. S1
	internal_mem( 5) <= "01" & "0101" & "0110" & "0001" & "0001"; --EST5: S3*, prueba Q2
	internal_mem( 6) <= "10" & "0000" & "0111" & "1011" & "1010"; --EST6: S1, prueba Q3, cond. S4*
	internal_mem( 7) <= "11" & "0111" & "1000" & "0110" & "0110"; --EST7: S2 y S4*, prueba Q4
	internal_mem( 8) <= "00" & "0000" & "0000" & "1001" & "1001"; --EST8: S1 y S3*, sin prueba -> EST0

	--Estados no utilizados (1001 a 1111): regresan a EST0 con las salidas en reposo
	internal_mem( 9) <= "00" & "0000" & "0000" & "0011" & "0011";
	internal_mem(10) <= "00" & "0000" & "0000" & "0011" & "0011";
	internal_mem(11) <= "00" & "0000" & "0000" & "0011" & "0011";
	internal_mem(12) <= "00" & "0000" & "0000" & "0011" & "0011";
	internal_mem(13) <= "00" & "0000" & "0000" & "0011" & "0011";
	internal_mem(14) <= "00" & "0000" & "0000" & "0011" & "0011";
	internal_mem(15) <= "00" & "0000" & "0000" & "0011" & "0011";

	process(dir, internal_mem)
	begin
		data <= internal_mem(conv_integer(unsigned(dir)));
	end process;
end Behavioral;
