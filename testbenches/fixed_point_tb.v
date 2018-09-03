`timescale 10ns/10ps

module fixed_point_tb();

parameter NUM_BITS_DATA = 8;

reg clk = 0;
/*reg[NUM_BITS_DATA-1:0] data_addr;
wire[NUM_BITS_DATA-1:0] data_out_integer;
wire[NUM_BITS_DATA-1:0] data_out_fractional;
wire[NUM_BITS_DATA-1:0] data_out_fractional_pre;
wire[4*NUM_BITS_DATA-1:0] data_pre_div;*/
wire[31:0] count_out;
wire[31:0] sum_out;
wire[15:0] boundaries_output;
wire[15:0] a_out;

fixed_point fixed_point_inst(
	.clk(clk),
	/*.data_out_integer(data_out_integer),
	.data_out_fractional(data_out_fractional),
	.data_out_fractional_pre(data_out_fractional_pre),
	.data_addr(data_addr),
	.data_pre_div(data_pre_div),*/
	.count_out(count_out),
	.sum_out(sum_out),
	.boundaries_output(boundaries_output),
	.a_out(a_out)
);

always begin
	#0.5 clk = ~clk;
end

initial begin
	$dumpfile ("fixed_point.vcd"); 
	$dumpvars;
end

initial begin
	/*#10

	data_addr <= 8'b0000;

	#10

	data_addr <= 8'b0001;

	#10

	data_addr <= 8'b0010;

	#10

	data_addr <= 8'b0011;

	#10

	data_addr <= 8'b1010;

	#10

	data_addr <= 8'b1011;

	#10

	data_addr <= 8'b1100;

	#10

	data_addr <= 8'b1101;

	#10

	data_addr <= 8'b1110;

	#10

	data_addr <= 8'b1111;

	#10

	data_addr <= 8'b10000;

	#10

	data_addr <= 8'b10001;

	#10

	data_addr <= 8'b10010;*/
	
	#40200
	
	$finish;
	
end

endmodule
