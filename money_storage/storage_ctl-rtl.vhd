architecture rtl of storage_ctl is
SIGNAL s_checkTHISCONDITION,s_goodChange, s_NeedMore, s_NeededLess,s_cmd_completeInsert, s_cmd_completeCalc,s_cmd_completeGive, s_cmd_completeMerge, s_cmd_completeRelease : std_logic;
SIGNAL s_cptr,coin_type,s_cptr_give,s_cptr_merge,s_cptr_release,s_allCount,s_allCountMerge, s_allReturnChange, s_count2, s_count1, s_count50c, s_count20c,s_register_change_count_02, s_register_change_count_05, s_register_change_count_1, s_register_change_count_2: STD_LOGIC_VECTOR(4 DOWNTO 0);
---------------------------
--SIGNAL s_register_change_count_02, s_register_change_count_05, s_register_change_count_1, s_register_change_count_2 : STD_LOGIC_VECTOR(4 DOWNTO 0):="00001";
--------------------------
SIGNAL s_FirstLoopCount: std_logic_vector(3 DOWNTO 0);
SIGNAL s_ReturnableChange, s_disp_sum,s_disp_sum1, s_disp_sum2,s_temp_storage_sum : STD_LOGIC_VECTOR(15 DOWNTO 0);

SIGNAL s_LeftToPay: unsigned(15 DOWNTO 0);

SIGNAL StateDone,s_CMD_COMPLETE: std_logic;
SIGNAL operation: std_logic_vector(3 DOWNTO 0);
SIGNAL changeCalc2,changeCalc1,changeCalc05,changeCalc02: std_logic;

begin
coin_type<= s_cptr_give when give_change='1' else
	    s_cptr_merge when merge_coins='1' else
	    s_cptr_release when release_coins='1' else
		"00001";

s_cptr <= in_coin_type when insert_coin = '1' 
else	coin_type;
		
cptr<=s_cptr;

s_disp_sum <= temp_storage_sum when (insert_coin='1')ELSE
		s_disp_sum2 when(show_change='1')ELSE
		"0000000000000000";
disp_on<='1' when (show_change='1' or insert_coin='1') and reset='0'
else 	'0';

disp_sum<=s_disp_sum;
main_storage_en<='1';
temp_storage_en<='1';
temp_storage_rem_coin <= '1' when reset/='1' and ((merge_coins='1' and temp_storage_count > "00000")or(release_coins='1' and temp_storage_count > "00000"))
else 			'0';

temp_storage_add_coin <= '1' when reset/='1' and insert_coin='1'
else			'0';

main_storage_add_coin <= '1' when reset/='1' and (merge_coins='1' and temp_storage_count > "00000" and temp_storage_fault='0')
else			'0';

main_storage_rem_coin <= '1' when reset/='1' and main_storage_count>"00000" and (give_change='1' and ((((s_cptr_give="01000" AND s_register_change_count_2>"00000") or (s_cptr_give="00100" AND s_register_change_count_1>"00000")) or (s_cptr_give="00010" AND s_register_change_count_05>"00000")) or (s_cptr_give="00001" AND s_register_change_count_02>"00000")))
else			'0';

procAllStars :PROCESS(clk,s_allCount,cmd_served,merge_coins,s_allCountMerge,temp_storage_count,calc_change,insert_coin,give_change,release_coins,in_coin_type,s_disp_sum,s_disp_sum1) IS BEGIN
IF (reset = '1') then
	cmd_complete<='0';
	s_cmd_completeCalc<='0';
	s_cmd_completeGive<='0';
	s_cmd_completeMerge<='0';
	s_cmd_completeRelease<='0';
	s_disp_sum2<="0000000000000000";
--defaults
--main_storage_en<='1';
--temp_storage_en<='1';
--s_temp_storage_sum<=temp_storage_sum;
--disp_on<='0';
--task 1
ELSIF (insert_coin='1')THEN
--disp_on<='1';
--disp_sum<=temp_storage_sum;
--temp_storage_add_coin <= '1';
--temp_storage_en <= '1';
--task 2
ELSIF(rising_edge(clk))THEN
IF(CMD_SERVED='1')THEN
	IF(calc_change='1') THEN
	--temp_storage_en<='1';
	--s_diff <=  (std_logic_vector(unsigned(price) - unsigned(s_temp_storage_sum)));
		IF(price=temp_storage_sum) THEN
		s_cmd_complete<='1';
		s_cmd_completeCalc<='1';
		IF(s_cmd_completeCalc='1')THEN
		cmd_complete<='1';
		END IF;
		zero<='1';
		negative<='0';
		s_disp_sum2<="0000000000000000";
		s_count2<="00000";
		s_count1<="00000";
		s_count50c<="00000";
		s_count20c<="00000";
		change_count_2<=s_count2;
		change_count_1<=s_count1;
		change_count_05<=s_count50c;
		change_count_02<=s_count20c;

		

		s_goodChange<='1';
		s_NeedMore<='0';
		s_NeededLess<='0';

		ELSIF((price)>(temp_storage_sum)) THEN
		negative <= '1';
		zero<='0';
		s_cmd_complete<='1';
		s_cmd_completeCalc<='1';
		IF(s_cmd_completeCalc='1')THEN
		cmd_complete<='1';
		END IF;

		s_count2<="00000";
		s_count1<="00000";
		s_count50c<="00000";
		s_count20c<="00000";
		change_count_2<=s_count2;
		change_count_1<=s_count1;
		change_count_05<=s_count50c;
		change_count_02<=s_count20c;

		s_goodChange<='0';
		s_NeedMore<='1';
		s_NeededLess<='0';

		ELSE
		zero<='0';
		negative<='0';
		s_LeftToPay <= (unsigned(temp_storage_sum)-unsigned(price));
		
			IF (s_LeftToPay=unsigned(temp_storage_sum)-unsigned(price)) THEN
			s_count2<="00000";
			s_count1<="00000";
			s_count50c<="00000";
			s_count20c<="00000";
			END IF;

		s_goodChange<='0';
		s_NeedMore<='0';
		s_NeededLess<='1';
	      	
			IF s_LeftToPay>=two THEN
			s_LeftToPay<=s_LeftToPay-two;
				IF (s_LeftToPay=unsigned(temp_storage_sum)-unsigned(price)) THEN
				s_count2<="00001";
				s_disp_sum1<=std_logic_vector(two);
				else
				s_count2<=STD_LOGIC_VECTOR(unsigned(s_count2)+"00001");
				s_disp_sum1<=std_logic_vector(unsigned(s_disp_sum1) + two);
				end if;

			ELSIF s_LeftToPay>=one THEN
			s_LeftToPay<=s_LeftToPay-ONE;
				IF (s_LeftToPay=unsigned(temp_storage_sum)-unsigned(price)) THEN
				s_count1<="00001";
				s_disp_sum1<=std_logic_vector(one);
				else
				s_count1<=STD_LOGIC_VECTOR(unsigned(s_count1)+"00001");
				s_disp_sum1<=std_logic_vector(unsigned(s_disp_sum1) + one);
				end if;

			ELSIF s_LeftToPay>=half THEN
			s_LeftToPay<=s_LeftToPay-half;
				IF (s_LeftToPay=unsigned(temp_storage_sum)-unsigned(price)) THEN					
				s_count50c<="00001";
				s_disp_sum1<=std_logic_vector(half);
				else
				s_count50c<=STD_LOGIC_VECTOR(unsigned(s_count50c)+"00001");
				s_disp_sum1<=std_logic_vector(unsigned(s_disp_sum1) + half);
				end if;

			ELSIF s_LeftToPay>=fifth THEN
			s_LeftToPay<=s_LeftToPay-fifth;
				IF (s_LeftToPay=unsigned(temp_storage_sum)-unsigned(price)) THEN
				s_count20c<="00001";
				s_disp_sum1<=std_logic_vector(fifth);
				else
				s_count20c<=STD_LOGIC_VECTOR(unsigned(s_count20c)+"00001");
				s_disp_sum1<=std_logic_vector(unsigned(s_disp_sum1) + fifth);
				end if;
			ELSE
			s_cmd_complete<='1';
			s_cmd_completeCalc<='1';
			IF(s_cmd_completeCalc='1')THEN
			cmd_complete<='1';
			END IF;

			change_count_2<=s_count2;
			change_count_1<=s_count1;
			change_count_05<=s_count50c;
			change_count_02<=s_count20c;

			s_register_change_count_2<=s_count2;
			s_register_change_count_1<=s_count1;
			s_register_change_count_05<=s_count50c;
			s_register_change_count_02<=s_count20c;
			
			s_disp_sum2<=s_disp_sum1;
			END IF;
		END IF;
--task 3
	ELSIF(give_change='1')THEN
	s_cptr_give<="01000";
	--after task is done
		IF(s_cptr_give="01000" AND s_register_change_count_2>="00000") THEN
			IF s_register_change_count_2>"00000" and (main_storage_count>"00000")THEN
				s_register_change_count_2<=std_logic_vector(unsigned(s_register_change_count_2) - "00001");
				--main_storage_rem_coin<='1';
			ELSE
			s_cptr_give<="00100";
			END IF;
		
		ELSIF(s_cptr_give="00100" AND s_register_change_count_1>="00000") THEN
			IF s_register_change_count_1>"00000" and (main_storage_count>"00000")THEN
				s_register_change_count_1<=std_logic_vector(unsigned(s_register_change_count_1) - "00001");
				--main_storage_rem_coin<='1';
			ELSE
			s_cptr_give<="00010";
			END IF;
		
		ELSIF(s_cptr_give="00010" AND s_register_change_count_05>="00000") THEN
			IF s_register_change_count_05>"00000" and (main_storage_count>"00000")THEN
				s_register_change_count_05<= std_logic_vector(unsigned(s_register_change_count_05) - "00001");
				--main_storage_rem_coin<='1';
			ELSE
			s_cptr_give<="00001";
			end if;
		
		ELSIF(s_cptr_give="00001" AND s_register_change_count_02>="00000") THEN
			IF s_register_change_count_02>"00000" and (main_storage_count>"00000")THEN
				s_register_change_count_02<=std_logic_vector(unsigned(s_register_change_count_02) - "00001");
				--main_storage_rem_coin<='1';
			ELSE
			s_cptr_give<="00000";
			end if;
		
		ELSIF(s_register_change_count_02="00000" and s_register_change_count_05="00000" and s_register_change_count_1="00000" and s_register_change_count_2="00000")THEN
		cmd_complete<='1';
		s_cmd_complete<='1';
			--IF(s_cmd_completeGive='1')THEN
			--cmd_complete<='1';
			--END IF;
		END IF;
	--cmd_complete<='1';
--task 4
	ELSIF(merge_coins='1') THEN
	--after task is done
	s_cptr_merge<="10000";
	--temp_storage_en<='1';
	--main_storage_en<='1';

		--IF() THEN
		--temp_storage_rem_coin <= '1';
		--main_storage_add_coin <= '1';
		IF(s_cptr_merge="10000" and temp_storage_count = "00000")THEN
		s_cptr_merge<="01000";
		ELSIF(s_cptr_merge="01000" and temp_storage_count = "00000")THEN
		s_cptr_merge<="00100";
		ELSIF(s_cptr_merge="00100" and temp_storage_count = "00000")THEN
		s_cptr_merge<="00010";
		ELSIF(s_cptr_merge="00010" AND temp_storage_count = "00000")THEN
		s_cptr_merge<="00001";
		ELSIF(s_cptr_merge="00001" AND temp_storage_count = "00000")THEN
		s_cptr_merge<="00000";
		s_cmd_complete<='1';
		cmd_complete<='1';
		--s_cmd_completeMerge<='1';
		--temp_storage_en<='0';
		--main_storage_en<='0';
		--temp_storage_rem_coin<='0';
		--main_storage_add_coin<='0';
		END IF;
	--cmd_complete<='1';
--task 5
	ELSIF(release_coins='1') THEN
	--after task is done
	s_cptr_release<="10000";
	--temp_storage_en<='1';

		IF(s_cptr_release="10000" and temp_storage_count = "00000") THEN
		s_cptr_release<="01000";
		ELSIF(s_cptr_release="01000" and temp_storage_count = "00000") THEN
		s_cptr_release<="00100";
		ELSIF(s_cptr_release="00100" and temp_storage_count = "00000") THEN
		s_cptr_release<="00010";
		ELSIF(s_cptr_release="00010" and temp_storage_count = "00000") THEN
		s_cptr_release<="00001";
		ELSIF(s_cptr_release="00001" and temp_storage_count = "00000")THEN
		s_cptr_release<="00000";
		cmd_complete<='1';
		s_cmd_complete<='1';
		--temp_storage_en<='0';
		--temp_storage_rem_coin<='0';
		END IF;
	END IF;
ELSE
s_cmd_complete<='0';
	IF s_cmd_complete='0' THEN
	cmd_complete<='0';
	END IF;
END IF;
END IF;
END PROCESS;
	
end architecture rtl;
