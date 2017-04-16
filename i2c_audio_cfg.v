module i2c_audio_cfg(
	input clk,
	input reset,
	input SCLK,
	input msg_end,
	input msg_ack,
	input [3:0] msg_step,

	output reg msg_go,
	output reg [23:0] i2c_data
	);

parameter LUT_size = 32;

parameter set_audio = 10; //Change this

//Define these according to the documentation for the DAC
parameter LT_MSG = 999999999999;
parameter LT_END = 999999999999;
parameter LUT_1 = 999999999999;
parameter LUT_2 = 999999999999;
parameter LUT_3 = 999999999999;
parameter LUT_4 = 999999999999;
parameter LUT_5 = 999999999999;
parameter LUT_6 = 999999999999;
parameter LUT_7 = 999999999999;
parameter LUT_8 = 999999999999;
parameter LUT_9 = 999999999999;
parameter LUT_10 = 999999999999;
parameter LUT_11 = 999999999999;
parameter LUT_12 = 999999999999;
parameter LUT_13 = 999999999999;
parameter LUT_14 = 999999999999;
parameter LUT_15 = 999999999999;
parameter LUT_16 = 999999999999;
parameter LUT_17 = 999999999999;
parameter LUT_18 = 999999999999;
parameter LUT_19 = 999999999999;
parameter LUT_20 = 999999999999;
parameter LUT_21 = 999999999999;


reg [5:0] LUT_index;

always @(posedge clk) begin
	if (!reset) begin
		LUT_index <= 0;
		msg_step <= 0;
		msg_go <= 0;
	end else begin
		if (LUT_index < LUT_size) begin
			case(msg_step)
				0: begin
					if (SCLK) begin
						if (LUT_index < set_audio) begin
							i2c_data <= {LT_MSG, LUT_data};
						end else begin
							i2c_data <= {LT_END, LUT_data};
							msg_go <= 1;
							msg_step <= 1;
						end
					end
				end

				1: begin
					if (msg_end) begin
						if (msg_ack) begin
							msg_step <= 2;
						end else begin
							msg_step <= 0;
							msg_go <= 0;
						end
					end
				end

				2: begin
					LUT_index <= LUT_index + 1;
					msg_step <= 0;
				end

				endcase
		end
	end
end

always @(posedge clk) begin
	case (LUT_index)
		set_audio: LUT_data <= LUT_0;
		set_audio + 1: LUT_data <= LUT_1;
		set_audio + 2: LUT_data <= LUT_2;
		set_audio + 3: LUT_data <= LUT_3;
		set_audio + 4: LUT_data <= LUT_4;
		set_audio + 5: LUT_data <= LUT_5;
		set_audio + 6: LUT_data <= LUT_6;
		set_audio + 7: LUT_data <= LUT_7;
		set_audio + 8: LUT_data <= LUT_8;
		set_audio + 9: LUT_data <= LUT_9;
		set_audio + 10: LUT_data <= LUT_10;
		set_audio + 11: LUT_data <= LUT_11;
		set_audio + 12: LUT_data <= LUT_12;
		set_audio + 13: LUT_data <= LUT_13;
		set_audio + 14: LUT_data <= LUT_14;
		set_audio + 15: LUT_data <= LUT_15;
		set_audio + 16: LUT_data <= LUT_16;
		set_audio + 17: LUT_data <= LUT_17;
		set_audio + 18: LUT_data <= LUT_18;
		set_audio + 19: LUT_data <= LUT_19;
		set_audio + 20: LUT_data <= LUT_20;
		set_audio + 21: LUT_data <= LUT_21;


end