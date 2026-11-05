library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity div_frec is
	Port (reloj : in std_logic;
			div_clk : out std_logic);
end div_frec;

architecture Behavioral of div_frec is
begin
	process (reloj)
	variable cuenta : std_logic_vector (27 downto 0) := X"0000000";
	begin
		if rising_edge (reloj) then
		
			--if cuenta 0 "4000000" then
			if cuenta = X"2FAF080" then
				cuenta := X"0000000";
			else
				cuenta := cuenta+1;
			end if;
		end if;
		div_clk <= cuenta(25);
	end process;
end Behavioral;