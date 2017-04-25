module Kefir_Capsense(
   input  CLK,
   inout  BTN1, BTN2, BTN3, BTN4,
   output LED1, LED2, LED3, LED4,
   output ARDU00, ARDU01, ARDU02, ARDU03,
   output SS_B);

localparam DIRECT=1; // Direct status, else: toggle
localparam EXPLICIT_TBUF=1; // Manually instantiate tri-state buffers

assign SS_B=1; // Disable the SPI memory

wire capsense_oe;
wire [3:0] capsense_in;

CapSense_Sys #(.N(4), .DIRECT(DIRECT), .FREQUENCY(24)) CS
  (.clk_i(CLK), .rst_i(1'b0),
   .capsense_i(capsense_in),
   .capsense_oe(capsense_oe),
   .buttons_o({LED1,LED2,LED3,LED4}),
   .debug_o({ARDU00, ARDU01, ARDU02, ARDU03}));

generate if (EXPLICIT_TBUF)
begin
  SB_IO #(
      .PIN_TYPE(6'b1010_01),
      .PULLUP(1'b0)
  ) buts [3:0] (
      .PACKAGE_PIN({BTN1,BTN2,BTN3,BTN4}),
      .OUTPUT_ENABLE(capsense_oe),
      .D_OUT_0(4'b0),
      .D_IN_0(capsense_in)
  );
end
else
begin
  assign {BTN1,BTN2,BTN3,BTN4}=capsense_oe ? 4'b0 : 4'bZ;
  assign capsense_in={BTN1,BTN2,BTN3,BTN4};
end endgenerate

endmodule

