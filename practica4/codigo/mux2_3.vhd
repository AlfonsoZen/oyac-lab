library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Multiplexor de liga
entity mux2_3 is
	Port( sel : in STD_LOGIC;
			--Defina las ligas
			liga_f : in STD_LOGIC_VECTOR(3 downto 0);
			liga_v : in STD_LOGIC_VECTOR(3 downto 0);
			O : out STD_LOGIC_VECTOR(3 downto 0)
			);
end mux2_3;

architecture Behavioral of mux2_3 is
begin
	process (sel, liga_f, liga_v)
	begin
		--Asigne a "O" la liga dependiendo del selector
		if sel = '0' then
			O <= liga_f;
		else
			O <= liga_v;
		end if;
	end process;
end Behavioral;
