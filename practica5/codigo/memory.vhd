library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity memory is
	Port( dir : in STD_LOGIC_VECTOR(2 downto 0);
			data : out STD_LOGIC_VECTOR(14 downto 0)
			);
end memory;

architecture Behavioral of memory is
	type mem is array(0 to 7) of std_logic_vector(14 downto 0);
	signal internal_mem : mem;

begin
	--Llenado de memoria. Direccionamiento implicito:
	--	Palabra = Prueba(3) & VF(1) & Liga(3) & SalFalsas(4) & SalVerdaderas(4)
	--	Memoria = 2^3 x 15 = 120 bits
	--
	--	Prueba:  000=X  001=Y  010=Z  011=W  100=aux(GND, constante 0)
	--	VF:      valor de la variable sensada con el que se CARGA la liga;
	--	         Carga = XNOR(variable, VF). Si Carga=0 el contador incrementa.
	--	Salidas: S1 S2 U1 U2
	--	         S1 y S2: logica estandar (1 = activa, 0 = inactiva)
	--	         U1 y U2: logica negada   (0 = activa, 1 = inactiva)
	--	         SalFalsas se aplican cuando la variable sensada vale 0,
	--	         SalVerdaderas cuando vale 1.

	--                      Prueba  VF    Liga    SalF    SalV
	internal_mem(0) <= "000" & "1" & "100" & "1001" & "1111"; --E0: S1;      X=0 +1->E1 (U1) | X=1 carga E4 (S2)
	internal_mem(1) <= "001" & "0" & "001" & "0010" & "0110"; --E1: U2;      Y=0 carga E1    | Y=1 +1->E2 (S2)
	internal_mem(2) <= "010" & "1" & "000" & "1001" & "1000"; --E2: S1 U1;   Z=0 +1->E3      | Z=1 carga E0 (U2)
	internal_mem(3) <= "100" & "0" & "000" & "0110" & "0110"; --E3: S2 U2;   incondicional carga E0
	internal_mem(4) <= "001" & "1" & "110" & "1111" & "1101"; --E4: S1 S2;   Y=0 +1->E5      | Y=1 carga E6 (U1)
	internal_mem(5) <= "000" & "1" & "000" & "0000" & "1000"; --E5: U1 U2;   X=0 +1->E6      | X=1 carga E0 (S1)
	internal_mem(6) <= "100" & "0" & "000" & "1100" & "1100"; --E6: S1 S2 U1 U2; incondicional carga E0
	internal_mem(7) <= "100" & "0" & "000" & "0011" & "0011"; --E7: no usado; regresa a E0 en reposo

	process(dir, internal_mem)
	begin
		data <= internal_mem(conv_integer(unsigned(dir)));
	end process;
end Behavioral;
