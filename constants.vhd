library ieee;
use ieee.std_logic_1164.all;

package constants is

constant WORD_SIZE : positive := 16;
constant BLOCK_SIZE : positive := 2*WORD_SIZE;
constant Z : std_logic_vector(61 downto 0) := "01100111000011010100100010111110110011100001101010010001011111";--11111010001001010110000111001101111101000100101011000011100110
constant M : positive :=4;
constant N_ROUNDS : positive :=12;

------ FOR TESTBENCH ------
signal sp_simon_out : std_logic_vector(31 downto 0);
end constants;
