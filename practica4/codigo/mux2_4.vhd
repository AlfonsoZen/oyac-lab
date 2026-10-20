library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Multiplexor de Salidas
entity mux2_4 is
	Port( sel : in STD_LOGIC;
			--Defina las salidas verdaderas y falsas
			salidas_f : in STD_LOGIC_VECTOR(3 downto 0);
			salidas_v : in STD_LOGIC_VECTOR(3 downto 0);
			O : out STD_LOGIC_VECTOR(3 downto 0)
			);
end mux2_4;

architecture Behavioral of mux2_4 is
begin
	process (sel, salidas_f, salidas_v)
	begin
		--Asigne a "O" las salidas dependiendo del selector
		if sel = '0' then
			O <= salidas_f;
		else
			O <= salidas_v;
		end if;
	end process;
end Behavioral;
