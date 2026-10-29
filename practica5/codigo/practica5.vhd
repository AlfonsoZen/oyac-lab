library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Practica 5: Construccion de Maquinas de Estados usando Memorias
-- Direccionamiento Implicito
--
-- Reproduce el diagrama de bloques de la profesora. La direccion de memoria es
-- unicamente el estado presente (3 bits). La palabra trae la parte de prueba, el
-- bit VF, una sola liga y los dos juegos de salidas. El selector mux5 engancha la
-- variable a sensar; Carga = XNOR(variable, VF) decide si el contador incrementa
-- (Carga='0') o carga la liga (Carga='1'). El mux de salidas conmuta con el valor
-- crudo de la variable sensada, no con Carga.

entity practica5 is
	Port( CLK : in STD_LOGIC;                        --Reloj de 50 MHz de la tarjeta
			RESET : in STD_LOGIC;                      --Activo en bajo (KEY0)
			X : in STD_LOGIC;
			Y : in STD_LOGIC;
			Z : in STD_LOGIC;
			W : in STD_LOGIC;
			S1 : out STD_LOGIC;
			S2 : out STD_LOGIC;
			U1 : out STD_LOGIC;
			U2 : out STD_LOGIC;
			EDO : out STD_LOGIC_VECTOR(2 downto 0)     --Estado presente
			);
end practica5;

architecture Estructural of practica5 is

	component div_frec is
		Port( reloj : in std_logic;
				div_clk : out std_logic);
	end component;

	component contador is
		Port( Carga : in STD_LOGIC;
				Liga : in STD_LOGIC_VECTOR(2 downto 0);
				CLK : in STD_LOGIC;
				RESET : in STD_LOGIC;
				SAL : out STD_LOGIC_VECTOR(2 downto 0));
	end component;

	component memory is
		Port( dir : in STD_LOGIC_VECTOR(2 downto 0);
				data : out STD_LOGIC_VECTOR(14 downto 0));
	end component;

	component divisor_datos is
		Port( entrada : in STD_LOGIC_VECTOR(14 downto 0);
				prueba : out STD_LOGIC_VECTOR(2 downto 0);
				VF : out STD_LOGIC;
				liga : out STD_LOGIC_VECTOR(2 downto 0);
				salidas_F : out STD_LOGIC_VECTOR(3 downto 0);
				salidas_V : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	component mux5 is
		Port( sel : in STD_LOGIC_VECTOR(2 downto 0);
				Q0 : in STD_LOGIC;
				Q1 : in STD_LOGIC;
				Q2 : in STD_LOGIC;
				Q3 : in STD_LOGIC;
				aux : in STD_LOGIC;
				O : out STD_LOGIC);
	end component;

	component mux1X2X1 is
		Port( sel : in STD_LOGIC;
				E0 : in STD_LOGIC_VECTOR(3 downto 0);
				E1 : in STD_LOGIC_VECTOR(3 downto 0);
				O : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	signal clk_fsm : std_logic;
	signal edo_pres : std_logic_vector(2 downto 0);
	signal palabra_mem : std_logic_vector(14 downto 0);  --Contenido de memoria leido
	signal prueba : std_logic_vector(2 downto 0);
	signal VF : std_logic;
	signal liga : std_logic_vector(2 downto 0);
	signal salidas_F : std_logic_vector(3 downto 0);
	signal salidas_V : std_logic_vector(3 downto 0);
	signal var_sensada : std_logic;                      --Salida del mux5
	signal carga : std_logic;                            --XNOR(var_sensada, VF)
	signal salidas : std_logic_vector(3 downto 0);       --S1 S2 U1 U2

begin

	U1_div : div_frec
		port map( reloj => CLK,
					 div_clk => clk_fsm);

	U2_cont : contador
		port map( Carga => carga,
					 Liga => liga,
					 CLK => clk_fsm,
					 RESET => RESET,
					 SAL => edo_pres);

	U3_mem : memory
		port map( dir => edo_pres,
					 data => palabra_mem);

	U4_div : divisor_datos
		port map( entrada => palabra_mem,
					 prueba => prueba,
					 VF => VF,
					 liga => liga,
					 salidas_F => salidas_F,
					 salidas_V => salidas_V);

	U5_mux : mux5
		port map( sel => prueba,
					 Q0 => X,
					 Q1 => Y,
					 Q2 => Z,
					 Q3 => W,
					 aux => '0',
					 O => var_sensada);

	--Compuerta XNOR del diagrama: carga la liga cuando la variable sensada
	--coincide con VF; en cualquier otro caso el contador incrementa.
	carga <= var_sensada xnor VF;

	U6_sal : mux1X2X1
		port map( sel => var_sensada,
					 E0 => salidas_F,
					 E1 => salidas_V,
					 O => salidas);

	S1 <= salidas(3);
	S2 <= salidas(2);
	U1 <= salidas(1);
	U2 <= salidas(0);
	EDO <= edo_pres;

end Estructural;
