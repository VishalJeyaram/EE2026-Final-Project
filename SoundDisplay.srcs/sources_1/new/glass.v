`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2021 19:09:11
// Design Name: 
// Module Name: glass
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


module glass( 
      input [2:0] state,
      input reset_ext,
      input CLK100MHZ, 
      input btnC,
      input btnR,
      input [15:0] led, 
      input [5:0] row,
      input [6:0] column,
      output reg [15:0]oled_glass_data = 0,
      output reg lv_up = 0
      );
      
    reg [7:0] mc_wid = 6;
    reg [7:0] mc_height = 13;
    reg [7:0] sprite1_row = 29; //mc current row
    reg [7:0] sprite1_col = 20; //mc current col
    wire [7:0] row_mc; // to generate the said row
    wire [7:0] col_mc; // to generate the said column
    wire [15:0]color_mc; // color data for main character
    wire [15:0]glass_cracked; // color data for cracked glass background
    wire [15:0]glass_destroyed;
    wire [15:0]glassisok;
    
    wire reset;
    assign reset = reset_ext || btnC;
    
    assign row_mc = ((row>sprite1_row) && (row< (sprite1_row+mc_height)) ) ? row-sprite1_row : 0 ; 
    assign col_mc = ((column>sprite1_col) && (column <sprite1_col + mc_wid)) ? column-sprite1_col : 0 ;   
    
    wire clk6p25m;
    timers ledclockglass(CLK100MHZ, clk6p25m, 32'd7); // to generate led clock
    
    maincharacter_rom mcglass(row_mc, col_mc, color_mc);
    glassminorcracks_rom glasiscracked(CLK100MHZ, row, column, glass_cracked);   
    smithereens_rom destroyed(CLK100MHZ, row, column, glass_destroyed); 
    Glassstillok_rom glassstanding(CLK100MHZ, row, column, glassisok);  
    
    wire sixhz_clock;
    timers traveltotrapdoor(CLK100MHZ, sixhz_clock ,32'd8333332);
    
    reg [15:0]pass = 16'b0;
    reg glass_shatters = 0; // to notify when glass cracks
    reg smither = 0; // to notify when class is completely broken
    reg clockinuse = 0; // current clock that is in use
    
    
    always @ ( posedge CLK100MHZ )
    begin
        if (glass_shatters == 1)
            clockinuse = sixhz_clock;
        else 
            clockinuse = clk6p25m;
    end 
       
   always @ (posedge clockinuse)
   begin
       if(reset)
       begin
           sprite1_col = 20;
           pass = 0;
           smither = 0;
           lv_up = 0;
           glass_shatters = 0;
       end
       if(state ==4)
       begin
           if(sprite1_col>95)
                lv_up = 1;
           if ((glass_shatters == 1) && (sprite1_col == 49))
               smither = 1;
           if (( glass_shatters == 1) && (btnR == 1)) 
               sprite1_col = (sprite1_col < 96) ? sprite1_col + 1 : sprite1_col;
           else
           begin
               if ( led == 16'b0000000000000001 ) 
               pass[0] = 1; 
               if ( led == 16'b0000000000000011) 
               pass[1] = 1; 
               if ( led == 16'b0000000000000111)
               pass[2] = 1; 
               if ( led == 16'b0000000000001111)
               pass[3] = 1; 
               if ( led == 16'b0000000000011111)
               pass[4] = 1; 
               if ( led == 16'b0000000000111111)
               pass[5] = 1; 
               if ( led == 16'b0000000001111111)
               pass[6] = 1; 
               if ( led == 16'b0000000011111111)
               pass[7] = 1; 
               if ( led == 16'b0000000111111111)
               pass[8] = 1; 
               if ( led == 16'b0000001111111111)
               pass[9] = 1; 
               if ( led == 16'b0000011111111111)
               pass[10] = 1; 
               if ( led == 16'b0000111111111111)
               pass[11] = 1; 
               if ( led == 16'b0001111111111111)
               pass[12] = 1; 
               if ( led == 16'b0011111111111111)
               pass[13] = 1; 
               if ( led == 16'b0111111111111111)
               pass[14] = 1; 
               if ( led == 16'b1111111111111111)
               pass[15] = 1;
               if ( pass == 16'b1111111111111111)  
               glass_shatters = 1;
           end
       end
   end
             
   always @ ( posedge clk6p25m )
   begin      
       if (((row > sprite1_row) && (row < (sprite1_row + mc_height))) && (( column > sprite1_col ) && ( column < ( sprite1_col + mc_wid ) ) ) )
       begin
             oled_glass_data = color_mc;
       end    
       
       else 
       begin
          if ( smither == 1 ) 
          begin
               oled_glass_data = glass_destroyed;
          end                                              
          
          else if ( glass_shatters == 1 )
          begin 
               oled_glass_data = glass_cracked;
          end
          
          else 
          begin
               oled_glass_data = glassisok;
          end
      end
   end                       
       
endmodule
