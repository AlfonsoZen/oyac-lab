library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity muxDireccion is
	Port( sel : in STD_LOGIC; -- Carga
			E0 : in STD_LOGIC_VECTOR(3 downto 0); -- Incremento
			E1 : in STD_LOGIC_VECTOR(3 downto 0); -- Salto
			sal : out STD_LOGIC_VECTOR(3 downto 0) -- Estado Siguiente
			);
end muxDireccion;

architecture Behavioral of muxDireccion is
begin
	process (sel, E0, E1)
	begin
		if sel = '0' then
			sal <= E0;
		elsif sel = '1' then
			sal <= E1;
		end if;
	end process;
end Behavioral;