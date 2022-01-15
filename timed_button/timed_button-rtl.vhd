architecture rtl of timed_button is
SIGNAL s_done, s_en: std_logic;

COMPONENT debouncer is
port(clk, button, clear: in std_logic;
	button_o: out std_logic);
end component;

COMPONENT timer is
port(clk,clear,en,timeout: in std_logic;
	pulse, done: out std_logic);
end component;

begin

s_en <= not(s_done);

instance_timer : entity work.timer(rtl) port map(
clk => clk,
clear => clear,
en => s_en,
timeout => "00001",
--outputs
done =>	s_done);


instance_debouncer: entity work.debouncer(rtl) port map(
clk => clk,
button => button,
clear => s_en,
--outputs
button_o => button_o);

end architecture rtl;
