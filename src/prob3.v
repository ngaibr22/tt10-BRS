/*
 * uo_outopyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_BRS_3 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    assign A = ui_in;
    assign B = uio_in;
    // Conditional bitwise XOR/AND logic
    assign uo_out[0] = (A[7] == 0) ? (A[0] ^ B[0]) : (A[0] & B[0]);
    assign uo_out[1] = (A[7] == 0) ? (A[1] ^ B[1]) : (A[1] & B[1]);
    assign uo_out[2] = (A[7] == 0) ? (A[2] ^ B[2]) : (A[2] & B[2]);
    assign uo_out[3] = (A[7] == 0) ? (A[3] ^ B[3]) : (A[3] & B[3]);
    assign uo_out[4] = (A[7] == 0) ? (A[4] ^ B[4]) : (A[4] & B[4]);
    assign uo_out[5] = (A[7] == 0) ? (A[5] ^ B[5]) : (A[5] & B[5]);
    assign uo_out[6] = (A[7] == 0) ? (A[6] ^ B[6]) : (A[6] & B[6]);
    assign uo_out[7] = (A[7] == 0) ? (A[7] ^ B[7]) : (A[7] & B[7]);
    
  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
