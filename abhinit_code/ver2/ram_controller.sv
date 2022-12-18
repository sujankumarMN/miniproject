/* PRECHARGE (PRE_A) : Open Policy, Close Policy
Refresh
Package
Data Bus (DQ)
RAS, CAS
DDR
Burst Mode
Test Bench 
*/

`timescale 1ns/1ps
module ram_controller(bank_grp, bank_no, rwb, auto_pre, act, reset, cs, cke, row_address, col_address, ras, cas, datain, dataout);
input bit [1:0] bank_no;
input bit bank_grp, rwb, auto_pre, act, reset, cs, cke, ras, cas; 
input bit [2:0] row_address; 
input bit [2:0] col_address;

	//logic [15:0]temp;
	input logic [15:0]datain;	//NEED TO CHECK INOUT
	output logic [15:0]dataout;

	bit clk_t, clk_c;
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
	always@(cke)
	begin
		clk_t = 1'b1; clk_c = 1'b0;
		if(cke == 1'b1)
			forever 
			begin 
				#5 clk_c = ~clk_c;
				   clk_t = ~clk_t;
			end
		else
			begin
				#5	clk_t = clk_t; 
					clk_c = clk_c;
			end
	end
/*-------------------------------------------------------------------------------
					ASSIGNING STATES BASED ON CLK_T
-------------------------------------------------------------------------------*/

	always_ff @(posedge clk_t or posedge clk_c)
	begin
		if(reset == 1'b1)
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
			if(act == 1'b1)
				next_state <= ACTIVATE;
			end

	ACTIVATE: 	begin
					if(act == 1'b1)
					begin
					  	next_bank = {bank_grp,bank_no};
					  	case(next_bank)
						BANK0_0 : sense_amp <= bank0_0[row_address][7:0];
						BANK0_1 : sense_amp <= bank0_1[row_address][7:0];
						BANK0_2 : sense_amp <= bank0_2[row_address][7:0];
						BANK0_3 : sense_amp <= bank0_3[row_address][7:0];
						BANK1_0 : sense_amp <= bank1_0[row_address][7:0];
						BANK1_1 : sense_amp <= bank1_1[row_address][7:0];
						BANK1_2 : sense_amp <= bank1_2[row_address][7:0];
						BANK1_3 : sense_amp <= bank1_3[row_address][7:0];
						endcase	
					  	if(cs == 1'b1)
					  	begin
						  	if(rwb == 1'b1 && auto_pre == 1'b1)
							next_state <= WRITE_A;
							else if(rwb == 1'b1 && auto_pre == 1'b0)
							next_state <= WRITE;
							else if(rwb == 1'b0 && auto_pre == 1'b1)
							next_state <= READ_A;
							else
							next_state <= READ;
						end
						else if(cs ==1'b0 && auto_pre == 1'b1)
							next_state <= PRECHARGE;	
				  	end
			  	end
	WRITE:	begin
				sense_amp[col_address] <= datain;
				
				if(cs == 1'b1)
			  	begin
				  	if(rwb == 1'b1 && auto_pre == 1'b1)
					next_state <= WRITE_A;
					else if(rwb == 1'b1 && auto_pre == 1'b0)
					next_state <= WRITE;
					else if(rwb == 1'b0 && auto_pre == 1'b1)
					next_state <= READ_A;
					else
					next_state <= READ;
				end
				else if(cs ==1'b0 && auto_pre == 1'b1)
					next_state <= PRECHARGE;
			end
	
	WRITE_A: begin
				sense_amp[col_address] <= datain;
				next_state <= PRECHARGE;
			 end
	
	READ:	begin
				dataout <= sense_amp[col_address];
				
				if(cs == 1'b1)
			  	begin
				  	if(rwb == 1'b1 && auto_pre == 1'b1)
					next_state <= WRITE_A;
					else if(rwb == 1'b1 && auto_pre == 1'b0)
					next_state <= WRITE;
					else if(rwb == 1'b0 && auto_pre == 1'b1)
					next_state <= READ_A;
					else
					next_state <= READ;
				end
				else if(cs ==1'b0 && auto_pre == 1'b1)
					next_state <= PRECHARGE;
			end
	
	READ_A:	begin
				dataout <= sense_amp[col_address];
				next_state <= PRECHARGE;
			end
			
	PRECHARGE:	begin
				case(current_bank)
				BANK0_0 : bank0_0[row_address] <= sense_amp;
				BANK0_1 : bank0_1[row_address] <= sense_amp;
				BANK0_2 : bank0_2[row_address] <= sense_amp;
				BANK0_3 : bank0_3[row_address] <= sense_amp;
				BANK1_0 : bank1_0[row_address] <= sense_amp;
				BANK1_1 : bank1_1[row_address] <= sense_amp;
				BANK1_2 : bank1_2[row_address] <= sense_amp;
				BANK1_3 : bank1_3[row_address] <= sense_amp;
				endcase	
				next_state <= IDLE;
				end
	endcase		
	end	
endmodule 
