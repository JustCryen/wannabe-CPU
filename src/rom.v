`timescale 1ps/1ps

module rom #(
	parameter UNDEFINED = 0,
	parameter CNTR_WIDTH = 0,
	parameter ADDR_WIDTH = 0,
	parameter REG_BIT_CNT = 0,
	parameter DATA_WIDTH = 0,
	parameter COMBINED_DATA = ADDR_WIDTH+UNDEFINED+DATA_WIDTH
)(
	input	[CNTR_WIDTH-1:0]	address,
	output	[COMBINED_DATA-1:0]	data_out
);
	reg [COMBINED_DATA-1:0] rom [0:24-1];  //24 - rom length
	assign data_out = rom[address];

	initial
		$readmemb("output/rom_prog.bin", rom);

endmodule
