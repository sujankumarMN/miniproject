class r_scoreboard;
 ram_transaction rsb;
 mailbox mbox2sb;
 
 function new(mailbox mbox2sb);
  this.mbox2sb = mbox2sb;
 endfunction
 
 extern task run();
endclass

task r_scoreboard::run();
 begin
	 bit e_row_address = 3'b111;
	 bit e_col_address = 3'b111;
	 rsb = new;
	 mbox2sb.get(rsb);
	 #150;	
	 $display("\n[SCOREBOARD] Expected row_address %d, Actual row_ddress %d, Expected col_address %d, Actual col_address %d ", e_row_address, rsb.row_address, e_col_address, rsb.col_address);
 end
endtask
