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
				rgen = new;
				rgen.rtype=write;
				rgen.randomize();
				$display("time: %t [GENERATOR] %b %b data=%h Write operation is in progress",$time, rgen.row_address,rgen.col_address,rgen.datain);
				rgen2mbox.put(rgen);
			end

			if(stringname=="write_a")
			begin
				rgen = new;
				rgen.rtype=write_a;
				rgen.randomize();
				$display("[GENERATOR] Write A operation is in progress");
				rgen2mbox.put(rgen);
			end

			if(stringname=="read")
			begin
				rgen = new;
				rgen.rtype=read;
				rgen.randomize();
				$display("[GENERATOR] Read operation is in progress");
				rgen2mbox.put(rgen);
			end

			if(stringname=="read_a")
			begin
				rgen = new;
				rgen.rtype=read_a;
				rgen.randomize();
				$display("[GENERATOR] Read operation is in progress");
				rgen2mbox.put(rgen);
			end

			if(stringname=="pre_c")
			begin
				rgen = new;
				rgen.rtype=pre_c;
				$display("[GENERATOR] Precharge operation is in progress");
				rgen2mbox.put(rgen);
			end

		end
	endtask

/*if(stringname=="reset")
			begin
				rgen = new;
				rgen.data_in=8'b1000_1000;
				rgen.address=10'd100;
				rgen.rtype=reset;
				rgen.randomize();
				$display("[GENERATOR] Reset operation is in progress");
				rgen2mbox.put(rgen);
			end

if(stringname=="self")
			begin
				rgen = new;
				rgen.data_in=8'b1000_1000;
				rgen.address=10'd100;
				rgen.rtype=self;
				rgen.randomize();
				$display("[GENERATOR] Self testing is in progress");
				rgen2mbox.put(rgen);
			end



*/

