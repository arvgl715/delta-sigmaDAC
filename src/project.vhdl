library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tt_um_Delta_Sigma_DAC is
    port (
        ui_in   : in  std_logic_vector(7 downto 0);
        uo_out  : out std_logic_vector(7 downto 0);
        uio_in  : in  std_logic_vector(7 downto 0);
        uio_out : out std_logic_vector(7 downto 0);
        uio_oe  : out std_logic_vector(7 downto 0);
        ena     : in  std_logic;
        clk     : in  std_logic;
        rst_n   : in  std_logic
    );
end tt_um_Delta_Sigma_DAC;

architecture Behavioral of tt_um_Delta_Sigma_DAC is

    constant offset : signed := "01100000000000000000";

    signal input : signed(15 downto 0) := (others => '0');
    signal offset_input : signed(19 downto 0) := (others => '0');
    signal filter_output : signed(19 downto 0) := (others => '0');
    signal output : signed(19 downto 0) := (others => '0');
    signal y : std_logic;
    signal filter_input_tmp : unsigned(17 downto 0) := (others => '0');
    signal filter_input : signed(18 downto 0) := (others => '0');

    signal delay0 : signed(19 downto 0) := (others => '0');
    signal delay1 : signed(18 downto 0) := (others => '0');
    signal delay2 : signed(18 downto 0) := (others => '0');
    signal delay3 : signed(18 downto 0) := (others => '0');
    signal delay4 : signed(18 downto 0) := (others => '0');
    signal delay5 : signed(18 downto 0) := (others => '0');
    signal delay6 : signed(18 downto 0) := (others => '0');
    signal delay7 : signed(18 downto 0) := (others => '0');
    signal delay8 : signed(18 downto 0) := (others => '0');
    signal delay9 : signed(18 downto 0) := (others => '0');
    signal delay10 : signed(18 downto 0) := (others => '0');
    signal delay11 : signed(18 downto 0) := (others => '0');
    signal delay12 : signed(18 downto 0) := (others => '0');

    
begin

    process(clk)
    begin
    if rising_edge(clk) then
        filter_output <= delay0;
        delay0 <= resize(filter_input, 20) + resize(shift_right(filter_input, 2), 20) + resize(delay1, 20);
        delay1 <= delay2 + shift_right(filter_input, 5);
        delay2 <= delay3;
        delay3 <= delay4;
        delay4 <= delay5;
        delay5 <= delay6 + (shift_right(filter_input, 8) - shift_right(filter_input, 3));
        delay6 <= delay7 - (shift_right(filter_input, 3));
        delay7 <= delay8;
        delay8 <= delay9;
        delay9 <= delay10;
        delay10 <= delay11;
        delay11 <= delay12;
        delay12 <= shift_right(filter_input, 3) - (shift_right(filter_input, 5) + shift_right(filter_input, 8));
    end if;
    end process;

    input <= signed(ui_in & uio_in);
    offset_input <= signed(offset) + resize(input, 20); 
    output <= offset_input + filter_output;
    assert (output(19) = '0');
    y <= output(18);
    filter_input_tmp <= unsigned(output(17 downto 0));
    filter_input <= signed(resize(filter_input_tmp, 19));


    uo_out(0) <= y;
    uio_out <= "00000000"; 
    uio_oe <= "00000000";

end Behavioral;