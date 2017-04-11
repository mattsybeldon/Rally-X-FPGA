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
always @(posedge clk) begin
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
		ack 3 = 0;
		transmission_end = 1;
		ack_en = 1;
		sclk = 1;
		sdo = 1;
	end else begin
		case (sd_counter)
			7'd1: begin end
			7'd2: begin end
			7'd3: begin end
			7'd4: begin end
			7'd5: begin end
			7'd6: begin end
			7'd7: begin end
			7'd8: begin end
			7'd9: begin end
			7'd10: begin end
			7'd11: begin end
			7'd12: begin end
			7'd13: begin end
			7'd14: begin end
			7'd15: begin end
			7'd16: begin end
			7'd17: begin end
			7'd18: begin end
			7'd19: begin end
			7'd20: begin end
			7'd21: begin end
			7'd22: begin end
			7'd23: begin end
			7'd24: begin end
			7'd25: begin end
			7'd26: begin end
			7'd27: begin end
			7'd28: begin end
			7'd29: begin end
			7'd30: begin end
			7'd31: begin end
			7'd32: begin end
			7'd33: begin end
			7'd34: begin end
			7'd35: begin end
			7'd36: begin end
			7'd37: begin end
			7'd38: begin end
			7'd39: begin end
			7'd40: begin end
			7'd41: begin end
			7'd42: begin end
			7'd43: begin end
			7'd44: begin end
			7'd45: begin end
			7'd46: begin end
			7'd47: begin end
			7'd48: begin end
			7'd49: begin end
			7'd50: begin end
			7'd51: begin end
			7'd52: begin end
			7'd53: begin end
			7'd54: begin end
			7'd55: begin end
			7'd56: begin end
			7'd57: begin end
			7'd58: begin end
			7'd59: begin end
			7'd60: begin end
			7'd61: begin end
			7'd62: begin end
			7'd63: begin end
			7'd64: begin end
			7'd65: begin end
			7'd66: begin end
			7'd67: begin end
			7'd68: begin end
			7'd69: begin end
			7'd70: begin end
			7'd71: begin end
			7'd72: begin end
			7'd73: begin end
			7'd74: begin end
			7'd75: begin end
			7'd76: begin end
			7'd77: begin end
			7'd78: begin end
			7'd79: begin end
			7'd80: begin end
			7'd81: begin end
			7'd82: begin end
			7'd83: begin end
			7'd84: begin end
			7'd85: begin end
			7'd86: begin end
			7'd87: begin end
			7'd88: begin end
			7'd89: begin end
			7'd90: begin end
			7'd91: begin end
			7'd92: begin end
			7'd93: begin end
			7'd94: begin end
			7'd95: begin end
			7'd96: begin end
			7'd97: begin end
			7'd98: begin end
			7'd99: begin end
			7'd100: begin end
			7'd101: begin end
			7'd102: begin end
			7'd103: begin end
			7'd104: begin end
			7'd105: begin end
			7'd106: begin end
			7'd107: begin end
			7'd108: begin end
			7'd109: begin end
			7'd110: begin end
			7'd111: begin end
			7'd112: begin end
			7'd113: begin end
			7'd114: begin end
			7'd115: begin end
			7'd116: begin end
			7'd117: begin end
			7'd118: begin end
		endcase
	end
end

endmodule
