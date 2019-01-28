onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tcm_tb/lhc_clk
add wave -noupdate /tcm_tb/lhc_rst
add wave -noupdate -radix hexadecimal /tcm_tb/bcres_d
add wave -noupdate -radix hexadecimal /tcm_tb/bx_nr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20630 ps} 0}
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
WaveRestoreZoom {0 ps} {584512 ps}
