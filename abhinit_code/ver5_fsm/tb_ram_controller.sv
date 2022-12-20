`include "r_interface.sv"
`include "ram_controller.sv"
`include "r_package.sv"
import r_package::*;
`include "r_environment.sv"
module tb_ram_controller();
    bit cke,clk_t,clk_c;
    initial cke = 1'b1;

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

  initial begin
    #800 $finish;
  end
endmodule	
