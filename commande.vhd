--Definition of a state machine avoiding a long press on a button
LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
entity generator is
PORT( E,clk : in std_logic;
		S: out std_logic);
end generator;

architecture a of generator is
--Definition of three possible states
type TypeEtat is (step1, step2, step3);
signal etat : TypeEtat;
begin
process(clk)
begin
	if clk'event and clk='1' then
		if etat=step1 and E='0' then
			etat<=step2;
		elsif etat=step2 then
			if E='1' then
				etat<=step1;
			else
				etat<=step3;
			end if;
		elsif etat=step3 and E='1' then
			etat<=step1;
		end if;
	end if;
end process;
S<='1' when etat=step2 else '0';
end a;

--Definition of the behavior of the stopwatch considering the pressed buttons (see subject for more infos)
LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
entity commande is
PORT( a, b, clk: in std_logic;
		EN, nload, nclear: out std_logic);
end commande;

architecture a of commande is
type TypeEtat is (clear, stop1, run1, run2, stop2);
signal etat : TypeEtat;
signal A1,B1: std_logic;
component generator is
PORT( E, clk: in std_logic;
		S: out std_logic);
end component;
begin
gen1 : generator port map (a, clk, A1);
gen2 : generator port map (b, clk, B1);
process(clk)
begin
	if (clk'event and clk='1') then
		if etat=clear then
			etat <= stop1;
		elsif etat=stop1 then
			if A1='1' then
				etat<=run1;
			elsif B1='1' then
				etat<=clear;
			end if;
		elsif etat=run1 then
			if A1='1' then
				etat<=stop1;
			elsif B1='1' then
				etat<=run2;
			end if;
		elsif etat=run2 then
			if A1='1' then
				etat<=stop2;
			elsif B1='1' then
				etat<=run1;
			end if;
		elsif etat=stop2 then
			if A1='1' then
				etat<= run2;
			elsif B1='1' then
				etat<=stop1;
			end if;
		end if;
	end if;
end process;
--Definition of outputs
EN<='0' when etat=clear or etat=stop1 or etat=stop2 else '1';
nload<='0' when etat=clear or etat=stop1 or etat=run1 else '1';
nclear<='0' when etat=clear else '1';
end a;

