`include "r_interface.sv"
`include "ram_controller.sv"
`include "r_package.sv"
import r_package::*;
`include "r_environment.sv"
module tb_ram_controller();
/*reg [1:0] bank_no;
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
wire [15:0]dataout;*/
//bit cke;
bit cke,clk_t,clk_c;
initial cke = 1'b1;

//always@(cke)
initial	begin
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

ram_interface rintf(cke,clk_t,clk_c);
ram_controller dut(rintf);
ram_env renv(rintf);


//ram_interface();


initial begin
	/*#10;

	rintf.reset = 1'b1;
	#10;
	
	rintf.act =1'b1;
	rintf.datain = 16'h7283;
	rintf.row_address = 3'b001;
	rintf.col_address = 3'b010;
	rintf.bank_grp = 0;
	rintf.bank_no = 0;
	rintf.rwb = 1'b0;
	
	#20;
	rintf.reset = 1'b0;
	#10;
	
	rintf.datain = 16'h7284;
	rintf.row_address = 3'b001;
	rintf.col_address = 3'b010;
	rintf.bank_grp = 0;
	rintf.bank_no = 0;
	rintf.rwb = 1'b1;
	
	#50;
	rintf.rwb =1'b0;rintf.auto_pre=1'b1;*/
	#200 $finish;
end
endmodule	
	
	
	
	
