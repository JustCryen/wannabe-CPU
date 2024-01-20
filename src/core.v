`timescale 1ps/1ps

module core #(
	parameter UNDEFINED = 3,
	parameter CNTR_WIDTH = 8,
	parameter ADDR_WIDTH = 5,
	parameter REG_BIT_CNT = 3,
	parameter DATA_WIDTH = 16,
	parameter COMBINED_DATA = ADDR_WIDTH+UNDEFINED+DATA_WIDTH
							//opcode[5]  register[3] data[16]
)(
	input	clk,
	input	rst_ext
);
	wire rst_int = 1;
	wire rst_n;

	wire load;
	wire store;
	wire jmp;
	wire cal_f;
	wire ret_f;
	wire zero_f;
	wire ls_z_f;
	wire gr_z_f;
	wire [DATA_WIDTH-1:0] reg_data;
	wire [DATA_WIDTH-1:0] acc_data;
	wire [CNTR_WIDTH-1:0] counter;
	wire [REG_BIT_CNT-1:0] reg_sel;
	wire [DATA_WIDTH-1:0] alu_data;
	wire [COMBINED_DATA-1:0] rom_data;
	wire [CNTR_WIDTH-1:0] ret_data;
	wire [ADDR_WIDTH-1:0] dec_data;
	reg	 [DATA_WIDTH-1:0] ld_data;

	assign rst_n = rst_ext && rst_int;
	
	always @(*)
	case (dec_data == `SUBi || dec_data == `ADDi || dec_data == `LDi)
		0:	ld_data <= reg_data;
		default:
			ld_data <= rom_data[DATA_WIDTH-1:0];
	endcase

acc #(
	.UNDEFINED(UNDEFINED),
	.CNTR_WIDTH(CNTR_WIDTH),
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
	.UNDEFINED(UNDEFINED),
	.CNTR_WIDTH(CNTR_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH),
	.REG_BIT_CNT(REG_BIT_CNT),
	.DATA_WIDTH(DATA_WIDTH)
)alu(
	.in1_acc(acc_data),		//16b
	.in2_reg(ld_data),		//16b
	.operation(dec_data),	//5b

	.data_out(alu_data),	//16b
	.zero_f(zero_f),
	.ls_z_f(ls_z_f),
	.gr_z_f(gr_z_f)
);
program_counter #(
	.UNDEFINED(UNDEFINED),
	.CNTR_WIDTH(CNTR_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH),
	.REG_BIT_CNT(REG_BIT_CNT),
	.DATA_WIDTH(DATA_WIDTH)
)pc(
	.clk(clk),				//1b
	.rst_n(rst_n),			//1b
	.jmp(jmp),				//1b
	.ret_f(ret_f),			//1b
//	.rom_data(rom_data[COMBINED_DATA-ADDR_WIDTH-UNDEFINED-1:DATA_WIDTH-CNTR_WIDTH]),
	.rom_data(rom_data[CNTR_WIDTH-1:0]),
	.ret_data(ret_data),

	.data_out(counter)		//5b
);
call_reg #(
	.UNDEFINED(UNDEFINED),
	.CNTR_WIDTH(CNTR_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH),
	.REG_BIT_CNT(REG_BIT_CNT),
	.DATA_WIDTH(DATA_WIDTH)
)call(
	.clk(clk),
	.rst_n(rst_n),
	.cal_f(cal_f),
	.counter(counter),

	.ret_addr(ret_data)
);
reg_file #(
	.UNDEFINED(UNDEFINED),
	.CNTR_WIDTH(CNTR_WIDTH),
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
	.UNDEFINED(UNDEFINED),
	.CNTR_WIDTH(CNTR_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH),
	.REG_BIT_CNT(REG_BIT_CNT),
	.DATA_WIDTH(DATA_WIDTH)
)dec(
	.zero_f(zero_f),
	.ls_z_f(ls_z_f),
	.gr_z_f(gr_z_f),
	.data_in(rom_data),		//21b
//	.cin(counter),			//5b

	.opcode(dec_data),		//5b
	.jmp(jmp),				//1b
	.cal_f(cal_f),			//1b
	.ret_f(ret_f),			//1b
	.reg_sel(reg_sel),		//3b
	.rst_f(rst_int),		//1b
	.load(load),			//1b
	.store(store)			//1b
);
rom #(
	.UNDEFINED(UNDEFINED),
	.CNTR_WIDTH(CNTR_WIDTH),
	.ADDR_WIDTH(ADDR_WIDTH),
	.REG_BIT_CNT(REG_BIT_CNT),
	.DATA_WIDTH(DATA_WIDTH)
)rom(
	.address(counter),	//5b

	.data_out(rom_data)		//21b
);

endmodule
