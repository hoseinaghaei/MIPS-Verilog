module FP_div(
	input [31:0] num1,
	input [31:0] num2,
	output [31:0] result,
	output overflow,
	output underflow,
	output inexact);

    wire sign;
    wire [7:0] exp_temp1, exp_temp2;
    wire [47:0] mantissa_temp1;
	 wire [23:0] mantissa_temp2;
    wire [22:0] result_mantissa;
    wire [4:0] shift;
    wire [8:0] result_exp;
	 wire check_inf1, check_inf2;
	 
		wire [23:0] mantissa1 , mantissa2; 
    assign sign = num1[31] ^ num2[31];  

    assign exp_temp1 = num1[30:23] - num2[30:23];
    assign exp_temp2 = exp_temp1 + 8'b01111111;

    assign mantissa1 = {|num1[30:23], num1[22:0]};
    assign mantissa2 = {|num2[30:23], num2[22:0]};
    assign mantissa_temp1 = ({mantissa1, 24'b0}) / mantissa2;
    assign mantissa_temp2 = mantissa_temp1[23:0]; 
	normalize_mantissa nm(mantissa_temp2, 1'b0, 1'b1, result_mantissa, shift);
		
	wire gr;
	assign gr = (mantissa1 < mantissa2 ? 1'b1 : 1'b0);
    assign result_exp = exp_temp2 - shift - gr ;
	
	assign check_inf1 = (num1[30:0] == 31'b1111111100000000000000000000000) ;
	assign check_inf2 = (num2[30:0] == 31'b1111111100000000000000000000000) ;
	
   
	assign result = (check_inf1 ? {sign, 8'b1, 23'b0} : (check_inf2 ? 32'b0 : ((num1 == 32'b0) ? 32'b0 : {sign, result_exp[7:0], result_mantissa})));

	assign inexact = ( | (({mantissa1, 24'b0}) % mantissa2) )  ; 
	assign overflow = (exp_temp1 > 8'sd127) ; 
	assign underflow = ($signed(exp_temp1) < $signed(-8'sd126)) ; 
endmodule 