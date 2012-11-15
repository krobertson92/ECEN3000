transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {des_6_1200mv_85c_slow.vo}

vlog -vlog01compat -work work +incdir+C:/Users/Keith\ Robertson/Documents/ECEN3000/DES {C:/Users/Keith Robertson/Documents/ECEN3000/DES/DES_testbench.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneiii_ver -L gate_work -L work -voptargs="+acc"  DES_Testbench

add wave *
view structure
view signals
run -all
