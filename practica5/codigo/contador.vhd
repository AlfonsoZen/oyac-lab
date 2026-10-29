library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Contador de estado del direccionamiento implicito.
-- Reproduce el diagrama contador.bdf: el registro guarda el estado presente,
-- el incrementador calcula edo+1 y el multiplexor de 3 bits elige entre ese
-- incremento (Carga = '0') y la liga que entrega la memoria (Carga = '1').

entity contador is
	Port( Carga : in STD_LOGIC;
			Liga : in STD_LOGIC_VECTOR(2 downto 0);
			CLK : in STD_LOGIC;
			RESET : in STD_LOGIC;
			SAL : out STD_LOGIC_VECTOR(2 downto 0)
			);
end contador;

architecture Estructural of contador is

	component incrementador is
		Port( entrada : in STD_LOGIC_VECTOR(2 downto 0);
				salida : out STD_LOGIC_VECTOR(2 downto 0));
	end component;

	component mux1X2X1_3 is
		Port( sel : in STD_LOGIC;
				E0 : in STD_LOGIC_VECTOR(2 downto 0);
				E1 : in STD_LOGIC_VECTOR(2 downto 0);
				salida : out STD_LOGIC_VECTOR(2 downto 0));
	end component;

	component register3 is
		Port( CLK : in STD_LOGIC;
				RESET : in STD_LOGIC;
				DATA_IN : in STD_LOGIC_VECTOR(2 downto 0);
				DATA_OUT : out STD_LOGIC_VECTOR(2 downto 0));
	end component;

	signal edo_pres : std_logic_vector(2 downto 0);
	signal incremento : std_logic_vector(2 downto 0);
	signal edo_sig : std_logic_vector(2 downto 0);

begin

	U1 : incrementador
		port map( entrada => edo_pres,
					 salida => incremento);

	U2 : mux1X2X1_3
		port map( sel => Carga,
					 E0 => incremento,
					 E1 => Liga,
					 salida => edo_sig);

	U3 : register3
		port map( CLK => CLK,
					 RESET => RESET,
					 DATA_IN => edo_sig,
					 DATA_OUT => edo_pres);

	SAL <= edo_pres;

end Estructural;
