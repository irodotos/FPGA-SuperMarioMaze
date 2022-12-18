/*******************************************************************************
 * CS220: Digital Circuit Lab
 * Computer Science Department
 * University of Crete
 * 
 * Date: 2017/10/30
 * Author: CS220 Instructors
 * Filename: vga_maze_top.v
 * Description: The top module that instantiates vga_sync and vga_frame etc
 *
 ******************************************************************************/

`timescale 1ns/1ps

module vga_maze_top(
  input clk,
  input rst,

  input  i_control,
  input  i_up,
  input  i_down,
  input  i_left,
  input  i_right,
  output logic [7:0] o_leds,

  output logic o_hsync,
  output logic o_vsync,
  output logic [3:0] o_red,
  output logic [3:0] o_green,
  output logic [3:0] o_blue
);

// BUTTON DEBOUNCERS
logic control, up,down,left,right;
debouncer control_dbnc (
  .clk(clk),
  .rst(rst),
  .i_button(i_control),
  .o_pulse(control)
);
debouncer up_dbnc (
  .clk(clk),
  .rst(rst),
  .i_button(i_up),
  .o_pulse(up)
);
debouncer down_dbnc (
  .clk(clk),
  .rst(rst),
  .i_button(i_down),
  .o_pulse(down)
);
debouncer left_dbnc (
  .clk(clk),
  .rst(rst),
  .i_button(i_left),
  .o_pulse(left)
);
debouncer right_dbnc (
  .clk(clk),
  .rst(rst),
  .i_button(i_right),
  .o_pulse(right)
);

logic pixel_valid;
logic [9:0] col;
logic [9:0] row;

vga_sync vs (
  .clk(clk),
  .rst(rst),

  .o_pix_valid(pixel_valid),
  .o_col(col),
  .o_row(row),

  .o_hsync(o_hsync),
  .o_vsync(o_vsync)
);


logic rom_en;
logic [10:0] rom_addr;
logic [15:0] rom_data;

logic [5:0] p_bcol;
logic [5:0] p_brow;

logic [5:0] e_bcol = 6'd37;
logic [5:0] e_brow = 6'd22;

logic [5:0] bar_bcol ;
logic [5:0] bar_brow = 6'd29;

vga_frame vf (
  .clk(clk),
  .rst(rst),

  .i_rom_en(rom_en),
  .i_rom_addr(rom_addr),
  .o_rom_data(rom_data),

  .i_pix_valid(pixel_valid),
  .i_col(col),
  .i_row(row),

  .i_player_bcol(p_bcol),
  .i_player_brow(p_brow),
  .i_exit_bcol(e_bcol),
  .i_exit_brow(e_brow),
  .i_bar_bcol(bar_bcol),
  .i_bar_brow(bar_brow),

  .o_red(o_red),
  .o_green(o_green),
  .o_blue(o_blue)
);

maze_controller vc (
  .clk(clk),
  .rst(rst),

  .i_control(control),
  .i_up(up),
  .i_down(down),
  .i_left(left),
  .i_right(right),

  .o_rom_en(rom_en),
  .o_rom_addr(rom_addr),
  .i_rom_data(rom_data),

  .o_player_bcol(p_bcol),
  .o_player_brow(p_brow),

  .i_exit_bcol(e_bcol),
  .i_exit_brow(e_brow),

  .o_leds(o_leds)
);

endmodule
