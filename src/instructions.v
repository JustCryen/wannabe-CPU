/*    00  01  11  10
 000 NOP XOR AND  OR
 001 SUBrADDr RL  RR
 011 NOT NOT RST RST
 010 DEC INC  ST LDr
 110 JMP CAL RET LDi
 111 --- --- --- ---
 101 SUB1ADDi SL  SR
 100 JEZ JNZ JGZ JLZ
 (ALU default - NOP)
*/ //instruction set
`define NOP	5'b00000
`define XOR	5'b00001
`define OR	5'b00010
`define AND	5'b00011
`define SUBr	5'b00100
`define ADDr	5'b00101
`define RR	5'b00110
`define RL	5'b00111
`define DEC	5'b01000
`define INC	5'b01001
`define LDr	5'b01010
`define ST	5'b01011
`define NOT	5'b0110x
`define RST	5'b0111x

`define JEZ	5'b10000
`define JNZ	5'b10001
`define JLZ	5'b10010
`define JGZ	5'b10011
`define SUBi	5'b10100
`define ADDi	5'b10101
`define SR	5'b10110
`define SL	5'b10111

`define JMP	5'b11000
`define CAL	5'b11001
`define LDi	5'b11010
`define RET	5'b11011
