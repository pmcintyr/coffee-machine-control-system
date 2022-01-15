architecture rtl of debouncer is
SIGNAL s_Q1, s_Q2, s_Q3,s_Q4 : std_logic;
begin
procGetQ1: process(button,clear,clk) IS
begin
if(rising_edge(clk))THEN
	s_Q1<=button and not(clear);
end if;
end process;

procGetQ2: process(s_Q1,clear,clk) IS
begin
if(rising_edge(clk))THEN
	s_Q2<=s_Q1 and not(clear);
end if;
end process;

procGetQ3: process(s_Q2,clear,clk) IS
begin
if(rising_edge(clk))THEN
	s_Q3<=s_Q2 and not(clear);
end if;
end process;

procGetQ4: process(s_Q2,s_Q3,clear,clk) IS
begin
if(rising_edge(clk))THEN
s_Q4<=(((s_Q2 and not(s_Q3)) or s_Q4) and not(clear));

end if;
button_o<=s_Q4;
end process;
end architecture rtl; 
