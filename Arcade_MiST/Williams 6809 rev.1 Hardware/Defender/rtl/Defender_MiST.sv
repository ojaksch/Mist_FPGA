//============================================================================
//  Arcade: Defender
//

module Defender_MiST(
	output        LED,						
	output  [5:0] VGA_R,
	output  [5:0] VGA_G,
	output  [5:0] VGA_B,
	output        VGA_HS,
	output        VGA_VS,
	output        AUDIO_L,
	output        AUDIO_R,	
	input         SPI_SCK,
	output        SPI_DO,
	input         SPI_DI,
	input         SPI_SS2,
	input         SPI_SS3,
	input         CONF_DATA0,
	input         CLOCK_27,

	output [12:0] SDRAM_A,
	inout  [15:0] SDRAM_DQ,
	output        SDRAM_DQML,
	output        SDRAM_DQMH,
	output        SDRAM_nWE,
	output        SDRAM_nCAS,
	output        SDRAM_nRAS,
	output        SDRAM_nCS,
	output  [1:0] SDRAM_BA,
	output        SDRAM_CLK,
	output        SDRAM_CKE
);

`include "rtl/build_id.v" 

localparam CONF_STR = {
	"DEFENDER;;",
	"O34,Scanlines,Off,25%,50%,75%;",
	"T6,Reset;",
	"V,v1.1.5.",`BUILD_DATE
};

assign LED = 1;
assign SDRAM_CLK = clk_sys;

wire clk_sys, clock_6, clock_0p89;
wire pll_locked;
pll_mist pll(
	.inclk0(CLOCK_27),
	.areset(0),
	.c0(clk_sys),//36
	.c1(clock_6),//6
	.c2(clock_0p89),//0.89
	.locked(pll_locked)
	);

wire [31:0] status;
wire  [1:0] buttons;
wire  [1:0] switches;
wire  [7:0] joystick_0;
wire  [7:0] joystick_1;
wire        scandoublerD;
wire        ypbpr;
wire [10:0] ps2_key;
wire  [7:0] audio;
wire        hs, vs;
wire        blankn;
wire  [2:0] r,g;
wire  [1:0] b;

wire [14:0] rom_addr;
wire [15:0] rom_do;
wire        rom_rd;
wire        ioctl_downl;
wire  [7:0] ioctl_index;
wire        ioctl_wr;
wire [24:0] ioctl_addr;
wire  [7:0] ioctl_dout;

data_io data_io (
	.clk_sys       ( clk_sys      ),
	.SPI_SCK       ( SPI_SCK      ),
	.SPI_SS2       ( SPI_SS2      ),
	.SPI_DI        ( SPI_DI       ),
	.ioctl_download( ioctl_downl  ),
	.ioctl_index   ( ioctl_index  ),
	.ioctl_wr      ( ioctl_wr     ),
	.ioctl_addr    ( ioctl_addr   ),
	.ioctl_dout    ( ioctl_dout   )
);
		
sdram cart
(
	.*,
	.init          ( ~pll_locked  ),
	.clk           ( clk_sys      ),
	.wtbt          ( 2'b00        ),
	.dout          ( rom_do     ),
	.din           ( {ioctl_dout, ioctl_dout} ),
	.addr          ( ioctl_downl ? ioctl_addr : rom_addr ),
	.we            ( ioctl_downl & ioctl_wr ),
	.rd            ( !ioctl_downl & rom_rd ),
	.ready()
);

reg reset = 1;
reg rom_loaded = 0;
always @(posedge clk_sys) begin
	reg ioctl_downlD;
	ioctl_downlD <= ioctl_downl;

	if (ioctl_downlD & ~ioctl_downl) rom_loaded <= 1;
	reset <= status[0] | buttons[1] | status[6] | ~rom_loaded;
end

defender defender (
	.clock_6				(clock_6),
	.clk_0p89			(clock_0p89),
	.reset        		( reset ),
	.video_r      		( r               ),
	.video_g      		( g               ),
	.video_b      		( b               ),
   .video_hs     		( hs              ),
	.video_vs     		( vs              ),
	.video_blankn 		( blankn          ),
	.audio_out    		( audio           ),	
	.roms_addr 			( rom_addr       ),
	.roms_do   			( rom_do[7:0]   ),
	.vma					( rom_rd				),
	.btn_two_players  ( btn_two_players ),
	.btn_one_player   ( btn_one_player  ),
	.btn_left_coin    ( btn_coin        ),
	.btn_auto_up		(btn_auto_up),
	.btn_advance		(btn_advance),
	.btn_high_score_reset(btn_score_reset),
	.btn_fire			(m_fire1),
	.btn_thrust			(m_fire2),
	.btn_smart_bomb	(m_fire3),
	.btn_hyperSpace	(m_fire4),
	.btn_reverse		(m_left | m_right),
	.btn_down			(m_down),
	.btn_up				(m_up),
   .sw_coktail_table	(1)
);

mist_video #(.COLOR_DEPTH(3), .SD_HCNT_WIDTH(10)) mist_video(
	.clk_sys        ( clk_sys          ),
	.SPI_SCK        ( SPI_SCK          ),
	.SPI_SS3        ( SPI_SS3          ),
	.SPI_DI         ( SPI_DI           ),
	.R              ( blankn ? r : 0   ),
	.G              ( blankn ? g : 0   ),
	.B              ( blankn ? {b, b[1] }  : 0   ),
	.HSync          ( hs               ),
	.VSync          ( vs               ),
	.VGA_R          ( VGA_R            ),
	.VGA_G          ( VGA_G            ),
	.VGA_B          ( VGA_B            ),
	.VGA_VS         ( VGA_VS           ),
	.VGA_HS         ( VGA_HS           ),
	.rotate         ( {1'b1,status[2]} ),
	.scandoubler_disable( scandoublerD ),
	.scanlines      ( status[4:3]      ),
	.ypbpr          ( ypbpr            )
	);

user_io #(
	.STRLEN(($size(CONF_STR)>>3)))
user_io(
	.clk_sys        (clk_sys        ),
	.conf_str       (CONF_STR       ),
	.SPI_CLK        (SPI_SCK        ),
	.SPI_SS_IO      (CONF_DATA0     ),
	.SPI_MISO       (SPI_DO         ),
	.SPI_MOSI       (SPI_DI         ),
	.buttons        (buttons        ),
	.switches       (switches       ),
	.scandoubler_disable (scandoublerD	  ),
	.ypbpr          (ypbpr          ),
	.key_strobe     (key_strobe     ),
	.key_pressed    (key_pressed    ),
	.key_code       (key_code       ),
	.joystick_0     (joystick_0     ),
	.joystick_1     (joystick_1     ),
	.status         (status         )
	);

wire dac_o;
assign AUDIO_L = dac_o;
assign AUDIO_R = dac_o;

dac #(
	.C_bits(15))
dac(
	.clk_i(clock_0p89),
	.res_n_i(1),
	.dac_i({audio,audio}),
	.dac_o(dac_o)
	);

wire m_up     = btn_up | joystick_0[3] | joystick_1[3];
wire m_down   = btn_down | joystick_0[2] | joystick_1[2];
wire m_left   = btn_left | joystick_0[1] | joystick_1[1];
wire m_right  = btn_right | joystick_0[0] | joystick_1[0];
wire m_fire1   = btn_fire1 | joystick_0[4] | joystick_1[4];
wire m_fire2   = btn_fire2 | joystick_0[5] | joystick_1[5];
wire m_fire3   = btn_fire3 | joystick_0[6] | joystick_1[6];
wire m_fire4   = btn_fire4 | joystick_0[7] | joystick_1[7];

reg btn_one_player = 0;
reg btn_two_players = 0;
reg btn_left = 0;
reg btn_right = 0;
reg btn_down = 0;
reg btn_up = 0;
reg btn_fire1 = 0;
reg btn_fire2 = 0;
reg btn_fire3 = 0;
reg btn_fire4 = 0;
reg btn_coin  = 0;
reg btn_advance = 0;
reg btn_auto_up = 0;
reg btn_score_reset = 0;
wire       key_pressed;
wire [7:0] key_code;
wire       key_strobe;

always @(posedge clk_sys) begin
	if(key_strobe) begin
		case(key_code)
			'h75: btn_up          <= key_pressed; // up
			'h72: btn_down        <= key_pressed; // down
			'h6B: btn_left        <= key_pressed; // left
			'h74: btn_right       <= key_pressed; // right
			'h76: btn_coin        <= key_pressed; // ESC
			'h05: btn_one_player  <= key_pressed; // F1
			'h06: btn_two_players <= key_pressed; // F2
			'h12: btn_fire4       <= key_pressed; // l shift
			'h14: btn_fire3       <= key_pressed; // ctrl
			'h11: btn_fire2       <= key_pressed; // alt
			'h29: btn_fire1       <= key_pressed; // Space
			'h1C: btn_advance      <= key_pressed; // A
			'h3C: btn_auto_up      <= key_pressed; // U
			'h33: btn_score_reset  <= key_pressed; // H
		endcase
	end
end

endmodule 
