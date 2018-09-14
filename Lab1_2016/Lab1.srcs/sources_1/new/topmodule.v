`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2018 09:54:34 AM
// Design Name: 
// Module Name: topmodule
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

//        seg = 7'b0011001; // 4

module topmodule(
    output reg [6:0] seg,
    output dp,
    output reg [3:0] an,
    input btnC,
    input btnU,
    input btnL,
    input btnR,
    input btnD,
    input [14:0] sw,
    input CLK100MHZ,
    input reset
    );
    `include "hexToSeg_funct.vh"
    reg [13:0] output_value = 0;
//    reg [15:0] output_value = 0; // 16'hFFFF
    reg [19:0] refresh_counter = 0; //380Hz refresh rate
    wire [1:0] activating_counter;
               //  count   0  ->  1  ->  2  ->  3
               // annode LED1   LED2   LED3   LED4
    reg [19:0] pressedU = 0;
    reg [19:0] pressed1 = 0;
    
//    always @(posedge sw[14])
//    begin
//        output_value = 10;
//    end
    
    // Iterate refresh_counter
    always @(posedge CLK100MHZ or posedge reset)
    begin
        if(reset==1)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end
    assign activating_counter = refresh_counter[19:18];
    
    //btnU&sw1
    always @(posedge CLK100MHZ or posedge reset)
    begin
        if(reset==1)
            output_value <= 10;
        else begin
            //check for button up
            if(btnU == 1 && pressedU==0)begin
                output_value <= output_value + 1;
                if(output_value>9999)
                    output_value <= 0;
                pressedU = refresh_counter;
            end
    //        else if(btnU == 0 && (refresh_counter-pressedU >= 5000))
            else if(btnU == 0)
                pressedU = 0;
                
            //check for sw[1]
            if(sw[0] == 1 && pressed1==0)begin
                if(output_value!=0)
                    output_value <= output_value - 1;
                pressed1 = refresh_counter;
            end
            else if (sw[0] == 0 && (refresh_counter - pressed1 >= 50000))
                pressed1 = 0;
        end
    end // btnU&sw1


    always @(*)
    begin
        an = anodeActivate(activating_counter);
        seg = segSplitDec(output_value, activating_counter);
    end
    
endmodule //topmodule
