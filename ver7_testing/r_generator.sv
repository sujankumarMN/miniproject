class r_generator;
    ram_transaction rgen;
	mailbox rgen2mbox;
	
	function new(mailbox rgen2mbox);
		this.rgen2mbox= rgen2mbox;
	endfunction
	extern task run(string stringname);
endclass

 task r_generator::run(string stringname);
		begin
			if(stringname=="write")
			begin
			   // repeat(5)
				rgen = new;
				rgen.rtype=write;
				rgen.randomize();
				$display("time: %0t [GENERATOR] %b %b data=%h Write operation is in progress",$time, rgen.row_address,rgen.col_address,rgen.datain);
				rgen2mbox.put(rgen);
			end

			if(stringname=="write_a")
			begin
				rgen = new;
				rgen.rtype=write_a;
				rgen.randomize();
				$display("time: %0t [GENERATOR] Write A operation is in progress",$time);
				rgen2mbox.put(rgen);
			end

			if(stringname=="read")
			begin
				rgen = new;
				rgen.rtype=read;
				rgen.randomize();
				$display("time: %0t [GENERATOR] Read operation is in progress",$time);
				rgen2mbox.put(rgen);
			end

			if(stringname=="read_a")
			begin
				rgen = new;
				rgen.rtype=read_a;
				rgen.randomize();
				$display("time: %0t [GENERATOR] Read A operation is in progress",$time);
				rgen2mbox.put(rgen);
			end

			if(stringname=="w_precharge")
			begin
				rgen = new;
				rgen.rtype=w_precharge;
				rgen.randomize();
				$display("time: %0t [GENERATOR] WRITE Precharge operation is in progress",$time);
				rgen2mbox.put(rgen);
			end

			if(stringname=="r_precharge")
			begin
				rgen = new;
				rgen.rtype=r_precharge;
				rgen.randomize();
				$display("time: %0t [GENERATOR] READ Precharge operation is in progress",$time);
				rgen2mbox.put(rgen);
			end
			
			if(stringname=="w_reset")
			begin
				rgen = new;
				rgen.rtype=w_reset;
				rgen.randomize();
				$display("time: %0t [GENERATOR] WRITE RESET operation is in progress",$time);
				rgen2mbox.put(rgen);
			end
			
			
			if(stringname=="r_reset")
			begin
				rgen = new;
				rgen.rtype=r_reset;
				rgen.randomize();
				$display("time: %0t [GENERATOR] READ RESET operation is in progress",$time);
				rgen2mbox.put(rgen);
			end
			
			if(stringname=="self")
			begin
				rgen = new;
				rgen.rtype=self;
				rgen.randomize();
				$display("time: %0t [GENERATOR] SELF operation is in progress",$time);
				rgen2mbox.put(rgen);
			end
			
			if(stringname=="w_burst")
			begin
			    //repeat(4)
			   // begin
				    rgen = new;
				    rgen.rtype=w_burst;
				    rgen.randomize();
				  
				    $display("time: %0t [GENERATOR] BURST write operation is in progress",$time);
				    rgen2mbox.put(rgen);
				//end
			end
			
			if(stringname=="r_burst")
			begin
				rgen = new;
				rgen.rtype=r_burst;
				rgen.randomize();
				$display("time: %0t [GENERATOR] BURST read operation is in progress",$time);
				rgen2mbox.put(rgen);
			end
			
			if(stringname=="rw_burst")
			begin
				rgen = new;
				rgen.rtype=rw_burst;
				rgen.randomize();
				$display("time: %0t [GENERATOR] RW_BURST operation is in progress",$time);
				rgen2mbox.put(rgen);
			end
			
		end
	endtask
