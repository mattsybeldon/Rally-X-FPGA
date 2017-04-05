module Rally_X_Top(
	input clk,
	input reset
);

z80_top_direct_n z80_cpu(
	.nM1,
    .nMREQ,
    .nIORQ,
    .nRD,
    .nWR,
    .nRFSH,
    .nHALT,
    .nBUSACK,

    .nWAIT,
    .nINT,
    .nNMI,
    .nRESET (reset),
    .nBUSRQ,

    .CLK (clk),
    .A,
   .D
);