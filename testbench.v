module testbench;

    //reg[7:0] registers[15:0];
    //reg[7:0] ram[255:0];
    reg[15:0] userInput;
    reg[7:0] result

    reg btnc;

    integer status; // how many items scanf read

    alu my_alu(
        .data_in(userInput),
        .btnc(btnc),
        .result(result)
    );

    initial begin

        btnc = 0;

        while(1) begin

            $display("Enter Input (or CTRL+C to stop):");
            
            status = $scanf("%b", userInput);

            if(status != 1) begin
                $display("Invalid input, stopping.");
                $finish;
            end

            btnc = 1; // activate alu

            #5;

            $display("Result: %d", result);
        
            btnc = 0; // reset alu activation
        end
    end
endmodule