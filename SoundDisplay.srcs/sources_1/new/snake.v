`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2021 23:09:19
// Design Name: 
// Module Name: snake
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


//module snake(
//    input clk,
//    input btnU,
//    input btnL,
//    input btnR,
//    input btnD,
//    input [12:0] pixel_index,
//    output [15:0] pixel_data
//    );

//    reg [12:0] snake [3:0]; //List of positions of snake
//    reg [3:0] len = 1;
    
//    initial
//    begin
//        snake[0] = 12'h0f0;
//        snake[1] = 0;
//        snake[2] = 0;
//        snake[3] = 0;
//    end
    
//    reg [1:0] direction = 0; //Direction the snake currently going at
//    reg [1:0] prev_dir = 0;
//    //0 =f, 1=l, 2=r, 3=d
    
//    reg collision = 0;
    
//    wire up;
//    wire down;
//    wire left;
//    wire right;
    
//    pulse move_up(clk, btnU, up);
//    pulse move_down(clk, btnD, down);
//    pulse move_left(clk, btnL, left);
//    pulse move_right(clk, btnR, right);
    
//    //direction ctrl
//    always @(posedge clk)
//    begin
//        if(up && prev_dir!=0)
//        begin
//            prev_dir = direction;
//            direction = 0;
//        end
        
//        if(left && prev_dir!=1)
//        begin
//            prev_dir = direction;
//            direction = 1;
//        end
        
//        if(right && prev_dir!=2)
//        begin
//            prev_dir = direction;
//            direction = 2;
//        end
        
//        if(down && prev_dir!=3)
//        begin
//            prev_dir = direction;
//            direction = 3;
//        end
//    end
    
//    always @(posedge clk)
//    begin
//        if(~collision)
//        begin
//            case(direction)
//                0:
//                begin
//                    snake[3] = snake[2]; 
//                    snake[2] = snake[1]; 
//                    snake[1] = snake[0];
////                    if(snake[0] == snake[2] | snake[0] == snake[3])
////                        collision = 1;
//                    snake[0] = snake[0] - 96; 
//                end
//                1:
//                begin
//                    snake[3] = snake[2]; 
//                    snake[2] = snake[1]; 
//                    snake[1] = snake[0];
////                    if(snake[0] == snake[2] | snake[0] == snake[3])
////                        collision = 1;
//                    snake[0] = snake[0] - 1; 
//                end
//                2:
//                begin
//                    snake[3] = snake[2]; 
//                    snake[2] = snake[1]; 
//                    snake[1] = snake[0];
////                    if(snake[0] == snake[2] | snake[0] == snake[3])
////                        collision = 1;
//                    snake[0] = snake[0] + 1; 
//                end
//                3:
//                begin
//                    snake[3] = snake[2]; 
//                    snake[2] = snake[1]; 
//                    snake[1] = snake[0];
////                    if(snake[0] == snake[2] | snake[0] == snake[3])
////                        collision = 1;
//                    snake[0] = snake[0] + 96; 
//                end
//            endcase
//        end
//    end
    
//    assign pixel_data = (pixel_index == snake[0] | 
//                         pixel_index == snake[1] | 
//                         pixel_index == snake[2] | 
//                         pixel_index == snake[3] ) ? 16'hFFFF : 0;
//endmodule

module draw(
            input [2:0] state, 
            input reset_ext,
            input clk,
            input [7:0] row,
            input [7:0] column,
            input btnC,
            input btnR,
            input btnU,
            input btnD,
            input btnL,
            output reg [15:0] pixel_data = 0
            );

    reg pen_down = 0;
    reg [6143:0] bitmap = 0; // 1 if colored, zero if background
    reg [7:0] crosshair_wid = 15;
    reg [7:0] crosshair_height = 15;
    reg [7:0] crosshair_row = 27;
    reg [7:0] crosshair_col = 17;
    wire [7:0] row_cross;
    wire [7:0] col_cross;
    
        
    assign row_cross = ((row>crosshair_row) && (row < (crosshair_row+crosshair_height)) ) ? row-crosshair_row : 0 ;    
    assign col_cross = ((column>crosshair_col) && (column <crosshair_col + crosshair_wid)) ? column-crosshair_col : 0 ;
     
    wire [15:0] crosshair_data; 
    crosshair_rom pointer(crosshair_row, crosshair_col,crosshair_data);
    always @(posedge clk)
    begin
        if(reset_ext)
            bitmap = 0;
        if(state == 5)
        begin
            if(btnC)
                pen_down = ~pen_down;
            else if(btnL)
                crosshair_col = crosshair_col - 1;
            else if(btnR)
                crosshair_col = crosshair_col + 1;
            else if(btnD)
                crosshair_row = crosshair_row + 1;
            else if(btnU)
                crosshair_row = crosshair_row - 1;
            if(pen_down && (row_cross > 2 && row_cross <13) && (col_cross > 2 && col_cross <13))
                bitmap[row_cross*96 + col_cross] = 1;
        end
    end
    
    always @(posedge clk)
        pixel_data = crosshair_data; //+ bitmap[row*96 +column] * 16'hFFFF;
        
endmodule