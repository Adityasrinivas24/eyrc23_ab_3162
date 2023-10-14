transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/asrin/Downloads/t1a_fs_pwm/t1a_fs_pwm {C:/Users/asrin/Downloads/t1a_fs_pwm/t1a_fs_pwm/t1a_fs_pwm_bdf.v}
vlog -vlog01compat -work work +incdir+C:/Users/asrin/Downloads/t1a_fs_pwm/t1a_fs_pwm {C:/Users/asrin/Downloads/t1a_fs_pwm/t1a_fs_pwm/pwm_generator.v}
vlog -vlog01compat -work work +incdir+C:/Users/asrin/Downloads/t1a_fs_pwm/t1a_fs_pwm {C:/Users/asrin/Downloads/t1a_fs_pwm/t1a_fs_pwm/frequency_scaling.v}

vlog -vlog01compat -work work +incdir+C:/Users/asrin/Downloads/t1a_fs_pwm/t1a_fs_pwm/simulation/modelsim {C:/Users/asrin/Downloads/t1a_fs_pwm/t1a_fs_pwm/simulation/modelsim/tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run 40 us
