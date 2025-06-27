/***************************************************/
/* ECE 327: Digital Hardware Systems - Spring 2025 */
/* Lab 1 - Part 3                                  */
/* Shift-Left, Add, Subract ALU module             */
/***************************************************/

module alu # (
    parameter DATAW = 2 // Bitwidth of ALU operands
)(
    input  clk,                   // Input clock signal
    input  [DATAW-1:0] i_dataa,   // First operand (A)
    input  [DATAW-1:0] i_datab,   // Second operand (B)
    input  [1:0] i_op,            // Operation code (00: reset, 01: A << B, 10: A + B, 11: A - B)
    output [2*DATAW-1:0] o_result // ALU output
);

// Remember that you are required to register all inputs and outputs of the ALU and use 
// the adder/subtractor module you implemented in Part 2 of this lab.

/******* Your code starts here *******/
logic [DATAW-1:0] dataa;
logic [DATAW-1:0] datab;
logic [1:0] op;
logic [DATAW:0] res;
logic [2*DATAW-1:0] o;

//Uses the LSB of i_op to determine add(0) or sub(1) for dataa and datab
//Output of submodule constantly stored in wire res
add_sub #(DATAW) alu_inst(.i_dataa(dataa), .i_datab(datab), .i_op(op[0]), .o_result(res));
always_ff @ (posedge clk) begin
	dataa <= i_dataa;
	datab <= i_datab;
	op <= i_op;
    case(op)
        //if i_op is 0, output 0
        2'b00: begin
            o <= 0;
        end
        //if i_op is 1, output dataa shifted left by datab
        2'b01: begin  
            o <= dataa << datab;
        end
        default: begin
        //if i_op is 2 or 3, output the result of the add_sub module(res)
        //Performs sign extension by duplicating the MSB of res to keep the two's complement format
            o <= {{(DATAW-1){res[DATAW]}}, res};
        end
    endcase
end

assign o_result = o;
/******* Your code ends here ********/

endmodule
