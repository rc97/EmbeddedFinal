library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm is
    Port ( clk : in STD_LOGIC;
           power : in STD_LOGIC_VECTOR (7 downto 0);
           sig : out STD_LOGIC);
end pwm;

architecture pwm of pwm is
    signal count: unsigned(7 downto 0) := (others => '0');
begin
    process(clk) begin
        if rising_edge(clk) then
            if count = to_unsigned(254, 8) then
                count <= (others => '0');
            else
                count <= count + to_unsigned(1, 8);
            end if;
        end if;
    end process;
    sig <= '1' when count < unsigned(power) else '0';
end pwm;
