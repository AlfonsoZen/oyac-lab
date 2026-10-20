library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divisor_datos is
	Port( entrada : in STD_LOGIC_VECTOR(17 downto 0); --Bits de memoria por registro
			-- Complementa con cada campo de memoria
			prueba : out STD_LOGIC_VECTOR(1 downto 0);      --Entrada a sensar
			liga_f : out STD_LOGIC_VECTOR(3 downto 0);      --Liga falsa
			liga_v : out STD_LOGIC_VECTOR(3 downto 0);      --Liga verdadera
			salidas_f : out STD_LOGIC_VECTOR(3 downto 0);   --Salidas falsas
			salidas_v : out STD_LOGIC_VECTOR(3 downto 0)    --Salidas verdaderas
			);
end divisor_datos;

architecture Behavioral of divisor_datos is
begin
	process (entrada)
	begin
		--Asigna cada parte de la memoria a los bits correspondientes de entrada
		prueba    <= entrada(17 downto 16);
		liga_f    <= entrada(15 downto 12);
		liga_v    <= entrada(11 downto 8);
		salidas_f <= entrada(7 downto 4);
		salidas_v <= entrada(3 downto 0);
	end process;
end Behavioral;
