/*    00  01  11  10
 000 NOT XOR AND  OR
 001 SUB ADDr RL  RR
 011 NOP NOP RST RST
 010 DEC INC  ST  LDr
 110 --- --- ---  LDi
 111 --- --- --- ---
 101 --- ADDi--- ---
 100 --- --- --- ---
 (ALU default - NOP)
*/ //instruction set
`define NOT		5'b00000
`define XOR		5'b00001
`define OR		5'b00010
`define AND		5'b00011
`define SUB		5'b00100
`define ADDr	5'b00101
`define RR		5'b00110
`define RL		5'b00111
`define DEC		5'b01000
`define INC		5'b01001
`define LDr		5'b01010
`define ST		5'b01011
`define NOP		5'b0110x
`define RST		5'b0111x

`define ADDi	5'b10101
`define LDi		5'b11010
