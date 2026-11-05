library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registroPrueba is
	Port( CLK : in STD_LOGIC;
			RESET : in STD_LOGIC;
			ENA : in STD_LOGIC;
			DATA_IN : in STD_LOGIC_VECTOR(1 downto 0); --MI
			DATA_OUT : out STD_LOGIC_VECTOR(1 downto 0)--MI
			);
end registroPrueba;

architecture Behavioral of registroPrueba is
	signal valor_interno : std_logic_vector(1 downto 0) := B"00";
	constant alta_impedancia : std_logic_vector(1 downto 0) := "ZZ";
	constant zero : std_logic_vector(1 downto 0) := B"00";
begin
	process (CLK, RESET, DATA_IN)
	begin
		if RESET = '0' then
			valor_interno <= zero;
		elsif rising_edge (CLK) then
			valor_interno <= DATA_IN;
		end if;
	end process;
	
	process(valor_interno, ENA)
	begin
		if  ENA = '1' then
			DATA_OUT <= alta_impedancia;
		else
			DATA_OUT <= valor_interno;
		end if;
	end process;
end Behavioral;