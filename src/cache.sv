module cache(
    data_addr,
    cache_word_out,
    cache_word_in,
    cache_we,
    cache_re,
    mem_fetch,
    mem_write,
    wait_signal,
    write_mem_addr,
    fetch_mem_addr,
    clk,
    rst_b
);

    input               rst_b;
    input               clk;
    input               cache_we;
    input               cache_re;
    input      [7:0]    cache_word_in  [3:0];
    input      [31:0]   data_addr;
    input               wait_signal;
    output reg [31:0]   write_mem_addr;
    output reg [31:0]   fetch_mem_addr;
    output reg [7:0]    cache_word_out [3:0];
    output reg          mem_fetch;
    output reg          mem_write;


    localparam word_in_block = 1;
    localparam cache_size    = 1 << 13;
    localparam word_size     = 32;
    localparam block_size    = word_in_block * word_size;
    localparam block_num     = cache_size    / block_size;

    reg [block_size - 1 : 0] cache_block [block_num - 1:0];
    reg                      valid_bits  [block_num - 1:0];
    reg                      dirty_bits  [block_num - 1:0];
    reg [21:0]               tag_bits    [block_num - 1:0];
    reg [31:0]               temp_data;
    reg [31:0]               temp_addr; 
    reg                      temp_flush;

    always_ff @(posedge clk, negedge rst_b) begin
        mem_fetch <= 1'b0;
        mem_write <= 1'b0;
        

        if (rst_b == 1'b0)
        begin
            integer i;
            for(i=0; i < block_num; i++)
                valid_bits[i] <= 1'b0;
        end
        else if(wait_signal == 1'b0)
        begin
            if(temp_flush == 1'b1)
            begin
                cache_block[temp_addr[9:2]] <= temp_data;
                tag_bits[temp_addr[9:2]] <= temp_addr[31:10];
                dirty_bits[temp_addr[9:2]] <= 1'b0;
                valid_bits[temp_addr[9:2]] <= 1'b1;
                temp_flush <= 1'b0;
            end
            else if (cache_we == 1'b1)
            begin
                if(valid_bits[block] == 1'b0)
                begin
                    cache_block[block] <= data_in;
                    valid_bits[block] <= 1'b1;
                    dirty_bits[block] <= 1'b1;
                end
                else
                begin
                    if(tag_bits[block] != tag && dirty_bits[block] == 1'b1)
                    begin
                        write_mem_addr <= {tag, data_addr[9:0]};
                        mem_write <= 1;
                        temp_addr <= data_addr;
                        temp_data <= {cache_word_in[3], cache_word_in[2], cache_word_in[1], cache_word_in[0]};
                        temp_flush <= 1'b1;
                    end
                    else
                    begin
                        cache_block[block] <= data_in;
                        dirty_bits[block] <= 1'b1;
                    end
                end
            end 
            else if (cache_re == 1'b1)
            begin
                if (valid_bits[block] == 1'b0) 
                begin
                    mem_fetch <= 1'b1;
                    fetch_mem_addr <= data_addr;
                end
                else
                begin
                    if (tag_bits[block] != tag) begin
                        if (dirty_bits[block] == 1'b1) begin
                            mem_write <= 1'b1;
                            write_mem_addr <= {tag_bits[block], data_addr[9:0]};
                        end
                            
                        fetch_mem_addr <= data_addr;
                        mem_fetch <= 1'b1;
                    end
                       
                end
            end
        end
    end
    

    wire [21:0] tag;
    wire [7:0] block;

    assign tag = data_addr[31:10];
    assign block = data_addr[9:2];

    wire [31:0] data_in;
    assign data_in = {cache_word_in[3], cache_word_in[2], cache_word_in[1], cache_word_in[0]};
    assign cache_word_out[3] = cache_block[block][31:24];
    assign cache_word_out[2] = cache_block[block][23:16];
    assign cache_word_out[1] = cache_block[block][15:8];
    assign cache_word_out[0] = cache_block[block][7:0];

endmodule