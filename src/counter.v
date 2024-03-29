`timescale 1ps/1ps

module program_counter #(
	parameter UNDEFINED = 0,
	parameter CNTR_WIDTH = 0,
	parameter ADDR_WIDTH = 0,
	parameter REG_BIT_CNT = 0,
	parameter DATA_WIDTH = 0,
	parameter COMBINED_DATA = ADDR_WIDTH+UNDEFINED+DATA_WIDTH
)(
	input	clk,
	input	rst_n,
	input	jmp,
	input	ret_f,
	input	[CNTR_WIDTH-1:0]		data_in,	//reg or rom
	input	[CNTR_WIDTH-1:0]		ret_data,
	output	reg [CNTR_WIDTH-1:0]	data_out
);
	always @(negedge rst_n or posedge clk) begin
		if (!rst_n) begin
			@(posedge clk)
			data_out <= 0;
		end else begin
			if (jmp) begin
				if (ret_f)
					data_out <= ret_data + 1;
				else if (0)
						data_out <= data_out + data_in;
					else
						data_out <= data_in;
			end else
				data_out <= data_out + 1'b1;
		end
	end
endmodule
