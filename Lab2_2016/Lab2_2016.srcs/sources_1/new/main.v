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
    output reg [15:0] LED,
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

    reg reset = 0;
    reg [16:0] output_value = 0;
    reg [16:0] input_value = 0;
    reg [19:0] refresh_counter = 0;
    wire [1:0] activating_counter;
                   //  count   0  ->  1  ->  2  ->  3
                   // annode LED1   LED2   LED3   LED4
    //Array of 5 buttons
    // U D L R C
    wire btn [0:4] = {btnU, btnD, btnL, btnR, btnC};
    //Array of 5 pressed variables
    //Array of 5 buttons
    // U D L R C
    //Array of 5 pressed variables
    reg [19:0] pressed [4:0];
    
    //debounce 5000 cycles => 1/20000 second
    parameter DEBOUNCE = 5000;
    
    //refresh_counter & set reset parameter
    always @(posedge CLK100MHZ)
    begin
        if(btn[4] && !pressed[4])begin
            pressed[4] <= refresh_counter;
            reset <= 1;
        end
//        else if(btn[4] && (refresh_counter - pressed[4] >= DEBOUNCE))begin
        else if(!btn[4] && (refresh_counter - pressed[4] >= DEBOUNCE))begin
            pressed[4] <= 0;
            reset <= 0;
        end
        refresh_counter <= refresh_counter + 1;
    end //refresh_counter
    assign activating_counter = refresh_counter[19:18];
    
    
    //Set new value from switches
//    generate
//    genvar counter;
//        for(counter = 0; counter <= 4'b1111; counter = counter + 1) begin : counter_outer
//            assign input_value[counter] = sw[counter];
//        end
//    endgenerate

    //set input value from switches
    reg [5:0] j = 0;
    always @(posedge CLK100MHZ)
    begin
        for(j=0; j <= 4'b1111; j = j + 1)begin
            input_value[j] <= sw[j];
            LED[j] <= sw[j];
        end
    end //set input value from switches
    
    
    //Check Buttons
    reg [4:0] i = 0;
    always @(posedge CLK100MHZ)
    begin
        for(i=0; i <= 2'b11; i = i + 1)
        begin
            if(reset)
                output_value <= 0;
            //TODO fix U back to i
            if(btn[i] && !pressed[i])begin
//                for(j=0; j <= 4'b1111; j = j + 1)
//                    input_value[j] <= sw[j];
                output_value <= math_funct(i,output_value,input_value);
                pressed[i] <= refresh_counter;
                end
            else if(!btn[i] && (pressed[i] - refresh_counter >= DEBOUNCE))begin
                pressed[i] <= 0;
            end
        end
    end //check buttons
    
    //Display current values to output
    always @(*)
    begin
        an = anodeActivate(activating_counter);
        seg = segSplitDec(output_value, activating_counter);
    end
    
endmodule //main
