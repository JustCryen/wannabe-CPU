`timescale 1ps/1ps
`include "instructions.v"

parameter UNDEFINED = 3;
parameter CNTR_WIDTH = 8;
parameter ADDR_WIDTH = 5;
parameter REG_BIT_CNT = 3;
parameter DATA_WIDTH = 16;
parameter COMBINED_DATA = ADDR_WIDTH+UNDEFINED+DATA_WIDTH;

//----------------------------------------------------------
class transaction;
	// ACC
	rand bit	we;              // write enable

	bit	signed [DATA_WIDTH-1:0] data_acc;

	//ALU
	rand bit	[DATA_WIDTH-1:0] data_ld;
	rand enum bit [ADDR_WIDTH-1:0] {
		NOP  = `NOP,
		XOR  = `XOR,
		AND  = `AND,
		OR   = `OR,
		SUBr = `SUBr,
		ADDr = `ADDr,
		RL   = `RL,
		RR   = `RR,
		NOT  = `NOT,
		RST  = `RST,
		DEC  = `DEC,
		INC  = `INC,
		ST   = `ST,
		LDr  = `LDr,
		JMPi = `JMPi,
		CAL  = `CAL,
		RET  = `RET,
		LDi  = `LDi,
		JMPr = `JMPr,
		SUBi = `SUBi,
		ADDi = `ADDi,
		SL   = `SL,
		SR   = `SR,
		JEZ  = `JEZ,
		JNZ  = `JNZ,
		JGZ  = `JGZ,
		JLZ  = `JLZ
	} opcode;

	bit	signed [DATA_WIDTH-1:0] data_alu;
	bit		ls_z_f;
	bit		zero_f;
	bit		gr_z_f;

  	//constaint
	//constraint accu_flag_constr {
	//	ls_z_f != zero_f + gr_z_f;
	//	zero_f != ls_z_f + gr_z_f;
	//	gr_z_f != ls_z_f + zero_f;
	//};

endclass

typedef mailbox #(transaction) trans_mailbox; // Vivado simulation fix for mailbox

//----------------------------------------------------------
class generator;
    rand transaction trans;
    trans_mailbox gen_mbx;
    event	trans_rdy;
    int		repeat_tests;  
    //constructor
    function new(trans_mailbox gen_mbx,event trans_rdy);
        this.gen_mbx = gen_mbx;
        this.trans_rdy = trans_rdy;
    endfunction
  
    //++
    task main();
        repeat(repeat_tests)
        begin
            trans = new();
            trans.randomize();    
            gen_mbx.put(trans);
        end
        -> trans_rdy; 
    endtask  
endclass

//----------------------------------------------------------
interface acc_interf(input logic clk, reset);
	// ACC
    logic   we;              // write enable

    logic   [DATA_WIDTH-1:0] data_acc;

	// ALU
    logic   [DATA_WIDTH-1:0] data_ld;
	logic	[ADDR_WIDTH-1:0] opcode;

	logic   [DATA_WIDTH-1:0] data_alu;
	logic	zero_f;
	logic	ls_z_f;
	logic	gr_z_f;

    //driver clocking block
    clocking driver_clk_block @(posedge clk);
        default input #1 output #1;
		// ACC
        output  we;              // write enable

        input   data_acc;

		// ALU
        output  data_ld;
		output 	opcode;

		input	data_alu;
		input	zero_f;
		input	ls_z_f;
		input	gr_z_f;

    endclocking
  
    //monitor clocking block
    clocking monitor_clk_block @(posedge clk);
        default input #1 output #1;
		// ACC
		input   we;              // write enable

        input   data_acc;

		// ALU
        input   data_ld;
		input	opcode;

		input	data_alu;
		input	zero_f;
		input	ls_z_f;
		input	gr_z_f;

    endclocking

    //driver modport
    modport driver_mode  (clocking driver_clk_block, input clk, reset);

    //monitor modport  
    modport monitor_mode (clocking monitor_clk_block, input clk, reset);

endinterface

//----------------------------------------------------------
class monitor;
    virtual acc_interf acc_virtual_interf;
    trans_mailbox mon_mbx;

    //constructor
    function new(virtual acc_interf acc_virtual_interf, trans_mailbox mon_mbx);
        this.acc_virtual_interf = acc_virtual_interf;
        this.mon_mbx = mon_mbx;
    endfunction

    //++
    task main;
        forever
        begin
            transaction trans;
            trans = new();

            @(posedge acc_virtual_interf.monitor_mode.clk);

            //wait(acc_virtual_interf.monitor_mode.monitor_clk_block.we);

            if(acc_virtual_interf.monitor_mode.monitor_clk_block.we)
            begin
				trans.opcode = acc_virtual_interf.monitor_mode.monitor_clk_block.opcode;
                trans.we = acc_virtual_interf.monitor_mode.monitor_clk_block.we;
                //@(posedge acc_virtual_interf.monitor_mode.clk);//??????
				//@(posedge acc_virtual_interf.monitor_mode.clk);
                trans.data_ld = acc_virtual_interf.monitor_mode.monitor_clk_block.data_ld;

				trans.data_alu = acc_virtual_interf.monitor_mode.monitor_clk_block.data_alu;
				trans.zero_f = acc_virtual_interf.monitor_mode.monitor_clk_block.zero_f;
				trans.ls_z_f = acc_virtual_interf.monitor_mode.monitor_clk_block.ls_z_f;
				trans.gr_z_f = acc_virtual_interf.monitor_mode.monitor_clk_block.gr_z_f;
				//@(posedge acc_virtual_interf.monitor_mode.clk) 
				trans.data_acc = acc_virtual_interf.monitor_mode.monitor_clk_block.data_acc;
            end

            mon_mbx.put(trans);
        end
    endtask
endclass

//----------------------------------------------------------
class driver;
    int trans_cnt; //number of transactions
    virtual acc_interf acc_virtual_interf;
    trans_mailbox drv_mbx;

    //constructor
    function new(virtual acc_interf acc_virtual_interf, trans_mailbox drv_mbx);
        this.acc_virtual_interf = acc_virtual_interf;
        this.drv_mbx = drv_mbx;
    endfunction


    // Reset task
    task reset;
        wait(!acc_virtual_interf.reset);
        $display("[DRIVER] reset started");
        acc_virtual_interf.driver_mode.driver_clk_block.we <= 0;
        acc_virtual_interf.driver_mode.driver_clk_block.data_ld <= 0;
        acc_virtual_interf.driver_mode.driver_clk_block.opcode <= 0;
        wait(acc_virtual_interf.reset);
        $display("[DRIVER] reset finished");
    endtask

    //++
    task main;
        forever
        begin
            transaction trans;
            drv_mbx.get(trans);

            $display("[DRIVER] transfer: %0d ]", trans_cnt);

            @(posedge acc_virtual_interf.driver_mode.clk);

            acc_virtual_interf.driver_mode.driver_clk_block.data_ld <= trans.data_ld;
			acc_virtual_interf.driver_mode.driver_clk_block.we <= trans.we;
			acc_virtual_interf.driver_mode.driver_clk_block.opcode <= trans.opcode;

            trans_cnt++;
        end
    endtask
endclass

//----------------------------------------------------------
class scoreboard;
	trans_mailbox mon_mbx;
	int trans_cnt;

	//ref model

	//constructor
	function new(trans_mailbox mon_mbx);
		this.mon_mbx = mon_mbx;
	endfunction
  
	function void funct(bit [DATA_WIDTH-1:0] data_alu, bit [DATA_WIDTH-1:0] funct_in);
		if(data_alu != funct_in) 
			$error("[SCOREBOARD] ALU out = %0h, Test = %0h", data_alu, funct_in);
		else 
			$display("[SCOREBOARD] ALU out = %0h, Test = %0h", data_alu, funct_in);
	endfunction

	//stores 
	task main;
    	transaction trans;
    	forever
    	begin
    	    //#50;
    	    mon_mbx.get(trans);

			if(trans.we)
			begin
				case (trans.opcode)
					`NOP:  begin $display("[SCOREBOARD] opcode: NOP");	funct(trans.data_alu, trans.data_acc); end
					`XOR:  begin $display("[SCOREBOARD] opcode: XOR");	funct(trans.data_alu, (trans.data_acc ^ trans.data_ld)); end
					`OR:   begin $display("[SCOREBOARD] opcode: OR");	funct(trans.data_alu, (trans.data_acc | trans.data_ld)); end
					`AND:  begin $display("[SCOREBOARD] opcode: AND");	funct(trans.data_alu, (trans.data_acc & trans.data_ld)); end
					`SUBr: begin $display("[SCOREBOARD] opcode: SUBr");	funct(trans.data_alu, (trans.data_acc - trans.data_ld)); end
					`ADDr: begin $display("[SCOREBOARD] opcode: ADDr");	funct(trans.data_alu, (trans.data_acc + trans.data_ld)); end
					`SR:   begin $display("[SCOREBOARD] opcode: SR");	funct(trans.data_alu, (trans.data_acc >>> 1)); end
					`SL:   begin $display("[SCOREBOARD] opcode: SL");	funct(trans.data_alu, (trans.data_acc << 1)); end
					`RR:   begin $display("[SCOREBOARD] opcode: RR");	funct(trans.data_alu, {trans.data_acc[0], trans.data_acc[DATA_WIDTH - 1: 1]}); end
					`RL:   begin $display("[SCOREBOARD] opcode: RL");	funct(trans.data_alu, {trans.data_acc[DATA_WIDTH-2: 0], trans.data_acc[DATA_WIDTH-1]}); end
					`DEC:  begin $display("[SCOREBOARD] opcode: DEC");	funct(trans.data_alu, (trans.data_acc - 1'b1)); end
					`INC:  begin $display("[SCOREBOARD] opcode: INC");	funct(trans.data_alu, (trans.data_acc + 1'b1)); end
					`NOT:  begin $display("[SCOREBOARD] opcode: NOT");	funct(trans.data_alu, ~(trans.data_acc)); end
					`SUBi: begin $display("[SCOREBOARD] opcode: SUBi");	funct(trans.data_alu, (trans.data_acc - trans.data_ld)); end
					`ADDi: begin $display("[SCOREBOARD] opcode: ADDi");	funct(trans.data_alu, (trans.data_acc + trans.data_ld)); end
					`LDi:  begin $display("[SCOREBOARD] opcode: LDi");	funct(trans.data_alu, trans.data_ld); end
					`LDr:  begin $display("[SCOREBOARD] opcode: LDr");	funct(trans.data_alu, trans.data_ld); end
					default: begin $display("[SCOREBOARD] opcode: NOP");	funct(trans.data_alu, trans.data_acc); end
				endcase

				if(trans.ls_z_f == trans.zero_f + trans.gr_z_f | trans.zero_f == trans.ls_z_f + trans.gr_z_f | trans.gr_z_f == trans.ls_z_f + trans.zero_f)
					$error("[SCOREBOARD] ls_z_f = %b, zero_f = %b, gr_z_f = %b", trans.ls_z_f, trans.zero_f, trans.gr_z_f);
				else
					$display("[SCOREBOARD] ls_z_f = %b, zero_f = %b, gr_z_f = %b", trans.ls_z_f, trans.zero_f, trans.gr_z_f);


				if((~trans.data_alu[DATA_WIDTH-1] & |trans.data_alu) == trans.gr_z_f)
				begin
					if(trans.gr_z_f)
						$display("[SCOREBOARD] Sign matched gr_z_f");
				end	else
					$error("[SCOREBOARD] Sign mismatch gr_z_f");


				//if(~|(trans.data_alu[DATA_WIDTH-1:0]) == trans.zero_f)
				if(~|trans.data_alu == trans.zero_f)
				begin
					if(trans.zero_f)
						$display("[SCOREBOARD] Sign matched zero_f");
				end else
					$error("[SCOREBOARD] Sign mismatch zero_f");


				if(trans.data_alu[DATA_WIDTH-1] == trans.ls_z_f)
				begin
					if(trans.ls_z_f)
						$display("[SCOREBOARD] Sign matched ls_z_f");
				end else
					$error("[SCOREBOARD] Sign mismatch ls_z_f: %b", trans.data_alu[DATA_WIDTH-1]);

			end
			else
				$display("[SCOREBOARD] we: %b", trans.we);

			trans_cnt++;
		end
	endtask

endclass

//----------------------------------------------------------
class environment;
	generator	gen;
	driver		driv;
	monitor		mon;
	scoreboard	scb;
	trans_mailbox	env_mbx_drv;
	trans_mailbox	env_mbx_mon;
	event		gen_ended;
	virtual acc_interf	acc_virtual_interf;

	//constructor
	function new(virtual acc_interf acc_virtual_interf);
		this.acc_virtual_interf = acc_virtual_interf;
		env_mbx_drv = new();
		env_mbx_mon = new();
		gen = new(env_mbx_drv,gen_ended);
		driv = new(acc_virtual_interf,env_mbx_drv);
		mon  = new(acc_virtual_interf,env_mbx_mon);
		scb  = new(env_mbx_mon);
	endfunction	
	//
	task pre_test();
		driv.reset();
	endtask

	//
	task test();
		fork 
			gen.main();
			driv.main();
			mon.main();
			scb.main();
		join_any
	endtask

	task post_test();
		wait(gen_ended.triggered);
		wait(gen.repeat_tests == driv.trans_cnt);
		$display("[POST TEST] Driver ended");
		wait(gen.repeat_tests == scb.trans_cnt);
		$display("[POST TEST] Scoreboard ended");
	endtask  

	//run task
	task run;
		pre_test();
		test();
		post_test();
		$finish;
	endtask
endclass

//----------------------------------------------------------
program test(acc_interf intf);
	environment env;

	initial 
	begin
		env = new(intf);
		env.gen.repeat_tests = 300;
		env.run();
	end
endprogram

//----------------------------------------------------------
module testbench_top;
	bit clk;
	bit reset;
  
	//clock generation
	always #5 clk = ~clk;

	//
	initial
	begin
		reset = 0;
		#5 reset = 1;
	end

	//interface
	acc_interf intf(clk, reset);

	//testcase
	test test1(intf);

	//DUT
	acc_acu_link #(
		.UNDEFINED(UNDEFINED),
		.CNTR_WIDTH(CNTR_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH),
		.REG_BIT_CNT(REG_BIT_CNT),
		.DATA_WIDTH(DATA_WIDTH)
	)DUT(
		// ACC
		.clk(intf.clk),				//1b
		.we(intf.we),				//1b load to accu

		.acc_data(intf.data_acc),	//16b to registers

		// ALU
		.ld_data(intf.data_ld),			//register in
		.dec_data(intf.opcode),			//opcode

		.alu_data(intf.data_alu),	//16b
		.zero_f(intf.zero_f),
		.ls_z_f(intf.ls_z_f),
		.gr_z_f(intf.gr_z_f)
	);

	//enabling the wave dump
	initial
	begin 
		$dumpfile("dump.vcd"); $dumpvars;
	end

endmodule
