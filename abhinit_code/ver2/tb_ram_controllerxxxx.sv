`timescale 1ns/1ps

module tb_ram_controller();

reg [1:0] bank_no;
reg bank_grp; 
reg rwb; 
reg auto_pre; 
reg act; 
reg reset; 
reg cs; 
reg cke; 
reg ras; 
reg cas; 
reg [2:0] row_address;
reg [2:0] col_address;
reg [15:0]datain;	
wire [15:0]dataout;

ram_controller dut(bank_grp, bank_no, rwb, auto_pre, act, reset, cs, cke, row_address, col_address, ras, cas, datain, dataout);

initial begin
	#10;
	cke = 1'b1;
	reset = 1'b1;
	cs = 1'b1;
	#10;
	
	act =1'b1;
	datain = 16'h7283;
	row_address = 3'b001;
	col_address = 3'b010;
	bank_grp = 0;
	bank_no = 0;
	rwb = 1'b0;
	
	#20;
	reset = 1'b0;
	#10;
	
	datain = 16'h7284;
	row_address = 3'b001;
	col_address = 3'b010;
	bank_grp = 0;
	bank_no = 0;
	rwb = 1'b1;
	
	#50;
	rwb =1'b0;auto_pre=1'b1;
	#50;
	rwb = 1'b1;
	bank_grp = 1;
	bank_no = 0;
	row_address = 3'b011;
	col_address = 3'b110;
	datain = 16'h7283;
	
	#20 cs = 1'b0;
	#50 reset = 1'b1;
	#50 $finish;
end
endmodule	
	
	
	
	
