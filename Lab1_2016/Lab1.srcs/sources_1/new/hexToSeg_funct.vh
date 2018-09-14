`ifndef HEXTOSEG_HEADER
`define HEXTOSEG_HEADER

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2018 01:41:49 PM
// Design Name: 
// Module Name: hexToSeg_funct
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

function [7:0] hexToSeg(
    input [3:0] hex
    );
    begin
    case(hex)
        4'hA: hexToSeg = 7'b0100000;
        4'hB: hexToSeg = 7'b0000011;
        4'hC: hexToSeg = 7'b1000110;
        4'hD: hexToSeg = 7'b0100001;
        4'hE: hexToSeg = 7'b0000110;
        4'hF: hexToSeg = 7'b0001110;
        4'h0: hexToSeg = 7'b1000000;
        4'h1: hexToSeg = 7'b1111001;
        4'h2: hexToSeg = 7'b0100100;
        4'h3: hexToSeg = 7'b0110000;
        4'h4: hexToSeg = 7'b0011001;
        4'h5: hexToSeg = 7'b0010010;
        4'h6: hexToSeg = 7'b0000010;
        4'h7: hexToSeg = 7'b1111000;
        4'h8: hexToSeg = 7'b0000000;
        4'h9: hexToSeg = 7'b0011000;
        default: hexToSeg = 7'b1000000;
    endcase
    end
endfunction //hexToSeg

function [3:0] anodeActivate(
    input [1:0] activating_counter
    );
    begin
    case(activating_counter)
        2'b00: anodeActivate = 4'b0111;
        2'b01: anodeActivate = 4'b1011;
        2'b10: anodeActivate = 4'b1101;
        2'b11: anodeActivate = 4'b1110;
        default: anodeActivate = 4'b1011;
    endcase
    end
endfunction //anodeActivate

function [7:0] segSplitHex(
    input [15:0] outputValue,
    input [1:0] activating_counter
    );
    begin
    case(activating_counter)
        2'b00: segSplitHex = hexToSeg(outputValue[15:12]);
        2'b01: segSplitHex = hexToSeg(outputValue[11:8]);
        2'b10: segSplitHex = hexToSeg(outputValue[7:4]);
        2'b11: segSplitHex = hexToSeg(outputValue[3:0]);
        default: segSplitHex = hexToSeg(4'hA);
    endcase
    end
endfunction //segSplitHex

function [7:0] segSplitDec(
    input [13:0] outputValue,
    input [1:0] activating_counter
    );
    begin
//    if(outputValue>9999)
//        outputValue=0;
    case(activating_counter)
        2'b00: segSplitDec = hexToSeg(outputValue/1000);
        2'b01: segSplitDec = hexToSeg((outputValue % 1000)/100);
        2'b10: segSplitDec = hexToSeg(((outputValue % 1000) % 100)/10);
        2'b11: segSplitDec = hexToSeg((((outputValue % 1000) % 100)% 10));
        default: segSplitDec = hexToSeg(4'hF);
    endcase
    end
endfunction //segSplitDec

`endif
