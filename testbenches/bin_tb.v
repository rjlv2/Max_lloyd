module bin();

reg[7:0] bin_boundaries[0:8]

initial begin
	bin_boundaries[0] = 8'b00000000;
	bin_boundaries[1] = 8'b00011111;
	bin_boundaries[2] = 8'b00111111;
	bin_boundaries[3] = 8'b01011111;
	bin_boundaries[4] = 8'b01111111;
	bin_boundaries[5] = 8'b10011111;
	bin_boundaries[6] = 8'b10111111;
	bin_boundaries[7] = 8'b11011111;
	bin_boundaries[8] = 8'b11111111;
end


endmodule
