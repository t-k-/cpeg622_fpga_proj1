--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:45:19 04/02/2014
-- Design Name:   
-- Module Name:   /home/tk/Desktop/cpeg622/proj1/part3/test_trans.vhd
-- Project Name:  part3
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
USE ieee.numeric_std.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_trans IS
END test_trans;
 
ARCHITECTURE behavior OF test_trans IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ent_trans
    PORT(
         rx_dout : IN  std_logic_vector(7 downto 0);
         rx_done : IN  std_logic;
         rst : IN  std_logic;
         clk : IN  std_logic;
         tx_done : IN  std_logic;
         tx_din : OUT  std_logic_vector(7 downto 0);
         tx_start : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rx_dout : std_logic_vector(7 downto 0) := (others => '0');
   signal rx_done : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
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
          clk => clk,
          tx_done => tx_done,
          tx_din => tx_din,
          tx_start => tx_start
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
		rst <= '1';
		rx_done <= '0';
		tx_done <= '0';
      wait for 100 ns;	
		rst <= '0';
		
      wait for clk_period*10;
		
		for i in 1 to 16
		loop
			rx_dout <= std_logic_vector(to_unsigned(i, 8));
			rx_done <= '1';
			wait for clk_period;
			rx_done <= '0';
			wait for clk_period;
		end loop;
		
		for i in 1 to 18
		loop
			tx_done <= '1';
			wait for clk_period;
			tx_done <= '0';
			wait for clk_period;
		end loop;
		
		wait for 300 ns;	-----------------
		
		for i in 1 to 16
		loop
			rx_dout <= std_logic_vector(to_unsigned(i, 8));
			rx_done <= '1';
			wait for clk_period;
			rx_done <= '0';
			wait for clk_period;
		end loop;
		
		for i in 1 to 18
		loop
			tx_done <= '1';
			wait for clk_period;
			tx_done <= '0';
			wait for clk_period;
		end loop;

      -- insert stimulus here 

      wait;
   end process;

END;
