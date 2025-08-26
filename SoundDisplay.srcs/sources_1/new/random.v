`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2021 10:36:12
// Design Name: 
// Module Name: random
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


module random(
    input clk,
    input seed,
    output val
    );
    
    reg [15:0] shift_reg;
    wire feedback;
    
    assign feedback = shift_reg[3]^shift_reg[0]^shift_reg[7]^shift_reg[11];
    assign val = feedback;
    
    initial
        shift_reg = (!seed) ? 15'd343 : seed;
       
    always @(posedge clk)
    begin
        shift_reg = {feedback,shift_reg[14:1]};
    end
    
    
endmodule
