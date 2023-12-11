`timescale 1ps/1ps

module acc #(
	parameter ADDR_WIDTH = 0,
	parameter REG_BIT_CNT = 0,
	parameter DATA_WIDTH = 0,
	parameter COMBINED_DATA = ADDR_WIDTH+REG_BIT_CNT+DATA_WIDTH
)(
	//input	ld,
	//input	st,
	input	clk,
	input	we,				// write enable
	//input	rst_n,
	//inout	[COMBINED_DATA-1:0] data_rom,
	inout	[DATA_WIDTH-1:0] data_alu,
	output	[DATA_WIDTH-1:0] data_out
);
	reg [DATA_WIDTH-1:0] acc = 0;

	assign data_out = acc;

	always @(posedge clk) //load to accu
		if (we)
			acc <= data_alu;


		//if (rst_n == 0)			//if reset
		//	data_out <= 0;
		//else
		//	if (ld == 1)		//load data from memory to register //store data from register to memory
		//						//  LD: ACC <= RF[x]
		//		data_out <= data_rom;
		//	else
		//	if (st == 1)		//load from alu
		//						//	ST: RF[x] <= ACC
		//		data_out <= data_alu;
//		end
//	end
endmodule