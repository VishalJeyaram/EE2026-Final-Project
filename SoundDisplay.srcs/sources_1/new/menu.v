module menu (
    input [2:0] state,
    input reset,
    input clk,
    input btnL,
    input btnR,
    input btnC,
    input [7:0] row,
    input [7:0] column,
    output reg [2:0] opt_selected,
    output reg [15:0] oled_data_menu = 0
);
    reg [1:0] menu_frame = 0;
    reg menu_state = 0;
    
    wire frame_clock;
    timers fps(clk, frame_clock ,32'd2223332);
    
    always @(posedge frame_clock) 
    begin
        menu_frame = menu_frame + 1;    
    end
    
    wire [15:0] color_frame1;
    wire [15:0] color_frame2;
    wire [15:0] color_frame3;
    wire [15:0] color_frame4;
    
    menu_rom frame1(row,column,color_frame1);
    menu1_rom frame2(row,column,color_frame2);
    menu2_rom frame3(row,column,color_frame3);
    menu3_rom frame4(row,column,color_frame4);
    
    wire set;
    wire left;
    wire right;
    pulse left_sig(.CLOCK(clk), .in(btnL), .out(left));
    pulse right_sig(.CLOCK(clk), .in(btnR), .out(right));
    pulse set_sig(.CLOCK(clk), .in(btnC), .out(set));

    always @(posedge clk) 
    begin
        if(state == 0)
        begin
            if(left)
                menu_state = menu_state-1;   
            if(right)
                menu_state = menu_state+1;    
            if(set)
                opt_selected = menu_state + 1; 
        end    
        if(state != 0)
            opt_selected = 0;
        if(reset)
        begin
            menu_state = 0;
        end
    end
 
    always @(posedge clk) 
    begin
        if((row < 3 || row > 60 || column < 3) && column < 45)
            oled_data_menu = (menu_state == 0) ? 16'hFFFF : 0;
        else if((row < 3 || row > 60 || column > 93) && column > 47)
            oled_data_menu = (menu_state == 1) ? 16'hFFFF : 0;
        else if(column > 44 & column < 48)
            oled_data_menu  = 16'hFFFF;
//        else if(row > 34 & column > 49 )
//            oled_data_menu = (menu_state == 3) ? 16'hFFFF : 0;
        else 
        begin
            case(menu_frame)
                0:
                    oled_data_menu = color_frame1;  
                1:
                    oled_data_menu = color_frame2;  
                2:
                    oled_data_menu = color_frame3;  
                3:
                    oled_data_menu = color_frame4;  
            endcase  
        end
    end

endmodule