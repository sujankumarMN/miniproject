class r_driver;
	ram_transaction rdrv;
	mailbox mbox2drv;
	virtual ram_interface ram_interface_driver;
	function new (mailbox mbox2drv,virtual ram_interface ram_interface_driver);
	
		this.mbox2drv=mbox2drv;
		this.ram_interface_driver=ram_interface_driver;
	
	endfunction
   extern task run();
   extern task send_to_dut(ram_transaction ram_drive);
endclass

task r_driver::run();
		rdrv=new;
		@(posedge ram_interface_driver.clk_t)
			mbox2drv.get(rdrv);
			send_to_dut(rdrv);
endtask
  
task r_driver::send_to_dut(input ram_transaction ram_drive);//specify direction
	@(posedge ram_interface_driver.clk_t)
	begin
		
		if(ram_drive.rtype== write)
		begin 
			#10 ram_interface_driver.rwb=1;
			ram_interface_driver.auto_pre=0;
			ram_interface_driver.act=1;
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
			ram_interface_driver.datain=ram_drive.datain;
			$display("time:%t [DRIVER] write operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address);
			//#10 ram_interface_driver.act=0;

		end
		
		if(ram_drive.rtype== write_a)
		begin 
			#10 ram_interface_driver.rwb=1;
			ram_interface_driver.auto_pre=1;
			ram_interface_driver.act=1;
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
			ram_interface_driver.datain=ram_drive.datain;
			$display("[DRIVER] write A operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h",ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address);
	#10 ram_interface_driver.act=0;
		end

		if(ram_drive.rtype== read)
		begin 

			//--------------WRITE A -----------------------------------//
				#10 ram_interface_driver.rwb=1;
			ram_interface_driver.auto_pre=1;
			ram_interface_driver.act=1;
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
			ram_interface_driver.datain=ram_drive.datain;
			$display("[DRIVER] write A operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h",ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address);
			#55
			ram_interface_driver.row_address=3'b101;
			ram_interface_driver.col_address=3'b011;
			ram_interface_driver.bank_grp=1'b0;
			ram_interface_driver.bank_no=2'b10;
			ram_interface_driver.datain=16'habcd;

	#10 ram_interface_driver.act=0;

			//----------------READ-------------------------------------//
			#10 ram_interface_driver.rwb=0;
			ram_interface_driver.auto_pre=0;
			ram_interface_driver.act=1;
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;

			$display("[DRIVER] Read operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h DATA_OUT=%h",ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address,ram_interface_driver.dataout);
		end

		if(ram_drive.rtype== read_a)
		begin 

		//--------------WRITE A -----------------------------------//
				#10 ram_interface_driver.rwb=1;
			ram_interface_driver.auto_pre=1;
			ram_interface_driver.act=1;
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
			ram_interface_driver.datain=ram_drive.datain;
			$display("[DRIVER] write A operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h",ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address);
			
			#30
			ram_interface_driver.row_address=3'b101;
			ram_interface_driver.col_address=3'b011;
			ram_interface_driver.bank_grp=1'b0;
			ram_interface_driver.bank_no=2'b10;
			ram_interface_driver.datain=16'habcd;
			
	        #30 ram_interface_driver.act=0;

			//----------------READ - A-------------------------------------//

			#30 	ram_interface_driver.act=1;
			ram_interface_driver.rwb=0;
			ram_interface_driver.auto_pre=1;
		
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
	#10 ram_interface_driver.act=0;
	 
			

			$display("[DRIVER] Read A operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h DATA_OUT=%h",ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address,ram_interface_driver.dataout);
		end
	end
#200 $finish;
endtask

























/*if(ram_drive.rtype == reset)
			begin 
				#10 ram_interface_driver.cs=1;
				ram_interface_driver.we=1;
				ram_interface_driver.data_in=ram_drive.data_in;
				ram_interface_driver.address=ram_drive.address;#20;
				#10 ram_interface_driver.reset=1;
				ram_interface_driver.we=0; #50;
				$display("[DRIVER] Reset operation is initiated");
			end*/
	
