`timescale 1ps/1ps

module rom #(
	parameter ADDR_WIDTH = 0,
	parameter REG_BIT_CNT = 0,
	parameter DATA_WIDTH = 0,
	parameter COMBINED_DATA = ADDR_WIDTH+REG_BIT_CNT+DATA_WIDTH
)(
	//input	chip_en,
	//input	clk,
	input	[ADDR_WIDTH-1:0]	address,
	output	[COMBINED_DATA-1:0]	data_out
);
	reg [COMBINED_DATA-1:0] rom [0:DATA_WIDTH-1];
/*
	always @(posedge clk)
		//data_out <= {address, reg_select, rom[address]};
		data_out <= rom[address];
*/
	assign data_out = rom[address];

	initial
		$readmemb("output/rom_prog.bin", rom);

endmodule
