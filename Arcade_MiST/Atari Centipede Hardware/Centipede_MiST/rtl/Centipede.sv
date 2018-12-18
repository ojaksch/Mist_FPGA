//============================================================================
//  Arcade: Centipede
//
//  Port to MiST
//  Copyright (C) 2018 Gehstock
//
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License as published by the Free
//  Software Foundation; either version 2 of the License, or (at your option)
//  any later version.
//
//  This program is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
//  more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//============================================================================

module Centipede
(
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
	input         CLOCK_27
);

`include "rtl\build_id.v" 

localparam CONF_STR = {
	"Centipede;;",
	"O1,Test,off,on;", 
	"O34,Scandoubler Fx,None,HQ2x,CRT 25%,CRT 50%;",
	"O5,Joystick Control,Upright,Normal;",	
	"T7,Reset;",
	"V,v1.00.",`BUILD_DATE
};

wire [31:0] status;
wire  [1:0] buttons;
wire  [1:0] switches;
wire  [9:0] kbjoy;
wire  [7:0] joystick_0;
wire  [7:0] joystick_1;
wire        scandoubler_disable;
wire        ypbpr;
wire        ps2_kbd_clk, ps2_kbd_data;

assign LED = 1;

wire clk_24, clk_12, clk_6, clk_100mhz;
wire pll_locked;

pll pll
(
	.inclk0(CLOCK_27),
	.areset(0),
	.c0(clk_24),
	.c2(clk_12),
	.c3(clk_6),
	.c4(clk_100mhz)
);

//ToDo Joystick breaks Controls

wire m_up     = status[5] ? ~kbjoy[6] & ~joystick_0[1] & ~joystick_1[1] : ~kbjoy[4] & ~joystick_0[3] & ~joystick_1[3];
wire m_down   = status[5] ? ~kbjoy[7] & ~joystick_0[0] & ~joystick_1[0] : ~kbjoy[5] & ~joystick_0[2] & ~joystick_1[2];
wire m_left   = status[5] ? ~kbjoy[5] & ~joystick_0[2] & ~joystick_1[2] : ~kbjoy[6] & ~joystick_0[1] & ~joystick_1[1];
wire m_right  = status[5] ? ~kbjoy[4] & ~joystick_0[3] & ~joystick_1[3] : ~kbjoy[7] & ~joystick_0[0] & ~joystick_1[0];

wire m_fire   = ~kbjoy[0] | joystick_0[4] | joystick_1[4] | joystick_0[5] | joystick_1[5];
wire m_start = ~kbjoy[1];
wire m_coin   = kbjoy[3];
wire m_test = ~status[1];
wire m_slam = 1'b1;
wire m_cocktail = 1'b1;
wire 	[9:0] playerinput_i = { m_coin, m_coin, m_coin, m_test, m_cocktail, m_slam, m_start, m_start, m_fire, m_fire };

centipede centipede(
	.clk_100mhz(clk_100mhz),
	.clk_12mhz(clk_12),
 	.reset(status[0] | status[7] | buttons[1]),
	.playerinput_i(playerinput_i),
	.trakball_i(),
	.joystick_i({m_right , m_left, m_down, m_up, m_right , m_left, m_down, m_up}),
	.sw1_i(8'h54),
	.sw2_i(8'b0),
	.rgb_o({b,g,r}),
	.hsync_o(hs),
	.vsync_o(vs),
	.hblank_o(hblank),
	.vblank_o(vblank),
	.audio_o(audio)
	);


wire [3:0] audio;

dac dac (
	.clk_i(clk_24),
	.res_n_i(1),
	.dac_i({audio,audio,audio,audio}),
	.dac_o(AUDIO_L)
	);

assign AUDIO_R = AUDIO_L;

wire hs, vs;
wire [2:0] r, g, b;
wire hblank, vblank;
wire blankn = ~(hblank | vblank);
video_mixer #(.LINE_LENGTH(640), .HALF_DEPTH(1)) video_mixer
(
	.clk_sys(clk_24),
	.ce_pix(clk_6),
	.ce_pix_actual(clk_6),
	.SPI_SCK(SPI_SCK),
	.SPI_SS3(SPI_SS3),
	.SPI_DI(SPI_DI),
	.R(blankn?r:"000"),
	.G(blankn?g:"000"),
	.B(blankn?b:"000"),
	.HSync(hs),
	.VSync(vs),
	.VGA_R(VGA_R),
	.VGA_G(VGA_G),
	.VGA_B(VGA_B),
	.VGA_VS(VGA_VS),
	.VGA_HS(VGA_HS),
	.scandoubler_disable(scandoubler_disable),
	.scanlines(scandoubler_disable ? 2'b00 : {status[4:3] == 2'b11, status[4:3] == 2'b10, status[4:3] == 2'b01}),
	.hq2x(status[4:3]==1),
	.ypbpr_full(1),
	.line_start(0),
	.mono(0)
);

mist_io #(.STRLEN(($size(CONF_STR)>>3))) mist_io
(
	.clk_sys        (clk_24   	     ),
	.conf_str       (CONF_STR       ),
	.SPI_SCK        (SPI_SCK        ),
	.CONF_DATA0     (CONF_DATA0     ),
	.SPI_SS2			 (SPI_SS2        ),
	.SPI_DO         (SPI_DO         ),
	.SPI_DI         (SPI_DI         ),
	.buttons        (buttons        ),
	.switches   	 (switches       ),
	.scandoubler_disable(scandoubler_disable),
	.ypbpr          (ypbpr          ),
	.ps2_kbd_clk    (ps2_kbd_clk    ),
	.ps2_kbd_data   (ps2_kbd_data   ),
	.joystick_0   	 (joystick_0     ),
	.joystick_1     (joystick_1     ),
	.status         (status         )
);

keyboard keyboard(
	.clk(clk_24),
	.reset(),
	.ps2_kbd_clk(ps2_kbd_clk),
	.ps2_kbd_data(ps2_kbd_data),
	.joystick(kbjoy)
	);


endmodule
