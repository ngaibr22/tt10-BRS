default_nettype none

module tt_um_BRS_2 (
    input  wire [7:0] ui_in,   
    output wire [7:0] uo_out, 
    input  wire [7:0] uio_in, 
    output wire [7:0] uio_out,  
    output wire [7:0] uio_oe,  
    input  wire       ena,      
    input  wire       clk,   
    input  wire       rst_n   
);

    wire [15:0] In = { ui_in, uio_in };

    reg [7:0] C;

    assign uo_out = C;

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    always @* begin
        if (In == 16'b0) begin
            C = 8'hF0;
        end
        else begin
            casez (In)
                16'b1???????????????: C = 8'd15;
                16'b01??????????????: C = 8'd14;
                16'b001?????????????: C = 8'd13;
                16'b0001????????????: C = 8'd12;
                16'b00001???????????: C = 8'd11;
                16'b000001??????????: C = 8'd10;
                16'b0000001?????????: C = 8'd9;
                16'b00000001????????: C = 8'd8;
                16'b000000001???????: C = 8'd7;
                16'b0000000001??????: C = 8'd6;
                16'b00000000001?????: C = 8'd5;
                16'b000000000001????: C = 8'd4;
                16'b0000000000001???: C = 8'd3;
                16'b00000000000001??: C = 8'd2;
                16'b000000000000001?: C = 8'd1;
                16'b0000000000000001: C = 8'd0;
                default:             C = 8'hF0; 
            endcase
        end
    end
endmodule

