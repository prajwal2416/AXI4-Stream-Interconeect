`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2024 23:52:41
// Design Name: 
// Module Name: axis_slave0
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


module axis_slave0(
input i_sclk,
input i_srst,
input i_s0_tvalid,
input [4:0]i_s0_tdest,
input [7:0]i_s0_tdata,
input i_s0_tlast,
output reg o_m_s0_tready
);

reg [1:0] axis_state = 2'b00;
reg received_data_flag = 1'b0;
reg [7:0] received_data = 8'b0;

parameter IDLE = 2'b00;
parameter CHECK_TVALID_TDEST = 2'b01;

always@(posedge i_sclk or posedge i_srst)
begin
	if(i_srst)
		begin
			o_m_s0_tready <= 1'b0;
		end 
	else begin 
		case(axis_state)
			IDLE : begin 
				   if(i_srst)
						begin
							axis_state <= IDLE;
						end 
					else begin 
						o_m_s0_tready 	   <= 1'b1;
						received_data_flag <= 1'b0;
						received_data 	   <= 8'b0;
						axis_state  	   <= CHECK_TVALID_TDEST;
						end 
				   end 
			CHECK_TVALID_TDEST: begin 
									if(i_s0_tvalid && i_s0_tdest == 5'b00001)
										begin 
											received_data 	   <= i_s0_tdata;
											received_data_flag <= 1'b1;
											o_m_s0_tready         <= 1'b0;
											axis_state         <= IDLE;
										end 
									else begin 
										axis_state <= CHECK_TVALID_TDEST;
										end 
								end 				
		endcase 
		end 
end  
endmodule 
