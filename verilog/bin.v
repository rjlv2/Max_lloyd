module bin();

reg[7:0] bin_boundaries[0:20]

integer i;

initial begin
	bin_boundaries[0] = 0;
	bin_boundaries[20] = 255;
	for(i=1; i<20; i++) begin
		bin_boundaries[i] = (i*255)/20;
	end
end


endmodule
