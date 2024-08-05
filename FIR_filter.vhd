library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIR_Filter is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        sw : in std_logic_vector(3 downto 0);
        sample_in : in signed(15 downto 0); -- Input sample
        sample_out : out std_logic_vector(31 downto 0)  -- Output sample
    );
end FIR_Filter;

architecture Behavioral of FIR_Filter is
constant N : positive:=80;

--LPF_coeff

type coeff_array is array (0 to 80) of std_logic_vector(15 downto 0);
 signal LPF_coeff : coeff_array :=
(x"0000",x"0000",x"0000",x"0000",x"0001",x"0003",x"0006",x"0009",x"000C",x"000C",
x"0007",x"FFFC",x"FFEC",x"FFD8",x"FFC6",x"FFBB",x"FFBE",x"FFD4",x"0000",x"003E",
x"0086",x"00C8",x"00F2",x"00F0",x"00B4",x"0037",x"FF82",x"FEAD",x"FDDF",x"FD4A",
x"FD22",x"FD97",x"FEC8",x"00BB",x"035A",x"066F",x"09AE",x"0CBD",x"0F3E",x"10E2",
x"1174",x"10E2",x"0F3E",x"0CBD",x"09AE",x"066F",x"035A",x"00BB",x"FEC8",x"FD97",
x"FD22",x"FD4A",x"FDDF",x"FEAD",x"FF82",x"0037",x"00B4",x"00F0",x"00F2",x"00C8",
x"0086",x"003E",x"0000",x"FFD4",x"FFBE",x"FFBB",x"FFC6",x"FFD8",x"FFEC",x"FFFC",
x"0007",x"000C",x"000C",x"0009",x"0006",x"0003",x"0001",x"0000",x"0000",x"0000",
x"0000");

--HPF_coeff

 signal HPF_coeff : coeff_array :=
(x"0000",x"0000",x"0000",x"0000",x"0001",x"FFFD",x"0006",x"FFF7",x"000C",x"FFF4",
x"0007",x"0004",x"FFEC",x"0028",x"FFC6",x"0045",x"FFBE",x"002C",x"0000",x"FFC2",
x"0086",x"FF38",x"00F2",x"FF10",x"00B4",x"FFC9",x"FF82",x"0153",x"FDDF",x"02B6",
x"FD22",x"0269",x"FEC8",x"FF45",x"035A",x"F991",x"09AE",x"F343",x"0F3E",x"EF1E",
x"1174",x"EF1E",x"0F3E",x"F343",x"09AE",x"F991",x"035A",x"FF45",x"FEC8",x"0269",
x"FD22",x"02B6",x"FDDF",x"0153",x"FF82",x"FFC9",x"00B4",x"FF10",x"00F2",x"FF38",
x"0086",x"FFC2",x"0000",x"002C",x"FFBE",x"0045",x"FFC6",x"0028",x"FFEC",x"0004",
x"0007",x"FFF4",x"000C",x"FFF7",x"0006",x"FFFD",x"0001",x"0000",x"0000",x"0000",
x"0000");

--BSF_coeff

 signal BSF_coeff : coeff_array :=
(x"0000",x"0000",x"FFFF",x"0000",x"FFFE",x"0000",x"000C",x"0000",x"FFE8",x"0000",
x"000D",x"0000",x"0029",x"0000",x"FF8C",x"0000",x"0084",x"0000",x"0000",x"0000",
x"FEF4",x"0000",x"01E4",x"0000",x"FE99",x"0000",x"FF04",x"0000",x"0442",x"0000",
x"FA44",x"0000",x"0270",x"0000",x"06B3",x"0000",x"ECA3",x"0000",x"1E7B",x"0000",
x"5D17",x"0000",x"1E7B",x"0000",x"ECA3",x"0000",x"06B3",x"0000",x"0270",x"0000",
x"FA44",x"0000",x"0442",x"0000",x"FF04",x"0000",x"FE99",x"0000",x"01E4",x"0000",
x"FEF4",x"0000",x"0000",x"0000",x"0084",x"0000",x"FF8C",x"0000",x"0029",x"0000",
x"000D",x"0000",x"FFE8",x"0000",x"000C",x"0000",x"FFFE",x"0000",x"FFFF",x"0000",
x"0000");

--BPF_coeff

 signal BPF_coeff : coeff_array :=
(x"0000",x"0000",x"0001",x"0000",x"0001",x"0000",x"FFF4",x"0000",x"0018",x"0000",
x"FFF3",x"0000",x"FFD7",x"0000",x"0074",x"0000",x"FF7C",x"0000",x"0000",x"0000",
x"010C",x"0000",x"FE1C",x"0000",x"0167",x"0000",x"00FC",x"0000",x"FBBE",x"0000",
x"05BC",x"0000",x"FD90",x"0000",x"F94D",x"0000",x"135D",x"0000",x"E185",x"0000",
x"22E9",x"0000",x"E185",x"0000",x"135D",x"0000",x"F94D",x"0000",x"FD90",x"0000",
x"05BC",x"0000",x"FBBE",x"0000",x"00FC",x"0000",x"0167",x"0000",x"FE1C",x"0000",
x"010C",x"0000",x"0000",x"0000",x"FF7C",x"0000",x"0074",x"0000",x"FFD7",x"0000",
x"FFF3",x"0000",x"0018",x"0000",x"FFF4",x"0000",x"0001",x"0000",x"0001",x"0000",
x"0000");

signal NO_coeff:coeff_array:=(others=>(others=>'0'));
signal CO_filter:coeff_array:=(others=>(others=>'0'));

type f_type is (NO_F,LPF,HPF,BSF,BPF);
signal filter_type : f_type ;

type mem is array (0 to 80) of signed(31 downto 0);
signal mul:mem:=(others=>(others=>'0'));
signal sum: mem :=(others=>(others=>'0'));

signal hn:std_logic_vector(15 downto 0):=x"0000";
signal count:integer range 0 to 100:=0;

begin

sample_out<=(others=>'0') when reset='1' else
            std_logic_vector(sample_in)&x"0000" when sw=x"0" else
            std_logic_vector(sum(0)(31 downto 0));

--sw for the filter we want to use         
CO_filter<=NO_coeff when sw=x"0" else
           LPF_coeff when sw=x"1" else
           HPF_coeff when sw=x"2" else
           BSF_coeff when sw=x"4" else
           BPF_coeff when sw=x"8" else
           (others=>(others=>'0'));
           
filter_type<=NO_F when sw=x"0" else
             LPF when sw=x"1" else
             HPF when sw=x"2" else
             BSF when sw=x"4" else
             BPF when sw=x"8" else
             NO_F;

process(clk,reset)
begin
if reset='1' then
    count<=0;
elsif rising_edge(clk) then
        for i in 80 downto 0 loop
            mul(i)<=sample_in*signed(CO_filter(i));
                if i<80 then
                     sum(i)<=sum(i+1)+mul(i);
                else
                    sum(i)<=mul(i);
                end if;
            count<=i;
        end loop;
            if count<80 then
            count<=count+1;
            else
            count<=0;
            end if;
        hn<=CO_filter(count);  
end if;
end process;
end Behavioral;
