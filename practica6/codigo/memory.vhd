library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity memory is
	Port( dir : in STD_LOGIC_VECTOR(3 downto 0); --Edo Presente
			data : out STD_LOGIC_VECTOR(16 downto 0) --Prueba+VF+MI+L+SC+SI
			);
end memory;

architecture Behavioral of memory is
	type mem is array(0 to 15) of std_logic_vector(16 downto 0);
	signal internal_mem : mem;

begin
						 --Prueba+ VF  +  MI  +  Liga  +  S.C  +  S.I
	--  Memoria = 2^4 x 17 = 272 bits
	--  Prueba (2): 00=X  01=Y  10=INT  11=Qaux (constante 0, saltos incondicionales)
	--  VF     (1): valor de la variable con el que se toma el salto.
	--              nCC = XOR(variable, VF); la logica interna salta con nCC='0'.
	--  MI     (2): 00=C (continua)  01=SCO  10=ST  11=SCI
	--  Liga   (4): destino del SCO. En ST el destino lo da el registro de
	--              transformacion y en SCI el de interrupciones.
	--  Salidas(4): S0 S1 S2 S3. S0 y S1 logica estandar (1=activa);
	--              S2 y S3 logica negada (0=activa). La carta no tiene salidas
	--              condicionales, por eso S.C y S.I son iguales en toda localidad.

	internal_mem( 0) <= "00" & "0" & "01" & "0000" & "0011" & "0011"; --E0   X: 1->+1 (E1) | 0->liga E0 (autolazo)
	internal_mem( 1) <= "11" & "0" & "00" & "0000" & "1011" & "1011"; --E1   C -> E2
	internal_mem( 2) <= "01" & "1" & "01" & "0101" & "1111" & "1111"; --E2   Y: 0->+1 (E3) | 1->liga E5
	internal_mem( 3) <= "11" & "0" & "00" & "0000" & "0001" & "0001"; --E3   C -> E4
	internal_mem( 4) <= "11" & "0" & "01" & "0110" & "0010" & "0010"; --E4   SCO incond. (Qaux) -> E6
	internal_mem( 5) <= "11" & "0" & "00" & "0000" & "0101" & "0101"; --E5   C -> E6
	internal_mem( 6) <= "10" & "1" & "11" & "0000" & "1010" & "1010"; --E6   SCI INT: 0->+1 (E7) | 1->vector INNT
	internal_mem( 7) <= "11" & "0" & "10" & "0000" & "0011" & "0011"; --E7   ST -> registro de transformacion
	internal_mem( 8) <= "11" & "0" & "01" & "1101" & "0111" & "0111"; --E8   SCO incond. -> E13
	internal_mem( 9) <= "11" & "0" & "01" & "1101" & "1011" & "1011"; --E9   SCO incond. -> E13
	internal_mem(10) <= "11" & "0" & "01" & "1101" & "0001" & "0001"; --E10  SCO incond. -> E13
	internal_mem(11) <= "11" & "0" & "01" & "1101" & "0010" & "0010"; --E11  SCO incond. -> E13
	internal_mem(12) <= "11" & "0" & "01" & "0000" & "1100" & "1100"; --E12  SCO incond. -> E0 (rutina de interrupcion)
	internal_mem(13) <= "00" & "1" & "01" & "0010" & "0110" & "0110"; --E13  X: 0->+1 (E14) | 1->liga E2
	internal_mem(14) <= "11" & "0" & "01" & "0000" & "1001" & "1001"; --E14  SCO incond. -> E0
	internal_mem(15) <= "11" & "0" & "01" & "0000" & "0011" & "0011"; ----   no usado -> E0 en reposo

	process(dir, internal_mem)
	begin
		data <= internal_mem(conv_integer(unsigned(dir)));
	end process;
end Behavioral;
