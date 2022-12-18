/*******************************************************************************
 * CS220: Digital Circuit Lab
 * Computer Science Department
 * University of Crete
 * 
 * Date: 2019/10/01
 * Author: CS220 Instructors
 * Filename: rom.sv
 * Description: This block generates a configurable ROM which is pre-initialized
 *              with the contents of the given parameter file.
 *
 ******************************************************************************/

`timescale 1ns/1ps

module rom #(
  parameter size  = 2048,
  parameter width = 16,
  parameter file  = "file.rom",
  parameter asize = $clog2(size)
)
(
  input clk,
  input en,
  input [asize-1:0] addr,
  output logic [width-1:0] dout
);


logic [width-1:0] rom_array [0 : (size-1)];

always_ff @(posedge clk) begin
  if ( en ) begin
    dout <= rom_array[addr];
  end
end

initial begin
  $readmemh(file, rom_array);
end

endmodule
