class r_scoreboard;
 ram_transaction rsb_dut;
 mailbox mbox2sb;
  
 function new(mailbox mbox2sb);
  this.mbox2sb = mbox2sb;
 
 endfunction
 
 extern task run();
endclass

task r_scoreboard::run();
 begin
	 rsb_dut = new;
	 mbox2sb.get(rsb_dut);
	 
	// #100
	  // @(posedge ram_interface_monitor.clk_t )
	 $display("\ntime: %0t [SCOREBOARD] DATA received from DUT",$time);	
	 $display("\n\t DATA_IN: %0h",rsb_dut.datain);
	 $display("\n\t DATA_OUT: %0h",rsb_dut.dataout);
	 $display("\n\t BANK GROUP: %0h",rsb_dut.bank_grp);
	 $display("\n\t BANK NUMBER: %0h",rsb_dut.bank_no);
	 $display("\n\t ROW ADDRESS: %0d",rsb_dut.row_address);
	 $display("\n\t COLUMN ADDRESS: %0d",rsb_dut.col_address);
 end
endtask

// ",$time,rsb_dut.datain );//
