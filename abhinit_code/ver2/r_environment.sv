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
	r_scoreboard ramSb = new(mon2sb);
	initial begin
	
		 if ($test$plusargs("write"))
		 begin
		   // repeat(5)
			ramGen.run("write");
		 end
		else if ($test$plusargs("write_a"))
			ramGen.run("write_a");
		else if ($test$plusargs("read"))
			ramGen.run("read");
		else if ($test$plusargs("a_read"))
			ramGen.run("read_a");
		else if ($test$plusargs("w_precharge"))
			ramGen.run("w_precharge");
		
	end
	
	initial begin
	   // repeat(10)
	    fork
		
	    ramDrv.run();
	    ramMon.run();
	    ramSb.run();
	join
	end
endprogram












/*	
		if($test$plusargs("reset"))
			ramGen.run("reset");
else if ($test$plusargs("self"))
			ramGen.run("self");*/


