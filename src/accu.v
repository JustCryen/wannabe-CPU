`timescale 1ps/1ps

module acc #(
	parameter UNDEFINED = 0,
	parameter CNTR_WIDTH = 0,
	parameter ADDR_WIDTH = 0,
	parameter REG_BIT_CNT = 0,
	parameter DATA_WIDTH = 0,
	parameter COMBINED_DATA = ADDR_WIDTH+UNDEFINED+DATA_WIDTH
)(
	input	clk,
	input	we,			// write enable
	input	[DATA_WIDTH-1:0] data_alu,
	output	[DATA_WIDTH-1:0] data_out
);
	reg [DATA_WIDTH-1:0] acc = 0;

	assign data_out = acc;

	always @(posedge clk)
		if (we)			//load to accu
			acc <= data_alu;
endmodule
