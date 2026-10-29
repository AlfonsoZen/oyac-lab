library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux1X2X1 is
	Port( sel : in STD_LOGIC;
			E0 : in STD_LOGIC_VECTOR(3 downto 0); -- Salidas Falsas
			E1 : in STD_LOGIC_VECTOR(3 downto 0); -- Salidas Verdaderas
			O : out STD_LOGIC_VECTOR(3 downto 0)
			);
end mux1X2X1;

architecture Behavioral of mux1X2X1 is
begin
	process (sel, E0, E1)
	begin
		if sel = '0' then
			O <= E0;
		elsif sel = '1' then
			O <= E1;
		end if;
	end process;
end Behavioral;