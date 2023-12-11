`timescale 1ps/1ps

module reg_file #(
	parameter ADDR_WIDTH = 0,
	parameter REG_BIT_CNT = 0,
	parameter DATA_WIDTH = 0,
	parameter COMBINED_DATA = ADDR_WIDTH+REG_BIT_CNT+DATA_WIDTH
)(
	input	clk,
	input	rst_n,
	input	we,
	input	[DATA_WIDTH-1:0]	acc,	//input
	//input	[ADDR_WIDTH-1:0]	adderss,
	input	[REG_BIT_CNT-1:0]	reg_select,

	//input  [REG_BIT_CNT-1:0]	bypass_acc,
	output [DATA_WIDTH-1:0]	data_out //to alu
);
	reg [DATA_WIDTH-1:0] reg_file [(1<<REG_BIT_CNT)-1:0];
	reg [REG_BIT_CNT:0] i;

	assign data_out = reg_file [reg_select];

	always @(negedge rst_n or posedge clk) begin
//		if (ce == 1) begin	//if chip enabled
		if (rst_n == 0)	//if reset
			for (i = 0; i < 8; i = i + 1)
				reg_file [i] <= 0;	//DATA_WIDTH
		else begin		//not reset, store to register
			if (we)
				reg_file [reg_select] <= acc;

//			data_out = reg_file [reg_select];
		end
	end

endmodule
