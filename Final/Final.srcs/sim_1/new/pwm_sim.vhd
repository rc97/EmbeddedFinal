library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_sim is
--  Port ( );
end pwm_sim;

architecture Behavioral of pwm_sim is

    component pwm is port ( 
        clk : in STD_LOGIC;
        power : in STD_LOGIC_VECTOR (7 downto 0);
        sig : out STD_LOGIC);
    end component;
    signal clk : std_logic;
    signal power : unsigned(7 downto 0);
    signal sig : std_logic;

begin
    pwm_map: pwm port map(
        clk => clk,
        power => std_logic_vector(power),
        sig => sig);
    
    process begin
        power <= (others => '0');
        for i in 0 to 1000 loop
            clk <= '1';
            wait for 0.5 ns;
            clk <= '0';
            wait for 0.5 ns;
        end loop;
        power <= to_unsigned(100, 8);
        for i in 0 to 1000 loop
            clk <= '1';
            wait for 0.5 ns;
            clk <= '0';
            wait for 0.5 ns;
        end loop;
        power <= to_unsigned(200, 8);
        for i in 0 to 1000 loop
            clk <= '1';
            wait for 0.5 ns;
            clk <= '0';
            wait for 0.5 ns;
        end loop;
        power <= to_unsigned(255, 8);
        for i in 0 to 1000 loop
            clk <= '1';
            wait for 0.5 ns;
            clk <= '0';
            wait for 0.5 ns;
        end loop;
    end process;    

end Behavioral;
