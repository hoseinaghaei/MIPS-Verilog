module fetch_operands(
    fetch_operands_inst_in,
    fetch_operands_rs_out,
    fetch_operands_rt_out,
    fetch_operands_rd_out,
    fetch_operands_shift_amount_out,
    fetch_operands_func_out,
    fetch_operands_imm_out,
    fetch_operands_address_out,
    fetch_operands_opcode_out,
    fetch_operands_r_type_out,
    fetch_operands_i_type_out,
    fetch_operands_j_type_out
);

    input  [31:0] fetch_operands_inst_in;
    output [4:0]  fetch_operands_rs_out;
    output [4:0]  fetch_operands_rt_out;
    output [4:0]  fetch_operands_rd_out;
    output [4:0]  fetch_operands_shift_amount_out;
    output [5:0]  fetch_operands_func_out, fetch_operands_opcode_out;
    output [15:0] fetch_operands_imm_out;
    output [25:0] fetch_operands_address_out;
    output        fetch_operands_r_type_out, fetch_operands_i_type_out, fetch_operands_j_type_out;

    
    
    // always @(*)
    // begin
    //     $display("fetch operands: %b", fetch_operands_inst_in);
    // end
    


    assign fetch_operands_rs_out            = (fetch_operands_r_type_out | fetch_operands_i_type_out) ? fetch_operands_inst_in[25:21] : 5'b00000;
    assign fetch_operands_rt_out            = (fetch_operands_r_type_out | fetch_operands_i_type_out) ? fetch_operands_inst_in[20:16] : 5'b00000;
    assign fetch_operands_rd_out            = fetch_operands_r_type_out            ? fetch_operands_inst_in[15:11] : 5'b00000;
    assign fetch_operands_shift_amount_out  = fetch_operands_r_type_out            ? fetch_operands_inst_in[10:6]  : 5'b00000;
    assign fetch_operands_imm_out           = fetch_operands_i_type_out            ? fetch_operands_inst_in[15:0]  : 16'd0;
    assign fetch_operands_address_out       = fetch_operands_j_type_out            ? fetch_operands_inst_in[25:0]  : 26'd0;
    assign fetch_operands_func_out          = fetch_operands_r_type_out            ? fetch_operands_inst_in[5:0]   : 6'b000000;

    assign fetch_operands_opcode_out = fetch_operands_inst_in[31-:6];
    assign fetch_operands_r_type_out = fetch_operands_opcode_out == 6'b000000                          ? 1'b1 : 1'b0;
    assign fetch_operands_j_type_out = (fetch_operands_opcode_out == 6'b000010 || fetch_operands_opcode_out == 6'b000011) ? 1'b1 : 1'b0;
    assign fetch_operands_i_type_out = ~(fetch_operands_r_type_out | fetch_operands_j_type_out);
    

endmodule