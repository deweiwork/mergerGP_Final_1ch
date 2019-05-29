library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;
use work.DataStruct_param_def_header.all;--invoke our defined type and parameter

entity decoder_16b20b is
  port (
    RESET_N     : in std_logic;
    CLK         : in std_logic;

    data_in     : in  std_logic_vector(para_data_length_per_ch_opensrc -1 downto 0);

    data_out    : out std_logic_vector(para_data_length_per_ch -1  downto 0);
    disp_out    : out std_logic_vector(ctrl_code_length_per_ch -1 downto 0);
    
    code_err    : out std_logic_vector(ctrl_code_length_per_ch -1 downto 0) ;
    disp_err    : out std_logic_vector(ctrl_code_length_per_ch -1 downto 0) 
  ) ;
end decoder_16b20b ;


architecture arch of decoder_16b20b is
  signal data_out_buf_0        : std_logic_vector(8 downto 0);
  signal data_out_buf_1        : std_logic_vector(8 downto 0);
  signal data_in_buf_0         : std_logic_vector(9 downto 0);
  signal data_in_buf_1         : std_logic_vector(9 downto 0);
  component decode_v
    port
    (
      datain : in std_logic_vector (9 DOWNTO 0);
      dispin : in std_logic;
      dataout : out std_logic_vector (8 DOWNTO 0);
      dispout : out std_logic;
      code_err : out std_logic;
      disp_err : out std_logic
    );
  end component;
begin
  decoder_0 : decode_v
    port map(
      datain  => data_in_buf_0,
      dispin  => '1',
      dataout => data_out_buf_0,
      dispout => open,

      code_err => code_err(0),
      disp_err => disp_err(0)
    );
 
  decoder_1 : decode_v
    port map(
      datain  => data_in_buf_1,
      dispin  => '0',
      dataout => data_out_buf_1,
      dispout => open,

      code_err => code_err(1),
      disp_err => disp_err(1)
    );
  process(CLK,RESET_N)
    begin
      if (RESET_N = '0') then
        data_out <= (others => '0');
      elsif rising_edge(CLK) then
        data_in_buf_0 <= data_in(9 downto 0);
        data_in_buf_1 <= data_in(19 downto 10);

        data_out(7 downto 0) <= data_out_buf_0(7 downto 0);
        disp_out(0)  <= data_out_buf_0(8);
        data_out(15 downto 8) <= data_out_buf_1(7 downto 0);
        disp_out(1)  <= data_out_buf_1(8);
      end if;
    end process;
end architecture ; 