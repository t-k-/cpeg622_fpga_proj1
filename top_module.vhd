-- Listing 7.4
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity uart is
   generic(
     -- Default setting:
     -- 19,200 baud, 8 data bis, 1 stop its, 2^2 FIFO
     DBIT: integer := 8;     -- # data bits
     SB_TICK: integer := 16; -- # ticks for stop bits, 16/24/32
                             --   for 1/1.5/2 stop bits
     DVSR: integer := 54;    -- baud rate divisor
                             -- DVSR = 100M/(16*115200)
	  DVSR_BIT: integer := 6  -- # bits of DVSR
   );
   port(
      clk, reset: in std_logic;
      pc_rx : in std_logic; 
		pc_tx : out std_logic;
		neighbor_rx, neighbor_tx: inout std_logic;
		err_head, err_tail : inout std_logic;
		encry_code : inout std_logic_vector(DBIT - 1 downto 0)
   );
end uart;

architecture str_arch of uart is
	signal tick: std_logic;
   signal pc_tx_start, pc_tx_done: std_logic;
	signal pc_tx_din, pc_tx_din_encry : std_logic_vector(7 downto 0);
	signal pc_rx_done: std_logic;
	signal pc_rx_dout, pc_rx_dout_encry : std_logic_vector(7 downto 0);
	signal neighbor_tx_start, neighbor_tx_done: std_logic;
	signal neighbor_tx_din : std_logic_vector(7 downto 0);
	signal neighbor_rx_done: std_logic;
	signal neighbor_rx_dout : std_logic_vector(7 downto 0);
begin
   baud_gen_unit: entity work.mod_m_counter(arch)
      generic map(M=>DVSR, N=>DVSR_BIT)
      port map(clk=>clk, reset=>reset, q=>open, max_tick=>tick);
					
   pc_rx_unit: entity work.uart_rx(arch)
      generic map(DBIT=>DBIT, SB_TICK=>SB_TICK)
      port map(clk=>clk, reset=>reset, rx=>pc_rx, s_tick=>tick, 
		         rx_done_tick=>pc_rx_done, dout=>pc_rx_dout);
					
	encoder_unit: entity work.ent_encry(arch_encry)
		generic map(DBIT=>DBIT)
		port map(code=>encry_code, idata=>pc_rx_dout ,odata=>pc_rx_dout_encry);
					
	trans_unit: entity work.ent_trans(arch_trans)
		port map(rst=>reset, clk=>clk,
		         rx_dout=>pc_rx_dout_encry, rx_done=>pc_rx_done,
		         tx_done=>neighbor_tx_done, tx_din=>neighbor_tx_din, 
					tx_start=>neighbor_tx_start);
					
	neighbor_tx_unit: entity work.uart_tx(arch)
      generic map(DBIT=>DBIT, SB_TICK=>SB_TICK)
      port map(clk=>clk, reset=>reset, tx=>neighbor_tx, s_tick=>tick,
               tx_start=>neighbor_tx_start, din=>neighbor_tx_din, 
					tx_done_tick=>neighbor_tx_done);
					
	neighbor_rx <= (not (not neighbor_tx));
  
   neighbor_rx_unit: entity work.uart_rx(arch)
      generic map(DBIT=>DBIT, SB_TICK=>SB_TICK)
      port map(clk=>clk, reset=>reset, rx=>neighbor_rx, s_tick=>tick, 
		         rx_done_tick=>neighbor_rx_done, dout=>neighbor_rx_dout);
					
	recv_unit: entity work.ent_recv(arch_recv)
		port map(rst=>reset, clk=>clk, err_head=>err_head, err_tail=>err_tail,
					rx_dout=>neighbor_rx_dout, rx_done=>neighbor_rx_done,
		         tx_done=>pc_tx_done, tx_din=>pc_tx_din_encry, tx_start=>pc_tx_start);
					
	decoder_unit: entity work.ent_encry(arch_encry)
		generic map(DBIT=>DBIT)
		port map(code=>encry_code, idata=>pc_tx_din_encry ,odata=>pc_tx_din);
	
	pc_tx_unit: entity work.uart_tx(arch)
      generic map(DBIT=>DBIT, SB_TICK=>SB_TICK)
      port map(clk=>clk, reset=>reset, tx=>pc_tx, s_tick=>tick,
				tx_start=>pc_tx_start, din=>pc_tx_din, tx_done_tick=>pc_tx_done);
				
end str_arch;