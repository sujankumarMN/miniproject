class r_monitor;
	ram_transaction rmon;
	mailbox mon2mbox;
	virtual ram_interface ram_interface_monitor;
	
	/*covergroup rmon_cov;
	    datain:
	    coverpoint rmon.datain{
	    bins datain_low = {[0:4'h5]};
	    bins datain_med = {[4'h6:4'ha]};
	    bins datain_high = {[4'hb:4'hf]};}
	    
	    ram_type: 
	    coverpoint rmon.rtype{
	    bins write = {write};
	    bins write_a = {write_a};
	    bins read = {read};
	    bins read_a = {read_a};
	    bins w_precharge = {w_precharge};
	    bins r_precharge = {r_precharge};}
	    datain_x_ram_type: cross datain,ram_type;
    endgroup	*/   
	        
	function new(mailbox mon2mbox, virtual ram_interface ram_interface_monitor);
		 this.mon2mbox=mon2mbox;
		 this.ram_interface_monitor=ram_interface_monitor;
		 //this.rmon_cov = new;
	endfunction
	
	extern task run();
endclass

 task r_monitor::run();
  begin
      rmon = new;
      begin
          @(posedge ram_interface_monitor.clk_t )//or posedge ram_interface_monitor.clk_c)
          
           //rmon.rwb=ram_interface_monitor.rwb;
           //rmon.auto_pre=ram_interface_monitor.auto_pre;
          // rmon.act=ram_interface_monitor.act;
           rmon.row_address=ram_interface_monitor.row_address;
           rmon.col_address=ram_interface_monitor.col_address;
           rmon.bank_grp=ram_interface_monitor.bank_grp;
           rmon.bank_no=ram_interface_monitor.bank_no;
           rmon.datain=ram_interface_monitor.datain;
           rmon.dataout=ram_interface_monitor.dataout;
           
        //   rmon.rtype=ram_interface_monitor.rtype;
          $display("\n[MONITOR] DUT to Monitor data_in=%0h, row_address = %0d, col_address = %0d, bank_grp = %0d, bank_no = %0d data_out=%0h", rmon.datain, rmon.row_address,rmon.col_address, rmon.bank_grp, rmon.bank_no, rmon.dataout);
           mon2mbox.put(rmon);
        end
 end
endtask
