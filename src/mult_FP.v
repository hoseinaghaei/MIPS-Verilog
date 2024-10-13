module FP_mul( 
	input [31:0] num1,
    input [31:0] num2,
	output [31:0] result,
	output overflow,
	output underflow,
	output in_exact);

    wire sign, round, carry_mantissa, carry_exp;
    wire [47:0] mantissa_temp1;
    wire [22:0] mantissa_temp2;
    wire [22:0] result_mantissa;
    wire [23:0] mantissa1, mantissa2;
    wire [8:0] exp_temp1, result_exp;
    wire ckeck_inf1, check_inf2, check_inf3, check_inf4, check_inf, check_inf_pos, check_inf_neg;

    assign sign = num1[31] ^ num2[31];

    assign mantissa1 = {|num1[30:23], num1[22:0]};
    assign mantissa2 = {|num2[30:23], num2[22:0]};
    assign mantissa_temp1 = mantissa1 * mantissa2;
    assign mantissa_temp2 = mantissa_temp1[47] ? mantissa_temp1[46:24] : mantissa_temp1[45:23];
    assign round = mantissa_temp1[47] ? |mantissa_temp1[23] : |mantissa_temp1[22];
    assign {carry_mantissa, result_mantissa} = mantissa_temp2 + {22'b0, round};

    assign exp_temp1 = num1[30:23] + num2[30:23];
    assign {carry_exp, result_exp} = exp_temp1 + 9'b110000001 + mantissa_temp1[47];

    assign check_inf = (num1[30:0] == 31'b1111111100000000000000000000000) | (num2[30:0] == 31'b1111111100000000000000000000000);

    assign result = ((num1 == 32'b0) | (num2 == 32'b0)) ? 32'b0 : (check_inf ? {sign, 8'b1, 23'b0} : {sign, result_exp[7:0], result_mantissa});

    assign underflow = ~carry_exp;

    assign overflow = carry_exp & result_exp[8];

    assign in_exact = mantissa_temp1[47] ? |mantissa_temp1[23:0] : |mantissa_temp1[22:0];

endmodule