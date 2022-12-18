################################################################################
# CS220: Digital Circuits Lab
# Computer Science Department
# University of Crete
# 
# Date: 2019/10/01
# Author: CS220 Instructors
# Filename: lab3.xdc
# Description: Xilinx Design Constraint file for Lab 3 
#
################################################################################

create_clock -name clk -period 10 [get_ports clk]
set_property PACKAGE_PIN Y9 [get_ports {clk}];   # "GCLK"
set_property PACKAGE_PIN F22 [get_ports {rst}];  # "SW0"

# ----------------------------------------------------------------------------
# User Push Buttons - Bank 34
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN P16 [get_ports {i_control}];  # "BTNC"
set_property PACKAGE_PIN T18 [get_ports {i_up}];       # "BTNU"
set_property PACKAGE_PIN R16 [get_ports {i_down}];     # "BTND"
set_property PACKAGE_PIN N15 [get_ports {i_left}];     # "BTNL"
set_property PACKAGE_PIN R18 [get_ports {i_right}];    # "BTNR"

# ----------------------------------------------------------------------------
# User LEDS - Bank 33
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN T22 [get_ports {o_leds[0]}];  # "LD0"
set_property PACKAGE_PIN T21 [get_ports {o_leds[1]}];  # "LD1"
set_property PACKAGE_PIN U22 [get_ports {o_leds[2]}];  # "LD2"
set_property PACKAGE_PIN U21 [get_ports {o_leds[3]}];  # "LD3"
set_property PACKAGE_PIN V22 [get_ports {o_leds[4]}];  # "LD4"
set_property PACKAGE_PIN W22 [get_ports {o_leds[5]}];  # "LD5"
set_property PACKAGE_PIN U19 [get_ports {o_leds[6]}];  # "LD6"
set_property PACKAGE_PIN U14 [get_ports {o_leds[7]}];  # "LD7"

# ----------------------------------------------------------------------------
# VGA Output - Bank 33
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN AA19 [get_ports {o_hsync}];  # "VGA-HS"
set_property PACKAGE_PIN Y19  [get_ports {o_vsync}];  # "VGA-VS"

set_property PACKAGE_PIN V20  [get_ports {o_red[0]}];    # "VGA-R1"
set_property PACKAGE_PIN U20  [get_ports {o_red[1]}];    # "VGA-R2"
set_property PACKAGE_PIN V19  [get_ports {o_red[2]}];    # "VGA-R3"
set_property PACKAGE_PIN V18  [get_ports {o_red[3]}];    # "VGA-R4"
set_property PACKAGE_PIN AB22 [get_ports {o_green[0]}];  # "VGA-G1"
set_property PACKAGE_PIN AA22 [get_ports {o_green[1]}];  # "VGA-G2"
set_property PACKAGE_PIN AB21 [get_ports {o_green[2]}];  # "VGA-G3"
set_property PACKAGE_PIN AA21 [get_ports {o_green[3]}];  # "VGA-G4"
set_property PACKAGE_PIN Y21  [get_ports {o_blue[0]}];   # "VGA-B1"
set_property PACKAGE_PIN Y20  [get_ports {o_blue[1]}];   # "VGA-B2"
set_property PACKAGE_PIN AB20 [get_ports {o_blue[2]}];   # "VGA-B3"
set_property PACKAGE_PIN AB19 [get_ports {o_blue[3]}];   # "VGA-B4"


# Note that the bank voltage for IO Bank 33 is fixed to 3.3V on ZedBoard. 
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]];

# Set the bank voltage for IO Bank 34 to 1.8V by default.
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]];

# Set the bank voltage for IO Bank 35 to 1.8V by default.
set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 35]];

# Note that the bank voltage for IO Bank 13 is fixed to 3.3V on ZedBoard. 
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];
