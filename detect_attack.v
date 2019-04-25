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

module detect_attack
    #(parameter NUM_OUTPUT_QUEUES = 8,
      parameter LUT_DEPTH_BITS = 4,
      parameter LUT_DEPTH = 2**LUT_DEPTH_BITS,
      parameter DEFAULT_MISS_OUTPUT_PORTS = 8'h55) // only send to the MAC txfifos not the cpu

   ( // --- core functionality signals
     
     input [47:0]                       src_mac_check,
     //input [47:0]                       src_mac_later,
     
     
     
  
     // --- lookup done signal
     output reg                         find_attack_hit,
     output reg                         find_attack_miss,          
    
       

     // --- Misc
     input                              clk,
     input                              reset

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
   //localparam RESET            = 1;
   //localparam IDLE             = 2;
   //localparam LATCH_DST_LOOKUP = 4;

   //---------------------- Wires and regs----------------------------

   wire                                  cam_match;
   wire [LUT_DEPTH_BITS-1:0]             cam_match_addr;
   reg [47:0]                            cam_din;

   /* wire [NUM_OUTPUT_QUEUES-1:0]          rd_oq;            // data read from the LUT at rd_addr
   wire [47:0]				 rd_mac;

   wire                                  cam_busy;
   wire                                  cam_match;
   wire [LUT_DEPTH_BITS-1:0]             cam_match_addr;
   reg  [47:0]                           cam_cmp_din;
    
   reg  [47:0]                           cam_din, cam_din_next;
   reg                                   cam_we, cam_we_next;
   reg  [LUT_DEPTH_BITS-1:0]             cam_wr_addr, cam_wr_addr_next;

   wire                                  cam_busy_learn;
   wire                                  cam_match_learn;
   wire [LUT_DEPTH_BITS-1:0]             cam_match_addr_learn;
   reg  [LUT_DEPTH_BITS-1:0]             cam_match_addr_learn_d1;
   reg  [47:0]                           cam_cmp_din_learn;

   reg  [47:0]                           cam_din_learn, cam_din_learn_next;
   reg                                   cam_we_learn, cam_we_learn_next;
   reg  [LUT_DEPTH_BITS-1:0]             cam_wr_addr_learn, cam_wr_addr_learn_next;


   reg  [NUM_OUTPUT_QUEUES-1:0]          src_port_latched;
   reg  [47:0]                           src_mac_latched;
   reg                                   latch_src;

   reg  [2:0]                            lookup_state, lookup_state_next;

   reg [LUT_DEPTH_BITS-1:0]              lut_rd_addr, lut_wr_addr, lut_wr_addr_next;
   reg                                   lut_wr_en, lut_wr_en_next;
   reg [NUM_OUTPUT_QUEUES+47:0]          lut_wr_data, lut_wr_data_next;
   reg [NUM_OUTPUT_QUEUES+47:0]          lut_rd_data;
   reg [NUM_OUTPUT_QUEUES+47:0]          lut[LUT_DEPTH-1:0];

   reg                                   reset_count_inc;
   reg [LUT_DEPTH_BITS:0]                reset_count;

   reg                                   lut_miss_next;
   reg    				 lut_hit_next;
   reg					 lookup_done_next;

   reg [LUT_DEPTH_BITS-1:0]		 pointer_add_cam, pointer_add_cam_next; */


   //------------------------- Modules-------------------------------

   // 1 cycle read latency, 2 cycles write latency, width=48, depth=16
   /* cam mac_cam
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
      .WR_ADDR                          (cam_wr_addr[LUT_DEPTH_BITS-1:0]));

   cam mac_cam_learn
     (
      (* box_type = "user_black_box" *)
      .BUSY                             (cam_busy_learn),
      .MATCH                            (cam_match_learn),
      .MATCH_ADDR                       (cam_match_addr_learn[LUT_DEPTH_BITS-1:0]),
      .CLK                              (clk),
      .CMP_DIN                          (cam_cmp_din_learn),
      .DIN                              (cam_din_learn[47:0]),
      .WE                               (cam_we_learn),
      .WR_ADDR                          (cam_wr_addr_learn[LUT_DEPTH_BITS-1:0])); */

   cam mac_cam
     (  
      (* box_type = "user_black_box" *)
      // Outputs
      //.BUSY                             (cam_busy),
      .MATCH                            (cam_match),
      .MATCH_ADDR                       (cam_match_addr[LUT_DEPTH_BITS-1:0]),
      // Inputs
      .CLK                              (clk),
      //.CMP_DIN                          (cam_cmp_din),
      .DIN                              (cam_din[47:0])
      //.WE                               (cam_we),
      //.WR_ADDR                          (cam_wr_addr[LUT_DEPTH_BITS-1:0]));
     );

   //------------------------- Logic --------------------------------


   /* assign lut outputs */
   //assign rd_oq = lut_rd_data[NUM_OUTPUT_QUEUES+47:48];
   //assign rd_mac = lut_rd_data[47:0];

   /* if we get a miss then set the dst port to the default ports
    * without the source */
   //assign dst_ports = (lut_miss) ? (DEFAULT_MISS_OUTPUT_PORTS & ~src_port_latched)
   //                                        : (rd_oq & ~src_port_latched);

   always @(*) begin
      cam_din_next = src_mac_check;
      if (cam_match) 
         find_attack_hit = 1;
      else find_attack_miss = 1;
   end



   always @(clk) begin
      if (reset) begin
         find_attack_hit <= 0;
         find_attack_miss <= 0;
      end
      else begin
         cam_din <= cam_din_next;
      end
   end


endmodule // mac_lut

