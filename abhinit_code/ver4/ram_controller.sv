/* PRECHARGE (PRE_A) : Open Policy, Close Policy
Refresh
Package
Data Bus (DQ)
RAS, CAS
DDR
Test Bench 
*/

//module ram_controller(bank_grp, bank_no, rwb, auto_pre, act, reset, cs, cke, row_address, col_address, ras, cas, datain, dataout);
module ram_controller(ram_interface rintf);
/*input bit [1:0] bank_no;
input bit bank_grp, rwb, auto_pre, act, reset, cs, cke, ras, cas; 
input bit [2:0] row_address; 
input bit [2:0] col_address;


	input logic [15:0]datain;	//NEED TO CHECK INOUT
	output logic [15:0]dataout;

	bit clk_t, clk_c;*/
	logic [15:0]bank0_0[7:0][7:0];
	logic [15:0]bank0_1[7:0][7:0];
	logic [15:0]bank0_2[7:0][7:0];
	logic [15:0]bank0_3[7:0][7:0];

	logic [15:0]bank1_0[7:0][7:0];
	logic [15:0]bank1_1[7:0][7:0];
	logic [15:0]bank1_2[7:0][7:0];
	logic [15:0]bank1_3[7:0][7:0];

	logic [15:0]sense_amp[7:0];
	
	
	bit [2:0] i;
	//bit [2:0] j;
	bit refresh_start = 1'b0;
	bit [7:0] refresh_counter;		
	
	typedef enum bit [3:0] {RESET, IDLE, ACTIVATE, INITIALIZE, WRITE, WRITE_A, READ, READ_A, PRECHARGE,REFRESH} State;
	State current_state, next_state;

	typedef enum bit [2:0] {BANK0_0, BANK0_1, BANK0_2, BANK0_3, BANK1_0, BANK1_1, BANK1_2, BANK1_3} Bank_State;
	Bank_State current_bank, next_bank;
	
/*-------------------------------------------------------------------------------
					ASSIGNING STATES BASED ON CLK_T
-------------------------------------------------------------------------------*/

	always_ff @(posedge rintf.clk_t)// or posedge rintf.clk_c)
	begin
		if(rintf.reset == 1'b1)
			current_state <= RESET;
		else
			begin
			current_state <= next_state;
			current_bank <= next_bank;			
			end
	end	
/*-------------------------------------------------------------------------------
					  REFRESH COUNTER GENERATION
-------------------------------------------------------------------------------*/
	always @(posedge rintf.clk_t)// or posedge rintf.clk_c)
	begin
		if(refresh_counter == 7'b1000000)										//WHEN REFRESH REACHES 32ms REFRESH STATE IS INITIATED
				refresh_start = 1'b1;
		else
			refresh_counter = refresh_counter + 1'b1;							//INCREMENT COUNT UNTIL REFRESH REACHES 32ms
	end
/*-------------------------------------------------------------------------------
					  		NAVIGATING FSM
-------------------------------------------------------------------------------*/


	always@(*)
	begin
	//next_bank = {bank_grp,bank_no};
	case(current_state)		
	RESET:	begin
				next_state <= INITIALIZE;   //clear sense amp ?
			end

	INITIALIZE:	begin
				next_state <= IDLE;
				end

	IDLE: 	begin
	        if(refresh_start == 1'b1)
				begin
					$display("in idle and refresh_next");
					next_state <= REFRESH;
				end
			else if(rintf.act == 1'b1)
				next_state <= ACTIVATE;
			end

	ACTIVATE: 	begin
					if(rintf.act == 1'b1)
					begin
					  	next_bank = {rintf.bank_grp,rintf.bank_no};
					  	case(next_bank)
						BANK0_0 : sense_amp <= bank0_0[rintf.row_address][7:0];
						BANK0_1 : sense_amp <= bank0_1[rintf.row_address][7:0];
						BANK0_2 : sense_amp <= bank0_2[rintf.row_address][7:0];
						BANK0_3 : sense_amp <= bank0_3[rintf.row_address][7:0];
						BANK1_0 : sense_amp <= bank1_0[rintf.row_address][7:0];
						BANK1_1 : sense_amp <= bank1_1[rintf.row_address][7:0];
						BANK1_2 : sense_amp <= bank1_2[rintf.row_address][7:0];
						BANK1_3 : sense_amp <= bank1_3[rintf.row_address][7:0];
						endcase	
					  	
					  	if(rintf.cs == 1'b1)
					  	begin
					      	if(rintf.rwb == 1'b1 && rintf.auto_pre == 1'b1)
					      	
						    begin 
						    next_state <= WRITE_A;
						   // $display("activate: here");
						    end
						    
						    else if(rintf.rwb == 1'b1 && rintf.auto_pre == 1'b0)
						    next_state <= WRITE;
						    else if(rintf.rwb == 1'b0 && rintf.auto_pre == 1'b1)
						    next_state <= READ_A;
						    else
						    next_state <= READ;	
				      	end
				      	else if(rintf.cs ==1'b0 && rintf.auto_pre == 1'b1)
							next_state <= PRECHARGE;
			  	    end
			  	   end
	WRITE:	begin			
				
				if(rintf.cs == 1'b1)
				begin
				
				    case(rintf.burst_mode)	
				    1'b0:   sense_amp[rintf.col_address] <= rintf.datain;
				    
				    1'b1:	begin
							    for(i=3'b000;i<rintf.burst_len;i++)
							    begin
								    @(posedge rintf.clk_t)// or posedge rintf.clk_c)
								    sense_amp[rintf.col_address + i] <= rintf.datain;
							    end
						    end
				    default: $display("WRITE:its a default case");	
				    endcase
					
				    if(rintf.rwb == 1'b1 && rintf.auto_pre == 1'b1)
				    next_state <= WRITE_A;
				    else if(rintf.rwb == 1'b1 && rintf.auto_pre == 1'b0)
				    next_state <= WRITE;
				    else if(rintf.rwb == 1'b0 && rintf.auto_pre == 1'b1)
				    next_state <= READ_A;
				    else
				    next_state <= READ;
				end
				else if(rintf.cs ==1'b0 && rintf.auto_pre == 1'b1)
							next_state <= PRECHARGE;						
				
			end
	
	WRITE_A: begin
	
	        case(rintf.burst_mode)	
				    1'b0:  
				     begin
				                sense_amp[rintf.col_address] <= rintf.datain;
				               // $display("WRITE-A HERE");
				            end
				    
				    1'b1:	begin
							    for(i=3'b000;i<rintf.burst_len;i++)
							    begin
								    @(posedge rintf.clk_t)// or posedge rintf.clk_c)
								    sense_amp[rintf.col_address + i] <= rintf.datain;
								    $display("WRITE-A HERE inside 1");
							    end
						    end
				    default: $display("WRITE_A:its a default case");		
				    endcase
				next_state <= PRECHARGE;
			//	$display("WRITE_A:next state:%b",next_state);
			 end
	
	READ:	begin
	        if(rintf.cs == 1'b1)
	        begin
				case(rintf.burst_mode)	
				    1'b0:   rintf.dataout <= sense_amp[rintf.col_address];
				    
				    1'b1:	begin
							    for(i=3'b000;i<rintf.burst_len;i++)
							    begin
								    @(posedge rintf.clk_t )//or posedge rintf.clk_c)
								    rintf.dataout <= sense_amp[rintf.col_address+i];
							    end
						    end	
				    default: $display("READ:its a default case");	
				endcase				
				    if(rintf.rwb == 1'b1 && rintf.auto_pre == 1'b1)
				    next_state <= WRITE_A;
				    else if(rintf.rwb == 1'b1 && rintf.auto_pre == 1'b0)
				    next_state <= WRITE;
				    else if(rintf.rwb == 1'b0 && rintf.auto_pre == 1'b1)
				    next_state <= READ_A;
				    else
				    next_state <= READ;
			end
			else if(rintf.cs ==1'b0 && rintf.auto_pre == 1'b1)
							next_state <= PRECHARGE;
			end
	
	READ_A:	begin
	        case(rintf.burst_mode)
			 1'b0:rintf.dataout <= sense_amp[rintf.col_address];
			 1'b1:begin
					for(i=3'b000;i<rintf.burst_len;i++)
					begin
						@(posedge rintf.clk_t )//or posedge rintf.clk_c)
						rintf.dataout <= sense_amp[rintf.col_address+i];
					end
				  end
		    default: $display("READ_A:its a default case");	
			 endcase	
			next_state <= PRECHARGE;
			end
			
	PRECHARGE:	begin
	           // $display("current back=%b",current_bank);
				case(current_bank)
				BANK0_0 : bank0_0[rintf.row_address] <= sense_amp;
				BANK0_1 : bank0_1[rintf.row_address] <= sense_amp;
				BANK0_2 : bank0_2[rintf.row_address] <= sense_amp;
				BANK0_3 : bank0_3[rintf.row_address] <= sense_amp;
				BANK1_0 : bank1_0[rintf.row_address] <= sense_amp;
				BANK1_1 : bank1_1[rintf.row_address] <= sense_amp;
				BANK1_2 : bank1_2[rintf.row_address] <= sense_amp;
				BANK1_3 : bank1_3[rintf.row_address] <= sense_amp;
				endcase	
				next_state <= IDLE;
				end
				
	REFRESH: begin
			 	repeat(5) 
			 		begin
			 		@(posedge rintf.clk_t)// or posedge rintf.clk_c)
			 			$display("REFRESH STATE in progress");
			 		end
		 		refresh_start <= 1'b0;
	 			refresh_counter <= 7'b0000000;
			 	next_state <= IDLE;
			 end
	endcase		
	end	
endmodule 
