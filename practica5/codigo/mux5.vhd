library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Selector de la variable a sensar, gobernado por la parte de prueba
entity mux5 is
	Port( sel : in STD_LOGIC_VECTOR(2 downto 0);
			--defina sus entradas
			Q0 : in STD_LOGIC;   --X
			Q1 : in STD_LOGIC;   --Y
			Q2 : in STD_LOGIC;   --Z
			Q3 : in STD_LOGIC;   --W
			aux : in STD_LOGIC;  --Constante (GND) para transiciones incondicionales
			O : out STD_LOGIC
			);
end mux5;

architecture Behavioral of mux5 is
begin
	process (sel, Q0, Q1, Q2, Q3, aux)
	begin
		case sel is
			when "000" => O <= Q0;
			when "001" => O <= Q1;
			when "010" => O <= Q2;
			when "011" => O <= Q3;
			when others => O <= aux;
		end case;
	end process;
end Behavioral;
