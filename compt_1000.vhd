--Definition of a 10-counter (for each 7-segments display)
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY compt_10 IS
	PORT(
		en,nclear,clk : IN std_logic;
		--Output of the counter
		Q: OUT std_logic_vector(3 downto 0);
		--Output of the carry over
		R: OUT std_logic);
end compt_10;

architecture a of compt_10 is
begin
--nclear is asynchronous and allow to reset the value of the counter when in low state
--When rising clock and high state of EN (running stopwatch), counter is incremented
process(nclear, clk)
variable var : std_logic_vector(4 downto 0);
begin
	if(nclear='0') then
		var:="00000";
	elsif (clk'event and clk='1' and en='1') then
		var:=var+'1';
	end if;
	--If we reach 10, the MSB is put at 1 for the carry over et we put all other bits at 0 to reset the counter
	if(var="01010") then
		var:="10000";
	--If the MSB is 1, the carry over has already been taken into account, we must delete it.
	elsif(var(4) = '1') then
		var(4) := '0';
	end if;
	--The output of the counter is the first 4 bits
	Q<=var(3 downto 0);
	--The carry over output is the MSB
	if (var(4)='1') then 
		R<='1';
	else	
		R<='0';
	end if;
end process;
end a;

--Definition of the 1000 counter 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity compt_1000 is
	port(
		en,nclear,clk : in std_logic;
		Q: OUT std_logic_vector(11 downto 0)
	);
end compt_1000;

architecture a of compt_1000 is
--Definition of three signals which will store the value of each digit of each 7-segment display (unit, tens, hundreads)
signal compt1_q : std_logic_vector(3 downto 0);
signal compt2_q : std_logic_vector(3 downto 0);
signal compt3_q : std_logic_vector(3 downto 0);
--Definition of three signals which will store the value of each carry over of each 10-counter (tens, hundreads, thousands)
signal compt1_r : std_logic;
signal compt2_r : std_logic;
signal compt3_r : std_logic;
--Signal for reduced clock
signal clock : std_logic;

component compt_10 is
	PORT(
		en,nclear,clk : IN std_logic;
		Q: OUT std_logic_vector(3 downto 0);
		R: OUT std_logic);
end component;

component clock_rate is
	PORT(
		clk : IN std_logic;
		S: OUT std_logic);
end component;
begin
--Instanciation des modules
clock_1 : clock_rate port map(clk,clock);
--The reduced clock is used by the remaining code as "regular" clock
compt1_10 : compt_10 port map(en, nclear, clock, compt1_q, compt1_r);
--If there is a carry over in the unit 10-counter we should increment the tens 10-counter by simulating a rising clock thanks to the carry over signal
compt2_10 : compt_10 port map(en, nclear, compt1_r, compt2_q, compt2_r);
--If there is a carry over in the tens 10-counter we should increment the hundreads 10-counter by simulating a rising clock thanks to the carry over signal
compt3_10 : compt_10 port map(en, nclear, compt2_r, compt3_q, compt3_r);
--The output is a 12-bits bus where the value (in bits) of hundreads, tens and units are added each one after the other
Q<= compt3_q&compt2_q&compt1_q;
end a;
