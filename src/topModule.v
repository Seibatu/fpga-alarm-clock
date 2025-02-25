`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Seiba 
// 
// Create Date: 22.02.2025 10:03:24
// Design Name: 
// Module Name: topModule
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
/* 
    This is the top-level module for the Clock. It integrates all sub-modules, 
    including the FSM control unit, clcok divider, time display and inputs.
    
    Usage
    //   Ensure all required modules are included in your Verilog project before simulating or synthesizing.
*/
// Dependencies: 
/*
    - `clkDivider.v` (Clock control logic)
    - `fsmClockCtrl.v` (FSM control logic)
    - `binaryBCD.v` (Converts binary time values to BCD)
    - `sevenSegment.v` (Display unit)
*/
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module topModule (
    input clk, rst,
    input S1, S2, // Move the clock to Set_time mode and Set_alaem mode 
    input S3, // Allows minutes to be incremented when in set mode 
    input S4, // Allows hours to be incremented when in set mode 
    input S5, // Activate the alarm 
    input S6, // Turns the entire clock on/off 
    input S7, // Mutes the alarm clock 
    input PB1, // stops alarm after it has started ringing 
    output Buzzer, // buzzes when the alarm is trigged and not muted 
    output LED0, LED1,
    output wire [7:0] seg_7_display,
    output wire [7:0] active_low_anode
);
   
    wire slw_clk;
    wire [5:0] minutes;
    wire [4:0] hours;
    wire [5:0] alarm_minutes;
    wire [4:0] alarm_hours;
    wire [7:0] bcd_minutes;
    wire [7:0] bcd_hours;
    wire [7:0] alarm_bcd_minutes;
    wire [7:0] alarm_bcd_hours;
    wire [7:0] display_minutes;
    wire [7:0] display_hours;
    
    // Instantiate clock divider unit 
    clkDivider clock_divider (
        .clk(clk),
        .rst(rst),
        .slw_clk(slw_clk)
    );

    // Instantiate alarm control unit 
    fsmClockCtrl fsm_time_ctrl (
        .slw_clk(slw_clk),
        .rst(rst),
        .S1(S1),
        .S2(S2),
        .S3(S3), 
        .S4(S4),
        .S5(S5), 
        .S6(S6), 
        .S7(S7), 
        .PB1(PB1), 
        .Buzzer(Buzzer),
        .minutes(minutes),
        .hours(hours),
        .alarm_minutes(alarm_minutes),
        .alarm_hours(alarm_hours),
        .LED0(LED0),
        .LED1(LED1)
    );
    
    // Instantiate binary to BCD module
    binaryBCD binary_to_BCD (
         .minutes(minutes),
         .hours(hours),
         .alarm_minutes(alarm_minutes),
         .alarm_hours(alarm_hours),
         .bcd_minutes(bcd_minutes),
         .bcd_hours(bcd_hours),
         .alarm_bcd_minutes(alarm_bcd_minutes),
         .alarm_bcd_hours(alarm_bcd_hours)
         );

    // **MUX Logic**: If in Set_alarm mode (S2=1), display alarm time. Else, show current time.
    assign display_minutes = (S2) ? alarm_bcd_minutes : bcd_minutes;
    assign display_hours = (S2) ? alarm_bcd_hours : bcd_hours;
    
    // Instantiate 7-segment display control unit 
    sevenSegment dsp_ctrl_unit (
        .clk(clk),
        .rst(rst),
        .display_minutes(display_minutes),
        .display_hours(display_hours),
        .seg_7_display(seg_7_display),
        .active_low_anode(active_low_anode)                   
    );

endmodule
