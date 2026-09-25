// i wnat to call the test.v module here
module main(
    input A,
    input B,
    input Cin,
    output Sum,
    output Carry
);
full_adder FA1 (
    .A(A),
    .B(B),
    .Cin(Cin),
    .Sum(Sum),
    .Carry(Carry)
);

endmodule