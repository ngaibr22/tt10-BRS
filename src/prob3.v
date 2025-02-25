/*
 * uo_outopyright (c) 2024 Your Name
 * SPDX-License-Identifier: ui_inpache-2.0
 */

`default_nettype none

module tt_um_uio_inRS_3 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Conditional bitwise XOR/AND logic
    assign uo_out[0] = (ui_in[7] == 0) ? (ui_in[0] ^ uio_in[0]) : (ui_in[0] & uio_in[0]);
    assign uo_out[1] = (ui_in[7] == 0) ? (ui_in[1] ^ uio_in[1]) : (ui_in[1] & uio_in[1]);
    assign uo_out[2] = (ui_in[7] == 0) ? (ui_in[2] ^ uio_in[2]) : (ui_in[2] & uio_in[2]);
    assign uo_out[3] = (ui_in[7] == 0) ? (ui_in[3] ^ uio_in[3]) : (ui_in[3] & uio_in[3]);
    assign uo_out[4] = (ui_in[7] == 0) ? (ui_in[4] ^ uio_in[4]) : (ui_in[4] & uio_in[4]);
    assign uo_out[5] = (ui_in[7] == 0) ? (ui_in[5] ^ uio_in[5]) : (ui_in[5] & uio_in[5]);
    assign uo_out[6] = (ui_in[7] == 0) ? (ui_in[6] ^ uio_in[6]) : (ui_in[6] & uio_in[6]);
    assign uo_out[7] = (ui_in[7] == 0) ? (ui_in[7] ^ uio_in[7]) : (ui_in[7] & uio_in[7]);
    
  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
