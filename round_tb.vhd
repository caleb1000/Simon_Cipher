library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity round_tb is
end round_tb;

architecture TB of round_tb is
  constant TIMEOUT : time     := 1 ms;
  type BLOCK_ARR is array (0 to 12) of std_logic_vector(31 downto 0);
  type WORD_ARR is array (0 to 11) of std_logic_vector(15 downto 0);
  signal x, y, round_key : std_logic_vector(15 downto 0);
  signal round_out : std_logic_vector(31 downto 0);
  signal round_key_arr : WORD_ARR := (X"0100", X"0908",X"1110", X"1918", X"71C3", X"B649", X"56D4", X"E070", X"F15A", X"C535", X"DD94", X"4010");
  signal round_out_arr : BLOCK_ARR := (X"C4F63807", X"AA18C4F6", X"75BCAA18", X"C58975BC", X"F382C589", X"F840F382", X"E448F840", X"7737E448", X"FE837737", X"FD64FE83", X"AEECFD64", X"D7CAAEEC", X"3B42D7CA");
begin

  U_ROUND : entity work.round
     port map(
     x =>x,
	 y =>y,
	 round_key => round_key,
	 round_out => round_out);
 
  
  process
  begin
    
    for i in 0 to 11 loop
      x<=round_out_arr(i)(31 downto 16);
	  y<=round_out_arr(i)(15 downto 0);
	  round_key<= round_key_arr(i);
	  wait for 10ns;
	  if(round_out /= round_out_arr(i+1)) then report "Incorrect round at " & integer'image(i);
	  end if;
    end loop;  -- i

	assert FALSE Report "SIMULATION FINISHED."severity note;
	
	wait;
    
  end process;
end;
