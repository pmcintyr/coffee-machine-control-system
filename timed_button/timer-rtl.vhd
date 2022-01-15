architecture rtl of timer is
SIGNAL TicksNb, TotalTicksNb : natural;
SIGNAL SecondsNb: std_logic_vector(4 downto 0);
SIGNAL s_pulse, s_done: std_logic;
begin


done<=s_done;
pulse<=s_pulse;
procTimer: PROCESS(clk,clear,en) IS
BEGIN


IF clear='1' THEN
TicksNb<= 0;
TotalTicksNb<=0;
SecondsNb<="00000";
s_done<='0';
s_pulse<='0';

ELSIF (rising_edge(clk) AND (en='1'))THEN
	TotalTicksNb<=TotalTicksNb+1;

	IF(float_eq(real(TicksNb),real(FCLK/natural(2)-1)) OR float_eq(real(TicksNb),real(FCLK-1)))then
	s_pulse <= not(s_pulse);
	END IF;
	
	if(TotalTicksNb=0)THEN
	SecondsNb<="00000";
	END IF;

	--true once every second, every 2 pulses
	if (TicksNb = FCLK - 1)THEN
	TicksNb<=0;
	--s_pulse<=not(s_pulse);
	SecondsNb<=std_logic_vector(unsigned(SecondsNb) + ("00001"));
		--IF (std_logic_vector(unsigned(SecondsNb) + ("00001"))=timeout) THEN
		--s_done<='1';
		--end if;
	ELSE
	TicksNb<=TicksNb+1;
	END IF;

END IF;
IF (rising_edge(clk) and (std_logic_vector(unsigned(SecondsNb))=timeout) and std_logic_vector(unsigned(SecondsNb))>"00000")
THEN
s_done<='1';
END IF;
END PROCESS;
	
end architecture rtl;
