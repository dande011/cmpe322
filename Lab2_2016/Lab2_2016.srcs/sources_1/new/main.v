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
    output dp,
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
    
<<<<<<< HEAD
<<<<<<< HEAD
=======
    
    reg [1:0] test = 0;
    
    
>>>>>>> parent of b5b4bc7... Heading to meeting
=======
    reg reset = 0;
>>>>>>> parent of f9219ee... Vivado forgot there was a top module
    reg [16:0] output_value = 0;
    wire [16:0] input_value = 0;
    reg [19:0] refresh_counter = 0;
    wire [1:0] activating_counter;
                   //  count   0  ->  1  ->  2  ->  3
                   // annode LED1   LED2   LED3   LED4
<<<<<<< HEAD
<<<<<<< HEAD
=======
    //Array of 5 buttons
    // U D L R C
    wire btn [4:0] = {btnU, btnD, btnL, btnR, btnC};
>>>>>>> parent of b5b4bc7... Heading to meeting
    //Array of 5 pressed variables
=======
    //Array of 5 buttons
>>>>>>> parent of f9219ee... Vivado forgot there was a top module
    // U D L R C
    wire btn [4:0] = {btnC, btnR, btnL, btnD, btnU};
    //Array of 5 pressed variables
    reg [19:0] pressed [4:0];
    
    //debounce 5000 cycles => 1/20000 second
    parameter DEBOUNCE = 5000;
    
    //refresh_counter
    always @(posedge CLK100MHZ)
    begin
<<<<<<< HEAD
<<<<<<< HEAD
        if(btnC && !pressed[4])begin
=======
        if(!btn[4] && !pressed[4])begin
>>>>>>> parent of f9219ee... Vivado forgot there was a top module
            refresh_counter <= 0;
            pressed[4] <= refresh_counter;
            reset <= 1;
        end
<<<<<<< HEAD
        else if(btnC && (refresh_counter - pressed[4] >= DEBOUNCE))begin
=======
        if(btn[4] == 1 && pressed[4] == 0)begin
            refresh_counter <= 0;
            pressed[4] <= refresh_counter;
=======
        else if(btn[4] && (refresh_counter - pressed[4] >= DEBOUNCE))begin
            pressed[4] <= 0;
>>>>>>> parent of f9219ee... Vivado forgot there was a top module
        end
        else if(btn[4] == 0 && (refresh_counter - pressed[4] >= DEBOUNCE))
>>>>>>> parent of b5b4bc7... Heading to meeting
            pressed[4] <= 0;
        else
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
    
    
    //Check Buttons
<<<<<<< HEAD
    always @(posedge CLK100MHZ)
    begin
        for(i=0; i < 2'b11; i = i + 1)
        begin
            if(reset)
                output_value <= 0;
<<<<<<< HEAD
            if(btnU && !pressed[i])
=======
    generate
        genvar i;
        for(i = 0; i <= 3; i = i + 1) begin : btn_outer
            always @(posedge CLK100MHZ) begin
            if(btn[i] == 1 && pressed[i] == 0)
                pressed[i] <= refresh_counter;
            else if(btn[i] == 0 && (refresh_counter - pressed[i] >= DEBOUNCE))
>>>>>>> parent of b5b4bc7... Heading to meeting
=======
            if(btn[i] && !pressed[i])
>>>>>>> parent of f9219ee... Vivado forgot there was a top module
                begin
                    pressed[i] <= 0;
                    output_value <= math_funct(i,output_value,sw);
                end
<<<<<<< HEAD
<<<<<<< HEAD
            else if(!btnU && (refresh_counter - pressed[i] >= DEBOUNCE))
=======
            else if(!btn[i] && (refresh_counter - pressed[i] >= DEBOUNCE))
>>>>>>> parent of f9219ee... Vivado forgot there was a top module
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
=======
            end
        end //btn_outer
    endgenerate //Check Buttons
>>>>>>> parent of b5b4bc7... Heading to meeting
    
    
    //Display current values to output
    always @(*)
    begin
        an = anodeActivate(activating_counter);
        seg = segSplitDec(output_value, activating_counter);
    end
    
endmodule //main
