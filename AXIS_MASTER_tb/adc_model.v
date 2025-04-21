`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2025 03:40:18 PM
// Design Name: 
// Module Name: adc_model
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
