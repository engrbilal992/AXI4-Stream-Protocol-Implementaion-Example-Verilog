`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Muhammad Bilal Sajid
// 
// Create Date: 04/21/2025 11:25:41 AM
// Design Name:  AXI4_Stream_Simple_Implementation
// Module Name: axis_master
// Project Name: AXI4_Stream_Simple_Implementation
// Target Devices:  Any (This Project only verifies for Test Bench)
// Tool Versions:  2024.1
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module axis_master_adc
(
  input  wire         adc_clk,
  input  wire [13: 0] adc_data,
  input  wire         m_axis_aclk,
  input  wire         m_axis_aresetn,
  output wire [15: 0] m_axis_tdata,
  output wire [1 : 0] m_axis_tstrb,
  output wire [1 : 0] m_axis_tkeep,
  output reg          m_axis_tvalid,
  input  wire         m_axis_tready,
  output reg          m_axis_tlast
);

wire fifo_empty;
wire fifo_afull;
reg rd_en;
reg  wr_en;
reg [5:0] data_count;
wire [13:0] rd_data;
reg wr_en_sync;
reg m_axis_aresetn_reg;

localparam INIT = 0,
           VALID_DATA = 1,
           STALL_DATA = 2,
           SLAVE_STALL = 3;
reg [1:0] state, next_state = 2'b00;

async_fifo fifo_inst
  ( .wr_clk(adc_clk),    
	.wr_en(wr_en),
	.wr_data (adc_data),
    .rd_clk(m_axis_aclk),
    .rd_en(rd_en),
    .rd_data(rd_data),
    .fifo_empty(fifo_empty),
    .fifo_afull(fifo_afull)
);

assign m_axis_tkeep = 2'b11;
assign m_axis_tstrb = 2'b11;
assign m_axis_tdata[13:0]  = rd_data;
assign m_axis_tdata[15:14] = "00";

always @(posedge adc_clk)
begin
  if (state == INIT)
    wr_en_sync <= 1'b0;
  else
    wr_en_sync <= 1'b1;

  wr_en <= wr_en_sync;
end
      
always @(state,fifo_empty,m_axis_tready,data_count) begin
  next_state = state;
  case (state)
    INIT: begin
      if ((m_axis_aresetn == 0) || (m_axis_aresetn_reg == 0))
        next_state = INIT;
      else if (fifo_empty == 1)
        next_state = STALL_DATA;
      else if (m_axis_tready == 0)
        next_state = SLAVE_STALL;
      else if (fifo_empty == 0)
        next_state = VALID_DATA;
    end
    VALID_DATA: begin
      if (m_axis_tready == 0)
        next_state = SLAVE_STALL;
      else if (fifo_empty == 1)
        next_state = STALL_DATA;
    end
    STALL_DATA: begin
      if ((m_axis_tready == 0)  && (fifo_empty == 0))
        next_state = SLAVE_STALL;
      else if (fifo_empty == 0)
        next_state = VALID_DATA;
    end
    SLAVE_STALL: begin
      if ((m_axis_tready == 1) && (fifo_empty == 0))
        next_state = VALID_DATA;
      else if (m_axis_tready == 1) 
        next_state = STALL_DATA;
    end
    default: next_state = INIT;
    endcase
end

always @(posedge m_axis_aclk)
begin
  m_axis_aresetn_reg <= m_axis_aresetn;
  if (m_axis_aresetn == 0)
    state <= INIT;
  else
    state <= next_state;
end

always @(posedge m_axis_aclk)
begin
  if (next_state == INIT) begin 
    data_count <= 0;
    m_axis_tlast <= 0;
  end
  else if ((next_state == VALID_DATA) && (data_count == 63)) begin
    data_count <= 0;
    m_axis_tlast <= 1;
  end
  else if (next_state == VALID_DATA) begin
    data_count <= data_count + 1;
    m_axis_tlast <= 0;
  end 
end

always @(next_state) begin
  case (next_state)
    INIT: begin
      m_axis_tvalid = 0;
      rd_en = 0;
    end
    VALID_DATA: begin
      m_axis_tvalid = 1;
      rd_en = 1;
    end
    STALL_DATA: begin
      m_axis_tvalid = 0;
      rd_en = 0;
    end
    SLAVE_STALL: begin
      m_axis_tvalid = 1;
      rd_en = 0;
    end
  endcase
end

endmodule


