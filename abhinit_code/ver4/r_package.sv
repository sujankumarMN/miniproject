
package r_package;
	typedef enum {write,read,write_a,read_a,w_precharge,r_precharge,w_reset,r_reset,self,w_burst,r_burst,rw_burst,refresh,activate} ram_type;
	
	class ram_transaction;
		bit rwb, auto_pre, act, reset, cs, cke,burst_mode;
		
		randc bit bank_grp;
	
		
		randc bit [1:0] bank_no;
		randc bit [2:0] row_address;
		randc bit [2:0] col_address;
		randc bit [2:0] burst_len;
		randc bit [15:0]datain;
		bit [15:0]dataout;
		bit clk_t, clk_c;
		bit [15:0]sense_amp[7:0];

	
		ram_type rtype;
	endclass
endpackage:r_package















































	/*bit [15:0]bank0_0[7:0][7:0];
		bit [15:0]bank0_1[7:0][7:0];
		bit [15:0]bank0_2[7:0][7:0];
		bit [15:0]bank0_3[7:0][7:0];

		bit [15:0]bank1_0[7:0][7:0];
		bit [15:0]bank1_1[7:0][7:0];
		bit [15:0]bank1_2[7:0][7:0];
		bit [15:0]bank1_3[7:0][7:0];*/
		

/*input bit [1:0] bank_no;
input bit bank_grp, rwb, auto_pre, act, reset, cs, cke, ras, cas; 
input bit [2:0] row_address; 
input bit [2:0] col_address;


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

	logic [15:0]sense_amp[7:0];*/
