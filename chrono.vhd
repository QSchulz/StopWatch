--Defining the memory for saving the first lap of the stopwatch
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity mem is
	port(
		clk, nload: in std_logic;
		E: in std_logic_vector(11 downto 0);
		Q: out std_logic_vector(11 downto 0)
	);
end mem;

architecture a of mem is
begin
--Memory is synchronized when rising clock and low state of nload
process (clk)
begin
	if (clk'event and clk='1' and nload='0') 
		Q<=E;
	end if;
end process;
end a;

--Defining the "main" module
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--Contains the clock and two buttons as input
--Output is 3 buses of 7 bits
entity chrono is
	port(
		clk_in,pb1, pb2:in std_logic;
		HEX0, HEX1, HEX2: out std_logic_vector(6 downto 0)
	);
end chrono;

architecture a of chrono is
--Instanciation of signals needed for inter-module operations
signal compt1000 : std_logic_vector(11 downto 0);
signal en: std_logic;
signal nclear: std_logic;
signal nload: std_logic;
signal mem1:std_logic_vector(11 downto 0);
--Definition of needed components
component compt_1000 is
		port(
		en,nclear,clk : in std_logic;
		Q: OUT std_logic_vector(11 downto 0));
end component;
component afficheur is
		PORT(
		A : in std_logic_vector(3 downto 0);
		HEX : out std_logic_vector(6 downto 0)
	);
end component;
component commande is
PORT( a,b,clk:in std_logic;
		EN, nload, nclear: out std_logic);
end component;
component mem is
	port(
		clk, nload: in std_logic;
		E: in std_logic_vector(11 downto 0);
		Q: out std_logic_vector(11 downto 0)
	);
end component;
begin

com : commande port map(pb1,pb2,clk_in, en, nload, nclear);
compt : compt_1000 port map(en,nclear,clk_in,compt1000);
memoire : mem port map (clk_in, nload, compt1000, mem1);
aff1 : afficheur port map (mem1(3 downto 0), HEX0);
aff2 : afficheur port map (mem1(7 downto 4), HEX1);
aff3 : afficheur port map (mem1(11 downto 8), HEX2);
end a;
