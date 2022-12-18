/*******************************************************************************
 * CS220: Digital Circuit Lab
 * Computer Science Department
 * University of Crete
 * 
 * Date: 2019/XX/XX
 * Author: Your name here
 * Filename: vga_frame.sv
 * Description: Your description here
 *
 ******************************************************************************/

`timescale 1ns/1ps

module vga_frame(
  input logic clk,
  input logic rst,

  input logic i_pix_valid,
  input logic [9:0] i_col,
  input logic [9:0] i_row,
  
  input logic i_rom_en,
  input logic [10:0] i_rom_addr,
  output logic [15:0] o_rom_data,

  input logic [5:0] i_player_bcol,
  input logic [5:0] i_player_brow,

  input logic [5:0] i_exit_bcol,
  input logic [5:0] i_exit_brow,
  
  input logic [5:0] i_bar_bcol,
  input logic [5:0] i_bar_brow,

  output logic [3:0] o_red,
  output logic [3:0] o_green,
  output logic [3:0] o_blue
);

/* maze_rom -----START------ */
logic[15:0] maze_pixel;
logic[10:0] maze_addr;
assign maze_addr = {i_col[9:4] , i_row[8:4] };
logic [24:0] time_cnt;
logic time_cond;

always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        time_cnt <= 0;
    end
    else begin
        time_cnt <= time_cnt + 1;
    end
end

always_comb begin
    if(time_cnt == 24999999) begin
        time_cond = 1;
    end
    else begin
        time_cond = 0;
    end     
end

rom_dp #(
  .size(2048),
  .file("F:/Users/User/Desktop/hy220/lab3_code/roms/maze1.rom") 
)
maze_rom (
  .clk(clk),
  .en(i_pix_valid),
  .addr(maze_addr), /* kanw dieresi epd pezi me ton arithmo tou block */ 
  .dout(maze_pixel),                   /* kanw *32 epd an dw to sxima etsi vgeoun ta amthimatika tou addr */  
  .en_b(i_rom_en),
  .addr_b(i_rom_addr),
  .dout_b(o_rom_data)  
);
/* maze_rom -----END------ */

/* player_rom -----START------ */
logic[15:0] player_pixel;
logic[7:0] player_addr;
assign player_addr = {i_row[3:0] , i_col[3:0] };   /* theli modulo kai oxi dieresi ? ? ? */

rom #(
  .size(256),
  .file("F:/Users/User/Desktop/hy220/lab3_code/roms/player.rom") 
)
player_rom (
  .clk(clk),
  .en(i_pix_valid),
  .addr(player_addr),   
  .dout(player_pixel)                  
);
/* player_rom ------END------ */

/* exit_rom ------START------ */
logic[15:0] exit_pixel;
logic[7:0] exit_addr;
assign exit_addr = { i_row[3:0] , i_col[3:0]  };

rom #(
  .size(256),
  .file("F:/Users/User/Desktop/hy220/lab3_code/roms/exit.rom") 
)
exit_rom (
  .clk(clk),
  .en(i_pix_valid),
  .addr(exit_addr),   
  .dout(exit_pixel)                 
);
/* exit_rom ------END------ */


logic temp_i_pix_valid;
logic[9:0] temp_i_col;
logic[9:0] temp_i_row;
logic[5:0] temp_i_player_bcol;
logic[5:0] temp_i_player_brow;
logic[5:0] temp_i_exit_bcol;
logic[5:0] temp_i_exit_brow;
logic[5:0] temp_i_bar_bcol;
logic[5:0] temp_i_bar_brow;

always_comb begin
    if(temp_i_pix_valid == 0) begin
        o_red = 0;
        o_green = 0;
        o_blue = 0;
    end
    else if(temp_i_col/16 >= 40 || temp_i_row/16 >= 30) begin  
        o_red = 0;
        o_green = 0;
        o_blue = 0;
    end 
    else if(temp_i_player_bcol == temp_i_col/16 && temp_i_player_brow == temp_i_row/16) begin
        o_red = player_pixel[3:0];
        o_green = player_pixel[7:4];
        o_blue = player_pixel[11:8];
        end
    else if(temp_i_exit_bcol == temp_i_col/16 && temp_i_exit_brow == temp_i_row/16) begin
        o_red = exit_pixel[3:0];
        o_green = exit_pixel[7:4];
        o_blue = exit_pixel[11:8];
    end 
    else begin
        o_red = maze_pixel[15:12];
        o_green = maze_pixel[11:8];
        o_blue = maze_pixel[7:4];
    end    
end


always_ff @(posedge clk or posedge rst) begin
    if(rst == 1) begin
        temp_i_pix_valid <= 0;
        temp_i_col <= 0;
        temp_i_row <= 0;
        temp_i_player_bcol <= 0;
        temp_i_player_brow <= 0;
        temp_i_exit_bcol <= 0;
        temp_i_exit_brow <= 0;
        temp_i_bar_bcol <= 0;         
        temp_i_bar_brow <= 0;           
    end
    else begin
        temp_i_pix_valid <= i_pix_valid;
        temp_i_col <= i_col;
        temp_i_row <= i_row;
        temp_i_player_bcol <= i_player_bcol;
        temp_i_player_brow <= i_player_brow;
        temp_i_exit_bcol <= i_exit_bcol;
        temp_i_exit_brow <= i_exit_brow;
        temp_i_bar_bcol <= i_bar_bcol;       
        temp_i_bar_bcol <= i_bar_bcol;         
    end
end


endmodule
