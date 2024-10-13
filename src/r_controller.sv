module r_controller(
    func,
    active,
    rxor,
    sll, 
    sllv, 
    srl, 
    sub, 
    srlv, 
    slt, 
    syscall, 
    subu, 
    ror, 
    rnor, 
    addu, 
    mult, 
    div, 
    andr, 
    add, 
    jr, 
    sra
);
    input   [5:0]  func;
    input          active;
    output         rxor;
    output         sll; 
    output         sllv; 
    output         srl;
    output         sub; 
    output         srlv; 
    output         slt;
    output         syscall; 
    output         subu;
    output         ror;
    output         rnor; 
    output         addu; 
    output         mult; 
    output         div;
    output         andr; 
    output         add; 
    output         jr;
    output         sra;

    assign rxor    = active ? func == 6'b100110 : 1'b0;
    assign sll     = active ? func == 6'b000000 : 1'b0;
    assign sllv    = active ? func == 6'b000100 : 1'b0;
    assign srl     = active ? func == 6'b000010 : 1'b0;
    assign sub     = active ? func == 6'b100010 : 1'b0;
    assign srlv    = active ? func == 6'b000110 : 1'b0;
    assign slt     = active ? func == 6'b101010 : 1'b0;
    assign syscall = active ? func == 6'b001100 : 1'b0;
    assign subu    = active ? func == 6'b100011 : 1'b0;
    assign ror     = active ? func == 6'b100101 : 1'b0;
    assign rnor    = active ? func == 6'b100111 : 1'b0;
    assign addu    = active ? func == 6'b100001 : 1'b0;
    assign mult    = active ? func == 6'b011000 : 1'b0;
    assign div     = active ? func == 6'b011010 : 1'b0;
    assign andr    = active ? func == 6'b100100 : 1'b0;
    assign add     = active ? func == 6'b100000 : 1'b0;
    assign jr      = active ? func == 6'b001000 : 1'b0;
    assign sra     = active ? func == 6'b000011 : 1'b0;

endmodule 