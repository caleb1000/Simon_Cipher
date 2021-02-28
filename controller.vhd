--Jonathan Cruz
--University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity controller is
    port(
	clk	: in std_logic;
	rst	: in std_logic;
	go	: in std_logic;
	round_count : out std_logic_vector(4 downto 0); --round count signal
	done	: out std_logic;
	mux_x_sel : out std_logic_vector(1 downto 0);
	mux_y_sel : out std_logic_vector(1 downto 0);
	ff_key_en : out std_logic;
	ff_x_en   : out std_logic;
	ff_y_en   : out std_logic;
	addr_in	: in std_logic_vector(4 downto 0); --address from input or output RAM
	valid	  : out std_logic;  -- data valid signal
	out_ram_wren : out std_logic	); --output RAM write enable

end controller;

architecture FSM2P of controller is
----------- your signals here -----------
    type STATE_TYPE is (WAIT_FOR_GO, LOAD_KEY,  S_ROUND, WRITE_RAM, S_DONE, DELAY_WR, S_CHECK, INC_COUNT, LOAD_INPUT, S_DONE2);
    signal state, next_state : STATE_TYPE;

    signal count_temp,count_temp_next : unsigned(4 downto 0) := "00000"; -- holds the count value

     -- wait for go to be assert aka WAIT_FOR_GO
    -- load key from ROM using DFF key, set count to 0, read input from the input RAM
    --one cycle delay for RAM read
begin
----------- your code for 2 Process FSM -----------

    process(clk, rst)
    begin
      if(rst = '1') then
          state <= WAIT_FOR_GO;
        elsif (clk'event and clk = '1') then
          state <= next_state;
			 			 count_temp <= count_temp_next;
        end if;
    end process;


   process (go, addr_in , state,count_temp)

   begin



	done	<= '0';
	mux_x_sel <= "00";
	mux_y_sel <= "00";
	ff_key_en <= '0';
	ff_x_en   <= '0';
	ff_y_en   <= '0';
	valid	  <= '0';
  out_ram_wren <= '0';

  next_state <= state;
  count_temp_next <= count_temp;

  case state is

   when  WAIT_FOR_GO =>
    if (go = '1') then
      next_state <= LOAD_KEY;
    else
      next_state <= WAIT_FOR_GO;
    end if;


    when  LOAD_KEY =>
             ff_key_en <= '1'; -- enable the rom read key, desert in next state
        count_temp_next <= "00000"; --set round count to zero

    --    mux_x_sel <= "11"; --select upper input ram bits
      --  mux_y_sel <= "10"; --select lower input ram bits
      --  ff_x_en   <= '1';
        --ff_y_en   <= '1';
--old state was S_CHECK
    next_state <= LOAD_INPUT;

when LOAD_INPUT =>
ff_key_en <= '0'; --de-assert
mux_x_sel <= "11"; --select upper input ram bits
mux_y_sel <= "10"; --select lower input ram bits
ff_x_en   <= '1';
ff_y_en   <= '1';

next_state <= S_CHECK;


 --check state
    when S_CHECK =>
          ff_key_en <= '0'; --de-assert
          if(count_temp_next < "01011") then
          --round_count <= std_logic_vector(count_temp);
          --if we are under round 12
          next_state <= S_ROUND;
          else
          count_temp_next <= "00000";

              ff_key_en <= '0'; --de-assert
              mux_x_sel <= "01"; --select upper split
              mux_y_sel <= "00"; --select lower split
              ff_x_en   <= '1';
            	ff_y_en   <= '1';

          --round_count <= std_logic_vector(count_temp);
          --send back to zero
          --if count_temp is 11 then we need to write to outram
          next_state <= WRITE_RAM;
          end if;

    when S_ROUND =>
        ff_key_en <= '0'; --de-assert
        mux_x_sel <= "01"; --select upper split
        mux_y_sel <= "00"; --select lower split
        ff_x_en   <= '1';
      	ff_y_en   <= '1';

    next_state <= INC_COUNT;


--inc count

  when INC_COUNT =>
      ff_key_en <= '0'; --de-assert
      count_temp_next <= count_temp_next + 1;
     --increment
      --round_count <= std_logic_vector(count_temp);
      next_state <= S_CHECK;


  when  WRITE_RAM =>
    ff_key_en <= '0'; --de-assert
     out_ram_wren <= '1'; --set write enable high
     if(addr_in = "11111") then
      next_state <= S_DONE;
      else
      next_state <=  DELAY_WR;
    end if;


when DELAY_WR =>

    ff_key_en <= '0'; --de-assert
     valid <= '1'; --Enable input and output address generators
      next_state <= LOAD_KEY;

 when  S_DONE =>
      ff_key_en <= '0'; --de-assert

     done <= '1'; --all inputs are encrypted
      next_state <= S_DONE2;

 when  S_DONE2 =>
      ff_key_en <= '0'; --de-assert

     done <= '0'; --all inputs are encrypted
     next_state <= S_DONE;

when others => null;
end case;
end process;

round_count <= std_logic_vector(count_temp);

end FSM2P;
