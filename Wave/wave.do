onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Param de base}
add wave -noupdate /tb/dut/clk
add wave -noupdate /tb/dut/resetn
add wave -noupdate -divider Sel
add wave -noupdate /tb/dut/sel_next_pc
add wave -noupdate /tb/dut/sel_next_ir
add wave -noupdate /tb/dut/sel_next_r0
add wave -noupdate /tb/dut/sel_next_r1
add wave -noupdate /tb/dut/sel_next_r3
add wave -noupdate /tb/dut/sel_address
add wave -noupdate /tb/dut/sel_status
add wave -noupdate /tb/dut/cmd_cmp
add wave -noupdate -divider Registre
add wave -noupdate /tb/dut/prog/r0_next
add wave -noupdate /tb/dut/prog/r1_next
add wave -noupdate /tb/dut/prog/r3_next
add wave -noupdate /tb/dut/prog/pc_next
add wave -noupdate /tb/dut/prog/ir_next
add wave -noupdate /tb/dut/prog/status_next
add wave -noupdate /tb/dut/prog/wait_next
add wave -noupdate /tb/dut/prog/r0_reg
add wave -noupdate /tb/dut/prog/r1_reg
add wave -noupdate /tb/dut/prog/r3_reg
add wave -noupdate /tb/dut/prog/pc_reg
add wave -noupdate /tb/dut/prog/ir_reg
add wave -noupdate /tb/dut/prog/status_reg
add wave -noupdate /tb/dut/prog/wait_reg
add wave -noupdate -divider Debug
add wave -noupdate /tb/dut/mem_address_debug
add wave -noupdate /tb/dut/mem_q_debug
add wave -noupdate -divider {Affichage Sorties}
add wave -noupdate /tb/dut/hex0
add wave -noupdate /tb/dut/hex1
add wave -noupdate /tb/dut/hex2
add wave -noupdate /tb/dut/hex3
add wave -noupdate /tb/dut/hex4
add wave -noupdate /tb/dut/hex5
add wave -noupdate /tb/dut/ledr
add wave -noupdate -divider {Memoire Double}
add wave -noupdate /tb/dut/mem_q
add wave -noupdate /tb/dut/mem_q_debug
add wave -noupdate /tb/dut/mem_address
add wave -noupdate /tb/dut/mem_data
add wave -noupdate /tb/dut/mem_wren
add wave -noupdate -divider {Memoire ecran}
add wave -noupdate /tb/dut/mem_ecran_address_1
add wave -noupdate /tb/dut/mem_ecran_address_2
add wave -noupdate /tb/dut/mem_ecran_wren
add wave -noupdate /tb/dut/mem_ecran_q
add wave -noupdate /tb/dut/mem_ecran_data
add wave -noupdate -divider {Controle ecran}
add wave -noupdate /tb/dut/lt24_reset_n
add wave -noupdate /tb/dut/lt24_cs_n
add wave -noupdate /tb/dut/lt24_rs
add wave -noupdate /tb/dut/lt24_rd_n
add wave -noupdate /tb/dut/lt24_wr_n
add wave -noupdate /tb/dut/lt24_d
add wave -noupdate /tb/dut/lt24_lcd_on
add wave -noupdate /tb/dut/x
add wave -noupdate /tb/dut/y
add wave -noupdate /tb/dut/c
add wave -noupdate -divider FSM
add wave -noupdate /tb/dut/status
add wave -noupdate /tb/dut/opcode
add wave -noupdate /tb/dut/state
add wave -noupdate /tb/dut/wren
add wave -noupdate /tb/dut/cmd_cmp
add wave -noupdate /tb/dut/end_tempo
add wave -noupdate /tb/dut/fsm/current_state
add wave -noupdate /tb/dut/fsm/next_state
add wave -noupdate -divider Random
add wave -noupdate /tb/dut/random/seed
add wave -noupdate /tb/dut/random/cmd_random
add wave -noupdate /tb/dut/random/result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {206789 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {4886 ns}
