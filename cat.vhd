library ieee;
use ieee.std_logic_1164.all;

entity cat is

  port (

    input1  : in  std_logic_vector(15 downto 0); --x
    input2  : in  std_logic_vector(15 downto 0); --y
    output : out std_logic_vector(31 downto 0));

end cat;


architecture BHV of cat is
begin

      output <= input1 & input2;

end BHV;
