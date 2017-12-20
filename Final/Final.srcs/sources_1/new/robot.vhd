library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity robot is port ( 
    clk, rst : in STD_LOGIC;
    rxd : out STD_LOGIC;
    txd : in STD_LOGIC;
    en1, en2, dir1, dir2 : out STD_LOGIC;
    led : out STD_LOGIC_VECTOR(3 downto 0)
);
end robot;

architecture bot of robot is
    component uart is port (
        clk, en, send, rx, rst : in std_logic;
        charSend : in std_logic_vector (7 downto 0);
        ready, tx, newChar : out std_logic;
        charRec : out std_logic_vector (7 downto 0)
    );
    end component;
    
    component pwm is port ( 
        clk : in STD_LOGIC;
        power : in STD_LOGIC_VECTOR (7 downto 0);
        sig : out STD_LOGIC);
    end component;
    
    component clock_div is port (
      clk : in std_logic;
      div : out std_logic);
    end component;
    
    signal sp1: unsigned(7 downto 0) := (others => '0');
    signal sp2: unsigned(7 downto 0) := (others => '0');
    signal div: std_logic;
    signal newChar: std_logic := '0';
    signal charRec: std_logic_vector(7 downto 0);
    
    constant speed: unsigned(7 downto 0) := to_unsigned(225, 8);
    constant minSpeed: unsigned(7 downto 0) := to_unsigned(100, 8);
    constant increment: unsigned(7 downto 0) := to_unsigned(2, 8);
    
    type state is (s, u, d, l, r, ul, ur, dl, dr, 
                   au, ad, al, ar, aul, aur, adl, adr);
    signal curr: state := s;

begin
    pwm1: pwm port map(
        clk => clk,
        power => std_logic_vector(sp1),
        sig => en1);
        
    pwm2: pwm port map(
        clk => clk,
        power => std_logic_vector(sp2),
        sig => en2);
    
    cd115200: clock_div port map(
        clk => clk,
        div => div);
    
    uart_dut: uart port map(
        clk => clk,
        rst => rst,
        en => div,
        rx => txd,
        tx => rxd,
        send => '0',
        newChar => newChar,
        charSend => (others => '0'),
        charRec => charRec);
    
    process(clk) begin
        if rst = '1' then
            curr <= s;
        elsif rising_edge(clk) then
            if newChar = '1' then
                case charRec is
                    when "00110001" => -- down left
                        curr <= dl;
                    when "00110010" => -- down
                        curr <= d;
                    when "00110011" => -- down right
                        curr <= dr;
                    when "00110100" => -- left
                        curr <= l;
                    when "00110101" => -- stop
                        curr <= s;
                    when "00110110" => -- right
                        curr <= r;
                    when "00110111" => -- up left
                        curr <= ul;
                    when "00111000" => -- up
                        curr <= u;
                    when "00111001" => -- up right
                        curr <= ur;
                    when "01111010" => -- z, acc down left
                        curr <= adl;
                    when "01111000" => -- x, acc down
                        curr <= ad;
                    when "01100011" => -- c, acc down right
                        curr <= adr;
                    when "01100001" => -- a, acc left
                        curr <= al;
                    when "01100100" => -- d, acc right
                        curr <= ar;
                    when "01110001" => -- q, acc up left
                        curr <= aul;
                    when "01110111" => -- w, acc up
                        curr <= au;
                    when "01100101" => -- e, acc up right
                        curr <= aur;
                    when others =>
                        curr <= curr;
                end case;
            end if;
            -- right wheel is 1, left wheel is 2, 0 goes forward
            case curr is
                when s =>
                    led <= "0000";
                    sp1 <= (others => '0');
                    sp2 <= (others => '0');
                when u =>
                    sp1 <= speed;
                    sp2 <= speed;
                    dir1 <= '0';
                    dir2 <= '0';
                when d =>
                    sp1 <= speed;
                    sp2 <= speed;
                    dir1 <= '1';
                    dir2 <= '1';
                when l =>
                    sp1 <= speed;
                    sp2 <= speed;
                    dir1 <= '1';
                    dir2 <= '0';
                when r =>
                    sp1 <= speed;
                    sp2 <= speed;
                    dir1 <= '0';
                    dir2 <= '1';
                when ul => 
                    sp1 <= (others => '0');
                    sp2 <= speed;
                    dir2 <= '0';
                when ur =>
                    sp1 <= speed;
                    sp2 <= (others => '0');
                    dir1 <= '0';
                when dl => 
                    sp1 <= (others => '0');
                    sp2 <= speed;
                    dir2 <= '1';
                when dr =>
                    sp1 <= speed;
                    sp2 <= (others => '0');
                    dir1 <= '1';
                when au =>
                    if sp1 < minSpeed then
                        led <= "0001";
                        sp1 <= minSpeed;
                    elsif ((sp1 + increment) < speed) then
                        led <= "1010";
                        sp1 <= sp1 + increment; 
                    else 
                        led <= "0100";
                        sp1 <= speed;
                    end if;
                    if sp2 < minSpeed then
                        sp2 <= minSpeed;
                    elsif ((sp2 + increment) < speed) then
                        sp2 <= sp2 + increment; 
                    else 
                        sp2 <= speed;
                    end if;
                    dir1 <= '0';
                    dir2 <= '0';
                when ad =>
                    if sp1 < minSpeed then
                        sp1 <= minSpeed;
                    elsif ((sp1 + increment) < speed) then
                        sp1 <= sp1 + increment; 
                    else 
                        sp1 <= speed;
                    end if;
                    if sp2 < minSpeed then
                        sp2 <= minSpeed;
                    elsif ((sp2 + increment) < speed) then
                        sp2 <= sp2 + increment; 
                    else 
                        sp2 <= speed;
                    end if;
                    dir1 <= '1';
                    dir2 <= '1';
                when al =>
                    if sp1 < minSpeed then
                        sp1 <= minSpeed;
                    elsif ((sp1 + increment) < speed) then
                        sp1 <= sp1 + increment; 
                    else 
                        sp1 <= speed;
                    end if;
                    if sp2 < minSpeed then
                        sp2 <= minSpeed;
                    elsif ((sp2 + increment) < speed) then
                        sp2 <= sp2 + increment; 
                    else 
                        sp2 <= speed;
                    end if;
                    dir1 <= '1';
                    dir2 <= '0';
                when ar =>
                    if sp1 < minSpeed then
                        sp1 <= minSpeed;
                    elsif ((sp1 + increment) < speed) then
                        sp1 <= sp1 + increment; 
                    else 
                        sp1 <= speed;
                    end if;
                    if sp2 < minSpeed then
                        sp2 <= minSpeed;
                    elsif ((sp2 + increment) < speed) then
                        sp2 <= sp2 + increment; 
                    else 
                        sp2 <= speed;
                    end if;
                    dir1 <= '0';
                    dir2 <= '1';
                when aul => 
                    sp1 <= (others => '0');
                    if sp2 < minSpeed then
                        sp2 <= minSpeed;
                    elsif ((sp2 + increment) < speed) then
                        sp2 <= sp2 + increment; 
                    else 
                        sp2 <= speed;
                    end if;
                    dir2 <= '0';
                when aur =>
                    if sp1 < minSpeed then
                        sp1 <= minSpeed;
                    elsif ((sp1 + increment) < speed) then
                        sp1 <= sp1 + increment; 
                    else 
                        sp1 <= speed;
                    end if;
                    sp2 <= (others => '0');
                    dir1 <= '0';
                when adl => 
                    sp1 <= (others => '0');
                    if sp2 < minSpeed then
                        sp2 <= minSpeed;
                    elsif ((sp2 + increment) < speed) then
                        sp2 <= sp2 + increment; 
                    else 
                        sp2 <= speed;
                    end if;
                    dir2 <= '1';
                when adr =>
                    if sp1 < minSpeed then
                        sp1 <= minSpeed;
                    elsif ((sp1 + increment) < speed) then
                        sp1 <= sp1 + increment; 
                    else 
                        sp1 <= speed;
                    end if;
                    sp2 <= (others => '0');
                    dir1 <= '1';
            end case;
        end if;
    end process;

end bot;
