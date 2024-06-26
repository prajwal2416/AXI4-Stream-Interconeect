`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2024 11:56:22
// Design Name: 
// Module Name: axis_interconnect_top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module axis_interconnect_top_tb();

reg i_clk_tb;
reg i_rst_tb;
reg[7:0]i_tdata_tb; 
wire [7:0]o_tdata_tb;   
	
axis_interconnect_top dut( .i_clk(i_clk_tb),
						   .i_rst(i_rst_tb),
						   .i_tdata(i_tdata_tb),
						   .o_tdata(o_tdata_tb));
						   
initial begin 
i_clk_tb = 1'b0; 
forever begin 
#5 i_clk_tb = ~i_clk_tb;
end 
end 

initial begin 
i_rst_tb = 1'b1; #15;
i_rst_tb = 1'b0; i_tdata_tb = 8'h56; #45;
i_tdata_tb = 8'h89; #75;
i_rst_tb = 1'b0; #10;

end
 
initial begin 
#135 $finish;
end 

endmodule 

	
	
	
	
	

