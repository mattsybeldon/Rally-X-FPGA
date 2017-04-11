module i2c_master(
	input clk, //27 MHz clock
	input reset,

	output wire i2c_sclk, //40 kHz clock

	inout wire i2c_sdat

	output reg transmission_end,
	output reg ack,
	output reg ack_en
	)

parameter clk_src_freq = 27000000;
parameter i2c_freq = 40000;

reg [15:0] clk_divider;
reg [23:0] sd;
reg [6:0] sd_counter;

reg sdo;

reg ack1;
reg ack2;
reg ack3;

reg sclk;

wire [23:0] data;
wire go;
wire [3:0] msg_step;



assign i2c_sclk = !transmission_end ?  sclk : 1;
assign i2c_sdat = ack_en ? sdo : 1'bz;

assign ack = ack1 | ack2 | ack3;

//Clock division shenanigans
always @(posedge i2c_clk) begin
	if (!reset) begin
		clk_divider <= 0;
		i2c_sclk <= 0;
	end else begin
		if (clk_divider < (clk_src_freq/i2c_freq)) begin
			clk_divider <= clk_divider + 1;
		end else begin
			clk_divider <= 0;
			i2c_sclk <= ~i2c_sclk;
		end
	end
end

//Track the message spot
always @(posedge i2c_sclk) begin
	if (!reset) begin
		sd_counter = 7'b1111111;
	end else begin
		if (!go) begin
			sd_counter = 7'b0000000;
		end else if ((sd_counter < 7'b1110111) & (!transmission_end)) begin
			sd_counter = sd_counter + 1;
		end
	end
end

//Begin crazy I2C code here
always @ (posedge clk) begin
	if (!reset) begin
		ack1 = 0;
		ack2 = 0;
		ack3 = 0;
		transmission_end = 1;
		ack_en = 1;
		sclk = 1;
		sdo = 1;
	end else begin
		case (sd_counter)
			7'd1: begin SD = (data); sdo = 0; end

			7'd2: begin sd[23]; sclk = 0; end
			7'd3: begin sd[23]; sclk = 1; end
			7'd4: begin sd[23]; sclk = 1;end 
			7'd5: begin sd[23]; sclk = 0;end

			7'd6: begin sd[22]; sclk = 0; end
			7'd7: begin sd[22]; sclk = 1; end
			7'd8: begin sd[22]; sclk = 1; end
			7'd9: begin sd[22]; sclk = 0; end

			7'd10: begin sd[21]; sclk = 0; end
			7'd11: begin sd[21]; sclk = 1; end
			7'd12: begin sd[21]; sclk = 1; end
			7'd13: begin sd[21]; sclk = 0; end

			7'd14: begin sd[20]; sclk = 0; end
			7'd15: begin sd[20]; sclk = 1; end
			7'd16: begin sd[20]; sclk = 1; end
			7'd17: begin sd[20]; sclk = 0; end

			7'd18: begin sd[19]; sclk = 0; end
			7'd19: begin sd[19]; sclk = 1; end
			7'd20: begin sd[19]; sclk = 1; end
			7'd21: begin sd[19]; sclk = 0; end

			7'd22: begin sd[18]; sclk = 0; end
			7'd23: begin sd[18]; sclk = 1; end
			7'd24: begin sd[18]; sclk = 1; end
			7'd25: begin sd[18]; sclk = 0; end

			7'd26: begin sd[17]; sclk = 0; end
			7'd27: begin sd[17]; sclk = 1; end
			7'd28: begin sd[17]; sclk = 1; end
			7'd29: begin sd[17]; sclk = 0; end

			7'd30: begin sd[16]; sclk = 0; end
			7'd31: begin sd[16]; sclk = 1; end
			7'd32: begin sd[16]; sclk = 1; end
			7'd33: begin sd[16]; sclk = 0; end

			//First acknowledge
			7'd34: begin sdo = 0; sclk = 0; end
			7'd35: begin sdo = 0; sclk = 1; end
			7'd36: begin sdo = 0; sclk = 1; end
			7'd37: begin ack1 = i2c_sdat; sclk = 0; ack_en = 0; end
			7'd38: begin ack1 = i2c_sdat; sclk = 0; ack_en = 0; end
			7'd39: begin sdo = 0 sclk = 0; ack_en = 1; end

			7'd40: begin sd[15]; sclk = 0; end
			7'd41: begin sd[15]; sclk = 1; end
			7'd42: begin sd[15]; sclk = 1; end
			7'd43: begin sd[15]; sclk = 0; end

			7'd44: begin sd[14]; sclk = 0; end
			7'd45: begin sd[14]; sclk = 1; end
			7'd46: begin sd[14]; sclk = 1; end
			7'd47: begin sd[14]; sclk = 0; end

			7'd48: begin sd[13]; sclk = 0; end
			7'd49: begin sd[13]; sclk = 1; end
			7'd50: begin sd[13]; sclk = 1; end
			7'd51: begin sd[13]; sclk = 0; end

			7'd52: begin sd[12]; sclk = 0; end
			7'd53: begin sd[12]; sclk = 1; end
			7'd54: begin sd[12]; sclk = 1; end
			7'd55: begin sd[12]; sclk = 0; end

			7'd56: begin sd[11]; sclk = 0; end
			7'd57: begin sd[11]; sclk = 1; end
			7'd58: begin sd[11]; sclk = 1; end
			7'd59: begin sd[11]; sclk = 0; end

			7'd60: begin sd[10]; sclk = 0; end
			7'd61: begin sd[10]; sclk = 1; end
			7'd62: begin sd[10]; sclk = 1; end
			7'd63: begin sd[10]; sclk = 0; end

			7'd64: begin sd[9]; sclk = 0; end
			7'd65: begin sd[9]; sclk = 1; end
			7'd66: begin sd[9]; sclk = 1; end
			7'd67: begin sd[9]; sclk = 0; end

			7'd68: begin sd[8]; sclk = 0; end
			7'd69: begin sd[8]; sclk = 1; end
			7'd70: begin sd[8]; sclk = 1; end
			7'd71: begin sd[8]; sclk = 0; end

			//Second acknowledge
			7'd72: begin sdo = 0; sclk = 0; end
			7'd73: begin sdo = 0; sclk = 1; end
			7'd74: begin sdo = 0; sclk = 1; end
			7'd75: begin ack1 = i2c_sdat; sclk = 0; ack_en = 0; end
			7'd76: begin ack1 = i2c_sdat; sclk = 0; ack_en = 0; end
			7'd77: begin sdo = 0; sclk = 0; ack_en = 1; end

			7'd78: begin sd[7]; sclk = 0; end
			7'd79: begin sd[7]; sclk = 1; end
			7'd80: begin sd[7]; sclk = 1; end
			7'd81: begin sd[7]; sclk = 0; end

			7'd82: begin sd[6]; sclk = 0; end
			7'd83: begin sd[6]; sclk = 1; end
			7'd84: begin sd[6]; sclk = 1; end
			7'd85: begin sd[6]; sclk = 0; end

			7'd86: begin sd[5]; sclk = 0; end
			7'd87: begin sd[5]; sclk = 1; end
			7'd88: begin sd[5]; sclk = 1; end
			7'd89: begin sd[5]; sclk = 0; end

			7'd90: begin sd[4]; sclk = 0; end
			7'd91: begin sd[4]; sclk = 1; end
			7'd92: begin sd[4]; sclk = 1; end
			7'd93: begin sd[4]; sclk = 0; end

			7'd94: begin sd[3]; sclk = 0; end
			7'd95: begin sd[3]; sclk = 1; end
			7'd96: begin sd[3]; sclk = 1; end
			7'd97: begin sd[3]; sclk = 0; end

			7'd98: begin sd[2]; sclk = 0; end
			7'd99: begin sd[2]; sclk = 1; end
			7'd100: begin sd[2]; sclk = 1; end
			7'd101: begin sd[2]; sclk = 0; end

			7'd102: begin sd[1]; sclk = 0; end
			7'd103: begin sd[1]; sclk = 1; end
			7'd104: begin sd[1]; sclk = 1; end
			7'd105: begin sd[1]; sclk = 0; end

			7'd106: begin sd[0]; sclk = 0; end
			7'd107: begin sd[0]; sclk = 1; end
			7'd108: begin sd[0]; sclk = 1; end
			7'd109: begin sd[0]; sclk = 0; end

			//Last acknowledge
			7'd110: begin sdo = 0; sclk = 0; end
			7'd111: begin sdo = 0; sclk = 1; end
			7'd112: begin sdo = 0; sclk = 1; end
			7'd113: begin ack1 = i2c_sdat; sclk = 0; ack_en = 0; end
			7'd114: begin ack1 = i2c_sdat; sclk = 0; ack_en = 0; end
			7'd115: begin sdo = 0; sclk = 0; ack_en = 1; end

			//Stop
			7'd116: begin sclk = 0; sdo = 0; end
			7'd117: begin sclk = 1; end
			7'd118: begin sdo = 1; transmission_end = 1;end
		endcase
	end
end

endmodule
