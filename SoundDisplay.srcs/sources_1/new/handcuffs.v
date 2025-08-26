`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2021 12:34:23
// Design Name: 
// Module Name: handcuffs
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


module handcuffs(
    input [1:0] state,
    input reset_ext,
    input clk,
    input btnL,
    input btnR,
    input btnU,
    input btnD,
    input btnC,
    input [7:0] row,
    input [7:0] column,
    output reg [15:0] pixel_data,
    output reg [6:0]pass1 = 7'b0,
    output reg [6:0]pass2 = 7'b0,
    output reg [6:0]pass3 = 7'b0,
    output reg [6:0]pass4 = 7'b0,
    output reg breaking_free = 0
    );
    
    reg [4:0]up_counter = 5'b0;
    reg [4:0]down_counter = 5'b0;
    reg [4:0]left_counter = 5'b0;
    reg [4:0]right_counter = 5'b0;
    
    wire left,right,up,down,reset,reset_int;
    pulse left_sig(.CLOCK(clk), .in(btnL), .out(left));
    pulse right_sig(.CLOCK(clk), .in(btnR), .out(right));
    pulse up_sig(.CLOCK(clk), .in(btnU), .out(up));
    pulse down_sig(.CLOCK(clk), .in(btnD), .out(down));
    pulse reset_timer(.CLOCK(clk), .in(btnC), .out(reset_int));
    
    assign reset = reset_int || reset_ext;

    reg image_state = 1'b0; // to cycle between the two different pixel states
    reg [3:0] button_count = 4'b0000; // measures the number of button counts 
    reg [32:0] ten_second_co = 0; // to count to ten seconds
    reg start_countdown = 0;
    wire [15:0]pixel_data_1;
    wire [15:0]pixel_data_2;
    wire [15:0]pixel_data_3;
    wire [15:0]pixel_data_4;
    
    always @ ( posedge clk ) 
    begin 
        if(reset_ext)
        begin
            up_counter = 0;
            down_counter = 0;
            left_counter = 0;
            right_counter = 0;
        end
        if(state == 2)
        begin
            if(reset_int)
            begin
                up_counter = 0;
                down_counter = 0;
                left_counter = 0;
                right_counter = 0;
            end
            if (up)
                up_counter = up_counter + 1;
            if (down)
                down_counter = down_counter + 1;
            if (left) 
                left_counter = left_counter + 1;
            if (right)
                right_counter = right_counter + 1; 
        end    
        if (breaking_free) 
        begin
             if ( down_counter > 5 )
                pass1 = 7'b1000111;
             else 
                pass1 = 7'b0001001;
             if ( up_counter > 5 )
                pass2 = 7'b1000111;
             else 
                pass2 = 7'b0001001;
             if ( left_counter > 5 )
                pass3 = 7'b1000111;
             else 
                pass3 = 7'b0001001;
             if ( right_counter > 5 )
                pass4 = 7'b1000111;
             else 
                pass4 = 7'b0001001;
        end
    end

    
    handcuff_rom locked(clk,row, column, pixel_data_1);
    handcuff1_rom shaking1(clk,row, column, pixel_data_2);
    handcuff2_rom shaking2(clk,row, column, pixel_data_3);
    handcuff_broken_rom breakout(clk,row, column, pixel_data_4);
         
    always @ (posedge clk) 
    begin
        if ( reset == 1 )
        begin
            start_countdown = 0;
            ten_second_co = 0;
        end
        if(state == 2)
        begin
            if ( (down == 1 ) || (up == 1 )  || (left == 1) || (right == 1) ) 
               start_countdown = 1;
            else if(start_countdown)
                ten_second_co = (ten_second_co < 62500000 ) ? ten_second_co + 1 : ten_second_co;    
        end
    end
        
    always @ (posedge clk) 
    begin   
        if (reset) 
        begin
            pixel_data = pixel_data_1;
            breaking_free = 0;
            image_state = 0;
            button_count = 4'b0000;
        end
        if(state==2)
        begin  
            if (breaking_free) 
                pixel_data = pixel_data_4;
            else if (start_countdown) 
            begin
                if((down) || (up) || (left) || (right))
                begin
                    button_count = button_count + 1; 
                    image_state = image_state + 1;
                end
                if ((ten_second_co < 62500000) && (button_count >= 4'b1010) )  
                    breaking_free = 1;
                else if ((ten_second_co == 62500000) && (button_count < 4'b1010) ) 
                    pixel_data = pixel_data_1;   
                else if (image_state)  
                    pixel_data = pixel_data_3;
                else
                    pixel_data = pixel_data_2;
            end              
            else 
                pixel_data = pixel_data_1;
        end
    end
endmodule
