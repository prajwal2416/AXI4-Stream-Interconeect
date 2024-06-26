`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2024 23:43:18
// Design Name: 
// Module Name: axi_switch
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


module axis_switch(
//global signals 
input i_switch_clk,
input i_switch_rst,

//axis_slave from master signals
input i_s_tvalid,
input i_s_tlast,
input [4:0]i_s_tdest,
input [7:0]i_s_tdata,
output reg o_s_tready,

//axis_master to slave signals
input 	   [1:0]  i_m_tready,
output reg [1:0]  o_m_tvalid,
output reg [9:0]  o_m_tdest,
output reg [15:0] o_m_tdata,
output reg [1:0]  o_m_tlast   

);
reg data_sent_flag0 = 1'b0;
reg data_sent_flag1 = 1'b0;
reg[3:0] axis_state = 3'b000;
reg[7:0] input_data = 8'b0;
reg[3:0] cntr_rr    = 4'b0000;


parameter IDLE = 3'b000;
parameter CHECK_TVALID  = 3'b001;
parameter CHECK_TREADY0 = 3'b010;
parameter CHECK_TREADY1 = 3'b011;

always @(posedge i_switch_clk or posedge i_switch_rst )
	begin 
		if(i_switch_rst)
			begin 
				o_m_tdata <= 0;
				o_m_tdest <= 0;
				o_m_tlast <= 0;
				o_m_tvalid <= 0;
				o_s_tready <= 0;
			end 
		else begin 
				case(axis_state)
					IDLE: begin 
							if(i_switch_rst)
							axis_state <= IDLE;
							else begin 
							data_sent_flag0 = 1'b0;
                            data_sent_flag1 = 1'b0;
							axis_state <= CHECK_TVALID;
							end
						  end 
					CHECK_TVALID: begin 
									if((i_s_tvalid && cntr_rr == 4'b0) || (i_s_tvalid && cntr_rr == 4'b0101)) 
										begin 
											input_data <= i_s_tdata;
											o_s_tready <= 1'b1;
											cntr_rr    <= cntr_rr+1;
											axis_state <= CHECK_TVALID;	
										end 
									else if(cntr_rr == 4'b0001) 
										begin 
											o_m_tvalid <= 2'b01;
											o_m_tdata  <= {input_data,input_data};
											o_m_tdest  <= 10'b0000100001;
											o_m_tlast  <= 2'b01;
											//cntr_rr    <= cntr_rr+1;
											axis_state <= CHECK_TREADY0;
										end 
									else if(cntr_rr > 4'b0001 & cntr_rr < 4'b0101) //wait here for 3 clock cycle to get next data
										begin 
											o_m_tvalid <= 2'b00;
											o_m_tdata  <= 16'b0;
											o_m_tdest  <= 10'b0;
											o_m_tlast  <= 2'b00;
											cntr_rr    <= cntr_rr+1;
											axis_state <= CHECK_TVALID;
										end 
									else if(cntr_rr == 4'b0110)
										begin 
											o_m_tvalid <= 2'b10;
											o_m_tdata  <= {input_data,input_data};
											o_m_tdest  <= 10'b0001000010;
											o_m_tlast  <= 2'b10;
											cntr_rr    <= 2'b00;
											axis_state <= CHECK_TREADY1;
										end 
									else 
										axis_state <= CHECK_TVALID;
								end 		
					CHECK_TREADY0:begin 
									if(i_m_tready==2'b11)
										begin 
											data_sent_flag0 <= 1'b1;
											cntr_rr         <= cntr_rr+1;
											axis_state      <= CHECK_TVALID;
										end 
									else 
										axis_state <= CHECK_TREADY0;
								end 
					CHECK_TREADY1:begin 
									if(i_m_tready==2'b11)
										begin 
											data_sent_flag1 <= 1'b1;
											cntr_rr         <= 2'b00;
											axis_state      <= IDLE;
										end 
									else 
										axis_state <= CHECK_TREADY1;
								end 
				endcase 
			end 
	end
endmodule
