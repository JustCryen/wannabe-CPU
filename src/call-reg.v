`timescale 1ps/1ps

module call_reg #(
	parameter UNDEFINED = 0,
	parameter CNTR_WIDTH = 0,
	parameter ADDR_WIDTH = 0,
	parameter REG_BIT_CNT = 0,
	parameter DATA_WIDTH = 0,
	parameter COMBINED_DATA = ADDR_WIDTH+UNDEFINED+DATA_WIDTH
)(
	input	clk,
	input	rst_n,
	input	cal_f,
	input	[CNTR_WIDTH-1:0]	counter,
	output	[CNTR_WIDTH-1:0]	ret_addr
);
	reg [CNTR_WIDTH-1:0] call_reg;
//	reg [CNTR_WIDTH-1:0] call_reg [(1<<REG_BIT_CNT)-1:0];
//	reg [REG_BIT_CNT:0] i;

	always @(negedge rst_n or posedge clk) begin
		if (rst_n == 0)	//if reset
//			for (i = 0; i < 8; i = i + 1)
//				call_reg [i] <= 0;
			@(posedge clk)
			call_reg <= 0;
		else begin		//not reset
			if (cal_f)
				call_reg <= counter;
		end
	end

	assign ret_addr = call_reg;

endmodule
