/*******************************************************************************
 * CS220: Digital Circuit Lab
 * Computer Science Department
 * University of Crete
 * 
 * Date: 2019/10/01
 * Author: CS220 Instructors
 * Filename: debouncer.sv
 * Description: This block is a button debouncer
 *
 ******************************************************************************/

`timescale 1ns/1ps

// Only for Icarus Verilog
//`define XILINX_SIMULATOR

module debouncer #(
  parameter pressed_value = 1,
`ifdef XILINX_SIMULATOR
  parameter cycles        = 1000,
`else
  parameter cycles        = 25000000,
`endif
  parameter cbits         = $clog2(cycles)
)
(
  input        clk,
  input        rst,
  input        i_button,
  output logic o_pulse
);

logic [cbits-1:0] counter;

always_ff @(posedge clk) begin
  if ( rst ) begin
    counter <= 0;
    o_pulse <= 0;
  end
  else begin
    if ( (counter == 0) && (i_button == pressed_value) ) begin
      counter <= counter + 1;
    end
    else if ( counter == (cycles-1) ) begin
      counter <= 0;
    end
    else if ( counter != 0 ) begin
      counter <= counter + 1;
    end

    o_pulse <= (counter == 1);
  end
end

endmodule
