--Jonathan Cruz
--University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity key_expansion is
    port(
	key_in	: in std_logic_vector(2*BLOCK_SIZE-1 downto 0); -- {round_key[i+3], round_key[i+2], round_key[i+1], round_key[i]}
	round_count : in std_logic_vector(4 downto 0); -- current round
	key_out	: out std_logic_vector(WORD_SIZE-1 downto 0) -- round_key[i+4]
    );

end key_expansion;

architecture BHV of key_expansion is
----------- your signals here -----------

begin

    process(key_in, round_count)
	  variable zvar : std_logic_vector(0 downto 0);  --Z Variable. Defined in constants.vhd
	  constant c : std_logic_vector(WORD_SIZE-1 downto 0) := X"0003"; -- Constant C
	  ----------- your variables here -----------
	  variable rotate_right3 : std_logic_vector (WORD_SIZE-1 downto 0);
    variable xor1 : std_logic_vector (WORD_SIZE-1 downto 0);
    variable rotate_right1 : std_logic_vector (WORD_SIZE-1 downto 0);
    variable not1 : std_logic_vector (WORD_SIZE-1 downto 0);
    variable xor2 : std_logic_vector (WORD_SIZE-1 downto 0);
    variable xor3 : std_logic_vector (WORD_SIZE-1 downto 0);
    variable xor4 : std_logic_vector (WORD_SIZE-1 downto 0);
    variable xor5 : std_logic_vector (WORD_SIZE-1 downto 0);
    variable temp  : integer;
    begin


--I could put the key_in values in terms of block_size to make it generic

    ----------- your code here -----------
       rotate_right3 := std_logic_vector(unsigned(key_in(63 downto 48)) ror 3);
       xor1 := rotate_right3 XOR key_in(31 downto 16);
       not1 := NOT(key_in(15 downto 0));
       rotate_right1 := std_logic_vector(unsigned(xor1) ror 1);
       xor2 := xor1 XOR rotate_right1;
       xor3 := xor2 XOR not1;
       temp := to_integer((unsigned(round_count)-4) mod 62);
       zvar :=  z(temp downto temp) ;
       xor4 := xor3 XOR ("000000000000000" & zvar); -- z(i-4)
       xor5 := xor4 XOR c;
       key_out <= xor5;
    end process;



end BHV;
