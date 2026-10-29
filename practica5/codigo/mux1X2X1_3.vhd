library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux1X2X1_3 is
	Port( sel : in STD_LOGIC; -- Carga
			--Definir ligas de incremento y carga
			E0 : in STD_LOGIC_VECTOR(2 downto 0); -- Liga de incremento (edo + 1)
			E1 : in STD_LOGIC_VECTOR(2 downto 0); -- Liga de carga (viene de memoria)
			salida : out STD_LOGIC_VECTOR(2 downto 0) -- Estado Siguiente
			);
end mux1X2X1_3;

architecture Behavioral of mux1X2X1_3 is
begin
	process (sel, E0, E1)
	begin
		if sel = '0' then
			salida <= E0;
		else
			salida <= E1;
		end if;
	end process;
end Behavioral;
