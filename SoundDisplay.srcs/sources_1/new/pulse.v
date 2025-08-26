`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2021 16:02:22
// Design Name: 
// Module Name: pulse
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


module pulse(
    input CLOCK,
    input in,
    output out
);
    wire out1;
    flip_flop a(CLOCK,in,out1);
    wire out2;
    flip_flop b(CLOCK,out1,out2);
    assign out = out1&(~out2);

endmodule

module flip_flop(
    input CLOCK,
    input P,
    output reg Q = 0
    );
    
    always @(posedge CLOCK)
    begin
        Q = P;
    end
endmodule