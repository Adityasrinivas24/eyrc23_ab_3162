transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/amuly/Eyantra/task\ 0/Sequence_detector {C:/Users/amuly/Eyantra/task 0/Sequence_detector/sequence_detector.v}

vlog -vlog01compat -work work +incdir+C:/Users/amuly/Eyantra/task\ 0/Sequence_detector {C:/Users/amuly/Eyantra/task 0/Sequence_detector/sequence_detector_test_bench.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  sequence_detector_test_bench

add wave *
view structure
view signals
run -all
