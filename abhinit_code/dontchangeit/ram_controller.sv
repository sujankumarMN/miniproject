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
	
	
	typedef enum bit [3:0] {RESET, IDLE, ACTIVATE, INITIALIZE, WRITE, WRITE_A, READ, READ_A, PRECHARGE} State; //REFRESH?
	State current_state, next_state;

	typedef enum bit [2:0] {BANK0_0, BANK0_1, BANK0_2, BANK0_3, BANK1_0, BANK1_1, BANK1_2, BANK1_3} Bank_State;
	Bank_State current_bank, next_bank;


	
/*-------------------------------------------------------------------------------
								CLOCK GENERATION
-------------------------------------------------------------------------------*/
	
/*-------------------------------------------------------------------------------
					ASSIGNING STATES BASED ON CLK_T
-------------------------------------------------------------------------------*/

	always_ff @(posedge rintf.clk_t)
	begin
		if(rintf.reset == 1'b1)
			current_state <= RESET;
		else
			begin
			current_state <= next_state;
			current_bank <= next_bank;			
			end
	end	

/*-------------------------------------------------------------------------------*/


	always_comb
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
			if(rintf.act == 1'b1)
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
					  	
					  	if(rintf.rwb == 1'b1 && rintf.auto_pre == 1'b1)
						next_state <= WRITE_A;
						else if(rintf.rwb == 1'b1 && rintf.auto_pre == 1'b0)
						next_state <= WRITE;
						else if(rintf.rwb == 1'b0 && rintf.auto_pre == 1'b1)
						next_state <= READ_A;
						else
						next_state <= READ;	
				  	end
			  	end
	WRITE:	begin
				sense_amp[rintf.col_address] <= rintf.datain;
								
				if(rintf.rwb == 1'b1 && rintf.auto_pre == 1'b1)
				next_state <= WRITE_A;
				else if(rintf.rwb == 1'b1 && rintf.auto_pre == 1'b0)
				next_state <= WRITE;
				else if(rintf.rwb == 1'b0 && rintf.auto_pre == 1'b1)
				next_state <= READ_A;
				else
				next_state <= READ;
			end
	
	WRITE_A: begin
				sense_amp[rintf.col_address] <= rintf.datain;
				next_state <= PRECHARGE;
			 end
	
	READ:	begin
				rintf.dataout <= sense_amp[rintf.col_address];
				
				if(rintf.rwb == 1'b1 && rintf.auto_pre == 1'b1)
				next_state <= WRITE_A;
				else if(rintf.rwb == 1'b1 && rintf.auto_pre == 1'b0)
				next_state <= WRITE;
				else if(rintf.rwb == 1'b0 && rintf.auto_pre == 1'b1)
				next_state <= READ_A;
				else
				next_state <= READ;
			end
	
	READ_A:	begin
				rintf.dataout <= sense_amp[rintf.col_address];
				next_state <= PRECHARGE;
			end
			
	PRECHARGE:	begin
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
	endcase		
	end	
endmodule 
