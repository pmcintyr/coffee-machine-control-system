architecture rtl of money_storage is

signal initcounttemp1 : init_count_t := (0,0,0,0,0);
signal initsumstemp1: init_sum_t := ("0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000");
COMPONENT coin_storage is
generic(INIT_COUNTS : init_count_t;
        INIT_SUMS   : init_sum_t);
port(clk       : in std_logic;
     reset     : in std_logic;
     en        : in std_logic;
     add_coin  : in std_logic;
     rem_coin  : in std_logic;
     coin_type : in std_logic_vector(4 downto 0);
     count     : out std_logic_vector(4 downto 0);
     sum       : out std_logic_vector(15 downto 0);
     fault     : out std_logic);
end component;
COMPONENT storage_ctl is
port(clk                   : in std_logic;
     reset                 : in std_logic;
     ------------------------------------------------------------------------------------
     --Commands and Other Inputs from the Main FSM
     ------------------------------------------------------------------------------------
     insert_coin           : in std_logic;
     calc_change           : in std_logic;
     give_change           : in std_logic;
     release_coins         : in std_logic;
     merge_coins           : in std_logic;
     in_coin_type          : in std_logic_vector(4 downto 0);
     price                 : in std_logic_vector(15 downto 0);
     show_change           : in std_logic;
     ------------------------------------------------------------------------------------
     --Status Signals for the Main FSM
     ------------------------------------------------------------------------------------
     zero                  : out std_logic;
     negative              : out std_logic;
     ------------------------------------------------------------------------------------
     --Main FSM Handshake Protocol
     ------------------------------------------------------------------------------------
     cmd_served            : in std_logic;
     cmd_complete          : out std_logic;

     ------------------------------------------------------------------------------------
     --Status Signals from the Storage Units
     ------------------------------------------------------------------------------------
     main_storage_count    : in std_logic_vector(4 downto 0);
     main_storage_sum      : in std_logic_vector(15 downto 0);
     main_storage_fault    : in std_logic;
     temp_storage_count    : in std_logic_vector(4 downto 0);
     temp_storage_sum      : in std_logic_vector(15 downto 0);
     temp_storage_fault    : in std_logic;
     ------------------------------------------------------------------------------------
     --Commands for the Storage Units
     ------------------------------------------------------------------------------------
     cptr                  : out std_logic_vector(4 downto 0);
     main_storage_en       : out std_logic;
     main_storage_add_coin : out std_logic;
     main_storage_rem_coin : out std_logic;
     temp_storage_en       : out std_logic;
     temp_storage_add_coin : out std_logic;
     temp_storage_rem_coin : out std_logic;
     ------------------------------------------------------------------------------------
     --Display and LED Interfaces
     ------------------------------------------------------------------------------------
     disp_on               : out std_logic;
     disp_sum              : out std_logic_vector(15 downto 0);
     change_count_2        : out std_logic_vector(4 downto 0);
     change_count_1        : out std_logic_vector(4 downto 0);   
     change_count_05       : out std_logic_vector(4 downto 0);   
     change_count_02       : out std_logic_vector(4 downto 0));   
end component;
SIGNAL s_temp_storage_fault,s_main_storage_fault,s_temp_storage_en,s_temp_storage_add_coin,s_temp_storage_rem_coin,s_main_storage_en,s_main_storage_add_coin,s_main_storage_rem_coin: STD_LOGIC;
SIGNAL s_main_storage_count,s_temp_storage_count,s_cptr,finalCoinType: STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL s_temp_storage_sum,s_main_storage_sum:STD_LOGIC_VECTOR(15 DOWNTO 0);
begin
finalCoinType <= in_coin_type when insert_coin='1'
else 		s_cptr;
Temp_Storage: entity work.coin_storage(rtl) 
generic map(
	INIT_COUNTS=>initcounttemp1,
	INIT_SUMS=>initsumstemp1)
port map(clk 	 => clk,
         reset    => reset,
         en	 => s_temp_storage_en,
         add_coin => s_temp_storage_add_coin,
 	 rem_coin => s_temp_storage_rem_coin,
    	 coin_type =>  finalCoinType,
--outputs
  	 count	 => s_temp_storage_count,
   	 sum	 => s_temp_storage_sum,
   	 fault	 => s_temp_storage_fault);

Main_Storage: entity work.coin_storage(rtl) 
generic map(
	INIT_COUNTS=>main_init_counts,
	INIT_SUMS=>main_init_sums)
port map(clk 	 => clk,
         reset   => reset,
         en	 => s_main_storage_en,
         add_coin => s_main_storage_add_coin,
 	 rem_coin => s_main_storage_rem_coin,
    	 coin_type =>  finalCoinType,
--outputs
  	 count	 => s_main_storage_count,
   	 sum	 => s_main_storage_sum,
   	 fault	 => s_main_storage_fault);

storage_ctl_instance: entity work.storage_ctl(rtl)
port map(clk 	 => clk,
        reset    => reset,
	insert_coin => insert_coin,
	calc_change => calc_change,
	give_change => give_change,
	release_coins => release_coins,
	merge_coins => merge_coins,
	in_coin_type =>in_coin_type,
	price => price,
	show_change => show_change,	
	zero => zero,--output
	negative => negative,--output
	cmd_served => cmd_served,		
	cmd_complete => cmd_complete,--output
	main_storage_count => s_main_storage_count,
	main_storage_sum => s_main_storage_sum,
	main_storage_fault => s_main_storage_fault,
	temp_storage_count => s_temp_storage_count,
	temp_storage_sum => s_temp_storage_sum,
	temp_storage_fault => s_temp_storage_fault,
--outputs
	cptr => s_cptr,
	main_storage_en => s_main_storage_en,
	main_storage_add_coin => s_main_storage_add_coin,
	main_storage_rem_coin => s_main_storage_rem_coin,
	temp_storage_en => s_temp_storage_en,
	temp_storage_add_coin => s_temp_storage_add_coin,
	temp_storage_rem_coin => s_temp_storage_rem_coin,
	disp_on => disp_on,
	disp_sum => disp_sum,
	change_count_2 => change_count_2,
	change_count_1 => change_count_1,
	change_count_05 => change_count_05,
	change_count_02 => change_count_02);
			
			
end architecture rtl; 
