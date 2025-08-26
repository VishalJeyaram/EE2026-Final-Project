`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2021 14:31:28
// Design Name: 
// Module Name: timers
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


module timers(
    input CLOCK,
    output reg out = 0,
    input [31:0] check
    );
    
    reg [31:0] count = 0;
 
    always @(posedge CLOCK)
    begin
        count <= (count == check) ? 0 : count + 1;
        out <= (count == 0) ? ~out : out;
    end
    
endmodule
