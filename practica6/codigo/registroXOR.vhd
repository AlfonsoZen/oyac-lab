library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registroXOR is
	Port( CLK : in STD_LOGIC;
			RESET : in STD_LOGIC;
			ENA : in STD_LOGIC;
			DATA_IN : in STD_LOGIC; --XOR
			DATA_OUT : out STD_LOGIC--XOR
			);
end registroXOR;

architecture Behavioral of registroXOR is
	signal valor_interno : std_logic := '0';
	constant alta_impedancia : std_logic := 'Z';
	constant zero : std_logic := '0';
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