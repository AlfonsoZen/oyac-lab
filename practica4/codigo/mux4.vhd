library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Multiplexor de entradas
entity mux4 is
	Port( sel : in STD_LOGIC_VECTOR(1 downto 0);
			--Defina sus entradas
			Q1 : in STD_LOGIC;
			Q2 : in STD_LOGIC;
			Q3 : in STD_LOGIC;
			Q4 : in STD_LOGIC;
			O : out STD_LOGIC
			);
end mux4;

architecture Behavioral of mux4 is
begin
	process (sel, Q1, Q2, Q3, Q4)
	begin
		-- Asigne a "O" la entrada dependiendo del selector
		case sel is
			when "00" => O <= Q1;
			when "01" => O <= Q2;
			when "10" => O <= Q3;
			when others => O <= Q4;
		end case;
	end process;
end Behavioral;
