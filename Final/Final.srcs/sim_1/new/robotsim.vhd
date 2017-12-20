library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity robotsim is
--  Port ( );
end robotsim;

architecture Behavioral of robotsim is

component uart is port (
	clk, en, send, rx, rst : in std_logic;
    charSend : in std_logic_vector (7 downto 0);
  	ready, tx, newChar : out std_logic;
  	charRec : out std_logic_vector (7 downto 0)
);
end component;

component robot is port ( 
    clk, rst : in STD_LOGIC;
    rxd : out STD_LOGIC;
    txd : in STD_LOGIC;
    en1, en2, dir1, dir2 : out STD_LOGIC
);
end component;

component clock_div is
port (
  clk : in std_logic;
  div : out std_logic
);
end component;

signal clk, en, send: std_logic;
signal msg : std_logic_vector (7 downto 0);
signal tx, rx : std_logic;
signal en1, en2, dir1, dir2 : std_logic;
begin

cd: clock_div port map(
    clk => clk,
    div => en
);

uart0: uart port map(
    clk => clk,
    en => en,
    send => send,
    charSend => msg,
    rx => rx,
    rst => '0',
    tx => tx
);

bot: robot port map(
    clk => clk,
    rst => '0',
    txd => tx,
    rxd => rx,
    en1 => en1,
    en2 => en2,
    dir1 => dir1,
    dir2 => dir2
);

process begin
    msg <= "01110111";
    send <= '1';
    for i in 0 to 100000000 loop
        clk <= '1';
        wait for 4 ns;
        clk <= '0';
        wait for 4 ns;
    end loop;
end process;

end Behavioral;
