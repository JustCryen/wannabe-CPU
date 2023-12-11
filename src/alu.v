`timescale 1ps/1ps
`include "src/instructions.v"

module alu #(
	parameter ADDR_WIDTH = 0,
	parameter REG_BIT_CNT = 0,
	parameter DATA_WIDTH = 0,
	parameter COMBINED_DATA = ADDR_WIDTH+REG_BIT_CNT+DATA_WIDTH
)(
	input	[DATA_WIDTH-1:0]	in1_acc,
	input	[DATA_WIDTH-1:0]	in2_reg,
	input	[ADDR_WIDTH-1:0]	operation,
	output	reg [DATA_WIDTH-1:0]	data_out
);
	always @(*) begin
		casex (operation)
			`NOT:	data_out <= {3'b000,~in1_acc};
			`XOR:	data_out <= {3'b000, in1_acc ^ in2_reg};
			`OR:	data_out <= {3'b000, in1_acc | in2_reg};
			`AND:	data_out <= {3'b000, in1_acc & in2_reg};
			`SUB:	data_out <= {3'b000, in1_acc - in2_reg};
			`ADDr:	data_out <= {3'b000, in1_acc + in2_reg};
			`RR:	data_out <= {3'b000, in1_acc >> 1};		//{acc[0], in1_acc[DATA_WIDTH - 1: 1]};
			`RL:	data_out <= {3'b000, in1_acc << 1};		//{acc[DATA_WIDTH - 2: 0], in1_acc[DATA_WIDTH - 1]};
			`DEC:	data_out <= {3'b000, in1_acc - 1'b1};
			`INC:	data_out <= {3'b000, in1_acc + 1'b1};
			`NOP:	data_out <= {3'b000, in1_acc};

			`ADDi:	data_out <= {3'b000, in1_acc + in2_reg};
			`LDi:	data_out <= {3'b000, in2_reg};
			`LDr:	data_out <= {3'b000, in2_reg};
			default:data_out <= {3'b000, in1_acc};
		endcase
	end
endmodule