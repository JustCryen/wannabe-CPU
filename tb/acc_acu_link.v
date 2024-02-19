`timescale 1ps/1ps

module acc_acu_link #(
	parameter UNDEFINED = 0,
	parameter CNTR_WIDTH = 0,
	parameter ADDR_WIDTH = 0,
	parameter REG_BIT_CNT = 0,
	parameter DATA_WIDTH = 0
)(
	input	clk,
	input	we,			// write enable
	output	[DATA_WIDTH-1:0] acc_data,

	//input signed [DATA_WIDTH-1:0]	in1_acc,
	input	[DATA_WIDTH-1:0] ld_data,
	input	[ADDR_WIDTH-1:0] dec_data,
	output	[DATA_WIDTH-1:0] alu_data,
	output	zero_f,
	output	ls_z_f,
	output	gr_z_f
);

acc #(
	.UNDEFINED(UNDEFINED),
	.CNTR_WIDTH(CNTR_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH),
	.REG_BIT_CNT(REG_BIT_CNT),
	.DATA_WIDTH(DATA_WIDTH)
)acc(
	.clk(clk),				//1b
	.we(we),				//1b load to accu
	.data_alu(alu_data),	//16b

	.data_out(acc_data)		//16b to registers
);

alu #(
	.UNDEFINED(UNDEFINED),
	.CNTR_WIDTH(CNTR_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH),
	.REG_BIT_CNT(REG_BIT_CNT),
	.DATA_WIDTH(DATA_WIDTH)
)alu(
	.in1_acc(acc_data),		//16b
	.in2_reg(ld_data),		//16b
	.operation(dec_data),	//5b

	.data_out(alu_data),	//16b
	.zero_f(zero_f),
	.ls_z_f(ls_z_f),
	.gr_z_f(gr_z_f)
);

endmodule