`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//
//  LAB SESSION DAY (Delete where applicable): MONDAY P.M, TUESDAY P.M, WEDNESDAY P.M, THURSDAY A.M., THURSDAY P.M
//
//  STUDENT A NAME: 
//  STUDENT A MATRICULATION NUMBER: 
//
//  STUDENT B NAME: 
//  STUDENT B MATRICULATION NUMBER: 
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,    // Connect to this signal from Audio_Capture.v
    input CLOCK,
    output [15:0] led,
    input [15:0] sw,
    input btnC,
    input btnR,
    input btnL,
    input btnU,
    input btnD,
    output [7:0] JC,
    output [6:0] seg,
    output [3:0] an
    // Delete this comment and include other inputs and outputs here
    );

    // Delete this comment and write your codes and instantiations here
    wire my_20KHz_clk;
    timers a(CLOCK, my_20KHz_clk, 32'd2499);
    
    wire clk6p25m;
    timers b(CLOCK, clk6p25m, 32'd7);
    
    wire [11:0] MIC_in;
    
    wire [15:0] pixel_data;
    
    wire reset,reset_global;
    pulse reset_sig(.CLOCK(clk6p25m), .in(btnC), .out(reset));
    assign reset_global = sw[1];
    
    //Random stuff
    wire frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index;
    wire [4:0] teststate;
    
    Oled_Display test (
                    .clk(clk6p25m),
                    .reset(reset),
                    .frame_begin(frame_begin), 
                    .sending_pixels(sending_pixels),
                    .sample_pixel(sample_pixel), 
                    .pixel_index(pixel_index), 
                    .pixel_data(pixel_data), 
                    .cs(JC[0]), 
                    .sdin(JC[1]), 
                    .sclk(JC[3]), 
                    .d_cn(JC[4]), 
                    .resn(JC[5]), 
                    .vccen(JC[6]),
                    .pmoden(JC[7]),
                    .teststate(teststate)
                    );
                    
    Audio_Capture microphone(
                        .CLK(CLOCK),                  // 100MHz clock
                        .cs(my_20KHz_clk),                   // sampling clock, 20kHz
                        .MISO(J_MIC3_Pin3),                 // J_MIC3_Pin3, serial mic input
                        .clk_samp(J_MIC3_Pin1),            // J_MIC3_Pin1
                        .sclk(J_MIC3_Pin4),            // J_MIC3_Pin4, MIC3 serial clock
                        .sample(MIC_in)     // 12-bit audio sample data
                        );

   
    wire [2:0] state;
    
    wire [5:0] vol;
    wire [15:0]ledwire;
    wire [3:0]an_data_vol;
    wire [6:0]seg_data_vol;
    peaking_algorithm  peakvsmic(CLOCK,MIC_in,sw[0],sw[11],vol,ledwire,an_data_vol,seg_data_vol);
    
    wire seg_clock;    
    timers segment(.CLOCK(CLOCK),.out(seg_clock),.check(32'd131_232));    
    
    assign led = ledwire;
    
    //get coordinate system to pass to other functions
    wire [7:0] row;
    wire [7:0] column;
    coordinates coords(
    .pixel_index(pixel_index),
    .row(row),
    .column(column)
    );
    
    wire [6:0] seg_data_corri;
    wire [3:0] an_data_corri;
    wire [15:0] oled_corri;
    
    wire [2:0] opt_selected;
    wire lv_up;
    wire lv_up1;
    wire lv_up2; 
    
    wire [6:0] seg_data;
    wire [3:0] an_data;
    
    assign seg = seg_data;
    assign an = an_data;
    
    state_ctrl state_check(
    .clk(CLOCK),
    .menu_state(opt_selected),
    .state(state),
    .lv_0_over(lv_up),
    .lv_1_over(lv_up1),
    .lv_2_over(lv_up2),
    .reset(reset_global) 
    );
    
    wire [15:0] oled_data_menu;
    menu my_menu(
    .reset(reset_global),
    .clk(clk6p25m),
    .btnL(btnL),
    .btnR(btnR),
    .btnC(btnC),
    .row(row),
    .column(column),
    .oled_data_menu(oled_data_menu),
    .state(state),
    .opt_selected(opt_selected)
    );
    
    wire [15:0] Oled_data_vol;
    Oled_vol vol_disp(
    .state(state),
    .clk(clk6p25m),
    .row(row),
    .column(column),
    .pixel_data(Oled_data_vol),
    .vol(vol),
    .btnL(btnL),
    .btnR(btnR),
    .thicken(sw[12]),
    .color_swap(sw[13]),
    .hide_border(sw[14]),
    .hide_volume(sw[15])
    );
    
    wire [7:0] pass1,pass2,pass3,pass4;
    
    wire [15:0] oled_handcuffs;
    handcuffs lv0(
    .reset_ext(reset_global),
    .state(state),
    .clk(clk6p25m),
    .btnL(btnL),
    .btnR(btnR),
    .btnU(btnU),
    .btnD(btnD),
    .btnC(btnC),
    .pixel_data(oled_handcuffs),
    .pass1(pass1),
    .pass2(pass2),
    .pass3(pass3),
    .pass4(pass4),
    .row(row),
    .column(column),
    .breaking_free(lv_up)
    );
    
    corridor lv1(
    .lv_up(lv_up1),
    .volume(vol),
    .reset_ext(reset_global),
    .state(state),
    .clk(CLOCK),
    .btnR(btnR),
    .btnL(btnL),
    .btnC(btnC),
    .row(row),
    .column(column),
    .seg_data(seg_data_corri),
    .an_data(an_data_corri),
    .oled_data_corridor(oled_corri),
    .pass1(pass1),
    .pass2(pass2),
    .pass3(pass3),
    .pass4(pass4)
    );
    
    wire [15:0] oled_glass_data;
    
    
    glass lv2(
    .state(state),
    .reset_ext(reset_global),
    .CLK100MHZ(CLOCK), 
    .btnR(btnR),
    .btnC(btnC),
    .led(led), 
    .row(row),
    .column(column),
    .oled_glass_data(oled_glass_data),
    .lv_up(lv_up2)
    );
    
//   wire [15:0]oled_spidey_data;
//   fight(CLOCK, btnR,btnL, btnU,btnD,row,column,sw[2],sw[10], vol, oled_spidey_data );
    
//    wire snake_speed;
//    timers snake_clk(CLOCK, snake_speed ,32'd249999);
//    wire [15:0] snakedata;
    
//    snake snek(
//        .clk(snake_speed),
//        .btnU(btnU),
//        .btnL(btnL),
//        .btnR(btnR),
//        .btnD(btnD),
//        .pixel_index(pixel_index),
//        .pixel_data(snakedata)
//        );
//        wire [15:0] oled_draw;
//        draw etch_a_sketch(
//            .state(state), 
//            .reset_ext(reset_global),
//            .clk(CLOCK),
//            .row(row),
//            .column(column),
//            .btnC(btnC),
//            .btnR(btnR),
//            .btnU(btnU),
//            .btnD(btnD),
//            .btnL(btnL),
//            .pixel_data(oled_draw)
//            );
    
    wire [15:0] venom_data;
    fight venom_fight( 
              .CLOCK(CLOCK), 
              .btnR(btnR),
              .btnL(btnL),
              .btnU(btnU),
              .btnD(btnD),
              .row(row),
              .column(column),
              .sw2(sw[2]),
              .sw10(sw[10]),
              .num(vol),
              .oled_spidey_data(venom_data),
              .state(state),
              .reset_ext(reset_global),
              .btnC(btnC)
            );
    
    
    
    disp dispmux(
    .clk(seg_clock),
    .state(state),
    .oled_data_vol(Oled_data_vol),
    .oled_data_menu(oled_data_menu),
    .oled_data_corridor(oled_corri),
    .oled_handcuffs(oled_handcuffs),
    .oled_data_glass(oled_glass_data),
    .oled_venom(venom_data),
    //add other oled datas here (button mash),(snake if possible) (Firefight)
    .seg_data_vol(seg_data_vol),
    .an_data_vol(an_data_vol),
    .seg_data_corridor(seg_data_corri),
    .an_data_corridor(an_data_corri),
    .seg_data(seg_data),
    .an_data(an_data),
    .Oled_data(pixel_data)
    );
endmodule