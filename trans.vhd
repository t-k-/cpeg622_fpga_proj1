library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity ent_trans is
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
			 code : in  STD_LOGIC_VECTOR (WORD_BITS - 1 downto 0));
end ent_trans;

architecture arch_trans of ent_trans is
	type buff_t is array (2**BUF_BITS - 1 downto 0) of std_logic_vector(WORD_BITS - 1 downto 0);
	type stat_t is (init_s, read_s, wait_s, push_s, start_push_s, start_wait_s,
	                stop_push_s, stop_wait_s);
	signal state : stat_t;
	signal buff : buff_t;
	signal p, p_plus, p_minus : unsigned(BUF_BITS - 1 downto 0);
	signal encry_zeros : STD_LOGIC_VECTOR (WORD_BITS - 1 downto 0);
begin
	p_plus <= p + 1;
	p_minus <= p - 1;
	encry_zeros <= "00000000" xor code;

process (clk, rst)
begin
	if (rst = '1') then
		p <= (others=>'0');
		buff <= (others=>(others=>'0'));
		state <= init_s;
		tx_din <= (others=>'0');
	elsif (rising_edge(clk)) then
		tx_start <= '0';
		
		case state is
			when init_s =>
				buff <= (others=>encry_zeros);
				state <= read_s;
			when read_s =>
				tx_din <= (others=>'0'); -- start char
				
				if (rx_done = '1') then		
					if (rx_dout = "00001101") then
						state <= start_push_s;
						p <= to_unsigned(BUFF_LEN - 1, BUF_BITS);
					else 
						buff(to_integer(p)) <= rx_dout;
						if (to_integer(p) = BUFF_LEN - 1) then					
							state <= start_push_s;			
						else 
							p <= p_plus;
						end if;
					end if;
				end if;
			when start_push_s =>
				tx_start <= '1';
				state <= start_wait_s;
			when start_wait_s =>
				if (tx_done = '1') then
					tx_din <= buff(0);
					state <= push_s;
				end if;
			when push_s =>
				tx_start <= '1';
				state <= wait_s;
			when wait_s =>
				if (tx_done = '1') then
					tx_din <= buff(to_integer(BUFF_LEN - p));
					if (p = 0) then
						state <= stop_push_s;
						tx_din <= (others=>'1'); -- end char
					else
						state <= push_s;
						p <= p_minus;
					end if;
				end if;
			when stop_push_s =>
				tx_start <= '1';
				state <= stop_wait_s;
			when stop_wait_s =>
				if (tx_done = '1') then
					state <= init_s;
				end if;
			when others =>
				-- empty
		end case;
	end if;
end process;

end arch_trans;