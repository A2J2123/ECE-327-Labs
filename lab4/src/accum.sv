/***************************************************/
/* ECE 327: Digital Hardware Systems - Spring 2025 */
/* Lab 4                                           */
/* Accumulator Module                              */
/***************************************************/

module accum # (
    parameter DATAW = 32,
    parameter ACCUMW = 32
)(
    input  clk,
    input  rst,
    input  signed [DATAW-1:0] data,
    input  ivalid,
    input  first,
    input  last,
    output signed [ACCUMW-1:0] result,
    output ovalid
);

/******* Your code starts here *******/
// Input register
logic r_valid;
logic signed [ACCUMW-1:0] r_result;

always_ff @ (posedge clk) begin
    if (rst) begin
        r_valid <= 0;
        r_result <= 0;
    end else if (ivalid) begin
        if (first && last) begin
            r_result <= data;
            r_valid <= 1;
        end else if (first) begin
            r_result <= data;
            r_valid <= 0;
        end else if (last) begin
            r_result <= r_result + data;
            r_valid <= 1;
        end else begin
            r_result <= r_result + data;
        end
    end
end

assign ovalid = r_valid;
assign result = r_result;
/******* Your code ends here ********/

endmodule