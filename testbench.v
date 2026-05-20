`timescale 1ns / 1ps

module testbench(
    input clk,
    input  [15:0] data_in,
    input btnc,
    output [6:0] seg,
    output [3:0] r_an
);
    wire [7:0] alu_result;

    alu uut (
        .clk(clk),
        .data_in(data_in),
        .btnc(btnc),
        .result(alu_result)
    );
    wire is_negative;
    wire [7:0] alu_result_unsigned;
    assign is_negative = alu_result[7];
    assign alu_result_unsigned = is_negative ? (~alu_result + 1) : alu_result;

    wire [3:0] bcd_ones;
    wire [3:0] bcd_tens;
    wire [3:0] bcd_hundreds;

    assign bcd_ones     = alu_result_unsigned % 10;
    assign bcd_tens     = (alu_result_unsigned / 10) % 10;
    assign bcd_hundreds = alu_result_unsigned / 100;

    // displayleri birlikte calistirmak icin refresh counter trick'i
    reg [17:0] refresh_counter = 0;
    
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end
    
    wire [1:0] active_display = refresh_counter[17:16];
    
    reg [3:0] hex_digit;
    reg [3:0] an_reg;
    reg is_minus;
    always @(*) begin
        is_minus = 1'b0;
        case(active_display)
            2'b00: begin
                an_reg = 4'b1110;    
                if(data_in[15:12] == 4'b1110) begin 
                    if(alu_result == 8'b00000001) hex_digit = 4'h1;
                    else hex_digit = 4'h0;
                end           
                else begin 
                    hex_digit = bcd_ones;         
                end
            end
            2'b01: begin
                an_reg = 4'b1101;      
                if(data_in[15:12] == 4'b1110) begin
                    if(alu_result == 8'b00001010) hex_digit = 4'h1;
                    else hex_digit = 4'h0;
                end           
                else begin
                    hex_digit = bcd_tens;
                end     
            end
            2'b10: begin
                an_reg = 4'b1011;   
                if(data_in[15:12] == 4'b1110) begin // eger compare durumu var ise soldan 2.display e ozel bir durum gosterme
                    if(alu_result == 8'b01100100) hex_digit = 4'h1;
                    else hex_digit = 4'h0;
                end        
                else begin    
                    hex_digit = bcd_hundreds;            
                end     
            end
            2'b11: begin
                if(is_negative) begin
                    an_reg = 4'b0111; 
                    is_minus = 1'b1;
                    hex_digit = 4'h0; 
                end
                else begin
                    an_reg = 4'b1111;
                    hex_digit = 4'h0;
                end
            end
        endcase
    end
    
    assign r_an = an_reg;

    reg [6:0] seg_reg;
    always @(*) begin
        if(is_minus) begin
            seg_reg = 7'b0111111; 
        end
        else begin
        case(hex_digit)
            4'h0: seg_reg = 7'b1000000; // 0
            4'h1: seg_reg = 7'b1111001; // 1
            4'h2: seg_reg = 7'b0100100; // 2
            4'h3: seg_reg = 7'b0110000; // 3
            4'h4: seg_reg = 7'b0011001; // 4
            4'h5: seg_reg = 7'b0010010; // 5
            4'h6: seg_reg = 7'b0000010; // 6
            4'h7: seg_reg = 7'b1111000; // 7
            4'h8: seg_reg = 7'b0000000; // 8
            4'h9: seg_reg = 7'b0010000; // 9
            4'hA: seg_reg = 7'b0001000; // a
            4'hB: seg_reg = 7'b0000011; // b
            4'hC: seg_reg = 7'b1000110; // c
            4'hD: seg_reg = 7'b0100001; // d
            4'hE: seg_reg = 7'b0000110; // e
            4'hF: seg_reg = 7'b0001110; // f
            default: seg_reg = 7'b1111111; 
        endcase
        end
    end

    assign seg = seg_reg;

endmodule

module alu_tb;
    reg clk;
    reg [15:0] data_in;
    reg btnc;

    wire [6:0] seg;
    wire [3:0] r_an;

    testbench uut_top (
        .clk(clk),
        .data_in(data_in),
        .btnc(btnc),
        .seg(seg),
        .r_an(r_an)
    );

    always #5 clk = ~clk;

    task pulse_btn;
        begin
            btnc = 1'b1;
            #25000000;
            btnc = 1'b0;
            #25000000;
        end
    endtask

    initial begin
        clk = 1'b0;
        btnc = 1'b0;
        data_in = 16'h0000;
        #100;

        data_in = 16'b0000_0000_00000101;
        pulse_btn();

        data_in = 16'b0000_0001_00000011;
        pulse_btn();

        data_in = 16'b0100_0000_0001_0010;
        pulse_btn();

        data_in = 16'b1110_0000_0001_0000;
        pulse_btn();

        #10000000;
        $finish;
    end
endmodule