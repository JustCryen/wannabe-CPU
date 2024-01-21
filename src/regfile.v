`timescale 1ps/1ps

module reg_file #(
	parameter UNDEFINED = 0,
	parameter CNTR_WIDTH = 0,
	parameter ADDR_WIDTH = 0,
	parameter REG_BIT_CNT = 0,
	parameter DATA_WIDTH = 0,
	parameter COMBINED_DATA = ADDR_WIDTH+UNDEFINED+DATA_WIDTH
)(
	input	clk,
	input	rst_n,
	input	we,
	input	[DATA_WIDTH-1:0]	acc,	//input
	input	[REG_BIT_CNT-1:0]	reg_select,
	output [DATA_WIDTH-1:0]	data_out	//to alu
);
	reg [DATA_WIDTH-1:0] reg_file [(1<<REG_BIT_CNT)-1:0];
	reg [REG_BIT_CNT:0] i;

	assign data_out = reg_file [reg_select];

	always @(negedge rst_n or posedge clk) begin
		if (rst_n == 0)	//if reset
			@(posedge clk)
			for (i = 0; i < 8; i = i + 1)
				reg_file [i] <= 0;	//DATA_WIDTH
		else begin		//not reset
			if (we)		//store to register
				reg_file [reg_select] <= acc;
		end
	end

endmodule
