
module FP_ALU(
    input [31:0] num1,
    input [31:0] num2,
    input [2:0] func,
    output [31:0] result,
    output overflow,
    output underflow,
    output inexact,
    output div_by_zero,
    output QNaN,
    output SNaN
    );
	 
	 
	wire [31:0] sub_add_result; 
	wire sub_add_overflow;
	wire sub_add_underflow;
	wire sub_add_inexact;
	wire sub_add_div_by_zero;
	wire sub_add_QNaN;
	wire sub_add_SNaN;
	
	FP_add_sub fp_add_sub(num1, num2, sub_add_result, func[0], sub_add_overflow, sub_add_underflow, sub_add_inexact);
	
	
	wire [31:0] mul_result; 
	wire mul_overflow;
	wire mul_underflow;
	wire mul_inexact;
	wire mul_div_by_zero;
	wire mul_QNaN;
	wire mul_SNaN;
	
	FP_mul fp_mul(num1, num2, mul_result, mul_overflow, mul_underflow, mul_inexact);
	
	wire [31:0] rounding_result; 
	wire rounding_overflow;
	wire rounding_underflow;
	wire rounding_inexact;
	wire rounding_div_by_zero;
	wire rounding_QNaN;
	wire rounding_SNaN;
	
	FP_rounding fp_rounding(num1, rounding_result, rounding_inexact, rounding_overflow);
	
	wire [31:0] div_result; 
	wire div_overflow;
	wire div_underflow;
	wire div_inexact;
	wire div_div_by_zero;
	wire div_QNaN;
	wire div_SNaN;
	
	FP_div fp_div(num1, num2, div_result, div_overflow, div_underflow, div_inexact);
	
	wire [31:0] inv_result; 
	wire inv_overflow;
	wire inv_underflow;
	wire inv_inexact;
	wire inv_div_by_zero;
	wire inv_QNaN;
	wire inv_SNaN;
	
	FP_div fp_inv(32'b00111111100000000000000000000000 , num1, inv_result, inv_overflow, inv_underflow, inv_inexact);
	
	wire [31:0] cmp_result; 
	wire cmp_overflow;
	wire cmp_underflow;
	wire cmp_inexact;
	wire cmp_div_by_zero;
	wire cmp_QNaN;
	wire cmp_SNaN;
	wire [2:0] cmp_temp_result; 
	
	FP_comperator fp_comperator(num1, num2, cmp_temp_result, cmp_overflow, cmp_underflow, cmp_inexact);
	
	assign cmp_result[0] = cmp_temp_result[0]; 
	assign cmp_result[1] = cmp_temp_result[1]; 
	assign cmp_result[2] = cmp_temp_result[2]; 
	assign cmp_result[31:3] = 29'b0;
	
	assign result 			= 	( (func[2] == 0 & func[1] == 0) 	? sub_add_result 		:
									( (func == 3'b010)					? mul_result 			:
									( (func == 3'b110)					? rounding_result 	:
									( (func == 3'b011)					? div_result 			:
									( (func == 3'b101)					? inv_result 			:
									( (func == 3'b100)					? cmp_result 			:
									0))))));
	
	assign overflow 		= 	( (func[2] == 0 & func[1] == 0) 	? sub_add_overflow 	: 
									( (func == 3'b010) 					? mul_overflow 		: 
									( (func == 3'b110) 					? rounding_overflow 	: 
									( (func == 3'b011) 					? div_overflow 		: 
									( (func == 3'b101) 					? inv_overflow 		: 
									( (func == 3'b100) 					? 0		: 
									0))))));
	
	assign underflow 		= 	( (func[2] == 0 & func[1] == 0) 	? sub_add_underflow 	:
									( (func == 3'b010) 					? mul_underflow 		:
									( (func == 3'b110) 					? 0 						:
									( (func == 3'b011) 					? div_underflow 		:
									( (func == 3'b101) 					? inv_underflow 		:
									( (func == 3'b100) 					? 0 						:
									0))))));
	
	assign inexact 		= 	( (func[2] == 0 & func[1] == 0) 	? sub_add_inexact 		: 
									( (func == 3'b010) 					? mul_inexact 				:
									( (func == 3'b110) 					? rounding_inexact 		:
									( (func == 3'b011) 					? div_inexact | div_by_zero				:
									( (func == 3'b101) 					? inv_inexact | div_by_zero			:
									( (func == 3'b100) 					? 0 				:
									0))))));
	
	assign div_by_zero 	=	( (func == 3'b011) 					? (num2 == 32'b0)  		:
									( (func == 3'b101) 					? (num1 == 32'b0) 		:
									 0));
	
	assign QNaN 			= 	( (func[2] == 0 & func[1] == 0) 	? (func[0]^num1[31]^num2[31]) &	(num1[30:0] == 31'b1111111100000000000000000000000) & (num2[30:0] == 31'b1111111100000000000000000000000)		: 
									( (func == 3'b010) 					? ((num1 == 32'b000000000000000000000000) & (num2[30:0] == 31'b1111111100000000000000000000000)	)	| ((num1[30:0] == 31'b1111111100000000000000000000000) & (num2 == 32'b0) )		: 
									( (func == 3'b110) 					? 0 					:
									( (func == 3'b011) 					? ((num1 == 32'b0) & (num2 == 32'b0)) | ( (num1[30:0] == 31'b1111111100000000000000000000000) & (num2[30:0] == 31'b1111111100000000000000000000000) )	:
									( (func == 3'b101) 					? 0					:
									( (func == 3'b100) 					? 0 					:
									0))))));
	
	
	assign SNaN 			= 	((num1 === 32'bX) | (num2 === 32'bX) | (num1 === 32'bZ) | (num2 === 32'bZ)); 
	
	
	
		

endmodule
