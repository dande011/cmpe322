`ifndef MATH_HEADER
`define MATH_HEADER


// 0    1         2    3
// Add, Subtract, And, Xor
function [16:0] math_funct(
    input [1:0] function_number,
    input [16:0] current_val,
    input [16:0] new_val
    );
<<<<<<< HEAD
<<<<<<< HEAD
//    math_funct = current_val + new_val;
=======
>>>>>>> parent of b5b4bc7... Heading to meeting
    case(function_number)
        2'b00: math_funct = current_val + new_val;
        2'b01: math_funct = current_val - new_val;
        2'b10: math_funct = current_val & new_val;
        2'b11: math_funct = current_val ^ new_val;
<<<<<<< HEAD
=======
    math_funct = current_val + new_val;
//    case(function_number)
//        2'b00: math_funct = current_val + new_val;
//        2'b01: math_funct = current_val - new_val;
//        2'b10: math_funct = current_val & new_val;
//        2'b11: math_funct = current_val ^ new_val;
>>>>>>> parent of f9219ee... Vivado forgot there was a top module
//    endcase   
=======
    endcase   
>>>>>>> parent of b5b4bc7... Heading to meeting
endfunction //math_funct


`endif
