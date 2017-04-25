------------------------------------------------------------------------------
----                                                                      ----
----  Kéfir I Capsense example                                            ----
----                                                                      ----
----  This file is part FPGA Libre project http://fpgalibre.sf.net/       ----
----                                                                      ----
----  Description:                                                        ----
----  This is an example of how to use the Kéfir I capacitive buttons.    ----
----                                                                      ----
----  To Do:                                                              ----
----  -                                                                   ----
----                                                                      ----
----  Author:                                                             ----
----    - Salvador E. Tropea, salvador en inti.gob.ar                     ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Copyright (c) 2016 Salvador E. Tropea <salvador en inti.gob.ar>      ----
---- Copyright (c) 2016 Instituto Nacional de Tecnología Industrial       ----
----                                                                      ----
---- This file can be distributed under the terms of the GPL 2.0 license  ----
---- or newer.                                                            ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Design unit:      Kefir_Capsense(TopLevel) (Entity and architecture) ----
---- File name:        kefir_capsense.vhdl                                ----
---- Note:             None                                               ----
---- Limitations:      None known                                         ----
---- Errors:           None known                                         ----
---- Library:          None                                               ----
---- Dependencies:     IEEE.std_logic_1164                                ----
----                   CapSense.Devices                                   ----
---- Target FPGA:      iCE40HX4K-TQ144                                    ----
---- Language:         VHDL                                               ----
---- Wishbone:         None                                               ----
---- Synthesis tools:  iCEcube2 2016.02                                   ----
---- Simulation tools: GHDL [Sokcho edition] (0.2x)                       ----
---- Text editor:      SETEdit 0.5.x                                      ----
----                                                                      ----
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

library CapSense;
use CapSense.Devices.all;

entity Kefir_Capsense is
   port(
      CLK    : in    std_logic;
      BTN1   : inout std_logic;
      BTN2   : inout std_logic;
      BTN3   : inout std_logic;
      BTN4   : inout std_logic;
      LED1   : out   std_logic;
      LED2   : out   std_logic;
      LED3   : out   std_logic;
      LED4   : out   std_logic;
      ARDU00 : out   std_logic;
      ARDU01 : out   std_logic;
      ARDU02 : out   std_logic;
      ARDU03 : out   std_logic;
      SS_B   : out   std_logic);
end entity Kefir_Capsense;

architecture TopLevel of Kefir_Capsense is
   constant DIRECT : boolean:=true; -- Direct status, else: toggle
begin
   SS_B <= '1'; -- Disable the SPI memory

   CS : entity work.CapSense_Sys
      generic map (N => 4, FREQUENCY => 24, DIRECT => DIRECT)
      port map(
         clk_i => CLK,
         rst_i => '0',
         capsense_io(0) => BTN1,
         capsense_io(1) => BTN2,
         capsense_io(2) => BTN3,
         capsense_io(3) => BTN4,
         buttons_o(0) => LED1,
         buttons_o(1) => LED2,
         buttons_o(2) => LED3,
         buttons_o(3) => LED4,
         debug_o(0) => ARDU00,
         debug_o(1) => ARDU01,
         debug_o(2) => ARDU02,
         debug_o(3) => ARDU03);
end architecture TopLevel; -- Entity: Kefir_Capsense

