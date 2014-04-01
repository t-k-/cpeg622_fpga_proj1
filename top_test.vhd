--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:14:48 03/25/2014
-- Design Name:   
-- Module Name:   /home/tk/Desktop/cpeg622/proj1/part2/top_test.vhd
-- Project Name:  part1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: uart
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
 
ENTITY top_test IS
END top_test;
 
ARCHITECTURE behavior OF top_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uart
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         rx : IN  std_logic;
         tx : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal rx : std_logic := '0';

 	--Outputs
   signal tx : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uart PORT MAP (
          clk => clk,
          reset => reset,
          rx => rx,
          tx => tx
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset <= '1';
      wait for 20 us;	
		reset <= '0';
		rx <= '1';
		wait for 20 us;
		
      --for j in 0 to 2 loop
            --for i in 0 to 4 loop
                    rx <= '0';  -- start
						  wait for 8.68 us;
                    rx <= '1';  -- bit0
						  wait for 8.68 us;
						  rx <= '1';  -- bit1
						  wait for 8.68 us;
                    rx <= '1';  -- bit2
						  wait for 8.68 us;
						  rx <= '1';  -- bit3
						  wait for 8.68 us;
                    rx <= '0';  -- bit4
						  wait for 8.68 us;
						  rx <= '1';  -- bit5
						  wait for 8.68 us;
                    rx <= '1';  -- bit6
						  wait for 8.68 us;
						  rx <= '1';  -- bit7
						  wait for 8.68 us;
                    rx <= '1';  -- stop
						  wait for 8.68 us;
            --end loop;
				wait for 30 us;
				        
						  rx <= '0';  -- start
						  wait for 8.68 us;
                    rx <= '1';  -- bit0
						  wait for 8.68 us;
						  rx <= '1';  -- bit1
						  wait for 8.68 us;
                    rx <= '1';  -- bit2
						  wait for 8.68 us;
						  rx <= '0';  -- bit3
						  wait for 8.68 us;
                    rx <= '0';  -- bit4
						  wait for 8.68 us;
						  rx <= '0';  -- bit5
						  wait for 8.68 us;
                    rx <= '1';  -- bit6
						  wait for 8.68 us;
						  rx <= '1';  -- bit7
						  wait for 8.68 us;
                    rx <= '1';  -- stop
						  wait for 8.68 us;
						  wait for 30 us;
						  
						  rx <= '0';  -- start
						  wait for 8.68 us;
                    rx <= '1';  -- bit0
						  wait for 8.68 us;
						  rx <= '1';  -- bit1
						  wait for 8.68 us;
                    rx <= '0';  -- bit2
						  wait for 8.68 us;
						  rx <= '1';  -- bit3
						  wait for 8.68 us;
                    rx <= '0';  -- bit4
						  wait for 8.68 us;
						  rx <= '1';  -- bit5
						  wait for 8.68 us;
                    rx <= '0';  -- bit6
						  wait for 8.68 us;
						  rx <= '1';  -- bit7
						  wait for 8.68 us;
                    rx <= '1';  -- stop
						  wait for 8.68 us;
						  wait for 30 us;
      --end loop; 

      wait;
   end process;

END;
