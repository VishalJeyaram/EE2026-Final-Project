module Oled_vol (
    input clk,
    input [2:0] state,
    input [7:0] row,
    input [7:0] column,
    output reg [15:0] pixel_data = 0,
    input btnL,
    input btnR,
    input thicken,
    input color_swap,
    input hide_border,
    input hide_volume,
    input [5:0] vol
);
    wire [1:0] thicc;
    reg [6:0] col_start = 45;
    
    wire left;
    wire right;
    pulse left_sig(.CLOCK(clk), .in(btnL), .out(left));
    pulse right_sig(.CLOCK(clk), .in(btnR), .out(right));

    wire [7:0] height; 
    assign height = 64 * vol / 16;
    //assign led = col_start;
    
    always @(posedge clk)
    begin
        if(state == 1)
        begin
            col_start = (right) ? 
                        (col_start != 90 - thicc) ? (col_start+7'b1) : col_start : 
                        (left) ? 
                        (col_start != thicc) ? (col_start-7'b1) : col_start :
                        col_start;
        end
    end
    
    assign thicc = (thicken) ? 3 : 1;
    
    always @(posedge clk)
    begin
        if(row < thicc | column < thicc | row > 63-thicc | column > 95-thicc)
            pixel_data = (hide_border) ? 16'h0000 : ((color_swap) ? 16'hFFFF : 16'hFFFF); //border
            
        else if(!hide_volume & column < (col_start + 6) & column > col_start & row > 64 - height) //column
        begin    
            if(row < 21 & row%4 != 0)
                pixel_data = (color_swap) ? 16'h00FF : 16'hF800; //Red
            else if(row < 42 & row%4 != 0)
                pixel_data = (color_swap) ? 16'h0FF0 : 16'hFFE0; //Yellow
            else if(row < 63 & row%4 != 0)
                pixel_data = (color_swap) ? 16'hFF00 : 16'h07E0; //Green
        end
        
        else
            pixel_data = (color_swap) ? 16'h0000 : 16'h0000;
    end
endmodule