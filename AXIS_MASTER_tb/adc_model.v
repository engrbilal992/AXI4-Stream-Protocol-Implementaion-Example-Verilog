`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Muhammad Bilal Sajid
// 
// Create Date: 04/21/2025 11:25:41 AM
// Design Name:  AXI4_Stream_Simple_Implementation
// Module Name: adc
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



module adc_model
(
    input  wire         adc_clk,
    output reg  [13: 0] adc_data
);

initial begin
    adc_data = 14'b0;
end

always@(posedge adc_clk) begin
  adc_data <= adc_data + 1;
end

endmodule
