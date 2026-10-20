library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Testbench del direccionamiento entrada-estado.
--
-- Instancia la cadena funcional completa (memoria, divisor de datos, selector de
-- entradas y los dos multiplexores de 2 a 1, mas el registro de estado) manejando
-- el registro con un reloj directo de 10 ns. Se omite div_frec a proposito: ese
-- modulo solo fija la velocidad visible en la tarjeta (~1 s por transicion) y
-- simularlo exigiria 2^25 ciclos por flanco.
--
-- La secuencia recorre los 9 estados y ambas ramas de cada decision, incluidas las
-- cuatro salidas condicionales. Cada transicion se comprueba con assert.

entity tb_practica4 is
end tb_practica4;

architecture sim of tb_practica4 is

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
				Q1, Q2, Q3, Q4 : in STD_LOGIC;
				O : out STD_LOGIC);
	end component;

	component mux2_3 is
		Port( sel : in STD_LOGIC;
				liga_f, liga_v : in STD_LOGIC_VECTOR(3 downto 0);
				O : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	component mux2_4 is
		Port( sel : in STD_LOGIC;
				salidas_f, salidas_v : in STD_LOGIC_VECTOR(3 downto 0);
				O : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	component register3 is
		Port( CLK, RESET : in STD_LOGIC;
				DATA_IN : in STD_LOGIC_VECTOR(3 downto 0);
				DATA_OUT : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	signal CLK : std_logic := '0';
	signal RESET : std_logic := '1';
	signal Q1, Q2, Q3, Q4 : std_logic := '0';

	signal EDO : std_logic_vector(3 downto 0);
	signal palabra_mem : std_logic_vector(17 downto 0);
	signal prueba : std_logic_vector(1 downto 0);
	signal liga_f, liga_v, liga : std_logic_vector(3 downto 0);
	signal salidas_f, salidas_v, salidas : std_logic_vector(3 downto 0);
	signal sel_entrada : std_logic;
	signal S1, S2, S3, S4 : std_logic;

	constant TCLK : time := 10 ns;
	signal fin : boolean := false;

	type vector_t is record
		q : std_logic_vector(3 downto 0);   --Q1 Q2 Q3 Q4
		edo_esp : std_logic_vector(3 downto 0);
	end record;
	type lista_t is array (natural range <>) of vector_t;

	constant SECUENCIA : lista_t := (
		(q => "0000", edo_esp => "0000"),  --EST0 con Q1=0: autolazo
		(q => "1000", edo_esp => "0001"),  --EST0 con Q1=1 -> EST1
		(q => "1000", edo_esp => "0010"),  --EST1 con Q2=0 -> EST2 (cond. S3*)
		(q => "1000", edo_esp => "0010"),  --EST2 con Q3=0: autolazo
		(q => "1010", edo_esp => "0100"),  --EST2 con Q3=1 -> EST4
		(q => "0010", edo_esp => "0110"),  --EST4 con Q1=0 -> EST6 (cond. S1)
		(q => "0010", edo_esp => "0111"),  --EST6 con Q3=1 -> EST7 (cond. S4*)
		(q => "0010", edo_esp => "0111"),  --EST7 con Q4=0: autolazo
		(q => "0011", edo_esp => "1000"),  --EST7 con Q4=1 -> EST8
		(q => "0011", edo_esp => "0000"),  --EST8 sin prueba -> EST0
		(q => "1011", edo_esp => "0001"),  --EST0 con Q1=1 -> EST1
		(q => "1111", edo_esp => "0011"),  --EST1 con Q2=1 -> EST3 (cond. S2)
		(q => "1110", edo_esp => "0101"),  --EST3 con Q4=0 -> EST5
		(q => "1010", edo_esp => "0101"),  --EST5 con Q2=0: autolazo
		(q => "1110", edo_esp => "0110"),  --EST5 con Q2=1 -> EST6
		(q => "1100", edo_esp => "0000"),  --EST6 con Q3=0 -> EST0
		(q => "1100", edo_esp => "0001"),  --EST0 con Q1=1 -> EST1
		(q => "1100", edo_esp => "0011"),  --EST1 con Q2=1 -> EST3
		(q => "1101", edo_esp => "0100"),  --EST3 con Q4=1 -> EST4
		(q => "1101", edo_esp => "0111"),  --EST4 con Q1=1 -> EST7
		(q => "1101", edo_esp => "1000"),  --EST7 con Q4=1 -> EST8
		(q => "1101", edo_esp => "0000")   --EST8 sin prueba -> EST0
	);

begin

	CLK <= not CLK after TCLK/2 when not fin else '0';

	U1 : memory        port map(dir => EDO, data => palabra_mem);
	U2 : divisor_datos port map(entrada => palabra_mem, prueba => prueba,
										 liga_f => liga_f, liga_v => liga_v,
										 salidas_f => salidas_f, salidas_v => salidas_v);
	U3 : mux4          port map(sel => prueba, Q1 => Q1, Q2 => Q2, Q3 => Q3, Q4 => Q4,
										 O => sel_entrada);
	U4 : mux2_3        port map(sel => sel_entrada, liga_f => liga_f, liga_v => liga_v,
										 O => liga);
	U5 : mux2_4        port map(sel => sel_entrada, salidas_f => salidas_f,
										 salidas_v => salidas_v, O => salidas);
	U6 : register3     port map(CLK => CLK, RESET => RESET, DATA_IN => liga, DATA_OUT => EDO);

	S1 <= salidas(3);
	S2 <= salidas(2);
	S3 <= salidas(1);
	S4 <= salidas(0);

	estimulo : process
		variable errores : integer := 0;
	begin
		RESET <= '0';                       --Reset asincrono activo en bajo
		wait for 2*TCLK;
		RESET <= '1';
		wait until falling_edge(CLK);
		assert EDO = "0000"
			report "FALLO: el reset no dejo la maquina en EST0" severity error;

		for i in SECUENCIA'range loop
			Q1 <= SECUENCIA(i).q(3);
			Q2 <= SECUENCIA(i).q(2);
			Q3 <= SECUENCIA(i).q(1);
			Q4 <= SECUENCIA(i).q(0);
			wait until rising_edge(CLK);
			wait for 1 ns;
			if EDO /= SECUENCIA(i).edo_esp then
				errores := errores + 1;
				report "FALLO en el paso " & integer'image(i+1) severity error;
			end if;
			wait until falling_edge(CLK);
		end loop;

		if errores = 0 then
			report "=== OK: las 22 transiciones coinciden con la carta ASM ===" severity note;
		else
			report "=== " & integer'image(errores) & " transiciones incorrectas ===" severity error;
		end if;

		fin <= true;
		wait;
	end process;

end sim;
