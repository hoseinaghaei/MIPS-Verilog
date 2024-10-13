module ALU(
    alu_r_type_in,
    alu_i_type_in,
    alu_j_type_in,
    alu_j_address_in,
    alu_rs_num_in,
    alu_rt_num_in,
    alu_rd_num_in,
    alu_rs_data_in,
    alu_rt_data_in,
    alu_opcode_in,
    alu_func_in,
    alu_shift_amount_in,
    alu_imm_in,
    alu_mem_data_in,
    alu_reg_num_alu_result_in,
    alu_data_alu_result_in,
    alu_mem_addr_alu_result_in,
    alu_reg_enable_alu_result_in,
    alu_mem_enable_alu_result_in,
    timehandler,
    rst_b,
    clk,
    old_pc,
    inst,

    alu_rs_num_out,
    alu_rt_num_out,
    alu_reg_num_out,
    alu_mem_addr_out,
    alu_data_out,
    alu_mem_enable_out,
    alu_reg_enable_out,
    alu_lw_out,
    alu_sw_out,
    alu_lb_out,
    alu_sb_out,
    alu_branch_exec_out,
    new_pc,
    halted
);

    input        alu_r_type_in, alu_i_type_in, alu_j_type_in, rst_b, alu_reg_enable_alu_result_in, alu_mem_enable_alu_result_in, clk;
    input [25:0] alu_j_address_in;
    input [4:0]  alu_rs_num_in, alu_rt_num_in, alu_rd_num_in, alu_reg_num_alu_result_in, alu_shift_amount_in, timehandler;
    input [31:0] alu_rs_data_in, alu_rt_data_in, alu_mem_data_in, old_pc, inst;
    input [5:0]  alu_opcode_in, alu_func_in;
    input [15:0] alu_imm_in;
    input [31:0] alu_data_alu_result_in, alu_mem_addr_alu_result_in;

    output [4:0] alu_rs_num_out, alu_rt_num_out, alu_reg_num_out;
    output [31:0] alu_mem_addr_out, alu_data_out, new_pc;
    output alu_mem_enable_out, alu_reg_enable_out;
    output alu_lw_out, alu_sw_out, alu_lb_out, alu_sb_out;
    output alu_branch_exec_out;
    output halted;

    wire j, jal;
    wire [31:0] rs_data_tmp, rt_data_tmp, mem_data_tmp;

    assign rs_data_tmp = (alu_reg_enable_alu_result_in) && (alu_rs_num_in == alu_reg_num_alu_result_in) ? alu_data_alu_result_in : alu_rs_data_in;
    assign rt_data_tmp = (alu_reg_enable_alu_result_in) && (alu_rt_num_in == alu_reg_num_alu_result_in) ? alu_data_alu_result_in : alu_rt_data_in;
    assign mem_data_tmp = (alu_mem_enable_alu_result_in) && (alu_mem_addr_out == alu_mem_addr_alu_result_in) ? alu_data_alu_result_in : alu_mem_data_in;
    assign alu_rs_num_out = alu_rs_num_in;
    assign alu_rt_num_out = alu_rt_num_in;
    assign alu_reg_enable_out = i_reg_we | r_reg_we;
    assign alu_data_out = r_reg_we ? rd_data_in :
                                                (i_reg_we ? rt_data_in : memory_data_in);
    assign alu_branch_exec_out = ((old_pc + 4) != new_pc);
    assign alu_reg_num_out = alu_r_type_in ? alu_rd_num_in : alu_rt_num_in;

    // always @(posedge clk) begin
    //     $display("rt_temp_data : %x, rs_temp_data : %x, alu_reg_num_out : %d, alu_data_out : %x", rt_data_tmp, rs_data_tmp, alu_reg_num_out, alu_data_out);
    // end


    j_controller j_controller(
        .opcode(alu_opcode_in),
        .active(alu_j_type_in),
        .j(j),
        .jal(jal)
    );

    wire addi, addiu, andi, xori, ori, beq, bne, blez, bgtz, bgez, lw, sw, lb, sb, slti, lui;

    i_controller i_controller(
        .opcode(alu_opcode_in),
        .active(alu_i_type_in),
        .addi(addi),
        .addiu(addiu),
        .andi(andi), 
        .xori(xori), 
        .ori(ori), 
        .beq(beq), 
        .bne(bne), 
        .blez(blez), 
        .bgtz(bgtz), 
        .bgez(bgez), 
        .lw(lw), 
        .sw(sw), 
        .lb(lb), 
        .sb(sb), 
        .slti(slti), 
        .lui(lui)
        );


    wire rxor, sll, sllv, srl, sub, srlv, slt, syscall, subu, ror, rnor, addu, mult, div, andr, add, jr, sra;
        
    r_controller r_controller(
        .func(alu_func_in),
        .active(alu_r_type_in),
        .rxor(rxor),
        .sll(sll),
        .sllv(sllv),
        .srl(srl),
        .sub(sub),
        .srlv(srlv), 
        .slt(slt),
        .syscall(syscall),
        .subu(subu),
        .ror(ror),
        .rnor(rnor),
        .addu(addu), 
        .mult(mult), 
        .div(div),
        .andr(andr), 
        .add(add), 
        .jr(jr),
        .sra(sra)
        );
    
    wire r_reg_we;
    
    // Inputs
	
	// Outputs
    wire [31:0] FP_result;
	wire overflow;
	wire underflow;
	wire inexact;
	wire div_by_zero;
	wire QNaN;
	wire SNaN;

	// Instantiate the Unit Under Test (UUT)
	FP_ALU uut (
		.num1(rs_data_tmp), 
		.num2(rt_data_tmp), 
        .func(alu_opcode_in[2:0]), 
        .result(FP_result), 
		.overflow(overflow), 
		.underflow(underflow), 
		.inexact(inexact), 
		.div_by_zero(div_by_zero), 
		.QNaN(QNaN), 
		.SNaN(SNaN)
	);
    
    R_type_ALU r_alu(
    .rs_data(rs_data_tmp),
    .rt_data(rt_data_tmp),
    .shift_amount(alu_shift_amount_in),
    .rd_data(rd_data_in),
    .rxor(rxor),
    .sll(sll), 
    .sllv(sllv), 
    .srl(srl), 
    .sub(sub), 
    .srlv(srlv), 
    .slt(slt),  
    .syscall(syscall),
    .subu(subu), 
    .ror(ror), 
    .rnor(rnor), 
    .addu(addu), 
    .mult(mult), 
    .div(div), 
    .andr(andr), 
    .add(add),
    .jr(jr), 
    .sra(sra),
    .rd_we(r_reg_we)
);

wire [31:0] memory_data_in, rt_data_in, rd_data_in;
wire i_reg_we;



I_type_ALU i_alu(
    .rs_data(rs_data_tmp), 
    .rt_data(rt_data_tmp), 
    .imm(alu_imm_in), 
    .memory_data(mem_data_tmp), 
    .reg_data_out(rt_data_in), 
    .mem_data_out(memory_data_in),
    .mem_addr(alu_mem_addr_out),
    .addi(addi),
    .addiu(addiu),
    .andi(andi),
    .xori(xori),
    .ori(ori),
    .lw(lw),
    .sw(sw),
    .lb(lb),
    .sb(sb),
    .slti(slti),
    .lui(lui),
    .mem_we(alu_mem_enable_out),
    .reg_we(i_reg_we)
);


PC_ALU pc_alu(
    .old_pc(old_pc), 
    .rs_data(rs_data_tmp),
    .rt_data(rt_data_tmp), 
    .imm(alu_imm_in), 
    .address(alu_j_address_in), 
    .jr(jr), 
    .beq(beq),
    .bnq(bne), 
    .blez(blez), 
    .bgtz(bgtz),
    .bgez(bgez),
    .j(j), 
    .jal(jal),
    .new_pc(new_pc),
    .last_four_inst(inst[31:28])
);


    assign halted               = rst_b == 1'b1 ? (syscall && (timehandler == 0)) : 1'b0;
    assign alu_reg_enable_out   = (r_reg_we | i_reg_we) & rst_b;
    assign alu_lb_out = lb;
    assign alu_sw_out = sw;
    assign alu_lw_out = lw;
    assign alu_sb_out = sb;
    

endmodule
