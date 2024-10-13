
module FP_rounding(
    input [31:0] num,
    output [31:0] result,
    output inexact,
    output overflow
    );

	wire sign, temp_carry;
	wire [23:0] mantisa;
	wire [7:0] exp_temp, result_exp;
	wire [31:0] temp_result; 
	wire [31:0] result_for_pos_exp; 
	
	assign sign = num[31]; 
	assign {temp_carry,exp_temp} = {1'b0,num[30:23]} - 9'd127;
	assign mantisa = {|num[30:23], num[22:0]};
	
	assign overflow = (exp_temp > 31) ; 
	
	assign temp_result = (exp_temp <= 0 ? (exp_temp == -1 ? 32'd1 : exp_temp == 0 ? mantisa : 32'b0) 
							: (exp_temp < 23 ? (32'b0 | (mantisa >> (23-exp_temp))) : 
								(32'b0 | (mantisa<<(23-exp_temp)))  ));
	 
	wire round;
	assign round = (exp_temp>0 & exp_temp<23 ? mantisa[23-exp_temp-1] : 0); 
	
	assign inexact = (exp_temp>0 & exp_temp<23 ? (|(mantisa << (exp_temp+1))) : 0);
	assign result = (sign ? -(temp_result+round) : temp_result+round) ; 
endmodule
