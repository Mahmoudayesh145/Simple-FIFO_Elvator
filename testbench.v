module testbench ;

    reg A, B, Cin;
    wire Sum, Carry;

    test UUT (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Carry(Carry)
    );

    initial begin
        // Initialize inputs
        A = 0; B = 0; Cin = 0;

        #10; // Wait for 10 time units

        // Test case 1: A=0, B=0, Cin=0
        A = 0; B = 0; Cin = 0;
        #10;

        // Test case 2: A=0, B=1, Cin=0
        A = 0; B = 1; Cin = 0;
        #10;

        // Test case 3: A=1, B=0, Cin=0
        A = 1; B = 0; Cin = 0;
        #10;

        // Test case 4: A=1, B=1, Cin=0
        A = 1; B = 1; Cin = 0;
        #10;

        // Test case 5: A=0, B=0, Cin=1
        A = 0; B = 0; Cin = 1;
        #10;

        // Test case 6: A=0, B=1, Cin=1
        A = 0; B = 1; Cin = 1;
        #10;

        // Test case 7: A=1, B=0, Cin=1
        A = 1; B = 0; Cin = 1;
        #10;

        // Test case 8: A=1, B=1, Cin=1
        A = 1; B = 1; Cin = 1;
        #10;

    end
endmodule