library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;
library std;            
use std.textio.all;

entity simon_top_tb is
end simon_top_tb;

architecture TB of simon_top_tb is
  constant TIMEOUT : time     := 1 ms;
  type BLOCK_ARR is array (0 to 31) of std_logic_vector(31 downto 0);
  signal clk, rst, go : std_logic := '0';
  signal done, valid: std_logic;
  signal ciphertext_arr : BLOCK_ARR := (X"3B42D7CA", X"F22C67C7", X"CF8995F3", X"B58D4FF1", X"CA675E35", X"955CD36F", X"67FFA256", X"F434E93E", 
										X"53D226DA", X"E3B899CF", X"2E4325C2", X"7DFCBE23", X"165A8BB7", X"2AD07732", X"A1A939E4", X"E1AB3354", 
										X"3F8197B7", X"01A77124", X"1587E901", X"B7E32E82", X"01BB30E7", X"591BF1D1", X"82971AC5", X"A0A27E77", 
										X"924A79BB", X"5D4C1181", X"32F75F94", X"570E32B3", X"E3FFAAF0", X"499E3868", X"AB52F1C6", X"37F45F83");
begin

  U_SIMON_CIPHER : entity work.simon_top(STR)
    port map (
      clk    => clk,
      rst    => rst,
      go     => go,
	  done   => done,
	  valid  => valid);
  
 
  
  clk <= not clk after 5 ns;

  process
  begin
    rst <= '1';
    go  <= '0';
    for i in 0 to 5 loop
      wait until clk'event and clk = '1';
    end loop;  -- i

    rst <= '0';
    wait until clk'event and clk = '1';
    go<='1';

	wait until clk'event and clk = '1';
	for i in 0 to 31 loop
      wait until valid = '1' for TIMEOUT;
	  wait until clk'event and clk = '0';
	  --sp_simon_out needs to be assigned in simon_top
	  if(ciphertext_arr(i) /= sp_simon_out) then 
	     report "Incorrect ciphertext. ACTUAL: " & to_hstring(ciphertext_arr(i)) & " vs COMPUTED: " & to_hstring(sp_simon_out) severity error;
	  end if;
    end loop;  -- i
	wait until done = '1';
	
	assert FALSE Report "SIMULATION FINISHED."severity note;
	
	wait;
    
  end process;
end;
