library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

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
	  if(ciphertext_arr(i) /= sp_simon_out) then report "Incorrect ciphertext. " & integer'image(i) & ": ACTUAL: "
																			   & std_logic'image(ciphertext_arr(i)(31))
																			   & std_logic'image(ciphertext_arr(i)(30))
																			   & std_logic'image(ciphertext_arr(i)(29))
																			   & std_logic'image(ciphertext_arr(i)(28))
																			   & std_logic'image(ciphertext_arr(i)(27))
																			   & std_logic'image(ciphertext_arr(i)(26))
																			   & std_logic'image(ciphertext_arr(i)(25))
																			   & std_logic'image(ciphertext_arr(i)(24))
																			   & std_logic'image(ciphertext_arr(i)(23))
																			   & std_logic'image(ciphertext_arr(i)(22))
																			   & std_logic'image(ciphertext_arr(i)(21))
																			   & std_logic'image(ciphertext_arr(i)(20))
																			   & std_logic'image(ciphertext_arr(i)(19))
																			   & std_logic'image(ciphertext_arr(i)(18))
																			   & std_logic'image(ciphertext_arr(i)(17))
																			   & std_logic'image(ciphertext_arr(i)(16))
																			   & std_logic'image(ciphertext_arr(i)(15))
																			   & std_logic'image(ciphertext_arr(i)(14))
																			   & std_logic'image(ciphertext_arr(i)(13))
																			   & std_logic'image(ciphertext_arr(i)(12))
																			   & std_logic'image(ciphertext_arr(i)(11))
																			   & std_logic'image(ciphertext_arr(i)(10))
																			   & std_logic'image(ciphertext_arr(i)(9))
																			   & std_logic'image(ciphertext_arr(i)(8))
																			   & std_logic'image(ciphertext_arr(i)(7))
																			   & std_logic'image(ciphertext_arr(i)(6))
																			   & std_logic'image(ciphertext_arr(i)(5))
																			   & std_logic'image(ciphertext_arr(i)(4))
																			   & std_logic'image(ciphertext_arr(i)(3))
																			   & std_logic'image(ciphertext_arr(i)(2))
																			   & std_logic'image(ciphertext_arr(i)(1))
																			   & std_logic'image(ciphertext_arr(i)(0))
																			   & " vs COMPUTED: " & std_logic'image(sp_simon_out(31))
																			   & std_logic'image(sp_simon_out(30))
																			   & std_logic'image(sp_simon_out(29))
																			   & std_logic'image(sp_simon_out(28))
																			   & std_logic'image(sp_simon_out(27))
																			   & std_logic'image(sp_simon_out(26))
																			   & std_logic'image(sp_simon_out(25))
																			   & std_logic'image(sp_simon_out(24))
																			   & std_logic'image(sp_simon_out(23))
																			   & std_logic'image(sp_simon_out(22))
																			   & std_logic'image(sp_simon_out(21))
																			   & std_logic'image(sp_simon_out(20))
																			   & std_logic'image(sp_simon_out(19))
																			   & std_logic'image(sp_simon_out(18))
																			   & std_logic'image(sp_simon_out(17))
																			   & std_logic'image(sp_simon_out(16))
																			   & std_logic'image(sp_simon_out(15))
																			   & std_logic'image(sp_simon_out(14))
																			   & std_logic'image(sp_simon_out(13))
																			   & std_logic'image(sp_simon_out(12))
																			   & std_logic'image(sp_simon_out(11))
																			   & std_logic'image(sp_simon_out(10))
																			   & std_logic'image(sp_simon_out(9))
																			   & std_logic'image(sp_simon_out(8))
																			   & std_logic'image(sp_simon_out(7))
																			   & std_logic'image(sp_simon_out(6))
																			   & std_logic'image(sp_simon_out(5))
																			   & std_logic'image(sp_simon_out(4))
																			   & std_logic'image(sp_simon_out(3))
																			   & std_logic'image(sp_simon_out(2))
																			   & std_logic'image(sp_simon_out(1))
																			   & std_logic'image(sp_simon_out(0));
		end if;
    end loop;  -- i
	wait until done = '1';



	assert FALSE Report "SIMULATION FINISHED."severity note;
	wait;

  end process;
end;
