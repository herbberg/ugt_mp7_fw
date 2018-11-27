onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal -childformat {{/difference_eta_tb/eg_eta_integer(0) -radix decimal} {/difference_eta_tb/eg_eta_integer(1) -radix decimal}} -expand -subitemconfig {/difference_eta_tb/eg_eta_integer(0) {-radix decimal} /difference_eta_tb/eg_eta_integer(1) {-radix decimal}} /difference_eta_tb/eg_eta_integer
add wave -noupdate -radix decimal -childformat {{/difference_eta_tb/diff_eg_eta(0) -radix decimal -childformat {{/difference_eta_tb/diff_eg_eta(0)(0) -radix decimal} {/difference_eta_tb/diff_eg_eta(0)(1) -radix decimal}}} {/difference_eta_tb/diff_eg_eta(1) -radix decimal -childformat {{/difference_eta_tb/diff_eg_eta(1)(0) -radix decimal} {/difference_eta_tb/diff_eg_eta(1)(1) -radix decimal}}}} -expand -subitemconfig {/difference_eta_tb/diff_eg_eta(0) {-radix decimal -childformat {{/difference_eta_tb/diff_eg_eta(0)(0) -radix decimal} {/difference_eta_tb/diff_eg_eta(0)(1) -radix decimal}} -expand} /difference_eta_tb/diff_eg_eta(0)(0) {-radix decimal} /difference_eta_tb/diff_eg_eta(0)(1) {-radix decimal} /difference_eta_tb/diff_eg_eta(1) {-radix decimal -childformat {{/difference_eta_tb/diff_eg_eta(1)(0) -radix decimal} {/difference_eta_tb/diff_eg_eta(1)(1) -radix decimal}} -expand} /difference_eta_tb/diff_eg_eta(1)(0) {-radix decimal} /difference_eta_tb/diff_eg_eta(1)(1) {-radix decimal}} /difference_eta_tb/diff_eg_eta
add wave -noupdate -radix decimal /difference_eta_tb/CONF
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {80901 ps} 0}
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
