class r_scoreboard;
 ram_transaction rsb_dut;
 ram_transaction_dummy rsb_gen;
 mailbox mbox2sb;
 mailbox gen2sb;
 logic [15:0] data;
 
 function new(mailbox mbox2sb,mailbox gen2sb);
  this.mbox2sb = mbox2sb;
  this.gen2sb = gen2sb;
 endfunction
 
 extern task run();
endclass

task r_scoreboard::run();
 begin
	 rsb_dut = new;
	 rsb_gen = new;
	 $display("time:%0t, score",$time);
	 
	  //mbox2sb.get(rsb_dut);
	  gen2sb.get(rsb_gen);
	  //data=rsb_gen.datain;
	  //mbox2sb.get(rsb_gen);
	  $display("time:%0t, score2",$time);
	   #10
	   $display("time:%0t, score ...datagen: ",$time,rsb_gen.datain);
	  //#10
	 //  $display("time:%0t, score ...data: ",$time,rsb_dut.datain);
	 
	  
	
	 #35
	  // @(posedge ram_interface_monitor.clk_t )	
	 $display("\n time: %0t [SCOREBOARD] Generated data_in: %0h ,data received from DUT: %0h",$time,rsb_gen.datain,rsb_dut.datain);
 end
endtask

// ",$time,rsb_dut.datain );//
