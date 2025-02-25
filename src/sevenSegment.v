`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Seiba 
// 
// Create Date: 22.02.2025 10:01:52
// Design Name: 
// Module Name: sevenSegment
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


module sevenSegment #(parameter integer n = 100_000)(
    input clk, 
    input rst,
    input [7:0] display_minutes,
    input [7:0] display_hours,
    output reg [7:0] seg_7_display,
    output reg [7:0] active_low_anode
);

    // Refresh rate: using n cycles for a refresh period (e.g., n=100_000 for 1kHz refresh with a 100MHz clock)
    reg [$clog2(n)-1:0] digit_count;
    reg [2:0] digit_for_display;
    reg [3:0] disp_val; // Selected BCD digit to be shown on the display

    // Digit refresh counter: cycles through the digits to be displayed
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            digit_count <= 0;
            digit_for_display <= 0;
        end else if (digit_count == n-1) begin
            digit_for_display <= digit_for_display + 1;
            digit_count <= 0;
        end else begin
            digit_count <= digit_count + 1;
        end
    end

    // Activate one digit at a time (active low anodes)
    always @(*) begin
        case (digit_for_display)
            3'b000: active_low_anode = 8'b1111_1110;
            3'b001: active_low_anode = 8'b1111_1101;
            3'b010: active_low_anode = 8'b1111_1011;
            3'b011: active_low_anode = 8'b1111_0111;
            default: active_low_anode = 8'b1111_1111; // All off
        endcase
    end

    // Select which BCD digit to display based on the active digit
    always @(*) begin
        case (digit_for_display)
            3'b000: disp_val = display_minutes[3:0];
            3'b001: disp_val = display_minutes[7:4];
            3'b010: disp_val = display_hours[3:0];
            3'b011: disp_val = display_hours[7:4];
            default: disp_val = 4'b0;
        endcase
    end

    // Convert the selected BCD digit into the corresponding 7-segment active low code
    always @(*) begin
        case (disp_val)
            4'b0000: seg_7_display = 8'b1100_0000; // 0
            4'b0001: seg_7_display = 8'b1111_1001; // 1
            4'b0010: seg_7_display = 8'b1010_0100; // 2
            4'b0011: seg_7_display = 8'b1011_0000; // 3
            4'b0100: seg_7_display = 8'b1001_1001; // 4
            4'b0101: seg_7_display = 8'b1001_0010; // 5
            4'b0110: seg_7_display = 8'b1000_0010; // 6
            4'b0111: seg_7_display = 8'b1111_1000; // 7
            4'b1000: seg_7_display = 8'b1000_0000; // 8
            4'b1001: seg_7_display = 8'b1001_0000; // 9
            default: seg_7_display = 8'b1100_0000; // off  
        endcase
    end

endmodule
