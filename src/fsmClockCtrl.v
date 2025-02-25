`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Seiba 
// 
// Create Date: 22.02.2025 10:02:44
// Design Name: 
// Module Name: fsmClockCtrl
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

module fsmClockCtrl(
    input slw_clk, rst,
    input S1, S2,      // Enter Set_time and Set_alarm modes, respectively
    input S3,         // Increment minutes in set modes
    input S4,         // Increment hours in set modes
    input S5,         // Activate the alarm
    input S6,         // Turn off the clcok 
    input S7,         // Mute the alarm
    input PB1,        // Stop the alarm once it has started ringing
    output reg Buzzer, // Buzzer output 
    output reg [5:0] minutes,
    output reg [4:0] hours,
    output reg [5:0] alarm_minutes,
    output reg [4:0] alarm_hours,
    output reg LED0, LED1
);

    // State encoding
    localparam Time      = 2'b00,
               Set_time  = 2'b01,
               Set_alarm = 2'b10,
               Alarm     = 2'b11;

    reg [1:0] state;
    reg [5:0] seconds;
    
    
    // Blinking counters (assume slw_clk = 1 Hz)
    reg time_led_counter;        // For LED0 in Time state: mod2 counter (50% duty cycle, period=2s)
    reg [1:0] alarm_led_counter; // For LED0 in Alarm state: mod4 counter (LED on for counts 0-2, off at 3)
    reg alarm_buzzer_counter;    // For buzzer in Alarm state: mod2 counter (50% duty cycle, period=2s)
    reg prv_S5; 
    wire S5_edge;        // Edge detection of S5 
    
    // Detect rising edges
    assign S5_edge = S5 & ~prv_S5;
    //assign b_edge = b & ~prv_b;
    
    always @ (posedge slw_clk or posedge rst) begin
        if (rst) begin 
            prv_S5 <= 0;
           // prv_b <= 0;
        end 
        else begin 
            prv_S5 <= S5;
            //prv_b <= b;
        end 
    end   
    

    // Single always block for state updates, outputs, and sequential logic
    always @(posedge slw_clk or posedge rst) begin
        if (rst) begin
            state               <= Time;
            minutes             <= 6'd0;
            seconds             <= 6'd0;
            hours               <= 5'd0;
            alarm_minutes       <= 6'd0;
            alarm_hours         <= 5'd0;
            time_led_counter    <= 1'b0;
            alarm_led_counter   <= 2'd0;
            alarm_buzzer_counter<= 1'b0;
            LED0                <= 1'b0;
            LED1                <= 1'b0;
            Buzzer              <= 1'b0;

        end 
        else if (S6) begin
            // When S6 is high, freeze all counters and force outputs off.
            state         <= state;   // Keep current state
            minutes       <= minutes;
            seconds       <= seconds;
            hours         <= hours;
            alarm_minutes <= alarm_minutes;
            alarm_hours   <= alarm_hours;
            LED0          <= 1'b0;
            LED1          <= 1'b0;
            Buzzer        <= 1'b0;
        end
        else begin
            case (state)
                Time: begin
                    // Update the time counters
                    if (seconds == 6'd59) begin
                        seconds <= 6'd0;
                        if (minutes == 6'd59) begin
                            minutes <= 6'd0;
                            hours <= (hours == 5'd23) ? 5'd0 : hours + 1; 
                        end 
                        else 
                            minutes <= minutes + 1;
                    end 
                    else begin
                        seconds <= seconds + 1;
                    end

                    // LED0 blinking: Toggle a 1-bit counter for 50% duty (period = 2s)
                    time_led_counter <= ~time_led_counter;
                    LED0 <= (time_led_counter == 1'b0) ? 1'b1 : 1'b0;
                    // LED1 remains constant high in Time state
                    LED1 <= 1'b1;
                    // Buzzer remains off in Time state
                    Buzzer <= 1'b0;
                    
                    // Next-state decision
                    if (S1)
                        state <= Set_time;
                    else if (S2)
                        state <= Set_alarm;
                    else if ((minutes == alarm_minutes) && (hours == alarm_hours) && S5_edge)
                        state <= Alarm;
                    else
                        state <= Time;
                end

                Set_time: begin
                    // LED and buzzer outputs in Set_time state
                    LED0   <= 1'b0;
                    LED1   <= 1'b1;
                    Buzzer <= 1'b0;
                    
                    // Adjust the current time registers based on inputs
                    if (S3 && S4) begin
                        minutes <= (minutes == 6'd59) ? 6'd0 : minutes + 1;
                        hours <= (hours == 5'd23) ?  5'd0 : hours + 1; 
                    end 
                    else if (S3 && !S4) 
                        minutes <= (minutes == 6'd59) ? 6'd0 : minutes + 1;
                    else if (!S3 && S4) 
                        hours <= (hours == 5'd23) ?  5'd0 : hours + 1; 
                    
                    // Remain in Set_time while S1 is asserted; otherwise, return to Time state
                    if (!S1)
                        state <= Time;
                    else
                        state <= Set_time;
                end

                Set_alarm: begin
                    // LED and buzzer outputs in Set_alarm state
                    LED0   <= 1'b1;
                    LED1   <= 1'b1;
                    Buzzer <= 1'b0;
                    
                    // Adjust the alarm registers based on inputs
                    if (S3 && S4) begin
                        alarm_minutes <= (alarm_minutes == 6'd59) ? 6'd0 : alarm_minutes + 1;
                        alarm_hours   <= (alarm_hours == 5'd23) ? 5'd0: alarm_hours + 1;
                    end 
                    else if (S3 && !S4) 
                        alarm_minutes <= (alarm_minutes == 6'd59) ? 6'd0 : alarm_minutes + 1;
                    else if (!S3 && S4) 
                        alarm_hours   <= (alarm_hours == 5'd23) ? 5'd0: alarm_hours + 1;
                    
                    // Remain in Set_alarm while S2 is asserted; otherwise, return to Time state
                    if (!S2)
                        state <= Time;
                    else
                        state <= Set_alarm;
                end

                Alarm: begin
                    // In Alarm state, update a mod4 counter for LED0 blinking (75% duty cycle)
                    alarm_led_counter <= alarm_led_counter + 1;  // 0,1,2,3 then wraps around
                    LED0 <= (alarm_led_counter < 2'd3) ? 1'b1 : 1'b0;
                    // LED1 remains constant high
                    LED1 <= 1'b1;

                    // Buzzer blinking: if not muted (S7 low), use a mod2 counter for 50% duty cycle
                    if (!S7) begin
                        alarm_buzzer_counter <= ~alarm_buzzer_counter;
                        Buzzer <= (alarm_buzzer_counter == 1'b0) ? 1'b1 : 1'b0;
                    end else begin
                        Buzzer <= 1'b0;
                    end

                    // Remain in Alarm until PB1 is pressed to stop the alarm
                    if (PB1)
                        state <= Time;
                    else
                        state <= Alarm;
                end

                default: state <= Time;
            endcase
        end
    end

endmodule
