`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2021 16:02:22
// Design Name: 
// Module Name: pulse
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


module disp (
    input clk,
    input [2:0] state,
    input [15:0] oled_data_vol,
    input [15:0] oled_data_menu,
    input [15:0] oled_handcuffs,
    input [15:0] oled_data_corridor,
    input [15:0] oled_data_glass,
    input [15:0] oled_venom,
    //add other oled datas here
    input [7:0] seg_data_vol,
    input [3:0] an_data_vol,
    input [7:0] seg_data_corridor,
    input [3:0] an_data_corridor,
    output reg [7:0] seg_data,
    output reg [3:0] an_data,
    output reg [15:0] Oled_data = 0
);
    
    always @(*) 
    begin
        case (state)
            0:
                Oled_data = oled_data_menu; 
            1:
                Oled_data = oled_data_vol;   
            2:
                Oled_data = oled_handcuffs;
            3:
                Oled_data = oled_data_corridor;
            4:
                Oled_data = oled_data_glass;
            5:
                Oled_data = oled_venom;
            default: 
                Oled_data = 16'hFEF6;
        endcase    
    end
    
    always @(clk) 
    begin
        case (state)
            1:
            begin
                seg_data = seg_data_vol;
                an_data = an_data_vol;
            end
            3:
            begin
                seg_data = seg_data_corridor;
                an_data = an_data_corridor;
            end
            default:
            begin
                seg_data = 7'b1111111;
                an_data = 4'b1111;
            end
        endcase
    end
endmodule