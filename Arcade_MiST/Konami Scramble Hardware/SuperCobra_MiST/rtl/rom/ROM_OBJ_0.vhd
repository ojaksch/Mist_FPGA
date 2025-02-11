library ieee;
use ieee.std_logic_1164.all,ieee.numeric_std.all;

entity ROM_OBJ_0 is
port (
	clk  : in  std_logic;
	addr : in  std_logic_vector(10 downto 0);
	data : out std_logic_vector(7 downto 0)
);
end entity;

architecture prom of ROM_OBJ_0 is
	type rom is array(0 to  2047) of std_logic_vector(7 downto 0);
	signal rom_data: rom := (
		X"38",X"7C",X"C2",X"82",X"86",X"7C",X"38",X"00",X"02",X"02",X"FE",X"FE",X"42",X"02",X"00",X"00",
		X"62",X"F2",X"BA",X"9A",X"9E",X"CE",X"46",X"00",X"8C",X"DE",X"F2",X"B2",X"92",X"86",X"04",X"00",
		X"08",X"FE",X"FE",X"C8",X"68",X"38",X"18",X"00",X"1C",X"BE",X"A2",X"A2",X"A2",X"E6",X"E4",X"00",
		X"0C",X"9E",X"92",X"92",X"D2",X"7E",X"3C",X"00",X"C0",X"E0",X"B0",X"9E",X"8E",X"C0",X"C0",X"00",
		X"0C",X"6E",X"9A",X"9A",X"B2",X"F2",X"6C",X"00",X"78",X"FC",X"96",X"92",X"92",X"F2",X"60",X"00",
		X"40",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"44",X"4C",X"5C",X"5C",X"E0",X"40",X"40",X"40",
		X"00",X"00",X"18",X"18",X"18",X"18",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"18",X"18",X"C3",X"C3",X"18",X"18",X"C3",X"C3",X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"3E",X"7E",X"C8",X"88",X"C8",X"7E",X"3E",X"00",
		X"6C",X"FE",X"92",X"92",X"92",X"FE",X"FE",X"00",X"44",X"C6",X"82",X"82",X"C6",X"7C",X"38",X"00",
		X"38",X"7C",X"C6",X"82",X"82",X"FE",X"FE",X"00",X"82",X"92",X"92",X"92",X"FE",X"FE",X"00",X"00",
		X"80",X"90",X"90",X"90",X"90",X"FE",X"FE",X"00",X"9E",X"9E",X"92",X"82",X"C6",X"7C",X"38",X"00",
		X"FE",X"FE",X"10",X"10",X"10",X"FE",X"FE",X"00",X"82",X"82",X"FE",X"FE",X"82",X"82",X"00",X"00",
		X"FC",X"FE",X"02",X"02",X"02",X"06",X"04",X"00",X"82",X"C6",X"6E",X"3C",X"18",X"FE",X"FE",X"00",
		X"02",X"02",X"02",X"02",X"FE",X"FE",X"00",X"00",X"FE",X"FE",X"70",X"38",X"70",X"FE",X"FE",X"00",
		X"FE",X"FE",X"1C",X"38",X"70",X"FE",X"FE",X"00",X"7C",X"FE",X"82",X"82",X"82",X"FE",X"7C",X"00",
		X"70",X"F8",X"88",X"88",X"88",X"FE",X"FE",X"00",X"7A",X"FC",X"8E",X"8A",X"82",X"FE",X"7C",X"00",
		X"72",X"F6",X"9E",X"8C",X"88",X"FE",X"FE",X"00",X"4C",X"DE",X"92",X"92",X"92",X"F6",X"64",X"00",
		X"80",X"80",X"FE",X"FE",X"80",X"80",X"00",X"00",X"FC",X"FE",X"02",X"02",X"02",X"FE",X"FC",X"00",
		X"F0",X"F8",X"1C",X"0E",X"1C",X"F8",X"F0",X"00",X"F8",X"FE",X"1C",X"38",X"1C",X"FE",X"F8",X"00",
		X"C6",X"EE",X"7C",X"38",X"7C",X"EE",X"C6",X"00",X"C0",X"F0",X"1E",X"1E",X"F0",X"C0",X"00",X"00",
		X"C2",X"E2",X"F2",X"BA",X"9E",X"8E",X"86",X"00",X"10",X"10",X"10",X"10",X"10",X"10",X"10",X"00",
		X"01",X"03",X"03",X"07",X"3F",X"7F",X"F1",X"FF",X"01",X"01",X"01",X"01",X"07",X"1F",X"71",X"FF",
		X"07",X"1F",X"31",X"7F",X"5F",X"FF",X"F1",X"FF",X"01",X"0F",X"07",X"03",X"07",X"1F",X"31",X"FF",
		X"FF",X"DF",X"7F",X"3F",X"07",X"03",X"03",X"01",X"FF",X"7F",X"1F",X"07",X"01",X"01",X"01",X"01",
		X"9F",X"FF",X"F1",X"7F",X"7F",X"3F",X"1D",X"07",X"FF",X"3F",X"1F",X"07",X"03",X"07",X"0F",X"01",
		X"03",X"07",X"FF",X"FF",X"FF",X"3F",X"0F",X"03",X"FF",X"1F",X"0F",X"01",X"07",X"1F",X"F1",X"FF",
		X"9F",X"FF",X"F1",X"7F",X"DF",X"7F",X"F1",X"FF",X"03",X"07",X"07",X"03",X"01",X"01",X"03",X"01",
		X"FF",X"1F",X"31",X"7F",X"DF",X"FF",X"71",X"FF",X"1F",X"FF",X"F1",X"FF",X"1F",X"FF",X"F1",X"FF",
		X"1F",X"FF",X"F1",X"FF",X"1F",X"FF",X"F1",X"FF",X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",
		X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"08",X"EE",X"EE",X"EE",X"EE",X"80",X"FF",
		X"3C",X"42",X"81",X"A5",X"A5",X"99",X"42",X"3C",X"FF",X"81",X"81",X"81",X"81",X"81",X"81",X"FF",
		X"00",X"03",X"07",X"0F",X"0F",X"1A",X"18",X"1F",X"00",X"80",X"C0",X"E0",X"F0",X"B0",X"30",X"F0",
		X"1F",X"1F",X"0A",X"08",X"07",X"03",X"00",X"00",X"F0",X"F0",X"F0",X"20",X"C0",X"80",X"00",X"00",
		X"00",X"7C",X"82",X"82",X"7C",X"00",X"7C",X"82",X"82",X"7C",X"00",X"02",X"FE",X"42",X"00",X"00",
		X"82",X"7C",X"00",X"62",X"92",X"8A",X"46",X"00",X"82",X"7C",X"00",X"6C",X"92",X"82",X"44",X"00",
		X"00",X"00",X"23",X"13",X"0B",X"08",X"38",X"3F",X"00",X"00",X"10",X"20",X"40",X"40",X"70",X"F0",
		X"3B",X"0B",X"08",X"10",X"23",X"03",X"00",X"00",X"70",X"40",X"40",X"20",X"10",X"00",X"00",X"00",
		X"00",X"00",X"00",X"23",X"33",X"3B",X"08",X"1C",X"00",X"00",X"00",X"10",X"30",X"40",X"40",X"E0",
		X"0B",X"0B",X"0B",X"30",X"20",X"03",X"00",X"00",X"40",X"70",X"30",X"10",X"00",X"00",X"00",X"00",
		X"01",X"01",X"7F",X"7F",X"21",X"01",X"00",X"00",X"26",X"6F",X"49",X"49",X"49",X"7B",X"32",X"00",
		X"00",X"00",X"01",X"01",X"7F",X"7F",X"21",X"01",X"00",X"00",X"31",X"79",X"5D",X"4D",X"4F",X"67",
		X"00",X"00",X"46",X"6F",X"79",X"59",X"49",X"43",X"00",X"00",X"04",X"7F",X"7F",X"64",X"34",X"1C",
		X"00",X"00",X"0E",X"5F",X"51",X"51",X"73",X"72",X"00",X"00",X"06",X"4F",X"49",X"69",X"3F",X"1E",
		X"00",X"00",X"60",X"70",X"58",X"4F",X"47",X"60",X"00",X"00",X"36",X"7F",X"49",X"49",X"7F",X"36",
		X"00",X"00",X"3C",X"7E",X"4B",X"49",X"49",X"39",X"00",X"00",X"1C",X"3E",X"61",X"43",X"3E",X"1C",
		X"C0",X"E0",X"FF",X"FF",X"1F",X"FC",X"F0",X"C0",X"1F",X"F8",X"F0",X"80",X"E0",X"F8",X"FF",X"FF",
		X"1F",X"F8",X"FC",X"FE",X"1F",X"FF",X"F6",X"FF",X"C0",X"E0",X"E0",X"C0",X"80",X"80",X"C0",X"80",
		X"80",X"C0",X"C0",X"E0",X"3C",X"FE",X"F3",X"FF",X"80",X"F0",X"E0",X"C0",X"60",X"F8",X"FC",X"FF",
		X"1F",X"FF",X"F6",X"FC",X"60",X"C0",X"C0",X"80",X"1F",X"FC",X"F8",X"E0",X"40",X"E0",X"F0",X"80",
		X"00",X"36",X"7F",X"49",X"49",X"7F",X"7F",X"00",X"00",X"1F",X"3F",X"64",X"64",X"3F",X"1F",X"00",
		X"00",X"00",X"00",X"49",X"49",X"49",X"7F",X"7F",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"03",X"20",X"30",X"0B",X"0B",X"0B",X"1C",X"00",X"00",X"00",X"10",X"30",X"70",X"40",X"E0",
		X"08",X"3B",X"33",X"23",X"00",X"00",X"00",X"00",X"40",X"40",X"30",X"10",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"08",X"00",X"00",X"00",X"00",X"00",X"7F",X"00",X"00",
		X"06",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"7F",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"01",X"03",X"00",X"40",X"00",X"00",X"00",X"00",X"FF",X"F0",X"00",X"00",
		X"38",X"03",X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"F0",X"FF",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"01",X"03",X"00",X"40",X"00",X"00",X"00",X"00",X"FF",X"F0",X"14",X"38",
		X"38",X"03",X"01",X"00",X"00",X"00",X"00",X"00",X"14",X"F0",X"FF",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"01",X"03",X"00",X"40",X"00",X"00",X"00",X"00",X"FF",X"F0",X"36",X"35",
		X"38",X"03",X"01",X"00",X"00",X"00",X"00",X"00",X"2A",X"F0",X"FF",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"01",X"01",X"00",X"02",X"02",X"00",X"00",X"00",X"00",X"00",X"20",X"00",X"80",
		X"23",X"02",X"02",X"00",X"01",X"01",X"00",X"00",X"F8",X"80",X"00",X"20",X"00",X"00",X"00",X"00",
		X"00",X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",X"00",
		X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",X"00",X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",X"7E",
		X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"00",X"00",X"00",X"00",X"00",X"80",X"80",X"C0",X"80",
		X"00",X"00",X"00",X"01",X"02",X"01",X"02",X"01",X"00",X"40",X"80",X"40",X"A0",X"40",X"A0",X"40",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"C0",X"C0",
		X"02",X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"02",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"40",
		X"00",X"02",X"00",X"00",X"00",X"00",X"00",X"00",X"F0",X"40",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"06",X"06",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"01",X"01",X"00",X"00",X"00",X"00",X"00",X"80",X"00",X"00",
		X"02",X"02",X"02",X"02",X"00",X"00",X"00",X"00",X"20",X"20",X"20",X"20",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"03",X"00",X"00",X"00",X"00",X"00",X"00",X"C0",X"00",
		X"04",X"08",X"00",X"00",X"01",X"00",X"00",X"00",X"00",X"00",X"40",X"80",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"0F",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"C0",
		X"00",X"00",X"0F",X"00",X"00",X"00",X"00",X"00",X"20",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"07",X"0F",X"3B",X"7B",X"7B",X"7B",X"7B",X"7B",
		X"00",X"00",X"03",X"04",X"00",X"00",X"00",X"00",X"8B",X"EB",X"EB",X"4B",X"2B",X"1B",X"07",X"00",
		X"10",X"10",X"10",X"10",X"00",X"00",X"00",X"02",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"03",X"07",X"07",X"00",X"00",X"00",X"00",X"00",X"C0",X"80",X"80",X"80",X"00",X"00",X"00",X"00",
		X"00",X"10",X"10",X"10",X"11",X"12",X"15",X"17",X"00",X"00",X"00",X"80",X"80",X"80",X"80",X"80",
		X"17",X"10",X"38",X"10",X"10",X"10",X"10",X"10",X"80",X"00",X"40",X"40",X"40",X"40",X"00",X"00",
		X"10",X"10",X"00",X"00",X"00",X"00",X"00",X"01",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"03",X"07",X"07",X"01",X"00",X"00",X"00",X"00",X"C0",X"C0",X"80",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"10",X"11",X"12",X"15",X"17",X"00",X"00",X"00",X"80",X"80",X"80",X"80",X"80",
		X"17",X"10",X"38",X"10",X"10",X"10",X"10",X"10",X"80",X"00",X"40",X"40",X"40",X"40",X"00",X"00",
		X"10",X"10",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"80",
		X"07",X"07",X"07",X"02",X"00",X"00",X"00",X"00",X"C0",X"C0",X"C0",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"00",X"10",X"11",X"12",X"15",X"17",X"00",X"00",X"00",X"80",X"80",X"80",X"80",X"80",
		X"17",X"10",X"38",X"10",X"10",X"10",X"10",X"10",X"80",X"00",X"40",X"40",X"40",X"40",X"00",X"00",
		X"07",X"03",X"03",X"07",X"03",X"03",X"07",X"03",X"FF",X"FF",X"FF",X"FF",X"F7",X"AB",X"01",X"AB",
		X"03",X"07",X"03",X"03",X"07",X"03",X"03",X"07",X"01",X"AB",X"DB",X"FF",X"FF",X"FF",X"FF",X"FF",
		X"01",X"05",X"03",X"03",X"00",X"07",X"07",X"0B",X"00",X"00",X"80",X"D0",X"F0",X"E0",X"60",X"E0",
		X"0D",X"06",X"15",X"1E",X"0C",X"03",X"02",X"01",X"D0",X"B0",X"38",X"D8",X"B0",X"70",X"C0",X"C0",
		X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"00",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"FF",X"00",
		X"FF",X"FF",X"FF",X"FF",X"FF",X"00",X"FF",X"00",X"FF",X"FF",X"FF",X"FF",X"FF",X"00",X"FF",X"00",
		X"FF",X"FF",X"FF",X"00",X"FF",X"00",X"FF",X"00",X"FF",X"FF",X"FF",X"00",X"FF",X"00",X"FF",X"00",
		X"FF",X"00",X"FF",X"00",X"FF",X"00",X"FF",X"00",X"FF",X"00",X"FF",X"00",X"FF",X"00",X"FF",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"04",X"3E",X"3B",X"69",X"6B",X"69",X"6B",X"29",
		X"00",X"00",X"03",X"04",X"00",X"00",X"00",X"00",X"8B",X"E9",X"EB",X"49",X"2B",X"1E",X"04",X"00",
		X"00",X"7E",X"0E",X"70",X"0E",X"70",X"7E",X"00",X"3F",X"1F",X"3F",X"1F",X"3F",X"1F",X"3F",X"00",
		X"00",X"00",X"00",X"FB",X"FB",X"00",X"00",X"00",X"00",X"10",X"20",X"20",X"44",X"44",X"44",X"44",
		X"00",X"00",X"05",X"01",X"03",X"03",X"05",X"07",X"80",X"A0",X"00",X"00",X"C0",X"40",X"D0",X"E0",
		X"35",X"0A",X"0F",X"0A",X"05",X"02",X"02",X"01",X"C8",X"B8",X"68",X"D0",X"B0",X"60",X"C0",X"80",
		X"00",X"00",X"00",X"01",X"00",X"00",X"02",X"01",X"40",X"20",X"30",X"20",X"20",X"60",X"B0",X"F0",
		X"05",X"03",X"01",X"03",X"02",X"05",X"03",X"01",X"70",X"F0",X"20",X"60",X"D0",X"B0",X"60",X"00",
		X"00",X"00",X"01",X"04",X"00",X"02",X"03",X"00",X"40",X"00",X"00",X"40",X"40",X"E0",X"E0",X"A0",
		X"07",X"06",X"0D",X"05",X"06",X"05",X"03",X"01",X"E0",X"60",X"B0",X"78",X"D0",X"A0",X"60",X"80",
		X"00",X"00",X"00",X"00",X"11",X"0E",X"05",X"0E",X"00",X"00",X"00",X"00",X"80",X"70",X"C0",X"D0",
		X"2B",X"0D",X"03",X"02",X"00",X"00",X"00",X"00",X"F0",X"A0",X"60",X"80",X"00",X"00",X"80",X"00",
		X"00",X"00",X"00",X"01",X"02",X"07",X"0D",X"0A",X"00",X"00",X"00",X"00",X"E8",X"D0",X"B0",X"F8",
		X"1A",X"1F",X"39",X"06",X"03",X"00",X"00",X"00",X"BC",X"28",X"F0",X"60",X"C0",X"00",X"00",X"00",
		X"00",X"00",X"04",X"0E",X"0F",X"18",X"09",X"07",X"00",X"00",X"C0",X"30",X"C8",X"74",X"D0",X"64",
		X"37",X"33",X"1B",X"08",X"01",X"03",X"00",X"00",X"32",X"76",X"6C",X"08",X"E8",X"80",X"00",X"00",
		X"00",X"01",X"13",X"23",X"0C",X"1E",X"26",X"4D",X"00",X"02",X"B8",X"EC",X"12",X"DC",X"EC",X"58",
		X"35",X"18",X"0B",X"25",X"03",X"0F",X"21",X"00",X"16",X"BB",X"6C",X"B4",X"34",X"B0",X"44",X"00",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"00",X"00",X"01",X"0E",X"05",X"0E",X"2A",X"0D",X"00",X"00",X"80",X"70",X"C0",X"D0",X"F0",X"A0",
		X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",X"00",
		X"01",X"02",X"07",X"0D",X"0A",X"1A",X"1F",X"39",X"00",X"E8",X"D0",X"B0",X"F8",X"BC",X"28",X"F0",
		X"00",X"00",X"00",X"00",X"00",X"00",X"04",X"0E",X"00",X"00",X"00",X"00",X"00",X"00",X"C0",X"30",
		X"0F",X"18",X"09",X"07",X"37",X"33",X"1B",X"26",X"C8",X"7C",X"D0",X"64",X"32",X"76",X"6C",X"54",
		X"00",X"00",X"00",X"01",X"07",X"07",X"0F",X"0F",X"00",X"00",X"80",X"80",X"80",X"C0",X"C0",X"60",
		X"07",X"07",X"03",X"00",X"00",X"00",X"00",X"00",X"40",X"00",X"40",X"00",X"00",X"00",X"00",X"00");
begin
process(clk)
begin
	if rising_edge(clk) then
		data <= rom_data(to_integer(unsigned(addr)));
	end if;
end process;
end architecture;
