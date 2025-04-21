`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Muhammad Bilal Sajid
// 
// Create Date: 04/21/2025 11:25:41 AM
// Design Name:  AXI4_Stream_Simple_Implementation
// Module Name: axis_slave_mem
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


module t_axis_slave_mem();

reg s_axis_aclk;                   // AXI Stream Master Clock
reg s_axis_aresetn;              // AXI Stream Reset , Active Low
reg [31 : 0] s_axis_tdata;     // AXI Stream Master Data word
reg [3 : 0] s_axis_tstrb;        // Byte Control, not dynamic in this design
reg [3 : 0] s_axis_tkeep;      // Byte Control, not dynamic in this design
wire s_axis_tvalid;                 // AXI Stream Master Data word valid
wire s_axis_tready;             // Ready to receive Data
wire s_axis_tlast;                    // Last data word in a frame
reg [5 : 0] lfsr = 6'b000011;

initial begin
    s_axis_aclk = 1'b0;
end

always #50 s_axis_aclk = ~ s_axis_aclk;

axis_slave_mem uut (
 .s_axis_aclk(s_axis_aclk),
 .s_axis_aresetn(s_axis_aresetn),
 .s_axis_tdata(s_axis_tdata),
 .s_axis_tstrb(s_axis_tstrb),
 .s_axis_tkeep(s_axis_tkeep),
 .s_axis_tvalid(s_axis_tvalid),
 .s_axis_tready(s_axis_tready),
 .s_axis_tlast(s_axis_tlast)
);

always @(posedge s_axis_aclk) begin
  if ((s_axis_tready == 1) || ((s_axis_tready == 0) && (s_axis_tvalid == 0))) begin
    lfsr[0] <= lfsr[5] ^ lfsr[4] ^ 1'b1;
    lfsr[5:1] <= lfsr[4:0];
  end
end

assign s_axis_tvalid = lfsr[5];
assign s_axis_tlast = (lfsr[5] & (s_axis_tdata == 127));

initial begin
    s_axis_aresetn = 1'b0;
    s_axis_tstrb = 4'b1111;
    s_axis_tkeep = 4'b1111;
    s_axis_tdata= 32'd0;
    @(posedge s_axis_aclk);
    @(posedge s_axis_aclk);
    @(posedge s_axis_aclk);
    s_axis_aresetn = 1'b1;
end
 
always @(posedge s_axis_aclk) begin
  if ((s_axis_tvalid == 1) && (s_axis_tready == 1)) begin
    if (s_axis_tdata == 127) 
      s_axis_tdata <= 0;
    else
      s_axis_tdata <= s_axis_tdata + 1;
  end
end

endmodule
