`timescale 1ps/1ps
//`include "src/Instructions.v"

module instruction_decoder #(
	parameter ADDR_WIDTH = 0,
	parameter REG_BIT_CNT = 0,
	parameter DATA_WIDTH = 0,
	parameter COMBINED_DATA = ADDR_WIDTH+REG_BIT_CNT+DATA_WIDTH
)(
	input	clk,
	input	[COMBINED_DATA-1:0]	data_in,	//24b
	output	[ADDR_WIDTH-1:0] opcode,	//5b <opc>[reg][dat]
	output	[REG_BIT_CNT-1:0] reg_sel,
	output	reg	rst_f,
	output	reg	load,		//links to accu
	output	reg	store		//links to accu
);
	//wire [ADDR_WIDTH-1:0] opcode;
			// opcode - [24-1:16+3] -> [23:19] -> 5b
	assign opcode = data_in[COMBINED_DATA-1:COMBINED_DATA-ADDR_WIDTH];
//	assign reg_sel = data_in[COMBINED_DATA-ADDR_WIDTH-1:DATA_WIDTH];
	assign reg_sel = data_in[COMBINED_DATA-ADDR_WIDTH-4:DATA_WIDTH-REG_BIT_CNT];

	always @(*) begin
		casex (opcode)
			`RST:	begin
				rst_f <= 1'b0;
				load <= 1'b0;
				store <= 1'b0;
			end
			default:	begin
				rst_f <= 1'b1;
				load <= 1'b1;
				store <= 1'b0;
			end
/*			`LDr:	begin
				rst_f <= 1'b1;
				load <= 1'b1;
				store <= 1'b0;
			end
			`LDi:	begin
				rst_f <= 1'b1;
				load <= 1'b1;
				store <= 1'b0;
			end
*/			`ST:	begin
				rst_f <= 1'b1;
				load <= 1'b0;
				store <= 1'b1;
			end
/*			default:	begin
				rst_f <= 1'b1;
				load <= 1'b0;
				store <= 1'b0;
			end
*/		endcase
//		data_out <= opcode;
	end

endmodule