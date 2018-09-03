
module fixed_point(
	input clk,
	/*input[NUM_BITS_DATA-1:0] data_addr,
	output [NUM_BITS_DATA-1:0] data_out_integer,
	output [NUM_BITS_DATA-1:0] data_out_fractional,
	output [NUM_BITS_DATA-1:0] data_out_fractional_pre,
	output [4*NUM_BITS_DATA-1:0] data_pre_div,*/
	output [31:0] count_out,
	output [31:0] sum_out,
	output [15:0] boundaries_output,
	output [15:0] a_out
);

parameter NUM_BITS_DATA = 8;
parameter NUMBER_OF_DATA = 200;

reg[NUM_BITS_DATA-1:0] data[0:NUMBER_OF_DATA-1];

//Bin boundaries and bin means
integer count[0:20];
integer sum[0:20];
reg[15:0] bin_boundaries[0:21];
//reg[7:0] bin_boundaries_int[0:21];
//reg[7:0] bin_boundaries_frac[0:21];
reg[15:0] a[0:20];
//reg[7:0] a_int[0:20];
//reg[7:0] a_frac[0:20];

integer i = 0;



initial begin
	//read in test data from file
	$readmemh("/home/ryan/verilog_quantisation/verilog/dataout.hex", data);
	
	//initialize boundaries
	bin_boundaries[0] = 16'd32768; //-128*256
	bin_boundaries[20] = 16'd32512; //127*256
	for(i=1; i<20; i++) begin
		bin_boundaries[i] = i*2560-32768;
	end
	
	//set count to 0
	for(i=0; i<20; i++) begin
		count[i] = 0;
	end
	
	//set sum to 0
	for(i=0; i<NUMBER_OF_DATA; i++) begin
		sum[i] = 0;
	end
	
	//set a to 0
	for(i=0; i<20; i++) begin
		a[i]=0;
	end
end

reg[7:0] index = 0;
integer data_index = 0;
integer hold_count;
integer hold_sum;
integer itr = 0;

//state machine
integer state = 0;
parameter search_location = 0;
parameter update_count_sum = 1;
parameter update_a = 2;
parameter update_boundaries = 3;
parameter check_iteration = 4;
parameter idle = 5;

always @(posedge clk) begin
	case (state)
		search_location: begin
			index = 0;
			while($signed(data[data_index])*256 >= $signed(bin_boundaries[index])) begin
				index++;
			end
			index--;//go back one space
			state = update_count_sum;
		end
		
		update_count_sum: begin
			//increment count
			hold_count = count[index]; 
			count[index] = hold_count + 1;
			
			//add to sum
			hold_sum = sum[index];
			sum[index] = hold_sum + $signed(data[data_index])*256;
			
			if(data_index == NUMBER_OF_DATA-1) begin
				state = update_a;
			end else begin //go to the next data
				data_index++;
				state = search_location;
			end
		end
		
		update_a: begin
			for(i=0; i<20; i++) begin
				if(count[i] != 0) begin
					a[i] = sum[i] / count[i];
				end
			end
			state=update_boundaries;
		end
		
		update_boundaries: begin
			//reset data_index
			data_index = 0;
			//update boundaries
			for(i=1; i<20; i++) begin
				bin_boundaries[i] = (a[i] + a[i-1])/2; 
			end
			state = check_iteration;
		end
		
		check_iteration: begin
			//clear count and sum
			for(i=0; i<20; i++) begin
				count[i] = 0;
			end
			for(i=0; i<NUMBER_OF_DATA; i++) begin
				sum[i] = 0;
			end
			
			//next iteration
			itr++;
			if(itr == 100) state = idle;
			else state = search_location;
		end
		
		idle: begin
			//nothing?
		end

	endcase
end

/*assign data_pre_div = $signed(bin_boundaries[data_addr]);
assign data_out_integer = ($signed(bin_boundaries[data_addr]) + $signed(bin_boundaries[data_addr+1]) + $signed(bin_boundaries[data_addr+2]) + $signed(bin_boundaries[data_addr+3])) / 11;
assign data_out_fractional_pre = ($signed(bin_boundaries[data_addr]) + $signed(bin_boundaries[data_addr+1]) + $signed(bin_boundaries[data_addr+2]) + $signed(bin_boundaries[data_addr+3])) % 11;
assign data_out_fractional = ((($signed(bin_boundaries[data_addr]) + $signed(bin_boundaries[data_addr+1]) + $signed(bin_boundaries[data_addr+2]) + $signed(bin_boundaries[data_addr+3])) % 11)*128) / 11;*/
assign count_out = count[index];
assign sum_out = sum[index]/256;
assign boundaries_output = bin_boundaries[1]/256;
assign a_out = a[1]/256;

endmodule
