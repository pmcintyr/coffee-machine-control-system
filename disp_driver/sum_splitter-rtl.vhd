architecture rtl of sum_splitter is
SIGNAL multip : std_logic_vector(13 downto 0);
begin
procSumSplitter: PROCESS(sum,multip) IS
BEGIN
	whole <= std_logic_vector(sum(15 DOWNTO 7));
	frac <= multip(13 DOWNTO 7);
	multip<=std_logic_vector(unsigned('0' & sum(6 DOWNTO 0)&"000000")+unsigned("00" & sum(6 DOWNTO 0) & "00000")+unsigned("00000" & sum(6 DOWNTO 0) & "00"));

END PROCESS;
end architecture rtl;