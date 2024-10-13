module normalize_mantissa(
					input[23:0] M_result,
					input M_carry,
					input what_to_do,
					output reg [22:0] normalized_M,
					output reg [4:0] shift);
			
    reg [23:0] M_temp;
                
    always @(*)
    begin
        if(M_carry & ~what_to_do)
        begin
            normalized_M = M_result[23:1] + {22'b0,M_result[0]};
            shift = 5'd0;
        end
        else
        begin
            casex(M_result)
                24'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx:
                begin
                    normalized_M = M_result[22:0];
                    shift = 5'd0;
                end
                24'b01xx_xxxx_xxxx_xxxx_xxxx_xxxx:
                begin
                    M_temp = M_result << 1;
                    normalized_M = M_temp[22:0];
                    shift = 5'd1;
                end
                24'b001x_xxxx_xxxx_xxxx_xxxx_xxxx:
                begin
                    M_temp = M_result << 2;
                    normalized_M = M_temp[22:0];
                    shift = 5'd2;
                end			
                24'b0001_xxxx_xxxx_xxxx_xxxx_xxxx:
                begin
                    M_temp = M_result << 3;
                    normalized_M = M_temp[22:0];
                    shift = 5'd3;
                end			
                24'b0000_1xxx_xxxx_xxxx_xxxx_xxxx:
                begin
                    M_temp = M_result << 4;
                    normalized_M = M_temp[22:0];
                    shift = 5'd4;
                end			
                24'b0000_01xx_xxxx_xxxx_xxxx_xxxx:
                begin
                    M_temp = M_result << 5;
                    normalized_M = M_temp[22:0];
                    shift = 5'd5;
                end			
                24'b0000_001x_xxxx_xxxx_xxxx_xxxx:
                begin
                    M_temp = M_result << 6;
                    normalized_M = M_temp[22:0];
                    shift = 5'd6;
                end			
                24'b0000_0001_xxxx_xxxx_xxxx_xxxx:
                begin
                    M_temp = M_result << 7;
                    normalized_M = M_temp[22:0];
                    shift = 5'd7;
                end			
                24'b0000_0000_1xxx_xxxx_xxxx_xxxx:
                begin
                    M_temp = M_result << 8;
                    normalized_M = M_temp[22:0];
                    shift = 5'd8;
                end			
                24'b0000_0000_01xx_xxxx_xxxx_xxxx:
                begin
                    M_temp = M_result << 9;
                    normalized_M = M_temp[22:0];
                    shift = 5'd9;
                end			
                24'b0000_0000_001x_xxxx_xxxx_xxxx:
                begin
                    M_temp = M_result << 10;
                    normalized_M = M_temp[22:0];
                    shift = 5'd10;
                end			
                24'b0000_0000_0001_xxxx_xxxx_xxxx:
                begin
                    M_temp = M_result << 11;
                    normalized_M = M_temp[22:0];
                    shift = 5'd11;
                end			
                24'b0000_0000_0000_1xxx_xxxx_xxxx:
                begin
                    M_temp = M_result << 12;
                    normalized_M = M_temp[22:0];
                    shift = 5'd12;
                end			
                24'b0000_0000_0000_01xx_xxxx_xxxx:
                begin
                    M_temp = M_result << 13;
                    normalized_M = M_temp[22:0];
                    shift = 5'd13;
                end			
                24'b0000_0000_0000_001x_xxxx_xxxx:
                begin
                    M_temp = M_result << 14;
                    normalized_M = M_temp[22:0];
                    shift = 5'd14;
                end			
                24'b0000_0000_0000_0001_xxxx_xxxx:
                begin
                    M_temp = M_result << 15;
                    normalized_M = M_temp[22:0];
                    shift = 5'd15;
                end			
                24'b0000_0000_0000_0000_1xxx_xxxx:
                begin
                    M_temp = M_result << 16;
                    normalized_M = M_temp[22:0];
                    shift = 5'd16;
                end			
                24'b0000_0000_0000_0000_01xx_xxxx:
                begin
                    M_temp = M_result << 17;
                    normalized_M = M_temp[22:0];
                    shift = 5'd17;
                end			
                24'b0000_0000_0000_0000_001x_xxxx:
                begin
                    M_temp = M_result << 18;
                    normalized_M = M_temp[22:0];
                    shift = 5'd18;
                end			
                24'b0000_0000_0000_0001_0001_xxxx:
                begin
                    M_temp = M_result << 19;
                    normalized_M = M_temp[22:0];
                    shift = 5'd19;
                end			
                24'b0000_0000_0000_0000_0000_1xxx:
                begin
                    M_temp = M_result << 20;
                    normalized_M = M_temp[22:0];
                    shift = 5'd20;
                end			
                24'b0000_0000_0000_0000_0000_01xx:
                begin
                    M_temp = M_result << 21;
                    normalized_M = M_temp[22:0];
                    shift = 5'd21;
                end			
                24'b0000_0000_0000_0000_0000_001x:
                begin
                    M_temp = M_result << 22;
                    normalized_M = M_temp[22:0];
                    shift = 5'd22;
                end			
                24'b0000_0000_0000_0000_0000_0001:
                begin
                    M_temp = M_result << 23;
                    normalized_M = M_temp[22:0];
                    shift = 5'd23;
                end			
                default:
                begin
                    normalized_M = 23'b0;
                    shift = 5'd0;
                end			
            endcase	
        end
    end	
endmodule