module I_type_ALU(
    rs_data, 
    rt_data, 
    imm, 
    memory_data, 
    reg_data_out, 
    mem_data_out,
    mem_addr,
    addi,
    addiu,
    andi,
    xori,
    ori,
    lw,
    sw,
    lb,
    sb,
    slti,
    lui,
    mem_we,
    reg_we
);

    input [31:0] rs_data; 
    input [31:0] rt_data;
    input [15:0] imm;
    input [31:0] memory_data;
    output [31:0] reg_data_out; 
    output [31:0] mem_data_out;
    output [31:0] mem_addr;
    input addi;
    input addiu;
    input andi;
    input xori;
    input ori;
    input lw;
    input sw;
    input lb;
    input sb;
    input slti;
    input lui;
    output mem_we;
    output reg_we;

    wire [31:0] addi_ans;
    wire [31:0] addiu_ans;
    wire [31:0] andi_ans;
    wire [31:0] xori_ans;
    wire [31:0] ori_ans;
    wire [31:0] lw_ans;
    wire [31:0] sw_ans;
    wire [31:0] lb_ans;
    wire [31:0] sb_ans;
    wire [31:0] slti_ans;
    wire [31:0] lui_ans;

    wire [31:0] sign_imm;
    wire [7:0]  which_byte_mem;
    wire [31:0] which_byte_reg;

    assign sign_imm = imm[15] == 1'b0 ? {16'd0, imm} : {16'hffff, imm}; 

    assign addi_ans  = addi  ? rs_data + sign_imm     : 32'd0; 
    assign addiu_ans = addiu ? rs_data + {16'd0, imm} : 32'd0; 
    assign andi_ans  = andi  ? rs_data & {16'd0, imm} : 32'd0; 
    assign xori_ans  = xori  ? rs_data ^ {16'd0, imm} : 32'd0; 
    assign ori_ans   = ori   ? rs_data | {16'd0, imm} : 32'd0; 
    
    assign lw_ans   = lw   ? memory_data                           : 32'd0; 
    assign sw_ans   = sw   ? rt_data                               : 32'd0; 
    assign lb_ans   = lb   ? {rt_data[31:8], which_byte_mem}       : 32'd0; 
    assign sb_ans   = sb   ? which_byte_reg                        : 32'd0; 
    assign slti_ans = slti ? (rs_data < sign_imm ? 32'hffffffff    : 32'd0)  : 32'd0; 
    assign lui_ans  = lui  ? {imm, 16'd0}                          : 32'd0; 

    assign mem_data_out   = sw    ? sw_ans    : (sb ? sb_ans : 32'd0) ; 
    assign reg_data_out   = addi  ? addi_ans  : 
                            addiu ? addiu_ans :  
                            andi  ? andi_ans  : 
                            xori  ? xori_ans  : 
                            ori   ? ori_ans   : 
                            lw    ? lw_ans    : 
                            lb    ? lb_ans    : 
                            slti  ? slti_ans  : 
                            lui   ? lui_ans   : 32'b0;  

    assign mem_we = (sw | sb);
    assign reg_we = (addi | addiu | andi | xori | ori | lw | lb | slti | lui);

    assign which_byte_mem = (mem_addr[1:0] == 2'b00 ? memory_data[31:24] : (
                         mem_addr[1:0] == 2'b01 ? memory_data[23:16] : (
                         mem_addr[1:0] == 2'b10 ? memory_data[15:8]  : (
                         mem_addr[1:0] == 2'b11 ? memory_data[7:0] : 8'b0
                         ))));
    assign which_byte_reg = (mem_addr[1:0] == 2'b00 ? {rt_data[7:0], memory_data[23:0]} : (
                         mem_addr[1:0] == 2'b01 ? {memory_data[31:24] , rt_data[7:0] , memory_data[15:0]}: (
                         mem_addr[1:0] == 2'b10 ? {memory_data[31:16] , rt_data[7:0], memory_data[7:0]}  : (
                         mem_addr[1:0] == 2'b11 ? {memory_data[31:8]  , rt_data[7:0]} : 32'd0
                         ))));

    
    assign mem_addr = rs_data + sign_imm;
endmodule