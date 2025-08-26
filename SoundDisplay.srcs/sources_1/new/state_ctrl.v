`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2021 19:11:21
// Design Name: 
// Module Name: state_ctrl
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


module state_ctrl(
    input reset,
    input clk,
    input [2:0] menu_state,
    input lv_0_over,
    input lv_1_over,
    input lv_2_over,
    //input lv_3_over,
    output reg [2:0] state = 0 
    );
    
    reg [1:0] prev_option = 0;
    always @(posedge clk)
    begin
        if(reset)
           state = 0;
        else
        begin
            if(menu_state != 0)
               state = menu_state;
            if(lv_0_over)
               state = 3; 
            if(lv_1_over)
               state = 4; 
            if(lv_2_over)
               state = 5; 
//            if(lv_3_over)
//               state = 0;
        end
    end
    
    
endmodule
