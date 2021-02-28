--Jonathan Cruz
--University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity simon is
    port(
	clk	: in std_logic;
	rst	: in std_logic;
	key_in	: in std_logic_vector(2*BLOCK_SIZE-1 downto 0); --key input
	input	: in std_logic_vector(BLOCK_SIZE-1 downto 0); --plaintext or ciphertext
	round_count : in std_logic_vector(4 downto 0); -- current round count
	mux_x_sel, mux_y_sel : in std_logic_vector(1 downto 0); --control for muxes
	ff_key_en, ff_x_en, ff_y_en : in std_logic; --enable for FFs
	output	: out std_logic_vector(BLOCK_SIZE-1 downto 0)); --final plaintext or ciphertext
end simon;

architecture datapath of simon is
----------- your signals here -----------
type KEY_EXPANSION_ARR is array (0 to N_ROUNDS-1) of std_logic_vector(WORD_SIZE-1 downto 0);
type ROUND_COUNT_ARR is array (0 to N_ROUNDS-1) of std_logic_vector(4 downto 0);
signal round_key : KEY_EXPANSION_ARR ; --round keys
signal round_count_index : ROUND_COUNT_ARR ; --index for round keys


signal key_dff_out : std_logic_vector(63 downto 0) := (others => '0'); --set others to zero
signal x_dff_out : std_logic_vector(15 downto 0) := (others => '0');
signal y_dff_out : std_logic_vector(15 downto 0) := (others => '0');
signal x_mux_out : std_logic_vector(15 downto 0) := (others => '0');
signal y_mux_out : std_logic_vector(15 downto 0) := (others => '0');
signal round_out_high : std_logic_vector(15 downto 0) := (others => '0');
signal round_out_low : std_logic_vector(15 downto 0) := (others => '0');
signal round_out     : std_logic_vector (31 downto 0) := (others => '0');
signal round_key_temp : std_logic_vector (WORD_SIZE-1 downto 0) := (others => '0');
--signal temp1 : std_logic_vector (15 downto 0) := (others => '0');
--signal temp2 : std_logic_vector (15 downto 0) := (others => '0');
--signal temp3 : std_logic_vector (15 downto 0) := (others => '0');
--signal temp4 : std_logic_vector (15 downto 0) := (others => '0');
--signal CAT_B : std_logic_vector (63 downto 0) := (others => '0');
--add signals here

signal hold :std_logic_vector(191 downto 0) := (others => '0');
--(rounds * key length) -1
--added NEw
--ADD GENERIC VALUES FOR INDEXING
begin


-----initialize round keys taken from input here-------

round_key(0) <= key_in(15 downto 0); --word size-1
round_key(1) <= key_in(31 downto 16);
round_key(2) <= key_in(47 downto 32);
round_key(3) <= key_in(63 downto 48);

hold(15 downto 0)<= key_in(15 downto 0);
hold(31 downto 16)<= key_in(31 downto 16);
hold(47 downto 32)<= key_in(47 downto 32);
hold(63 downto 48)<= key_in(63 downto 48);
--ADDED NEW

--round_key(4) <= X"71C3";
--round_key(5) <= X"B649";
--round_key(6) <= X"56D4";
--round_key(7) <= X"E070";
--round_key(8) <= X"F15A";
--round_key(9) <= X"C535";
--round_key(10)<= X"DD94";
--round_key(11)<= X"4010";

--round count array for key expansion
round_count_index <= ("00000","00001","00010", "00011","00100","00101","00110","00111",
                "01000","01001","01010","01011"); -- from 0 to 11 for the 12 rounds

-- generate round keys
GEN_ROUND_KEYS: for i in 4 to N_ROUNDS-1 generate
----------- your code here -----------
--temp1 <= round_key(i-1);
--temp2 <= round_key(i-2);
--temp3 <= round_key(i-3);
--temp4 <= round_key(i-4);
--CAT_B <= temp1 & temp2 & temp3 & temp4;



U_GEN: entity work.key_expansion port map (
--key_in => CAT_B,
--round_count => round_count_index(i),
--key_out => round_key(i)


key_in => hold((i)*16 -1 downto (i-4)*16),
round_count => round_count_index(i),
key_out => hold((i+1)*16-1 downto (i+1)*16 - 16)
--ADDED NEW

); --fills the round_key array with the values

round_key(i) <= hold((i+1)*16-1 downto (i+1)*16 - 16);
--added NEW

end generate GEN_ROUND_KEYS;

----------- your code here -----------

X_DFF : entity work.reg
    generic map (
      width => 16)
    port map(
          clk => clk,
          rst => rst,
          load => ff_x_en,
          input => x_mux_out,
          output => x_dff_out);

Y_DFF : entity work.reg
    generic map (
      width => 16)
    port map(
          clk => clk,
          rst => rst,
          load => ff_y_en,
          input => y_mux_out,
          output => y_dff_out);

KEY_DFF : entity work.reg
    generic map (
      width => 64)
    port map(
          clk => clk,
          rst => rst,
          load => ff_key_en,
          input => key_in,
          output => key_dff_out);

X_MUX : entity work.mux4_1

      port map(
                in1 => round_out_low,
                in2 => round_out_high,
                in3 => input(15 downto 0),
                in4 => input(31 downto 16),

                sel => mux_x_sel,
                output => x_mux_out);

Y_MUX : entity work.mux4_1

      port map(
                in1 => round_out_low,
                in2 => round_out_high,
                in3 => input(15 downto 0),
                in4 => input(31 downto 16),

                sel => mux_y_sel,
                output => y_mux_out);

SPLIT_ROUND : entity work.split
     -- 11 10 01 00
        port map(
           high => round_out_high,
           low =>  round_out_low,
           input => round_out

         );


round_key_temp <= round_key(to_integer(unsigned(round_count)));
ROUND_ENT : entity work.round
        port map (
             x => x_dff_out,
             y => y_dff_out,

             round_key => round_key_temp,
             round_out => round_out
            );

CAT_ENT : entity work.cat
port map (
        input1 => x_dff_out,
        input2 => y_dff_out,
        output => output
);



end datapath;
