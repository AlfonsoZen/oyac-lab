library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divisor_datos is
	Port( entrada : in STD_LOGIC_VECTOR(14 downto 0);
			prueba : out STD_LOGIC_VECTOR(2 downto 0);    --Selector de la variable a sensar
			VF : out STD_LOGIC;                           --Valor con el que se carga la liga
			liga : out STD_LOGIC_VECTOR(2 downto 0);      --Estado siguiente en caso de carga
			salidas_F : out STD_LOGIC_VECTOR(3 downto 0); --Salidas con la variable en 0
			salidas_V : out STD_LOGIC_VECTOR(3 downto 0)  --Salidas con la variable en 1
			);
end divisor_datos;

architecture Behavioral of divisor_datos is
begin
	process (entrada)
	begin
		prueba    <= entrada(14 downto 12);
		VF        <= entrada(11);
		liga      <= entrada(10 downto 8);
		salidas_F <= entrada(7 downto 4);
		salidas_V <= entrada(3 downto 0);
	end process;
end Behavioral;
