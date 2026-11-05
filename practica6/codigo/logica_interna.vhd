library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logica_interna is
	Port( instruccion : in STD_LOGIC_VECTOR(1 downto 0); -- 4 MI
			nCC : in STD_LOGIC; --  Compuerta XOR
			selector : out STD_LOGIC; -- Selecciona Inc o Salto
			nPL : out STD_LOGIC; -- Activa la liga
			nMAP : out	STD_LOGIC; -- Activa RT
			nVECT : out STD_LOGIC -- ACtiva RI
			);
end logica_interna;

architecture Behavioral of logica_interna is
begin
	process (instruccion, nCC)
	begin
		if instruccion = "00" then -- Paso Contiguo
			selector <= '0';
			nPL <= '1';
			nMap <= '1';
			nVECT <= '1';
		elsif instruccion = "01" then -- Salto Condicional
			if nCC = '0' then 
				selector <= '1';
				nPL <= '0';
				nMap <= '1';
				nVECT <= '1';
			elsif nCC = '1' then
				selector <= '0';
				nPL <= '1';
				nMap <= '1';
				nVECT <= '1';
			end if;
		elsif instruccion = "10" then -- Salto Transformacion
			selector <= '1';
			nPL <= '1';
			nMap <= '0';
			nVECT <= '1';
		elsif instruccion = "11" then -- Salto Interrupcion
			if nCC = '0' then 
				selector <= '1';
				nPL <= '1';
				nMap <= '1';
				nVECT <= '0';
			elsif nCC = '1' then
				selector <= '0';
				nPL <= '1';
				nMap <= '1';
				nVECT <= '1';
			end if;
		end if;
	end process;
end Behavioral;