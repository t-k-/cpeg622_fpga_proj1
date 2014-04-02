library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ent_encry is
    generic(DBIT: integer := 8);
    Port ( idata : in  STD_LOGIC_VECTOR (DBIT - 1 downto 0);
           odata : out  STD_LOGIC_VECTOR (DBIT - 1 downto 0);
           code : in  STD_LOGIC_VECTOR (DBIT - 1 downto 0));
end ent_encry;

architecture arch_encry of ent_encry is
begin
	with idata select 
		odata <= idata when "00001101", idata xor code when others;
end arch_encry;

