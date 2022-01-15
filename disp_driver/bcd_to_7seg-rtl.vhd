architecture rtl of bcd_to_7seg is
begin

procDisplayNumbaz: process(en,point_on,bcd) is
begin
IF(en='1') THEN
	IF(bcd="0000") THEN
	disp<="1111110" & point_on;
	ELSIF(bcd="0001")THEN
	disp<="0110000" & point_on;
	ELSIF(bcd="0010")THEN
	disp<="1101101" & point_on;
	ELSIF(bcd="0011")THEN
	disp<="1111001" & point_on;
	ELSIF(bcd="0100")THEN
	disp<="0110011" & point_on;
	ELSIF(bcd="0101")THEN
	disp<="1011011" & point_on;
	ELSIF(bcd="0110")THEN
	disp<="1011111" & point_on;
	ELSIF(bcd="0111")THEN
	disp<="1110000" & point_on;
	ELSIF(bcd="1000")THEN
	disp<="1111111" & point_on;
	else
	disp<="1111011" & point_on;
	END IF;
ELSE
disp<="00000000";
END IF;
END PROCESS;
end architecture rtl;

