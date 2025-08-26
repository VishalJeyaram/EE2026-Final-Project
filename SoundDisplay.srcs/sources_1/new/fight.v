`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2021 03:09:09
// Design Name: 
// Module Name: fight
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


module fight( 
              input CLOCK, 
              input btnR,
              input btnL,
              input btnU,
              input btnD,
              input [5:0] row,
              input [6:0] column,
              input sw2,
              input sw10,
              input [5:0]num,
              output reg [15:0]oled_spidey_data = 16'hFFFF,
              input [2:0] state,
              input reset_ext,
              input btnC
            );
    
    
    reg [7:0] spidey_wid = 17;
    reg [7:0] spidey_height = 28;
    reg [7:0] sprite1_row = 35; //spidey current row
    reg [7:0] sprite1_col = 25; //spidey current col
    wire [7:0] row_spidey; // to generate the said row
    wire [7:0] col_spidey; // to generate the said column
    reg [7:0] venom_wid = 35;
    reg [7:0] venom_height = 46;
    reg [7:0] sprite2_row = 21; //spidey current row
    reg [7:0] sprite2_col = 55; //spidey current col
    wire [7:0] row_venom; // to generate the said row
    wire [7:0] col_venom;
    
    
    assign row_spidey = ((row>sprite1_row) && (row< (sprite1_row+ spidey_height)) ) ? row-sprite1_row : 0 ; 
    assign col_spidey = ((column>sprite1_col) && (column <sprite1_col + spidey_wid)) ? column-sprite1_col : 0 ; 
    assign row_venom = ((row>sprite2_row) && (row< (sprite2_row+ venom_height)) ) ? row-sprite2_row : 0 ; 
    assign col_venom = ((column>sprite2_col) && (column <sprite2_col + venom_wid)) ? column-sprite2_col : 0 ;    
    
    
    reg [7:0] spideyhealth_starting = 11;
    reg [7:0] spideyhealth_height = 3;
    reg [7:0] spideyhealth_ending = 12;
    reg [7:0] venomhealth_starting = 51;
    reg [7:0] venomhealth_height = 3;
    reg [7:0] venomhealth_ending = 52;
    
    
    wire [15:0]color_spidey;
    wire [15:0]color_venom;
    wire [15:0]color_rooftop;
    wire [15:0]venompunches;
    wire [15:0]spideypunches;
    wire [15:0]healthbars;
    wire [15:0]ko_data;
    
    reg gameover = 0;
    reg attackforthefirsttimevenom = 0;
    reg attackforthefirsttimespidey = 0;
    reg venomattackspidey = 0;
    reg spideyattacksvenom = 0;
    
    truespiderman_rom spidey(row_spidey, col_spidey, color_spidey);
    truevenom_rom venomous(row_venom, col_venom, color_venom);   
    rooftop_rom battleworld( row, column, color_rooftop);
    venompunch_rom punching1( row, column, venompunches);
    spideypunch_rom punching2( row, column, spideypunches);
    healthdown_rom healthbar( row, column, healthbars );
    koscreen_rom fightover( row, column, ko_data );
    
    wire reset;
    assign reset = reset_ext || btnC;
    
    wire clk6p25m;
    timers venom1(CLOCK, clk6p25m, 32'd7);
    
    wire sixhz_clock;
    timers venom2(CLOCK, sixhz_clock ,32'd8333332);
    
    always @ ( posedge sixhz_clock ) 
    begin
        if(reset)
        begin
            gameover = 0;
            sprite1_col = 35;
            sprite2_col = 55;
            venomhealth_ending = 52;
            spideyhealth_ending = 12;
        end
        
        else if(state == 5)
        begin
            if ( venomhealth_ending == 81 ) 
                gameover = 1;
            else if ( spideyhealth_ending == 43 ) 
                gameover = 1;           
            if ( ((( sprite2_col - sprite1_col ) <= 20 ) && (sw10 == 1)) || ( num >= 8 ) ) 
                venomhealth_ending = venomhealth_ending + 1;
            else if ((( sprite2_col - sprite1_col ) <= 20 ) && (sw2 == 1)) 
                spideyhealth_ending = spideyhealth_ending + 1;            
            if ( ( btnL == 1 ) && ( sprite1_col >= 1 ) ) 
                sprite1_col = sprite1_col - 1;
            else if ( ( btnU == 1 ) && ( (sprite1_col + spidey_wid) <= 95 ) ) 
                sprite1_col = sprite1_col + 1;
            if ( ( btnD == 1 ) && ( sprite2_col >= 1 ) ) 
                sprite2_col = sprite2_col - 1;
            else if ( ( btnR == 1 ) && ( (sprite2_col + venom_wid) <= 95 ) ) 
                sprite2_col = sprite2_col + 1;
       end 
    end
    
    always @ ( posedge clk6p25m )
    begin 
        if(state == 5)
        begin
            if ( gameover == 1 ) 
            begin
                oled_spidey_data = ko_data;
            end          
            else if ( ( ( sprite2_col - sprite1_col ) <= 20 ) && (sw2 == 1)  )
            begin
                oled_spidey_data =  venompunches;
                attackforthefirsttimevenom = 1;
                venomattackspidey = 1;
            end           
            else if ( ( ( sprite2_col - sprite1_col ) <= 20 ) && (sw10 == 1)  )
            begin
                oled_spidey_data =  spideypunches;
                attackforthefirsttimespidey = 1;
                spideyattacksvenom = 1;
            end       
            else if ( ( attackforthefirsttimespidey  == 1 ) && ( ( row >= 3 ) && ( row <= 8 ) ) && ( ( column > spideyhealth_starting ) && ( column < spideyhealth_ending ) ) )
                 oled_spidey_data = healthbars;           
            else if ( (  attackforthefirsttimespidey  == 1 ) && ( ( row >= 3 ) && ( row <= 8 ) ) && ( ( column > venomhealth_starting ) && ( column < venomhealth_ending ) ) )
                 oled_spidey_data = healthbars;          
            else if ( ( ( row > sprite1_row ) && ( row < ( sprite1_row + spidey_height ) ) ) && ( ( column > sprite1_col ) && ( column < ( sprite1_col + spidey_wid ) ) ) )
            begin
                 oled_spidey_data = color_spidey;
            end    
            else if ( ( ( row > sprite2_row ) && ( row < ( sprite2_row + venom_height ) ) ) && ( ( column > sprite2_col ) && ( column < ( sprite2_col + venom_wid ) ) ) )
            begin
                oled_spidey_data = color_venom;
            end                                              
            else 
            begin
                oled_spidey_data = color_rooftop;
            end
            venomattackspidey = 0;
            spideyattacksvenom = 0;
        end
    end                       
     
endmodule


//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 03.04.2021 03:09:09
//// Design Name: 
//// Module Name: fight
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


//module fight( 
//              input CLOCK, 
//              input btnR,
//              input btnL,
//              input btnU,
//              input btnD,
//              input [5:0] row,
//              input [6:0] column,
//              input sw2,
//              input sw10,
//              input [5:0]num,
//              output reg [15:0]oled_spidey_data = 16'hFFFF,
//              input [2:0] state,
//              input reset_ext,
//              input btnC
//            );
    
    
//    reg [7:0] spidey_wid = 17;
//    reg [7:0] spidey_height = 28;
//    reg [7:0] sprite1_row = 35; //spidey current row
//    reg [7:0] sprite1_col = 25; //spidey current col
//    wire [7:0] row_spidey; // to generate the said row
//    wire [7:0] col_spidey; // to generate the said column
//    reg [7:0] venom_wid = 35;
//    reg [7:0] venom_height = 46;
//    reg [7:0] sprite2_row = 21; //spidey current row
//    reg [7:0] sprite2_col = 55; //spidey current col
//    wire [7:0] row_venom; // to generate the said row
//    wire [7:0] col_venom;
    
//    reg [7:0] spideyhealth_wid = 2;
//    reg [7:0] spideyhealth_height = 5;
//    reg [7:0] sprite3_row = 3; //spidey health current row
//    reg [7:0] sprite3_col = 11; //spidey health current col
//    wire [7:0] row_spideyhealth; // to generate the said row
//    wire [7:0] col_spideyhealth; // to generate the said column
//    reg [7:0] venomhealth_wid = 2;
//    reg [7:0] venomhealth_height = 5;
//    reg [7:0] sprite4_row = 3; // venom health current row
//    reg [7:0] sprite4_col = 51; // venom health current col
//    wire [7:0] row_venomhealth; //
//    wire [7:0] col_venomhealth;
//    reg attackforthefirsttimevenom = 0;
//    reg attackforthefirsttimespidey = 0;
//    reg venomattackspidey = 0;
//    reg spideyattacksvenom = 0;
//    reg gameover = 0;
    

    
//    assign row_spidey = ((row>sprite1_row) && (row< (sprite1_row+ spidey_height)) ) ? row-sprite1_row : 0 ; 
//    assign col_spidey = ((column>sprite1_col) && (column <sprite1_col + spidey_wid)) ? column-sprite1_col : 0 ; 
//    assign row_venom = ((row>sprite2_row) && (row< (sprite2_row+ venom_height)) ) ? row-sprite2_row : 0 ; 
//    assign col_venom = ((column>sprite2_col) && (column <sprite2_col + venom_wid)) ? column-sprite2_col : 0 ;    
    
//    assign row_spideyhealth = ((row>sprite3_row) && (row< (sprite3_row+ spideyhealth_height)) ) ? row-sprite3_row : 0 ; 
//    assign col_spideyhealth = ((column>sprite3_col) && (column <sprite3_col + spideyhealth_wid)) ? column-sprite3_col : 0 ; 
//    assign row_venomhealth = ((row>sprite4_row) && (row< (sprite4_row+ venomhealth_height)) ) ? row-sprite4_row : 0 ; 
//    assign col_venomhealth = ((column>sprite4_col) && (column <sprite4_col + venomhealth_wid)) ? column-sprite4_col : 0 ;     
    
//    wire [15:0]color_spidey;
//    wire [15:0]color_venom;
//    wire [15:0]color_rooftop;
//    wire [15:0]venompunches;
//    wire [15:0]spideypunches;
//    wire [15:0]spiderhealth;
//    wire [15:0]venomhealth;
//    wire [15:0]ko_data;
    
//    truespiderman_rom spidey(row_spidey, col_spidey, color_spidey);
//    truevenom_rom venomous(row_venom, col_venom, color_venom);   
//    rooftop_rom battleworld( row, column, color_rooftop);
//    venompunch_rom punching1( row, column, venompunches);
//    spideypunch_rom punching2( row, column, spideypunches);
//    healthbar_rom spideyhealth ( row_spideyhealth, col_spideyhealth, spiderhealth );
//    healthbar_rom venhealth ( row_venomhealth, col_venomhealth, venomhealth );
//    koscreen_rom fightover( row, column, ko_data );
    
          
    
//    wire clk6p25m;
//    timers venomclk1(CLOCK, clk6p25m, 32'd7);
    
//    wire sixhz_clock;
//    timers venomclk2(CLOCK, sixhz_clock ,32'd8333332);
    
//    always @ ( posedge sixhz_clock ) 
//    begin
//        if(reset)
//        begin
//            gameover = 0;
//            spideyhealth_wid = 2;
//            venomhealth_wid = 2;
//            sprite1_col = 35;
//            sprite2_col = 55;
//        end
//        if(state == 5)
//        begin
//            if ( venomhealth_wid == 31 ) 
//                gameover = 1;
//            else if ( spideyhealth_wid == 31 ) 
//                gameover = 1;
//            if ( ( spideyattacksvenom == 1 ) || ( num >= 8 ) ) 
//                venomhealth_wid = venomhealth_wid + 1;
//            else if ( venomattackspidey == 1 ) 
//                spideyhealth_wid = spideyhealth_wid + 1;
//            if ( ( btnL == 1 ) && ( sprite1_col >= 1 ) ) 
//                sprite1_col = sprite1_col - 1;
//            else if ( ( btnU == 1 ) && ( (sprite1_col + spidey_wid) <= 95 ) ) 
//                sprite1_col = sprite1_col + 1;
//            if ( ( btnD == 1 ) && ( sprite2_col >= 1 ) ) 
//                sprite2_col = sprite2_col - 1;
//            else if ( ( btnR == 1 ) && ( (sprite2_col + venom_wid) <= 95 ) ) 
//                sprite2_col = sprite2_col + 1;
//        end
//    end
    
//    always @ ( posedge clk6p25m )
//    begin 
//        if(state ==5)
//        begin
//            if ( gameover == 1 ) 
//            begin
//                oled_spidey_data = ko_data;
//            end
            
            
//            else if ( ( ( sprite2_col - sprite1_col ) <= 20 ) && (sw2 == 1)  )
//            begin
//                    oled_spidey_data =  venompunches;
//                    attackforthefirsttimevenom = 1;
//                    venomattackspidey = 1;
//            end
            
//            else if ( ( ( sprite2_col - sprite1_col ) <= 20 ) && (sw10 == 1)  )
//            begin
//                oled_spidey_data =  spideypunches;
//                attackforthefirsttimespidey = 1;
//                spideyattacksvenom = 1;
//            end
            
//            else if (( attackforthefirsttimevenom  == 1 ) && (( row > sprite3_row ) && ( row < ( sprite3_row + spideyhealth_height ) ) ) && ( ( column > sprite3_col ) && ( column < ( sprite3_col + spideyhealth_wid ) ) ) )
//                 oled_spidey_data = spiderhealth;
            
//            else if ((  attackforthefirsttimespidey  == 1 ) && (( row > sprite4_row ) && ( row < ( sprite4_row + venomhealth_height ) ) ) && ( ( column > sprite4_col ) && ( column < ( sprite4_col + venomhealth_wid ) ) ) )
//                 oled_spidey_data = venomhealth;
            
//            else if ( ( ( row > sprite1_row ) && ( row < ( sprite1_row + spidey_height ) ) ) && ( ( column > sprite1_col ) && ( column < ( sprite1_col + spidey_wid ) ) ) )
//            begin
//                 oled_spidey_data = color_spidey;
//            end    
           
//            else if ( ( ( row > sprite2_row ) && ( row < ( sprite2_row + venom_height ) ) ) && ( ( column > sprite2_col ) && ( column < ( sprite2_col + venom_wid ) ) ) )
//            begin
//                oled_spidey_data = color_venom;
//            end   
//        end
              
//            else 
//            begin
//            oled_spidey_data = color_rooftop;
//            end
            
//            venomattackspidey = 0;
//            spideyattacksvenom = 0;
//            end                       
     
//endmodule
