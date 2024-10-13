module j_controller(
    opcode,
    active,
    j,
    jal
    );

    input   [5:0]  opcode;
    input          active;
    output         j;
    output         jal;

    assign j      = active ? opcode == 6'b000010 : 1'b0;
    assign jal    = active ? opcode == 6'b000011 : 1'b0;

endmodule