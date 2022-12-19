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
		@(posedge ram_interface_driver.clk_t or posedge ram_interface_driver.clk_c)
			mbox2drv.get(rdrv);
			send_to_dut(rdrv);
endtask
  
task r_driver::send_to_dut(input ram_transaction ram_drive);//specify direction
	@(posedge ram_interface_driver.clk_t or posedge ram_interface_driver.clk_c)
	begin
 // ------------------------------------------ W R I T E (start) --------------------------------------------------------------//		
		if(ram_drive.rtype== write)
		begin 
			#10 ram_interface_driver.rwb=1;
			ram_interface_driver.auto_pre=0;
			ram_interface_driver.burst_mode=0;
			ram_interface_driver.act=1;
			ram_interface_driver.cs=1;
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
			ram_interface_driver.datain=ram_drive.datain;
			ram_interface_driver.burst_len=ram_drive.burst_len;
			$display("time: %0t [DRIVER] write operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address);
			//#10 ram_interface_driver.act=0;

		end
 // ------------------------------------------ W R I T E (end) --------------------------------------------------------------//		
 
 // ------------------------------------------ W R I T E _ A (start) --------------------------------------------------------------//
		if(ram_drive.rtype== write_a)
		begin 
			#10 ram_interface_driver.rwb=1;
			ram_interface_driver.auto_pre=1;
			
			ram_interface_driver.act=1;
			ram_interface_driver.cs=1;
			
			ram_interface_driver.burst_mode=0;
			
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
			ram_interface_driver.datain=ram_drive.datain;
			ram_interface_driver.burst_len=ram_drive.burst_len;
			#30
			$display("[DRIVER] write A operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h, burst length = %b",ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address,ram_interface_driver.burst_len);
	#30 ram_interface_driver.act=0;
		end
 // ------------------------------------------ W R I T E _ A (end) --------------------------------------------------------------//
 
 // ------------------------------------------ R E A D (start) --------------------------------------------------------------//
		if(ram_drive.rtype== read)
		begin 

			//--------------WRITE A -----------------------------------//
				#10 ram_interface_driver.rwb=1;
			ram_interface_driver.auto_pre=1;
			ram_interface_driver.act=1;
			
			ram_interface_driver.burst_mode=0;
			
			ram_interface_driver.cs=1;
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
			ram_interface_driver.datain=ram_drive.datain;
			ram_interface_driver.burst_len=ram_drive.burst_len;
			$display("\ntime: %0t [DRIVER] write A operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address);
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
			ram_interface_driver.cs=1;
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
			
			#10
			ram_interface_driver.act=0;
			ram_interface_driver.reset=1;

			$display("time: %0t [DRIVER] Read operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h DATA_OUT=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address,ram_interface_driver.dataout);
		end
// ------------------------------------------ R E A D (end) --------------------------------------------------------------//


// ------------------------------------------ R E A D _ A (start) --------------------------------------------------------------//

		if(ram_drive.rtype== read_a)
		begin 

		//--------------WRITE A -----------------------------------//
				#10 ram_interface_driver.rwb=1;
			ram_interface_driver.auto_pre=1;
			ram_interface_driver.act=1;
			ram_interface_driver.burst_mode=0;
			ram_interface_driver.cs=1;
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
			ram_interface_driver.datain=ram_drive.datain;
			ram_interface_driver.burst_len=ram_drive.burst_len;
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
			ram_interface_driver.cs=1;
			ram_interface_driver.rwb=0;
			ram_interface_driver.auto_pre=1;
		
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
	    #10 ram_interface_driver.act=0;
	        $display("[DRIVER] Read A operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h DATA_OUT=%h",ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address,ram_interface_driver.dataout);
		    end
// ------------------------------------------ R E A D _ A (end) --------------------------------------------------------------//	 

//----------------------------------------- W R I T E _ P R E C H A R G E (start) --------------------------------------------------------------//		
		if(ram_drive.rtype== w_precharge)
		begin 
		// ----- write data -- //
			#10 ram_interface_driver.rwb=1;
			ram_interface_driver.auto_pre=0;
			ram_interface_driver.act=1;
			ram_interface_driver.burst_mode=0;
			ram_interface_driver.cs=1;
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
			ram_interface_driver.datain=ram_drive.datain;
			ram_interface_driver.burst_len=ram_drive.burst_len;
			$display("time:%t [DRIVER] write operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address);
			#30 ram_interface_driver.act=0;
			ram_interface_driver.auto_pre=1;
			ram_interface_driver.cs=0;

		end
//----------------------------------------- W R I T E _ P R E C H A R G E (end) --------------------------------------------------------------//

//----------------------------------------- R E A D _ P R E C H A R G E (start) --------------------------------------------------------------//

        if(ram_drive.rtype== r_precharge)
		begin 

			//--------------WRITE  -----------------------------------//
				#10 ram_interface_driver.rwb=1;
			ram_interface_driver.auto_pre=0;
			ram_interface_driver.act=1;
			ram_interface_driver.burst_mode=0;
			ram_interface_driver.cs=1;
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
			ram_interface_driver.datain=ram_drive.datain;
			ram_interface_driver.burst_len=ram_drive.burst_len;
			
			#15 ram_interface_driver.cs=0;
			ram_interface_driver.auto_pre=1;
			#10 ram_interface_driver.cs=1;
			ram_interface_driver.auto_pre=0;
			$display("[DRIVER] write A operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h",ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address);
			#10
			ram_interface_driver.row_address=3'b101;
			ram_interface_driver.col_address=3'b011;
			ram_interface_driver.bank_grp=1'b0;
			ram_interface_driver.bank_no=2'b10;
			ram_interface_driver.datain=16'habcd;
			#15 ram_interface_driver.cs=0;
			ram_interface_driver.auto_pre=1;
			#10 ram_interface_driver.cs=1;
			ram_interface_driver.auto_pre=0;

	        #10 ram_interface_driver.act=0;
	        #5 ram_interface_driver.cs=0;
			    ram_interface_driver.auto_pre=1;
			#5 ram_interface_driver.cs=1;
			    ram_interface_driver.auto_pre=0;

			//----------------READ-------------------------------------//
			#10 ram_interface_driver.rwb=0;
			ram_interface_driver.auto_pre=0;
			ram_interface_driver.act=1;
			ram_interface_driver.cs=1;
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
			#15 ram_interface_driver.auto_pre=1;
			ram_interface_driver.cs=0;
			#10 ram_interface_driver.act=0;
			

			$display("[DRIVER] Read operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h DATA_OUT=%h",ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address,ram_interface_driver.dataout);
		end
//----------------------------------------- R E A D _ P R E C H A R G E (end) --------------------------------------------------------------//

// ------------------------------------------ W _ R E S E T (start) --------------------------------------------------------------//		
		if(ram_drive.rtype== w_reset)
		begin 
			#10 ram_interface_driver.rwb=1;
			ram_interface_driver.auto_pre=0;
			ram_interface_driver.act=1;
			ram_interface_driver.burst_mode=0;
			ram_interface_driver.cs=1;
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
			ram_interface_driver.datain=ram_drive.datain;
			ram_interface_driver.burst_len=ram_drive.burst_len;
			$display("time:%t [DRIVER] write operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address);
			#10 ram_interface_driver.act=0;
			    ram_interface_driver.reset=1;

		end
 // ------------------------------------------ W _ R E S E T (end) --------------------------------------------------------------//		
 
 // ------------------------------------------ R _ R E S E T (start) --------------------------------------------------------------//		
		if(ram_drive.rtype== r_reset)
		begin 
			#10 ram_interface_driver.rwb=0;
			ram_interface_driver.auto_pre=0;
			ram_interface_driver.act=1;
			ram_interface_driver.burst_mode=0;
			ram_interface_driver.cs=1;
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
			ram_interface_driver.datain=ram_drive.datain;
			ram_interface_driver.burst_len=ram_drive.burst_len;
			$display("time:%t [DRIVER] write operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address);
			#10 ram_interface_driver.act=0;
			    ram_interface_driver.reset=1;

		end
 // ------------------------------------------ R _ R E S E T (end) --------------------------------------------------------------//		
 
 // ------------------------------------------ S E L F _ T E S T [write -->precharge, write_a, read, read_a] (start) ------------//
        if(ram_drive.rtype == self)
        begin
        
            //---write --//
            #10 ram_interface_driver.rwb=1;
			ram_interface_driver.auto_pre=0;
			ram_interface_driver.act=1;
			ram_interface_driver.burst_mode=0;
			ram_interface_driver.cs=1;
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
			ram_interface_driver.datain=ram_drive.datain;
			ram_interface_driver.burst_len=ram_drive.burst_len;
			$display("time:%t [DRIVER] write operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address);
			//---precharge---//
			#10 ram_interface_driver.act=0;
			ram_interface_driver.auto_pre=1;
			ram_interface_driver.cs=0;
			//--write_a--//
			#10 ram_interface_driver.auto_pre=1;
			ram_interface_driver.act=1;
			ram_interface_driver.cs=1;
			
			ram_interface_driver.row_address=3'b101;
			ram_interface_driver.col_address=3'b011;
			ram_interface_driver.bank_grp=1'b0;
			ram_interface_driver.bank_no=2'b10;
			ram_interface_driver.datain=16'habcd;
			#10 ram_interface_driver.act=0;
			// -- read -- //
			
			#10 ram_interface_driver.rwb=0;
			ram_interface_driver.auto_pre=0;
			ram_interface_driver.act=1;
			ram_interface_driver.cs=1;
			// -- read_a -- //2
			#10
			ram_interface_driver.auto_pre=1;
			#20
			ram_interface_driver.auto_pre=0;
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
			#20
			ram_interface_driver.act=0;
			ram_interface_driver.reset=1;
			#20
				ram_interface_driver.reset=0;
			ram_interface_driver.rwb=0;
			ram_interface_driver.auto_pre=0;
			ram_interface_driver.act=1;
			ram_interface_driver.cs=1;
		end
 // ------------------------------------------ S E L F _ T E S T [write -->precharge, write_a, read, read_a] (end) ------------//
 
 // ------------------------------------------- B U R S T _ W R I T E (start)---------------------------------------------------------//
        if(ram_drive.rtype == w_burst)
            begin                             
                //---write --//
                #10 ram_interface_driver.rwb=1;
		        ram_interface_driver.auto_pre=0;
		        ram_interface_driver.act=1;
		        ram_interface_driver.burst_mode=1;
		        ram_interface_driver.cs=1;
		        ram_interface_driver.row_address=ram_drive.row_address;
		        ram_interface_driver.col_address=ram_drive.col_address;
		        ram_interface_driver.bank_grp=ram_drive.bank_grp;
		        ram_interface_driver.bank_no=ram_drive.bank_no;
		        ram_interface_driver.datain=ram_drive.datain;
		        ram_interface_driver.burst_len=ram_drive.burst_len;
		        #30
		        ram_interface_driver.cs=0;
		        ram_interface_driver.auto_pre=1;
		        #10
		        ram_interface_driver.act=0;
		    end
 // ------------------------------------------- B U R S T _ W R I T E (end) ---------------------------------------------------------//        			
 
 // ------------------------------------------- B U R S T _ R E A D (start)---------------------------------------------------------//
        if(ram_drive.rtype == r_burst)
            begin                             
                //---write --//
                
                #10 ram_interface_driver.rwb=1;
		        ram_interface_driver.auto_pre=0;
		        ram_interface_driver.act=1;
		        ram_interface_driver.burst_mode=1;
		        ram_interface_driver.cs=1;
		        ram_interface_driver.row_address=ram_drive.row_address;
		        ram_interface_driver.col_address=ram_drive.col_address;
		        ram_interface_driver.bank_grp=ram_drive.bank_grp;
		        ram_interface_driver.bank_no=ram_drive.bank_no;
		        ram_interface_driver.datain=ram_drive.datain;
		        ram_interface_driver.burst_len=ram_drive.burst_len;
		        #30
		        ram_interface_driver.cs=0;
		        ram_interface_driver.auto_pre=1;
		        #10
		        ram_interface_driver.act=0;
		         ram_interface_driver.cs=1;
		        #10 
		        ram_interface_driver.rwb=0;
		        ram_interface_driver.auto_pre=0;
		        ram_interface_driver.act=1;
		        $display("burst read is in progress . . .");
		        
		    end
 // ------------------------------------------- B U R S T _ W R I T E (end) ---------------------------------------------------------//     

  // ------------------------------------------- R W_B U R S T (start)---------------------------------------------------------//
        if(ram_drive.rtype == rw_burst)
            begin                             
                //---write --//
                
                #10 ram_interface_driver.rwb=1;
		        ram_interface_driver.auto_pre=0;
		        ram_interface_driver.act=1;
		        ram_interface_driver.burst_mode=1;
		        ram_interface_driver.cs=1;
		        ram_interface_driver.row_address=ram_drive.row_address;
		        ram_interface_driver.col_address=ram_drive.col_address;
		        ram_interface_driver.bank_grp=ram_drive.bank_grp;
		        ram_interface_driver.bank_no=ram_drive.bank_no;
		        ram_interface_driver.datain=ram_drive.datain;
		        ram_interface_driver.burst_len=ram_drive.burst_len;
		        #25 
		        ram_interface_driver.burst_mode=0;
		        
		        //precharge
		        #38
		        ram_interface_driver.act=0;
		        ram_interface_driver.cs=0;
		        ram_interface_driver.auto_pre=1;
		        #20
		        //ram_interface_driver.act=0;
		        ram_interface_driver.act=1;
		        ram_interface_driver.cs=0;
		        ram_interface_driver.auto_pre=0;
		        #10
		        ram_interface_driver.burst_mode=1;
		        ram_interface_driver.cs=0;
		        ram_interface_driver.row_address=3'b101;
			    ram_interface_driver.col_address=3'b011;
			    ram_interface_driver.bank_grp=1'b0;
			    ram_interface_driver.bank_no=2'b11;
			    ram_interface_driver.datain=16'habcd;
			    #2
			    ram_interface_driver.cs=1;
		        //ram_interface_driver.burst_mode=1;//change
		        #5 
		        ram_interface_driver.burst_mode=0;
		        #25
		        ram_interface_driver.cs=0;
		        ram_interface_driver.auto_pre=1;
		        #15 
		        ram_interface_driver.row_address=ram_drive.row_address;
		        ram_interface_driver.col_address=ram_drive.col_address;
		        ram_interface_driver.bank_grp=ram_drive.bank_grp;
		        ram_interface_driver.bank_no=ram_drive.bank_no;
		        ram_interface_driver.rwb=0;
		        ram_interface_driver.auto_pre=0;
		        ram_interface_driver.act=1;
		        #3
		         ram_interface_driver.cs=1;
		        $display("burst read is in progress . . .");
		      /**/  
		    end
 // -------------------------------------------R W_B U R S T (end) ---------------------------------------------------------//        			
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
	
