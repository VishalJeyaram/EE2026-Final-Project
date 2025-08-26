`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2021 00:45:29
// Design Name: 
// Module Name: corridor
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


module corridor (
    input [1:0] state,
    input reset_ext,
    input [4:0] volume,
    input [6:0] pass1,
    input [6:0] pass2,
    input [6:0] pass3,
    input [6:0] pass4,
    input clk,
    input btnR,
    input btnL,
    input btnC,
    input [7:0] row,
    input [7:0] column,
    output reg [6:0] seg_data = 7'b1111111,
    output reg [3:0] an_data = 4'b1111,
    output reg lv_up = 0,
    output reg [15:0] oled_data_corridor = 0
);
    
    reg [3:0] password = 0; 
    wire reset;
    wire left,right;
    pulse left_sig(.CLOCK(clk), .in(btnL), .out(left));
    pulse right_sig(.CLOCK(clk), .in(btnR), .out(right));
    
    assign reset = reset_ext | btnC;
   
    wire [15:0] color_data_bg;
    wire [15:0] color_data_fall;
    wire [15:0] color_data_dead;
    wire [15:0] color_guard;
    wire [15:0] color_mc;
    
    //Sprite coords
    reg [7:0] guard_wid = 8;
    reg [7:0] guard_height = 15;
    reg [7:0] mc_wid = 6;
    reg [7:0] mc_height = 13;
    reg [7:0] sprite1_row = 27;
    reg [7:0] sprite1_col = 17;
    reg [7:0] sprite2_row = 24;
    reg [7:0] sprite2_col = 73; // 28-41 for trap door pixel column index
    wire [7:0] row_mc;
    wire [7:0] col_mc;
    wire [7:0] row_guard;
    wire [7:0] col_guard;
    
    //map (0,0) of sprite (row_start,col_start) to (0,0) of input to module
    assign row_mc = ((row>sprite1_row) && (row< (sprite1_row+mc_height)) ) ? row-sprite1_row : 0 ; 
    //same for col
    assign col_mc = ((column>sprite1_col) && (column <sprite1_col + mc_wid)) ? column-sprite1_col : 0 ; 
    assign row_guard = ((row>sprite2_row) && (row<sprite2_row+ guard_height)) ? row-sprite2_row : 0 ; 
    assign col_guard = ((column>sprite2_col) && (column < (sprite2_col + guard_wid)) ) ? column-sprite2_col : 0 ; 
    
    Background_corridor_rom background(clk, row, column, color_data_bg);
    maincharacter_rom testing(row_mc, col_mc, color_mc);
    Imagewithstuff_rom guard_corridor(row_guard, col_guard, color_guard);
    Background_corridor_trapdooropen_rom fall(clk,row, column, color_data_fall);
    Guardkills_hero21_rom death(clk,row,column,color_data_dead);
    
    //guard movement
    wire twohz_clock;
    wire sixhz_clock;
    timers travelontrapdoor(clk, twohz_clock ,32'd24999999);
    timers traveltotrapdoor(clk, sixhz_clock ,32'd8333332);
    
    wire open_trapdoor;
    wire dead;
    wire moveable;
    reg password_entered = 0;
    
    wire clocktouse;
    assign clocktouse = (sprite2_col <= 41 && ~password_entered) ? twohz_clock : sixhz_clock; 
    
    always @ ( posedge clocktouse ) 
    begin 
        if(reset)
        begin
            sprite2_row = 24;
            sprite2_col = 73;
            password_entered = 0; 
            sprite1_col = 17;
            lv_up = 0;
            password = 0;
        end
        else if(state == 3)
        begin
            lv_up = (moveable && sprite1_col==95);
            sprite2_col = (password_entered | dead) ? sprite2_col : sprite2_col - 1;
            if(sprite2_col > 25 && sprite2_col < 41)
            begin
                password[3] = (pass1 == 7'b1000111) ? 
                              (volume < 7 && volume > 3) ? 1 : password[3] : 
                              (volume > 7) ? 1 : password[3] ;
                password[2] = (pass2 == 7'b1000111) ? 
                              (volume < 7 && volume > 3 && password[3] == 1) ? 1 : password[2]: 
                              (volume > 7 && password[3] == 1) ? 1 : password[2];
                password[1] = (pass3 == 7'b1000111) ? 
                              (volume < 7 && volume > 3 && password[2] == 1) ? 1 : password[1]: 
                              (volume > 7 && password[2] == 1) ? 1 : password[1];
                password[0] = (pass4 == 7'b1000111) ? 
                              (volume < 7 && volume > 3 && password[1] == 1) ? 1 : password[0]: 
                              (volume > 7 && password[1] == 1) ? 1 : password[0];        
                password_entered = (btnL & btnR) || (password == 4'b1111) ? 1 : password_entered;
            end
            if(open_trapdoor)
                sprite2_row = (sprite2_row > 65) ? sprite2_row : sprite2_row+1;
            if(moveable)
                sprite1_col = (sprite1_col < 95) ? sprite1_col +1 : sprite1_col;
        end
    end
    
    assign dead = (sprite2_col < 20 && ~password_entered) ? 1 : 0 ;
    assign open_trapdoor = password_entered;
    assign moveable = (sprite2_row > 65);
    
    always@ (posedge clk)
    begin
        if ((row>sprite1_row && (row <(sprite1_row+mc_height))) && (column > sprite1_col && (column < (sprite1_col + mc_wid))) && !dead) 
        begin
            oled_data_corridor = color_mc;
        end    
        else if ( ((row>sprite2_row) && (row<(sprite2_row+guard_height))) && ((column > sprite2_col) && (column < ( sprite2_col + guard_wid ))) )
        begin
            oled_data_corridor = color_guard;
        end    
        else if(open_trapdoor && sprite2_row < 65)
            oled_data_corridor = color_data_fall;
        else if(dead)
            oled_data_corridor = color_data_dead;
        else
            oled_data_corridor = color_data_bg;
    end   
 
    //Segment
    reg [1:0] counter = 0;
    wire seg_clk;
    reg [9:0] show_combi = 0;
    timers randomname(.CLOCK(clk),.out(seg_clk),.check(32'd131_232));
    reg flag = 0;

    //Password input
    always @(posedge seg_clk ) 
    begin 
        if(state == 3)
        begin
            flag = (show_combi == 381) ? 1 : 0;
            show_combi = (flag) ? show_combi : show_combi + 1;
            counter = counter + 1;
            case ({flag,counter})
                0:
                begin
                    an_data = 4'b0111 | password;
                    seg_data = 7'b0001100; //P
                end
                1:
                begin
                    an_data = 4'b1011 | password;
                    seg_data = 7'b0001000; //A
                end
                2:
                begin
                    an_data = 4'b1101 | password;
                    seg_data = 7'b0010010; //S
                end
                3:  
                begin
                    an_data = 4'b1110 | password;
                    seg_data = 7'b0010010; //S
                end
                4:
                begin
                    an_data = 4'b0111 | password;
                    seg_data = pass1; //num1
                end
                5:
                begin
                    an_data = 4'b1011 | password;
                    seg_data = pass2; //num2
                end
                6:
                begin
                    an_data = 4'b1101 | password;
                    seg_data = pass3; //num3
                end
                7:  
                begin
                    an_data = 4'b1110 | password;
                    seg_data = pass4; //num4
                end
            endcase
        end
        
        else
            an_data = 4'b1111;
    end

 endmodule