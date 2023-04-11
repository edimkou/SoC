//////////////////////////////////////////////////////////////////////////////////
//This module has been taken ready-made from OpenCores.
//Project maintainer: Mr. Burke, Tom.
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module qmults(
	input 	[31:0]  i_multiplicand,
	input 	[31:0]	i_multiplier,
	input 	i_start,
	input 	i_clk,
	output 	[31:0] o_result_out,
	output  reg o_complete,
	output 	 o_overflow
	);

	reg [62:0]	reg_working_result;		//	a place to accumulate our result
	reg [62:0]	reg_multiplier_temp;		//	a working copy of the multiplier
	reg [31:0]		reg_multiplicand_temp;	//	a working copy of the umultiplicand
	
	reg [5:0] reg_count; 		//	This is obviously a lot bigger than it needs to be, as we only need 
								//		count to N, but computing that number of bits requires a 
								//		logarithm (base 2), and I don't know how to do that in a 
								//		way that will work for every possibility
										 
	//reg		reg_done;		//	Computation completed flag
	reg		reg_sign;		//	The result's sign bit
	reg		reg_overflow;	//	Overflow flag

	reg reg_done_in;
	reg reg_overflow_in;


	//initial reg_done = 1'b1;			//	Initial state is to not be doing anything
	//initial reg_overflow = 1'b0;		//		And there should be no woverflow present
	//initial reg_sign = 1'b0;			//		And the sign should be positive
	
	assign o_result_out[30:0] = i_start ? reg_working_result[46:16] : 31'b0;	//	The multiplication results
	assign o_result_out[31] = reg_sign;								//	The sign of the result
	//assign o_complete = reg_done;											//	"Done" flag
	assign o_overflow = reg_overflow_in;									//	Overflow flag

	/*always@(posedge i_clk) begin
		if(i_start) begin
			reg_done_in <= o_complete;
		end
		else begin
			reg_done_in <= 1'b1;
		end
	end

	always@(posedge i_clk) begin
        reg_overflow_in <= reg_overflow;
    end*/
	

	always @( posedge i_clk ) begin
        reg_overflow_in <= reg_overflow;
        
        if(i_start) begin
			reg_done_in <= o_complete;
		end
		else begin
			reg_done_in <= 1'b1;
		end
		
		
		if( reg_done_in && i_start ) begin										//	This is our startup condition
			o_complete <= 1'b0;														//	We're not done
			reg_count <= 6'b0;														//	Reset the count
			reg_working_result <= 0;											//	Clear out the result register
			
			reg_overflow <= 1'b0;												//	Clear the overflow register

			reg_multiplicand_temp[30:0] <= i_multiplicand[30:0];				//	Load the multiplicand in its working register and lose the sign bit
			reg_multiplicand_temp[31] <= 1'b0;
			reg_multiplier_temp <= i_multiplier[30:0];					//	Load the multiplier into its working register and lose the sign bit
			
			reg_sign <= i_multiplicand[31] ^ i_multiplier[31];		//	Set the sign bit

			end 

		else if (!reg_done_in) begin
            reg_multiplier_temp <= reg_multiplier_temp << 1;						//	Do a left-shift on the multiplier
			reg_count <= reg_count + 1'b1;													//	Increment the count
			if (reg_multiplicand_temp[reg_count] == 1'b1) begin						//	if the appropriate multiplicand bit is 1
				reg_working_result <= reg_working_result + reg_multiplier_temp;	//		then add the temp multiplier
            end
            else begin
                reg_working_result <= reg_working_result;
            end

			//stop condition
			if(reg_count == 6'b100000) begin
				o_complete <= 1'b1;										//	If we're done, it's time to tell the calling process
				if (reg_working_result[62:47] > 0) begin			// Check for an overflow
					reg_overflow <= 1'b1;
					end
                //else
                    //reg_count <= reg_count + 1'b1;													//	Increment the count
			end
        end
        else begin
            o_complete <= 1'b0;														//	We're not done
            reg_count <= 0;														//	Reset the count
            reg_working_result <= 0;											//	Clear out the result register
            reg_multiplier_temp <= 0;											//	Clear out the multiplier register 
            reg_multiplicand_temp <= 0;										//	Clear out the multiplicand register 
            reg_overflow <= 1'b0;	//	Clear the overflow register
            
            reg_multiplicand_temp <= i_multiplicand[30:0];				//	Load the multiplicand in its working register and lose the sign bit
            reg_multiplier_temp <= i_multiplier[30:0];					//	Load the multiplier into its working register and lose the sign bit

            
            reg_sign <= i_multiplicand[31] ^ i_multiplier[31];		//	Set the sign bit
        end
    end
    
endmodule
