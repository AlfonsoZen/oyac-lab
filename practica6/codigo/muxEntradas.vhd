library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity muxEntradas is
	Port( sel : in STD_LOGIC_VECTOR(1 downto 0);
			Q0 : in STD_LOGIC; 
			Q1 : in STD_LOGIC; 
			Q2 : in STD_LOGIC; -- INT
			Q3 : in STD_LOGIC; -- AUX
			O : out STD_LOGIC
			);
end muxEntradas;

architecture Behavioral of muxEntradas is
begin
	process (sel, Q0, Q1, Q2, Q3)
	begin
		if sel = "00" then 
			O <= Q0;
		elsif sel = "01" then 
			O <= Q1;
		elsif sel = "10" then -- INT
			O <= Q2;
		elsif sel = "11" then -- AUX
			O <= Q3;
		end if;
	end process;
end Behavioral;