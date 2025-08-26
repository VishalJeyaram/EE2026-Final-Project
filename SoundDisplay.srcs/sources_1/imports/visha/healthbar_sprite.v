module healthbar_rom
	(
		input [1:0] row,
		input [-1:0] col,
		output reg [15:0] color_data
	);

	always @*
	case ({row, col})
		2'b000: color_data = 16'b1110100011100100;
		2'b001: color_data = 16'b1110100011100100;

		2'b010: color_data = 16'b1110100011100100;
		2'b011: color_data = 16'b1110100011100100;

		2'b100: color_data = 16'b1110100011100100;
		2'b101: color_data = 16'b1110100011100100;

		2'b110: color_data = 16'b1110100011100100;
		2'b111: color_data = 16'b1110100011100100;

		2'b1000: color_data = 16'b1110100011100100;
		2'b1001: color_data = 16'b1110100011100100;

		default: color_data = 16'b0000000000000000;
	endcase
endmodule