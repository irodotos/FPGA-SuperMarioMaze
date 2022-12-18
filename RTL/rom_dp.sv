/*******************************************************************************
 * CS220: Digital Circuit Lab
 * Computer Science Department
 * University of Crete
 * 
 * Date: 2019/10/01
 * Author: CS220 Instructors
 * Filename: rom_dp.sv
 * Description: This block generates configurable dual-ported ROM which is 
 *              pre-initialized with the contents of the given parameter file.
 *
 ******************************************************************************/

`timescale 1ns/1ps

module rom_dp #(
  parameter size  = 2048,
  parameter width = 16,
  parameter file  = "file.rom",
  parameter asize = $clog2(size)
)
(
  input clk,

  input en,
  input [asize-1:0] addr,
  output logic [width-1:0] dout,

  input en_b,
  input [asize-1:0] addr_b,
  output logic [width-1:0] dout_b
);


logic [width-1:0] rom_array [0 : (size-1)];

//PORT A
always_ff @(posedge clk) begin
  if ( en ) begin
    dout <= rom_array[addr];
  end
end

// PORT B
always_ff @(posedge clk) begin
  if ( en_b ) begin
    dout_b <= rom_array[addr_b];
  end
end

initial begin
  $readmemh(file, rom_array);
end

endmodule
