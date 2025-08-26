`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2021 14:37:28
// Design Name: 
// Module Name: sim_timers
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


module sim_timers();
    
    reg clk = 0;
    wire out;
    timers a(clk,out,2499);
    
    always
    begin
    #5 clk = ~clk;
    end

endmodule
