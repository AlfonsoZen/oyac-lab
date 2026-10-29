library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Testbench del direccionamiento implicito.
-- Instancia la cadena funcional completa (memoria, divisor de datos, selector de
-- variable, XNOR de carga, contador y selector de salidas) manejando el contador
-- con un reloj directo de 10 ns. Se omite div_frec a proposito: solo fija la
-- velocidad visible en la tarjeta y simularlo exigiria 2^25 ciclos por flanco.

entity tb_practica5 is
end tb_practica5;

architecture sim of tb_practica5 is

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
				Q0, Q1, Q2, Q3, aux : in STD_LOGIC;
				O : out STD_LOGIC);
	end component;

	component mux1X2X1 is
		Port( sel : in STD_LOGIC;
				E0, E1 : in STD_LOGIC_VECTOR(3 downto 0);
				O : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	component contador is
		Port( Carga : in STD_LOGIC;
				Liga : in STD_LOGIC_VECTOR(2 downto 0);
				CLK, RESET : in STD_LOGIC;
				SAL : out STD_LOGIC_VECTOR(2 downto 0));
	end component;

	signal CLK : std_logic := '0';
	signal RESET : std_logic := '1';
	signal X, Y, Z, W : std_logic := '0';

	signal edo : std_logic_vector(2 downto 0);
	signal palabra_mem : std_logic_vector(14 downto 0);
	signal prueba : std_logic_vector(2 downto 0);
	signal VF : std_logic;
	signal liga : std_logic_vector(2 downto 0);
	signal salidas_F, salidas_V, salidas : std_logic_vector(3 downto 0);
	signal var_sensada, carga : std_logic;
	signal S1, S2, U1, U2 : std_logic;

	constant TCLK : time := 10 ns;
	signal fin : boolean := false;

	type vector_t is record
		e : std_logic_vector(3 downto 0);        --X Y Z W
		edo_esp : std_logic_vector(2 downto 0);
		sal_esp : std_logic_vector(3 downto 0);  --S1 S2 U1 U2 durante el estado previo
	end record;
	type lista_t is array (natural range <>) of vector_t;

	-- sal_esp es lo que deben valer las salidas MIENTRAS se aplica el vector,
	-- es decir antes del flanco que lleva a edo_esp.
	constant SECUENCIA : lista_t := (
		(e => "1000", edo_esp => "100", sal_esp => "1100"), --E0 X=1: S1 S2, carga E4
		(e => "0000", edo_esp => "101", sal_esp => "1100"), --E4 Y=0: S1 S2, +1 -> E5
		(e => "0000", edo_esp => "110", sal_esp => "0011"), --E5 X=0: U1 U2, +1 -> E6
		(e => "0000", edo_esp => "000", sal_esp => "1111"), --E6 incondicional: todas, carga E0
		(e => "0000", edo_esp => "001", sal_esp => "1010"), --E0 X=0: S1 U1, +1 -> E1
		(e => "0000", edo_esp => "001", sal_esp => "0001"), --E1 Y=0: U2, carga E1 (autolazo)
		(e => "0100", edo_esp => "010", sal_esp => "0101"), --E1 Y=1: U2 S2, +1 -> E2
		(e => "0000", edo_esp => "011", sal_esp => "1010"), --E2 Z=0: S1 U1, +1 -> E3
		(e => "0000", edo_esp => "000", sal_esp => "0101"), --E3 incondicional: S2 U2, carga E0
		(e => "0000", edo_esp => "001", sal_esp => "1010"), --E0 X=0: +1 -> E1
		(e => "0100", edo_esp => "010", sal_esp => "0101"), --E1 Y=1: +1 -> E2
		(e => "0010", edo_esp => "000", sal_esp => "1011"), --E2 Z=1: S1 U1 U2, carga E0
		(e => "1000", edo_esp => "100", sal_esp => "1100"), --E0 X=1: carga E4
		(e => "0100", edo_esp => "110", sal_esp => "1110"), --E4 Y=1: S1 S2 U1, carga E6
		(e => "0000", edo_esp => "000", sal_esp => "1111"), --E6 incondicional: carga E0
		(e => "1000", edo_esp => "100", sal_esp => "1100"), --E0 X=1: carga E4
		(e => "0000", edo_esp => "101", sal_esp => "1100"), --E4 Y=0: +1 -> E5
		(e => "1000", edo_esp => "000", sal_esp => "1011")  --E5 X=1: U1 U2 S1, carga E0
	);

begin

	CLK <= not CLK after TCLK/2 when not fin else '0';

	UM : memory        port map(dir => edo, data => palabra_mem);
	UD : divisor_datos port map(entrada => palabra_mem, prueba => prueba, VF => VF,
										 liga => liga, salidas_F => salidas_F, salidas_V => salidas_V);
	UX : mux5          port map(sel => prueba, Q0 => X, Q1 => Y, Q2 => Z, Q3 => W,
										 aux => '0', O => var_sensada);
	US : mux1X2X1      port map(sel => var_sensada, E0 => salidas_F, E1 => salidas_V,
										 O => salidas);
	UC : contador      port map(Carga => carga, Liga => liga, CLK => CLK, RESET => RESET,
										 SAL => edo);

	carga <= var_sensada xnor VF;

	S1 <= salidas(3);
	S2 <= salidas(2);
	U1 <= salidas(1);
	U2 <= salidas(0);

	estimulo : process
		variable errores : integer := 0;
	begin
		RESET <= '0';
		wait until falling_edge(CLK);
		wait until falling_edge(CLK);
		RESET <= '1';                       --Se libera en flanco de bajada:
		wait for 1 ns;                      --el siguiente flanco de subida es
		assert edo = "000"                  --la primera transicion real.
			report "FALLO: el reset no dejo la maquina en E0" severity error;

		for i in SECUENCIA'range loop
			X <= SECUENCIA(i).e(3);
			Y <= SECUENCIA(i).e(2);
			Z <= SECUENCIA(i).e(1);
			W <= SECUENCIA(i).e(0);
			wait for 1 ns;
			if salidas /= SECUENCIA(i).sal_esp then
				errores := errores + 1;
				report "FALLO de salidas en el paso " & integer'image(i+1) severity error;
			end if;
			wait until rising_edge(CLK);
			wait for 1 ns;
			if edo /= SECUENCIA(i).edo_esp then
				errores := errores + 1;
				report "FALLO de estado en el paso " & integer'image(i+1) severity error;
			end if;
			wait until falling_edge(CLK);
		end loop;

		if errores = 0 then
			report "=== OK: las 18 transiciones y sus salidas coinciden con la carta ASM ===" severity note;
		else
			report "=== " & integer'image(errores) & " comprobaciones fallidas ===" severity error;
		end if;

		fin <= true;
		wait;
	end process;

end sim;
