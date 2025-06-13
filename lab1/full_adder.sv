/***************************************************/
/* ECE 327: Digital Hardware Systems - Spring 2025 */
/* Lab 1 - Part 1                                  */
/* Full adder module                               */
/***************************************************/

module full_adder (
    input a,    // First operand bit
    input b,    // Second operand bit
    input cin,  // Input Carry bit
    output s,   // Output sum bit
    output cout // Output carry bit
);

/******* Your code starts here *******/
// Module to add 2 1-bit numbers with a carry-in bit.
logic o0, o1;

always_comb begin
    o0 <= cin^(a^b);
    o1 <= (cin&(a|b)) | (a&b);
end

assign s = o0;
assign cout = o1;
/******* Your code ends here ********/

endmodule
