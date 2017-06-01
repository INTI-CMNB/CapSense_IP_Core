------------------------------------------------------------------------------
----                                                                      ----
----  Capsense controller package                                         ----
----                                                                      ----
----  This file is part FPGA Libre project http://fpgalibre.sf.net/       ----
----                                                                      ----
----  Description:                                                        ----
----  Declarations for the CapSense library.                              ----
----                                                                      ----
----  To Do:                                                              ----
----  -                                                                   ----
----                                                                      ----
----  Author:                                                             ----
----    - Salvador E. Tropea, salvador en inti.gob.ar                     ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Copyright (c) 2016-2017 Salvador E. Tropea <salvador en inti.gob.ar> ----
---- Copyright (c) 2016-2017 Instituto Nacional de Tecnología Industrial  ----
----                                                                      ----
---- This file can be distributed under the terms of the GPL 2.0 license  ----
---- or newer.                                                            ----
----                                                                      ----
------------------------------------------------------------------------------
----                                                                      ----
---- Design unit:      Devices (Package)                                  ----
---- File name:        capsense_pkg.vhdl                                  ----
---- Note:             None                                               ----
---- Limitations:      None known                                         ----
---- Errors:           None known                                         ----
---- Library:          None                                               ----
---- Dependencies:     IEEE.std_logic_1164                                ----
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

package Devices is
   component CapSense is
      generic(
         N : integer range 2 to 8);
      port(
         clk_i      : in    std_logic; -- System clock
         rst_i      : in    std_logic; -- System reset
         ena_i      : in    std_logic; -- Frequency used to sample the buttons
         start_i    : in    std_logic; -- Start a sampling sequence
         buttons_i  : in    std_logic_vector(N-1 downto 0); -- Input pins
         but_oe_o   : out   std_logic;                      -- Cap. discharge
         sampled_o  : out   std_logic_vector(N-1 downto 0); -- Last sample result
         debug_o    : out   std_logic_vector(N-1 downto 0)  -- Used to measure the button timing
           );
   end component CapSense;

   component CapSense_Sys is
      generic(
         DIRECT    : std_logic:='1';
         FREQUENCY : integer:=24;
         N         : integer range 2 to 8:=4);
      port(
         clk_i       : in    std_logic; -- System clock
         rst_i       : in    std_logic; -- System reset
         capsense_i  : in    std_logic_vector(N-1 downto 0); -- Input pins
         capsense_o  : out   std_logic; -- Cap. discharge
         buttons_o   : out   std_logic_vector(N-1 downto 0); -- Last sample result
         debug_o     : out   std_logic_vector(N-1 downto 0)  -- Used to measure the button timing
           );
   end component CapSense_Sys;
end package Devices;

