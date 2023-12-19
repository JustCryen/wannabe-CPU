`timescale 1ps/1ps

module core_tb;

	reg	clk;
	reg rst_ext;

core UUT(
	.clk(clk),
	.rst_ext(rst_ext)
);

	always #5 clk = ~clk;
	initial begin
		clk = 1'b0;
		rst_ext = 1'b1;

		#5	rst_ext = 1'b0;
		#5	rst_ext = 1'b1;
//		#200 rst_ext = 1'b0;
//		#5	rst_ext = 1'b1;
	end

	initial begin
		$dumpfile ("output/Core.lxt");
		$dumpvars (0, core_tb);
		$dumpon;
		#2000 $finish;
	end
endmodule
