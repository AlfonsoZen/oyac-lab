library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Practica 4: Construccion de Maquinas de Estados usando Memorias
-- Direccionamiento Entrada-Estado
--
-- La direccion de memoria es UNICAMENTE el estado presente (4 bits, 9 estados). La palabra
-- leida trae la prueba, las dos ligas y los dos juegos de salidas; el selector de
-- entradas (mux4) elige la variable a sensar y su valor gobierna los dos mux de
-- 2 a 1 que escogen liga y salidas.
--
--                                 +-----------+
--   Q1..Q4 ------------------->   |   mux4    |--- sel ---+-------------+
--                        +------->|  entradas |           |             |
--                        | prueba +-----------+           v             v
--   +-----------+        |                           +---------+   +---------+
--   | register3 |--dir-->| memory |--16--> divisor --| mux2_3  |   | mux2_4  |
--   |  (edo)    |        +--------+        _datos    |  liga   |   | salidas |
--   +-----^-----+                                    +----+----+   +----+----+
--         |                                               |             |
--         +------------------ liga ----------------------+              v
--                                                                  S1..S4

entity practica4 is
	Port( CLK50 : in STD_LOGIC;                        --Reloj de 50 MHz de la tarjeta
			RESET : in STD_LOGIC;                        --Activo en bajo (KEY0)
			Q1 : in STD_LOGIC;
			Q2 : in STD_LOGIC;
			Q3 : in STD_LOGIC;
			Q4 : in STD_LOGIC;
			S1 : out STD_LOGIC;                          --Logica estandar
			S2 : out STD_LOGIC;                          --Logica estandar
			S3 : out STD_LOGIC;                          --Logica negada (activa en 0)
			S4 : out STD_LOGIC;                          --Logica negada (activa en 0)
			EDO : out STD_LOGIC_VECTOR(3 downto 0)       --Estado presente
			);
end practica4;

architecture Estructural of practica4 is

	component div_frec is
		Port( reloj : in std_logic;
				div_clk : out std_logic);
	end component;

	component register3 is
		Port( CLK : in STD_LOGIC;
				RESET : in STD_LOGIC;
				DATA_IN : in STD_LOGIC_VECTOR(3 downto 0);
				DATA_OUT : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	component memory is
		Port( dir : in STD_LOGIC_VECTOR(3 downto 0);
				data : out STD_LOGIC_VECTOR(17 downto 0));
	end component;

	component divisor_datos is
		Port( entrada : in STD_LOGIC_VECTOR(17 downto 0);
				prueba : out STD_LOGIC_VECTOR(1 downto 0);
				liga_f : out STD_LOGIC_VECTOR(3 downto 0);
				liga_v : out STD_LOGIC_VECTOR(3 downto 0);
				salidas_f : out STD_LOGIC_VECTOR(3 downto 0);
				salidas_v : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	component mux4 is
		Port( sel : in STD_LOGIC_VECTOR(1 downto 0);
				Q1 : in STD_LOGIC;
				Q2 : in STD_LOGIC;
				Q3 : in STD_LOGIC;
				Q4 : in STD_LOGIC;
				O : out STD_LOGIC);
	end component;

	component mux2_3 is
		Port( sel : in STD_LOGIC;
				liga_f : in STD_LOGIC_VECTOR(3 downto 0);
				liga_v : in STD_LOGIC_VECTOR(3 downto 0);
				O : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	component mux2_4 is
		Port( sel : in STD_LOGIC;
				salidas_f : in STD_LOGIC_VECTOR(3 downto 0);
				salidas_v : in STD_LOGIC_VECTOR(3 downto 0);
				O : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	signal clk_fsm : std_logic;
	signal edo_pres : std_logic_vector(3 downto 0);
	signal palabra_mem : std_logic_vector(17 downto 0);  --Contenido de memoria leido
	signal prueba : std_logic_vector(1 downto 0);
	signal liga_f : std_logic_vector(3 downto 0);
	signal liga_v : std_logic_vector(3 downto 0);
	signal salidas_f : std_logic_vector(3 downto 0);
	signal salidas_v : std_logic_vector(3 downto 0);
	signal sel_entrada : std_logic;                      --Valor de la variable sensada
	signal liga : std_logic_vector(3 downto 0);
	signal salidas : std_logic_vector(3 downto 0);

begin

	U1 : div_frec
		port map( reloj => CLK50,
					 div_clk => clk_fsm);

	U2 : register3
		port map( CLK => clk_fsm,
					 RESET => RESET,
					 DATA_IN => liga,
					 DATA_OUT => edo_pres);

	U3 : memory
		port map( dir => edo_pres,
					 data => palabra_mem);

	U4 : divisor_datos
		port map( entrada => palabra_mem,
					 prueba => prueba,
					 liga_f => liga_f,
					 liga_v => liga_v,
					 salidas_f => salidas_f,
					 salidas_v => salidas_v);

	U5 : mux4
		port map( sel => prueba,
					 Q1 => Q1,
					 Q2 => Q2,
					 Q3 => Q3,
					 Q4 => Q4,
					 O => sel_entrada);

	U6 : mux2_3
		port map( sel => sel_entrada,
					 liga_f => liga_f,
					 liga_v => liga_v,
					 O => liga);

	U7 : mux2_4
		port map( sel => sel_entrada,
					 salidas_f => salidas_f,
					 salidas_v => salidas_v,
					 O => salidas);

	S1 <= salidas(3);
	S2 <= salidas(2);
	S3 <= salidas(1);
	S4 <= salidas(0);
	EDO <= edo_pres;

end Estructural;
