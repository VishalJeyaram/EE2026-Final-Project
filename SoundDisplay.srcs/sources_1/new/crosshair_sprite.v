`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2021 06:25:54
// Design Name: 
// Module Name: crosshair_sprite
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


module crosshair_rom
	(
		input [3:0] row,
		input [3:0] col,
		output reg [15:0] color_data
	);

	always @*
	case ({row, col})
		8'h60: color_data = 16'hFFFF;
		8'h61: color_data = 16'hFFFF;
		8'h62: color_data = 16'hFFFF;
		8'h63: color_data = 16'hFFFF;
		8'h64: color_data = 16'hFFFF;
		8'h65: color_data = 16'hFFFF;
        8'h66: color_data = 16'hFFFF;
        8'h67: color_data = 16'hFFFF;
        8'h68: color_data = 16'hFFFF;
        8'h69: color_data = 16'hFFFF;
        8'h6A: color_data = 16'hFFFF;
        8'h6B: color_data = 16'hFFFF;
        8'h6C: color_data = 16'hFFFF;
        8'h6D: color_data = 16'hFFFF;
        8'h6E: color_data = 16'hFFFF;
        
        8'h70: color_data = 16'hFFFF;
        8'h71: color_data = 16'hFFFF;
        8'h72: color_data = 16'hFFFF;
        8'h73: color_data = 16'hFFFF;
        8'h74: color_data = 16'hFFFF;
        8'h75: color_data = 16'hFFFF;
        8'h76: color_data = 16'hFFFF;
        8'h77: color_data = 16'hFFFF;
        8'h78: color_data = 16'hFFFF;
        8'h79: color_data = 16'hFFFF;
        8'h7A: color_data = 16'hFFFF;
        8'h7B: color_data = 16'hFFFF;
        8'h7C: color_data = 16'hFFFF;
        8'h7D: color_data = 16'hFFFF;
        8'h7E: color_data = 16'hFFFF;
        
        8'h80: color_data = 16'hFFFF;
        8'h81: color_data = 16'hFFFF;
        8'h82: color_data = 16'hFFFF;
        8'h83: color_data = 16'hFFFF;
        8'h84: color_data = 16'hFFFF;
        8'h85: color_data = 16'hFFFF;
        8'h86: color_data = 16'hFFFF;
        8'h87: color_data = 16'hFFFF;
        8'h88: color_data = 16'hFFFF;
        8'h89: color_data = 16'hFFFF;
        8'h8A: color_data = 16'hFFFF;
        8'h8B: color_data = 16'hFFFF;
        8'h8C: color_data = 16'hFFFF;
        8'h8D: color_data = 16'hFFFF;
        8'h8E: color_data = 16'hFFFF;
        
        8'h06: color_data = 16'hFFFF;
        8'h16: color_data = 16'hFFFF;
        8'h26: color_data = 16'hFFFF;
        8'h36: color_data = 16'hFFFF;
        8'h46: color_data = 16'hFFFF;
        8'h56: color_data = 16'hFFFF;
        8'h96: color_data = 16'hFFFF;
        8'hA6: color_data = 16'hFFFF;
        8'hB6: color_data = 16'hFFFF;
        8'hC6: color_data = 16'hFFFF;
        8'hD6: color_data = 16'hFFFF;
        8'hE6: color_data = 16'hFFFF;
        
        8'h07: color_data = 16'hFFFF;
        8'h17: color_data = 16'hFFFF;
        8'h27: color_data = 16'hFFFF;
        8'h37: color_data = 16'hFFFF;
        8'h47: color_data = 16'hFFFF;
        8'h57: color_data = 16'hFFFF;
        8'h97: color_data = 16'hFFFF;
        8'hA7: color_data = 16'hFFFF;
        8'hB7: color_data = 16'hFFFF;
        8'hC7: color_data = 16'hFFFF;
        8'hD7: color_data = 16'hFFFF;
        8'hE7: color_data = 16'hFFFF;
        
        8'h08: color_data = 16'hFFFF;
        8'h18: color_data = 16'hFFFF;
        8'h28: color_data = 16'hFFFF;
        8'h38: color_data = 16'hFFFF;
        8'h48: color_data = 16'hFFFF;
        8'h58: color_data = 16'hFFFF;
        8'h98: color_data = 16'hFFFF;
        8'hA8: color_data = 16'hFFFF;
        8'hB8: color_data = 16'hFFFF;
        8'hC8: color_data = 16'hFFFF;
        8'hD8: color_data = 16'hFFFF;
        8'hE8: color_data = 16'hFFFF;

		default: color_data = 16'b0000000000000000;
	endcase
endmodule