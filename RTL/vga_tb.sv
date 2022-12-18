/*******************************************************************************
 * CS220: Digital Circuit Lab
 * Computer Science Department
 * University of Crete
 * 
 * Date: 2019/10/01
 * Author: CS220 Instructors
 * Filename: vga_tb.sv
 * Description: A testbench that generates clock and reset and 
 *              captures VGA output in VGA Simulator format
 *
 ******************************************************************************/

`timescale 1ns/1ps

// Only for Icarus Verilog
//`define VCD_WAVES

// 40 ns -> 25 MHz
`define VGA_CLK_PERIOD  40
`define SIM_CYCLES      400000
`define MOVE_CYCLES     2000

module vga_tb;

integer fileout;

logic clk;
logic rst;

always #(`VGA_CLK_PERIOD/2) clk = ~clk;

logic hsync;
logic vsync;
logic [3:0] red;
logic [3:0] green;
logic [3:0] blue;
logic up,down,left,right,control;

vga_maze_top vga0 (
  .clk (clk),
  .rst (rst),
  .i_control(control),
  .i_up(up),
  .i_down(down),
  .i_left(left),
  .i_right(right),
  .o_leds(),
  .o_hsync (hsync),
  .o_vsync (vsync),
  .o_red (red),
  .o_green (green),
  .o_blue (blue)
);


localparam BTN_UP      = 1;
localparam BTN_DOWN    = 2;
localparam BTN_LEFT    = 3;
localparam BTN_RIGHT   = 4;
localparam BTN_CONTROL = 5;

task push_button;
  input integer button;
  input integer up_time;
  input integer down_time;
  input integer times;
  integer i;
  begin
    for (i=0; i<times ; i=i+1) begin
      case(button)
        BTN_UP:      up = 1;
        BTN_DOWN:    down = 1;
        BTN_LEFT:    left = 1;
        BTN_RIGHT:   right = 1;
        BTN_CONTROL: control = 1;
      endcase
      repeat(up_time) @(posedge clk);
      case(button)
        BTN_UP:      up = 0;
        BTN_DOWN:    down = 0;
        BTN_LEFT:    left = 0;
        BTN_RIGHT:   right = 0;
        BTN_CONTROL: control = 0;
      endcase
      repeat(down_time) @(posedge clk);
    end
  end
endtask

// clk and reset
initial begin
  fileout = $fopen("vga_log.txt");

  $timeformat(-9, 0, " ns", 6);

`ifdef VCD_WAVES
  $dumpfile("vga_tb_waves.vcd");
  $dumpvars;
`endif

  up = 0;
  down = 0;
  left = 0;
  right = 0;
  control = 0;

  clk = 0;
  rst = 1;
  @(posedge clk);
  @(posedge clk);
  @(posedge clk);
  #1;
  rst = 0;
  @(posedge clk);


  repeat (`MOVE_CYCLES) @(posedge clk);
  push_button(BTN_CONTROL,10,5,20);
  repeat (`MOVE_CYCLES) @(posedge clk);
  push_button(BTN_CONTROL,10,5,20);
  repeat (`MOVE_CYCLES) @(posedge clk);
  push_button(BTN_CONTROL,10,5,20);
  repeat (`MOVE_CYCLES) @(posedge clk);
  push_button(BTN_UP,10,5,20);
  repeat (`MOVE_CYCLES) @(posedge clk);
  push_button(BTN_UP,10,5,20);
  repeat (`MOVE_CYCLES) @(posedge clk);
  push_button(BTN_DOWN,10,5,20);
  repeat (`MOVE_CYCLES) @(posedge clk);
  push_button(BTN_LEFT,10,5,20);

//  repeat (`MOVE_CYCLES) @(posedge clk);
//  push_button(BTN_CONTROL,10,5,20);
//  repeat (`MOVE_CYCLES) @(posedge clk);
//  push_button(BTN_CONTROL,10,5,20);
//  repeat (`MOVE_CYCLES) @(posedge clk);
//  push_button(BTN_CONTROL,10,5,20);
//  repeat (`MOVE_CYCLES) @(posedge clk);
//  push_button(BTN_CONTROL,10,5,20);
//  repeat (`MOVE_CYCLES) @(posedge clk);
//  push_button(BTN_CONTROL,10,5,20);

  wait (vsync == 0);
  repeat (`SIM_CYCLES/2) @(posedge clk);

  repeat (30) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_RIGHT,10,5,20);
  end

  repeat (5) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_DOWN,10,5,20);
  end

  repeat (5) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_LEFT,10,5,20);
  end

  repeat (5) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_DOWN,10,5,20);
  end

  repeat (10) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_RIGHT,10,5,20);
  end

  repeat (5) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_UP,10,5,20);
  end

  repeat (5) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_LEFT,10,5,20);
  end

  repeat (5) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_UP,10,5,20);
  end

  repeat (15) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_RIGHT,10,5,20);
  end

  repeat (5) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_DOWN,10,5,20);
  end

  repeat (5) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_LEFT,10,5,20);
  end

  repeat (10) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_DOWN,10,5,20);
  end

  repeat (5) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_LEFT,10,5,20);
  end

  repeat (5) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_DOWN,10,5,20);
  end

  repeat (5) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_LEFT,10,5,20);
  end

  repeat (5) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_DOWN,10,5,20);
  end

  repeat (5) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_RIGHT,10,5,20);
  end

  repeat (5) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_UP,10,5,20);
  end

  repeat (5) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_RIGHT,10,5,20);
  end

  repeat (5) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_DOWN,10,5,20);
  end

  repeat (5) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_RIGHT,10,5,20);
  end

  repeat (8) begin
    repeat (`MOVE_CYCLES) @(posedge clk);
    push_button(BTN_DOWN,10,5,20);
  end

  wait (vsync == 0);

  repeat (`MOVE_CYCLES) @(posedge clk);
  push_button(BTN_DOWN,10,5,20);

  repeat (`SIM_CYCLES/2) @(posedge clk);
  wait (vsync == 0);

  repeat (`MOVE_CYCLES) @(posedge clk);
  push_button(BTN_CONTROL,10,5,20);
  repeat (`MOVE_CYCLES) @(posedge clk);
  push_button(BTN_DOWN,10,5,20);

  repeat (`SIM_CYCLES/2) @(posedge clk);
  wait (vsync == 0);

  repeat (`SIM_CYCLES/2) @(posedge clk);
  #1;

  $fclose(fileout);
  $finish;
end

always @(posedge clk) begin
  if ( ~rst ) begin
    $fdisplay(fileout, "%t: %b %b %b %b %b", $time, hsync, vsync, red, green, blue);
  end
end

endmodule
