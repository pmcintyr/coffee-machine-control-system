architecture rtl of drink_preparation is
--Preparation times are as follows (ordered from MSB to LSB):
--5, 7, 7, 9, 13
--Prices are as follows (ordered from MSB to LSB):
--1.2, 1.4, 1.4, 1.8, 2.5
--You may use the >>float_to_fixed<< routine to convert to unsigned.
--Numbers of ingredients packages are as follows (ordered from MSB to LSB):
--2, 2, 2, 2, 1
SIGNAL AmountStocked1,AmountStocked2,AmountStocked3,AmountStocked4,AmountStocked5: natural;
SIGNAL prep_time: std_logic_vector(4 downto 0);
--signals determined by drink_type
SIGNAL s_done,removed,clearTimer,s_cmd_complete: std_logic;

COMPONENT timer is
port(clk,clear,en,timeout: in std_logic;
	pulse, done: out std_logic);
end component;
begin

--timer
instance_timer : entity work.timer(rtl) port map(
clk => clk,
clear => clearTimer,
en => cmd_served,
timeout => prep_time,
--outputs
pulse => led_out,
done =>	s_done);

procClearTimer: PROCESS(reset,cmd_served)IS
BEGIN
IF(cmd_served='0')then
clearTimer<='1';
ELSE
clearTimer<='0';
END IF;
END PROCESS;

--handshake
procHandshake: PROCESS(clk,cmd_served,s_done) IS
BEGIN
cmd_complete<=s_cmd_complete;
	IF (cmd_served='1')THEN
		IF(s_done='1')THEN
		s_cmd_complete<='1';
		END IF;
	ELSE
	s_cmd_complete<='0';
	END IF;

END PROCESS;
--ingredients register bank
procDrinkPrep: PROCESS(clk,reset,drink_type,AmountStocked1,AmountStocked2,AmountStocked3,AmountStocked4,AmountStocked5) IS
BEGIN
IF (reset='1')THEN
removed<='0';
AmountStocked1<=natural(2);
AmountStocked2<=natural(2);
AmountStocked3<=natural(2);
AmountStocked4<=natural(2);
AmountStocked5<=natural(1);
available<='1';
END IF;

IF(drink_type="10000")THEN
price<=std_logic_vector(float_to_fixed(real(1.2)));
prep_time<="00101";
	IF(AmountStocked1/=natural(0))THEN
	available<='1';
		IF( removed='0')THEN
			IF(cmd_served='1')THEN
			AmountStocked1<=AmountStocked1-natural(1);
			removed<='1';
			ELSE
			removed<='0';
			END IF;
		ELSIF(cmd_served='0')THEN
		removed<='0';
		END IF;
	ELSE
	available<='0';
		if(cmd_served='0')THEN
		removed<='0';
		END IF;
	end if;
	
ELSIF(drink_type="01000")THEN
price<=std_logic_vector(float_to_fixed(real(1.4)));
prep_time<="00111";
	IF(AmountStocked2/=natural(0))THEN
	available<='1';
		IF( removed='0')THEN
			IF(cmd_served='1')THEN
			AmountStocked2<=AmountStocked2-natural(1);
			removed<='1';
			ELSE
			removed<='0';
			END IF;
		ELSIF(cmd_served='0')THEN
		removed<='0';
		END IF;
	ELSE
	available<='0';
		if(cmd_served='0')THEN
		removed<='0';
		END IF;
	end if;
ELSIF(drink_type="00100")THEN
price<=std_logic_vector(float_to_fixed(real(1.4)));
prep_time<="00111";
	IF(AmountStocked3/=natural(0))THEN
	available<='1';
		IF( removed='0')THEN
			IF(cmd_served='1')THEN
			AmountStocked3<=AmountStocked3-natural(1);
			removed<='1';
			ELSE
			removed<='0';
			END IF;
		ELSIF(cmd_served='0')THEN
		removed<='0';
		END IF;
	ELSE
	available<='0';
		if(cmd_served='0')THEN
		removed<='0';
		END IF;
	end if;
ELSIF(drink_type="00010")THEN
price<=std_logic_vector(float_to_fixed(real(1.8)));
prep_time<="01001";
	IF(AmountStocked4/=natural(0))THEN
	available<='1';
		IF( removed='0')THEN
			IF(cmd_served='1')THEN
			AmountStocked4<=AmountStocked4-natural(1);
			removed<='1';
			ELSE
			removed<='0';
			END IF;
		ELSIF(cmd_served='0')THEN
		removed<='0';
		END IF;
	ELSE
	available<='0';
		if(cmd_served='0')THEN
		removed<='0';
		END IF;
	end if;
ELSIF(drink_type="00001")THEN
price<=std_logic_vector(float_to_fixed(real(2.5)));
prep_time<="01101";
	IF(AmountStocked5/=natural(0))THEN
	available<='1';
		IF( removed='0')THEN
			IF(cmd_served='1')THEN
			AmountStocked5<=AmountStocked5-natural(1);
			removed<='1';
			ELSE
			removed<='0';
			END IF;
		ELSIF(cmd_served='0')THEN
		removed<='0';
		END IF;
	ELSE
	available<='0';
		if(cmd_served='0')THEN
		removed<='0';
		END IF;
	end if;
END IF;
END PROCESS;
end architecture rtl;
