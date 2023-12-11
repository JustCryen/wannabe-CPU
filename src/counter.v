`timescale 1ps/1ps

module program_counter #(
	parameter ADDR_WIDTH = 0,
	parameter REG_BIT_CNT = 0,
	parameter DATA_WIDTH = 0,
	parameter COMBINED_DATA = ADDR_WIDTH+REG_BIT_CNT+DATA_WIDTH
)(
	input	clk,
	input	rst_n,
	input	ce,
	output	reg [ADDR_WIDTH-1:0]	data_out
);
	always @(negedge rst_n or posedge clk) begin
		if (rst_n == 0)
			data_out <= 0;
		else if (ce)
			data_out <= data_out + 1'b1;
	end
endmodule
