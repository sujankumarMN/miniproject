interface ram_interface(input cke,clk_t,clk_c); //input clk_t, input clk_c

	logic bank_grp, rwb, auto_pre, act, reset, cs,burst_mode; 
	logic [2:0] row_address; 
	logic [2:0] col_address;
	logic [2:0] burst_len;
	logic [1:0] bank_no;

	logic [15:0] datain;	
	logic [15:0] dataout;
	

	//logic [15:0]sense_amp[7:0];

	//logic [7:0]mem[127:0];
	modport ram_controller(input cs,bank_grp,rwb,auto_pre,act,reset,cke,row_address,col_address,bank_no,datain,clk_t,clk_c,output dataout);
endinterface



