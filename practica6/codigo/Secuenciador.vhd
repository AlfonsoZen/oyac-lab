library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Secuenciador basico (reproduce Secuenciador.bdf).
--
-- El bus Y (SAL) es la direccion del estado siguiente y sale del muxDireccion:
--   selector = '0' -> la aporta el registro de microprograma (uPC)
--   selector = '1' -> la aporta la entrada D (bus Q), que viene del registro
--                     de liga, del de transformacion o del de interrupciones
--                     segun cual habilite la logica interna con nPL/nMAP/nVECT.
-- La direccion que sale del multiplexor se incrementa en uno y se carga en el
-- uPC en el siguiente ciclo de reloj, tal como describe el manual.

entity Secuenciador is
	Port( CLK : in STD_LOGIC;
			RESET : in STD_LOGIC;
			ENA : in STD_LOGIC;
			Ins : in STD_LOGIC_VECTOR(1 downto 0);   --Microinstruccion (MI)
			nCC : in STD_LOGIC;                      --Condicion, activa en bajo
			Q : in STD_LOGIC_VECTOR(3 downto 0);     --Entrada D: direccion de salto
			nPL : out STD_LOGIC;                     --Habilita el registro de liga
			nMAP : out STD_LOGIC;                    --Habilita el registro de transformacion
			nVECT : out STD_LOGIC;                   --Habilita el registro de interrupciones
			SAL : out STD_LOGIC_VECTOR(3 downto 0)   --Bus Y: direccion del estado siguiente
			);
end Secuenciador;

architecture Estructural of Secuenciador is

	component logica_interna is
		Port( instruccion : in STD_LOGIC_VECTOR(1 downto 0);
				nCC : in STD_LOGIC;
				selector : out STD_LOGIC;
				nPL : out STD_LOGIC;
				nMAP : out STD_LOGIC;
				nVECT : out STD_LOGIC);
	end component;

	component registroMP is
		Port( CLK : in STD_LOGIC;
				RESET : in STD_LOGIC;
				ENA : in STD_LOGIC;
				DATA_IN : in STD_LOGIC_VECTOR(3 downto 0);
				DATA_OUT : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	component incrementador is
		Port( entrada : in STD_LOGIC_VECTOR(3 downto 0);
				salida : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	component muxDireccion is
		Port( sel : in STD_LOGIC;
				E0 : in STD_LOGIC_VECTOR(3 downto 0);
				E1 : in STD_LOGIC_VECTOR(3 downto 0);
				sal : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	signal selector : std_logic;
	signal upc : std_logic_vector(3 downto 0);        --Salida del uPC
	signal dir_sig : std_logic_vector(3 downto 0);    --Salida del muxDireccion (bus Y)
	signal incremento : std_logic_vector(3 downto 0); --dir_sig + 1

begin

	LogIn : logica_interna
		port map( instruccion => Ins,
					 nCC => nCC,
					 selector => selector,
					 nPL => nPL,
					 nMAP => nMAP,
					 nVECT => nVECT);

	muxDir : muxDireccion
		port map( sel => selector,
					 E0 => upc,        --Paso contiguo
					 E1 => Q,          --Salto por la entrada D
					 sal => dir_sig);

	Inc : incrementador
		port map( entrada => dir_sig,
					 salida => incremento);

	MicroPC : registroMP
		port map( CLK => CLK,
					 RESET => RESET,
					 ENA => ENA,
					 DATA_IN => incremento,
					 DATA_OUT => upc);

	SAL <= dir_sig;

end Estructural;
