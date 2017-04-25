# CapSense_IP_Core
Capacitive buttons IP core

This core was designed for the Kéfir I board that uses capacitive buttons similars to the ones found
in the iCE40 Blink kit.

You can configure 2 to 8 buttons (the above mentioned boards have 4).

VHDL and Verilog implementations are available. Both versions works with iCECube 2 and the Verilog
implementation also works with IceStorm tools.

The CapSense entity/module contains the sampling FSM and CapSense_Sys also includes the polling and
sampling timing.

For Kéfir I board I got good results using a sampling frequency of 1.5 MHz and a polling period of
87 ms. Note that CapSense_Sys generates both just providing the clock frequency (in MHz).

The DIRECT generic/parameter of CapSense_Sys selects if you get a '1' when a button is pressed or if
the buttons toggle its value every time you touch them.

Also note that buttons uses I/O pins. In the Verilog version you have capsense_i lines, used to read
the buttons, and capsense_oe used to discharge the buttons. Both signals are used for the same I/O pin.
They are separated because IceStorm doesn't handle tri-states properly.

A VHDL example is included in FPGA/kefir_capsense (for iCECube2)

A Verilog example is included in FPGA/kefir_capsense_v (for iCECube2 and IceStorm)

