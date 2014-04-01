library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity ent_recv is
	Generic ( WORD_BITS : integer := 8;
	          BUF_BITS  : integer := 4;
	          BUFF_LEN  : integer := 16
	);
	Port ( rx_dout : in  STD_LOGIC_VECTOR (WORD_BITS - 1 downto 0);
	       rx_done : in  STD_LOGIC;
	       rst, clk : in std_logic;
	       tx_done : in  STD_LOGIC;
	       tx_din : out  STD_LOGIC_VECTOR (WORD_BITS - 1 downto 0);
	       tx_start : out  STD_LOGIC;
			 err_head, err_tail: inout  STD_LOGIC);
end ent_recv;
 
architecture arch_recv of ent_recv is
	type buff_t is array (2**BUF_BITS - 1 downto 0) of 
		std_logic_vector(WORD_BITS - 1 downto 0);
	type stat_t is (head_s, data_s, tail_s, put_s, signal_s);
	signal state, next_state : stat_t;
	signal buff : buff_t;
	signal p, next_p: unsigned(BUF_BITS - 1 downto 0);
	signal wr_ctrl : std_logic;
	signal next_tx_start : std_logic;
	constant ones : std_logic_vector(WORD_BITS - 1 downto 0) := (others=>'0'); 
begin
err_head <= '1';
err_tail <= '0';
tx_din <= buff(BUFF_LEN - to_integer(p));

process (clk, rst)
begin	
	if (rst = '1') then
		state <= head_s;
		p <= (others=>'0');
		tx_start <= '0';
		wr_ctrl <= '0';
		
		buff <= (others=>(others=>'0'));
	elsif (rising_edge(clk)) then
		state <= next_state;

		p <= next_p;
		tx_start <= next_tx_start;
		
		if (wr_ctrl = '1') then
			buff(to_integer(p)) <= rx_dout;
		end if;
	end if;
end process;

process (rx_done, state, rx_dout, p, tx_done, buff) 
begin
	next_state <= state;
	
	next_p <= p;
	next_tx_start <= '0';
	wr_ctrl <= '0';
	
	case state is
		when head_s =>
			if (rx_done = '1') then
				next_p <= (others=>'0');
				if (unsigned(rx_dout) = 0) then
					next_state <= data_s;
				else
				end if;
			end if;
		when data_s =>
			if (rx_done = '1') then
				if (p = BUFF_LEN) then
					next_state <= tail_s;
				else
					wr_ctrl <= '1';
					next_p <= p + 1;
				end if;
			end if;
		when tail_s =>
			if (rx_done = '1') then
				if (rx_dout = ones) then
					next_state <= put_s;
				else
					next_state <= head_s;
				end if;
			end if;
		when put_s =>
			if (tx_done = '1') then
				if (p = 0) then
					next_state <= head_s;
				else
					next_state <= signal_s;
					next_p <= p - 1;
				end if;
			end if;
		when signal_s =>
			next_tx_start <= '1';
			next_state <= put_s;
	end case;
end process;

end arch_recv;
