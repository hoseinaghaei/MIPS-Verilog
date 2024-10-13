module fetch_result(
    fetch_result_r_type_in,
    fetch_result_i_type_in,
    fetch_result_j_type_in,
    fetch_result_address_in,
    fetch_result_rs_in,
    fetch_result_rt_in,
    fetch_result_rd_in,
    fetch_result_imm_in,
    fetch_result_opcode_in,
    fetch_result_func_in,
    fetch_result_shift_amount_in,
    inst_addr,
    inst,
    timehandler,
    clk,

    fetch_result_r_typeout,
    fetch_result_i_typeout,
    fetch_result_j_typeout,
    fetch_result_addressout,
    fetch_result_rsout,
    fetch_result_rtout,
    fetch_result_rdout,
    fetch_result_immout,
    fetch_result_opcodeout,
    fetch_result_funcout,
    fetch_result_inst_addr_out,
    fetch_result_shift_amountout,
    fetch_result_inst_out
    );


    input        fetch_result_r_type_in, fetch_result_i_type_in, fetch_result_j_type_in, clk;
    input [25:0] fetch_result_address_in;
    input [4:0]  fetch_result_rs_in, fetch_result_rt_in, fetch_result_rd_in, fetch_result_shift_amount_in;
    input [5:0]  fetch_result_func_in, fetch_result_opcode_in;
    input [15:0] fetch_result_imm_in;
    input [31:0] inst_addr, inst;
    input [4:0]  timehandler;

    output reg        fetch_result_r_typeout, fetch_result_i_typeout, fetch_result_j_typeout;
    output reg [25:0] fetch_result_addressout;
    output reg [4:0]  fetch_result_rsout, fetch_result_rtout, fetch_result_rdout, fetch_result_shift_amountout;
    output reg [5:0]  fetch_result_opcodeout, fetch_result_funcout;
    output reg [15:0] fetch_result_immout;
    output reg [31:0] fetch_result_inst_addr_out, fetch_result_inst_out;

    always_ff @(posedge clk) begin
        if (timehandler == 5'd17)
        begin
            fetch_result_addressout      <= fetch_result_address_in;
            fetch_result_rsout           <= fetch_result_rs_in;
            fetch_result_rtout           <= fetch_result_rt_in;
            fetch_result_rdout           <= fetch_result_rd_in;
            fetch_result_opcodeout       <= fetch_result_opcode_in;
            fetch_result_funcout         <= fetch_result_func_in;
            fetch_result_immout          <= fetch_result_imm_in;
            fetch_result_r_typeout       <= fetch_result_r_type_in;
            fetch_result_i_typeout       <= fetch_result_i_type_in;
            fetch_result_j_typeout       <= fetch_result_j_type_in;
            fetch_result_shift_amountout <= fetch_result_shift_amount_in;
            fetch_result_inst_addr_out   <= inst_addr;
            fetch_result_inst_out        <= inst;
        end
    end


endmodule