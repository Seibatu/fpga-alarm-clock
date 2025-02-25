`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.02.2025 10:03:24
// Design Name: 
// Module Name: clkDivider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// Generates a 1s clock from a 10ns clock input 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module clkDivider #(parameter integer N = 100_000_000) (
    input clk, 
    input rst, 
    output reg slw_clk
);
     
    // Counter to count half the period (N/2 cycles)
    reg [$clog2(N/2)-1:0] cnt_tmp;
    
    // Toggle slw_clk every (N/2) cycles
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt_tmp  <= 0;
            slw_clk  <= 0;
        end
        else if (cnt_tmp == (N/2)-1) begin
            slw_clk  <= ~slw_clk;
            cnt_tmp  <= 0;
        end
        else begin
            cnt_tmp  <= cnt_tmp + 1;
        end
    end

endmodule
