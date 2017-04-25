------------------------------------------------------------------------------
----                                                                      ----
----  Capsense system controller                                          ----
----                                                                      ----
----  This file is part FPGA Libre project http://fpgalibre.sf.net/       ----
----                                                                      ----
----  Description:                                                        ----
----  Core used to periodically sample capsense buttons.                  ----
----  This version includes the frequency dividers and the toggle logic.  ----
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
---- Design unit:      CapSense_Sys(RTL) (Entity and architecture)        ----
---- File name:        capsense_sys.vhdl                                  ----
---- Note:             None                                               ----
---- Limitations:      None known                                         ----
---- Errors:           None known                                         ----
---- Library:          None                                               ----
---- Dependencies:     IEEE.std_logic_1164                                ----
----                   IEEE.numeric_std                                   ----
----                   IEEE.math_real                                     ----
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
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity CapSense_Sys is
   generic(
      DIRECT    : boolean:=true;
      FREQUENCY : integer:=24;
      N         : integer range 2 to 8:=4);
   port(
      clk_i       : in    std_logic; -- System clock
      rst_i       : in    std_logic; -- System reset
      capsense_io : inout std_logic_vector(N-1 downto 0); -- I/O pins
      buttons_o   : out   std_logic_vector(N-1 downto 0); -- Last sample result
      debug_o     : out   std_logic_vector(N-1 downto 0)  -- Used to measure the button timing
        );
end entity CapSense_Sys;

architecture TopLevel of CapSense_Sys is
   constant MOD_SAMP : integer:=integer(real(FREQUENCY)/1.5);
   constant MOD_BITS : integer:=integer(ceil(log2(real(MOD_SAMP))));
   signal clkSamp    : std_logic;
   signal cntSamp    : unsigned(MOD_BITS-1 downto 0):=(others => '0');
   signal clkPoll    : std_logic;
   signal cntPoll    : unsigned(16 downto 0):=(others => '0');
   signal cur_btns   : std_logic_vector(3 downto 0);
   signal prev_btn_r : std_logic_vector(3 downto 0):=(others => '0');
   signal cur_btn_r  : std_logic_vector(3 downto 0):=(others => '0');
begin
   -- 1.5 MHz capacitors sample
   do_div:
   process (clk_i)
   begin
      if rising_edge(clk_i) then
         if cntSamp=MOD_SAMP-1 then
            cntSamp <= (others => '0');
         else
            cntSamp <= cntSamp+1;
         end if;
      end if;
   end process do_div;
   clkSamp <= '1' when cntSamp=0 else '0';

   -- 87 ms
   do_div87ms:
   process (clk_i)
   begin
      if rising_edge(clk_i) then
         if clkSamp='1' then
            cntPoll <= cntPoll+1;
         end if;
      end if;
   end process do_div87ms;
   clkPoll <= '1' when cntPoll=0 else '0';

   CS : entity work.CapSense
      generic map (N => N)
      port map(
         clk_i => clk_i,
         rst_i => rst_i,
         ena_i => clkSamp,
         start_i => clkPoll,
         buttons_io => capsense_io,
         sampled_o => cur_btns,
         debug_o => debug_o);

   push_buttons:
   if DIRECT generate
      buttons_o <= cur_btns;
   end generate push_buttons;

   toggle_buttons:
   if not(DIRECT) generate
      btn_regs:
      process (clk_i)
      begin
         if rising_edge(clk_i) then
            prev_btn_r <= cur_btns;
            for i in cur_btns'range loop
                if prev_btn_r(i)='0' and cur_btns(i)='1' then -- pressed?
                   cur_btn_r(i) <= not(cur_btn_r(i)); -- toggle
                end if;
            end loop;
         end if;
      end process btn_regs;
      buttons_o <= cur_btn_r;
   end generate toggle_buttons;

end architecture TopLevel; -- Entity: CapSense_Sys

