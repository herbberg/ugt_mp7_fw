onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /conversions_tb/CONF
add wave -noupdate -radix hexadecimal /conversions_tb/dut/obj
add wave -noupdate -radix hexadecimal /conversions_tb/dut/pt
add wave -noupdate -radix hexadecimal /conversions_tb/dut/eta
add wave -noupdate -radix hexadecimal /conversions_tb/dut/phi
add wave -noupdate -radix hexadecimal /conversions_tb/dut/iso
add wave -noupdate -radix hexadecimal /conversions_tb/dut/qual
add wave -noupdate -radix hexadecimal /conversions_tb/dut/charge
add wave -noupdate -radix hexadecimal /conversions_tb/dut/pt_vector
add wave -noupdate -radix decimal /conversions_tb/dut/eta_integer
add wave -noupdate -radix decimal /conversions_tb/dut/phi_integer
add wave -noupdate -radix decimal /conversions_tb/dut/cos_phi
add wave -noupdate -radix decimal /conversions_tb/dut/sin_phi
add wave -noupdate -radix decimal /conversions_tb/dut/conv_2_muon_eta_integer
add wave -noupdate -radix decimal /conversions_tb/dut/conv_2_muon_phi_integer
add wave -noupdate -radix decimal /conversions_tb/dut/conv_mu_cos_phi
add wave -noupdate -radix decimal /conversions_tb/dut/conv_mu_sin_phi
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
