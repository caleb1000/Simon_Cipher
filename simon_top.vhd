--Jonathan Cruz
--University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity simon_top is
  port(
	clk	: in std_logic;
	rst	: in std_logic;
	go	: in std_logic;
	valid : out std_logic; --denotes output is valid.
	done : out std_logic);

end simon_top;

architecture STR of simon_top is

signal simon_out : std_logic_vector(BLOCK_SIZE-1 downto 0); -- map to output of your simon cipher instance. DO NOT TOUCH
----------- your signals here -----------


signal ROM_OUT    : std_logic_vector (63 downto 0);
signal IN_RAM_OUT : std_logic_vector (31 downto 0);
signal CONTROLLER_ROUND_COUNT : std_logic_vector(4 downto 0);
signal X_MUX_SEL : std_logic_vector (1 downto 0);
signal Y_MUX_SEL : std_logic_vector (1 downto 0);
signal KEY_EN : std_logic;
signal X_EN : std_logic;
signal Y_EN : std_logic;
signal VALID_BIT : std_logic;
signal IN_RAM_ADD : std_logic_vector(4 downto 0);
signal OUT_RAM_ADD : std_logic_vector(4 downto 0);
signal OUT_RAM_WRITE_EN : std_logic;

begin
----------- your code here -----------
sp_simon_out <= simon_out; --for testbench to work, this signal assignment is needed. DO NOT TOUCH

SIMON_ENT : entity work.simon
  port map(
	clk	=> clk,
	rst	=> rst,
	key_in => ROM_OUT,
	input	=> IN_RAM_OUT,
	round_count  => CONTROLLER_ROUND_COUNT ,
	mux_x_sel   => X_MUX_SEL   ,
  mux_y_sel  => Y_MUX_SEL     ,
	ff_key_en  => KEY_EN   ,
  ff_x_en   => X_EN     ,
  ff_y_en   => Y_EN     ,
	output	=>  simon_out);

IN_RAM_ADD_GEN : entity work.ram_addr_gen
    port map(
        clk   => clk,
        rst   => rst,
        valid => VALID_BIT,
        output => IN_RAM_ADD);

OUT_RAM_ADD_GEN : entity work.ram_addr_gen
    port map(
        clk   => clk,
        rst   => rst,
        valid => VALID_BIT,
        output => OUT_RAM_ADD);

SIMON_CONTROLLER : entity work.controller
  port map(
	clk	=> clk,
	rst	=> rst,
	go	=> go,
	round_count => CONTROLLER_ROUND_COUNT,
	done	=> done,
	mux_x_sel => X_MUX_SEL,
	mux_y_sel => y_MUX_SEL,
	ff_key_en => KEY_EN,
	ff_x_en  => X_EN,
	ff_y_en => Y_EN,
	addr_in	=> IN_RAM_ADD,
	valid	 => VALID_BIT,
	out_ram_wren => OUT_RAM_WRITE_EN	);

INPUT_RAM : entity work.inram
port map(
address => IN_RAM_ADD,
clock => clk,
data => "00000000000000000000000000000000",
wren => '0',
q => IN_RAM_OUT);

OUTPUT_RAM : entity work.outram
port map(
address => OUT_RAM_ADD,
clock => clk,
data => simon_out ,
wren => OUT_RAM_WRITE_EN,
q => open);

KEY_ROM : entity work.keyrom
port map(
address => "0",
clock => clk,
q => ROM_OUT);


valid <= VALID_BIT;



end STR;
