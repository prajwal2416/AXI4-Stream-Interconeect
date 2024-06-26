`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2024 23:52:06
// Design Name: 
// Module Name: axis_master
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


module axis_master(
//global signals 
input i_mclk,
input i_mrst,
input[7:0]i_tdata,
//axis signals 
input 	   i_m_tready,
output reg o_m_tvalid,
output reg [4:0] o_m_tdest,
output reg [7:0] o_m_tdata,
output reg o_m_tlast
   
   );
	
reg [2:0] axis_state = 3'b0;
reg [3:0] cntr_tdest = 4'b0;
reg data_sent_flag0 = 0;
reg data_sent_flag1 = 0;


//axi_switch state
parameter IDLE 		   = 3'b0;
parameter SET_TVALID   = 3'b001;
parameter CHECK_TREADY = 3'b010;

always@(posedge i_mclk or posedge i_mrst)
	begin 
		if(i_mrst)
			begin 
			o_m_tdata  <= 0;
			o_m_tdest  <= 0;
			o_m_tlast  <= 0;
			o_m_tvalid <= 0;
			axis_state <= IDLE;
			end 
		else begin 
				case (axis_state)
					IDLE: begin 
							if(i_mrst)
							axis_state <= IDLE;
							else 
							axis_state <= SET_TVALID;
						  end 
					SET_TVALID: begin 
									if(cntr_tdest == 4'b0)
										begin 
											o_m_tvalid <= 1'b1;
											o_m_tdata  <= i_tdata;
											o_m_tdest  <= 5'b00001;
											o_m_tlast  <= 1'b1;
											cntr_tdest <= cntr_tdest +1;
											axis_state <= CHECK_TREADY;
										end 
									else if (cntr_tdest == 4'b0100)
										begin 
											o_m_tvalid <= 1'b1;
											o_m_tdata  <= i_tdata;
											o_m_tdest  <= 5'b00010;
											o_m_tlast  <= 1'b1;
											cntr_tdest <= cntr_tdest+1;
											axis_state <= CHECK_TREADY;
										end 
									else 
										axis_state <= IDLE; 
								end
					CHECK_TREADY: begin 
										if(i_m_tready && cntr_tdest < 4'b0100)
											begin 
												data_sent_flag0 <= 1'b1;
												axis_state      <= CHECK_TREADY;
												cntr_tdest      <= cntr_tdest+1;
											end 
										else if(i_m_tready && cntr_tdest == 4'b0100)
											begin 
												o_m_tvalid <= 1'b0;
												axis_state <= SET_TVALID;	
											end 
										else if(i_m_tready && cntr_tdest == 4'b0101 )
											begin 
												data_sent_flag1 <= 1'b1;
												axis_state      <= IDLE;
												cntr_tdest      <= 4'b0;
											end 
										else 
											axis_state <= CHECK_TREADY;
									end 
			endcase
			end 
	end 
	
	
endmodule
