module pwm(
	input wire clk, //This should be much faster than 96 kHz
	input wire reset,

	//From the WSG
	input reg [7:0] pwm_dat,

	//DE1 IP specific
	output reg aud_xclk,
	inout wire aud_bclk,
	output reg aud_dacdat,
	inout wire aud_daclrck,
	output wire i2c_sclk,
	inout wire i2c_sdat
	);

parameter threshold = 8'b00001111;  //Might need to change this to a different value

always @(posedge reset) begin
	aud_xclk = 0;
	aud_dacdat = 0;
	aud_daclrck = 0;
	aud_adclrck = 0;
end

//Will need to do clk divisions

always @(posedge clk) begin
	aud_dacdat = (pwm_dat >= threshold) ? 1'b1 : 1'b0;
end

endmodule