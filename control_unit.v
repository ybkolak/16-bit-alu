module control_unit (
    input[15:0] data_in,
    output[3:0] ra,
    output[3:0] rb,
    output[3:0] rd,
    output[7:0] w,
    output[7:0] ram_addr,
    output[3:0] reg_addr,
);


always @(data_in) begin
    case(data_in[15:12])
        4'b0000 : begin
            w <= data_in[7:0];
            rd <= w;
            reg_addr <= data_in[11:8];
        end



endmodule