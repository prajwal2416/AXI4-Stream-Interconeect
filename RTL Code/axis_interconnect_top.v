`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2024 23:53:14
// Design Name: 
// Module Name: axis_interconnect_top
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


module axis_interconnect_top(
input i_clk,
input i_rst,
input[7:0]i_tdata,
output[7:0]o_tdata
    );
//wires from master switch slave  
wire m_tready;
wire m_tvalid;
wire [4:0] m_tdest;
wire [7:0] m_tdata;
wire m_tlast;
//wires from switch master to slave0 and slave1
wire [1:0]m_tready01;
wire [1:0]m_tvalid01;
wire [9:0]m_tdest01;
wire [15:0]m_tdata01; 
wire [1:0]m_tlast01;




axis_master dut0( .i_mclk(i_clk),
				  .i_mrst(i_rst),
				  .i_tdata(i_tdata),
				  .i_m_tready(m_tready),
				  .o_m_tvalid(m_tvalid),
				  .o_m_tdest(m_tdest),
                  .o_m_tdata(m_tdata),
				  .o_m_tlast(m_tlast)
				  );
axis_switch dut1( .i_switch_clk(i_clk),
				  .i_switch_rst(i_rst),
				  .i_s_tvalid(m_tvalid),
				  .i_s_tlast(m_tlast),
				  .i_s_tdest(m_tdest),
				  .i_s_tdata(m_tdata),
				  .o_s_tready(m_tready),
				  .i_m_tready(m_tready01),
				  .o_m_tvalid(m_tvalid01),
				  .o_m_tdest(m_tdest01),
				  .o_m_tdata(m_tdata01),
				  .o_m_tlast(m_tlast01)
				  );
				  
axis_slave0 dut2( .i_sclk(i_clk),
				  .i_srst(i_rst),
				  .i_s0_tvalid(m_tvalid01[0]),
				  .i_s0_tdest(m_tdest01[4:0]),
				  .i_s0_tdata(m_tdata01[7:0]),
				  .i_s0_tlast(m_tlast01[0]),
				  .o_m_s0_tready(m_tready01[0])
				);
				
axis_slave1 dut3( .i_sclk(i_clk),
				  .i_srst(i_rst),
				  .i_s1_tvalid(m_tvalid01[1]),
				  .i_s1_tdest(m_tdest01[9:5]),
				  .i_s1_tdata(m_tdata01[15:8]),
				  .i_s1_tlast(m_tlast01[1]),
				  .o_m_s1_tready(m_tready01[1])
				);
endmodule
