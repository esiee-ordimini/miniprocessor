MOV R1, #temp_1
LDRB R0, [R1]
MOV R1, #var_i
STRB R0, [R1]

MOV R1, #temp_2
LDRB R0, [R1]
MOV R1, #var_in
STRB R0, [R1]

startwhile1
MOV R1, #var_i
LDRB R0, [R1]
MOV R1, #temp_3
LDRB R3, [R1]
CMP R0, R3
MOV R1, #const_1
LDRB R0, [R1]
BCC condtrue2
MOV R1, #const_0
LDRB R0, [R1]
condtrue2
MOV R1, #temp_4
STRB R0, [R1]

MOV R1, #temp_4
LDRB R0, [R1]
MOV R1, #const_1
LDRB R3, [R1]
CMP R0, R3
BNE endwhile1
MOV R1, #0x400
LDRB R0, [R1]
MOV R1, #var_in
STRB R0, [R1]

MOV R1, #var_in
LDRB R0, [R1]
MOV R1, #temp_5
LDRB R3, [R1]
CMP R0, R3
MOV R1, #const_1
LDRB R0, [R1]
BEQ condtrue3
MOV R1, #const_0
LDRB R0, [R1]
condtrue3
MOV R1, #temp_6
STRB R0, [R1]

MOV R1, #temp_7
LDRB R3, [R1]
MOV R1, #var_i
LDRB R0, [R1]
MOV R1, #0x200
ADD R1, R1, R0
MOV R0, R3
STRB R0, [R1]
MOV R1, #temp_6
LDRB R0, [R1]
MOV R1, #const_1
LDRB R3, [R1]
CMP R0, R3
BNE else4
MOV R1, #temp_8
LDRB R3, [R1]
MOV R1, #var_i
LDRB R0, [R1]
MOV R1, #0x200
ADD R1, R1, R0
MOV R0, R3
STRB R0, [R1]
B ifend4
else4
MOV R1, #temp_9
LDRB R3, [R1]
MOV R1, #var_i
LDRB R0, [R1]
MOV R1, #0x200
ADD R1, R1, R0
MOV R0, R3
STRB R0, [R1]
ifend4
MOV R1, #var_i
LDRB R0, [R1]
MOV R1, #temp_10
LDRB R3, [R1]
ADD R0, R0, R3
MOV R1, #temp_11
STRB R0, [R1]

MOV R1, #temp_11
LDRB R0, [R1]
MOV R1, #var_i
STRB R0, [R1]

WAIT #0x64
B startwhile1
endwhile1
endprog
B endprog

const_1 DCB 0x1
const_0 DCB 0x0
temp_1 DCB 0x0
temp_2 DCB 0x0
temp_3 DCB 0x12C
temp_4 DCB 0x0
temp_5 DCB 0x1
temp_6 DCB 0x0
temp_7 DCB 0x38
temp_8 DCB 0x7
temp_9 DCB 0x38
temp_10 DCB 0x1
temp_11 DCB 0x0
var_i DCB 0x0
var_in DCB 0x0
