module R_type_ALU (
    rs_data,
    rt_data,
    shift_amount,
    rd_data,
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
    sra,
    rd_we
);
    input [31:0]  rs_data;
    input [31:0]  rt_data;
    input [4:0]   shift_amount; 
    input         rxor;
    input         sll; 
    input         sllv; 
    input         srl;
    input         sub; 
    input         srlv; 
    input         slt;
    input         syscall;
    input         subu;
    input         ror;
    input         rnor; 
    input         addu; 
    input         mult; 
    input         div;
    input         andr; 
    input         add;
    input         jr;
    input         sra;
    output [31:0] rd_data;
    output        rd_we;


    wire [31:0] ans_rxor;
    wire [31:0] ans_sll; 
    wire [31:0] ans_sllv; 
    wire [31:0] ans_srl;
    wire [31:0] ans_sub; 
    wire [31:0] ans_srlv; 
    wire [31:0] ans_slt;
    wire [31:0] ans_subu;
    wire [31:0] ans_ror;
    wire [31:0] ans_rnor; 
    wire [31:0] ans_addu; 
    wire [31:0] ans_mult; 
    wire [31:0] ans_div;
    wire [31:0] ans_andr; 
    wire [31:0] ans_add;
    wire [31:0] ans_sra;

    assign ans_rxor = rs_data   ^   rt_data;     
    assign ans_sll  = rt_data   <<  shift_amount;
    assign ans_sllv = rt_data   <<  rs_data;    
    assign ans_srl  = rt_data   >>  shift_amount;
    assign ans_sub  = rs_data   -   rt_data;     
    assign ans_srlv = rt_data   >>  rs_data;

    assign ans_slt  = $signed(rt_data) > $signed(rs_data) ? 32'hffffffff : 32'd0;

    assign ans_subu = rs_data   -   rt_data;    
    assign ans_ror  = rs_data   |   rt_data;    
    assign ans_rnor = rt_data   ~|  rs_data;   
    assign ans_addu = rt_data   +   rs_data;    
    assign ans_mult = rt_data   *   rs_data;    
    assign ans_div  = rt_data   /   rs_data;    
    assign ans_andr = rt_data   &   rs_data;    
    assign ans_add  = rt_data   +   rs_data;    
    //jump not here
    assign ans_sra = $signed(rt_data) >>> shift_amount;

    assign rd_data =  (rxor ? ans_rxor :
                      (sll  ? ans_sll  :
                      (sllv ? ans_sllv :
                      (srl  ? ans_srl  :
                      (sub  ? ans_sub  :
                      (srlv ? ans_srlv : 
                      (slt  ? ans_sllv :
                      (subu ? ans_subu : 
                      (ror  ? ans_ror  : 
                      (rnor ? ans_rnor : 
                      (addu ? ans_addu : 
                      (mult ? ans_mult : 
                      (div  ? ans_div  : 
                      (andr ? ans_andr : 
                      (add  ? ans_add  : 
                      (sra  ? ans_sra  : 32'b0
                      ))))))))))))))));

    
    assign rd_we = (rxor | sll | sllv  | srl  | sub  | srlv  | slt   | subu  | ror  | rnor  | addu  | mult  | div  | andr  | add | sra);
    
endmodule