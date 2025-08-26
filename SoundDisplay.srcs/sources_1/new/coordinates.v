`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2021 00:47:06
// Design Name: 
// Module Name: coordinates
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


module coordinates(
input [12:0] pixel_index,
    output [7:0] row,
    output [7:0] column
);
    assign row = pixel_index / 96;
    assign column = pixel_index % 96;
endmodule
