library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Practica 3: Construccion de Maquinas de Estados usando Memorias
-- Direccionamiento por Trayectoria
--
--            +-------------+        +----------+        +---------+
--   Q1Q2Q3 ->| concatena   |-- 6 -->| memoria  |-- 7 -->| divisor |-- 4 --> S1..S4
--   EdoPres->| dor_datos   |  dir   | 64 x 7   |  data  | _datos  |
--       ^    +-------------+        +----------+        +----+----+
--       |                                                    | liga (3)
--       |              +-----------+                         |
--       +--------------| register2 |<------------------------+
--                      +-----+-----+
--                            | CLK
--                      +-----+-----+
--       CLK50 -------->| div_frec  |
--                      +-----------+

entity Practica3 is
	Port( CLK50 : in STD_LOGIC;                        --Reloj de 50 MHz de la tarjeta
			RESET : in STD_LOGIC;                        --Activo en bajo (KEY0)
			Q1 : in STD_LOGIC;
			Q2 : in STD_LOGIC;
			Q3 : in STD_LOGIC;
			S1 : out STD_LOGIC;                          --Logica estandar
			S2 : out STD_LOGIC;                          --Logica estandar
			S3 : out STD_LOGIC;                          --Logica negada (activa en 0)
			S4 : out STD_LOGIC;                          --Logica negada (activa en 0)
			EDO : out STD_LOGIC_VECTOR(2 downto 0)       --Estado presente
			);
end Practica3;

architecture Estructural of Practica3 is

	component div_frec is
		Port( reloj : in std_logic;
				div_clk : out std_logic);
	end component;

	component concatenador_datos is
		Port( entradaA : in STD_LOGIC_VECTOR(2 downto 0);
				entradaB : in STD_LOGIC_VECTOR(2 downto 0);
				salida : out STD_LOGIC_VECTOR(5 downto 0));
	end component;

	component memory is
		Port( dir : in STD_LOGIC_VECTOR(5 downto 0);
				data : out STD_LOGIC_VECTOR(6 downto 0));
	end component;

	component divisor_datos is
		Port( entrada : in STD_LOGIC_VECTOR(6 downto 0);
				liga : out STD_LOGIC_VECTOR(2 downto 0);
				salidas : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	component register2 is
		Port( CLK : in STD_LOGIC;
				RESET : in STD_LOGIC;
				DATA_IN : in STD_LOGIC_VECTOR(2 downto 0);
				DATA_OUT : out STD_LOGIC_VECTOR(2 downto 0));
	end component;

	signal clk_fsm : std_logic;
	signal entradas : std_logic_vector(2 downto 0);   --Q1 Q2 Q3
	signal edo_pres : std_logic_vector(2 downto 0);
	signal direccion : std_logic_vector(5 downto 0);
	signal palabra : std_logic_vector(6 downto 0);
	signal liga : std_logic_vector(2 downto 0);
	signal salidas : std_logic_vector(3 downto 0);    --S1 S2 S3 S4

begin

	entradas <= Q1 & Q2 & Q3;

	U1 : div_frec
		port map( reloj => CLK50,
					 div_clk => clk_fsm);

	U2 : concatenador_datos
		port map( entradaA => entradas,
					 entradaB => edo_pres,
					 salida => direccion);

	U3 : memory
		port map( dir => direccion,
					 data => palabra);

	U4 : divisor_datos
		port map( entrada => palabra,
					 liga => liga,
					 salidas => salidas);

	U5 : register2
		port map( CLK => clk_fsm,
					 RESET => RESET,
					 DATA_IN => liga,
					 DATA_OUT => edo_pres);

	S1 <= salidas(3);
	S2 <= salidas(2);
	S3 <= salidas(1);
	S4 <= salidas(0);
	EDO <= edo_pres;

end Estructural;
