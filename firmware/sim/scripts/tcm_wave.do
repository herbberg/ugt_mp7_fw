onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tcm_tb/lhc_clk
add wave -noupdate /tcm_tb/lhc_rst
add wave -noupdate -radix hexadecimal /tcm_tb/bcres_d
add wave -noupdate /tcm_tb/bcres_d_FDL
add wave -noupdate /tcm_tb/oc0
add wave -noupdate /tcm_tb/start
add wave -noupdate /tcm_tb/ec0
add wave -noupdate /tcm_tb/l1a
add wave -noupdate -radix unsigned /tcm_tb/dut/l.internal_bx_nr
add wave -noupdate -radix unsigned /tcm_tb/dut/l.bx_nr_chk
add wave -noupdate -radix unsigned /tcm_tb/bx_nr
add wave -noupdate -radix unsigned /tcm_tb/bx_nr_d_fdl
add wave -noupdate -radix decimal /tcm_tb/orbit_nr
add wave -noupdate -radix decimal /tcm_tb/dut/luminosity_seg_nr
add wave -noupdate -radix unsigned /tcm_tb/dut/event_nr
add wave -noupdate -radix unsigned /tcm_tb/dut/trigger_nr
add wave -noupdate /tcm_tb/dut/start_lumisection_int
add wave -noupdate /tcm_tb/dut/start_lumisection
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {21000 ps} 0} {{Cursor 2} {2000 ps} 0} {{Cursor 3} {3568000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 329
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {42000384 ps}
