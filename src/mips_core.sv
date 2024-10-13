module mips_core(
    inst_addr,
    inst,
    mem_addr,
    mem_data_out,
    mem_data_in,
    mem_write_en,
    halted,
    clk,
    rst_b
);

    
    input      [31:0] inst;
    input             clk;
    input             rst_b;   
    input      [7:0]  mem_data_out[0:3];
    output     [7:0]  mem_data_in [0:3];
    output     [31:0] mem_addr;
    output            mem_write_en;
    output            halted;
    output reg [31:0] inst_addr;

    /*
        RegisterFile wires 
        RegisterFile definition
        Start
    */

    wire [31:0] rs_data;
    wire [31:0] rt_data;
    wire [4:0]  rs_num;
    wire [4:0]  rt_num;
    wire [31:0] reg_data_in;
    reg         first_clock;


    reg reg_we;

    regfile reg_file (
    .rs_data(rs_data),
    .rt_data(rt_data),
    .rs_num(rs_num),
    .rt_num(rt_num),
    .rd_num(alu_result_reg_num_out),
    .rd_data(alu_result_data_out),
    .rd_we(reg_we),
    .clk(clk),
    .rst_b(rst_b),
    .halted(halted)
    );

    // assign rd_num       = r_type        ? rd         : rt_num;
    // assign reg_data_in  = r_type        ? rd_data_in : rt_data_in;
    // assign halted       = rst_b == 1'b1 ? syscall    : 1'b0;

    assign mem_data_in[3] = cache_word_out[3];
    assign mem_data_in[2] = cache_word_out[2];
    assign mem_data_in[1] = cache_word_out[1];
    assign mem_data_in[0] = cache_word_out[0];

    assign cache_word_in[3] = ((mem_fetch || (mem_fetch_and_write & cnt_mem < 4'd6)) && (timehandler >= 6)) ? mem_data_in[3] : alu_result_data_out[31:24];
    assign cache_word_in[2] = ((mem_fetch || (mem_fetch_and_write & cnt_mem < 4'd6)) && (timehandler >= 6)) ? mem_data_in[2] : alu_result_data_out[23:16];
    assign cache_word_in[1] = ((mem_fetch || (mem_fetch_and_write & cnt_mem < 4'd6)) && (timehandler >= 6)) ? mem_data_in[1] : alu_result_data_out[15:8];
    assign cache_word_in[0] = ((mem_fetch || (mem_fetch_and_write & cnt_mem < 4'd6)) && (timehandler >= 6)) ? mem_data_in[0] : alu_result_data_out[7:0];
    
    /*
        cache wires 
        cache definition
        End
    */  
    reg [7:0] cache_word_out [3:0];
    reg [7:0] cache_word_in  [3:0];
    reg cache_we, cache_re, mem_fetch, mem_write;
    reg [31:0] cache_write_mem_addr, cache_addr;
    reg [31:0] cache_fetch_mem_addr;
    reg cache_wait_signal;

    assign cache_addr = (timehandler <= 12) ? alu_mem_addr_out : alu_result_mem_addr_out;

    cache cache(
    .data_addr(cache_addr),
    .cache_word_out(cache_word_out),
    .cache_word_in(cache_word_in),
    .cache_we(cache_we),
    .cache_re(cache_re),
    .write_mem_addr(cache_write_mem_addr),
    .fetch_mem_addr(cache_fetch_mem_addr),
    .wait_signal(cache_wait_signal),
    .mem_fetch(mem_fetch),
    .mem_write(mem_write),
    .clk(clk),
    .rst_b(rst_b)
);

    // Pipeline stages
    // Cascade style
    reg [4:0] timehandler;

    time_handler core_time_handler(
        .clk(clk),
        .rst_b(rst_b),
        .counter(timehandler)
    );

    reg  [5:0]  opcode;
    reg         r_type;
    wire [4:0]  rd, shift_amount;
    wire [5:0]  func;
    reg         j_type;
    wire [15:0] imm;
    reg         i_type;
    wire [25:0] address;

    fetch_operands fetch_operand(
        .fetch_operands_inst_in(inst),
        .fetch_operands_rs_out(rs_num),
        .fetch_operands_rt_out(rt_num),
        .fetch_operands_rd_out(rd),
        .fetch_operands_shift_amount_out(shift_amount),
        .fetch_operands_func_out(func),
        .fetch_operands_imm_out(imm),
        .fetch_operands_address_out(address),
        .fetch_operands_opcode_out(opcode),
        .fetch_operands_r_type_out(r_type),
        .fetch_operands_i_type_out(i_type),
        .fetch_operands_j_type_out(j_type)
    );

    reg  [5:0]  fetch_result_opcodeout;
    reg         fetch_result_r_type;
    reg         fetch_result_i_type;
    reg         fetch_result_j_type;
    wire [4:0]  fetch_result_rs, fetch_result_rt, fetch_result_rd, fetch_result_shift_amount;
    wire [5:0]  fetch_result_func;
    wire [15:0] fetch_result_imm;
    wire [25:0] fetch_result_address;
    wire [31:0] fetch_result_inst_addr_out, fetch_result_inst_out;

        
    fetch_result fetch_resultt(
        .fetch_result_r_type_in(r_type),
        .fetch_result_i_type_in(i_type),
        .fetch_result_j_type_in(j_type),
        .fetch_result_address_in(address),
        .fetch_result_rs_in(rs_num),
        .fetch_result_rt_in(rt_num), 
        .fetch_result_rd_in(rd),
        .fetch_result_imm_in(imm),
        .fetch_result_opcode_in(opcode),
        .fetch_result_func_in(func),
        .fetch_result_shift_amount_in(shift_amount),
        .inst_addr(inst_addr),
        .inst(inst),
        .timehandler(timehandler),
        .clk(clk),

        .fetch_result_r_typeout(fetch_result_r_type),
        .fetch_result_i_typeout(fetch_result_i_type),
        .fetch_result_j_typeout(fetch_result_j_type),
        .fetch_result_addressout(fetch_result_address),
        .fetch_result_rsout(fetch_result_rs),
        .fetch_result_rtout(fetch_result_rt),
        .fetch_result_rdout(fetch_result_rd),
        .fetch_result_immout(fetch_result_imm),
        .fetch_result_opcodeout(fetch_result_opcodeout),
        .fetch_result_funcout(fetch_result_func),
        .fetch_result_inst_addr_out(fetch_result_inst_addr_out),
        .fetch_result_inst_out(fetch_result_inst_out),
        .fetch_result_shift_amountout(fetch_result_shift_amount)
    );

    wire [31:0] rd_data_in;
    

    wire alu_lw, alu_sw, alu_lb, alu_sb, alu_branch_exec;
    wire [4:0] alu_rs_num, alu_rt_num, alu_reg_num_out;
    wire [31:0] alu_mem_addr_out, alu_data_out;
    wire alu_mem_enable_out, alu_reg_enable_out;
    wire [31:0] new_pc;
    

    ALU alu_core(
        .alu_r_type_in(fetch_result_r_type),
        .alu_i_type_in(fetch_result_i_type),
        .alu_j_type_in(fetch_result_j_type),
        .alu_j_address_in(fetch_result_address),
        .alu_rs_num_in(fetch_result_rs),
        .alu_rt_num_in(fetch_result_rt),
        .alu_rd_num_in(fetch_result_rd),
        .alu_rs_data_in(rs_data),
        .alu_rt_data_in(rt_data),
        .alu_opcode_in(fetch_result_opcodeout),
        .alu_func_in(fetch_result_func),
        .alu_shift_amount_in(fetch_result_shift_amount),
        .alu_imm_in(fetch_result_imm),
        .alu_mem_data_in(alu_mem_data_in),
        .alu_reg_num_alu_result_in(alu_result_reg_num_out),
        .alu_data_alu_result_in(alu_result_data_out),
        .alu_mem_addr_alu_result_in(alu_result_mem_addr_out),
        .alu_reg_enable_alu_result_in(alu_result_reg_enable_out),
        .alu_mem_enable_alu_result_in(alu_result_mem_enable_out),
        .timehandler(timehandler),
        .rst_b(rst_b),
        .old_pc(fetch_result_inst_addr_out),
        .inst(fetch_result_inst_out),
        .clk(clk),
    
        .alu_rs_num_out(alu_rs_num),
        .alu_rt_num_out(alu_rt_num),
        .alu_reg_num_out(alu_reg_num_out),
        .alu_mem_addr_out(alu_mem_addr_out),
        .alu_data_out(alu_data_out),
        .alu_mem_enable_out(alu_mem_enable_out),
        .alu_reg_enable_out(alu_reg_enable_out),
        .alu_lw_out(alu_lw),
        .alu_sw_out(alu_sw),
        .alu_lb_out(alu_lb),
        .alu_sb_out(alu_sb),
        .alu_branch_exec_out(alu_branch_exec),
        .new_pc(new_pc),
        .halted(halted)
    );

    wire [31:0] alu_mem_data_in;
    assign alu_mem_data_in = {cache_word_out[3], cache_word_out[2], cache_word_out[1], cache_word_out[0]};

    wire [31:0] alu_result_data_out, alu_result_mem_addr_out;
    wire [4:0] alu_result_reg_num_out;
    wire alu_result_reg_enable_out, alu_result_mem_enable_out;


    alu_result alu_res(
    .alu_result_data_in(alu_data_out),
    .alu_result_mem_addr_in(alu_mem_addr_out),
    .alu_result_reg_num_in(alu_reg_num_out),
    .alu_result_reg_enable_in(alu_reg_enable_out),
    .alu_result_mem_enable_in(alu_mem_enable_out),
    .timehandler(timehandler),
    .clk(clk),

    .alu_result_data_out(alu_result_data_out),
    .alu_result_mem_addr_out(alu_result_mem_addr_out),
    .alu_result_reg_num_out(alu_result_reg_num_out),
    .alu_result_reg_enable_out(alu_result_reg_enable_out),
    .alu_result_mem_enable_out(alu_result_mem_enable_out)
    );


    reg [3:0] cnt_mem; 
    always @(posedge clk, negedge rst_b)
    begin
        if(rst_b == 1'b0)
        begin
            inst_addr <= 32'd0;
            first_clock <= 1;
            cnt_mem <= 0; 
        end
        else
        begin
            if (!first_clock)
            begin
                if(alu_lw | alu_sw | alu_lb | alu_sb)
                begin
                    if (timehandler == 0)
                        inst_addr <= new_pc;

                    if(inst_first_clk == 1'b1)
                        inst_first_clk <= 0;
                    else
                    begin
                        if (cnt_mem == 0)
                        begin
                            if(mem_fetch_and_write)
                                cnt_mem <= 4'd11;
                            else if(mem_write)
                                cnt_mem <= 4'd6;
                            else if(mem_fetch)
                                cnt_mem <= 4'd6;
                            else
                            begin
                                cnt_mem <= 1 ;
                            end
                        end
                        else if (cnt_mem == 1)
                        begin
                            cnt_mem <= 0;
                            inst_first_clk <= 1;
                        end
                        else
                        begin
                            cnt_mem <= (cnt_mem - 1) ;
                        end
                    end
                end
                else
                begin
                    cnt_mem <= 0; 

                    if (timehandler == 0)
                        inst_addr <= new_pc;

                    inst_first_clk <= 1;
                end
                
            end
            else
                first_clock <= 0;
        end
    end



    assign  cache_wait_signal = (cnt_mem > 4'd1 && (cnt_mem != 4'd6 && mem_fetch_and_write) );
    reg     mem_fetch_and_write;
    assign  mem_fetch_and_write = mem_fetch & mem_write;
    reg     inst_first_clk;

    assign mem_addr     = rst_b == 1'b0 ? 32'd0 : ((mem_fetch_and_write & (cnt_mem > 4'd6)) ? cache_write_mem_addr : (mem_write ? cache_write_mem_addr : cache_fetch_mem_addr));
    assign mem_write_en = rst_b == 1'b0 ? 1'b0  : ((mem_fetch_and_write & (cnt_mem == 4'd11)) ? 1'b1 : ((mem_write & (cnt_mem == 4'd6)) ? 1'b1 : 1'b0 ));
    assign cache_we     = rst_b == 1'b0 ? 1'b0  : (((cnt_mem == 2 && (mem_fetch || mem_fetch_and_write))) && (timehandler >= 6)) || ((timehandler > 12) && alu_result_mem_enable_out);
    assign cache_re     = rst_b == 1'b0 ? 1'b0  : (timehandler < 6 && (alu_lw | alu_lb));
    assign reg_we       = rst_b == 1'b0 ? 1'b0  : (timehandler > 12) && alu_result_reg_enable_out;

endmodule
 
