architecture rtl of disp_driver is
SIGNAL s_whole: std_logic_vector(8 DOWNTO 0);
SIGNAL s_frac: std_logic_vector(6 DOWNTO 0);
SIGNAL s_frac2: std_logic_vector(7 DOWNTO 0);
SIGNAL s_frac_disp_l, s_frac_disp_u, s_whole2: std_logic_vector(3 DOWNTO 0);
COMPONENT sum_splitter is
port(sum   : in std_logic_vector(15 downto 0);
     --Input number to be split.
     whole : out std_logic_vector(8 downto 0);
     --Whole part encoded in 9-bit natural binary.
     frac  : out std_logic_vector(6 downto 0));
END COMPONENT;

COMPONENT bin_to_bcd is
port(bin   : in std_logic_vector(7 downto 0);
     --Input number to be split into BCD digits.
     l_bcd : out std_logic_vector(3 downto 0);
     --The less significant digit (ones).
     u_bcd : out std_logic_vector(3 downto 0));
END COMPONENT;

COMPONENT bcd_to_7seg is
port(en       : in std_logic;
     --Enables the display.
     bcd      : in std_logic_vector(3 downto 0);
     --The digit to be displayed.
     point_on : in std_logic;
     --Indicates if the decimal point should be turned on.
     disp     : out std_logic_vector(7 downto 0));
END COMPONENT;
begin
instance_sum_splitter: entity work.sum_splitter(rtl) PORT MAP(
sum => num,
whole => s_whole,
frac => s_frac);

instance_Entiers_binToBcd: bin_to_bcd PORT MAP(
bin => s_whole(7 DOWNTO 0),
l_bcd => s_whole2);

instance_Fraxion_binToBcd: bin_to_bcd PORT MAP(
bin => s_frac2,
l_bcd => s_frac_disp_l,
u_bcd => s_frac_disp_u);

instanceUnits_bcdTo7seg: bcd_to_7seg PORT MAP(
en => en,
bcd => s_whole2,
point_on => '1',
disp => whole_disp);

instanceUBcd_bcdTo7seg: bcd_to_7seg PORT MAP(
en => en,
bcd => s_frac_disp_u,
point_on => '0',
disp => frac_disp_u);

instanceLBcd_bcdTo7seg: bcd_to_7seg PORT MAP(
en => en,
bcd => s_frac_disp_l,
point_on => '0',
disp => frac_disp_l);

s_frac2<='0' & s_frac;

end architecture rtl;
