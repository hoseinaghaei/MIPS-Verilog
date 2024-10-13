module FP_comperator(
    input [31:0] num1,
    input [31:0] num2,
    output reg [2:0] result,
    output overflow,
    output underflow,
    output exception);


    assign overflow = 1'b0;
    assign underflow = 1'b0;
    assign exception = 1'b0;
     
    always @*
    begin
        if (num1[31] != num2[31])
        begin
            if (num1[31])
                result = 3'b001;
            else
                result = 3'b100;
        end
        else
        begin
            if (num1[30:23] > num2[30:23])
				begin
					if (num1[31] == 1'b0)
						result = 3'b100;
					else 
						result = 3'b001;
				end
            else if (num2[30:23] > num1[30:23])
				begin
               if (num1[31] == 1'b0)
						result = 3'b001;
					else 
						result = 3'b100;
				end
            else
            begin
                if (num1[22:0] > num2[22:0])
                begin
						if (num1[31] == 1'b0)
							result = 3'b100;
						else 
							result = 3'b001;
					end
               else if (num2[22:0] > num2[22:0])
               begin
						if (num1[31] == 1'b0)
							result = 3'b001;
						else 
							result = 3'b100;
					end
                else
                    result = 3'b010;
            end
        end
    end
    
endmodule