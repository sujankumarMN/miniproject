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
			#30;

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
			ram_interface_driver.act=0;
			$display("time: %0t [DRIVER] write A operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address);
	       
	        #30;
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
			
			#55
			ram_interface_driver.row_address=3'b101;
			ram_interface_driver.col_address=3'b011;
			ram_interface_driver.bank_grp=1'b1;
			ram_interface_driver.bank_no=2'b11;
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
			ram_interface_driver.datain=ram_drive.datain;
			
			#10
			ram_interface_driver.act=0;
			ram_interface_driver.reset=1;

			$display("time: %0t [DRIVER] Read operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h DATA_OUT=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address,ram_interface_driver.dataout);
			#30;
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
						
			#30
			ram_interface_driver.row_address=3'b101;
			ram_interface_driver.col_address=3'b011;
			ram_interface_driver.bank_grp=1'b1;
			ram_interface_driver.bank_no=2'b11;
			ram_interface_driver.datain=16'habcd;
			
	        #30 ram_interface_driver.act=0;

			//----------------READ - A-------------------------------------//

			#30 	
			ram_interface_driver.act=1;
			ram_interface_driver.cs=1;
			ram_interface_driver.rwb=0;
			ram_interface_driver.auto_pre=1;
		
			ram_interface_driver.row_address=ram_drive.row_address;
			ram_interface_driver.col_address=ram_drive.col_address;
			ram_interface_driver.bank_grp=ram_drive.bank_grp;
			ram_interface_driver.bank_no=ram_drive.bank_no;
			ram_interface_driver.datain=ram_drive.datain;
	        #10 
	        ram_interface_driver.act=0;
	        #30 
	        ram_interface_driver.act=1;
	        ram_interface_driver.reset=0;
	        ram_interface_driver.cs=1;
			ram_interface_driver.rwb=0;
			ram_interface_driver.auto_pre=1;
	        $display("time: %0t [DRIVER] Read A operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h DATA_OUT=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address,ram_interface_driver.dataout);
	        #30;
		    end
// ------------------------------------------ R E A D _ A (end) --------------------------------------------------------------//	 

//----------------------------------------- W R I T E _ P R E C H A R G E (start) --------------------------------------------------------------//		
		if(ram_drive.rtype== w_precharge)
		begin 
		// ----- write data -- //
			#10 
			ram_interface_driver.rwb=1;
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
			$display("time:%t [DRIVER] write precharge operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address);
			#30 
			ram_interface_driver.act=0;
			ram_interface_driver.auto_pre=1;
			ram_interface_driver.cs=0;
			#30;

		end
//----------------------------------------- W R I T E _ P R E C H A R G E (end) --------------------------------------------------------------//

//----------------------------------------- R E A D _ P R E C H A R G E (start) --------------------------------------------------------------//

        if(ram_drive.rtype== r_precharge)
		begin 

			//--------------WRITE  -----------------------------------//
			#10 
			ram_interface_driver.rwb=1;
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
			
			#35 
			ram_interface_driver.cs=0;
			ram_interface_driver.auto_pre=1;
			#10 
			ram_interface_driver.cs=1;
			ram_interface_driver.auto_pre=0;
			//$display("time: %0t [DRIVER] read precharge operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address);
			#10
			ram_interface_driver.row_address=3'b101;
			ram_interface_driver.col_address=3'b011;
			ram_interface_driver.bank_grp=1'b1;
			ram_interface_driver.bank_no=2'b11;
			ram_interface_driver.datain=16'habcd;
			
			#15 
			ram_interface_driver.cs=0;
			ram_interface_driver.auto_pre=1;
			#10 
			ram_interface_driver.cs=1;
			ram_interface_driver.auto_pre=0;
			ram_interface_driver.datain=ram_drive.datain;

	        #10 
	        ram_interface_driver.act=0;
	        #5 
	        ram_interface_driver.cs=0;
			ram_interface_driver.auto_pre=1;
			#5 
			ram_interface_driver.cs=1;
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
			

			$display("time: %0t [DRIVER] read precharge operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h DATA_OUT=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address,ram_interface_driver.dataout);
			#30;
		end
//----------------------------------------- R E A D _ P R E C H A R G E (end) --------------------------------------------------------------//

// ------------------------------------------ W _ R E S E T (start) --------------------------------------------------------------//		
		if(ram_drive.rtype== w_reset)
		begin 
			#10 
			ram_interface_driver.rwb=1;
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
			$display("time: %0t [DRIVER] write reset operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address);
			#20 
			ram_interface_driver.act=0;
			#10
			ram_interface_driver.reset=1;
			#30;

		end
 // ------------------------------------------ W _ R E S E T (end) --------------------------------------------------------------//		
 
 // ------------------------------------------ R _ R E S E T (start) --------------------------------------------------------------//		
		if(ram_drive.rtype== r_reset)
		begin 
			#10 
			ram_interface_driver.rwb=0;
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
		    $display("time: %0t [DRIVER] Read reset operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h DATA_OUT=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address,ram_interface_driver.dataout);
			#30
			ram_interface_driver.reset=1;
			#30;

		end
 // ------------------------------------------ R _ R E S E T (end) --------------------------------------------------------------//		
 

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
		        $display("time: %0t [DRIVER] burst  write operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address);
		        #30
		        ram_interface_driver.cs=0;
		        ram_interface_driver.auto_pre=1;
		        #10
		        ram_interface_driver.act=0;
		        #30;
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
		        #25
		        ram_interface_driver.burst_mode=0;
		        ram_interface_driver.datain=4'haabb;
		        #5
		        ram_interface_driver.datain=4'h1000;
		        #5
		        ram_interface_driver.datain=4'h0002;
		        
		        #4
		        ram_interface_driver.cs=0;
		        ram_interface_driver.auto_pre=1;
		        #10
		        ram_interface_driver.act=0;
		         ram_interface_driver.burst_mode=1;
		         ram_interface_driver.cs=1;
		        #20 
		        ram_interface_driver.rwb=0;
		        ram_interface_driver.auto_pre=0;
		        ram_interface_driver.act=1;
		        $display("time: %0t [DRIVER] Burst Read operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h DATA_OUT=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address,ram_interface_driver.dataout);
		        #30;
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
		        ram_interface_driver.datain=4'haabb;
		        #5
		        ram_interface_driver.datain=4'h1000;
		        #5
		        ram_interface_driver.datain=4'h0002;
		        
		        //#4
		        
		        //#25 
		        ram_interface_driver.burst_mode=0;
		        
		        //precharge
		        #4
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
		        #18
		        ram_interface_driver.cs=0;
		        ram_interface_driver.auto_pre=1;
		        #15 
		        ram_interface_driver.burst_mode=1;
		        ram_interface_driver.row_address=ram_drive.row_address;
		        ram_interface_driver.col_address=ram_drive.col_address;
		        ram_interface_driver.bank_grp=ram_drive.bank_grp;
		        ram_interface_driver.bank_no=ram_drive.bank_no;
		        ram_interface_driver.datain=ram_drive.datain;
		        ram_interface_driver.rwb=0;
		        ram_interface_driver.auto_pre=0;
		        ram_interface_driver.act=1;
		        $display("time: %0t [DRIVER] Read - write  operation is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h DATA_OUT=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address,ram_interface_driver.dataout);
		        #3
		        ram_interface_driver.cs=1;
		        #30
		        ram_interface_driver.burst_mode=0;
		        ram_interface_driver.auto_pre=1;
		        ram_interface_driver.cs=0;
		        ram_interface_driver.act=1;
		        #30;
		         //for fsm//
		         /*
		        #30
		         ram_interface_driver.burst_mode=0;
		        ram_interface_driver.auto_pre=1;
		        ram_interface_driver.cs=0;
		        ram_interface_driver.act=1;
		        #30
		        ram_interface_driver.cs=1;
		        ram_interface_driver.rwb=1;
		        #20	        
		       
		        ram_interface_driver.rwb=0;
		        #60
		        ram_interface_driver.act=0;
		        //change point
		        #30
		        ram_interface_driver.auto_pre=0;
		        ram_interface_driver.act=1;
		        #10
		        ram_interface_driver.auto_pre=1;
		        #20
		        ram_interface_driver.auto_pre=0;
		        ram_interface_driver.rwb=0;
		        #30
		        ram_interface_driver.cs=0;
		        ram_interface_driver.auto_pre=1;
		        #50
		        ram_interface_driver.cs=1;
		        ram_interface_driver.auto_pre=1;
		        ram_interface_driver.rwb=1;
		        #80
		        ram_interface_driver.auto_pre=0;
		        #50
		        ram_interface_driver.cs=0;
		        ram_interface_driver.auto_pre=1;
		        #10
		        ram_interface_driver.act=0;
		        #750;
		        */
		     
		    end
 // -------------------------------------------R W_B U R S T (end) ---------------------------------------------------------//  
 
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
			//ram_interface_driver.rtype=ram_drive.rtype;
			
			//---precharge---//
			#10 ram_interface_driver.act=0;
			ram_interface_driver.auto_pre=1;
			ram_interface_driver.cs=0;
			//--write_a--//
			#10 ram_interface_driver.auto_pre=1;
			ram_interface_driver.act=1;
			ram_interface_driver.cs=1;
			#10
			ram_interface_driver.row_address=3'b101;
			ram_interface_driver.col_address=3'b011;
			ram_interface_driver.bank_grp=1'b1;
			ram_interface_driver.bank_no=2'b11;
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
			ram_interface_driver.datain=ram_drive.datain;
			$display("time: %0t [DRIVER] SELF testing is initiated. DATA_IN=%h, Row_Address=%h, Col_Address=%h",$time,ram_interface_driver.datain,ram_interface_driver.row_address, ram_interface_driver.col_address);
			#20
			ram_interface_driver.act=0;
			ram_interface_driver.reset=1;
			#20
				ram_interface_driver.reset=0;
			ram_interface_driver.rwb=0;
			ram_interface_driver.auto_pre=0;
			ram_interface_driver.act=1;
			ram_interface_driver.cs=1;
			#50
			ram_interface_driver.act=0;
			ram_interface_driver.reset=1;
			#10
			ram_interface_driver.reset=0;
			#30;
		end
 // ------------------------------------------ S E L F _ T E S T [write -->precharge, write_a, read, read_a] (end) ------------//
 

	end
//#450 $finish;
endtask

























 //-------------------------------------------- buf---------------------------------------------------------------------------//
        /*if(ram_drive.rtype == buffer)
        begin
            #10
            ram_interface_driver.rwb=1;
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
			#2
			ram_interface_driver.burst_mode=0;
			#50;
			
		end*/
       			
