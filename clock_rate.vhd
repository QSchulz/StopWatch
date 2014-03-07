--Definition of the "reducing clock to 10Hz" module
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY clock_rate IS
	PORT(
		clk : IN std_logic;
		S: OUT std_logic);
end clock_rate;


architecture a of clock_rate is
begin
--On rising clock, we increase a counter until it reaches 2,5.10^6. At this time we switch the output signal to 1
--Original clock is at 50MHz while reduced clock is at 10Hz
process(clk)
variable var : integer;
begin
	if(clk'event and clk='1')then
		var:=var+1;
		--To be sure we will not meet forbidden values (and reset the counter when needed)
		var:=var mod 5000000;
		if (var>=2500000)then
			S<='1';
		else
			S<='0';
		end if;
	end if;
end process;
end a;

