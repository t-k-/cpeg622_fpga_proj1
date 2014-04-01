--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:44:28 04/01/2014
-- Design Name:   
-- Module Name:   /home/tk/Desktop/cpeg622/proj1/part3/recv_test.vhd
-- Project Name:  part3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ent_recv
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
 
ENTITY recv_test IS
END recv_test;
 
ARCHITECTURE behavior OF recv_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ent_recv
    PORT(
         rx_dout : IN  std_logic_vector(7 downto 0);
         rx_done : IN  std_logic;
         rst : IN  std_logic;
         clk : IN  std_logic;
         tx_done : IN  std_logic;
         tx_din : OUT  std_logic_vector(7 downto 0);
         tx_start : OUT  std_logic;
         err_head : INOUT  std_logic;
         err_tail : INOUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rx_dout : std_logic_vector(7 downto 0) := (others => '0');
   signal rx_done : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal tx_done : std_logic := '0';

	--BiDirs
   signal err_head : std_logic;
   signal err_tail : std_logic;

 	--Outputs
   signal tx_din : std_logic_vector(7 downto 0);
   signal tx_start : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ent_recv PORT MAP (
          rx_dout => rx_dout,
          rx_done => rx_done,
          rst => rst,
          clk => clk,
          tx_done => tx_done,
          tx_din => tx_din,
          tx_start => tx_start,
          err_head => err_head,
          err_tail => err_tail
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
      -- hold reset state for 100 ns.\
		rst <= '1';
      wait for 2 us;	
		rst <= '0';
		rx_dout <= "00000000";
		tx_done <= '0';
		rx_done <= '0';
      wait for 2 us;

		for i in 0 to 16
		loop
			wait for 17 ns;
			rx_dout <= std_logic_vector(to_unsigned(i, 8));
			wait for clk_period;
			rx_done <= '1';
			wait for clk_period;
			rx_done <= '0';
			wait for clk_period * 4;
		end loop;
		
		rx_dout <= "11111111";
		wait for clk_period;
		rx_done <= '1';
		wait for clk_period;
		rx_done <= '0';
		
		wait for 1 us;
		
      wait;
   end process;

END;
