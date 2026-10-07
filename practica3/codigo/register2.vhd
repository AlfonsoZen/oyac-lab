library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register2 is
	Port( CLK : in STD_LOGIC;
			RESET : in STD_LOGIC;
			DATA_IN : in STD_LOGIC_VECTOR(2 downto 0); --Liga
			DATA_OUT : out STD_LOGIC_VECTOR(2 downto 0)--Edo Presente
			);
end register2;

architecture Behavioral of register2 is
	signal internal_value : std_logic_vector(2 downto 0) := B"000";
begin
	process (CLK, RESET)
	begin
		if RESET = '0' then
			internal_value <= B"000";          --EST0
		elsif rising_edge (CLK) then
			internal_value <= DATA_IN;         --Liga del estado presente
		end if;
	end process;

	process(internal_value)
	begin
		DATA_OUT <= internal_value;
	end process;
end Behavioral;
