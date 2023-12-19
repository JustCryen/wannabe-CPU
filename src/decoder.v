`timescale 1ps/1ps

module instruction_decoder #(
	parameter UNDEFINED = 0,
	parameter CNTR_WIDTH = 0,
	parameter ADDR_WIDTH = 0,
	parameter REG_BIT_CNT = 0,
	parameter DATA_WIDTH = 0,
	parameter COMBINED_DATA = ADDR_WIDTH+UNDEFINED+DATA_WIDTH
)(
	input	clk,
	input	[COMBINED_DATA-1:0]	data_in,	//24b
//	input	[CNTR_WIDTH-1:0] cin,
	output	[ADDR_WIDTH-1:0] opcode,		//5b <opc>[reg][dat]
//	output	reg [CNTR_WIDTH-1:0] cout,
	output	[REG_BIT_CNT-1:0] reg_sel,
	output	jmp,
	output	rst_f,
	output	load,		//links to accu
	output	store		//links to regfile
);

//	wire [CNTR_WIDTH-1:0] jmp_addr;

	assign opcode = data_in[COMBINED_DATA-1:COMBINED_DATA-ADDR_WIDTH];
	assign reg_sel = data_in[COMBINED_DATA-ADDR_WIDTH-UNDEFINED-1:DATA_WIDTH-REG_BIT_CNT];
//	assign jmp_addr = data_in[COMBINED_DATA-ADDR_WIDTH-UNDEFINED-1:DATA_WIDTH-CNTR_WIDTH];

	assign				{rst_f, load, store, jmp} = 
		opcode == `JMP ? {1'b1, 1'b0, 1'b0, 1'b1}:
		//opcode == `JEZ ? {1'b1, 1'b0, 1'b0, 1'b1}:
		//opcode == `JNZ ? {1'b1, 1'b0, 1'b0, 1'b1}:
		opcode == `RST ? {1'b0, 1'b0, 1'b0, 1'b0}:
		opcode == `NOP ? {1'b1, 1'b0, 1'b0, 1'b0}:
		opcode == `ST  ? {1'b1, 1'b0, 1'b1, 1'b0}:
		{1'b1, 1'b1, 1'b0, 1'b0};

endmodule
