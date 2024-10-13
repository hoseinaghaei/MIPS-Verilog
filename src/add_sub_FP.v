module FP_add_sub(
    input [31:0] num1,
    input [31:0] num2,
    output [31:0] result,
    input sub,
    output overflow,
    output underflow,
    output in_exact);

    wire exp1_greater_exp2;
    wire [23:0] mantissa1, mantissa2, mantissa_temp1, mantissa_temp2, temp_trash1, temp_trash2;
    wire [7:0] exp_temp1, exp_temp2, temp_exp_diff, exp_diff, not_exp_diff;
    wire [8:0] result_exp;
    wire [22:0] result_mantissa;
    wire what_to_do, trash1, trash2;
    wire [4:0] shift;
	wire sign, mantissa_carry, check_zero1, check_zero2, check_zero3, check_zero, not_sub;
	wire ckeck_inf1, check_inf2, check_inf3, check_inf4, check_inf, check_inf_pos, check_inf_neg;
   	wire [8:0]moz ; 
	wire [7:0] not_shift; 
	wire [7:0] not_num2_30_23; 
	wire [7:0] not_temp_exp_diff; 
	wire [23:0] not_mantissa2;
	wire not_mantissa_carry;
	wire [23:0] not_mantissa_temp1;
	wire not_what_to_do;
	wire not_num131;
	wire [8:0] bit_shift;
	wire [31:0] inf_value;
	
	assign not_num2_30_23 = ~num2[30:23]; 
	
	assign moz = num1[30:23] + not_num2_30_23 + 1'b1;
	
	assign exp1_greater_exp2 = moz[8]; 
	assign temp_exp_diff = moz[7:0];
	
	assign not_temp_exp_diff = ~temp_exp_diff; 
   
	assign exp_diff = exp1_greater_exp2 ? temp_exp_diff : (not_temp_exp_diff) + 1'b1;

    assign exp_temp1 = exp1_greater_exp2 ? num1[30:23] : num2[30:23];

    assign mantissa1 = exp1_greater_exp2 ? {|num1[30:23], num1[22:0]} : {|num1[30:23], num1[22:0]} >> exp_diff;
    assign mantissa2 = exp1_greater_exp2 ? {|num2[30:23], num2[22:0]}  >> exp_diff : {|num2[30:23], num2[22:0]};

    assign what_to_do = sub ^ num1[31] ^ num2[31];
	
	assign not_mantissa2 = ~mantissa2;
	assign not_mantissa_carry = ~mantissa_carry;
	assign not_mantissa_temp1 = ~mantissa_temp1;
	assign not_what_to_do = ~what_to_do;
	assign not_num131 = ~num1[31];
	
    assign {mantissa_carry, mantissa_temp1} = (what_to_do ? (mantissa1 + (not_mantissa2) + what_to_do) : (mantissa1 + mantissa2));
    assign mantissa_temp2 = (what_to_do & (not_mantissa_carry)) ? (not_mantissa_temp1) + 1'b1 : mantissa_temp1;

    assign exp_temp2 = ((not_what_to_do) & mantissa_carry) ? (exp_temp1 + 8'd1) : exp_temp1;

    assign sign = (what_to_do & (not_num131) & (not_mantissa_carry)) | ((not_what_to_do) & num1[31]) | (num1[31] & mantissa_carry);

    normalize_mantissa nm(mantissa_temp2, mantissa_carry, what_to_do, result_mantissa, shift);

	
	assign not_shift = ~shift; 
    assign result_exp = exp_temp2 + not_shift + 1'b1 ;

	assign not_sub = ~sub;
	assign check_zero1 = not_sub & (num1[31] != num2[31]) & (num1[30:0] == num2[30:0]);
	assign check_zero2 = sub & (num1[31:0] == num2[31:0]);
	assign check_zero3 = (num1 == 32'b0) & (num2[31:0] == 32'b0);
	assign check_zero = check_zero1 | check_zero2 | check_zero3;

	assign check_inf1 = ((num1 == {0, 8'b1, 23'b0}) & (num2 != {1, 8'b1, 23'b0})) | ((num2 == {0, 8'b1, 23'b0}) & (num1 != {1, 8'b1, 23'b0}));
	assign check_inf2 = ((num1 == {1, 8'b1, 23'b0}) & (num2 != {0, 8'b1, 23'b0})) | ((num2 == {1, 8'b1, 23'b0}) & (num1 != {0, 8'b1, 23'b0}));
	assign check_inf3 = ((num1 == {0, 8'b1, 23'b0}) & (num2 != {0, 8'b1, 23'b0})) | ((num2 == {1, 8'b1, 23'b0}) & (num1 != {1, 8'b1, 23'b0}));
	assign check_inf4 = ((num1 == {1, 8'b1, 23'b0}) & (num2 != {1, 8'b1, 23'b0})) | ((num2 == {0, 8'b1, 23'b0}) & (num1 != {0, 8'b1, 23'b0}));

	assign check_inf_pos = (check_inf1 & not_sub) | (check_inf3 & sub);
	assign check_inf_neg = (check_inf2 & not_sub) | (check_inf4 & sub);
	assign check_inf = check_inf_pos | check_inf_neg;

	assign inf_value = check_inf ? (check_inf_pos ? {1'b0, 8'b1, 23'b0} : {1'b1, 8'b1, 23'b0}) : 1'b0 ;

    assign result =  check_zero ? 32'b0 : (check_inf ? inf_value : {sign, result_exp[7:0], result_mantissa});


    assign underflow = ~result_exp[8];

    assign overflow = (&(exp_temp1 + 8'd1)) & (~|shift);
	wire [7:0] havij; 
	wire [23:0] sib, golabi;
	assign havij = 8'd24; 
	assign not_exp_diff = ~exp_diff; 
	assign bit_shift = havij + not_exp_diff + 1'b1;
	assign sib = {|num1[30:23], num1[22:0]} << bit_shift[7:0];
	assign golabi = {|num2[30:23], num2[22:0]} << bit_shift[7:0];
	assign temp_trash1 = exp1_greater_exp2 ? 1'b0 : (bit_shift[7] ? 1'b1 : sib);
	assign trash1 = |temp_trash1;
	assign temp_trash2 = exp1_greater_exp2 ? (bit_shift[7] ? 1'b1 : golabi) : 1'b0;
	assign trash2 = |temp_trash2;
	assign in_exact = trash1 | trash2 | (mantissa_temp2[0] & mantissa_carry);
 
    
endmodule 									
