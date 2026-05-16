    module alu (
        input[15:0] data_in,
        input btnc,
        output reg[7:0] result
    );
        reg[7:0] registers[15:0];
        reg[7:0] ram[255:0];

    always @(posedge btnc) begin
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
                result <= registers[data_in[11:8]] - 1;
            end
            4'b1000: begin
                registers[data_in[3:0]] <= registers[data_in[11:8]] & registers[data_in[7:4]];
                result <= registers[data_in[11:8]] & registers[data_in[7:4]];
            end
            4'b1001: begin
                registers[data_in[3:0]] <= registers[data_in[11:8]] | registers[data_in[7:4]];
                result <= registers[data_in[11:8]] | registers[data_in[7:4]];
            end
            4'b1010: begin  
                registers[data_in[3:0]] <= registers[data_in[11:8]] ^ registers[data_in[7:4]];
                result <= registers[data_in[11:8]] ^ registers[data_in[7:4]];
            end
            4'b1011: begin
                registers[data_in[7:4]] <= ~registers[data_in[11:8]];
                result <= ~registers[data_in[11:8]];
            end
            4'b1100: begin
                registers[data_in[7:4]] <= registers[data_in[11:8]] << 1;
                result <= registers[data_in[11:8]] << 1;
            end
            4'b1101: begin
                registers[data_in[7:4]] <= registers[data_in[11:8]] >> 1;
                result <= registers[data_in[11:8]] >> 1;
            end
            4'b1110: begin
            if(registers[data_in[11:8]] > registers[data_in[7:4]]) begin
                    result <= 8'b01100100;
            end else if (registers[data_in[11:8]] < registers[data_in[7:4]]) begin
                    result <= 8'b00000001;
            end else begin
                    result <= 8'b00001010;
            end
            end
            4'b1111: begin
                result <= 8'b00000000;
            end
            default : begin
                result <= 8'b00000000;
            end
        endcase
    end

endmodule