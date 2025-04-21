`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2025 02:59:18 PM
// Design Name: 
// Module Name: async_fifo
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

module async_fifo
(
    input  wire         wr_clk,
    input  wire         wr_en,
    input  wire [13: 0] wr_data,
    input  wire         rd_clk,
    input  wire         rd_en,
    output wire [13: 0] rd_data,
    output wire         fifo_empty,
    output wire         fifo_afull
);

reg [3:0] wr_addr = 4'b0000;
wire [3:0] wr_addr_grey;
reg [3:0] wr_addr_grey_sync;
reg [3:0] wr_addr_grey_sync2;
wire [3:0] wr_addr_sync;

reg [3:0] rd_addr = 4'b0000;
wire [3:0] rd_addr_grey;
reg [3:0] rd_addr_grey_sync;
reg [3:0] rd_addr_grey_sync2;
wire [3:0] rd_addr_sync;

wire [3:0] fifo_space;
wire full;
wire empty;

reg [13:0] fifo_memory [0:15];

assign wr_addr_grey = {wr_addr[3],wr_addr[3] ^ wr_addr[2],wr_addr[2] ^ wr_addr[1],wr_addr[1] ^ wr_addr[0]};

assign wr_addr_sync = {wr_addr_grey_sync2[3],wr_addr_grey_sync2[3] ^ wr_addr_grey_sync2[2],
                  wr_addr_grey_sync2[3] ^ wr_addr_grey_sync2[2] ^ wr_addr_grey_sync2[1],
                 wr_addr_grey_sync2[3] ^ wr_addr_grey_sync2[2] ^ wr_addr_grey_sync2[1] ^ wr_addr_grey_sync2[0]};

assign rd_addr_grey = {rd_addr[3],rd_addr[3] ^ rd_addr[2],rd_addr[2] ^ rd_addr[1],rd_addr[1] ^ rd_addr[0]};

assign rd_addr_sync = {rd_addr_grey_sync2[3],rd_addr_grey_sync2[3] ^ rd_addr_grey_sync2[2],
                 rd_addr_grey_sync2[3] ^ rd_addr_grey_sync2[2] ^ rd_addr_grey_sync2[1],
                 rd_addr_grey_sync2[3] ^ rd_addr_grey_sync2[2] ^ rd_addr_grey_sync2[1] ^ rd_addr_grey_sync2[0]};

assign fifo_space =  wr_addr - rd_addr_sync;
assign full       =  (fifo_space > 14) ? 1:0;
assign fifo_afull =  (fifo_space > 13) ? 1:0;
assign empty      =  ((rd_addr == wr_addr_sync) ? 1:0);
assign fifo_empty = empty;

always @(posedge wr_clk)
begin
  if ((full == 0) && (wr_en == 1))
    wr_addr <= wr_addr + 1;
 end

always @(posedge wr_clk)
begin
    rd_addr_grey_sync  <= rd_addr_grey;
    rd_addr_grey_sync2 <= rd_addr_grey_sync;
 end

always @(posedge wr_clk)
begin
    if ((full == 0) && (wr_en == 1))
      fifo_memory[wr_addr] <= wr_data;
end

assign rd_data = fifo_memory[rd_addr];
always @(posedge rd_clk)
begin
    wr_addr_grey_sync  <= wr_addr_grey;
    wr_addr_grey_sync2 <= wr_addr_grey_sync;
end

always @(posedge rd_clk)
begin
  if ((rd_en == 1) && (empty == 0))
    rd_addr <=rd_addr + 1;

end

endmodule
