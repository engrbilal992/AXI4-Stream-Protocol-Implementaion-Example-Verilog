`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2025 03:38:54 PM
// Design Name: 
// Module Name: t_axis_master_adc
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


module t_axis_master_adc;

reg adc_clk;
wire [13:0] adc_data;
reg m_axis_aclk;
reg m_axis_aresetn;
wire [15 : 0] m_axis_tdata;
wire [1 : 0]  m_axis_tstrb;
wire [1 : 0]  m_axis_tkeep;
wire m_axis_tvalid;
wire m_axis_tready;
wire m_axis_tlast;

reg [5:0] lfsr;
reg [15:0] data_check;
reg [15:0] rem_value;
reg error;
reg tlast_error;
integer i;

initial
begin
  adc_clk = 1'b0;
  m_axis_aclk = 1'b0;
  m_axis_aresetn = 1'b0;
  lfsr = 6'b100000;
  for (i= 0; i < 5; i=i+1) @(posedge m_axis_tlast);
  $finish;
end

always
  #20 m_axis_aclk = ~m_axis_aclk;

always
  #50 adc_clk = ~adc_clk;

axis_master_adc uut (
  .adc_clk(adc_clk),
  .adc_data(adc_data),
  .m_axis_aclk(m_axis_aclk),
  .m_axis_aresetn(m_axis_aresetn),
  .m_axis_tdata(m_axis_tdata),
  .m_axis_tstrb(m_axis_tstrb),
  .m_axis_tkeep(m_axis_tkeep),
  .m_axis_tvalid(m_axis_tvalid),
   .m_axis_tlast(m_axis_tlast),
 .m_axis_tready(m_axis_tready)
);

adc_model adc_model_inst (
  .adc_clk(adc_clk),
  .adc_data(adc_data)
  );
initial
begin
 m_axis_aresetn = 1'b0;
 #200 m_axis_aresetn = 1'b1;
 
end

always@(posedge m_axis_aclk) begin
    lfsr[0]   <= lfsr[5] ^ lfsr[4] ^ 1'b1;
    lfsr[5:1] <= lfsr[4:0];
end
assign m_axis_tready = lfsr[5];

initial begin
  while( !((m_axis_tvalid === 1) && (lfsr[5] == 1))) @(posedge m_axis_aclk);
  data_check = m_axis_tdata;
  rem_value  = m_axis_tdata;
  while (1) begin   
    @(posedge m_axis_aclk);
    if ((m_axis_tvalid == 1) && (lfsr[5] == 1))
      data_check = data_check + 1;
    if ((m_axis_tdata != data_check) && (m_axis_tvalid == 1) && (lfsr[5] == 1))
      error = 1;
    else
      error = 0;
    
    if (((m_axis_tdata%64) != rem_value) && (m_axis_tvalid == 1) && (m_axis_tlast == 1) && (lfsr[5] == 1))
      tlast_error = 1;
    else
      tlast_error = 0;

  end
end
endmodule

