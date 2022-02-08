if [file exists work]  {
  vdel -lib work -all
}

vlib work
vmap work work 

set liste {
bin2bcd
}

foreach el $liste {
vcom -93 -cover bcesx ../rtl/$el.vhd
}
vcom -93 -cover bcesx tb_bin2bcd.vhd

vsim  -novopt tb_bin2bcd
source chrono.tcl

run 100 ns


