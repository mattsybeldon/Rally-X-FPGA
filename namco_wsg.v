module namco_wsg(
	input wire clk, //96 kHz clock
	input wire reset,

	//v1 and v2 are to play background. Yes, V1 and V2 have different sizes. This happened in the original hardware
	input reg [3:0] v1_waveform,
	input reg [19:0] v1_freq, //20 bits in low nibbles
	input reg [3:0] v1_volume,

	input reg [3:0] v2_waveform,
	input reg [15:0] v2_freq, //20 bits in low nibbles
	input reg [3:0] v2_volume,

	//v3 plays sound effects
	input reg [3:0] v3_waveform,
	input reg [15:0] v3_freq, //20 bits in low nibbles
	input reg [3:0] v3_volume,

	//ROM interfaces
	output wire rom_clk, //Might remove this
	input reg [7:0] v1_rom_byte,
	input reg [7:0] v2_rom_byte,
	input reg [7:0] v3_rom_byte,
	output reg [7:0] v1_waveform_addr;
	output reg [7:0] v2_waveform_addr;
	output reg [7:0] v3_waveform_addr;

	//Interfaces with PWM unit
	output reg [7:0] pwm_dat
	);

reg [19:0] v1_accumulator;
reg [15:0] v2_accumulator;
reg [15:0] v3_accumulator;

assign rom_clk = clk;

always @(posedge reset) begin
	v1_accumulator = 20'b00000000000000000000;
	v2_accumualtor = 16'b0000000000000000;
	v2_accumualtor = 16'b0000000000000000;

	v1_waveform_addr = 8'b00000000;
	v2_waveform_addr = 8'b00000000;
	v3_waveform_addr = 8'b00000000;

	pwm_dat = 8'b00000000;
end

always @(posedge clk) begin
	//Add voice frequency to accumulator
	v1_accumulator = v1_accumulator + v1_freq;

	//Create sample address by concatenating waveform index with top 5 accumulator bits
	v1_waveform_addr = {v1_waveform[2:0], v1_accumulator[7:3]};
end

always @(posedge clk) begin
	v2_accumulator = v2_accumulator + v2_freq;
	v2_waveform_addr = {v2_waveform[2:0], v2_accumulator[7:3]};
	end

always @(posedge clk) begin
	v3_accumulator = v3_accumulator + v3_freq;
	v3_waveform_addr = {v3_waveform[2:0], v3_accumulator[7:3]};
end

//Ad the lower nibbles of the samples together and send to the PWM.
always @(posedge clk) begin
	pwm_dat = ((v1_rom_byte [3:0] * v1_volume) + (v2_rom_byte[3:0] * v2_volume) + (v3_rom_byte[3:0] * v3_volume)) << 2;
end