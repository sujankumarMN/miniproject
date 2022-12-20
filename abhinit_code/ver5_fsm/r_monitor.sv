class r_monitor;
	ram_transaction rmon;
	mailbox mon2mbox;
	virtual ram_interface ram_interface_monitor;
	
	covergroup rmon_cov;
	    row_address:
	    coverpoint rmon.row_address{
            bins row_address_low = {[0:3'b100]};
	        bins row_address_high = {[3'b101:3'b111]};	    
	    }
	    
	    datain:
	    coverpoint rmon.row_address{
	        bins datain_low = {[0:4'h9999]};
	        bins datain_med = {[4'ha000:4'hc999]};
	        bins datain_high = {[4'hd000:4'hffff]};}
	    row_address_x_datain: cross row_address,datain;
	   
    endgroup	  
	        
	function new(mailbox mon2mbox, virtual ram_interface ram_interface_monitor);
		 this.mon2mbox=mon2mbox;
		 this.ram_interface_monitor=ram_interface_monitor;
		 this.rmon_cov = new;
	endfunction
	
	extern task run();
endclass

 task r_monitor::run();
  begin
      rmon = new;
        begin
          @(posedge ram_interface_monitor.clk_t)// or posedge ram_interface_monitor.clk_c)
      
           rmon.row_address=ram_interface_monitor.row_address;
           rmon.col_address=ram_interface_monitor.col_address;
           rmon.bank_grp=ram_interface_monitor.bank_grp;
           rmon.bank_no=ram_interface_monitor.bank_no;
           rmon.datain=ram_interface_monitor.datain;
           rmon.dataout=ram_interface_monitor.dataout;
        
          $display("\ntime: %0t [MONITOR] DUT to Monitor data_in=%0h, row_address = %0d, col_address = %0d, bank_grp = %0d, bank_no = %0d data_out=%0h, datain: %0h",$time, rmon.datain, rmon.row_address,rmon.col_address, rmon.bank_grp, rmon.bank_no, rmon.dataout, rmon.datain);
           rmon_cov.sample();
           mon2mbox.put(rmon);
        end
 end
endtask





















/*ram_type: 
	    coverpoint rmon.rtype{
	    
	    bins write_a = {write_a};
	    bins read = {read};
	    bins write = {write};
	    bins read_a = {read_a};
	    bins w_precharge = {w_precharge};
	    bins r_precharge = {r_precharge};
	    bins self = {self};}
	    row_address_x_ram_type: cross row_address,ram_type;//datain, */








    
           //rmon.rwb=ram_interface_monitor.rwb;
           //rmon.auto_pre=ram_interface_monitor.auto_pre;
          // rmon.act=ram_interface_monitor.act;
