    module alu (
        input clk,
        input[15:0] data_in,
        input btnc,
        output reg[7:0] result
    );
    reg[7:0] registers[15:0];
    reg[7:0] ram[255:0];
    // debouncer  kaynak : https://www.youtube.com/watch?v=2dgFvj3WwXk    
    reg [1:0] state_reg, state_next;
    parameter s0 = 0, s1 = 1, s2 = 2, s3 = 3;

    // debouncer degiskenleri
    reg [21:0] timer_reg;
    wire timer_done;
    wire timer_reset;
    wire btn_pulsed;
    
    always @(posedge clk) begin
        state_reg <= state_next;
        
        if (timer_reset)
            timer_reg <= 0;
        else
            timer_reg <= timer_reg + 1;
    end

   // 20ms delay debouncer
    assign timer_done = (timer_reg == 21'd2000000);

    // debouncer durum diyagrami
    always @(*) begin
        state_next = state_reg; 
        
        case (state_reg)
            s0: if (~btnc)
                    state_next = s0;
                else if (btnc)
                    state_next = s1;
                    
            s1: if (~btnc)
                    state_next = s0;
                else if (btnc & ~timer_done)
                    state_next = s1;
                else if (btnc & timer_done)
                    state_next = s2;
                    
            s2: if (~btnc)
                    state_next = s3;
                else if (btnc)
                    state_next = s2;
                    
            s3: if (btnc)
                    state_next = s2;
                else if (~btnc & ~timer_done)
                    state_next = s3;
                else if (~btnc & timer_done)
                    state_next = s0;
                    
            default: state_next = s0;
        endcase
    end

   
    assign timer_reset = (state_reg == s0 && state_next == s1) || (state_reg == s2 && state_next == s3);

    assign btn_pulsed = (state_reg == s1 && state_next == s2);

    // ALU islemleri
    always @(posedge clk) begin
        if (btn_pulsed) begin
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
    end

endmodule 
