library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Practica 6: Secuenciador basico (reproduce practica6_diagrama.bdf).
--
-- La memoria se direcciona con el bus Y que entrega el secuenciador. La palabra
-- de 17 bits se reparte en prueba, VF, MI, liga y los dos juegos de salidas.
--
-- Los tres origenes de la direccion de salto comparten la entrada D (bus Q) con
-- salidas de tres estados: el registro de liga, el de transformacion y el de
-- interrupciones. La logica interna habilita uno solo mediante nPL, nMAP o
-- nVECT (activos en bajo); los otros dos quedan en alta impedancia.
--
-- nCC = XOR(variable sensada, VF), registrada, y es la condicion del salto:
-- vale '0' cuando la variable coincide con VF, que es lo que la logica interna
-- interpreta como "saltar".

entity practica6 is
	Port( CLK : in STD_LOGIC;                        --Reloj de 50 MHz de la tarjeta
			RESET : in STD_LOGIC;                      --Activo en bajo (KEY0)
			X : in STD_LOGIC;                          --Entrada real 1
			Y : in STD_LOGIC;                          --Entrada real 2
			INT : in STD_LOGIC;                        --Peticion de interrupcion
			INTRA : in STD_LOGIC_VECTOR(3 downto 0);   --Direccion de transformacion
			INNT : in STD_LOGIC_VECTOR(3 downto 0);    --Direccion de interrupcion
			SAL : out STD_LOGIC_VECTOR(3 downto 0);    --Salidas S1 S2 U1 U2
			EDO : out STD_LOGIC_VECTOR(3 downto 0)     --Estado presente
			);
end practica6;

architecture Estructural of practica6 is

	component div_frec is
		Port( reloj : in std_logic;
				div_clk : out std_logic);
	end component;

	component Secuenciador is
		Port( CLK : in STD_LOGIC;
				RESET : in STD_LOGIC;
				ENA : in STD_LOGIC;
				Ins : in STD_LOGIC_VECTOR(1 downto 0);
				nCC : in STD_LOGIC;
				Q : in STD_LOGIC_VECTOR(3 downto 0);
				nPL : out STD_LOGIC;
				nMAP : out STD_LOGIC;
				nVECT : out STD_LOGIC;
				SAL : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	component memory is
		Port( dir : in STD_LOGIC_VECTOR(3 downto 0);
				data : out STD_LOGIC_VECTOR(16 downto 0));
	end component;

	component divisor_datos is
		Port( entrada : in STD_LOGIC_VECTOR(16 downto 0);
				prueba : out STD_LOGIC_VECTOR(1 downto 0);
				VF : out STD_LOGIC;
				MI : out STD_LOGIC_VECTOR(1 downto 0);
				liga : out STD_LOGIC_VECTOR(3 downto 0);
				salidasF : out STD_LOGIC_VECTOR(3 downto 0);
				salidasV : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	component registroMP is
		Port( CLK, RESET, ENA : in STD_LOGIC;
				DATA_IN : in STD_LOGIC_VECTOR(3 downto 0);
				DATA_OUT : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	component registroTrans is
		Port( CLK, RESET, ENA : in STD_LOGIC;
				DATA_IN : in STD_LOGIC_VECTOR(3 downto 0);
				DATA_OUT : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	component registroPrueba is
		Port( CLK, RESET, ENA : in STD_LOGIC;
				DATA_IN : in STD_LOGIC_VECTOR(1 downto 0);
				DATA_OUT : out STD_LOGIC_VECTOR(1 downto 0));
	end component;

	component registroXOR is
		Port( CLK, RESET, ENA : in STD_LOGIC;
				DATA_IN : in STD_LOGIC;
				DATA_OUT : out STD_LOGIC);
	end component;

	component muxEntradas is
		Port( sel : in STD_LOGIC_VECTOR(1 downto 0);
				Q0, Q1, Q2, Q3 : in STD_LOGIC;
				O : out STD_LOGIC);
	end component;

	component muxSalidas is
		Port( sel : in STD_LOGIC;
				E0 : in STD_LOGIC_VECTOR(3 downto 0);
				E1 : in STD_LOGIC_VECTOR(3 downto 0);
				O : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	signal clk_fsm : std_logic;
	signal dir : std_logic_vector(3 downto 0);        --Bus Y: estado presente
	signal palabra_mem : std_logic_vector(16 downto 0);
	signal prueba : std_logic_vector(1 downto 0);
	signal VF : std_logic;
	signal MI : std_logic_vector(1 downto 0);
	signal liga : std_logic_vector(3 downto 0);
	signal salidasF : std_logic_vector(3 downto 0);
	signal salidasV : std_logic_vector(3 downto 0);
	signal nPL, nMAP, nVECT : std_logic;
	signal busD : std_logic_vector(3 downto 0);       --Entrada D compartida (tres estados)
	signal var_sensada : std_logic;
	signal cond : std_logic;                          --XOR(var_sensada, VF)
	signal nCC : std_logic;                           --cond registrada
	signal MI_reg : std_logic_vector(1 downto 0);     --MI registrada

begin

	DivFrec : div_frec
		port map( reloj => CLK,
					 div_clk => clk_fsm);

	Sec : Secuenciador
		port map( CLK => clk_fsm,
					 RESET => RESET,
					 ENA => '0',
					 Ins => MI_reg,
					 nCC => nCC,
					 Q => busD,
					 nPL => nPL,
					 nMAP => nMAP,
					 nVECT => nVECT,
					 SAL => dir);

	mem : memory
		port map( dir => dir,
					 data => palabra_mem);

	divda : divisor_datos
		port map( entrada => palabra_mem,
					 prueba => prueba,
					 VF => VF,
					 MI => MI,
					 liga => liga,
					 salidasF => salidasF,
					 salidasV => salidasV);


	--Los tres origenes comparten la entrada D con salidas de tres estados; la
	--logica interna habilita uno solo con nPL, nMAP o nVECT (activos en bajo).
	--Los registros son indispensables: sin ellos el lazo
	--   edo -> memory -> liga -> busD -> muxDireccion -> edo
	--es puramente combinacional (ModelSim alcanza el limite de iteraciones).
	RegLiga : registroMP
		port map( CLK => clk_fsm, RESET => RESET, ENA => nPL,
					 DATA_IN => liga, DATA_OUT => busD);

	RegTrans : registroTrans
		port map( CLK => clk_fsm, RESET => RESET, ENA => nMAP,
					 DATA_IN => INTRA, DATA_OUT => busD);

	RegInter : registroTrans
		port map( CLK => clk_fsm, RESET => RESET, ENA => nVECT,
					 DATA_IN => INNT, DATA_OUT => busD);

	muxEn : muxEntradas
		port map( sel => prueba,
					 Q0 => X,
					 Q1 => Y,
					 Q2 => INT,
					 Q3 => '0',     --AUX: constante para las transiciones incondicionales
					 O => var_sensada);

	cond <= var_sensada xor VF;

	--El secuenciador opera sobre la palabra del ciclo anterior: MI, la condicion
	--y la direccion de salto van registradas. Ademas de dar un pipeline coherente,
	--registrar MI rompe el lazo combinacional
	--   edo -> memory -> MI -> logica_interna -> muxDireccion -> edo
	RegMI : registroPrueba
		port map( CLK => clk_fsm, RESET => RESET, ENA => '0',
					 DATA_IN => MI, DATA_OUT => MI_reg);

	RegXOR : registroXOR
		port map( CLK => clk_fsm, RESET => RESET, ENA => '0',
					 DATA_IN => cond, DATA_OUT => nCC);

	muxSal : muxSalidas
		port map( sel => var_sensada,
					 E0 => salidasF,
					 E1 => salidasV,
					 O => SAL);

	EDO <= dir;

end Estructural;
