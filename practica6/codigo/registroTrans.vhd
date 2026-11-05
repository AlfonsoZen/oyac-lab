library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registroTrans is
	Port( CLK : in STD_LOGIC;
			RESET : in STD_LOGIC;
			ENA : in STD_LOGIC;
			DATA_IN : in STD_LOGIC_VECTOR(3 downto 0); --Salto
			DATA_OUT : out STD_LOGIC_VECTOR(3 downto 0)--Edo Sig
			);
end registroTrans;

architecture Behavioral of registroTrans is
	signal valor_interno : std_logic_vector(3 downto 0) := B"0000";
	constant alta_impedancia : std_logic_vector(3 downto 0) := "ZZZZ";
	constant zero : std_logic_vector(3 downto 0) := B"0000";
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