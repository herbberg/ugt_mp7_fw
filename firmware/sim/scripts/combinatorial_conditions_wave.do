onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /combinatorial_conditions_tb/CONF
add wave -noupdate -radix hexadecimal /combinatorial_conditions_tb/lhc_clk
add wave -noupdate -radix hexadecimal /combinatorial_conditions_tb/dut/pt
add wave -noupdate -radix hexadecimal /combinatorial_conditions_tb/dut/eta_w1
add wave -noupdate -radix hexadecimal /combinatorial_conditions_tb/dut/eta_w2
add wave -noupdate -radix hexadecimal /combinatorial_conditions_tb/dut/eta_w3
add wave -noupdate -radix hexadecimal /combinatorial_conditions_tb/dut/eta_w4
add wave -noupdate -radix hexadecimal /combinatorial_conditions_tb/dut/eta_w5
add wave -noupdate -radix hexadecimal /combinatorial_conditions_tb/dut/phi_w1
add wave -noupdate -radix hexadecimal /combinatorial_conditions_tb/dut/phi_w2
add wave -noupdate -radix hexadecimal /combinatorial_conditions_tb/dut/iso
add wave -noupdate -radix hexadecimal /combinatorial_conditions_tb/dut/qual
add wave -noupdate -radix hexadecimal /combinatorial_conditions_tb/dut/charge
add wave -noupdate -radix hexadecimal /combinatorial_conditions_tb/dut/tbpt
add wave -noupdate -radix hexadecimal /combinatorial_conditions_tb/dut/charge_corr_double
add wave -noupdate -radix hexadecimal /combinatorial_conditions_tb/dut/charge_corr_triple
add wave -noupdate -radix hexadecimal /combinatorial_conditions_tb/dut/charge_corr_quad
add wave -noupdate -radix hexadecimal /combinatorial_conditions_tb/dut/cond_o
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
