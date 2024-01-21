`timescale 1ps/1ps

module instruction_decoder #(
	parameter UNDEFINED = 0,
	parameter CNTR_WIDTH = 0,
	parameter ADDR_WIDTH = 0,
	parameter REG_BIT_CNT = 0,
	parameter DATA_WIDTH = 0,
	parameter COMBINED_DATA = ADDR_WIDTH+UNDEFINED+DATA_WIDTH
)(
	input	zero_f,
	input	ls_z_f,
	input	gr_z_f,
	input	[COMBINED_DATA-1:0]	rom_data,	//24b
	output	[ADDR_WIDTH-1:0] opcode,		//5b <opc>[reg][dat]
	output	[REG_BIT_CNT-1:0] reg_sel,
	output	jmp,
	output	cal_f,
	output	ret_f,
	output	rst_f,
	output	load,		//links to accu
	output	store		//links to regfile
);

	assign opcode = rom_data[COMBINED_DATA-1:COMBINED_DATA-ADDR_WIDTH];
	assign reg_sel = rom_data[COMBINED_DATA-ADDR_WIDTH-UNDEFINED-1:DATA_WIDTH-REG_BIT_CNT];

	assign						  {rst_f, load, store, jmp, cal_f, ret_f} = 
		opcode == `CAL			 ? {1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0}:
		opcode == `RET			 ? {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1}:
		opcode == `JMPi			 ? {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0}:
		opcode == `JMPr			 ? {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0}:
		opcode == `JEZ &  zero_f ? {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0}:
		opcode == `JNZ & !zero_f ? {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0}:
		opcode == `JLZ &  ls_z_f ? {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0}:
		opcode == `JGZ &  gr_z_f ? {1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0}:
		opcode == `RST			 ? {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}:
		opcode == `NOP			 ? {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}:
		opcode == `ST			 ? {1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0}:
								   {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};

endmodule
