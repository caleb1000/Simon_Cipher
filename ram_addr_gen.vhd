library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_addr_gen is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        valid     : in std_logic;
        output : out std_logic_vector(4 downto 0)); --32 values
end ram_addr_gen;

architecture BHV of ram_addr_gen is

--signals

signal count : unsigned(4 downto 0);
--by using unsigned the wrapping is automatically handled
begin

process(clk, rst)

begin

if (rst = '1') then

count <="00000";

elsif (clk'event and clk = '1') then



            if(valid = '1') then
            count <= count+1;
            --active low count up


            else
            count <= count; -- I might not need this line but it helps clarity
              

    end if;


end if;


end process;

output <= std_logic_vector(count);

end BHV;
