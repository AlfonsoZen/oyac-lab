# Abre ModelSim, haz File > Change Directory a esta carpeta y ejecuta:  do wave.do
# Deja el waveform listo para capturar la evidencia del punto 5 del manual:
# contenido de memoria (palabra_mem y sus campos) ademas del estado presente.

vlib work
vmap work work
vcom -quiet ../memory.vhd
vcom -quiet ../divisor_datos.vhd
vcom -quiet ../mux4.vhd
vcom -quiet ../mux2_3.vhd
vcom -quiet ../mux2_4.vhd
vcom -quiet ../register3.vhd
vcom -quiet tb_practica4.vhd

vsim work.tb_practica4

delete wave *
add wave -divider "Reloj y reset"
add wave -label CLK       /tb_practica4/CLK
add wave -label RESET     /tb_practica4/RESET

add wave -divider "Entradas"
add wave -label Q1 /tb_practica4/Q1
add wave -label Q2 /tb_practica4/Q2
add wave -label Q3 /tb_practica4/Q3
add wave -label Q4 /tb_practica4/Q4

add wave -divider "Estado presente (direccion de memoria)"
add wave -label EDO -radix binary /tb_practica4/EDO

add wave -divider "Contenido de memoria"
add wave -label PALABRA   -radix binary /tb_practica4/palabra_mem
add wave -label prueba    -radix binary /tb_practica4/prueba
add wave -label liga_F    -radix binary /tb_practica4/liga_f
add wave -label liga_V    -radix binary /tb_practica4/liga_v
add wave -label salidas_F -radix binary /tb_practica4/salidas_f
add wave -label salidas_V -radix binary /tb_practica4/salidas_v

add wave -divider "Seleccion y resultado"
add wave -label entrada_sensada /tb_practica4/sel_entrada
add wave -label liga -radix binary /tb_practica4/liga
add wave -label S1 /tb_practica4/S1
add wave -label S2 /tb_practica4/S2
add wave -label S3 /tb_practica4/S3
add wave -label S4 /tb_practica4/S4

run -all
wave zoom full
