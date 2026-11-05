library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Testbench del secuenciador basico. Instancia la cadena funcional completa
-- manejando el secuenciador con un reloj directo de 10 ns; se omite div_frec,
-- que solo fija la velocidad visible en la tarjeta.
-- INNT = 1100 (vector de interrupcion, estado E12).
-- INTRA = "10" & X & Y, para que el salto de transformacion de E7 caiga en
-- E8..E11 segun la carta.

entity tb_practica6 is
end tb_practica6;

architecture sim of tb_practica6 is
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
	component Secuenciador is
		Port( CLK, RESET, ENA : in STD_LOGIC;
				Ins : in STD_LOGIC_VECTOR(1 downto 0);
				nCC : in STD_LOGIC;
				Q : in STD_LOGIC_VECTOR(3 downto 0);
				nPL, nMAP, nVECT : out STD_LOGIC;
				SAL : out STD_LOGIC_VECTOR(3 downto 0));
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
				E0, E1 : in STD_LOGIC_VECTOR(3 downto 0);
				O : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	signal CLK : std_logic := '0';
	signal RESET : std_logic := '1';
	signal X, Y, INT : std_logic := '0';
	signal edo, liga, busD : std_logic_vector(3 downto 0);
	signal INTRA, INNT : std_logic_vector(3 downto 0);
	signal palabra_mem : std_logic_vector(16 downto 0);
	signal prueba, MI : std_logic_vector(1 downto 0);
	signal VF, var_sensada, cond, nCC : std_logic;
	signal MI_reg : std_logic_vector(1 downto 0);
	signal nPL, nMAP, nVECT : std_logic;
	signal salidasF, salidasV, SAL : std_logic_vector(3 downto 0);

	constant TCLK : time := 10 ns;
	signal fin : boolean := false;
	type vector_t is record
		e : std_logic_vector(2 downto 0);        --X Y INT
		edo_esp : std_logic_vector(3 downto 0);
	end record;
	type lista_t is array (natural range <>) of vector_t;
	constant SECUENCIA : lista_t := (
		(e => "000", edo_esp => "0000"),  --E0  X=0: autolazo
		(e => "100", edo_esp => "0001"),  --E0  X=1: +1 -> E1
		(e => "100", edo_esp => "0010"),  --E1  C -> E2
		(e => "110", edo_esp => "0101"),  --E2  Y=1: liga -> E5
		(e => "110", edo_esp => "0110"),  --E5  C -> E6
		(e => "111", edo_esp => "1100"),  --E6  INT=1: vector -> E12
		(e => "110", edo_esp => "0000"),  --E12 incond -> E0
		(e => "100", edo_esp => "0001"),  --E0  X=1 -> E1
		(e => "100", edo_esp => "0010"),  --E1  C -> E2
		(e => "100", edo_esp => "0011"),  --E2  Y=0: +1 -> E3
		(e => "100", edo_esp => "0100"),  --E3  C -> E4
		(e => "100", edo_esp => "0110"),  --E4  incond -> E6
		(e => "110", edo_esp => "0111"),  --E6  INT=0: +1 -> E7
		(e => "110", edo_esp => "1011"),  --E7  ST con XY=11 -> E11
		(e => "110", edo_esp => "1101"),  --E11 incond -> E13
		(e => "000", edo_esp => "1110"),  --E13 X=0: +1 -> E14
		(e => "000", edo_esp => "0000"),  --E14 incond -> E0
		(e => "100", edo_esp => "0001"),  --E0  X=1 -> E1
		(e => "100", edo_esp => "0010"),  --E1  C -> E2
		(e => "100", edo_esp => "0011"),  --E2  Y=0 -> E3
		(e => "100", edo_esp => "0100"),  --E3  C -> E4
		(e => "100", edo_esp => "0110"),  --E4  incond -> E6
		(e => "000", edo_esp => "0111"),  --E6  INT=0 -> E7
		(e => "000", edo_esp => "1000"),  --E7  ST con XY=00 -> E8
		(e => "000", edo_esp => "1101"),  --E8  incond -> E13
		(e => "000", edo_esp => "1110"),  --E13 X=0 -> E14
		(e => "000", edo_esp => "0000"),  --E14 incond -> E0
		(e => "100", edo_esp => "0001"),  --E0  X=1 -> E1
		(e => "100", edo_esp => "0010"),  --E1  C -> E2
		(e => "100", edo_esp => "0011"),  --E2  Y=0 -> E3
		(e => "100", edo_esp => "0100"),  --E3  C -> E4
		(e => "010", edo_esp => "0110"),  --E4  incond -> E6
		(e => "010", edo_esp => "0111"),  --E6  INT=0 -> E7
		(e => "010", edo_esp => "1001"),  --E7  ST con XY=01 -> E9
		(e => "010", edo_esp => "1101"),  --E9  incond -> E13
		(e => "000", edo_esp => "1110"),  --E13 X=0 -> E14
		(e => "000", edo_esp => "0000"),  --E14 incond -> E0
		(e => "100", edo_esp => "0001"),  --E0  X=1 -> E1
		(e => "100", edo_esp => "0010"),  --E1  C -> E2
		(e => "100", edo_esp => "0011"),  --E2  Y=0 -> E3
		(e => "100", edo_esp => "0100"),  --E3  C -> E4
		(e => "100", edo_esp => "0110"),  --E4  incond -> E6
		(e => "100", edo_esp => "0111"),  --E6  INT=0 -> E7
		(e => "100", edo_esp => "1010"),  --E7  ST con XY=10 -> E10
		(e => "100", edo_esp => "1101"),  --E10 incond -> E13
		(e => "000", edo_esp => "1110"),  --E13 X=0 -> E14
		(e => "000", edo_esp => "0000")   --E14 incond -> E0
	);
begin
	CLK <= not CLK after TCLK/2 when not fin else '0';
	INNT  <= "1100";
	INTRA <= "10" & X & Y;

	UM : memory        port map(dir => edo, data => palabra_mem);
	UD : divisor_datos port map(entrada => palabra_mem, prueba => prueba, VF => VF,
										 MI => MI, liga => liga,
										 salidasF => salidasF, salidasV => salidasV);
	UX : muxEntradas   port map(sel => prueba, Q0 => X, Q1 => Y, Q2 => INT, Q3 => '0',
										 O => var_sensada);
	US : muxSalidas    port map(sel => var_sensada, E0 => salidasF, E1 => salidasV, O => SAL);
	UC : Secuenciador  port map(CLK => CLK, RESET => RESET, ENA => '0', Ins => MI_reg,
										 nCC => nCC, Q => busD, nPL => nPL, nMAP => nMAP,
										 nVECT => nVECT, SAL => edo);

	cond <= var_sensada xor VF;
	RegMI  : registroPrueba port map(CLK=>CLK, RESET=>RESET, ENA=>'0', DATA_IN=>MI,   DATA_OUT=>MI_reg);
	RegXOR : registroXOR    port map(CLK=>CLK, RESET=>RESET, ENA=>'0', DATA_IN=>cond, DATA_OUT=>nCC);
	RegLiga  : registroMP    port map(CLK=>CLK, RESET=>RESET, ENA=>nPL,   DATA_IN=>liga,  DATA_OUT=>busD);
	RegTrans : registroTrans port map(CLK=>CLK, RESET=>RESET, ENA=>nMAP,  DATA_IN=>INTRA, DATA_OUT=>busD);
	RegInter : registroTrans port map(CLK=>CLK, RESET=>RESET, ENA=>nVECT, DATA_IN=>INNT,  DATA_OUT=>busD);

	estimulo : process
		variable errores : integer := 0;
	begin
		RESET <= '0';
		wait until falling_edge(CLK);
		wait until falling_edge(CLK);
		RESET <= '1';
		wait for 1 ns;
		assert edo = "0000" report "FALLO: el reset no dejo la maquina en E0" severity error;

		for i in SECUENCIA'range loop
			X   <= SECUENCIA(i).e(2);
			Y   <= SECUENCIA(i).e(1);
			INT <= SECUENCIA(i).e(0);
			wait until rising_edge(CLK);
			wait for 1 ns;
			if edo /= SECUENCIA(i).edo_esp then
				errores := errores + 1;
				report "FALLO en el paso " & integer'image(i+1) severity error;
			end if;
			wait until falling_edge(CLK);
		end loop;

		if errores = 0 then
			report "=== OK: las 47 transiciones coinciden con la carta ASM ===" severity note;
		else
			report "=== " & integer'image(errores) & " transiciones incorrectas ===" severity error;
		end if;
		fin <= true;
		wait;
	end process;
end sim;
