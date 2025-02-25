`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Seiba 
// 
// Create Date: 22.02.2025 10:01:52
// Design Name: 
// Module Name: binaryBCD
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

module binaryBCD(
    input [5:0] minutes,
    input [4:0] hours,
    input [5:0] alarm_minutes,
    input [4:0] alarm_hours,
    output reg [7:0] bcd_minutes,  // Two-digit BCD for minutes
    output reg [7:0] bcd_hours,    // Two-digit BCD for hours
    output reg [7:0] alarm_bcd_minutes, // Two-digit BCD for alarm minutes
    output reg [7:0] alarm_bcd_hours    // Two-digit BCD for alarm hours
);

    integer i;
    reg [13:0] shift_reg_minutes, shift_reg_alarm_minutes;  // 14-bit shift register for minutes
    reg [12:0] shift_reg_hours, shift_reg_alarm_hours;    // 13-bit shift register for hours

    always @(*) begin
        // Convert minutes (6-bit binary) to 2-digit BCD.
        shift_reg_minutes = 14'b0;
        shift_reg_minutes[5:0] = minutes;
        // Loop iterations equal to the number of binary input bits (6).
        for (i = 0; i < 6; i = i + 1) begin
            if (shift_reg_minutes[9:6] >= 5)
                shift_reg_minutes[9:6] = shift_reg_minutes[9:6] + 3;
            if (shift_reg_minutes[13:10] >= 5)
                shift_reg_minutes[13:10] = shift_reg_minutes[13:10] + 3;
            shift_reg_minutes = shift_reg_minutes << 1;
        end
        // Extract the two 4-bit BCD digits from the upper bits.
        bcd_minutes = {shift_reg_minutes[13:10], shift_reg_minutes[9:6]};

        // Convert hours (4-bit binary) to 2-digit BCD.
        shift_reg_hours = 13'b0;
        shift_reg_hours[4:0] = hours;
        // Loop iterations equal to the number of binary input bits (4).
        for (i = 0; i < 5; i = i + 1) begin
            if (shift_reg_hours[8:5] >= 5)
                shift_reg_hours[8:5] = shift_reg_hours[8:5] + 3;
            if (shift_reg_hours[12:9] >= 5)
                shift_reg_hours[12:9] = shift_reg_hours[12:9] + 3;
            shift_reg_hours = shift_reg_hours << 1;
        end
        // Extract the two 4-bit BCD digits.
        bcd_hours = {shift_reg_hours[12:9], shift_reg_hours[8:5]};
        
        // Convert alarm minutes to BCD
        shift_reg_alarm_minutes = 14'b0;
        shift_reg_alarm_minutes[5:0] = alarm_minutes;
        for (i = 0; i < 6; i = i + 1) begin
            if (shift_reg_alarm_minutes[9:6] >= 5)
                shift_reg_alarm_minutes[9:6] = shift_reg_alarm_minutes[9:6] + 3;
            if (shift_reg_alarm_minutes[13:10] >= 5)
                shift_reg_alarm_minutes[13:10] = shift_reg_alarm_minutes[13:10] + 3;
            shift_reg_alarm_minutes = shift_reg_alarm_minutes << 1;
        end
        alarm_bcd_minutes = {shift_reg_alarm_minutes[13:10], shift_reg_alarm_minutes[9:6]};

        // Convert alarm hours to BCD
        shift_reg_alarm_hours = 13'b0;
        shift_reg_alarm_hours[4:0] = alarm_hours;
        for (i = 0; i < 5; i = i + 1) begin
            if (shift_reg_alarm_hours[8:5] >= 5)
                shift_reg_alarm_hours[8:5] = shift_reg_alarm_hours[8:5] + 3;
            if (shift_reg_alarm_hours[12:9] >= 5)
                shift_reg_alarm_hours[12:9] = shift_reg_alarm_hours[12:9] + 3;
            shift_reg_alarm_hours = shift_reg_alarm_hours << 1;
        end
        alarm_bcd_hours = {shift_reg_alarm_hours[12:9], shift_reg_alarm_hours[8:5]};

    end

endmodule

