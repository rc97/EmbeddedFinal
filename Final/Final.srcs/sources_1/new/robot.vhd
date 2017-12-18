library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity robot is port ( 
    clk, rst : in STD_LOGIC;
    rxd : out STD_LOGIC;
    txd : in STD_LOGIC;
    en1, en2, dir1, dir2 : out STD_LOGIC
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
    
    signal sp1: unsigned(7 downto 0);
    signal sp2: unsigned(7 downto 0);
    signal div: std_logic;
    signal newChar: std_logic := '0';
    signal charRec: std_logic_vector(7 downto 0);
    
    signal speed: unsigned(7 downto 0) := to_unsigned(200, 8);
    
    type state is (u, d, l, r, s);
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
                    when "01110101" => -- u
                        curr <= u;
                    when "01100100" => -- d
                        curr <= d;
                    when "01101100" => -- l
                        curr <= l;
                    when "01110010" => -- r
                        curr <= r;
                    when others =>
                        curr <= s;
                end case;
            end if;
            case curr is
                when s =>
                    sp1 <= (others => '0');
                    sp2 <= (others => '0');
                when u =>
                    sp1 <= speed;
                    sp2 <= speed;
                    en1 <= '1';
                    en2 <= '0';
                when d =>
                    sp1 <= speed;
                    sp2 <= speed;
                    en1 <= '0';
                    en2 <= '1';
                when l =>
                    sp1 <= speed;
                    sp2 <= speed;
                    en1 <= '1';
                    en2 <= '1';
                when r =>
                    sp1 <= speed;
                    sp2 <= speed;
                    en1 <= '0';
                    en2 <= '0';
            end case;
        end if;
    end process;

end bot;