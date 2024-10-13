module alu_result(
    alu_result_data_in,
    alu_result_mem_addr_in,
    alu_result_reg_num_in,
    alu_result_reg_enable_in,
    alu_result_mem_enable_in,
    timehandler,
    clk,

    alu_result_data_out,
    alu_result_mem_addr_out,
    alu_result_reg_num_out,
    alu_result_reg_enable_out,
    alu_result_mem_enable_out
    );


    input        alu_result_reg_enable_in, alu_result_mem_enable_in, clk;
    input [31:0] alu_result_data_in, alu_result_mem_addr_in;
    input [4:0]  alu_result_reg_num_in;
    input [4:0]  timehandler;

    output reg        alu_result_reg_enable_out, alu_result_mem_enable_out;
    output reg [31:0] alu_result_mem_addr_out, alu_result_data_out;
    output reg [4:0]  alu_result_reg_num_out;

    always_ff @(posedge clk) begin
        // $display("alu_result_reg_num_in  : %d", alu_result_reg_num_in);
        // $display("alu_result_reg_num_out : %d", alu_result_reg_num_out);
        if (timehandler == 5'd0)
        begin
            alu_result_reg_enable_out <= alu_result_reg_enable_in;
            alu_result_mem_enable_out <= alu_result_mem_enable_in;
            alu_result_mem_addr_out   <= alu_result_mem_addr_in;
            alu_result_data_out       <= alu_result_data_in;
            alu_result_reg_num_out    <= alu_result_reg_num_in;
        end
    end

endmodule