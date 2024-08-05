
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIR_Filter_tb is
end FIR_Filter_tb;

architecture Behavioral of FIR_Filter_tb is

component FIR_Filter is 
  Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        sw : in std_logic_vector(3 downto 0);
        sample_in : in signed(15 downto 0); -- Input sample
        sample_out : out std_logic_vector(31 downto 0)  -- Output sample
    );
end component;

type coeff_array is array (0 to 80) of std_logic_vector(15 downto 0);
 signal sin : coeff_array :=
(x"0000",x"3855",x"0000",x"F895",x"0000",x"6549",x"0000",x"1DEE",x"0000",x"7FFF",
x"0000",x"2BDA",x"0000",x"7FFF",x"0000",x"1DEE",x"0000",x"6549",x"0000",x"F895",
x"0000",x"3855",x"0000",x"C7AB",x"0000",x"076B",x"0000",x"9AB7",x"0000",x"E212",
x"0000",x"8000",x"0000",x"D426",x"0000",x"8000",x"0000",x"E212",x"0000",x"9AB7",
x"0000",x"076B",x"0000",x"C7AB",x"0000",x"3855",x"0000",x"F895",x"0000",x"6549",
x"0000",x"1DEE",x"0000",x"7FFF",x"0000",x"2BDA",x"0000",x"7FFF",x"0000",x"1DEE",
x"0000",x"6549",x"0000",x"F895",x"0000",x"3855",x"0000",x"C7AB",x"0000",x"076B",
x"0000",x"9AB7",x"0000",x"E212",x"0000",x"8000",x"0000",x"D426",x"0000",x"8000",
x"0000");

signal sample_in : signed(15 downto 0):=(others=>'0');
signal sample_out: std_logic_vector(31 downto 0);
signal clk,reset : std_logic:='0';
signal sw : std_logic_vector(3 downto 0):=x"0";

begin
u1: FIR_Filter port map(clk=>clk,sample_in=>sample_in,sample_out=>sample_out,reset=>reset,sw=>sw);

process
begin
wait for 5ns;
clk<=not(clk);
end process;

process
begin 
reset<='1';
wait for 1000ns;
reset<=not(reset);
wait;
end process;

process
variable ind:integer range 0 to 8:=0;
begin 
for i in 0 to 3 loop
wait for 3500ns;
sw<=std_logic_vector(to_signed(ind,4));
ind:=2**i;
end loop;
end process;

process
begin
for i in 0 to 80 loop
wait for 20ns;
sample_in<=signed(sin(i));
end loop;
end process;
end Behavioral;
