vlib work
vmap work work
vcom -quiet ../logica_interna.vhd ../incrementador.vhd ../registroMP.vhd ../muxDireccion.vhd
vcom -quiet ../registroTrans.vhd ../registroPrueba.vhd ../registroXOR.vhd ../Secuenciador.vhd ../memory.vhd ../divisor_datos.vhd ../muxEntradas.vhd ../muxSalidas.vhd
vcom -quiet tb_practica6.vhd
vsim -c work.tb_practica6
run -all
quit -f
