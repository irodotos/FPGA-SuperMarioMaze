/*******************************************************************************
 * CS220: Digital Circuit Lab
 * Computer Science Department
 * University of Crete
 * 
 * Date: 2019/XX/XX
 * Author: Your name here
 * Filename: maze_controller.sv
 * Description: Your description here
 *
 ******************************************************************************/

`timescale 1ns/1ps

module maze_controller(
  input clk,
  input rst,

  input  i_control,
  input  i_up,
  input  i_down,
  input  i_left,
  input  i_right,

  output logic        o_rom_en,
  output logic [10:0] o_rom_addr,
  input  logic [15:0] i_rom_data,

  output logic [5:0] o_player_bcol,
  output logic [5:0] o_player_brow,

  input  logic [5:0] i_exit_bcol,
  input  logic [5:0] i_exit_brow,

  output logic [7:0] o_leds
);

// Implement your code here

logic [1:0] start_cnt;
logic [2:0] end_cnt;
logic [5:0] new_bcol, new_brow;
logic [5:0] tmp_col , tmp_row;
logic move_valid;
logic start_condition;
logic end_condition;
logic reach_exit;


typedef enum logic[3:0] {IDLE, PLAY, UP, DOWN, LEFT, RIGHT, READROM, CHECK, UPDATE, END_state}state;

state currentState, nextState;

always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        currentState <= IDLE;
        new_bcol <= 1;
        new_brow <= 0;
        o_player_bcol <= 1;
        o_player_brow <= 0;
    end
    else begin
        currentState <= nextState;
        new_bcol <= tmp_col;
        new_brow <= tmp_row;
        if(move_valid && currentState==UPDATE || currentState == IDLE) begin
            o_player_brow  <= new_brow;
            o_player_bcol <= new_bcol;
        end
    end
end 


always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        start_cnt <= 0;
        end_cnt <= 0;
    end
    else begin 
        if (i_control) begin
            start_cnt <= start_cnt + 1;
            end_cnt <= end_cnt + 1;
        end
        else if(i_up || i_down || i_left || i_right) begin
            start_cnt <= 0;
            end_cnt <= 0;
        end
        else begin
            start_cnt <= start_cnt;
            end_cnt <= end_cnt;
        end
    end
end

always_comb begin
    start_condition = (start_cnt == 3) ;
    move_valid = (i_rom_data != 0) ;
    reach_exit = (o_player_bcol == i_exit_bcol && o_player_brow == i_exit_brow) ;
    end_condition = (end_cnt == 5) ;
    o_rom_addr = {new_bcol , new_brow[4:0] };  
end


always_comb begin
    nextState = currentState;
    o_rom_en = 0;
    o_leds = 0;
    tmp_row = new_brow;     // prin itan temp_row = 0 kai den mporouse na kinithi  pextis 
    tmp_col = new_bcol;      // prin itan temp_col = 1 kai den mporouse na kinithi  pextis 
    case ( currentState )
        IDLE: begin
            if(end_condition) begin
                tmp_col = 1;
                tmp_row = 0;
                nextState = IDLE;
            end
            else begin
                o_leds = 1;
//                o_player_bcol = new_bcol;
//                o_player_brow = new_brow;
                if( start_condition ) begin
                    nextState = PLAY;
                end
                else begin
                    nextState = IDLE;
                end
            end
        end
        PLAY: begin
            o_leds = 2;
            if( reach_exit ) begin
                nextState = END_state;
            end
            else  if(end_condition) begin
                tmp_col = 1;
                tmp_row = 0;
                nextState = IDLE;
            end
            else begin
                 if( i_up ) begin
                    nextState = UP;
                end
                else if ( i_down ) begin
                    nextState = DOWN;
                end
                else if ( i_left ) begin
                    nextState = LEFT;
                end
                else if ( i_right ) begin
                    nextState = RIGHT;
                end
                else 
                    nextState = PLAY;
            end
                
        end
        UP: begin
             if(end_condition) begin
                tmp_col = 1;
                tmp_row = 0;
                nextState = IDLE;
            end
            else begin
                o_leds = 3;
                tmp_row = o_player_brow - 1;
                tmp_col = o_player_bcol;
                nextState = READROM;
            end
        end
        DOWN: begin
             if(end_condition) begin
                tmp_col = 1;
                tmp_row = 0;
                nextState = IDLE;
            end
            else begin
                o_leds = 4; 
                tmp_row = o_player_brow + 1;
                tmp_col = o_player_bcol; 
                nextState = READROM;
            end
        end
        LEFT: begin
             if(end_condition) begin
                tmp_col = 1;
                tmp_row = 0;
                nextState = IDLE;
            end
            else begin
                o_leds = 5;
                tmp_row = o_player_brow;
                tmp_col = o_player_bcol-1;
                nextState = READROM;
            end
        end
        RIGHT: begin
         if(end_condition) begin
                tmp_col = 1;
                tmp_row = 0;
                nextState = IDLE;
            end
            else begin
                o_leds = 6;
                tmp_row = o_player_brow;
                tmp_col = o_player_bcol+1;
                nextState = READROM;
            end
        end
        READROM: begin
            o_leds = 7;
            if(new_brow < 0 || new_bcol < 0 || new_brow > 29 || new_bcol > 39) begin  //xriazete epd ginontan i row 3F=-1 sto proto up
                tmp_col = o_player_bcol;
                tmp_row = o_player_brow;
                nextState = PLAY;
            end 
            else  if(end_condition) begin
                tmp_col = 1;
                tmp_row = 0;
                nextState = IDLE;
            end  
            else begin 
                o_rom_en = 1;
                nextState = CHECK;       
            end
        end
        CHECK: begin
            o_leds = 8; 
             if(end_condition) begin
                tmp_col = 1;
                tmp_row = 0;
                nextState = IDLE;
            end
            else begin
                if(move_valid) begin
                    nextState = UPDATE;
                end
                else begin
                    tmp_col = o_player_bcol;
                   tmp_row = o_player_brow;
                   nextState = PLAY;
                end
            end
        end
        UPDATE: begin
            o_leds = 9;
             if(end_condition) begin
                tmp_col = 1;
                tmp_row = 0;
                nextState = IDLE;
            end
            else begin
                nextState = PLAY;
            end
        end
        END_state: begin
            o_leds = 10;
             if(end_condition) begin
                tmp_col = 1;
                tmp_row = 0;
                nextState = IDLE;
            end
            else begin
                if( i_control ) begin
                    tmp_col = 1;
                    tmp_row = 0;
                    nextState = IDLE;
                end
                else begin
                    nextState = END_state;
                end
            end
        end
        default: begin
            nextState = IDLE;
        end        
    endcase
end

endmodule