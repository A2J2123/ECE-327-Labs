/***************************************************/
/* ECE 327: Digital Hardware Systems - Spring 2025 */
/* Lab 3                                           */
/* Hyperbolic Tangent (Tanh) circuit               */
/***************************************************/

module tanh (
    input  clk,         // Input clock signal
    input  rst,         // Active-high reset signal
    // Input interface
    input  [13:0] i_x,  // Input value x
    input  i_valid,     // Input value x is valid
    output o_ready,     // Circuit is ready to accept an input
    // Output interface 
    output [13:0] o_fx, // Output result f(x)
    output o_valid,     // Output result f(x) is valid
    input  i_ready      // Downstream circuit is ready to accept an input
);

// Local parameters to define the Taylor coefficients
localparam signed [13:0] A0 = 14'b11101010101011; // a0 = -0.33349609375
localparam signed [13:0] A1 = 14'b00001000100010; // a1 =  0.13330078125
localparam signed [13:0] A2 = 14'b11111100100011; // a2 = -0.05419921875
localparam signed [13:0] A3 = 14'b00000001011001; // a3 =  0.021484375
localparam signed [13:0] A4 = 14'b11111111011100; // a4 = -0.0087890625


/******* Your code starts here *******/
function automatic logic signed [13:0] multiply (input logic signed [13:0] x, input logic signed [13:0] y);
    logic signed [27:0] z;
    z = x * y; multiply = z[25:12];
endfunction

//Input registers
logic signed [13:0] r_x; logic r_valid;
//Stage 1 registers
logic signed [13:0] r_fx1; logic r_valid1;
logic signed [13:0] r_x1;
//Stage 2 registers
logic signed [13:0] r_fx2; logic r_valid2;
logic signed [13:0] r_x2; logic signed [13:0] r_xsq2;
//Stage 3 registers
logic signed [13:0] r_fx3; logic r_valid3;
logic signed [13:0] r_x3; logic signed [13:0] r_xsq3;
//Stage 4 registers
logic signed [13:0] r_fx4; logic r_valid4;
logic signed [13:0] r_x4; logic signed [13:0] r_xsq4;
//Stage 5 registers
logic signed [13:0] r_fx5; logic r_valid5;
logic signed [13:0] r_x5; logic signed [13:0] r_xsq5;
//Stage 6 registers
logic signed [13:0] r_fx6; logic r_valid6;
logic signed [13:0] r_x6; logic signed [13:0] r_xsq6;
//Stage 7 registers
logic signed [13:0] r_fx7; logic r_valid7;
logic signed [13:0] r_x7; logic signed [13:0] r_xsq7;
//Stage 8 registers
logic signed [13:0] r_fx8; logic r_valid8;
logic signed [13:0] r_x8; logic signed [13:0] r_xsq8;
//Stage 9 registers
logic signed [13:0] r_fx9; logic r_valid9;
logic signed [13:0] r_x9; logic signed [13:0] r_xsq9;
//Stage 10 registers
logic signed [13:0] r_fx10; logic r_valid10;
logic signed [13:0] r_x10;
//Stage 11 registers
logic signed [13:0] r_fx11; logic r_valid11;
logic signed [13:0] r_x11;
//Output registers
logic signed [13:0] r_fx; logic r_o_valid;

always_ff @ (posedge clk) begin
    if (rst) begin
        r_x <=0; r_valid <= 0; 
        r_fx1 <= 0; r_x1 <= 0; r_valid1 <= 0;
        r_fx2 <= 0; r_x2 <= 0; r_valid2 <= 0; r_xsq2 <= 0;
        r_fx3 <= 0; r_x3 <= 0; r_valid3 <= 0; r_xsq3 <= 0;
        r_fx4 <= 0; r_x4 <= 0; r_valid4 <= 0; r_xsq4 <= 0;
        r_fx5 <= 0; r_x5 <= 0; r_valid5 <= 0; r_xsq5 <= 0;
        r_fx6 <= 0; r_x6 <= 0; r_valid6 <= 0; r_xsq6 <= 0;
        r_fx7 <= 0; r_x7 <= 0; r_valid7 <= 0; r_xsq7 <= 0;
        r_fx8 <= 0; r_x8 <= 0; r_valid8 <= 0; r_xsq8 <= 0;
        r_fx9 <= 0; r_x9 <= 0; r_valid9 <= 0; r_xsq9 <= 0;
        r_fx10 <= 0; r_x10 <= 0; r_valid10 <= 0;
        r_fx11 <= 0; r_x11 <= 0; r_valid11 <= 0;
        r_fx <= 0; r_o_valid <= 0;
    end else if (i_ready) begin
        //Input registers
        r_x <= i_x;
        r_valid <= i_valid;
        //Stage 1 registers
        r_x1 <= r_x;
        r_valid1 <= r_valid;
        r_fx1 <= multiply(r_x, r_x);
        //Stage 2 registers
        r_x2 <= r_x1;
        r_valid2 <= r_valid1;
        r_xsq2 <= r_fx1;
        r_fx2 <= multiply(r_fx1, A4);
        //Stage 3 registers
        r_x3 <= r_x2;
        r_valid3 <= r_valid2;
        r_xsq3 <= r_xsq2;
        r_fx3 <= (r_fx2 + A3);
        //Stage 4 registers
        r_x4 <= r_x3;
        r_valid4 <= r_valid3;
        r_xsq4 <= r_xsq3;
        r_fx4 <= multiply(r_fx3, r_xsq3);
        //Stage 5 registers
        r_x5 <= r_x4;
        r_valid5 <= r_valid4;
        r_xsq5 <= r_xsq4;
        r_fx5 <= (r_fx4 + A2);
        //Stage 6 registers
        r_x6 <= r_x5;
        r_valid6 <= r_valid5;
        r_xsq6 <= r_xsq5;
        r_fx6 <= multiply(r_fx5, r_xsq5);
        //Stage 7 registers
        r_x7 <= r_x6;
        r_valid7 <= r_valid6;
        r_xsq7 <= r_xsq6;
        r_fx7 <= (r_fx6 + A1);
        //Stage 8 registers
        r_x8 <= r_x7;
        r_valid8 <= r_valid7;
        r_xsq8 <= r_xsq7;
        r_fx8 <= multiply(r_fx7, r_xsq7);
        //Stage 9 registers
        r_x9 <= r_x8;
        r_valid9 <= r_valid8;
        r_xsq9 <= r_xsq8;
        r_fx9 <= (r_fx8 + A0);
        //Stage 10 registers
        r_x10 <= r_x9;
        r_valid10 <= r_valid9;
        r_fx10 <= multiply(r_fx9, r_xsq9);
        //Stage 11 registers
        r_x11 <= r_x10;
        r_valid11 <= r_valid10;
        r_fx11 <= multiply(r_fx10, r_x10);
        //Output registers
        r_fx <= (r_fx11 + r_x11);
        r_o_valid <= r_valid11;
    end
end

assign o_ready = i_ready;
assign o_valid = r_o_valid;
assign o_fx = r_fx;
/******* Your code ends here ********/

endmodule