--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:10:06 03/20/2014
-- Design Name:   
-- Module Name:   /home/tk/Desktop/cpeg622/proj1/part1/trans_test.vhd
-- Project Name:  part1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ent_trans
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY trans_test IS
END trans_test;
 
ARCHITECTURE behavior OF trans_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ent_trans
    PORT(
         rx_dout : IN  std_logic_vector(7 downto 0);
         rx_done : IN  std_logic;
         rst : IN  std_logic;
         tx_done : IN  std_logic;
         tx_din : OUT  std_logic_vector(7 downto 0);
         tx_start : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rx_dout : std_logic_vector(7 downto 0) := (others => '0');
   signal rx_done : std_logic := '0';
   signal rst : std_logic := '0';
   signal tx_done : std_logic := '0';

 	--Outputs
   signal tx_din : std_logic_vector(7 downto 0);
   signal tx_start : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ent_trans PORT MAP (
          rx_dout => rx_dout,
          rx_done => rx_done,
          rst => rst,
          tx_done => tx_done,
          tx_din => tx_din,
          tx_start => tx_start
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst <= '1';
      wait for 100 ns;	
		rst <= '0';
		rx_done <= '0';
      wait for clk_period * 10;

		rx_done <= '1';
		rx_dout <= "00000001";
		wait for clk_period;
		rx_done <= '0';
		wait for clk_period;
		
		rx_done <= '1';
		rx_dout <= "00000010";
		wait for clk_period;
		rx_done <= '0';
		wait for clk_period;
		
		rx_done <= '1';
		rx_dout <= "00000011";
		wait for clk_period;
		rx_done <= '0';
		wait for clk_period;
		
		wait for 100 ns;
		
		tx_done <= '1';
		wait for clk_period;
		tx_done <= '0';
		wait for clk_period;
		
		tx_done <= '1';
		wait for clk_period;
		tx_done <= '0';
		wait for clk_period;
		
		tx_done <= '1';
		wait for clk_period;
		tx_done <= '0';
		wait for clk_period;
		
		
		wait for 300 us;
      -- insert stimulus here 

      wait;
   end process;

END;
