library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx is port (
    clk, en, send, rst : in std_logic;
    char : in std_logic_vector (7 downto 0);
    ready, tx : out std_logic
);
end uart_tx;

architecture t of uart_tx is
    type state is (idle, start, sending, stop);
	signal curr : state := idle;
	
	signal count: unsigned(2 downto 0) := to_unsigned(0, 3);
	signal sendChar: std_logic_vector(7 downto 0) := (others => '0');
begin

    process(clk) begin
        if rst = '1' then
            curr <= idle;
            tx <= '1';
            ready <= '1';
            count <= to_unsigned(0, 3);
        elsif rising_edge(clk) and en = '1' then
            case curr is
                when idle =>
                    tx <= '1';
                    ready <= '1';
                    if send = '1' then
                        sendChar <= char;
                        curr <= start;
                    end if;
                when start =>
                    tx <= '0';
                    ready <= '0';
                    curr <= sending;
                when sending =>
                    tx <= sendChar(to_integer(count));
                    ready <= '0';
                    if count = to_unsigned(7, 3) then
                        curr <= stop;
                        count <= to_unsigned(0, 3);
                    else
                        count <= count + 1;
                    end if;
                when stop =>
                    tx <= '1';
                    ready <= '0';
                    curr <= idle;
            end case;
        end if;
    end process;

end t;
