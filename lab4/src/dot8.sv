/***************************************************/
/* ECE 327: Digital Hardware Systems - Spring 2025 */
/* Lab 4                                           */
/* 8-Lane Dot Product Module                       */
/***************************************************/

module dot8 # (
    parameter IWIDTH = 8,
    parameter OWIDTH = 32
)(
    input clk,
    input rst,
    input signed [8*IWIDTH-1:0] vec0,
    input signed [8*IWIDTH-1:0] vec1,
    input ivalid,
    output signed [OWIDTH-1:0] result,
    output ovalid
);

/******* Your code starts here *******/

//Input registers
logic signed [IWIDTH-1:0] r_a[7:0];
logic signed [IWIDTH-1:0] r_b[7:0];

//Stage 1 multiply registers
logic signed [2*IWIDTH-1:0] r_product[7:0];

//Stage 2 add registers
logic signed [2*IWIDTH:0] r_sum1[3:0];

//Stage 3 add registers
logic signed [2*IWIDTH+1:0] r_sum2[1:0];

//Output registers
logic signed [2*IWIDTH+2:0] r_output;

//Valid registers
logic r_valid[4:0];

always_ff @ (posedge clk) begin
    if(rst) begin
        //Reset registers
        r_a[0] <= 0; r_a[1] <= 0; r_a[2] <= 0; r_a[3] <= 0; r_a[4] <= 0; r_a[5] <= 0; r_a[6] <= 0; r_a[7] <= 0;
        r_b[0] <= 0; r_b[1] <= 0; r_b[2] <= 0; r_b[3] <= 0; r_b[4] <= 0; r_b[5] <= 0; r_b[6] <= 0; r_b[7] <= 0;
        
        r_product[0] <= 0; r_product[1] <= 0; r_product[2] <= 0; r_product[3] <= 0; r_product[4] <= 0; r_product[5] <= 0; r_product[6] <= 0; r_product[7] <= 0;
        
        r_sum1[0] <= 0; r_sum1[1] <= 0; r_sum1[2] <= 0; r_sum1[3] <= 0;
        
        r_sum2[0] <= 0; r_sum2[1] <= 0;
        
        r_output <= 0;
        
        r_valid[0] <= 0; r_valid[1] <= 0; r_valid[2] <= 0; r_valid[3] <= 0; r_valid[4] <= 0;
        
    end else begin
        //Input registers
        r_a[0] <= vec0[(1)*IWIDTH-1:0*IWIDTH];
        r_a[1] <= vec0[(2)*IWIDTH-1:1*IWIDTH];
        r_a[2] <= vec0[(3)*IWIDTH-1:2*IWIDTH];
        r_a[3] <= vec0[(4)*IWIDTH-1:3*IWIDTH];
        r_a[4] <= vec0[(5)*IWIDTH-1:4*IWIDTH];
        r_a[5] <= vec0[(6)*IWIDTH-1:5*IWIDTH];
        r_a[6] <= vec0[(7)*IWIDTH-1:6*IWIDTH];
        r_a[7] <= vec0[(8)*IWIDTH-1:7*IWIDTH];
        r_b[0] <= vec1[(1)*IWIDTH-1:0*IWIDTH];
        r_b[1] <= vec1[(2)*IWIDTH-1:1*IWIDTH];
        r_b[2] <= vec1[(3)*IWIDTH-1:2*IWIDTH];
        r_b[3] <= vec1[(4)*IWIDTH-1:3*IWIDTH];
        r_b[4] <= vec1[(5)*IWIDTH-1:4*IWIDTH];
        r_b[5] <= vec1[(6)*IWIDTH-1:5*IWIDTH];
        r_b[6] <= vec1[(7)*IWIDTH-1:6*IWIDTH];
        r_b[7] <= vec1[(8)*IWIDTH-1:7*IWIDTH];
        r_valid[0] <= ivalid;
        
        //Stage 1 multiply
        r_product[0] <= r_a[0] * r_b[0];
        r_product[1] <= r_a[1] * r_b[1];
        r_product[2] <= r_a[2] * r_b[2];
        r_product[3] <= r_a[3] * r_b[3];
        r_product[4] <= r_a[4] * r_b[4];
        r_product[5] <= r_a[5] * r_b[5];
        r_product[6] <= r_a[6] * r_b[6];
        r_product[7] <= r_a[7] * r_b[7];
        r_valid[1] <= r_valid[0];
        
        //Stage 2 add
        r_sum1[0] <= r_product[0] + r_product[1];
        r_sum1[1] <= r_product[2] + r_product[3];
        r_sum1[2] <= r_product[4] + r_product[5];
        r_sum1[3] <= r_product[6] + r_product[7];
        r_valid[2] <= r_valid[1];
        
        //Stage 3 add
        r_sum2[0] <= r_sum1[0] + r_sum1[1];
        r_sum2[1] <= r_sum1[2] + r_sum1[3];
        r_valid[3] <= r_valid[2];
        
        //Output
        r_output <= r_sum2[0] + r_sum2[1];
        r_valid[4] <= r_valid[3];
        
    end
end

assign ovalid = r_valid[4];
assign result = r_output;
/******* Your code ends here ********/

endmodule