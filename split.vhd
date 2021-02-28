library ieee;
use ieee.std_logic_1164.all;

entity split is

  port (

    high  : out std_logic_vector(15 downto 0); -- high 31:16
    low  : out std_logic_vector(15 downto 0); -- low 15:0
    input : in std_logic_vector(31 downto 0));

end split;


architecture BHV of split is
begin

      high <= input(31 downto 16); --high
      low <= input(15 downto 0);  --low
end BHV;
