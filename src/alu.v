`timescale 1ps/1ps
`include "src/instructions.v"

module alu #(
	parameter UNDEFINED = 0,
	parameter CNTR_WIDTH = 0,
	parameter ADDR_WIDTH = 0,
	parameter REG_BIT_CNT = 0,
	parameter DATA_WIDTH = 0,
	parameter COMBINED_DATA = ADDR_WIDTH+UNDEFINED+DATA_WIDTH
)(
	input	[DATA_WIDTH-1:0]	in1_acc,
	input	[DATA_WIDTH-1:0]	in2_reg,
	input	[ADDR_WIDTH-1:0]	operation,
	output	reg [DATA_WIDTH-1:0]	data_out,
	output	zero_f,
	output	ls_z_f,
	output	gr_z_f
);
	always @(*) begin
		casex (operation)
			`NOP:	data_out <= {3'b000, in1_acc};
			`XOR:	data_out <= {3'b000, in1_acc ^ in2_reg};
			`OR:	data_out <= {3'b000, in1_acc | in2_reg};
			`AND:	data_out <= {3'b000, in1_acc & in2_reg};
			`SUBr:	data_out <= {3'b000, in1_acc - in2_reg};
			`ADDr:	data_out <= {3'b000, in1_acc + in2_reg};
			`RR:	data_out <= {3'b000, in1_acc >> 1};		//{acc[0], in1_acc[DATA_WIDTH - 1: 1]};
			`RL:	data_out <= {3'b000, in1_acc << 1};		//{acc[DATA_WIDTH - 2: 0], in1_acc[DATA_WIDTH - 1]};
			`DEC:	data_out <= {3'b000, in1_acc - 1'b1};
			`INC:	data_out <= {3'b000, in1_acc + 1'b1};
			`NOT:	data_out <= {3'b000,~in1_acc};

			`SUBi:	data_out <= {3'b000, in1_acc - in2_reg};
			`ADDi:	data_out <= {3'b000, in1_acc + in2_reg};
			`LDi:	data_out <= {3'b000, in2_reg};
			`LDr:	data_out <= {3'b000, in2_reg};
			default:data_out <= {3'b000, in1_acc};
		endcase
	end

	assign zero_f = data_out == 0 ? 1:0;
	assign ls_z_f = 0;	//currently no negative numbers
	assign gr_z_f = data_out > 0  ? 1:0;
/*	always @(*) begin
		if (data_out == 0)
			zero_f <= 1;
		else
			zero_f <= 0;
	end*/
endmodule
