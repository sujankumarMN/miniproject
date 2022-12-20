`include "r_generator.sv"
`include "r_driver.sv"
`include "r_monitor.sv"
`include "r_scoreboard.sv"
program ram_env(ram_interface r);

	mailbox gen2drv=new();
	mailbox mon2sb=new();
	r_generator ramGen =  new(gen2drv);
	r_driver ramDrv = new(gen2drv,r);
	r_monitor ramMon = new(mon2sb,r);
	r_scoreboard ramSb = new(mon2sb);//gen2drv);
	initial begin
	
		 if ($test$plusargs("write"))
		 begin
		   // repeat(5)
			ramGen.run("write");
		 end
		else if ($test$plusargs("a_write"))
			ramGen.run("write_a");
		else if ($test$plusargs("read"))
			ramGen.run("read");
		else if ($test$plusargs("a_read"))
			ramGen.run("read_a");
		else if ($test$plusargs("w_precharge"))
			ramGen.run("w_precharge");
		else if ($test$plusargs("r_precharge"))
			ramGen.run("r_precharge");
		else if ($test$plusargs("w_reset"))
			ramGen.run("w_reset");
		else if ($test$plusargs("r_reset"))
			ramGen.run("r_reset");
		else if ($test$plusargs("w_burst"))
			ramGen.run("w_burst");	
		else if ($test$plusargs("r_burst"))
			ramGen.run("r_burst");	
		else if ($test$plusargs("wr_burst"))
			ramGen.run("rw_burst");	
		else if ($test$plusargs("self"))
			ramGen.run("self");			
		
	end
	
	initial begin
	  //  @(posedge r.clk_c or r.clk_t)
	  //repeat(10)
	    //fork
		
	    ramDrv.run();
	    ramMon.run();
	    ramSb.run();
	   // join
	end
endprogram
