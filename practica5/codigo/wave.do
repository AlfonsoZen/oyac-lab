# Abre ModelSim, File > Change Directory a esta carpeta y ejecuta:  do wave.do
# Deja el waveform listo para capturar la evidencia: contenido de memoria
# (palabra_mem y sus cinco campos) junto al estado presente.

vlib work
vmap work work
vcom -quiet ../memory.vhd
vcom -quiet ../divisor_datos.vhd
vcom -quiet ../mux5.vhd
vcom -quiet ../mux1X2X1.vhd
vcom -quiet ../mux1X2X1_3.vhd
vcom -quiet ../incrementador.vhd
vcom -quiet ../register3.vhd
vcom -quiet ../contador.vhd
vcom -quiet tb_practica5.vhd

vsim work.tb_practica5

delete wave *
add wave -divider "Reloj y reset"
add wave -label CLK   /tb_practica5/CLK
add wave -label RESET /tb_practica5/RESET

add wave -divider "Entradas"
add wave -label X /tb_practica5/X
add wave -label Y /tb_practica5/Y
add wave -label Z /tb_practica5/Z
add wave -label W /tb_practica5/W

add wave -divider "Estado presente (direccion de memoria)"
add wave -label EDO -radix binary /tb_practica5/edo

add wave -divider "Contenido de memoria"
add wave -label PALABRA   -radix binary /tb_practica5/palabra_mem
add wave -label prueba    -radix binary /tb_practica5/prueba
add wave -label VF        /tb_practica5/VF
add wave -label liga      -radix binary /tb_practica5/liga
add wave -label salidas_F -radix binary /tb_practica5/salidas_F
add wave -label salidas_V -radix binary /tb_practica5/salidas_V

add wave -divider "Seleccion y resultado"
add wave -label variable_sensada /tb_practica5/var_sensada
add wave -label CARGA /tb_practica5/carga
add wave -label S1 /tb_practica5/S1
add wave -label S2 /tb_practica5/S2
add wave -label U1 /tb_practica5/U1
add wave -label U2 /tb_practica5/U2

run -all
wave zoom full
