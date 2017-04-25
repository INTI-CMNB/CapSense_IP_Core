------------------------------------------------------------------------------
----                                                                      ----
----  Capsense controller                                                 ----
----                                                                      ----
----  This file is part FPGA Libre project http://fpgalibre.sf.net/       ----
----                                                                      ----
----  Description:                                                        ----
----  Core used to periodically sample capsense buttons.                  ----
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
---- Design unit:      CapSense(RTL) (Entity and architecture)            ----
---- File name:        capsense.vhdl                                      ----
---- Note:             None                                               ----
---- Limitations:      None known                                         ----
---- Errors:           None known                                         ----
---- Library:          None                                               ----
---- Dependencies:     IEEE.std_logic_1164                                ----
----                   IEEE.numeric_std                                   ----
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

entity CapSense is
   generic(
      N : integer range 2 to 8);
   port(
      clk_i      : in    std_logic; -- System clock
      rst_i      : in    std_logic; -- System reset
      ena_i      : in    std_logic; -- Frequency used to sample the buttons
      start_i    : in    std_logic; -- Start a sampling sequence
      buttons_io : inout std_logic_vector(N-1 downto 0); -- I/O pins
      sampled_o  : out   std_logic_vector(N-1 downto 0); -- Last sample result
      debug_o    : out   std_logic_vector(N-1 downto 0)  -- Used to measure the button timing
        );
end entity CapSense;

architecture RTL of CapSense is
   constant ALL_0 : std_logic_vector(N-1 downto 0):=(others => '0');
   constant ALL_1 : std_logic_vector(N-1 downto 0):=(others => '1');
   type state_type is (idle, sampling, do_sample);
   signal state  : state_type;
   signal btns_r : std_logic_vector(N-1 downto 0);
begin
   -- Keep the capacitors discharged while we are idle
   buttons_io <= (others => '0') when state=idle else (others => 'Z');
   -- Used to measure the buttons timing
   debug_o    <= (others => '1') when state=idle else buttons_io;

   do_fsm:
   process (clk_i)
   begin
      if rising_edge(clk_i) then
         if rst_i='1' then
            state  <= idle;
            btns_r <= (others => '0');
         else
            case state is
                 when idle =>
                      if start_i='1' then
                         state <= sampling;
                      end if;
                 when sampling =>
                      -- Sample the capacitors at the ena_i rate
                      -- If any of the capacitors is charged stop waiting
                      if ena_i='1' and buttons_io/=ALL_0 then
                         state  <= do_sample;
                      end if;
                 when others => -- do_sample
                      -- We wait 1 more cycle to mask small differences between
                      -- buttons. Pressed buttons have big differeneces.
                      if ena_i='1' then -- For debug: and buttons_io=ALL_1 then
                         -- The "pressed" buttons are the ones that stay charging
                         btns_r <= not(buttons_io);
                         state  <= idle;
                      end if;
            end case;
         end if;
      end if;
   end process do_fsm;
   sampled_o <= btns_r;
end architecture RTL; -- Entity: CapSense

