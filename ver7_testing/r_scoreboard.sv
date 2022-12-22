class r_scoreboard;
 ram_transaction rsb_dut;
 bit [15:0] data_out[integer]; //n
 bit [15:0] data_in[integer]; //n
 mailbox mbox2sb;
 
  
 function new(mailbox mbox2sb);
  this.mbox2sb = mbox2sb;
 
 endfunction
 
 extern task run();
 extern task data_check();
endclass

task r_scoreboard::run();
 begin
	 rsb_dut = new;
	 
	 forever begin //n
	     mbox2sb.get(rsb_dut);
	     $display("\ntime: %0t [SCOREBOARD] DATA received from DUT",$time);	
	     $display("\n\t DATA_IN: %0h",rsb_dut.datain);
	     $display("\n\t DATA_OUT: %0h",rsb_dut.dataout);
	     $display("\n\t BANK GROUP: %0h",rsb_dut.bank_grp);
	     $display("\n\t BANK NUMBER: %0h",rsb_dut.bank_no);
	     $display("\n\t ROW ADDRESS: %0d",rsb_dut.row_address);
	     $display("\n\t COLUMN ADDRESS: %0d",rsb_dut.col_address);
	     if(rsb_dut.rtype == write) 
	     begin
	        data_in[rsb_dut.row_address] = rsb_dut.datain;
	        data_out[rsb_dut.row_address] = rsb_dut.dataout;
	     end
	     else
	        data_out[rsb_dut.row_address]= rsb_dut.dataout;
	 end 
 end
endtask

task r_scoreboard::data_check();
bit [2:0]row_address;

integer no_datain_entries, no_dataout_entries;
begin
 no_datain_entries = data_in.num();
 no_dataout_entries = data_out.num();
 for(row_address = 0; row_address<8;row_address++) 
     begin
         
        if(data_in.exists(row_address))
        begin
            if(data_in[row_address] === data_out[row_address])
                $display("time: %0t [SCOREBOARD] <TESTCASE PASSED> ROW ADDRESS: %0h, DATA IN: %0h MATCHED with DATA_OUT=%0h",$time,row_address,data_in[row_address],data_out[row_address]);
            else
                $display("time: %0t [SCOREBOARD] <TESTCASE FAILED> ROW ADDRESS: %0h, DATA IN: %0h ERROR with DATA_OUT=%0h",$time,row_address,data_in[row_address],data_out[row_address]);
            no_datain_entries--;
            no_dataout_entries--;
            $display("time: %0t [SCOREBOARD] write entries=%0d, Read entries =%0d",$time,no_datain_entries,no_dataout_entries);  
            
        end
         
        if(no_datain_entries ==0)
        break;
                    
      end
               
     
end
endtask
// ",$time,rsb_dut.datain );//
