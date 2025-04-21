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


module axis_slave_mem
(
    input  wire         s_axis_aclk,
    input  wire         s_axis_aresetn,
    input  wire [31: 0] s_axis_tdata,
    input  wire [3 : 0] s_axis_tstrb,
    input  wire [3 : 0] s_axis_tkeep,
    input  wire         s_axis_tvalid,
    output wire         s_axis_tready,
    input  wire         s_axis_tlast
);

parameter FLOW_SIM = 1;
reg [6 : 0] memory_address;
reg [31 : 0] data_memory [0 : 127];
reg s_axis_aresetn_reg;
reg [5 : 0] lfsr;

always @ (posedge s_axis_aclk)
    begin
        s_axis_aresetn_reg <= s_axis_aresetn;
        if(s_axis_aresetn == 0)
            lfsr <= 6'b000101;
        else
            if ((s_axis_tvalid == 1) || (s_axis_tvalid == 0) && (lfsr[5] == 0))
            begin
                lfsr[0] <= lfsr[5] ^ lfsr[4] ^ 1'b1;
                lfsr[5:1] <= lfsr[4:0];
            end
    end
    
assign s_axis_tready = ((s_axis_aresetn == 0) || (s_axis_aresetn_reg == 0)) ? 1'b0 : FLOW_SIM ? lfsr[5] : 1'b1;

always @ (posedge s_axis_aclk)
    begin
        if (s_axis_aresetn == 0)
            memory_address <= 7'h00;
        else begin
            if ((s_axis_tvalid == 1) && (s_axis_tready == 1))
                memory_address <= memory_address + 1;
            else if ((s_axis_tlast ==1) && (s_axis_tvalid == 1) && (s_axis_tready == 1))
                memory_address <= 0;
        end
    end
   
always @ (posedge s_axis_aclk)
    begin
        if ((s_axis_tvalid == 1) && (s_axis_tready == 1))
            data_memory[memory_address] <= s_axis_tdata;
    end
    
endmodule
