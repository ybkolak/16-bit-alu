module control_unit (
    input[15:0] data_in,
    input reg[7:0] registers[15:0],
    input reg[7:0] ram[255:0],
    output[7:0] result,
);


always @(data_in) begin
    case(data_in[15:12])
        4'b0000 : begin
            registers[data_in[11:8]] <= data_in[7:0];
            result <= data_in[7:0];
        end
        4'b0001 : begin
            registers[data_in[11:8]] <= ram[data_in[7:0]];
            result <= ram[data_in[7:0]];
        end
        4'b0010: begin
            ram[data_in[7:0]] <= registers[data_in[11:8]];
            result <= registers[data_in[11:8]];
        end
        4'b0011: begin 
            registers[data_in[7:4]] <= registers[data_in[11:8]];
            result <= registers[data_in[11:8]];
        end
        4'b0100: begin
            registers[data_in[3:0]] <= registers[data_in[11:8]] + registers[data_in[7:4]];
            result <= registers[data_in[11:8]] + registers[data_in[7:4]];
        end
        4'b0101: begin
            registers[data_in[3:0]] <= registers[data_in[11:8]] - registers[data_in[7:4]];
            result <= registers[data_in[11:8]] - registers[data_in[7:4]];
        end
        4'b0110: begin
            registers[data_in[7:4]] <= registers[data_in[11:8]] + 1;
            result <= registers[data_in[11:8]] + 1;
        end
        4'b0111: begin
            registers[data_in[7:4]] <= registers[data_in[11:8]] - 1;
        end
        4'b1000: begin
            registers[data_in[3:0]] <= registers[data_in[11:8]] & registers[data_in[7:4]];
        end
        4'b1001: begin
            registers[data_in[3:0]] <= registers[data_in[11:8]] | registers[data_in[7:4]];
        end
        4'b1010: begin  
            registers[data_in[3:0]] <= registers[data_in[11:8]] ^ registers[data_in[7:4]];
        end
        4'b1011: begin
            registers[data_in[7:4]] <= ~registers[data_in[11:8]];
        end
        4'b1100: begin
            registers[data_in[7:4]] <= registers[data_in[11:8]] << 1;
        end
        4'b1101: begin
            registers[data_in[7:4]] <= registers[data_in[11:8]] >> 1;
        end
        4'b1110: begin
           if(register[data_in[11:8]] > register[data_in[7:4]]) begin
                result = 0010100100;
           end else if (register[data_in[11:8]] < register[data_in[7:4]]) begin
                result = 0000000001;
           end else begin
                result = 0000001010;
           end
        end
        4'b1111: begin
            result = 0000000000;
        end





endmodule