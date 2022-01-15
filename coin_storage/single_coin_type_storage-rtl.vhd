architecture rtl of single_coin_type_storage is
SIGNAL s_EN, inc, dec, ovf: std_logic;
SIGNAL s_Carry,s_DCarry, s_Y1, s_D1,s_Q1 : std_logic_vector(4 DOWNTO 0);
SIGNAL s_Y2, s_D2, s_Q2 : std_logic_vector(15 DOWNTO 0);
begin
	inc<=add_coin;
	dec<=rem_coin;

	incDecUnit: PROCESS(inc,dec,reset,s_Q1) IS
	BEGIN
		IF(reset='0' AND dec='1') THEN
			IF(s_Q1/="00000") THEN
			ovf<='0';
			s_Y1<=std_logic_vector(unsigned(s_Q1)-"00001");
			ELSE
			ovf<='1';
			END IF;
	
		ELSIF(reset='0' AND inc = '1') THEN
			IF(s_Q1/="11111") THEN
			ovf<='0';
			s_Y1<=std_logic_vector(unsigned(s_Q1) + "00001");
			ELSE
			ovf<='1';
			END IF;
		ELSE
		ovf<='0';
		s_Y1<=s_Q1;
		END IF;
	END PROCESS;
	
	s_EN<= (en AND (NOT(ovf)));

	proc_Counter_Reg: PROCESS(s_EN,s_D1,clk,reset) IS
	BEGIN
		IF((rising_edge(clk)AND s_EN='1')OR(reset='1')) THEN
			s_Q1<=s_D1;
		END IF;
	END PROCESS proc_Counter_Reg;

	proc_Sum_Reg: PROCESS(s_EN,s_D2,clk,reset) IS
	BEGIN
		IF((rising_edge(clk)AND s_EN='1')OR(reset='1')) THEN
				s_Q2<=s_D2;
		END IF;
	END PROCESS proc_Sum_Reg;

	AddSubUnit : PROCESS(inc,dec,reset,s_Q2) IS
	BEGIN
		IF(dec='1' AND reset='0') THEN
			s_Y2<=std_logic_vector(unsigned(s_Q2)-coin_val);
		ELSIF(inc = '1' AND reset='0') THEN
			s_Y2<=std_logic_vector(unsigned(s_Q2)+coin_val);
		ELSE
			s_Y2<=s_Q2;
		END IF;
	END PROCESS AddSubUnit;

	multiplexerCounter : PROCESS (reset,s_Y1) IS
	BEGIN
		IF(reset = '1') THEN
			s_D1<=std_logic_vector(to_unsigned(INIT_COUNT,5));
		ELSE
			s_D1<=s_Y1;
		END IF;
	END PROCESS multiplexerCounter;

	multiplexerSum : PROCESS (reset,s_Y2) IS
	BEGIN
		IF(reset = '1') THEN
			s_D2<=std_logic_vector(INIT_SUM);
		ELSE
			s_D2<=s_Y2;
		END IF;
	END PROCESS multiplexerSum;
	
	counterTime : Process(en,s_Q1) IS
	BEGIN
		IF(en = '1') THEN
		count<=s_Q1;
		ELSE
		count<="00000";
		END IF;
	END PROCESS;

	fault<=(ovf AND en);
	sum<=s_Q2;

end architecture rtl;
