`timescale 1ps/1ps

module core #(
	parameter ADDR_WIDTH = 5,
	parameter REG_BIT_CNT = 3,
	parameter DATA_WIDTH = 16,
	parameter COMBINED_DATA = ADDR_WIDTH+REG_BIT_CNT+DATA_WIDTH
							//opcode[5]  register[3] data[16]
)(
	input	clk,
	input	rst_ext
);
	wire rst_int;
	wire rst_n;

	wire load;
	wire store;
	wire [DATA_WIDTH-1:0] reg_data;
	wire [DATA_WIDTH-1:0] acc_data;
	wire [ADDR_WIDTH-1:0] counter;
	wire [REG_BIT_CNT-1:0] reg_sel;
	wire [DATA_WIDTH-1:0] alu_data;
	wire [COMBINED_DATA-1:0] rom_data;
	wire [ADDR_WIDTH-1:0] dec_data;
	reg	 [DATA_WIDTH-1:0] ld_data;

	assign rst_n = rst_ext && rst_int;
	
	always @(*)
	case (dec_data[ADDR_WIDTH-1])
		0:	ld_data <= reg_data;
		default:
			ld_data <= rom_data[DATA_WIDTH-1:0];
	endcase

acc #(
	.ADDR_WIDTH(ADDR_WIDTH),
	.REG_BIT_CNT(REG_BIT_CNT),
	.DATA_WIDTH(DATA_WIDTH)
)acc(
	.clk(clk),				//1b
	.we(load),				//1b load to accu
	.data_alu(alu_data),	//16b

	.data_out(acc_data)		//16b to registers
);
alu #(
	.ADDR_WIDTH(ADDR_WIDTH),
	.REG_BIT_CNT(REG_BIT_CNT),
	.DATA_WIDTH(DATA_WIDTH)
)alu(
	.in1_acc(acc_data),		//16b
	.in2_reg(ld_data),		//16b
	.operation(dec_data),	//5b

	.data_out(alu_data)		//16b
);
program_counter #(
	.ADDR_WIDTH(ADDR_WIDTH),
	.REG_BIT_CNT(REG_BIT_CNT),
	.DATA_WIDTH(DATA_WIDTH)
)pc(
	.clk(clk),				//1b
	.rst_n(rst_n),			//1b
	.ce(1'b1),				//1b

	.data_out(counter)		//5b
);
reg_file #(
	.ADDR_WIDTH(ADDR_WIDTH),
	.REG_BIT_CNT(REG_BIT_CNT),
	.DATA_WIDTH(DATA_WIDTH)
)rf(
	.clk(clk),				//1b
	.rst_n(rst_n),			//1b
	.we(store),				//store to register
	.acc(acc_data),			//16b
	.reg_select(reg_sel),	//3b (replacing ce)

	.data_out(reg_data)		//16b
);
instruction_decoder #(
	.ADDR_WIDTH(ADDR_WIDTH),
	.REG_BIT_CNT(REG_BIT_CNT),
	.DATA_WIDTH(DATA_WIDTH)
)dec(
	.clk(clk),				//1b
	.data_in(rom_data),		//21b

	.opcode(dec_data),		//5b
	.reg_sel(reg_sel),		//3b
	.rst_f(rst_int),		//1b
	.load(load),			//1b
	.store(store)			//1b
);
rom #(
	.ADDR_WIDTH(ADDR_WIDTH),
	.REG_BIT_CNT(REG_BIT_CNT),
	.DATA_WIDTH(DATA_WIDTH)
)rom(
	.address(counter),		//5b

	.data_out(rom_data)		//21b
);

endmodule