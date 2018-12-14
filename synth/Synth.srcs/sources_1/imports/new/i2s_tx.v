/*
 * Redistribution and use in source and non-source forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in non-source form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 * THIS WORK IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * WORK, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Modified by JUIXXXE Sept. 2015
 * Modified by JUIXXXE Jan. 2016
 * Modified by D.Anderson Nov. 2018
 */
 `timescale 1ns / 1ps
`define CHANNELDEPTH 16
`define logCHANNELDEPTH 4
module i2s_tx(
    input            mclk,
    output reg        sdata = 1'b0,
    input signed [`CHANNELDEPTH-1:0]    left_chan, 
    input signed [`CHANNELDEPTH-1:0]    right_chan
);
reg lrclk_delayed = 1'b1;
reg [`logCHANNELDEPTH-1:0] bit_cnt = `logCHANNELDEPTH'b0;
reg signed [`CHANNELDEPTH-1:0]        left;
reg signed [`CHANNELDEPTH-1:0]        right;
reg [4:0] mclk_count = 4'b0;
    
always @(posedge mclk) begin
    //i2s requires the signal be delayed by one bclk cycle from the lr switch
    if(mclk_count == 8) begin
        mclk_count = 0;
        if (bit_cnt == `logCHANNELDEPTH'b0) begin
            lrclk_delayed = ~lrclk_delayed;
            //read in channels at beginning of lr cycle
            if(lrclk_delayed) begin
                left = left_chan;
                right = right_chan;
            end
        end
   
       //assign proper chanel to sdata
        sdata = lrclk_delayed ? right[`CHANNELDEPTH-1 - bit_cnt] : left[`CHANNELDEPTH-1 - bit_cnt];
        //increment bit count
        if(bit_cnt == `logCHANNELDEPTH'b1111)
            bit_cnt = `logCHANNELDEPTH'b0;
        else
            bit_cnt = bit_cnt + 1;
    end
    mclk_count = mclk_count + 1;
end
endmodule