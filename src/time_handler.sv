module time_handler(
    clk,
    rst_b,
    counter
);

    input clk;
    input rst_b;
    output reg [4:0] counter;

    always @(posedge clk, negedge rst_b)
    begin
        if (rst_b == 0 || counter == 5'd0)
            counter <= 5'd18;
        else
            counter <= counter - 1;
    end

endmodule