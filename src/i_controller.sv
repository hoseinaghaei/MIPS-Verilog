module i_controller(
    opcode,
    active,
    addi,
    addiu,
    andi, 
    xori, 
    ori, 
    beq, 
    bne, 
    blez, 
    bgtz, 
    bgez, 
    lw, 
    sw, 
    lb, 
    sb, 
    slti, 
    lui
);

    input   [5:0]  opcode;
    input          active;
    output         addi;
    output         addiu;
    output         andi;
    output         xori;
    output         ori;
    output         beq;
    output         bne;
    output         blez;
    output         bgtz;
    output         bgez;
    output         lw;
    output         sw;
    output         lb;
    output         sb;
    output         slti;
    output         lui;


    assign addi   = active ? opcode == 6'b001000 : 1'b0;
    assign addiu  = active ? opcode == 6'b001001 : 1'b0;
    assign andi   = active ? opcode == 6'b001100 : 1'b0;
    assign xori   = active ? opcode == 6'b001110 : 1'b0;
    assign ori    = active ? opcode == 6'b001101 : 1'b0;
    assign beq    = active ? opcode == 6'b000100 : 1'b0;
    assign bne    = active ? opcode == 6'b000101 : 1'b0;
    assign blez   = active ? opcode == 6'b000110 : 1'b0;
    assign bgtz   = active ? opcode == 6'b000111 : 1'b0;
    assign bgez   = active ? opcode == 6'b000001 : 1'b0;
    assign lw     = active ? opcode == 6'b100011 : 1'b0;
    assign sw     = active ? opcode == 6'b101011 : 1'b0;
    assign lb     = active ? opcode == 6'b100000 : 1'b0;
    assign sb     = active ? opcode == 6'b101000 : 1'b0;
    assign slti   = active ? opcode == 6'b001010 : 1'b0;
    assign lui    = active ? opcode == 6'b001111 : 1'b0;

endmodule