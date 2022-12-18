/*******************************************************************************
 * CS220: Digital Circuit Lab
 * Computer Science Department
 * University of Crete
 * 
 * Date: 2019/XX/XX
 * Author: Your name here
 * Filename: vga_sync.sv
 * Description: Implements VGA HSYNC and VSYNC timings for 640 x 480 @ 60Hz
 *
 ******************************************************************************/

`timescale 1ns/1ps

module vga_sync(
  input logic clk,
  input logic rst,

  output logic o_pix_valid,
  output logic [9:0] o_col,
  output logic [9:0] o_row,

  output logic o_hsync,
  output logic o_vsync
);

parameter FRAME_HPIXELS           = 640;
parameter FRAME_HFPORCH           = 16;
parameter FRAME_HSPULSE           = 96;
parameter FRAME_HBPORCH           = 48;
parameter FRAME_MAX_HCOUNT        = 800;

parameter FRAME_VLINES            = 480;
parameter FRAME_VFPORCH           = 10;
parameter FRAME_VSPULSE           = 2;
parameter FRAME_VBPORCH           = 29;
parameter FRAME_MAX_VCOUNT        = 521;
/* the logic of horizontal syncronization */
/* =======  START HERE  ===========    */

logic[9:0] hcnt;
logic hcnt_clr;
logic hs_set;
logic hs_clr;
logic hsync;
logic hsync_with_delay;

/* hcnt register */
always_ff @(posedge clk or posedge rst) begin
    if(rst == 1) begin
        hcnt <= 0;
    end
    else if(hcnt_clr == 1) begin
        hcnt <= 0;
    end
    else begin
        hcnt <= hcnt + 1;
    end
end

/* the logic of hcnt_clr that make register hcnt = 0 */
always_comb begin
    hcnt_clr = ( hcnt == (FRAME_MAX_HCOUNT-1) );
    hs_set = (hcnt == (FRAME_HPIXELS + FRAME_HFPORCH - 1) );
    hs_clr = (hcnt == (FRAME_HPIXELS + FRAME_HFPORCH + FRAME_HSPULSE - 1) );
end

assign o_col = hcnt;  /* anathesi tis eksodou o_col */

/* hsync register */
always_ff @(posedge clk or posedge rst) begin
    if(rst == 1) begin
        hsync <= 0;
    end
    else begin
        hsync <= ( ~hs_clr & (hs_set || hsync) );
    end
end

/* hsync_with_delay register */
always_ff @(posedge clk or posedge rst) begin
    if(rst == 1) begin
        hsync_with_delay <= 0;
    end
    else begin
        hsync_with_delay <= hsync;
    end
end

assign o_hsync = ~hsync_with_delay;  /* anathesi tis eksodou o_hsync*/

/* the logic of horizontal syncronization */
/* ======== END HERE  =============       */


/* the logic of vertical syncronization  */
/* ======== START HERE ============      */

logic[9:0] vcnt;
logic vcnt_clear;
logic vs_set;
logic vs_clr;
logic vsync;

/* vcnt register */
always_ff @(posedge clk or posedge rst) begin
    if(rst == 1) begin
        vcnt <= 0;
    end
    else begin
        if(vcnt_clear == 1) begin
            vcnt <= 0;
        end
        else begin
            if(hcnt_clr == 1) begin
                vcnt <= vcnt + 1;
            end
            else begin
                vcnt <= vcnt;
            end
        end
    end
end 

/* the logic of vcnt_clear that make vcnt = 0 */
always_comb begin
    vcnt_clear = ( (vcnt == FRAME_MAX_VCOUNT - 1) & (hcnt_clr == 1) );
    vs_set = ( (vcnt == (FRAME_VLINES + FRAME_VFPORCH -1)) & hcnt_clr );
    vs_clr = ( (vcnt == (FRAME_VLINES + FRAME_VFPORCH + FRAME_VSPULSE -1)) & hcnt_clr );
     
end

assign o_row = vcnt ; /* anathesi tis eksodou o_row */

/* vsync register */
always_ff @(posedge clk or posedge rst) begin
    if(rst == 1) begin
        vsync <= 0;
    end
    else begin
        vsync <= ((vs_set || vsync) & ~vs_clr );
    end
end

assign o_vsync = ~vsync; /* anathesi tis eksodou o_vsync */

/* the logic of vertical syncronization  */
/* ========= END HERE ===========   */

/* the logic of valid pixel */
/* =====  START HERE ======= */

logic pix_valid;

always_comb begin
    if( (hcnt < FRAME_HPIXELS) & (vcnt < FRAME_VLINES) ) begin
        pix_valid = 1;
    end
    else begin
        pix_valid = 0;
    end
end 

assign o_pix_valid = pix_valid;

/* the logic of valid pixel  */
/* ===== END HERE ======== */

endmodule
