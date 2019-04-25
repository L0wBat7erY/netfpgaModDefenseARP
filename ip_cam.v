/*******************************************************************************
 *
 *  NetFPGA-10G http://www.netfpga.org
 *
 *  File:
 *        mac_cam_lut.v
 *
 *  Library:
 *        /hw/std/pcores/nf10_switch_output_port_lookup_v1_10_a
 *
 *  Module:
 *        mac_cam_lut
 *
 *  Author:
 *        Gianni Antichi
 *
 *  Description:
 *        learning CAM switch core functionality
 *
 *  Copyright notice:
 *        Copyright (C) 2010, 2011 The Board of Trustees of The Leland Stanford
 *                                 Junior University
 *
 *  Licence:
 *        This file is part of the NetFPGA 10G development base package.
 *
 *        This file is free code: you can redistribute it and/or modify it under
 *        the terms of the GNU Lesser General Public License version 2.1 as
 *        published by the Free Software Foundation.
 *
 *        This package is distributed in the hope that it will be useful, but
 *        WITHOUT ANY WARRANTY; without even the implied warranty of
 *        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *        Lesser General Public License for more details.
 *
 *        You should have received a copy of the GNU Lesser General Public
 *        License along with the NetFPGA source package.  If not, see
 *        http://www.gnu.org/licenses/.
 *
 */


`timescale 1ns/1ps

module mac_cam_lut
    #(parameter NUM_OUTPUT_QUEUES = 8,
      parameter LUT_DEPTH_BITS = 4,
      parameter LUT_DEPTH = 2**LUT_DEPTH_BITS)


(
    input [47:0]                src_ip;
    input [47:0]                dst_ip;
    input [LUT_DEPTH-1:0]       opcode;
    input                       look_req;

    // --- lookup done signal
    output reg                  lookup_done,          // pulses high on lookup done
    output reg				    lut_miss,
    output reg				    lut_hit,

    // --- Misc
    input                       clk,
    input                       reset;

    output                      attack   
);



   function integer log2;
      input integer number;
      begin
         log2=0;
         while(2**log2<number) begin
            log2=log2+1;
         end
      end
   endfunction // log2

   
   //--------------------- Internal Parameter-------------------------
   localparam RESET            = 1;
   localparam IDLE             = 2;
   localparam LATCH_DST_LOOKUP = 4;

   //---------------------- Wires and regs----------------------------


    
   wire                                  cam_busy;
   wire                                  cam_match;
   wire [LUT_DEPTH_BITS-1:0]             cam_match_addr;
   reg  [47:0]                           cam_cmp_din;
    
   reg  [47:0]                           cam_din, cam_din_next;
   reg                                   cam_we, cam_we_next;
   reg  [LUT_DEPTH_BITS-1:0]             cam_wr_addr, cam_wr_addr_next;


   reg  [2:0]                            lookup_state, lookup_state_next;

   reg [LUT_DEPTH_BITS-1:0]              lut_rd_addr, lut_wr_addr, lut_wr_addr_next;
   reg                                   lut_wr_en, lut_wr_en_next;
   reg [NUM_OUTPUT_QUEUES+47:0]          lut_wr_data, lut_wr_data_next;
   reg [NUM_OUTPUT_QUEUES+47:0]          lut_rd_data;
   reg [NUM_OUTPUT_QUEUES+47:0]          lut[LUT_DEPTH-1:0];

   reg [47:0]                            src_ip_latched;
   reg [NUM_OUTPUT_QUEUES-1:0]           count;
   reg                                   attack;                          

   reg                                   reset_count_inc;
   reg [LUT_DEPTH_BITS:0]                reset_count;

   reg                                   lut_miss_next;
   reg    				                 lut_hit_next;
   reg					                 lookup_done_next;

   reg [LUT_DEPTH_BITS-1:0]		         pointer_add_cam, pointer_add_cam_next;


cam mac_cam
(
    (* box_type = "user_black_box" *)
      // Outputs
      .BUSY                             (cam_busy),
      .MATCH                            (cam_match),
      .MATCH_ADDR                       (cam_match_addr[LUT_DEPTH_BITS-1:0]),
      // Inputs
      .CLK                              (clk),
      .CMP_DIN                          (cam_cmp_din),
      .DIN                              (cam_din[47:0]),
      .WE                               (cam_we),
      .WR_ADDR                          (cam_wr_addr[LUT_DEPTH_BITS-1:0])
);


   //------------------------- Logic --------------------------------

   //


    always @(*) begin
      cam_wr_addr_next      = pointer_add_cam;
      cam_din_next          = src_ip_latched;
      cam_we_next           = 0;
      cam_cmp_din           = 0;

      //lut_rd_addr           = cam_match_addr;
      lut_wr_en_next        = 1'b0;
      //lut_wr_data_next      = {count, src_ip_latched}; 


      reset_count_inc       = 0;
      latch_src             = 0;
      lookup_done_next      = 0;
      lut_miss_next	        = 0;
      lut_hit_next	        = 0;
      pointer_add_cam_next  = pointer_add_cam;

      lookup_state_next = lookup_state;

    end



    always @(posedge clk) begin
    end