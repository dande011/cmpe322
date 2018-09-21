`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2018 09:19:52 AM
// Design Name: 
// Module Name: main
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


module main(
    output reg [6:0] seg,
//    output dp,
    output reg [3:0] an,
    input btnU,
    input btnD,
    input btnL,
    input btnR,
    input btnC,
    input [15:0] sw,
    input CLK100MHZ
    );
    `include "hexToSeg_funct.vh"
    `include "math_funct.vh"
    
    reg [16:0] output_value = 0;
    reg [16:0] input_value = 0;
    reg [19:0] refresh_counter = 0;
    wire [1:0] activating_counter;
                   //  count   0  ->  1  ->  2  ->  3
                   // annode LED1   LED2   LED3   LED4
    //Array of 5 pressed variables
    // U D L R C
    reg [19:0] pressed [4:0];
    
    //debounce 5000 cycles => 1/20000 second
    parameter DEBOUNCE = 5000;
    
    //refresh_counter
    always @(posedge CLK100MHZ)
    begin
        if(btnC && !pressed[4])begin
            refresh_counter <= 0;
            pressed[4] <= refresh_counter;
        end
        else if(btnC && (refresh_counter - pressed[4] >= DEBOUNCE))begin
            pressed[4] <= 0;
        end
        refresh_counter <= refresh_counter + 1;
    end //refresh_counter
    assign activating_counter = refresh_counter[19:18];
    
    
    reg [3:0] counter = 0;
    //Set new value from switches
    always @(posedge CLK100MHZ)
    begin
        for(counter = 0; counter <= 4'b111; counter = counter + 1)
            input_value[counter] = sw[counter];
    end //Set from switches
//    generate
//    genvar counter;
//        for(counter = 0; counter <= 4'b1111; counter = counter + 1) begin : counter_outer
//            assign input_value[counter] = sw[counter];
//        end
//    endgenerate
    
    reg [1:0] i;
    //Check Buttons
    always @(posedge CLK100MHZ)
    begin
        for(i=0; i < 2'b11; i = i + 1)
        begin
            if(btnC)
                output_value <= 0;
            if(btnU && !pressed[i])
                begin
                    pressed[i] <= refresh_counter;
                    output_value <= math_funct(i,output_value,input_value);
                end
            else if(!btnU && (refresh_counter - pressed[i] >= DEBOUNCE))
                pressed[i] <= 0;
        end
    end //check buttons
//    generate
//        genvar i;
//        for(i = 0; i <= 3; i = i + 1) begin : btn_outer
//            always @(posedge CLK100MHZ) begin
//            if(btn[i] == 1 && pressed[i] == 0)
//                pressed[i] <= refresh_counter;
//            else if(btn[i] == 0 && (refresh_counter - pressed[i] >= DEBOUNCE))
//                begin
//                    pressed[i] <= 0;
//                    output_value <= math_funct(i,output_value,sw);
//                end
//            end
//        end //btn_outer
//    endgenerate //Check Buttons
    
    
    //Display current values to output
    always @(*)
    begin
        an = anodeActivate(activating_counter);
        seg = segSplitDec(output_value, activating_counter);
    end
    
endmodule //main
