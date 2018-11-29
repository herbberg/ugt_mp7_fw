onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /correlation_conditions_tb/CONF
add wave -noupdate -radix hexadecimal /correlation_conditions_tb/lhc_clk
add wave -noupdate -radix binary /correlation_conditions_tb/pt_1
add wave -noupdate -radix binary /correlation_conditions_tb/pt_2
add wave -noupdate -radix binary -childformat {{/correlation_conditions_tb/deta(11) -radix binary} {/correlation_conditions_tb/deta(10) -radix binary} {/correlation_conditions_tb/deta(9) -radix binary} {/correlation_conditions_tb/deta(8) -radix binary} {/correlation_conditions_tb/deta(7) -radix binary} {/correlation_conditions_tb/deta(6) -radix binary} {/correlation_conditions_tb/deta(5) -radix binary} {/correlation_conditions_tb/deta(4) -radix binary} {/correlation_conditions_tb/deta(3) -radix binary} {/correlation_conditions_tb/deta(2) -radix binary} {/correlation_conditions_tb/deta(1) -radix binary} {/correlation_conditions_tb/deta(0) -radix binary}} -expand -subitemconfig {/correlation_conditions_tb/deta(11) {-radix binary} /correlation_conditions_tb/deta(10) {-radix binary} /correlation_conditions_tb/deta(9) {-radix binary} /correlation_conditions_tb/deta(8) {-radix binary} /correlation_conditions_tb/deta(7) {-radix binary} /correlation_conditions_tb/deta(6) {-radix binary} /correlation_conditions_tb/deta(5) {-radix binary} /correlation_conditions_tb/deta(4) {-radix binary} /correlation_conditions_tb/deta(3) {-radix binary} /correlation_conditions_tb/deta(2) {-radix binary} /correlation_conditions_tb/deta(1) {-radix binary} /correlation_conditions_tb/deta(0) {-radix binary}} /correlation_conditions_tb/deta
add wave -noupdate -radix binary /correlation_conditions_tb/dut/cond_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {184253 ps} 0}
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
WaveRestoreZoom {0 ps} {292256 ps}
