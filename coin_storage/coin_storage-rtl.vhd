architecture rtl of coin_storage is
SIGNAL s_Fault5f,s_Fault2f,s_Fault1f,s_Fault50c,s_Fault20c : STD_LOGIC;
SIGNAL s_Count5f,s_Count2f,s_Count1f,s_Count50c,s_Count20c,s_final_coin_type : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL s_Sum5f,s_Sum2f,s_Sum1f,s_Sum50c,s_Sum20c : STD_LOGIC_VECTOR(15 DOWNTO 0);

COMPONENT single_coin_type_storage is
generic(INIT_COUNT : natural;
        INIT_SUM   : unsigned(15 downto 0);
        COIN_VAL   : unsigned(15 downto 0));

port(clk, reset, en, add_coin , rem_coin : in std_logic;
     count    : out std_logic_vector(4 downto 0);
     sum      : out std_logic_vector(15 downto 0);
     fault    : out std_logic);

end component;

begin
	procFCT : PROCESS(en,coin_type) IS
	BEGIN
			IF (en='1') THEN 
			s_final_coin_type<=coin_type;
			ELSE
			s_final_coin_type<="00000";
			END IF;	
END PROCESS;

instance_5f_single_coin : entity work.single_coin_type_storage(rtl) generic map(
			INIT_COUNT=>INIT_COUNTS(4),
			INIT_SUM=>INIT_SUMS(4),
			COIN_VAL=>five)
								port map(
			add_coin => add_coin,
			rem_coin => rem_coin,
			reset    => reset,
			clk 	 => clk,
			en	 => s_final_coin_type(4),
			fault	 => s_Fault5f,
			sum	 => s_Sum5f,
			count	 => s_Count5f);

instance_2f_single_coin : entity work.single_coin_type_storage(rtl) generic map(
			INIT_COUNT=>INIT_COUNTS(3),
			INIT_SUM=>INIT_SUMS(3),
			COIN_VAL=>two)
								port map(
			add_coin => add_coin,
			rem_coin => rem_coin,
			reset    => reset,
			clk 	 => clk,
			en	 => s_final_coin_type(3),
			fault	 => s_Fault2f,
			sum	 => s_Sum2f,
			count	 => s_Count2f);
	
			

instance_1f_single_coin : entity work.single_coin_type_storage(rtl) generic map(
			INIT_COUNT=>INIT_COUNTS(2),
			INIT_SUM=>INIT_SUMS(2),
			COIN_VAL=>one)
								port map(
			add_coin => add_coin,
			rem_coin => rem_coin,
			reset    => reset,
			clk 	 => clk,
			en	 => s_final_coin_type(2),
			fault	 => s_Fault1f,
			sum	 => s_Sum1f,
			count	 => s_Count1f);
			
			

instance_50c_single_coin : entity work.single_coin_type_storage(rtl) generic map(
			INIT_COUNT=>INIT_COUNTS(1),
			INIT_SUM=>INIT_SUMS(1),
			COIN_VAL=>half)
								port map(
			add_coin => add_coin,
			rem_coin => rem_coin,
			reset    => reset,
			clk 	 => clk,
			en	 => s_final_coin_type(1),
			fault	 => s_Fault50c,
			sum	 => s_Sum50c,
			count	 => s_Count50c);

instance_20c_single_coin : entity work.single_coin_type_storage(rtl) generic map(
			INIT_COUNT=>INIT_COUNTS(0),
			INIT_SUM=>INIT_SUMS(0),
			COIN_VAL=>fifth)
								port map(
			add_coin => add_coin,
			rem_coin => rem_coin,
			reset    => reset,
			clk 	 => clk,
			en	 => s_final_coin_type(0),
			fault	 => s_Fault20c,
			sum	 => s_Sum20c,
			count	 => s_Count20c);

fault<=s_Fault5f OR s_Fault2f OR s_Fault1f OR s_Fault50c OR s_Fault20c;

count<=s_Count5f OR s_Count2f OR s_Count1f OR s_Count50c OR s_Count20c;

sum<=std_logic_vector(unsigned(s_Sum5f)+unsigned(s_Sum2f)+unsigned(s_Sum1f)+unsigned(s_Sum50c)+unsigned(s_Sum20c));

end architecture rtl;
