library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity key_expansion_tb is
end key_expansion_tb;

architecture TB of key_expansion_tb is
  constant TIMEOUT : time     := 1 ms;
  type WORD_ARR is array (0 to 35) of std_logic_vector(15 downto 0);
  type COUNT_ARR is array (0 to 11) of std_logic_vector(4 downto 0);
  signal key_out : std_logic_vector(15 downto 0);
  signal key_in : std_logic_vector(63 downto 0);
  signal round_count : std_logic_vector(4 downto 0);
  signal round_count_index : COUNT_ARR := ("00000","00001","00010", "00011","00100","00101","00110","00111",
                "01000","01001","01010", "01011");
  signal round_key_arr : WORD_ARR := (X"0100", X"0908",X"1110", X"1918", X"71C3", X"B649", X"56D4", X"E070", X"F15A", X"C535", X"DD94", X"4010",
									  X"DEF0", X"9ABC", X"5678", X"1234", X"358A", X"FDEC", X"E2C8", X"50F3", X"167C", X"D214", X"32DC", X"F73B", 
									  X"7750", X"5214", X"4123", X"6589", X"495A", X"A1E5", X"87B1", X"DF0E", X"F1A1", X"3B5E", X"EC1B", X"EAC1");
begin

  U_KEY_EXP : entity work.key_expansion
     port map(
     key_in =>key_in,
	 round_count => round_count,
	 key_out => key_out);
 
  
  process
  begin
    
    for i in 4 to 11 loop
      key_in<=round_key_arr(i-1) & round_key_arr(i-2) & round_key_arr(i-3) & round_key_arr(i-4);
	  round_count<=round_count_index(i);
	  wait for 10ns;
	  if(key_out /= round_key_arr(i)) then report "Incorrect key expansion1 at round" & integer'image(i);
	  end if;
    end loop;  -- i

	for i in 16 to 23 loop
      key_in<=round_key_arr(i-1) & round_key_arr(i-2) & round_key_arr(i-3) & round_key_arr(i-4);
	  round_count<=round_count_index(i-12);
	  wait for 10ns;
	  if(key_out /= round_key_arr(i)) then report "Incorrect key expansion2 at round" & integer'image(i-10);
	  end if;
    end loop;  -- i
	
	for i in 28 to 35 loop
      key_in<=round_key_arr(i-1) & round_key_arr(i-2) & round_key_arr(i-3) & round_key_arr(i-4);
	  round_count<=round_count_index(i-24);
	  wait for 10ns;
	  if(key_out /= round_key_arr(i)) then report "Incorrect key expansion3 at round" & integer'image(i-20);
	  end if;
    end loop;  -- i
	
	assert FALSE Report "SIMULATION FINISHED."severity note;
	
	wait;
    
  end process;
end;
