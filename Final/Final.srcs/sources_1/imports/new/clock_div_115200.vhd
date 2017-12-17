library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_div is
port (
  clk : in std_logic;
  div : out std_logic
);
end clock_div;

architecture cnt of clock_div is
  signal count : std_logic_vector (10 downto 0) := (others => '0');
begin

  process(count) begin
    if count = std_logic_vector(to_unsigned(1085, 11)) then
        div <= '1';
    else
        div <= '0';
    end if;
  end process;
  
  process(clk) begin
    if rising_edge(clk) then
      if count = std_logic_vector(to_unsigned(1085, 11)) then
        count <= (others => '0');
      else 
        count <= std_logic_vector( unsigned(count) + 1 );
      end if;
    end if;
  end process;
  
end cnt;