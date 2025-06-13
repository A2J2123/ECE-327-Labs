/***************************************************/
/* ECE 327: Digital Hardware Systems - Spring 2025 */
/* Lab 1 - Part 2                                  */
/* Multi-bit adder/subtractor module               */
/***************************************************/

module add_sub # (
    parameter DATAW = 2 // Bitwidth of adder/subtractor operands
)(
    input [DATAW-1:0] i_dataa, // First operand (A)
    input [DATAW-1:0] i_datab, // Second operand (B)
    input i_op,                // Operation (0: A+B, 1: A-B)
    output [DATAW:0] o_result  // Addition/Subtraction result
);

/******* Your code starts here *******/
// Module to add 2 N-bit numbers using the full_adder submodule.
logic [DATAW:0] res;
logic [DATAW:0] carry;
assign carry[0] = i_op;

genvar i;
generate
for (i = 0; i < DATAW; i = i+1)
begin: gen_adders
    full_adder add_inst(.a(i_dataa[i]), .b((i_datab[i]^i_op)), .cin(carry[i]), .s(res[i]), .cout(carry[i+1]));
end
endgenerate

full_adder add_final(.a(i_dataa[DATAW-1]), .b((i_datab[DATAW-1]^i_op)), .cin(carry[DATAW]), .s(res[DATAW]), .cout());
assign o_result = res;
/******* Your code ends here ********/

endmodule
