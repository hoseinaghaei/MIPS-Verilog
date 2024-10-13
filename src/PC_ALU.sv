module PC_ALU(
    old_pc,
    rs_data,
    rt_data, 
    imm, 
    address, 
    jr, 
    beq,
    bnq, 
    blez, 
    bgtz,
    bgez,
    j, 
    jal,
    new_pc, 
    last_four_inst
);
    input  [31:0] old_pc; 
    input  [31:0] rs_data; 
    input  [31:0] rt_data; 
    input  [15:0] imm; 
    input  [25:0] address; 
    input         jr;
    input         beq;
    input         bnq;
    input         blez;
    input         bgtz; 
    input         bgez;
    input         j; 
    input         jal;
    output [31:0] new_pc; 
    input  [3:0]  last_four_inst;

    wire [31:0] jr_ans;
    wire [31:0] beq_ans;
    wire [31:0] bnq_ans;
    wire [31:0] blez_ans;
    wire [31:0] bgtz_ans;
    wire [31:0] bgez_ans;
    wire [31:0] j_ans;
    wire [31:0] jal_ans;


    wire [31:0] sign_imm;
    assign sign_imm = imm[15] == 1'b0 ? {16'd0, imm} : {16'hffff, imm}; 
    

    assign jr_ans   = rs_data;
    assign beq_ans  = rs_data == rt_data                  ? (old_pc + sign_imm * 4) + 4 : old_pc + 4;
    assign bnq_ans  = rs_data != rt_data                  ? (old_pc + sign_imm * 4) + 4 : old_pc + 4; 
    assign blez_ans = rs_data <= 32'd0                    ? (old_pc + sign_imm * 4) + 4 : old_pc + 4;
    assign bgtz_ans = rs_data > 32'd0                     ? (old_pc + sign_imm * 4) + 4 : old_pc + 4;
    assign bgez_ans = $signed(rs_data) >= $signed(32'd0)  ? (old_pc + sign_imm * 4) + 4 : old_pc + 4;
    assign j_ans    = {last_four_inst, address, 2'b0};
    assign jal_ans  = {last_four_inst, address, 2'b0};
    
    assign new_pc = jr   ? jr_ans   : 
                    beq  ? beq_ans  : 
                    bnq  ? bnq_ans  : 
                    blez ? blez_ans : 
                    bgtz ? bgtz_ans : 
                    bgez ? bgez_ans : 
                    j    ? j_ans    : 
                    jal  ? jal_ans  : old_pc + 4;

endmodule
