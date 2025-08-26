`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2021 13:09:26
// Design Name: 
// Module Name: peaking_algorithm
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


module peaking_algorithm(
    input CLOCK,
    input [11:0]mic_in,
    input sw0,
    input sw11,
    output reg [5:0] num = 0,
    output reg [15:0]led = 0,
    output reg [3:0]an = 4'b1111,
    output reg [6:0]seg = 7'b1111111
    );
    
    wire twenty_khz_clock;
    timers twentykhz(CLOCK, twenty_khz_clock ,32'd2499);
    
    wire thirty_hz;
    timers thirtykhz(CLOCK, thirty_hz ,32'd1666665);
    
    
    wire clktouse;
    assign clktouse = (sw0) ? twenty_khz_clock : thirty_hz;
    
    
    reg [5:0]seg_no = 0;   
    reg [13:0]count = 0;
    reg [11:0]maximum = 0;
    reg [16:0]seven_segcount = 0;
    reg seven_segclock = 0;
    
    always @ (posedge clktouse) //peaking algorithm to obtain 5000 samples
    begin
    
    if ( sw0 == 1 ) 
    begin
        count <= (count == 14'd5000) ? 0 : count + 1; 
        if ( count == 0 ) 
        begin
        maximum <= mic_in;
        end
        else 
        begin
             if ( mic_in > maximum )
             begin
             maximum <= mic_in;
             end
        end
        
        if ( maximum[11] ) 
        begin
        num <= (maximum[10:7] + 1);
        end
        else 
        begin
        num <= 0;
        end
    end
    
    
    else 
    begin
    if ( mic_in[11] ) 
    begin
        num <= (mic_in[10:7] + 1);
    end
    else 
    begin
        num <= 0;
    end
    
    end
    
         
    end
    
    always @ ( posedge CLOCK ) 
    begin
        seven_segcount <= seven_segcount + 1;
        seven_segclock = ( seven_segcount == 0 ) ? ~seven_segclock : seven_segclock;
     // peaking
       
     if(num == 0) begin led<= 16'h0000; seg_no =1; end
     else if(num == 1)begin led<= 16'h0001; seg_no =2; end
     else if(num == 2)begin led<= 16'h0003; seg_no =3; end
     else if(num == 3)begin led<= 16'h0007; seg_no =4; end
     else if(num == 4)begin led<= 16'h000F; seg_no =5; end
     else if(num == 5)begin led<= 16'h001F; seg_no =6; end
     else if(num == 6)begin led<= 16'h003F; seg_no =7; end
     else if(num == 7)begin led<= 16'h007F; seg_no =8; end
     else if(num == 8)begin led<= 16'h00FF; seg_no =9; end
     else if(num == 9)begin led<= 16'h01FF; seg_no =10; end
     else if(num == 10)begin led<= 16'h03FF; seg_no =11; end
     else if(num == 11)begin led<= 16'h07FF; seg_no =12; end
     else if(num == 12)begin led<= 16'h0FFF; seg_no =13; end
     else if(num == 13)begin led<= 16'h1FFF; seg_no =14; end
     else if(num == 14)begin led<= 16'h3FFF; seg_no =15; end
     else if(num == 15)begin led<= 16'h7FFF; seg_no =16; end
     else if(num >= 16)begin led<= 16'hFFFF; seg_no =17; end
     
//     else 
//     begin 
//     if(mic_in < 2176) begin led<= 16'h0000; end
//     else if(mic_in >=2176 && mic_in<2304)begin led<= 16'h0001; seg_no =1; end
//     else if(mic_in>=2304 && mic_in<2432)begin led<= 16'h0003; seg_no =2; end
//     else if(mic_in>=2432 && mic_in<2560)begin led<= 16'h0007; seg_no =3; end
//     else if(mic_in>=2560 && mic_in<2688)begin led<= 16'h000F; seg_no =4; end
//     else if(mic_in>=2688 && mic_in<2816)begin led<= 16'h001F; seg_no =5; end
//     else if(mic_in>=2816 && mic_in<2944)begin led<= 16'h003F; seg_no =6; end
//     else if(mic_in>=2944 && mic_in<3072)begin led<= 16'h007F; seg_no =7; end
//     else if(mic_in>=3072 && mic_in<3200)begin led<= 16'h00FF; seg_no =8; end
//     else if(mic_in>=3200 && mic_in<3328)begin led<= 16'h01FF; seg_no =9; end
//     else if(mic_in>=3328 && mic_in<3456)begin led<= 16'h03FF; seg_no =10; end
//     else if(mic_in>=3456 && mic_in<3584)begin led<= 16'h07FF; seg_no =11; end
//     else if(mic_in>=3584 && mic_in<3712)begin led<= 16'h0FFF; seg_no =12; end
//     else if(mic_in>=3712 && mic_in<3840)begin led<= 16'h1FFF; seg_no =13; end
//     else if(mic_in>=3840 && mic_in<3968)begin led<= 16'h3FFF; seg_no =14; end
//     else if(mic_in>=3968 && mic_in<4096)begin led<= 16'h7FFF; seg_no =15; end
//     else if(mic_in>= 4096) begin led<= 16'hFFFF; seg_no =16; end
    
//    end
    
    end
    
    reg [2:0]anode_counter = 3'b000;
    reg [6:0]first_seg = 7'b0;
    reg [6:0]second_seg = 7'b1111111;
    reg [6:0]third_seg = 7'b0;
    reg [6:0]fourth_seg = 7'b0;
    
    always @(posedge seven_segclock)
    begin 
    anode_counter <= anode_counter + 1;
    case(anode_counter)
    3'b000: begin 
                if ( sw11 == 1 ) 
                begin
                    seg <= first_seg;
                end
                else
                begin
                    seg <= 7'b1111111;
                end 
                an <= 4'b0111; 
            end
    3'b001: begin 
                seg <= second_seg; 
                an <= 4'b1011; 
            end
    3'b010: begin 
                seg <= third_seg; 
                an <= 4'b1101; 
            end
    3'b011: begin 
                seg <= fourth_seg; 
                an <= 4'b1110; 
            end
    3'b100: begin 
                anode_counter <= 3'b000; 
            end
    endcase
    end
    
     always @ (posedge CLOCK)
     begin
     case(seg_no)
     1:begin 
       first_seg <= 7'b1000111; 
       third_seg <= 7'b1000000; //0
       fourth_seg <= 7'b1000000; //0
       end
     2:begin 
       first_seg <= 7'b1000111; 
       third_seg <= 7'b1000000; //0
       fourth_seg <= 7'b1111001;//1
       
       end
     3:begin 
       first_seg <= 7'b1000111; 
       third_seg <= 7'b1000000; //0
       fourth_seg <= 7'b0100100; //2
       end
     4:begin 
       first_seg <= 7'b1000111; 
       third_seg <= 7'b1000000; //0
       fourth_seg <= 7'b0110000; //3 
       end
     5:begin 
       first_seg <= 7'b1000111; 
       third_seg <= 7'b1000000; //0
       fourth_seg <= 7'b0011001; //4 
      end
     6:begin 
       first_seg <= 7'b1000111;   
       third_seg <= 7'b1000000; //0
       fourth_seg <= 7'b0010010; //5
       end
     7:begin 
       first_seg <= 7'b1101010;
       third_seg <= 7'b1000000; //0
       fourth_seg <= 7'b0000010; //6
       end
     8:begin 
       first_seg <= 7'b1101010;  
       third_seg <= 7'b1000000; //0
       fourth_seg <= 7'b1111000; //7
       end
     9:begin 
       first_seg <= 7'b1101010; 
       third_seg <= 7'b1000000; //0
       fourth_seg <= 7'b0000000; //8 
       end
     10:begin 
       first_seg <= 7'b1101010;
       third_seg <= 7'b1000000; //0
       fourth_seg <= 7'b0010000; //9
       end
     11:begin 
        first_seg <= 7'b1101010;
        third_seg <= 7'b1111001; // 1
        fourth_seg <=  7'b1000000; //0
        end
     12:begin 
        first_seg <= 7'b1101010;
        third_seg <= 7'b1111001; // 1
        fourth_seg <= 7'b1111001;  //1
        end
     13:begin 
        first_seg <= 7'b0001001;  
        third_seg <= 7'b1111001; // 1
        fourth_seg <= 7'b1111001; // 2
        end
     14:begin 
        first_seg <= 7'b0001001;
        third_seg <= 7'b1111001; // 1
        fourth_seg <= 7'b0110000; //3 
        end
     15:begin 
        first_seg <= 7'b0001001;
        third_seg <= 7'b1111001; // 1
        fourth_seg <= 7'b0011001; // 4
        end
     16:begin 
        first_seg <= 7'b0001001;
        third_seg <= 7'b1111001; // 1
        fourth_seg <= 7'b0010010; //5
        end
     17:begin 
        first_seg <= 7'b0001001;
        third_seg <= 7'b1111001; // 1
        fourth_seg <= 7'b0000010; //6
        end
        endcase
     end 
endmodule


