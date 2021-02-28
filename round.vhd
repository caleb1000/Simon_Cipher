--Jonathan Cruz
--University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity round is
    port(
        x	: in std_logic_vector(WORD_SIZE-1 downto 0); --most significant word of input
        y	: in std_logic_vector(WORD_SIZE-1 downto 0); -- least signficant word of input
	round_key : in std_logic_vector(WORD_SIZE-1 downto 0);
	round_out : out std_logic_vector(BLOCK_SIZE-1 downto 0)
    );

end round;

architecture BHV of round is


begin
    process(x,y,round_key)
	----------- your variables here -----------
  variable rotate_left1 : std_logic_vector (WORD_SIZE-1 downto 0);
	variable rotate_left8 : std_logic_vector (WORD_SIZE-1 downto 0);
  variable rotate_left2 : std_logic_vector (WORD_SIZE-1 downto 0);
  variable and18 : std_logic_vector (WORD_SIZE-1 downto 0);
  variable xor1 : std_logic_vector (WORD_SIZE-1 downto 0);
  variable xor2 : std_logic_vector (WORD_SIZE-1 downto 0);
    variable  xor3 : std_logic_vector (WORD_SIZE-1 downto 0);


  begin
	----------- your code here -----------

      rotate_left1 := std_logic_vector(unsigned(x) rol 1);
      rotate_left8 := std_logic_vector(unsigned(x) rol 8);
      rotate_left2 := std_logic_vector(unsigned(x) rol 2);
      and18 := rotate_left1 AND rotate_left8;
      xor1 := y XOR and18;
      xor2 := rotate_left2 XOR xor1;
      xor3 := round_key XOR xor2;

      round_out <= xor3 & x; -- the upper is the new X and the lower is the old X



    end process;
end BHV;
