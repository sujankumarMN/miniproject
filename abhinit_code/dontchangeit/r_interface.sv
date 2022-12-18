interface ram_interface(input cke,clk_t,clk_c); //input clk_t, input clk_c
	logic [1:0] bank_no;
	logic bank_grp, rwb, auto_pre, act, reset, cs, ras, cas; 
	logic [2:0] row_address; 
	logic [2:0] col_address;

	logic [15:0]datain;	//NEED TO CHECK INOUT
	logic [15:0]dataout;

	//logic clk_t, clk_c;
	//logic [15:0]sense_amp[7:0];

	//logic [7:0]mem[127:0];
	modport ram_controller(input cs,bank_grp,rwb,auto_pre,act,reset,cke,ras,cas,row_address,col_address,bank_no,datain,clk_t,clk_c,output dataout);
endinterface



